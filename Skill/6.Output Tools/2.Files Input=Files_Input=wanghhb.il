axlCmdRegister("Files_Input" 'Files_Input ?cmdType "general")

defun(Files_Input ()
let((Inputform File_Dxf)
	
	axlLayerCreateNonConductor("BOARD GEOMETRY/DXF_FILE")
	axlVisibleLayer("BOARD GEOMETRY/DXF_FILE" t)
	Inputform = axlFormCreate((gensym) strcat(FormPath "LD_Files_Input.form") nil 'Files_Input_Action t)
	axlFormDisplay(Inputform)
	axlFormAutoResize(Inputform)
	Inputform_Int()

)
)

;--------------------line转成outline----------------

defun(Inputform_Int ()
let(()
	axlFormSetField(Inputform "Input4" "20")
	axlFormSetField(Inputform "Input5" "30")
	
)
)



;--------------------form返回函数----------------
defun(Files_Input_Action (Inputform)
let((PlaceFile File_Dxf Path_Netlist Path_XRF N_KeepIN N_KeepOut)
	case(Inputform->curField
		("FileButton1"
			PlaceFile = axlDMFileBrowse("ALLEGRO_DXF" nil)
			when(PlaceFile
				if(substring(PlaceFile strlen(PlaceFile)-3 strlen(PlaceFile)) == ".dxf" then
					axlFormSetField(Inputform "Input1" PlaceFile)
				)
			)
		)
		
		("FileButton2"
			PlaceFile = axlDMDirectoryBrowse("." nil)
			axlFormSetField(Inputform "Input2" PlaceFile)
		)
	
		("FileButton3"
			PlaceFile = axlDMFileBrowse(nil nil ?optFilters "XRF Files(*.XRF)|*.XRF|")
			axlFormSetField(Inputform "Input3" PlaceFile)
		)
	
		("ImportButton"
			File_Dxf = axlOSSlash(axlFormGetField(Inputform "Input1"))
			Path_Netlist = axlOSSlash(axlFormGetField(Inputform "Input2"))
			Path_XRF = axlOSSlash(axlFormGetField(Inputform "Input3"))
			N_KeepIN = axlOSSlash(axlFormGetField(Inputform "Input4"))
			N_KeepOut = axlOSSlash(axlFormGetField(Inputform "Input5"))
			when(File_Dxf != "" 
				Clean_Dxflayer()
				Input_Dxffile(File_Dxf)
				;printf("----------------\321\241\324\361\322\252\261\344\263\311Outline\265\304\317\337-----------------")
				axlUIConfirm("\321\241\324\361\322\252\261\344\263\311Outline\265\304\317\337")
				ComShapeDxf()
				AddRouteKeep()
				axlShell("
					save;
					fillin yes;
				")
			)
			
			when(Path_Netlist != "" 
				Input_Netlist()
				axlShell("
					save;
					fillin yes;
				")
			)
			when(Path_XRF != "" 
				;println(Path_XRF)
				Page_Playce(Path_XRF)
			)
		)
	)
)
)
;--------------------line转成outline----------------
defun(ComShapeDxf ()
let(()
	axlShell("
		setwindow pcb;
		trapsize 0;
		setwindow pcb;
		compose shape;
		setwindow form.mini;
		FORM mini class BOARD GEOMETRY;
		FORM mini subclass OUTLINE;
		FORM mini subcolor 1 ;
		setwindow form.find;
		FORM find all_off  ;
		FORM find lines YES ;
		FORM find shapes YES ;
	")
)
)
;--------------------导入网表----------------
defun(Input_Netlist ()
let((Out_Port)

	Out_Port = outfile("./scr_file.scr")
	fprintf( Out_Port "version 16.3\n" )
	fprintf( Out_Port "\n" )
	fprintf( Out_Port "setwindow pcb\n" )
	fprintf( Out_Port "trapsize 0\n" )
	fprintf( Out_Port "placementedit\n" )
	fprintf( Out_Port "netin \n" )
	fprintf( Out_Port "setwindow form.niparams\n" )
	fprintf( Out_Port "FORM niparams capture_netlist YES \n" )
	fprintf( Out_Port "FORM niparams browse\n" )
	fprintf( Out_Port "fillin %s\n" Path_Netlist)
	fprintf( Out_Port "FORM niparams import\n" )
	close( Out_Port )
	
	axlShell( "replay ./scr_file.scr" )
	deleteFile( "./scr_file.scr" )

)
)


;--------------------清理DXF_FILE层线----------------
defun(Clean_Dxflayer ()
let((VisList)
	VisList = axlVisibleGet()	
	axlVisibleDesign(nil)
	axlVisibleLayer("BOARD GEOMETRY/DXF_FILE" t)
	;axlVisibleLayer("BOARD GEOMETRY/OUTLINE" t)
	axlSetFindFilter(?enabled '("NOALL" "SHAPES" "LINES") ?onButtons '("ALLTYPES"))
	axlAddSelectAll()
	axlDeleteObject(axlGetSelSet() 'ripup)
	axlClearSelSet()
	axlVisibleSet(VisList)
	axlVisibleUpdate(nil)
)
)

;--------------------导入Dxf到DXF_FILE层----------------
defun(Input_Dxffile (S_FilesPath)
let((FilesIN FilesOut_Cnv FilesOut_Scr N_line layer_list)
	unless(axlLayerGet("BOARD GEOMETRY/DXF_FILE")
		axlLayerCreateNonConductor("BOARD GEOMETRY/DXF_FILE")
	)
	unless(axlLayerGet("BOARD GEOMETRY/TPLAYER")
		axlLayerCreateNonConductor("BOARD GEOMETRY/TPLAYER")
	)
	
	FilesIN = infile(S_FilesPath)
	N_line = 0
	layer_list = '()
	when( FilesIN
		while(gets(one FilesIN)
			when(one == "AcDbLayerTableRecord\n" 
				N_line = 0
			)
			when(N_line == 2
				layer_list = append1(layer_list car(parseString(one "\n")))
			)
			N_line++
		)
	)
	layer_list = cdr(layer_list)
	close(FilesIN)
	
	FilesOut_Cnv = outfile("./CnvFile_Temp.cnv")
	fprintf( FilesOut_Cnv "#This is the Layer Conversion File used for\n")
	fprintf( FilesOut_Cnv "#importing DXF data into Allegro/APD.\n")
	fprintf( FilesOut_Cnv "#CLASS!            SUBCLASS!                 DXF_LAYER!\n")
	fprintf( FilesOut_Cnv "BOARD GEOMETRY!\n")
	foreach(n0 layer_list
		case(upperCase(n0)
			;("OUTLINE" 	fprintf( FilesOut_Cnv "                   OUTLINE!                  %s!\n" n0) )
			;("TPLAYER" 	fprintf( FilesOut_Cnv "                   TPLAYER!                  %s!\n" n0) )
			(t 					fprintf( FilesOut_Cnv "                   DXF_FILE!                 %s!\n" n0) )
		)
	)
	fprintf( FilesOut_Cnv "\n#END")
	close(FilesOut_Cnv)	
	
	FilesOut_Scr = outfile("./ScrFile_Temp.scr")
	fprintf( FilesOut_Scr "version 16.3\n")
	fprintf( FilesOut_Scr "\n")
	fprintf( FilesOut_Scr "setwindow pcb\n")
	fprintf( FilesOut_Scr "trapsize 0\n")
	fprintf( FilesOut_Scr "dxf in \n")
	fprintf( FilesOut_Scr "setwindow form.dxfInMain\n")
	fprintf( FilesOut_Scr "FORM dxfInMain browsedxf\n")
	fprintf( FilesOut_Scr "fillin %s\n" S_FilesPath)
	fprintf( FilesOut_Scr "FORM dxfInMain units MM \n")
	fprintf( FilesOut_Scr "FORM dxfInMain incremental YES\n")
	fprintf( FilesOut_Scr "fillin yes\n")
	fprintf( FilesOut_Scr "FORM dxfInMain browselyrcnv\n")
	fprintf( FilesOut_Scr "fillin %s\n" "CnvFile_Temp.cnv")
	fprintf( FilesOut_Scr "FORM dxfInMain import\n")
	fprintf( FilesOut_Scr "setwindow form.dxfInMain\n")
	fprintf( FilesOut_Scr "FORM dxfInMain cancel\n")
	close(FilesOut_Scr)	
	
	axlShell("replay ./ScrFile_Temp.scr")
	deleteFile("./CnvFile_Temp.cnv")
	deleteFile("./ScrFile_Temp.scr")
	axlVisibleLayer("BOARD GEOMETRY/DXF_FILE" t)
	axlVisibleLayer("BOARD GEOMETRY/TPLAYER" t)
)
)







;--------------------------按页布局---------------------------

defun(Page_Playce (S_XRFPath)
let((pgfile SymXY line_lst refdes_name)
	List_Expt = list(4 9 16 25 36 49 64 81 100)
	pgFile = infile(S_XRFPath)
	when(pgFile
		while(gets(nextline pgFile)
			line_lst = parseString(nextline "\t")
			when(atoi(car(line_lst))
				refdes_name = nth(2 line_lst)
				page_no = nth(4 line_lst)
				;println(refdes_name)
				;println(page_no)
				foreach(n0 List_Expt
					
				)
				
				
			
			)
			;if( length(line_lst) == 8 then
			;	refdes_name = nth(2 line_lst)
			;	page_no = nth(4 line_lst)
				
				/*
				if(page_no=="1" then
					println(refdes_name)
					axlClearSelSet()
					axlSetFindFilter(?enabled '("noall" "alltypes" "nameform") ?onButtons "alltypes")
					axlSingleSelectName( "component" refdes_name)
					X0 = axlMKSConvert(atof(nth(6 line_lst)) "mm" car(axlDBGetDesignUnits()))*1.5
					Y0 = -(axlMKSConvert(atof(nth(7 line_lst)) "mm" car(axlDBGetDesignUnits()))*1.5)
					println(list(atof(nth(6 line_lst)) atof(nth(7 line_lst))))
					axlDBIgnoreFixed(t)
				)
				*/
				
			;)
		)
	)
	close(pgFile)
	axlClearSelSet()
)
)

;--------------------增加Route Keep----------------

defun(AddRouteKeep ()
let((List_Shape EOID)
	when(N_KeepIN == "" 
		N_KeepIN = axlUIPrompt("\312\344\310\353Route Keepin ( mil ) ")
	)
	when(N_KeepOut == "" 
		N_KeepOut = axlUIPrompt("\312\344\310\353Route KeepOut ( mil ) ")
	)
	N_KeepIN = axlMKSConvert(atof(N_KeepIN) "mil" car(axlDBGetDesignUnits()))
	N_KeepOut = axlMKSConvert(atof(N_KeepOut) "mil" car(axlDBGetDesignUnits()))
	axlVisibleDesign(nil)
	axlVisibleLayer("BOARD GEOMETRY/OUTLINE" t)
	axlSetFindFilter(?enabled '("NOALL" "SHAPES") ?onButtons '("ALLTYPES"))
	axlAddSelectAll()
	List_Shape = axlGetSelSet()
	axlClearSelSet()
	EOID = nil
	foreach(n0 List_Shape
		if(n0->bBox == axlExtentDB() then
			List_Shape = remove(n0 List_Shape)
			EOID = n0
		)
	)
	when(EOID
		EOIDPoly = car(axlPolyExpand(car(axlPolyFromDB(EOID)) -N_KeepIN 'NONE))
		axlDBCreateShape(EOIDPoly nil "ROUTE KEEPIN/ALL")
		foreach(n0 List_Shape
			EOIDPoly = car(axlPolyExpand(car(axlPolyFromDB(n0)) N_KeepOut 'NONE))
			axlDBCreateShape(EOIDPoly t "ROUTE KEEPOUT/ALL")
		)
	)
	axlVisibleLayer("ROUTE KEEPOUT/ALL" t)
	axlVisibleLayer("ROUTE KEEPIN/ALL" t)
)
)