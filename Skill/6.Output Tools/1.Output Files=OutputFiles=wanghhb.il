axlCmdRegister("OutputFiles" 'OutputFiles ?cmdType "general")


defun(OutputFiles ()
let(()
	DrawName = axlCurrentDesign()
	CreateForm()
	Gerberform = axlFormCreate((gensym) "Gerber.form" nil 'Gerber_Action t)
	deleteFile("./Gerber.form")
	axlFormDisplay(Gerberform)
	axlFormAutoResize(Gerberform)
	Int_Form()
)
)


defun(Gerber_Action (Gerberform)
let((Silk_En)
	case(Gerberform->curField
		("Output0"
			Silk_En = axlFormGetField(Gerberform "Silk_Set")			
			Gerber_Int(Silk_En)
			AddDrill()
			CreateGerber()
		)
		("Output1"
			OutFiles_WJG()
		)
		("Output2"
			Output_IDFfile(DrawName)
		)
	)
	FileManager()
)
)


defun(Int_Form ()
let(()
	axlFormSetField(Gerberform "Silk_Set" 1)
)
)



defun(CreateForm ()
let((FormFile)
	FormFile = outfile("./Gerber.form")
	fprintf( FormFile "FILE_TYPE=FORM_DEFN VERSION=2\n")
	fprintf( FormFile "FORM\n")
	fprintf( FormFile "FIXED\n")
	fprintf( FormFile "PORT 50 6\n")
	fprintf( FormFile "HEADER \"\312\344\263\366\271\244\276\337\"\n")
	fprintf( FormFile "\n")
	fprintf( FormFile "TILE\n")
	fprintf( FormFile "\n")
	fprintf( FormFile "FIELD Silk_Set\n")
	fprintf( FormFile "FLOC 5 3\n")
	fprintf( FormFile "CHECKLIST \"\313\277\323\241\260\374\272\254\316\273\272\305\" \n")
	fprintf( FormFile "ENDFIELD\n")
	fprintf( FormFile "\n")
	fprintf( FormFile "GROUP \"Gerber\312\344\263\366\"\n")
	fprintf( FormFile "GLOC 1 0\n")
	fprintf( FormFile "GSIZE 33 6\n")
	fprintf( FormFile "ENDGROUP\n")
	fprintf( FormFile "\n")
	fprintf( FormFile "GROUP \"\315\342\274\323\271\244\316\304\274\376\312\344\263\366\"\n")
	fprintf( FormFile "GLOC 1 7\n")
	fprintf( FormFile "GSIZE 33 6\n")
	fprintf( FormFile "ENDGROUP\n")
	fprintf( FormFile "\n")
	fprintf( FormFile "GROUP \"3D\316\304\274\376\312\344\263\366\"\n")
	fprintf( FormFile "GLOC 1 14\n")
	fprintf( FormFile "GSIZE 33 6\n")
	fprintf( FormFile "ENDGROUP\n")
	fprintf( FormFile "\n")
	fprintf( FormFile "FIELD Output0\n")
	fprintf( FormFile "FLOC 21 3\n")
	fprintf( FormFile "MENUBUTTON \"\265\274\263\366\" 9 3\n")
	fprintf( FormFile "ENDFIELD\n")
	fprintf( FormFile "\n")
	fprintf( FormFile "FIELD Output1\n")
	fprintf( FormFile "FLOC 21 10\n")
	fprintf( FormFile "MENUBUTTON \"\265\274\263\366\" 9 3\n")
	fprintf( FormFile "ENDFIELD\n")
	fprintf( FormFile "\n")
	fprintf( FormFile "FIELD Output2\n")
	fprintf( FormFile "FLOC 21 17\n")
	fprintf( FormFile "MENUBUTTON \"\265\274\263\366\" 9 3\n")
	fprintf( FormFile "ENDFIELD\n")
	fprintf( FormFile "\n")
	fprintf( FormFile "ENDTILE\n")
	fprintf( FormFile "ENDFORM\n")
	
	close(FormFile)

)
)


defun(CreateGerber ()
let((Scr_Port)	
	Scr_Port = outfile("./scr_file.scr")
	fprintf( Scr_Port "version 16.3\n")	
	fprintf( Scr_Port "\n")
	
	fprintf( Scr_Port "artwork \n")	
	fprintf( Scr_Port "FORM film_control apertures  \n")
	fprintf( Scr_Port "setwindow form.apt_wheels\n")
	fprintf( Scr_Port "FORM apt_wheels 1 delete  \n")
	fprintf( Scr_Port "FORM apt_wheels add_wheel  \n")
	fprintf( Scr_Port "FORM apt_wheels 1 edit\n")
	fprintf( Scr_Port "setwindow form.apt_stations\n")
	fprintf( Scr_Port "FORM apt_stations auto With Rotation \n")
	fprintf( Scr_Port "FORM apt_stations sort By Station \n")
	fprintf( Scr_Port "FORM apt_stations apt_done  \n")
	fprintf( Scr_Port "setwindow form.apt_wheels\n")
	fprintf( Scr_Port "FORM apt_wheels done\n")
	
	fprintf( Scr_Port "FORM film_control film_control  \n")
	fprintf( Scr_Port "FORM film_control select_all  \n")
	fprintf( Scr_Port "FORM film_control database_check YES \n")	
	fprintf( Scr_Port "FORM film_control create  \n")
	fprintf( Scr_Port "FORM film_control ok\n")	
	
	fprintf( Scr_Port "ncdrill customization \n")
	fprintf( Scr_Port "generaledit \n")
	fprintf( Scr_Port "setwindow form.nc_drillcustomization\n")
	fprintf( Scr_Port "FORM nc_drillcustomization auto_symbols  \n")
	fprintf( Scr_Port "fillin yes \n")
	fprintf( Scr_Port "FORM nc_drillcustomization done  \n")
	fprintf( Scr_Port "fillin yes \n")
	
	fprintf( Scr_Port "nctape_full\n")
	fprintf( Scr_Port "setwindow form.nc_drill\n")
	fprintf( Scr_Port "FORM nc_drill execute  \n")
	fprintf( Scr_Port "FORM nc_drill close  \n")
	
	fprintf( Scr_Port "ncroute\n")
	fprintf( Scr_Port "setwindow form.nc_route\n")
	fprintf( Scr_Port "FORM nc_route execute\n")
	fprintf( Scr_Port "FORM nc_route close\n")
	
	close( Scr_Port )
	axlShell( "replay ./scr_file.scr" )
	deleteFile( "./scr_file.scr" )
)
)


defun(AddDrill ()
let((bBoxXY dertar Dx Dy VisList NCID Scr_Port)
	VisList = axlVisibleGet()
	axlVisibleDesign(nil)	
	foreach(n0 axlSubclasses("MANUFACTURING")
		if(rexMatchp("^NCLEGEND+" n0) then
			axlVisibleLayer(strcat("MANUFACTURING/" n0) t)
		)
	)
	axlSetFindFilter(
		?enabled '("NOALL" "SHAPES" "LINES" "TEXT" "FIGURES") 
		?onButtons '("ALLTYPES")
	)
	axlAddSelectAll()
	NCID = axlGetSelSet()
	axlClearSelSet()
	foreach(n0 NCID
		axlDeleteObject(n0 'ripup)
	)
	axlVisibleSet(VisList)
	axlVisibleUpdate(nil)
	Dx = caadr(axlExtentDB())
	dertar = axlMKSConvert(20 "mm" car(axlDBGetDesignUnits()))
	Dx = Dx+dertar
	Dy = lastelem(cadr(axlExtentDB()))
	Scr_Port = outfile("./scr_file.scr")
	fprintf( Scr_Port "version 16.3\n")
	fprintf( Scr_Port "ncdrill legend \n")
	fprintf( Scr_Port "setwindow form.nc_drilllegend\n")
	fprintf( Scr_Port "FORM nc_drilllegend done \n" )
	fprintf( Scr_Port "setwindow pcb\n" )
	fprintf( Scr_Port "pick grid %f %f\n" Dx Dy)
	fprintf( Scr_Port "generaledit  \n")
	close( Scr_Port )
	axlShell( "replay ./scr_file.scr" )
	deleteFile( "./scr_file.scr" )
	
)
)


;-----
defun(Gerber_Int (t_Silk)
let((EtchList NcList Scr_Port SilkList)
	;É¾²ã	
	axlDeleteObject(axlGetParam("artwork"))
	
	;Í­Æ¤²ã
	foreach(n0 axlSubclasses("ETCH")
		EtchList = list("BOARD GEOMETRY/OUTLINE" 
			strcat("ETCH/" n0) 
			strcat("PIN/" n0) 
			strcat("VIA CLASS/" n0)
		)
		axlfcreate(n0  '(0 0 0 500 10000 1 0 0 0 0 0 0 1) EtchList)
	)
	
	;×ê¿×	
	foreach(n0 axlSubclasses("MANUFACTURING")
		if(rexMatchp("^NCLEGEND+" n0) then
			NcList = append1(NcList strcat("MANUFACTURING/" n0))
		)
	)
	NcList = append(NcList 
		'(
			"BOARD GEOMETRY/OUTLINE" 
			"BOARD GEOMETRY/DIMENSION" 
			"MANUFACTURING/NCDRILL_LEGEND" 
			"MANUFACTURING/NCDRILL_FIGURE"
		)
	)
	axlfcreate("DRILL"  '(0 0 0 500 10000 1 0 0 0 0 0 0 1) NcList)
	
	;Æ´°åÍ¼
	when(axlIsLayer("BOARD GEOMETRY/PANEL")
		axlfcreate(
			"PANEL"
			'(0 0 0 500 10000 1 0 0 0 0 0 0 1) 
			'("BOARD GEOMETRY/PANEL")
		)
	)
	
	;°×ÓÍ
	SilkList = '("BOARD GEOMETRY/OUTLINE"  
		"PACKAGE GEOMETRY/SILKSCREEN_TOP" "BOARD GEOMETRY/SILKSCREEN_TOP"
	)
	when(t_Silk
		SilkList = append(SilkList '("REF DES/SILKSCREEN_TOP"))
	)
	axlfcreate(
		"SILK_TOP" 
		'(0 0 0 500 10000 1 0 0 0 0 0 0 1) 
		SilkList
	)
	
	SilkList = '("BOARD GEOMETRY/OUTLINE"  
		"PACKAGE GEOMETRY/SILKSCREEN_BOTTOM" "BOARD GEOMETRY/SILKSCREEN_BOTTOM"
	)
	when(t_Silk
		SilkList = append(SilkList '("REF DES/SILKSCREEN_BOTTOM"))
	)
	axlfcreate(
		"SILK_BOTTOM" 
		'(0 0 0 500 10000 1 0 0 0 0 0 0 1) 
		SilkList
	)
	
	;¿ª´°
	axlfcreate(
		"SOLD_TOP" 
		'(0 0 0 500 10000 1 0 0 0 0 0 0 1) 
		'("BOARD GEOMETRY/OUTLINE" "PIN/SOLDERMASK_TOP" 
			"PACKAGE GEOMETRY/SOLDERMASK_TOP" "BOARD GEOMETRY/SOLDERMASK_TOP"
		)
	)
	axlfcreate(
		"SOLD_BOTTOM"  
		'(0 0 0 500 10000 1 0 0 0 0 0 0 1)
		'("BOARD GEOMETRY/OUTLINE" "PIN/SOLDERMASK_BOTTOM" 
		"PACKAGE GEOMETRY/SOLDERMASK_BOTTOM" "BOARD GEOMETRY/SOLDERMASK_BOTTOM")
	)
	
	;¸ÖÍø
	axlfcreate(
		"PAST_TOP"
		'(0 0 0 500 10000 1 0 0 0 0 0 0 1) 
		'("BOARD GEOMETRY/OUTLINE" "PIN/PASTEMASK_TOP" 
		"PACKAGE GEOMETRY/PASTEMASK_TOP")
	)
	axlfcreate(
		"PAST_BOTTOM"  
		'(0 0 0 500 10000 1 0 0 0 0 0 0 1) 
		'("BOARD GEOMETRY/OUTLINE" "PIN/PASTEMASK_BOTTOM" 
		"PACKAGE GEOMETRY/PASTEMASK_BOTTOM")
	)
	
	Scr_Port = outfile("./art_param.txt")
	fprintf( Scr_Port "DEVICE-TYPE           GERBER_RS274X\n")
	fprintf( Scr_Port "OUTPUT-UNITS          INCHES\n")
	fprintf( Scr_Port "FILM-SIZE             2400000 1600000\n")
	fprintf( Scr_Port "FORMAT                5.5\n")
	fprintf( Scr_Port "ABORT-ON-ERROR        NO\n")
	fprintf( Scr_Port "SCALE                 1\n")
	fprintf( Scr_Port "SUPPRESS-LEAD-ZEROES  YES\n")
	fprintf( Scr_Port "SUPPRESS-TRAIL-ZEROES NO\n")
	fprintf( Scr_Port "SUPPRESS-EQUAL        YES\n")
	fprintf( Scr_Port "UNDEF-APT-CONT        NO\n")	
	close( Scr_Port )
	
	Scr_Port = outfile("./nc_param.txt")
	fprintf( Scr_Port "INTEGER-PLACES         2\n")
	fprintf( Scr_Port "DECIMAL-PLACES         3\n")
	fprintf( Scr_Port "X-OFFSET               0.000000\n")
	fprintf( Scr_Port "Y-OFFSET               0.000000\n")
	fprintf( Scr_Port "FEEDRATE               1\n")
	fprintf( Scr_Port "COORDINATES            ABSOLUTE\n")
	fprintf( Scr_Port "OUTPUT-UNITS           ENGLISH\n")
	fprintf( Scr_Port "TOOL-ORDER             INCREASING\n")
	fprintf( Scr_Port "REPEAT-CODES           YES\n")
	fprintf( Scr_Port "SUPPRESS-LEAD-ZEROES   YES\n")
	fprintf( Scr_Port "SUPPRESS-TRAIL-ZEROES  NO\n")
	fprintf( Scr_Port "SUPPRESS-EQUAL         NO\n")
	fprintf( Scr_Port "TOOL-SELECT            NO\n")
	fprintf( Scr_Port "OPTIMIZE_DRILLING      NO\n")
	fprintf( Scr_Port "ENHANCED_EXCELLON      YES\n")
	fprintf( Scr_Port "HEADER                 none\n")
	fprintf( Scr_Port "LEADER                 12\n")
	fprintf( Scr_Port "CODE                   ASCII\n")
	fprintf( Scr_Port "SEPARATE               NO\n")
	fprintf( Scr_Port "DRILLING               LAYER-PAIR\n")
	fprintf( Scr_Port "BACKDRILL              NO\n")
	close( Scr_Port )
	

)
)

