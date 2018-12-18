

axlCmdRegister("Centre_Text" 'Centre_Text ?cmdType "general")

defun(Centre_Text ()
prog((Centre_Text_Popup SeleLayer deta_Dis nCSMark Vis_Temp)
	Centre_Text_Popup = axlUIPopupDefine(nil list(
		list("Done" 'Centre_Text_Done) 
		list("Oops" 'Centre_Text_Undo)
		list("Cancel" 'Centre_Text_Cancel)
		list("Next" 'Centre_Text_Next)
	))
	axlUIPopupSet(Centre_Text_Popup)
	SeleLayer = list("REF DES/SILKSCREEN_TOP" "BOARD GEOMETRY/OUTLINE" "PIN/TOP" 
		"PACKAGE GEOMETRY/SILKSCREEN_TOP"
	)
	VisableLayer(SeleLayer)
	
	Define_Text()
	deta_Dis = axlMKSConvert(0.2 "mm" car(axlDBGetDesignUnits()))
	Vis_Temp = list("COMPONENT VALUE/ASSEMBLY_TOP" "COMPONENT VALUE/ASSEMBLY_BOTTOM" 
		"REF DES/ASSEMBLY_TOP" "REF DES/ASSEMBLY_BOTTOM" "COMPONENT VALUE/SILKSCREEN_TOP" 
		"COMPONENT VALUE/SILKSCREEN_BOTTOM" "REF DES/SILKSCREEN_TOP" "REF DES/SILKSCREEN_BOTTOM"
	)
	
	axlControlRaise('options)
	Centre_Value_form = axlMiniStatusLoad(
		(gensym) strcat(FormPath "Centre_Value.form") 'Centre_Value_callBack t
	)
	;Centre_Value_form = axlFormCreate((gensym) strcat(FormPath "Centre_Value.form") nil 'Centre_Value_callBack t t)
	axlFormSetField(Centre_Value_form "Ref_Top" t)
	;axlFormDisplay(Centre_Value_form)
	axlSetFindFilter(?enabled '("NOALL" "SYMBOLS") ?onButtons '("ALLTYPES"))
	nCSMark = axlDBTransactionStart()
	while(axlSelect()
		axlDBTransactionMark(nCSMark)
		foreach(n0 axlGetSelSet() 
			foreach(n1 n0->children
				if(car(SeleLayer) == n1->layer then
					if(rexMatchp("^TP[0-9]" n0->refdes) 
						&& rexMatchp("^COMPONENT VALUE/SILKSCREEN_+" n1->layer) then
						axlDeleteObject(n1 'ripup)
					else
						Centre_Text_Action(n1 n0)
					)
				)
			)
		)
	)
	nCSMark = 'unbound
	
)
)

defun(VisableLayer (l_layer)
let(()
	axlVisibleDesign(nil)
	foreach(n0 l_layer
		axlVisibleLayer(n0 t)
	)	
	axlVisibleUpdate(nil)
)
)


defun(Define_Text ()
let((TextBlock1 TextBlock2)
	while((axlGetParam("paramTextBlock:1")->width && axlGetParam("paramTextBlock:2")->width) == nil	
		Scr_Port = outfile("./scr_file.scr")
		fprintf( Scr_Port "version 16.3\n")
		fprintf( Scr_Port "prmed\n")
		fprintf( Scr_Port "FORM prmedit text \n")
		fprintf( Scr_Port "FORM prmedit text_setup_button\n" )
		fprintf( Scr_Port "FORM textblock add  \n" )
		fprintf( Scr_Port "FORM textblock done \n" )
		fprintf( Scr_Port "FORM prmedit done  \n")
		close( Scr_Port )
		axlShell( "replay ./scr_file.scr" )
		deleteFile( "./scr_file.scr" )		
	)
	TextBlock1 = axlGetParam("paramTextBlock:1")
	TextBlock2 = axlGetParam("paramTextBlock:2")
	;println(TextBlock1)
	TextBlock1->width = 16.0
	TextBlock1->height = 25.0
	TextBlock1->lineSpace = 31.0
	TextBlock1->photoWidth = 5.0
	TextBlock1->charSpace = 6.0
	TextBlock2->width = 11.81
	TextBlock2->height = 15.75
	TextBlock2->lineSpace = 0.0
	TextBlock2->photoWidth = 0.0
	TextBlock2->charSpace = 0.0
	axlSetParam(TextBlock1)
	axlSetParam(TextBlock2)
)
)



defun(Centre_Value_callBack (Centre_Value_form)
let((ComID deta_Rot myorient)
	case(Centre_Value_form->curField
		("Ref_Top"
			if(Centre_Value_form->curValueInt == 1 then
				SeleLayer = list("REF DES/SILKSCREEN_TOP" "BOARD GEOMETRY/OUTLINE" "PIN/TOP" 
					"PACKAGE GEOMETRY/SILKSCREEN_TOP"
				)
				VisableLayer(SeleLayer)
			)
		)
		("Ref_Bottom"
			if(Centre_Value_form->curValueInt == 1 then
				SeleLayer = list("REF DES/SILKSCREEN_BOTTOM" "BOARD GEOMETRY/OUTLINE" 
					"PIN/BOTTOM" "PACKAGE GEOMETRY/SILKSCREEN_BOTTOM"
				)
				VisableLayer(SeleLayer)
			)
		)
		("Value_Top"
			if(Centre_Value_form->curValueInt == 1 then
				SeleLayer = list("COMPONENT VALUE/SILKSCREEN_TOP" "BOARD GEOMETRY/OUTLINE" 
					"PACKAGE GEOMETRY/SILKSCREEN_TOP"
				)
				VisableLayer(SeleLayer)
			)	
		)
		("Value_Bottom"
			if(Centre_Value_form->curValueInt == 1 then
				SeleLayer = list("COMPONENT VALUE/SILKSCREEN_BOTTOM" "BOARD GEOMETRY/OUTLINE" 
					"PACKAGE GEOMETRY/SILKSCREEN_BOTTOM"
				)
				VisableLayer(SeleLayer)
			)
		)
	)
)
)


defun(Centre_Text_Action (TextID SymID)
prog((myorient)
	case(SymID->rotation
		((0.0 180.0) axlTransformObject(TextID ?move axlMXYSub(axlMXYSub(SymID->xy TextID->xy) list(0 deta_Dis)) ?angle -(TextID->rotation)))
		((90.0 270.0)
			if(SymID->isMirrored then
				axlTransformObject(TextID ?move axlMXYSub(axlMXYSub(SymID->xy TextID->xy) list(deta_Dis 0)) ?angle 270-(TextID->rotation))
			else
				axlTransformObject(TextID ?move axlMXYSub(axlMXYSub(SymID->xy TextID->xy) list(-deta_Dis 0)) ?angle 90-(TextID->rotation))
			)
		)
	)
	myorient = axlTextOrientationCopy(TextID)
	myorient->justify = "center"
	if(rexMatchp("^REF DES/SILKSCREEN_+" TextID->layer) then
		myorient->textBlock = "1"
	else
		myorient->textBlock = "2"
	)
	myorient->mirrored  = SymID->isMirrored
	axlDBChangeText(TextID nil myorient)
	;if(rexMatchp("^TEST P*" TextID->text) then
	;	axlDeleteObject(TextID)
	;)

)
)

defun(Centre_Text_Done ()
prog(()
	axlDBTransactionCommit(nCSMark)
	axlCancelEnterFun()
	t
)
)


defun(Centre_Text_Undo ()
prog(()
	axlDBTransactionOops(nCSMark)
	t
)
)


defun(Centre_Text_Cancel ()
prog(()
	axlDBTransactionRollback(nCSMark)
	axlClearSelSet()
	axlCancelEnterFun()
	t
)
)


defun(Centre_Text_Next ()
prog(()
	axlDBTransactionCommit(nCSMark)
	axlClearSelSet()
	t
)
)

