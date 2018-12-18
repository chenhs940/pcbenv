axlCmdRegister("NoMount" 'NoMount ?cmdType "general")

defun(NoMount ()
let((MinX MinY MaxY MaxX Dn nCSMark)
	Dn = axlMKSConvert(0.2 "mm" car(axlDBGetDesignUnits()))
	NoMount_Popup = axlUIPopupDefine(nil list(
		list("Done" 'NoMount_Done) 
		list("Oops" 'NoMount_Undo)
		list("Cancel" 'NoMount_Cancel)
		list("Next" 'NoMount_Next))
	)
	axlUIPopupSet(NoMount_Popup)
	;----鼠标右键-----
	axlClearSelSet()
	axlSetFindFilter(?enabled '("NOALL" "SYMBOLS") ?onButtons '("ALLTYPES"))
	
	nCSMark = axlDBTransactionStart()    ;------设置返回点-------
	while(axlSelect()
		axlDBTransactionMark(nCSMark)
		
		foreach(n0 axlGetSelSet()
			MinX = nil
			MinY = nil
			MaxX = nil
			MaxY = nil
			foreach(n1 n0->pins
				unless(MinX MinX = car(car(n1->bBox)))
				MinX = min(MinX car(car(n1->bBox)))
				MinX = min(MinX car(cadr(n1->bBox)))
				unless(MinY MinY = cadr(car(n1->bBox)))
				MinY = min(MinY cadr(car(n1->bBox)))
				MinY = min(MinY cadr(cadr(n1->bBox)))
				
				unless(MaxX MaxX = car(car(n1->bBox)))
				MaxX = max(MaxX car(car(n1->bBox)))
				MaxX = max(MaxX car(cadr(n1->bBox)))
				unless(MaxY MaxY = cadr(car(n1->bBox)))
				MaxY = max(MaxY cadr(car(n1->bBox)))
				MaxY = max(MaxY cadr(cadr(n1->bBox)))
			)
			axlDBCreateLine(list(list(MinX MinY) list(MaxX MaxY)) 
				Dn "BOARD GEOMETRY/SILKSCREEN_TOP" nil nil
			)
			axlDBCreateLine(list(list(MinX MaxY) list(MaxX MinY)) 
				Dn "BOARD GEOMETRY/SILKSCREEN_TOP" nil nil
			)
			foreach(n1 n0->children
				if(n1->objType == "text" && n1->layer == "REF DES/SILKSCREEN_TOP" then
					axlDBCreateLine(n1->bBox 
						Dn "REF DES/SILKSCREEN_TOP" nil nil
					)
				)
			)
		)
	)
	nCSMark = 'unbound
	t
)
)

defun(NoMount_Done ()
let(()
	
	axlDBTransactionCommit(nCSMark)
	axlCancelEnterFun()
)
)

defun(NoMount_Undo ()
let(()
	axlDBTransactionOops(nCSMark)
)
)

defun(NoMount_Cancel ()
let(()
	axlDBTransactionRollback(nCSMark)
	axlClearSelSet()
	axlCancelEnterFun()

)
)

defun(NoMount_Next ()
let(()
	axlDBTransactionCommit(nCSMark)
	axlClearSelSet()
)
)
