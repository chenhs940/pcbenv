
axlCmdRegister("MeshLayout" 'MeshLayout); ?cmdType "interactive" ?doneCmd 'MeshLayoutDone ?cancelCmd 'MeshLayoutCancel
               
procedure(MeshLayout()
prog((MeshSq_120 rMeshLayoutPopup nCSMark)
	/*
  MeshSq120 = '(MeshSq_120_list
		MeshSq120_A (			
			((0 15) (5 15) (5 115) (115 115) (115 25) (45 25) (45 75) (75 75) (75 55) (85 55) (85 85) (35 85) (35 15) (120 15))
			((0 5) (15 5) (15 105) (105 105) (105 35) (55 35) (55 65) (65 65) (65 45) (95 45) (95 95) (25 95) (25 5) (120 5))
		)
		MeshSq120_12 (
			((15 120) (15 85) (65 85) (65 115) (115 115) (115 5) (45 5) (45 45) (75 45) (75 35) (85 35) (85 55) (35 55) (35 5) (15 5) (15 0))
			((5 120) (5 25) (15 25) (15 75) (75 75) (75 105) (105 105) (105 15) (55 15) (55 35) (65 35) (65 25) (95 25) (95 95) (85 95) (85 65) (25 65) (25 15) (5 15) (5 0))
		)
		MeshSq120_15 (
			((5 120) (5 105) (105 105) (105 15) (35 15) (35 25) (95 25) (95 95) (35 95) (35 65) (65 65) (65 55) (5 55) (5 0))
			((15 120) (15 115) (115 115) (115 5) (25 5) (25 35) (85 35) (85 85) (45 85) (45 75) (75 75) (75 45) (15 45) (15 0)))
		MeshSq120_23 (
			((5 120) (5 75) (95 75) (95 105) (105 105) (105 65) (85 65) (85 15) (75 15) (75 65) (45 65) (45 15) (35 15) (35 65) (5 65) (5 0))
			((15 120) (15 85) (85 85) (85 115) (115 115) (115 5) (105 5) (105 55) (95 55) (95 5) (65 5) (65 55) (55 55) (55 5) (25 5) (25 55) (15 55) (15 0))
		)
	)
	MeshSq_60 = '(MeshSq_60_list
		MeshSq_60A (
			((60 15) (35 15) (35 25) (55 25) (55 55) (5 55) (5 15) (0 15))
			((60 5) (25 5) (25 35) (45 35) (45 45) (15 45) (15 5) (0 5))
		)
	)
	
	
	;unless(axlOKToProceed()
  ;  axlUIConfirm("Please Finish current command!")  
	;	return(nil)
  ;)
  */
  
  
  axlVisibleDesign(nil)
  Vislist = list("ROUTE KEEPOUT/ALL" "ROUTE KEEPIN/ALL" "VIA CLASS/TOP" "ETCH/TOP" "ETCH/BOTTOM" "BOARD GEOMETRY/DIMENSION" "BOARD GEOMETRY/OUTLINE")
  foreach(n0 Vislist
  	axlVisibleLayer(n0 t)
  )
  ;--------鼠标-----------
	rMeshLayoutPopup = axlUIPopupDefine(nil list(
		  list("Done" 'MeshLayoutDone) 
			list("Oops" 'MeshLayoutUndo) 
			list("Cancel" 'MeshLayoutCancel)
		)
	)
  axlUIPopupSet(rMeshLayoutPopup)
  
  ;--------鼠标-----------
  ;nCSMark = axlDBTransactionStart()
	;axlSetFindFilter(?enabled '("noall" "shapes" "vias") ?onButtons '("noall" "shapes"))
  ;when(axlSelect()
  	;axlDBTransactionMark(nCSMark)
		MeshLayoutArea()
		MeshLayoutSQ()
  ;)
  ;nCSMark = 'unbound
)
)




procedure(MeshLayoutArea()
	prog((lSelBox tRectLayer dRectCut LayoutPoly lSelectShapes)
		tRectLayer = "BOARD GEOMETRY/DIMENSION"
		lSelBox = axlEnterBox()
		when(lSelBox			
			dRectCut = car(axlDBCreateRectangle(lSelBox nil tRectLayer nil nil))
			LayoutPoly = axlPolyFromDB(dRectCut)      ;获取选择的多边形
			when(dRectCut
				axlDeleteObject(dRectCut)    ;删除shape
			)
			axlSetFindFilter(?enabled '("noall" "shapes" "vias") ?onButtons '("noall" "shapes" "vias"))  ;选择控制
			axlSingleSelectBox(lSelBox)
			lSelectShapes = axlGetSelSet()
			axlClearSelSet()
			foreach(n0 lSelectShapes
				cond(
					(n0->objType == "via"
						LayoutPoly = axlPolyOperation(LayoutPoly axlPolyFromDB(n0) 'ANDNOT)
					)
					(rexMatchp("^ROUTE KEEPIN*" n0->layer)
						LayoutPoly = axlPolyOperation(LayoutPoly axlPolyFromDB(n0) 'AND)
					)
					(rexMatchp("^ROUTE KEEPOUT*" n0->layer)
						LayoutPoly = axlPolyOperation(LayoutPoly axlPolyFromDB(n0) 'ANDNOT)
					)
				)
				;LayoutPoly为mesh可走线区域。
			)
			layoutShape = axlDBCreateOpenShape(car(LayoutPoly) t tRectLayer nil nil)
			axlDBCreateCloseShape(layoutShape)
		)
	)
)


defun(MeshLayoutSQ ()
let(()
	println(layoutShape->bBox)
	println(axlMXYSub(lastelem(layoutShape->bBox) car(layoutShape->bBox)))
	;println(car(layoutShape->bBox))
	;println(last(layoutShape->bBox))
)
)




/*
;---------鼠标--------
procedure(MeshLayoutUndo()
	let(()
		axlDBTransactionOops(nCSMark)
		axlClearSelSet()
	)
)

procedure(MeshLayoutDone()
	let(()
		axlDBTransactionCommit(nCSMark)
		axlCancelEnterFun()
		;gc()
	)
)


procedure(MeshLayoutCancel()
	let(()
		axlDBTransactionRollback(nCSMark)
		;bCSDoFlag = nil
		axlClearSelSet()
		axlCancelEnterFun()
		;gc()
	)
)

*/

/*
procedure(AddSquare(Poly_LayoutPoly Int_ExptNumber)
let((KK X0 Y0 X1 Y1 dx dy TT TTPoint LayoutPolySurp SquarebPath SquareID SquarePoly)
	;LayoutPolySurp = Poly_LayoutPoly
	KK = 2**Int_ExptNumber*30
	when(KK >= 30 
		X0 = fix(car(car(Poly_LayoutPoly->bBox))/KK)
		Y0 = fix(cadr(car(Poly_LayoutPoly->bBox))/KK)
		X1 = ceiling(car(cadr(Poly_LayoutPoly->bBox))/KK)
		Y1 = ceiling(cadr(cadr(Poly_LayoutPoly->bBox))/KK)
		dx = 0;car(car(Poly_LayoutPoly->bBox))-X0
		dy = 0;cadr(car(Poly_LayoutPoly->bBox))-Y0
		for(i X0 X1
			for(j Y0 Y1
				SquarebPath = list(list(KK*i+dx KK*j+dy) list(KK*i+KK+dx KK*j+dy) list(KK*i+KK+dx KK*j+KK+dy) list(KK*i+dx KK*j+KK+dy) list(KK*i+dx KK*j+dy))
				TTPoint = list(KK*i+dx KK*j+dy)
				SquarePoly = axlPolyFromDB(axlPathStart(SquarebPath 0))
				TT = axlPolyOperation(Poly_LayoutPoly SquarePoly 'AND)
				;println(TT)
				if(SquarePoly == TT then
					SquareID = car(axlDBCreateShape(car(SquarePoly) nil tRectLayer nil nil))
					case(KK
						(120 
							AddMesh_Sq("ETCH/TOP" MeshSq120->MeshSq120_A TTPoint nil -90)
						)
						(60
							t;AddMesh_Sq("ETCH/TOP" MeshSq_60->MeshSq_60A TTPoint nil 0)
						)
					)
					;ListSquareID = cons(SquareID ListSquareID)
				else
					when(! member(nil TT)
						AddSquare(car(TT) Int_ExptNumber-1)
					)
				)
			)
		)
	)
	;ListSquareID
)
)



procedure(AddMesh_Sq(String_layer list_SqPath Point_xy Bool_mirror f_angle)
let((TL MeshSq Inlayer Base_xy)
	Inlayer = String_layer
	Mainlayer = car(parseString(String_layer "/"))
	when(Bool_mirror
		Inlayer = strcat(Mainlayer "/" nth(length(member(cadr(parseString(String_layer "/")) axlSubclasses(Mainlayer)))-1 axlSubclasses(Mainlayer)))
	)
	Base_xy = axlMXYSub(car(axlExtentDB()) list(axlMKSConvert(120 "mil" car(axlDBGetDesignUnits())) 0))
	MeshSq = '()
	foreach(n0 list_SqPath
		TL = nil
		foreach(n1 n0
			TL = cons(axlMXYAdd(n1 Base_xy) TL)
		)
		MeshSq = cons(caar(axlDBCreateLine(TL 5 Inlayer nil nil)) MeshSq)
	)
	axlCopyObject(MeshSq ?move axlMXYSub(Point_xy Base_xy) ?mirror Bool_mirror ?angle f_angle)
	axlDeleteObject(MeshSq)
	
)
)

*/