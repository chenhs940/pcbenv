axlCmdRegister("TP_XY_Checking" 'TP_XY_Checking)



defun(TP_XY_Checking ()
		
	TP_XY_Checking_form = axlFormCreate((gensym) strcat(FormPath "TP_XY_Checking.form") nil 'TP_XY_Checking_Form_callBack nil t)
	
	axlUIWPerm(TP_XY_Checking_form nil)
	axlFormAutoResize(TP_XY_Checking_form)	
	axlFormDisplay(TP_XY_Checking_form)
	
)

defun(TP_XY_Checking_Form_callBack (TP_XY_Checking_form)
	prog( (PlaceFile TPOneID PlaceFile_Input KK n_Error TPSymbolID Dx Dy Dref ErrorOne)
		Dref = axlMKSConvert(0.001 "mm" car(axlDBGetDesignUnits()))
    case(TP_XY_Checking_form->curField
			("FileButton"
				PlaceFile = axlDMFileBrowse("ALLEGRO_LAYOUT_DB" nil)
				when(substring(PlaceFile strlen(PlaceFile)-3 strlen(PlaceFile)) == ".brd"
					axlFormSetField(TP_XY_Checking_form "Input1" PlaceFile)
					;axlOpenDesign(?design PlaceFile ?mode "wf")
					;axlKillDesign()
				)
      )
      
			("CheckButton"
				axlFormListSelAll(TP_XY_Checking_form "ErrorList" t)
				List_Sel_Items = axlFormListGetSelItems(TP_XY_Checking_form "ErrorList")
				axlFormListDeleteItem(TP_XY_Checking_form "ErrorList" List_Sel_Items)
				List_Error = '()
				TPSymbolID = axlSelectByName("SYMTYPE" "TP*" t)
				PlaceFile_Input = infile(axlOSSlash(axlFormGetField(TP_XY_Checking_form "Input1")))
				when(PlaceFile_Input					
					while(gets(n0 PlaceFile_Input)
						KK = parseString(n0)
						if(car(KK) == "UUNITS" && nth(2 KK) != upperCase(car(axlDBGetDesignUnits())) then
							close(PlaceFile_Input)
							ErrorOne = list(nil "\301\275brd\316\304\274\376\265\245\316\273\262\273\315\263\322\273")
							List_Error = append1(List_Error ErrorOne)
						else
							when(car(KK) != "UUNITS" && rexMatchp("^TP*" car(KK))
								TPOneID = car(axlSelectByName("COMPONENT" car(KK)))->symbol
								TPSymbolID = remd(TPOneID TPSymbolID)
								if(TPOneID then
									Dx = abs(atof(nth(1 KK))-car(TPOneID->xy))
									Dy = abs(atof(nth(2 KK))-cadr(TPOneID->xy))
									when(Dx > Dref && Dy > Dref
										if(TPOneID->isMirrored then
											Vis_Temp = list("BOARD GEOMETRY/OUTLINE" "PACKAGE GEOMETRY/SILKSCREEN_BOTTOM" "PIN/BOTTOM")
										else
											Vis_Temp = list("BOARD GEOMETRY/OUTLINE" "PACKAGE GEOMETRY/SILKSCREEN_TOP" "PIN/TOP")
										)
										ErrorOne = list(car(TPOneID->pins) concat(TPOneID->refdes "\316\273\326\303\323\320\322\306\266\257") Vis_Temp)
										List_Error = append1(List_Error ErrorOne)
									)
								else
									ErrorOne = list(nil concat("\310\245\262\342\312\324\265\343" car(KK)))
									List_Error = append1(List_Error ErrorOne)	
								)
							)
						)
					)
				)
				foreach(n0 TPSymbolID
					if(n0->isMirrored then
						Vis_Temp = list("BOARD GEOMETRY/OUTLINE" "PACKAGE GEOMETRY/SILKSCREEN_BOTTOM" "PIN/BOTTOM")
					else
						Vis_Temp = list("BOARD GEOMETRY/OUTLINE" "PACKAGE GEOMETRY/SILKSCREEN_TOP" "PIN/TOP")
					)
					ErrorOne = list(car(n0->pins) concat("\324\366\262\342\312\324\265\343" n0->refdes) Vis_Temp)
					List_Error = append1(List_Error ErrorOne)
				)
				n_Error = 1
				foreach(n0 List_Error
					axlFormListAddItem(TP_XY_Checking_form "ErrorList" concat(n_Error ": " cadr(n0)) -1)
					n_Error++
				)
				unless(List_Error
					axlFormListAddItem(TP_XY_Checking_form "ErrorList" "\262\342\312\324\265\343\316\336\322\306\266\257." -1)
				)
			)
		      
	  	("ErrorList0"
	  		for(i 0 length(List_Error)-1
	  			if(concat(car(parseString(TP_XY_Checking_form->curValue ":"))) == concat(i+1) then		
	  				axlZoomToDbid(car(nth(i List_Error)) t)
	  				axlHighlightObject(car(nth(i List_Error)))
	  				when(caddr(nth(i List_Error))
		  				axlVisibleDesign(nil)
		  				foreach(n0 caddr(nth(i List_Error))
		  					axlVisibleLayer(n0 t)		  				
		  				)
	  				)	  				
	  			else
	  				axlDehighlightObject(car(nth(i List_Error)) nil)
	  			)
	  		)
			)
    );case
    if(nequal(TP_XY_Checking_form->doneState 0) then
    	axlFormClose(TP_XY_Checking_form)
    );if
	);prog
);procedure