defun(FileManager ()
let((DirName)
	createDir("Output Files")
	DirName = strcat("Output Files/" DrawName "_CAM")
	foreach(n0 getDirFiles("./")
		cond(
			(rexMatchp(".*.art$" n0) || rexMatchp(strcat("^" DrawName ".*.drl$") n0) 
				|| rexMatchp(strcat("^" DrawName ".rou$") n0) || n0 == "art_aper.txt"
				createDir(DirName)
				axlOSFileMove(n0 strcat(DirName "/" n0))
			)
			(rexMatchp(".*_param.txt$" n0)
				axlOSFileCopy(n0 strcat(DirName "/" n0) nil)
			)
			(n0 == strcat(DrawName "_placement.brd")
				|| n0 == strcat(DrawName ".emn")
				|| n0 == strcat(DrawName ".emp")
				|| n0 == strcat(DrawName "_AB.emn")
				|| n0 == strcat(DrawName "_AB.emp")
				axlOSFileMove(n0 strcat("Output Files/" n0))
			)
		)
	)
)
)


defun(OutFiles_WJG ()
let((SS VisList X0 Y0 X1 Y1 Out_Port)
	axlDeleteObject(axlDBGetDesign()->nets)
	VisList = axlVisibleGet()
	axlVisibleDesign(nil)
	axlVisibleLayer("VIA CLASS" t)
	axlVisibleLayer("ETCH" t)
	

	X0 = car(car(axlExtentDB()))
	Y0 = lastelem(car(axlExtentDB()))
	X1 = car(cadr(axlExtentDB()))
	Y1 = lastelem(cadr(axlExtentDB()))
	
	Out_Port = outfile("./scr_file.scr")
	fprintf( Out_Port "version 16.3\n")
	fprintf( Out_Port "\n")
	fprintf( Out_Port "delete\n")
	fprintf( Out_Port "setwindow form.find\n")
	fprintf( Out_Port "FORM find all_off  \n")
	fprintf( Out_Port "FORM find shapes YES \n")
	fprintf( Out_Port "FORM find clines YES \n")
	fprintf( Out_Port "FORM find vias YES \n")
	fprintf( Out_Port "drag_start %f %f\n" X0 Y0)
	fprintf( Out_Port "drag_stop %f %f\n" X1 Y1)
	fprintf( Out_Port "pick grid 0 0\n")
	fprintf( Out_Port "done\n")	
	
	close( Out_Port )	
	axlShell( "replay ./scr_file.scr" )
	deleteFile( "./scr_file.scr" )
	
	axlHighlightObject(axlDBGetDesign()->symbols)
	axlDehighlightObject(axlDBGetDesign()->symbols)
	axlVisibleSet(VisList)
	axlVisibleUpdate(nil)
	
	
	Out_Port = outfile("./scr_file.scr")
	fprintf( Out_Port "save_as\n")
	fprintf( Out_Port "fillin \"%s\"\n" strcat(DrawName "_WJG.brd"))
	fprintf( Out_Port "open\n")
	fprintf( Out_Port "fillin \"%s\"\n" strcat(DrawName ".brd"))	
	fprintf( Out_Port "OutputFiles\n")
	
	close( Out_Port )	
	axlShell( "replay ./scr_file.scr" )
	deleteFile( "./scr_file.scr" )
)
)


defun(Output_IDFfile (S_String)
let((Out_IDFConfig tt)
	if(rexMatchp(".+_AB$" S_String) then
		foreach(n0 axlDBGetDesign()->components
			unless(rexMatchp("^TP+" n0->package)
				axlDBDeleteProp(n0 "FIXED")
				axlDeleteObject(n0 'ripup)
			)
		)
	)	
	Out_IDFConfig = outfile("./iDfFilterOut.config")
	fprintf( Out_IDFConfig "( filter    Route_Keepout_sym  Route_Keepout_board    Via_Keepout_sym  Via_Keepout_board  Vias  Route_Outline  Unplaced_Comp Placed_Comp )" )
	close( Out_IDFConfig )	
	tt=strcat("idf_out %s -d PTC -o " S_String " -s \"allegro_16.3" "\"" " -b 1 -h 2000 -V 3.0 -c \"iDfFilterOut.config\"")
	axlRunBatchDBProgram("idf_out" tt)
	deleteFile( "./iDfFilterOut.config" )
	t
)
)
