procedure(TRL_ALTIUM2HDL_Callback(fid) 
    let((new_color index tmp_input org_color remaining
	    prjpcb_file file_name dir_name dest_dir schdoc_file
	    tmp
	) 
	case((fid->curField) 
	    ("map_sym_prop" 
		if((axlFormGetField fid "map_sym_prop") then 
		    (axlFormSetFieldEditable fid "s_value_l" t) 
		    (axlFormSetFieldEditable fid "sym_part_number_l" t) 
		    (axlFormSetFieldEditable fid "prop1_l" t)
		    (axlFormSetFieldEditable fid "cds_prop1_l" t) 
		    (axlFormSetFieldEditable fid "prop2_l" t) 
		    (axlFormSetFieldEditable fid "cds_prop2_l" t) else 
		    (axlFormSetFieldEditable fid "s_value_l" nil)
		    (axlFormSetFieldEditable fid "sym_part_number_l" nil) 
		    (axlFormSetFieldEditable fid "prop1_l" nil) 
		    (axlFormSetFieldEditable fid "cds_prop1_l" nil) 
		    (axlFormSetFieldEditable fid "prop2_l" nil) 
		    (axlFormSetFieldEditable fid "cds_prop2_l" nil)
		)
	    ) 
	    ("use_reference" 
		TRL_ALTIUM2HDL_Load_Reference_File() 
		when((car((trl_altium2hdl_global->Reference)) && cadr((trl_altium2hdl_global->Reference))) 
		    (axlFormSetFieldEditable fid "create_sch" t) 
		    (axlFormSetFieldEditable fid "create_symbols" nil)
		)
	    ) 
	    ("license" 
		(trl_altium2hdl_global->license = (axlFormGetField fid "license"))
	    ) 
	    ("create_reference" 
		TRL_ALTIUM2HDL_Create_Reference_File()
	    )
	    ("tree" 
		TRL_ALTIUM2HDL_Tree_Item_Action((fid->curValue))
	    ) 
	    ("con_to_cap" 
		TRL_ALTIUM2HDL_Create_OrCAD_symbols()
	    ) 
	    ("load_SchDoc" 
		TRL_ALTIUM2HDL_Load_SCHematic() 
		TRL_ALTIUM2HDL_SCH_Create_Concept_Harness_Adapter_List() 
		if((trl_altium2hdl_global->SchRawList) then 
		    (org_color = car((trl_altium2hdl_global->Global_GUI_Handling))) 
		    (remaining = cadr((trl_altium2hdl_global->Global_GUI_Handling))) 
		    (index = 1)
		    foreach(color org_color 
			if(onep(index) then 
			    (new_color = cons("green" new_color)) else 
			    (new_color = cons(color new_color))
			) 
			index++
		    ) 
		    (new_color = reverse(new_color)) 
		    (trl_altium2hdl_global->Global_GUI_Handling = list(new_color remaining)) 
		    TRL_ALTIUM2HDL_Create_Flow_Graphic() 
		    (axlFormSetFieldEditable fid "project_setup" t)
		    (axlFormTreeViewSet fid "tree" 
			'TV_REMOVEALL nil
		    ) 
		    TRL_ALTIUM2HDL_Tree_View() 
		    (axlFormTreeViewSet fid "tree" 
			'TV_NOEDITLABEL nil
		    ) else 
		    (org_color = car((trl_altium2hdl_global->Global_GUI_Handling)))
		    (remaining = cadr((trl_altium2hdl_global->Global_GUI_Handling))) 
		    (index = 1) 
		    foreach(color org_color 
			if(onep(index) then 
			    (new_color = cons("red" new_color)) else 
			    (new_color = cons(color new_color))
			) 
			index++
		    ) 
		    (new_color = reverse(new_color)) 
		    (trl_altium2hdl_global->Global_GUI_Handling = list(new_color remaining))
		    TRL_ALTIUM2HDL_Create_Flow_Graphic() 
		    (axlFormSetFieldEditable fid "project_setup" nil)
		)
	    ) 
	    ("project_setup" 
		(tmp_input = TRL_ALTIUM2HDL_SCH_Create_Project_Structure()) 
		if(tmp_input then 
		    (org_color = car((trl_altium2hdl_global->Global_GUI_Handling))) 
		    (remaining = cadr((trl_altium2hdl_global->Global_GUI_Handling))) 
		    (index = 1)
		    foreach(color org_color 
			if((index == 2) then 
			    (new_color = cons("green" new_color)) else 
			    (new_color = cons(color new_color))
			) 
			index++
		    ) 
		    (new_color = reverse(new_color)) 
		    (trl_altium2hdl_global->Global_GUI_Handling = list(new_color remaining)) 
		    TRL_ALTIUM2HDL_Create_Flow_Graphic() 
		    (axlFormSetFieldEditable fid "create_symbols" t)
		    else 
		    (org_color = car((trl_altium2hdl_global->Global_GUI_Handling))) 
		    (remaining = cadr((trl_altium2hdl_global->Global_GUI_Handling))) 
		    (index = 1) 
		    foreach(color org_color 
			if((index == 2) then 
			    (new_color = cons("red" new_color)) else 
			    (new_color = cons(color new_color))
			) 
			index++
		    )
		    (new_color = reverse(new_color)) 
		    (trl_altium2hdl_global->Global_GUI_Handling = list(new_color remaining)) 
		    TRL_ALTIUM2HDL_Create_Flow_Graphic() 
		    (axlFormSetFieldEditable fid "create_symbols" nil) 
		    (axlFormSetFieldEditable fid "create_sch" nil)
		)
	    ) 
	    ("create_symbols" 
		TRL_ALTIUM2HDL_Create_Concept_symbols() 
		(tmp_input = t) 
		if(tmp_input then 
		    (org_color = car((trl_altium2hdl_global->Global_GUI_Handling))) 
		    (remaining = cadr((trl_altium2hdl_global->Global_GUI_Handling))) 
		    (index = 1)
		    foreach(color org_color 
			if((index == 3) then 
			    (new_color = cons("green" new_color)) else 
			    (new_color = cons(color new_color))
			) 
			index++
		    ) 
		    (new_color = reverse(new_color)) 
		    (trl_altium2hdl_global->Global_GUI_Handling = list(new_color remaining)) 
		    TRL_ALTIUM2HDL_Create_Flow_Graphic() 
		    (axlFormSetFieldEditable 
			(trl_altium2hdl_global->formid) "create_sch" t
		    )
		    else 
		    (org_color = car((trl_altium2hdl_global->Global_GUI_Handling))) 
		    (remaining = cadr((trl_altium2hdl_global->Global_GUI_Handling))) 
		    (index = 1) 
		    foreach(color org_color 
			if((index == 3) then 
			    (new_color = cons("red" new_color)) else 
			    (new_color = cons(color new_color))
			) 
			index++
		    )
		    (new_color = reverse(new_color)) 
		    (trl_altium2hdl_global->Global_GUI_Handling = list(new_color remaining)) 
		    TRL_ALTIUM2HDL_Create_Flow_Graphic()
		)
	    )
	    ("create_orcad_symbols" 
		TRL_ALTIUM2HDL_Create_OrCAD_symbols() 
		(tmp_input = t) 
		if(tmp_input then 
		    (org_color = car((trl_altium2hdl_global->Global_GUI_Handling))) 
		    (remaining = cadr((trl_altium2hdl_global->Global_GUI_Handling))) 
		    (index = 1)
		    foreach(color org_color 
			if((index == 4) then 
			    (new_color = cons("green" new_color)) else 
			    (new_color = cons(color new_color))
			) 
			index++
		    ) 
		    (new_color = reverse(new_color)) 
		    (trl_altium2hdl_global->Global_GUI_Handling = list(new_color remaining)) 
		    TRL_ALTIUM2HDL_Create_Flow_Graphic() 
		    (axlFormSetFieldEditable fid "create_orcad_sch" t)
		    else 
		    (org_color = car((trl_altium2hdl_global->Global_GUI_Handling))) 
		    (remaining = cadr((trl_altium2hdl_global->Global_GUI_Handling))) 
		    (index = 1) 
		    foreach(color org_color 
			if((index == 4) then 
			    (new_color = cons("red" new_color)) else 
			    (new_color = cons(color new_color))
			) 
			index++
		    )
		    (new_color = reverse(new_color)) 
		    (trl_altium2hdl_global->Global_GUI_Handling = list(new_color remaining)) 
		    TRL_ALTIUM2HDL_Create_Flow_Graphic() 
		    (axlFormSetFieldEditable fid "create_orcad_sch" nil)
		)
	    ) 
	    ("create_sch" 
		TRL_ALTIUM2HDL_SCH_Create_Concept_Schematic() 
		(tmp_input = t) 
		if(tmp_input then 
		    (org_color = car((trl_altium2hdl_global->Global_GUI_Handling))) 
		    (remaining = cadr((trl_altium2hdl_global->Global_GUI_Handling))) 
		    (index = 1)
		    foreach(color org_color 
			if((index == 4) then 
			    (new_color = cons("green" new_color)) else 
			    (new_color = cons(color new_color))
			) 
			index++
		    ) 
		    (new_color = reverse(new_color)) 
		    (trl_altium2hdl_global->Global_GUI_Handling = list(new_color remaining)) 
		    TRL_ALTIUM2HDL_Create_Flow_Graphic() else
		    (org_color = car((trl_altium2hdl_global->Global_GUI_Handling))) 
		    (remaining = cadr((trl_altium2hdl_global->Global_GUI_Handling))) 
		    (index = 1) 
		    foreach(color org_color 
			if((index == 4) then 
			    (new_color = cons("red" new_color)) else 
			    (new_color = cons(color new_color))
			) 
			index++
		    ) 
		    (new_color = reverse(new_color))
		    (trl_altium2hdl_global->Global_GUI_Handling = list(new_color remaining)) 
		    TRL_ALTIUM2HDL_Create_Flow_Graphic()
		)
	    ) 
	    ("create_orcad_sch" 
		(TRL_ALTIUM2HDL_Create_XML_Schematic)
	    ) 
	    ("load_view" 
		(axlFormTreeViewSet fid "tree" 
		    'TV_REMOVEALL nil
		) 
		TRL_ALTIUM2HDL_Tree_View() 
		(axlFormTreeViewSet fid "tree" 
		    'TV_NOEDITLABEL nil
		)
	    ) 
	    ("SchDoc" 
		(schdoc_file = (axlDMFileBrowse nil nil ?optFilters "Altium PCB Files(*.SchDoc)|*.SchDoc")) 
		when((schdoc_file && isFile(schdoc_file)) 
		    (tmp = (trl_altium2hdl_global->files)) 
		    (trl_altium2hdl_global->files = list("" "" schdoc_file 
			    cadddr(tmp) 
			    nth(4 tmp)
			    nth(5 tmp) 
			    nth(6 tmp) 
			    nth(7 tmp)
			)) 
		    (axlFormSetField fid "prjpcb_l" 
			car((trl_altium2hdl_global->files))
		    ) 
		    (axlFormSetField fid "SchDoc_l" schdoc_file)
		    (axlFormSetField fid "SchDocDir_l" 
			cadr((trl_altium2hdl_global->files))
		    )
		)
	    )
	    ("prjpcb" 
		(prjpcb_file = (axlDMFileBrowse nil nil ?optFilters "Altium PCB Files(*.PrjPcb)|*.PrjPcb")) 
		when((prjpcb_file && isFile(prjpcb_file)) 
		    (trl_altium2hdl_global->files = cons(prjpcb_file 
			    cdr((trl_altium2hdl_global->files))
			)) 
		    (axlFormSetField fid "prjpcb_l" prjpcb_file) 
		    (axlFormSetField fid "SchDoc_l" 
			caddr((trl_altium2hdl_global->files))
		    ) 
		    (axlFormSetField fid "SchDocDir_l" 
			cadr((trl_altium2hdl_global->files))
		    )
		)
	    ) 
	    ("SchDocDir" 
		(dir_name = (axlDMDirectoryBrowse "." t ?title "Pick Schematic directory")) 
		if(isWritable(dir_name) then 
		    (tmp = (trl_altium2hdl_global->files)) 
		    (trl_altium2hdl_global->files = list(car(tmp) dir_name 
			    caddr(tmp) 
			    cadddr(tmp) 
			    nth(4 tmp)
			    nth(5 tmp) 
			    nth(6 tmp) 
			    nth(7 tmp)
			)) 
		    (trl_altium2hdl_global->exeption = cons(sprintf(nil "   X.1.01 INFO    - Schematic Directory set: %L" dir_name) 
			    (trl_altium2hdl_global->exeption)
			))
		    (axlFormSetField fid "prjpcb_l" 
			car((trl_altium2hdl_global->files))
		    ) 
		    (axlFormSetField fid "SchDocDir_l" dir_name) 
		    (axlFormSetField fid "SchDoc_l" 
			caddr((trl_altium2hdl_global->files))
		    ) else 
		    (trl_altium2hdl_global->exeption = cons(sprintf(nil "   X.1.01 INFO    - Project Directory: %L Not Writable" dir_name) 
			    (trl_altium2hdl_global->exeption)
			))
		    (axlFormSetField fid "SchDocDir_l" "")
		)
	    ) 
	    ("reference" 
		(file_name = (axlDMFileBrowse nil nil ?optFilters "Altium PCB Files(*.ref)|*.ref")) 
		(axlFormSetField fid "reference_l" file_name)
	    ) 
	    ("source_projloc" 
		(file_name = (axlDMFileBrowse nil nil ?optFilters "Altium PCB Files(*.cpm)|*.cpm")) 
		(axlFormSetField fid "source_projloc_l" file_name)
	    ) 
	    ("cis" 
		(file_name = (axlDMFileBrowse nil nil ?optFilters "Component Information Files(*.csv)|*.csv")) 
		(axlFormSetField fid "cis_l" file_name)
	    )
	    ("projloc" 
		(dest_dir = (axlDMDirectoryBrowse "." t ?title "Pick a directory")) 
		if(isWritable(dest_dir) then 
		    (trl_altium2hdl_global->exeption = cons(sprintf(nil "   X.1.01 INFO    - Project Directory set: %L" dest_dir) 
			    (trl_altium2hdl_global->exeption)
			)) 
		    (tmp = (trl_altium2hdl_global->files)) 
		    (trl_altium2hdl_global->files = list(car(tmp) 
			    cadr(tmp) 
			    caddr(tmp) 
			    cadddr(tmp) dest_dir
			    nth(5 tmp) 
			    nth(6 tmp) 
			    nth(7 tmp)
			))
		    (axlFormSetField fid "projloc_l" dest_dir) else 
		    (trl_altium2hdl_global->exeption = cons(sprintf(nil "   X.1.01 INFO    - Project Directory: %L Not Writable" dest_dir) 
			    (trl_altium2hdl_global->exeption)
			)) 
		    (tmp = (trl_altium2hdl_global->files)) 
		    (trl_altium2hdl_global->files = list(car(tmp) 
			    cadr(tmp) 
			    caddr(tmp) 
			    cadddr(tmp) ""
			    nth(5 tmp) 
			    nth(6 tmp) 
			    nth(7 tmp)
			))
		    (axlFormSetField fid "projloc_l" "")
		)
	    ) 
	    ("report" 
		TRL_ALTIUM2HDL_Show_Report()
	    ) 
	    ("done" 
		(axlFormClose fid) 
		(axlCancelEnterFun)
	    ) 
	    ("my_help" 
		TRL_HELP_Launch("altium2hdl_adv")
	    )
	)
    )
)
procedure(TRL_ALTIUM2HDL_Callback_Basic(fid) 
    let((prjpcb_file tmp_input tmp dest_dir) 
	case((fid->curField) 
	    ("report" 
		TRL_ALTIUM2HDL_Show_Report()
	    ) 
	    ("run_translator" 
		TRL_ALTIUM2HDL_Load_SCHematic() 
		TRL_ALTIUM2HDL_SCH_Create_Concept_Harness_Adapter_List() 
		if((trl_altium2hdl_global->SchRawList) then 
		    (tmp_input = TRL_ALTIUM2HDL_SCH_Create_Project_Structure()) 
		    if(tmp_input then 
			TRL_ALTIUM2HDL_Create_Concept_symbols() 
			TRL_ALTIUM2HDL_SCH_Create_Concept_Schematic() else
			(axlUIWPrint fid "E - Check if License for FET exist! Check if Template Project exist!")
		    ) else
		    (axlUIWPrint fid "E - Check if ASCII SchDoc Loaded!")
		)
	    ) 
	    ("prjpcb" 
		(prjpcb_file = (axlDMFileBrowse nil nil ?optFilters "Altium PCB Files(*.PrjPcb)|*.PrjPcb")) 
		when((prjpcb_file && isFile(prjpcb_file)) 
		    (trl_altium2hdl_global->files = cons(prjpcb_file 
			    cdr((trl_altium2hdl_global->files))
			)) 
		    (axlFormSetField fid "prjpcb_l" prjpcb_file)
		)
	    ) 
	    ("projloc" 
		(dest_dir = (axlDMDirectoryBrowse "." t ?title "Pick a directory")) 
		if(isWritable(dest_dir) then 
		    (trl_altium2hdl_global->exeption = cons(sprintf(nil "   X.1.01 INFO    - Project Directory set: %L" dest_dir) 
			    (trl_altium2hdl_global->exeption)
			)) 
		    (tmp = (trl_altium2hdl_global->files)) 
		    (trl_altium2hdl_global->files = list(car(tmp) 
			    cadr(tmp) 
			    caddr(tmp) 
			    cadddr(tmp) dest_dir
			    nth(5 tmp) 
			    nth(6 tmp) 
			    nth(7 tmp)
			))
		    (axlFormSetField fid "projloc_l" dest_dir) else 
		    (trl_altium2hdl_global->exeption = cons(sprintf(nil "   X.1.01 INFO    - Project Directory: %L Not Writable" dest_dir) 
			    (trl_altium2hdl_global->exeption)
			)) 
		    (tmp = (trl_altium2hdl_global->files)) 
		    (trl_altium2hdl_global->files = list(car(tmp) 
			    cadr(tmp) 
			    caddr(tmp) 
			    cadddr(tmp) ""
			    nth(5 tmp) 
			    nth(6 tmp) 
			    nth(7 tmp)
			))
		    (axlFormSetField fid "projloc_l" "")
		)
	    )
	    ("done" 
		(axlFormClose fid) 
		(axlCancelEnterFun)
	    ) 
	    ("my_help" 
		TRL_HELP_Launch("altium2hdl")
	    )
	)
    )
)
procedure(TRL_ALTIUM2HDL_Check_Overlapping_Pin(curr_id sym_rec) 
    let((rec id record lx ly
	    coor_l over_l pname comm_l grpe_l
	    tmp_lst
	) 
	(coor_l = list()) 
	(over_l = list()) 
	(comm_l = list()) 
	(grpe_l = list())
	foreach(recs sym_rec 
	    (pname = cadr(recs)) 
	    (rec = car(last(recs))) 
	    (id = get(rec 
		    'OWNERPARTID
		))
	    (record = get(rec 
		    'RECORD
		)) 
	    when(((id == curr_id) && (record == "2")) 
		(lx = get(rec 
			'LOCATION\.X
		    )) 
		(ly = get(rec 
			'LOCATION\.Y
		    )) 
		unless(lx 
		    (lx = "0")
		) 
		unless(ly 
		    (ly = "0")
		)
		(lx = atoi(lx)) 
		(ly = atoi(ly)) 
		(comm_l = cons(list((lx:ly) pname) comm_l)) 
		if(member((lx:ly) coor_l) then 
		    unless(member((lx:ly) over_l) 
			(over_l = cons((lx:ly) over_l))
		    ) 
		    (coor_l = cons((lx:ly) coor_l)) else
		    (coor_l = cons((lx:ly) coor_l))
		)
	    )
	) 
	when(over_l 
	    foreach(g_elem over_l 
		(tmp_lst = list()) 
		foreach(c_elem comm_l 
		    when((g_elem == car(c_elem)) 
			(tmp_lst = cons(cadr(c_elem) tmp_lst))
		    )
		) 
		(grpe_l = cons(tmp_lst grpe_l))
	    )
	) 
	list(over_l grpe_l)
    )
)
procedure(TRL_ALTIUM2HDL_Create_Concept_Chips_PRT(sym_rec sym_views pinTable pinImpli part_name
	label_data outport nc_pins sh_pins
    ) 
    let((p_strg part_prefix tmp_name pname electrical
	    process
	) 
	unless(sym_views 
	    printf("..Chips_PRT->sym_views\n")
	) 
	fprintf(outport "FILE_TYPE=LIBRARY_PARTS;\n") 
	fprintf(outport "primitive '%s';\n" part_name) 
	fprintf(outport "  pin\n")
	foreach(pin 
	    (pinTable->?) 
	    (process = t) 
	    when(nc_pins 
		foreach(nc nc_pins 
		    when((upperCase(car(nc)) == upperCase(pin)) 
			(process = nil)
		    )
		)
	    ) 
	    when(process 
		(tmp_name = parseString(pin "_")) 
		foreach(rec sym_rec 
		    when((cadr(rec) == car(tmp_name)) 
			(rec = nth(3 rec)) 
			(electrical = get(rec 
				'ELECTRICAL
			    ))
		    )
		) 
		(pname = pin) 
		when((car(last(tmp_name)) == "NNN") 
		    (tmp_name = cdr(reverse(tmp_name))) 
		    (tmp_name = reverse(tmp_name)) 
		    (tmp_name = buildString(tmp_name)) 
		    (pname = "-")
		    (pname = sprintf(nil "%s%s" pname tmp_name))
		)
		rexCompile("\\[") 
		(pname = rexReplace(pname "_" 0)) 
		rexCompile("\\]") 
		(pname = rexReplace(pname "_" 0)) 
		fprintf(outport "     '%s':\n" pname)
		(p_strg = "      PIN_NUMBER='(") 
		(p_strg = strcat(p_strg 
			car(pinTable[pin])
		    )) 
		when((length(pinTable[pin]) > 1) 
		    foreach(pinval 
			cdr(pinTable[pin]) 
			rexCompile("[.]") 
			(pinval = rexReplace(pinval "_" 0)) 
			(p_strg = strcat(p_strg "," pinval))
		    )
		) 
		(p_strg = strcat(p_strg ")';\n")) 
		fprintf(outport p_strg)
		case(electrical 
		    ("1" 
			fprintf(outport "      BIDIRECTIONAL='TRUE';\n") 
			fprintf(outport "      INPUT_LOAD='(-0.01,0.01)';\n") 
			fprintf(outport "      OUTPUT_LOAD='(1.0,-1.0)';\n")
		    ) 
		    ("2" 
			fprintf(outport "      OUTPUT_LOAD='(1.0,-1.0)';\n")
		    ) 
		    ("3" 
			fprintf(outport "      OUTPUT_TYPE='(OC,AND)';\n") 
			fprintf(outport "      BIDIRECTIONAL='TRUE';\n") 
			fprintf(outport "      INPUT_LOAD='(-0.01,0.01)';\n") 
			fprintf(outport "      OUTPUT_LOAD='(1.0,*)';\n")
		    ) 
		    ("4" 
			fprintf(outport "      PINUSE='UNSPEC';\n") 
			fprintf(outport "      NO_LOAD_CHECK='Both';\n") 
			fprintf(outport "      NO_IO_CHECK='Both';\n") 
			fprintf(outport "      NO_ASSERT_CHECK='TRUE';\n")
			fprintf(outport "      NO_DIR_CHECK='TRUE';\n") 
			fprintf(outport "      ALLOW_CONNECT='TRUE';\n")
		    )
		    ("5" 
			fprintf(outport "      OUTPUT_TYPE='(TS,TS)';\n") 
			fprintf(outport "      BIDIRECTIONAL='TRUE';\n") 
			fprintf(outport "      INPUT_LOAD='(-0.01,0.01)';\n") 
			fprintf(outport "      OUTPUT_LOAD='(1.0,-1.0)';\n")
		    ) 
		    ("6" 
			fprintf(outport "      OUTPUT_TYPE='(OE,OR)';\n") 
			fprintf(outport "      BIDIRECTIONAL='TRUE';\n") 
			fprintf(outport "      INPUT_LOAD='(-0.01,0.01)';\n") 
			fprintf(outport "      OUTPUT_LOAD='(1.0,*)';\n")
		    ) 
		    ("7" 
			fprintf(outport "      PINUSE='POWER';\n") 
			fprintf(outport "      NO_LOAD_CHECK='Both';\n") 
			fprintf(outport "      NO_IO_CHECK='Both';\n") 
			fprintf(outport "      NO_ASSERT_CHECK='TRUE';\n")
			fprintf(outport "      NO_DIR_CHECK='TRUE';\n") 
			fprintf(outport "      ALLOW_CONNECT='TRUE';\n")
		    ) 
		    (t 
			fprintf(outport "      INPUT_LOAD='(-0.01,0.01)';\n")
		    )
		)
	    )
	) 
	fprintf(outport "  end_pin;\n") 
	fprintf(outport "  body\n") 
	if(car(label_data) then 
	    (part_prefix = upperCase(car(label_data))) else 
	    (part_prefix = "U")
	) 
	if(((part_prefix == "U") || (part_prefix == "IC")) then 
	    fprintf(outport "    CLASS='IC';\n") else 
	    if(((part_prefix == "J") || (part_prefix == "S") || (part_prefix == "X")) then 
		fprintf(outport "    CLASS='IO';\n") else 
		fprintf(outport "    CLASS='DISCRETE';\n")
	    )
	)
	fprintf(outport "    PART_NAME='%s';\n" part_name) 
	fprintf(outport "    BODY_NAME='%s';\n" part_name) 
	fprintf(outport "    PHYS_DES_PREFIX='%s';\n" part_prefix) 
	when(pinImpli outport 
	    TRL_ALTIUM2HDL_Create_Symbol_Implicite_Pin(pinImpli outport)
	) 
	when(nc_pins 
	    TRL_ALTIUM2HDL_Create_Symbol_NC_Pin(nc_pins outport)
	)
	when(sh_pins 
	    TRL_ALTIUM2HDL_Create_Symbol_Short_Pin(sh_pins outport)
	) 
	fprintf(outport "  end_body;\n") 
	fprintf(outport "end_primitive;\n") 
	fprintf(outport "END.\n")
    )
)
procedure(TRL_ALTIUM2HDL_Create_Concept_PINCONGLOMERATE(pin_c rot mirr pname dname
	pvalue nc_pins rotate
    ) 
    let(nil 
	case(pin_c 
	    ("60" 
		(pin_c = "32")
	    ) 
	    ("61" 
		(pin_c = "33")
	    ) 
	    ("62" 
		(pin_c = "34")
	    ) 
	    ("63" 
		(pin_c = "35")
	    )
	    ("8" 
		(pin_c = "40")
	    ) 
	    ("9" 
		(pin_c = "41")
	    ) 
	    ("10" 
		(pin_c = "42")
	    ) 
	    ("11" 
		(pin_c = "43")
	    ) 
	    ("16" 
		(pin_c = "48")
	    )
	    ("17" 
		(pin_c = "49")
	    ) 
	    ("18" 
		(pin_c = "50")
	    ) 
	    ("19" 
		(pin_c = "51")
	    ) 
	    ("80" 
		(pin_c = "48")
	    ) 
	    ("81" 
		(pin_c = "49")
	    )
	    ("82" 
		(pin_c = "50")
	    ) 
	    ("83" 
		(pin_c = "51")
	    ) 
	    ("24" 
		(pin_c = "56")
	    ) 
	    ("25" 
		(pin_c = "57")
	    ) 
	    ("26" 
		(pin_c = "58")
	    )
	    ("27" 
		(pin_c = "59")
	    ) 
	    ("96" 
		(pin_c = "56")
	    ) 
	    ("97" 
		(pin_c = "57")
	    ) 
	    ("98" 
		(pin_c = "58")
	    ) 
	    ("99" 
		(pin_c = "59")
	    )
	    ("112" 
		(pin_c = "48")
	    ) 
	    ("113" 
		(pin_c = "49")
	    ) 
	    ("114" 
		(pin_c = "50")
	    ) 
	    ("115" 
		(pin_c = "51")
	    ) 
	    ("38" 
		(nc_pins = cons(list(pname dname pvalue) nc_pins))
	    )
	    ("36" 
		(nc_pins = cons(list(pname dname pvalue) nc_pins))
	    ) 
	    ("55" 
		(nc_pins = cons(list(pname dname pvalue) nc_pins))
	    ) 
	    ("100" 
		(nc_pins = cons(list(pname dname pvalue) nc_pins))
	    ) 
	    ("102" 
		(nc_pins = cons(list(pname dname pvalue) nc_pins))
	    ) 
	    (t)
	) 
	when(rot 
	    case(rot 
		("1" 
		    case(pin_c 
			("32" 
			    (pin_c = "35")
			) 
			("33" 
			    (pin_c = "32")
			) 
			("34" 
			    (pin_c = "33")
			) 
			("35" 
			    (pin_c = "34")
			)
			("40" 
			    (pin_c = "43")
			) 
			("41" 
			    (pin_c = "40")
			) 
			("42" 
			    (pin_c = "41")
			) 
			("43" 
			    (pin_c = "42")
			) 
			("48" 
			    (pin_c = "51")
			)
			("49" 
			    (pin_c = "48")
			) 
			("50" 
			    (pin_c = "49")
			) 
			("51" 
			    (pin_c = "50")
			) 
			("56" 
			    (pin_c = "59")
			) 
			("57" 
			    (pin_c = "56")
			)
			("58" 
			    (pin_c = "57")
			) 
			("59" 
			    (pin_c = "58")
			) 
			(t 
			    printf("--Hier bei pin_c %L\n" pin_c)
			)
		    )
		) 
		("2" 
		    case(pin_c 
			("32" 
			    (pin_c = "34")
			) 
			("33" 
			    (pin_c = "35")
			) 
			("34" 
			    (pin_c = "32")
			) 
			("35" 
			    (pin_c = "33")
			)
			("40" 
			    (pin_c = "42")
			) 
			("41" 
			    (pin_c = "43")
			) 
			("42" 
			    (pin_c = "40")
			) 
			("43" 
			    (pin_c = "41")
			) 
			("48" 
			    (pin_c = "50")
			)
			("49" 
			    (pin_c = "51")
			) 
			("50" 
			    (pin_c = "48")
			) 
			("51" 
			    (pin_c = "49")
			) 
			("56" 
			    (pin_c = "58")
			) 
			("57" 
			    (pin_c = "59")
			)
			("58" 
			    (pin_c = "56")
			) 
			("59" 
			    (pin_c = "57")
			) 
			(t 
			    printf("--Hier bei pin_c %L\n" pin_c)
			)
		    )
		) 
		("3" 
		    case(pin_c 
			("32" 
			    (pin_c = "33")
			) 
			("33" 
			    (pin_c = "34")
			) 
			("34" 
			    (pin_c = "35")
			) 
			("35" 
			    (pin_c = "32")
			)
			("40" 
			    (pin_c = "41")
			) 
			("41" 
			    (pin_c = "42")
			) 
			("42" 
			    (pin_c = "43")
			) 
			("43" 
			    (pin_c = "40")
			) 
			("48" 
			    (pin_c = "49")
			)
			("49" 
			    (pin_c = "50")
			) 
			("50" 
			    (pin_c = "51")
			) 
			("51" 
			    (pin_c = "48")
			) 
			("56" 
			    (pin_c = "57")
			) 
			("57" 
			    (pin_c = "58")
			)
			("58" 
			    (pin_c = "59")
			) 
			("59" 
			    (pin_c = "56")
			) 
			(t 
			    printf("--Hier bei pin_c %L\n" pin_c)
			)
		    )
		) 
		(t 
		    printf("--Hier bei pin_c %L\n" pin_c)
		)
	    )
	) 
	when(mirr 
	    when(((rotate == 0.0) || (rotate == -180.0)) 
		case(pin_c 
		    ("34" 
			(pin_c = "32")
		    ) 
		    ("42" 
			(pin_c = "40")
		    ) 
		    ("50" 
			(pin_c = "48")
		    ) 
		    ("58" 
			(pin_c = "56")
		    )
		    ("32" 
			(pin_c = "34")
		    ) 
		    ("40" 
			(pin_c = "42")
		    ) 
		    ("48" 
			(pin_c = "50")
		    ) 
		    ("56" 
			(pin_c = "58")
		    ) 
		    (t 
			printf("--Hier bei pin_c mirr %L\n" pin_c)
		    )
		)
	    ) 
	    when(((rotate == -90.0) || (rotate == -270.0)) 
		case(pin_c 
		    ("33" 
			(pin_c = "35")
		    ) 
		    ("41" 
			(pin_c = "43")
		    ) 
		    ("49" 
			(pin_c = "51")
		    ) 
		    ("57" 
			(pin_c = "59")
		    )
		    ("35" 
			(pin_c = "33")
		    ) 
		    ("43" 
			(pin_c = "41")
		    ) 
		    ("51" 
			(pin_c = "49")
		    ) 
		    ("59" 
			(pin_c = "57")
		    ) 
		    (t 
			printf("--Hier bei pin_c mirr %L\n" pin_c)
		    )
		)
	    )
	) 
	list(pin_c nc_pins)
    )
)
procedure(TRL_ALTIUM2HDL_Create_Concept_Part_Table(sym_rec sym_views pinTable part_name outport
	label_data
    ) 
    let((name string header_inf part_number part_value
	    part_jedec index prop1 prop2 part_prop1
	    part_prop2 part_str p_number p_value p_jedec
	    p_prop1 p_prop2 val
	) 
	(pinTable = pinTable) 
	(sym_views = sym_views) 
	if((trl_altium2hdl_global->CISRawList) then 
	    (header_inf = TRL_ALTIUM2HDL_SCH_Create_Concept_PPT_Header(car((trl_altium2hdl_global->CISRawList)) outport label_data)) 
	    (part_number = car(header_inf)) 
	    (part_value = cadr(header_inf))
	    (part_jedec = caddr(header_inf)) 
	    (part_prop1 = nth(3 header_inf)) 
	    (part_prop2 = nth(4 header_inf)) 
	    (index = 1) 
	    foreach(part 
		cdr((trl_altium2hdl_global->CISRawList)) 
		when((upperCase(TRL_ALTIUM2HDL_PCB_Util_Namemaper(car(part))) == upperCase(part_name)) 
		    (part_str = "") 
		    when(part_number 
			(part_str = sprintf(nil "%s'%s'" part_str 
				nth(part_number part)
			    ))
		    ) 
		    when(part_value 
			(part_str = sprintf(nil "%s | '%s'" part_str 
				nth(part_value part)
			    ))
		    ) 
		    when(part_prop1 
			(part_str = sprintf(nil "%s | '%s'" part_str 
				nth(part_prop1 part)
			    ))
		    )
		    when(part_prop2 
			(part_str = sprintf(nil "%s | '%s'" part_str 
				nth(part_prop2 part)
			    ))
		    ) 
		    (part_str = sprintf(nil "%s = '%s'" part_str 
			    cadr(part)
			)) 
		    foreach(item 
			cddr(part) 
			when((item == "xyzxyz") 
			    (item = " ")
			) 
			(part_str = sprintf(nil "%s | '%s'" part_str item))
		    ) 
		    (part_str = sprintf(nil "%s\n" part_str)) 
		    fprintf(outport "%s" part_str)
		    index++
		)
	    )
	    fprintf(outport "\nEND_PART\n\n") 
	    fprintf(outport "END.\n") 
	    (trl_altium2hdl_global->exeption = cons(sprintf(nil "   3.6.2  INFO    - [%d] Symbols ADDED to the MULTI_PHYS_TABLE" index) 
		    (trl_altium2hdl_global->exeption)
		)) else 
	    (part_number = upperCase((axlFormGetField 
			(trl_altium2hdl_global->formid) "part_number_l"
		    )
		))
	    (part_jedec = upperCase((axlFormGetField 
			(trl_altium2hdl_global->formid) "part_jedec_l"
		    )
		)) 
	    (part_value = upperCase((axlFormGetField 
			(trl_altium2hdl_global->formid) "part_value_l"
		    )
		)) 
	    (prop1 = upperCase((axlFormGetField 
			(trl_altium2hdl_global->formid) "prop1_l"
		    )
		)) 
	    (prop2 = upperCase((axlFormGetField 
			(trl_altium2hdl_global->formid) "prop2_l"
		    )
		)) 
	    (p_value = "''")
	    (p_number = "''") 
	    (p_jedec = "''") 
	    (p_prop1 = "''") 
	    (p_prop2 = "''") 
	    fprintf(outport "FILE_TYPE = MULTI_PHYS_TABLE;\n\n")
	    fprintf(outport "PART '%s'\n\n" part_name) 
	    fprintf(outport "{========================================================================================}\n") 
	    fprintf(outport ": PART_NUMBER  = PART_NUMBER | VALUE | JEDEC_TYPE | %s | %s;\n" 
		TRL_ALTIUM2HDL_PCB_Util_Namemaper(prop1) 
		TRL_ALTIUM2HDL_PCB_Util_Namemaper(prop2)
	    ) 
	    fprintf(outport "{========================================================================================}\n") 
	    foreach(rec sym_rec 
		(name = get(rec 
			'NAME
		    )) 
		(val = get(rec 
			'TEXT
		    )) 
		when((name && val) 
		    when((part_number == upperCase(name)) 
			(p_number = get(rec 
				'TEXT
			    ))
		    ) 
		    when((part_value == upperCase(name)) 
			(p_value = get(rec 
				'TEXT
			    ))
		    ) 
		    when((part_jedec == upperCase(name)) 
			(p_jedec = get(rec 
				'TEXT
			    ))
		    ) 
		    when((prop1 == upperCase(name)) 
			(p_prop1 = get(rec 
				'TEXT
			    ))
		    )
		    when((prop2 == upperCase(name)) 
			(p_prop2 = get(rec 
				'TEXT
			    ))
		    )
		)
	    )
	    (string = sprintf(nil "'%s' = '%s' | '%s' | '%s' | '%s' | '%s' \n\n" p_number p_number p_value
		    p_jedec p_prop1 p_prop2
		)) 
	    fprintf(outport string) 
	    fprintf(outport "END_PART\n\n") 
	    fprintf(outport "END.\n")
	)
    )
)
procedure(TRL_ALTIUM2HDL_Create_Concept_Symbol_Arc(sym_rec curr_id loc_x loc_y rot
	mirr port display
    ) 
    let((id lx ly rad sa
	    ea min_x max_y r_frac rotate
	    xy disp_mode record
	) 
	(min_x = 1000000) 
	(max_y = -1000000) 
	(rotate = 0.0) 
	foreach(rec sym_rec 
	    (id = get(rec 
		    'OWNERPARTID
		)) 
	    (record = get(rec 
		    'RECORD
		)) 
	    (disp_mode = get(rec 
		    'OWNERPARTDISPLAYMODE
		))
	    if(display then 
		if((disp_mode == display) then 
		    (disp_mode = t) else 
		    (disp_mode = nil)
		) else 
		if(disp_mode then 
		    (disp_mode = nil) else 
		    (disp_mode = t)
		)
	    ) 
	    when(((id == curr_id) && (record == "12") && disp_mode) 
		(lx = get(rec 
			'LOCATION\.X
		    )) 
		(ly = get(rec 
			'LOCATION\.Y
		    )) 
		(rad = get(rec 
			'RADIUS
		    )) 
		(sa = get(rec 
			'STARTANGLE
		    ))
		(ea = get(rec 
			'ENDANGLE
		    )) 
		(r_frac = get(rec 
			'RADIUS_FRAC
		    )) 
		when(mirr 
		    (mirr = t)
		) 
		when(rot 
		    case(rot 
			("1" 
			    (rotate = -90.0)
			) 
			("2" 
			    (rotate = -180.0)
			) 
			("3" 
			    (rotate = -270.0)
			) 
			(t 
			    printf("----> was ist los hier bei rotate sym ARC %L\n" rot)
			)
		    )
		) 
		when(ea 
		    (lx = ((atoi(lx) - atoi(loc_x)) * 5)) 
		    (ly = ((atoi(ly) - atoi(loc_y)) * 5)) 
		    if((rot || mirr) then 
			(xy = (axlGeoRotatePt rotate 
				(lx:ly) 
				(0.0:0.0) mirr
			    )) 
			(lx = round(car(xy))) 
			(ly = round(cadr(xy)))
			else 
			(lx = round(lx)) 
			(ly = round(ly))
		    ) 
		    when(rad 
			(rad = (atoi(rad) * 5))
		    )
		    when(sa 
			(sa = (atof(sa) + rotate))
		    ) 
		    when(ea 
			(ea = (atof(ea) + rotate))
		    ) 
		    unless(sa 
			(sa = 0.0)
		    ) 
		    when(r_frac 
			(r_frac = atoi(r_frac)) 
			(r_frac = ((r_frac / 100000.0) * 5))
		    ) 
		    unless(rad 
			(rad = 5)
		    )
		    when(r_frac 
			(rad = (rad + r_frac))
		    ) 
		    (rad = round(rad)) 
		    printf("--ARC-> %L %L %L %L %L - %L\n" lx ly rad sa
			ea r_frac
		    ) 
		    fprintf(port "A %d %d %d %f %f 16\n" lx ly rad
			sa ea
		    )
		)
	    )
	)
	list(min_x max_y)
    )
)
procedure(TRL_ALTIUM2HDL_Create_Concept_Symbol_Ellipse(sym_rec curr_id loc_x loc_y rot
	mirr port display
    ) 
    let((id lx ly rad secrad
	    sa ea min_x max_y r_frac
	    rotate xy disp_mode record
	) 
	(min_x = 1000000) 
	(max_y = -1000000) 
	(rotate = 0.0) 
	foreach(rec sym_rec 
	    (id = get(rec 
		    'OWNERPARTID
		)) 
	    (record = get(rec 
		    'RECORD
		)) 
	    (disp_mode = get(rec 
		    'OWNERPARTDISPLAYMODE
		))
	    if(display then 
		if((disp_mode == display) then 
		    (disp_mode = t) else 
		    (disp_mode = nil)
		) else 
		if(disp_mode then 
		    (disp_mode = nil) else 
		    (disp_mode = t)
		)
	    ) 
	    when(((id == curr_id) && (record == "8") && disp_mode) 
		(lx = get(rec 
			'LOCATION\.X
		    )) 
		(ly = get(rec 
			'LOCATION\.Y
		    )) 
		(rad = get(rec 
			'RADIUS
		    )) 
		(secrad = get(rec 
			'SECONDARYRADIUS
		    ))
		(sa = get(rec 
			'STARTANGLE
		    )) 
		(ea = get(rec 
			'ENDANGLE
		    )) 
		(r_frac = get(rec 
			'RADIUS_FRAC
		    )) 
		when(mirr 
		    (mirr = t)
		) 
		when(rot 
		    case(rot 
			("1" 
			    (rotate = -90.0)
			) 
			("2" 
			    (rotate = -180.0)
			) 
			("3" 
			    (rotate = -270.0)
			) 
			(t 
			    printf("----> was ist los hier bei rotate sym ARC %L\n" rot)
			)
		    )
		)
		if((secrad == rad) then 
		    unless(ea 
			(ea = "360.0")
		    ) 
		    unless(sa 
			(sa = "0.0")
		    ) 
		    when((lx && ly) 
			(lx = ((atoi(lx) - atoi(loc_x)) * 5)) 
			(ly = ((atoi(ly) - atoi(loc_y)) * 5)) 
			if((rot || mirr) then 
			    (xy = (axlGeoRotatePt rotate 
				    (lx:ly) 
				    (0.0:0.0) mirr
				)) 
			    (lx = round(car(xy))) 
			    (ly = round(cadr(xy)))
			    else 
			    (lx = round(lx)) 
			    (ly = round(ly))
			) 
			when(rad 
			    (rad = (atoi(rad) * 5))
			)
			when(sa 
			    (sa = (atof(sa) + rotate))
			) 
			when(ea 
			    (ea = (atof(ea) + rotate))
			) 
			unless(rad 
			    (rad = 5) 
			    when(r_frac 
				(r_frac = atoi(r_frac)) 
				(rad = ((r_frac / 10000) * 5))
			    )
			) 
			fprintf(port "A %d %d %d %f %f 16\n" lx ly rad
			    sa ea
			)
		    )
		    else 
		    printf("--ARC-> %L %L %L %L %L %L\n" lx ly rad secrad
			sa ea
		    )
		)
	    )
	)
	list(min_x max_y)
    )
)
procedure(TRL_ALTIUM2HDL_Create_Concept_Symbol_EllipseArc(sym_rec curr_id loc_x loc_y rot
	mirr port display
    ) 
    let((id lx ly rad sa
	    ea min_x max_y r_frac rotate
	    xy secrad disp_mode record
	) 
	(min_x = 1000000) 
	(max_y = -1000000) 
	(rotate = 0.0) 
	foreach(rec sym_rec 
	    (id = get(rec 
		    'OWNERPARTID
		)) 
	    (record = get(rec 
		    'RECORD
		)) 
	    (disp_mode = get(rec 
		    'OWNERPARTDISPLAYMODE
		))
	    if(display then 
		if((disp_mode == display) then 
		    (disp_mode = t) else 
		    (disp_mode = nil)
		) else 
		if(disp_mode then 
		    (disp_mode = nil) else 
		    (disp_mode = t)
		)
	    ) 
	    when(((id == curr_id) && (record == "11") && disp_mode) 
		(lx = get(rec 
			'LOCATION\.X
		    )) 
		(ly = get(rec 
			'LOCATION\.Y
		    )) 
		(rad = get(rec 
			'RADIUS
		    )) 
		(secrad = get(rec 
			'SECONDARYRADIUS
		    ))
		(sa = get(rec 
			'STARTANGLE
		    )) 
		(ea = get(rec 
			'ENDANGLE
		    )) 
		(r_frac = get(rec 
			'RADIUS_FRAC
		    )) 
		when(mirr 
		    (mirr = t)
		) 
		when(rot 
		    case(rot 
			("1" 
			    (rotate = -90.0)
			) 
			("2" 
			    (rotate = -180.0)
			) 
			("3" 
			    (rotate = -270.0)
			) 
			(t 
			    printf("----> was ist los hier bei rotate sym ARC %L\n" rot)
			)
		    )
		)
		unless((secrad == rad) 
		    printf("--This is a EllipsARC-> %L %L %L %L %L %L\n" lx ly rad secrad
			sa ea
		    ) 
		    (secrad = rad)
		) 
		if((secrad == rad) then 
		    unless(ea 
			(ea = "360.0")
		    ) 
		    unless(sa 
			(sa = "0.0")
		    ) 
		    when((lx && ly) 
			(lx = ((atoi(lx) - atoi(loc_x)) * 5)) 
			(ly = ((atoi(ly) - atoi(loc_y)) * 5)) 
			if((rot || mirr) then 
			    (xy = (axlGeoRotatePt rotate 
				    (lx:ly) 
				    (0.0:0.0) mirr
				)) 
			    (lx = round(car(xy))) 
			    (ly = round(cadr(xy)))
			    else 
			    (lx = round(lx)) 
			    (ly = round(ly))
			) 
			when(rad 
			    (rad = (atoi(rad) * 5))
			)
			when(sa 
			    (sa = (atof(sa) + rotate))
			) 
			when(ea 
			    (ea = (atof(ea) + rotate))
			) 
			unless(rad 
			    (rad = 5) 
			    when(r_frac 
				(r_frac = atoi(r_frac)) 
				(rad = ((r_frac / 10000) * 5))
			    )
			) 
			fprintf(port "A %d %d %d %f %f 16\n" lx ly rad
			    sa ea
			)
		    )
		    else 
		    printf("--ARC-> %L %L %L %L %L %L\n" lx ly rad secrad
			sa ea
		    )
		)
	    )
	)
	list(min_x max_y)
    )
)
procedure(TRL_ALTIUM2HDL_Create_Concept_Symbol_Label(sym_rec curr_id loc_x loc_y rot
	mirr port display exceptions_list
    ) 
    let((lx ly prop_val prop_name prop_just
	    prop_vis iscurrent prop_font prop_color ref_des_pref
	    index key_list prop_list prop_size prop_rot
	    power_port record created id comment
	    modelname modeltype jedecType
	) 
	(display = display) 
	(key_list = list()) 
	(index = 1) 
	foreach(rec sym_rec 
	    (power_port = get(rec 
		    'SHOWNETNAME
		)) 
	    unless(power_port 
		(prop_name = get(rec 
			'NAME
		    )) 
		(prop_list = cons(prop_name prop_list))
	    )
	)
	foreach(rec sym_rec 
	    (power_port = get(rec 
		    'SHOWNETNAME
		)) 
	    unless(power_port 
		(prop_val = get(rec 
			'TEXT
		    )) 
		(prop_name = get(rec 
			'NAME
		    )) 
		when((prop_name == "Comment") 
		    if(member(prop_val prop_list) then 
			(comment = nil) else 
			(prop_vis = get(rec 
				'ISHIDDEN
			    ))
			if((prop_vis == "T") then 
			    (prop_vis = 0) else 
			    (prop_vis = 1)
			) 
			(comment = list(prop_val prop_vis rec))
		    )
		)
	    )
	) 
	foreach(rec sym_rec 
	    (record = get(rec 
		    'RECORD
		)) 
	    (power_port = get(rec 
		    'SHOWNETNAME
		)) 
	    unless(power_port 
		if(t then 
		    (prop_val = get(rec 
			    'TEXT
			)) 
		    (prop_name = get(rec 
			    'NAME
			)) 
		    (id = get(rec 
			    'OWNERPARTID
			))
		    when((record == "45") 
			(iscurrent = get(rec 
				'ISCURRENT
			    )) 
			(modeltype = get(rec 
				'MODELTYPE
			    )) 
			when(((iscurrent == "T") && (modeltype == "PCBLIB")) 
			    (modelname = get(rec 
				    'MODELNAME
				)) 
			    when(modelname 
				(prop_val = TRL_ALTIUM2HDL_SCH_Util_PCB_Namemaper(modelname)) 
				(jedecType = prop_val) 
				(prop_name = "JEDEC_TYPE")
			    )
			)
		    ) 
		    when(prop_val 
			unless((prop_name == "PinUniqueId") 
			    (prop_val = TRL_ALTIUM2HDL_SCH_Util_PCB_Namemaper(prop_val)) 
			    (lx = get(rec 
				    'LOCATION\.X
				)) 
			    (ly = get(rec 
				    'LOCATION\.Y
				)) 
			    when(mirr 
				(mirr = t)
			    )
			    if((lx && ly) then 
				(lx = ((atoi(lx) - atoi(loc_x)) * 5)) 
				(ly = ((atoi(ly) - atoi(loc_y)) * 5)) 
				if((rot || mirr) then 
				    (lx = round(lx)) 
				    (ly = round(ly)) else
				    (lx = round(lx)) 
				    (ly = round(ly))
				)
				else 
				(lx = 0) 
				(ly = 0)
			    ) 
			    (prop_just = get(rec 
				    'JUSTIFICATION
				)) 
			    (prop_rot = get(rec 
				    'ORIENTATION
				)) 
			    (prop_vis = get(rec 
				    'ISHIDDEN
				)) 
			    (prop_font = get(rec 
				    'FONTID
				))
			    (prop_color = get(rec 
				    'COLOR
				)) 
			    if((prop_vis == "T") then 
				(prop_vis = 0) else 
				(prop_vis = 1)
			    ) 
			    unless(prop_just 
				(prop_just = "0")
			    ) 
			    if(prop_font then 
				(prop_size = TRL_ALTIUM2HDL_SCH_Util_Font_ID(prop_font)) 
				(prop_size = car(prop_size)) else
				(prop_size = 20)
			    ) 
			    if(prop_rot then 
				case(prop_rot 
				    ("1" 
					(prop_rot = 90.0)
				    ) 
				    ("2" 
					(prop_rot = 180.0)
				    ) 
				    ("3" 
					(prop_rot = 270.0)
				    ) 
				    (t 
					printf("----> was ist los hier bei rotate sym PROP ROT %L\n" rot)
				    )
				) else 
				(prop_rot = 0.0)
			    )
			    case(prop_font 
				("5" 
				    (prop_size = 28)
				) 
				("3" 
				    (prop_size = 28)
				) 
				("2" 
				    (prop_size = 28)
				) 
				(t 
				    (prop_size = 34)
				)
			    ) 
			    case(prop_just 
				("0" 
				    (prop_just = 0)
				) 
				("1" 
				    (prop_just = 1)
				) 
				("2" 
				    (prop_just = 2)
				) 
				("3" 
				    (prop_just = 0) 
				    (ly = (ly - (prop_size / 2)))
				)
				("4" 
				    (prop_just = 1) 
				    (ly = (ly - (prop_size / 2)))
				) 
				("5" 
				    (prop_just = 2) 
				    (ly = (ly - (prop_size / 2)))
				) 
				("6" 
				    (prop_just = 0) 
				    (ly = (ly - prop_size))
				) 
				("7" 
				    (prop_just = 1) 
				    (ly = (ly - prop_size))
				) 
				("8" 
				    (prop_just = 2) 
				    (ly = (ly - prop_size))
				)
				(t 
				    (prop_just = 0)
				)
			    ) 
			    (created = nil) 
			    if(prop_name then 
				when((upperCase(prop_name) == "SIZE") 
				    (prop_name = "CMP_SIZE")
				) 
				when((record == "34") 
				    (prop_name = "LOCATION") 
				    (ref_des_pref = car(parseString(prop_val ""))) 
				    (prop_val = sprintf(nil "%s?" ref_des_pref)) 
				    (ly = (ly + 4))
				    (created = t)
				) 
				when((record == "41") 
				    (created = t) 
				    when((prop_name == "Comment") 
					(created = nil) 
					when(comment 
					    (created = t)
					)
				    )
				)
				when((record == "45") 
				    (prop_vis = 0) 
				    (created = t)
				) 
				when((created && lx) 
				    unless(((prop_name == "Kind") || (prop_name == "SubKind") || (prop_name == "Spice Prefix") || (prop_name == "Netlist") || (prop_name == "Comment") || (upperCase(prop_name) == "RULE")) 
					(prop_name = TRL_ALTIUM2HDL_Preprocess_ASCII_File(prop_name)) 
					(prop_name = TRL_ALTIUM2HDL_SCH_Util_PCB_Namemaper(prop_name)) 
					(prop_name = upperCase(prop_name)) 
					when((prop_name == "LOCATION") 
					    (prop_name = "$LOCATION")
					)
					unless(((prop_name == "COMMENT") || (prop_name == "$LOCATION")) 
					    (prop_vis = 0)
					) 
					fprintf(port "P %L %L %d %d %L 0.00 %d 0 0 %d 0 0 %d 0 10\n" prop_name prop_val lx
					    ly prop_rot prop_size prop_just prop_vis
					)
				    )
				) else 
				unless(prop_name 
				    (prop_name = sprintf(nil "tmp_prop_%d" index))
				) 
				when((record == "4") 
				    when((id == curr_id) 
					(created = t)
				    ) 
				    if((prop_rot == 0.0) then 
					(ly = (ly + 5)) 
					(lx = (lx - 2)) else
					(lx = (lx - 3))
				    ) 
				    (created = nil)
				)
				when((created && lx) 
				    fprintf(port "P %L %L %d %d %L 0.00 %d 0 0 %d 0 0 %d 0 10\n" prop_name prop_val lx
					ly prop_rot prop_size prop_just prop_vis
				    ) 
				    when((axlFormGetField 
					    (trl_altium2hdl_global->formid) "verbose"
					) 
					(trl_altium2hdl_global->exeption = cons(sprintf(nil "   3.5.1  INFO    - Symbols Property: %L Value: %L Vis: %L Created [%L %L %L %L %L]" prop_name prop_val prop_vis
						    lx ly prop_just prop_font prop_color
						) 
						(trl_altium2hdl_global->exeption)
					    ))
				    )
				)
			    ) 
			    index++
			)
		    ) else t
		)
	    )
	) 
	unless(ref_des_pref 
	    fprintf(port "P \"$LOCATION\" \"U?\" 0 0 0.00 0.00 47 0 0 0 0 0 1 0 32\n") 
	    (ref_des_pref = "U")
	) 
	fprintf(port "P \"PATH\" \"?\" 0 0 0.00 0.00 47 0 0 0 0 0 0 0 32\n") 
	when(exceptions_list 
	    foreach(exception exceptions_list 
		unless((car(exception) == upperCase("JEDEC_TYPE")) 
		    fprintf(port "P \"%s\" \"%s\" 0 0 0.00 0.00 47 0 0 0 0 0 0 0 32\n" 
			car(exception) 
			cadr(exception)
		    )
		)
	    )
	)
	list(ref_des_pref key_list jedecType)
    )
)
procedure(TRL_ALTIUM2HDL_Create_Concept_Symbol_Line(sym_rec curr_id loc_x loc_y rot
	mirr port display
    ) 
    let((index id lx ly cx
	    cy lwidth min_x max_y rotation
	    ll ur record disp_mode l_width
	) 
	(min_x = 1000000) 
	(max_y = -1000000) 
	(index = 0) 
	(loc_x = atoi(loc_x))
	(loc_y = atoi(loc_y)) 
	when(mirr 
	    (rotation = 0.0) 
	    (mirr = t)
	) 
	when(rot 
	    case(rot 
		("1" 
		    (rotation = -90.0)
		) 
		("2" 
		    (rotation = -180.0)
		) 
		("3" 
		    (rotation = -270.0)
		) 
		(t 
		    (trl_altium2hdl_global->exeption = cons(sprintf(nil "-->3.3.01 ERROR   - Symbol LINE -> Unknown Rotation Code: %L %L" rot mirr) 
			    (trl_altium2hdl_global->exeption)
			))
		)
	    )
	) 
	foreach(rec sym_rec 
	    (id = get(rec 
		    'OWNERPARTID
		)) 
	    (record = get(rec 
		    'RECORD
		)) 
	    (disp_mode = get(rec 
		    'OWNERPARTDISPLAYMODE
		))
	    if(display then 
		if((disp_mode == display) then 
		    (disp_mode = t) else 
		    (disp_mode = nil)
		) else 
		if(disp_mode then 
		    (disp_mode = nil) else 
		    (disp_mode = t)
		)
	    ) 
	    when(((id == curr_id) && (record == "13") && disp_mode) 
		(lx = get(rec 
			'LOCATION\.X
		    )) 
		(ly = get(rec 
			'LOCATION\.Y
		    )) 
		(cx = get(rec 
			'CORNER\.X
		    )) 
		(cy = get(rec 
			'CORNER\.Y
		    ))
		(lwidth = get(rec 
			'LINEWIDTH
		    )) 
		when((cx && cy && lx && ly) 
		    (lx = ((atoi(lx) - loc_x) * 5.0)) 
		    (ly = ((atoi(ly) - loc_y) * 5.0)) 
		    (cx = ((atoi(cx) - loc_x) * 5.0)) 
		    (cy = ((atoi(cy) - loc_y) * 5.0))
		    if((rot || mirr) then 
			(ll = (axlGeoRotatePt rotation 
				(lx:ly) 
				(0.0:0.0) mirr
			    )) 
			(ur = (axlGeoRotatePt rotation 
				(cx:cy) 
				(0.0:0.0) mirr
			    )) 
			(lx = round(car(ll)))
			(ly = round(cadr(ll))) 
			(cx = round(car(ur))) 
			(cy = round(cadr(ur))) else 
			(lx = round(lx))
			(ly = round(ly)) 
			(cx = round(cx)) 
			(cy = round(cy))
		    ) 
		    unless(lwidth 
			(l_width = "L")
		    ) 
		    when((lwidth == "1") 
			(l_width = "L")
		    ) 
		    when((lwidth == "2") 
			(l_width = "M")
		    ) 
		    fprintf(port "%s %d %d %d %d -1 16\n" l_width lx ly
			cx cy
		    )
		    index++
		)
	    )
	) 
	when((index > 0) 
	    (trl_altium2hdl_global->exeption = cons(sprintf(nil "   3.3.02 INFO    - [%5d] Symbol LINES -> Created" index) 
		    (trl_altium2hdl_global->exeption)
		))
	)
	list(min_x max_y)
    )
)
procedure(TRL_ALTIUM2HDL_Create_Concept_Symbol_Pin(sym_rec curr_id loc_x loc_y rot
	mirr port
    ) 
    let((lx ly pl pname pvalue
	    s_out pin_c dispx dispy symindex
	    t_size name mirror rotate xy
	    min_x max_y tmp_name dname inv_flag
	    electrical s_out_e record pins id
	    rec coor_l index nc_pins tmp_str
	    PinOverLapp stub_lx stub_ly stub_xy PackShortGr
	    ret tdisx tdisy
	) 
	(min_x = 1000000) 
	(max_y = -1000000) 
	(index = 0) 
	(coor_l = list())
	(nc_pins = list()) 
	when(mirr 
	    (mirror = t) 
	    (rotate = 0.0)
	) 
	when(rot 
	    case(rot 
		("1" 
		    (rotate = -90.0)
		) 
		("2" 
		    (rotate = -180.0)
		) 
		("3" 
		    (rotate = -270.0)
		) 
		(t 
		    printf("----> was ist los hier bei rotate symbolpin %L\n" rot)
		)
	    )
	) 
	(ret = TRL_ALTIUM2HDL_Check_Overlapping_Pin(curr_id sym_rec)) 
	(PinOverLapp = car(ret))
	(PackShortGr = cadr(ret)) 
	(symindex = 1) 
	foreach(recs sym_rec 
	    (dname = nil) 
	    (inv_flag = nil) 
	    (rec = car(last(recs)))
	    (id = get(rec 
		    'OWNERPARTID
		)) 
	    (record = get(rec 
		    'RECORD
		)) 
	    when(((id == curr_id) && (record == "2")) 
		(pins = t) 
		(lx = get(rec 
			'LOCATION\.X
		    )) 
		(ly = get(rec 
			'LOCATION\.Y
		    )) 
		(pin_c = get(rec 
			'PINCONGLOMERATE
		    ))
		unless(lx 
		    (lx = "0")
		) 
		unless(ly 
		    (ly = "0")
		) 
		(lx = atoi(lx)) 
		(ly = atoi(ly)) 
		(stub_lx = lx)
		(stub_ly = ly) 
		when(PinOverLapp 
		    if(member((lx:ly) PinOverLapp) then 
			if(member((lx:ly) coor_l) then 
			    while(member((lx:ly) coor_l) 
				case(pin_c 
				    ("32" 
					lx--
				    ) 
				    ("40" 
					lx--
				    ) 
				    ("48" 
					lx--
				    ) 
				    ("56" 
					lx--
				    )
				    ("33" 
					ly--
				    ) 
				    ("41" 
					ly--
				    ) 
				    ("49" 
					ly--
				    ) 
				    ("57" 
					ly--
				    ) 
				    ("34" 
					lx++
				    )
				    ("42" 
					lx++
				    ) 
				    ("50" 
					lx++
				    ) 
				    ("58" 
					lx++
				    ) 
				    ("35" 
					ly++
				    ) 
				    ("43" 
					ly++
				    )
				    ("51" 
					ly++
				    ) 
				    ("59" 
					ly++
				    ) 
				    (t 
					lx++ 
					ly++
				    )
				)
			    ) 
			    (coor_l = cons((lx:ly) coor_l)) else
			    (coor_l = cons((lx:ly) coor_l))
			) else 
			(coor_l = cons((lx:ly) coor_l))
		    )
		) 
		(pl = get(rec 
			'PINLENGTH
		    )) 
		(name = get(rec 
			'NAME
		    )) 
		(pvalue = get(rec 
			'DESIGNATOR
		    ))
		(s_out_e = get(rec 
			'SYMBOL_OUTEREDGE
		    )) 
		(s_out = get(rec 
			'SYMBOL_OUTER
		    )) 
		(electrical = get(rec 
			'ELECTRICAL
		    )) 
		(pname = cadr(recs)) 
		(tmp_name = parseString(pname "_"))
		when((car(last(tmp_name)) == "NNN") 
		    (tmp_name = cdr(reverse(tmp_name))) 
		    (tmp_name = reverse(tmp_name)) 
		    (tmp_name = buildString(tmp_name)) 
		    (pname = sprintf(nil "%s*" tmp_name))
		    (dname = sprintf(nil "%s*" tmp_name)) 
		    (inv_flag = t)
		) 
		unless(dname 
		    (dname = name)
		) 
		when(pin_c 
		    (ret = TRL_ALTIUM2HDL_Create_Concept_PINCONGLOMERATE(pin_c rot mirr pname dname
			    pvalue nc_pins rotate
			)) 
		    (pin_c = car(ret)) 
		    (nc_pins = cadr(ret)) 
		    if((loc_x && loc_y) then 
			(lx = ((lx - atoi(loc_x)) * 5.0)) 
			(ly = ((ly - atoi(loc_y)) * 5.0)) 
			(stub_lx = ((stub_lx - atoi(loc_x)) * 5.0))
			(stub_ly = ((stub_ly - atoi(loc_y)) * 5.0)) else 
			printf("-SYMBOL PIN-> %L %L %L %L %L %L %L\n" lx ly pl loc_x
			    loc_y pname pvalue
			)
		    )
		    unless(pl 
			printf("-SYMBOL PIN-> %L %L %L %L %L %L %L\n" lx ly pl loc_x
			    loc_y pname pvalue
			) 
			(pl = "0")
		    ) 
		    (pl = (atoi(pl) * 5)) 
		    (t_size = 38) 
		    if((rot || mirr) then 
			(xy = (axlGeoRotatePt rotate 
				(lx:ly) 
				(0.0:0.0) mirror
			    )) 
			(lx = round(car(xy))) 
			(ly = round(cadr(xy)))
			(stub_xy = (axlGeoRotatePt rotate 
				(stub_lx:stub_ly) 
				(0.0:0.0) mirror
			    )) 
			(stub_lx = round(car(stub_xy))) 
			(stub_ly = round(cadr(stub_xy))) else 
			(lx = round(lx))
			(ly = round(ly)) 
			(stub_lx = round(stub_lx)) 
			(stub_ly = round(stub_ly))
		    ) 
		    unless(dname 
			(dname = "")
		    )
		    (dname = parseString(dname "\\")) 
		    if((length(dname) == 1) then 
			(dname = TRL_ALTIUM2HDL_Preprocess_ASCII_File(car(dname))) else 
			(tmp_str = "")
			foreach(str dname 
			    (tmp_str = sprintf(nil "%s%s" tmp_str str))
			) 
			(dname = tmp_str) 
			(dname = TRL_ALTIUM2HDL_Preprocess_ASCII_File(dname))
		    ) 
		    rexCompile("[~]+") 
		    (dname = rexReplace(dname "_" 0)) 
		    rexCompile("\\[")
		    (pname = rexReplace(pname "_" 0)) 
		    rexCompile("\\]") 
		    (pname = rexReplace(pname "_" 0)) 
		    case(pin_c 
			("32" 
			    (dispx = (lx + pl)) 
			    (dispy = ly) 
			    fprintf(port "C %d %d %L %d %d 0 1 %d 0 C\n" 
				(lx + pl) ly pname
				dispx dispy t_size
			    ) 
			    fprintf(port "L %d %d %d %d -1 16\n" stub_lx stub_ly 
				(stub_lx + pl)
				stub_ly
			    )
			    fprintf(port "X \"$PN\" \"#\" %d %d 0.00 0.00 36 0 0 0 0 1 0 0 64\n" lx ly) 
			    when((lx < min_x) 
				(min_x = lx)
			    )
			) 
			("33" 
			    (dispx = lx) 
			    (dispy = (ly + pl)) 
			    fprintf(port "C %d %d %L %d %d 0 1 %d 0 L\n" lx 
				(ly + pl) pname
				dispx dispy t_size
			    ) 
			    fprintf(port "L %d %d %d %d -1 16\n" stub_lx stub_ly stub_lx
				(stub_ly + pl)
			    )
			    fprintf(port "X \"$PN\" \"#\" %d %d 90.00 0.00 36 0 0 0 0 1 1 0 64\n" lx ly) 
			    when((ly > max_y) 
				(max_y = ly)
			    )
			) 
			("34" 
			    (dispx = (lx - pl)) 
			    (dispy = ly) 
			    fprintf(port "C %d %d %L %d %d 0 1 %d 0 C\n" 
				(lx - pl) ly pname
				dispx dispy t_size
			    ) 
			    fprintf(port "L %d %d %d %d -1 16\n" 
				(stub_lx - pl) stub_ly stub_lx
				stub_ly
			    )
			    fprintf(port "X \"$PN\" \"#\" %d %d 0.00 0.00 36 0 0 2 0 1 0 0 64\n" lx ly) 
			    when((lx < min_x) 
				(min_x = lx)
			    )
			) 
			("35" 
			    (dispx = lx) 
			    (dispy = (ly - pl)) 
			    fprintf(port "C %d %d %L %d %d 0 1 %d 0 L\n" lx 
				(ly - pl) pname
				dispx dispy t_size
			    ) 
			    fprintf(port "L %d %d %d %d -1 16\n" stub_lx stub_ly stub_lx
				(stub_ly - pl)
			    )
			    fprintf(port "X \"$PN\" \"#\" %d %d 90.00 0.00 36 0 0 2 0 1 1 0 64\n" lx ly) 
			    when((lx < min_x) 
				(min_x = lx)
			    )
			)
			("40" 
			    (dispx = (lx - 20)) 
			    (dispy = (ly - round((t_size / 2)))) 
			    (tdisx = (stub_lx - 20)) 
			    (tdisy = (stub_ly - round((t_size / 2))))
			    fprintf(port "C %d %d %L %d %d 0 1 %d 0 C\n" 
				(lx + pl) ly pname
				dispx dispy t_size
			    ) 
			    fprintf(port "X \"PIN_TEXT\" %L %d %d 0.00 0.00 %d 0 0 2 0 0 1 0 64\n" dname tdisx tdisy
				t_size
			    ) 
			    fprintf(port "X \"$PN\" \"#\" %d %d 0.00 0.00 36 0 0 0 0 1 0 0 64\n" 
				(lx + 50) 
				(ly + 7)
			    ) 
			    fprintf(port "L %d %d %d %d -1 16\n" stub_lx stub_ly 
				(stub_lx + pl)
				stub_ly
			    ) 
			    when((lx < min_x) 
				(min_x = lx)
			    )
			) 
			("41" 
			    (dispx = (lx + round((t_size / 2)))) 
			    (dispy = (ly - 10)) 
			    (tdisx = (stub_lx + round((t_size / 2)))) 
			    (tdisy = (stub_ly - 10))
			    fprintf(port "C %d %d %L %d %d 0 1 %d 0 L\n" lx 
				(ly + pl) pname
				dispx dispy t_size
			    ) 
			    fprintf(port "X \"PIN_TEXT\" %L %d %d 90.00 0.00 %d 0 0 2 0 0 0 0 10\n" dname tdisx tdisy
				t_size
			    ) 
			    fprintf(port "X \"$PN\" \"#\" %d %d 90.00 0.00 36 0 0 0 0 1 1 0 64\n" 
				(lx - 7) 
				(ly + 50)
			    ) 
			    fprintf(port "L %d %d %d %d -1 16\n" stub_lx stub_ly stub_lx
				(stub_ly + pl)
			    ) 
			    when((ly > max_y) 
				(max_y = ly)
			    )
			) 
			("42" 
			    (dispx = (lx + 20)) 
			    (dispy = (ly - round((t_size / 2)))) 
			    (tdisx = (stub_lx + 20)) 
			    (tdisy = (stub_ly - round((t_size / 2))))
			    fprintf(port "C %d %d %L %d %d 0 1 %d 0 C\n" 
				(lx - pl) ly pname
				dispx dispy t_size
			    ) 
			    fprintf(port "X \"PIN_TEXT\" %L %d %d 0.00 0.00 %d 0 0 0 0 0 1 0 10\n" dname tdisx tdisy
				t_size
			    ) 
			    fprintf(port "X \"$PN\" \"#\" %d %d 0.00 0.00 36 0 0 2 0 1 0 0 64\n" 
				(lx - 50) 
				(ly + 7)
			    ) 
			    fprintf(port "L %d %d %d %d -1 16\n" 
				(stub_lx - pl) stub_ly stub_lx
				stub_ly
			    ) 
			    when((lx < min_x) 
				(min_x = lx)
			    )
			) 
			("43" 
			    (dispx = (lx + round((t_size / 2)))) 
			    (dispy = (ly + 10)) 
			    (tdisx = (stub_lx + round((t_size / 2)))) 
			    (tdisy = (stub_ly + 10))
			    fprintf(port "C %d %d %L %d %d 0 1 %d 0 L\n" lx 
				(ly - pl) pname
				dispx dispy t_size
			    ) 
			    fprintf(port "X \"PIN_TEXT\" %L %d %d 90.00 0.00 %d 0 0 0 0 0 1 0 10\n" dname tdisx tdisy
				t_size
			    ) 
			    fprintf(port "X \"$PN\" \"#\" %d %d 90.00 0.00 36 0 0 2 0 1 1 0 64\n" 
				(lx - 7) 
				(ly - 50)
			    ) 
			    fprintf(port "L %d %d %d %d -1 16\n" stub_lx stub_ly stub_lx
				(stub_ly - pl)
			    ) 
			    when((lx < min_x) 
				(min_x = lx)
			    )
			) 
			("48" 
			    (dispx = (lx + pl)) 
			    (dispy = ly) 
			    fprintf(port "C %d %d %L %d %d 0 1 %d 0 C\n" 
				(lx + pl) ly pname
				dispx dispy t_size
			    ) 
			    fprintf(port "L %d %d %d %d -1 16\n" stub_lx stub_ly 
				(stub_lx + pl)
				stub_ly
			    )
			    fprintf(port "X \"$PN\" \"?\" %d %d 0.00 0.00 36 0 0 0 0 1 1 0 64\n" 
				(lx + 50) 
				(ly + 7)
			    ) 
			    TRL_ALTIUM2HDL_Create_Concept_Symbol_Pin_Electrical_Representation("RIGHT" lx ly pl electrical
				inv_flag s_out s_out_e port
			    ) 
			    when((ly > max_y) 
				(max_y = ly)
			    )
			)
			("49" 
			    (dispx = lx) 
			    (dispy = (ly + pl)) 
			    fprintf(port "C %d %d %L %d %d 0 1 %d 0 L\n" lx 
				(ly + pl) pname
				dispx dispy t_size
			    ) 
			    fprintf(port "L %d %d %d %d -1 16\n" stub_lx stub_ly stub_lx
				(stub_ly + pl)
			    )
			    fprintf(port "X \"$PN\" \"?\" %d %d 90.00 0.00 36 0 0 0 0 1 1 0 64\n" 
				(lx - 7) 
				(ly + 50)
			    ) 
			    TRL_ALTIUM2HDL_Create_Concept_Symbol_Pin_Electrical_Representation("TOP" lx ly pl electrical
				inv_flag s_out s_out_e port
			    ) 
			    when((ly > max_y) 
				(max_y = ly)
			    )
			) 
			("50" 
			    (dispx = (lx - pl)) 
			    (dispy = ly) 
			    fprintf(port "C %d %d %L %d %d 0 1 %d 0 C\n" 
				(lx - pl) ly pname
				dispx dispy t_size
			    ) 
			    fprintf(port "L %d %d %d %d -1 16\n" 
				(stub_lx - pl) stub_ly stub_lx
				stub_ly
			    )
			    fprintf(port "X \"$PN\" \"?\" %d %d 0.00 0.00 36 0 0 2 0 1 1 0 64\n" 
				(lx - 50) 
				(ly + 7)
			    ) 
			    TRL_ALTIUM2HDL_Create_Concept_Symbol_Pin_Electrical_Representation("LEFT" lx ly pl electrical
				inv_flag s_out s_out_e port
			    ) 
			    when((lx < min_x) 
				(min_x = lx)
			    )
			) 
			("51" 
			    (dispx = lx) 
			    (dispy = (ly - pl)) 
			    fprintf(port "C %d %d %L %d %d 0 1 %d 0 L\n" lx 
				(ly - pl) pname
				dispx dispy t_size
			    ) 
			    fprintf(port "L %d %d %d %d -1 16\n" stub_lx stub_ly stub_lx
				(stub_ly - pl)
			    )
			    fprintf(port "X \"$PN\" \"?\" %d %d 90.00 0.00 36 0 0 2 0 1 1 0 64\n" 
				(lx - 7) 
				(ly - 50)
			    ) 
			    TRL_ALTIUM2HDL_Create_Concept_Symbol_Pin_Electrical_Representation("BOT" lx ly pl electrical
				inv_flag s_out s_out_e port
			    ) 
			    when((lx < min_x) 
				(min_x = lx)
			    )
			) 
			("56" 
			    (dispx = (lx - 24)) 
			    (dispy = (ly - round((t_size / 2)))) 
			    fprintf(port "C %d %d %L %d %d 0 1 %d 0 C\n" 
				(lx + pl) ly pname
				dispx dispy t_size
			    ) 
			    fprintf(port "X \"PIN_TEXT\" %L %d %d 0.00 0.00 %d 0 0 2 0 0 1 0 10\n" dname dispx dispy
				(t_size - 4)
			    )
			    fprintf(port "X \"$PN\" \"?\" %d %d 0.00 0.00 36 0 0 0 0 1 1 0 64\n" 
				(lx + 50) 
				(ly + 7)
			    ) 
			    TRL_ALTIUM2HDL_Create_Concept_Symbol_Pin_Electrical_Representation("RIGHT" lx ly pl electrical
				inv_flag s_out s_out_e port
			    ) 
			    when((lx < min_x) 
				(min_x = lx)
			    )
			) 
			("57" 
			    (dispx = (lx + round((t_size / 2)))) 
			    (dispy = (ly - 23)) 
			    fprintf(port "C %d %d %L %d %d 0 1 %d 0 L\n" lx 
				(ly + pl) pname
				dispx dispy t_size
			    ) 
			    fprintf(port "X \"PIN_TEXT\" %L %d %d 90.00 0.00 %d 0 0 2 0 0 0 0 10\n" dname dispx dispy
				(t_size - 4)
			    )
			    fprintf(port "X \"$PN\" \"?\" %d %d 90.00 0.00 36 0 0 0 0 1 1 0 64\n" 
				(lx - 7) 
				(ly + 50)
			    ) 
			    TRL_ALTIUM2HDL_Create_Concept_Symbol_Pin_Electrical_Representation("TOP" lx ly pl electrical
				inv_flag s_out s_out_e port
			    ) 
			    when((ly > max_y) 
				(max_y = ly)
			    )
			)
			("58" 
			    (dispx = (lx + 24)) 
			    (dispy = (ly - round((t_size / 2)))) 
			    fprintf(port "C %d %d %L %d %d 0 1 %d 0 C\n" 
				(lx - pl) ly pname
				dispx dispy t_size
			    ) 
			    fprintf(port "X \"PIN_TEXT\" %L %d %d 0.00 0.00 %d 0 0 0 0 0 1 0 10\n" dname dispx dispy
				(t_size - 4)
			    )
			    fprintf(port "X \"$PN\" \"?\" %d %d 0.00 0.00 36 0 0 2 0 1 1 0 64\n" 
				(lx - 50) 
				(ly + 7)
			    ) 
			    TRL_ALTIUM2HDL_Create_Concept_Symbol_Pin_Electrical_Representation("LEFT" lx ly pl electrical
				inv_flag s_out s_out_e port
			    ) 
			    when((lx < min_x) 
				(min_x = lx)
			    )
			) 
			("59" 
			    (dispx = (lx + round((t_size / 2)))) 
			    (dispy = (ly + 24)) 
			    fprintf(port "C %d %d %L %d %d 0 1 %d 0 L\n" lx 
				(ly - pl) pname
				dispx dispy t_size
			    ) 
			    fprintf(port "X \"PIN_TEXT\" %L %d %d 90.00 0.00 %d 0 0 0 0 0 1 0 10\n" dname dispx dispy
				(t_size - 4)
			    )
			    fprintf(port "X \"$PN\" \"?\" %d %d 90.00 0.00 36 0 0 2 0 1 1 0 64\n" 
				(lx - 7) 
				(ly - 50)
			    ) 
			    TRL_ALTIUM2HDL_Create_Concept_Symbol_Pin_Electrical_Representation("BOT" lx ly pl electrical
				inv_flag s_out s_out_e port
			    ) 
			    when((lx < min_x) 
				(min_x = lx)
			    )
			) 
			(t 
			    printf("--> PINCONGLOMERATE = %L\n" pin_c)
			)
		    )
		) 
		index++
	    )
	) 
	when((symindex > 1) 
	    (trl_altium2hdl_global->exeption = cons(sprintf(nil "   3.3.04 INFO    - [%5d] Logical Pins Created" symindex) 
		    (trl_altium2hdl_global->exeption)
		))
	) 
	when((index > 1) 
	    (trl_altium2hdl_global->exeption = cons(sprintf(nil "   3.3.01 INFO    - [%5d] Logical Pins Created" index) 
		    (trl_altium2hdl_global->exeption)
		))
	)
	list(pins min_x max_y nc_pins PinOverLapp
	    PackShortGr
	)
    )
)
procedure(TRL_ALTIUM2HDL_Create_Concept_Symbol_Pin_Electrical_Representation(side lx ly pl electrical
	inv_flag s_out s_out_e port
    ) 
    if((axlFormGetField 
	    (trl_altium2hdl_global->formid) "simple_sym_pin"
	) then 
	case(side 
	    ("RIGHT" 
		if(inv_flag then 
		    if((pl > 50) then 
			fprintf(port "L %d %d %d %d -1 16\n" 
			    (lx + 50) ly 
			    (lx + pl)
			    ly
			) 
			fprintf(port "A %d %d 25 0.00 360.0 74\n" 
			    (lx + 25) ly
			) else
			fprintf(port "A %d %d 25 0.00 360.0 74\n" 
			    (lx + 25) ly
			)
		    ) else 
		    fprintf(port "L %d %d %d %d -1 16\n" lx ly 
			(lx + pl)
			ly
		    )
		)
	    ) 
	    ("LEFT" 
		if(inv_flag then 
		    if((pl > 50) then 
			fprintf(port "L %d %d %d %d -1 16\n" 
			    (lx - 50) ly 
			    (lx - pl)
			    ly
			) 
			fprintf(port "A %d %d 25 0.00 360.0 74\n" 
			    (lx - 25) ly
			) else
			fprintf(port "A %d %d 25 0.00 360.0 74\n" 
			    (lx - 25) ly
			)
		    ) else 
		    fprintf(port "L %d %d %d %d -1 16\n" 
			(lx - pl) ly lx
			ly
		    )
		)
	    ) 
	    ("TOP" 
		if(inv_flag then 
		    if((pl > 50) then 
			fprintf(port "L %d %d %d %d -1 16\n" lx 
			    (ly + 50) lx
			    (ly + pl)
			) 
			fprintf(port "A %d %d 25 0.00 360.0 74\n" lx 
			    (ly + 25)
			) else
			fprintf(port "A %d %d 25 0.00 360.0 74\n" lx 
			    (ly + 25)
			)
		    ) else 
		    fprintf(port "L %d %d %d %d -1 16\n" lx 
			(ly + pl) lx
			ly
		    )
		)
	    ) 
	    ("BOT" 
		if(inv_flag then 
		    if((pl > 50) then 
			fprintf(port "L %d %d %d %d -1 16\n" lx 
			    (ly - 50) lx
			    (ly - pl)
			) 
			fprintf(port "A %d %d 25 0.00 360.0 74\n" lx 
			    (ly - 25)
			) else
			fprintf(port "A %d %d 25 0.00 360.0 74\n" lx 
			    (ly - 25)
			)
		    ) else 
		    fprintf(port "L %d %d %d %d -1 16\n" lx 
			(ly - pl) lx
			ly
		    )
		)
	    )
	    (t 
		printf("--SIDE->%L\n" side)
	    )
	) else 
	case(side 
	    ("RIGHT" 
		when(s_out_e 
		    printf("--RIGHT s_out_e->%L\n" s_out_e)
		) 
		when(s_out 
		    printf("--RIGHT s_out->%L\n" s_out)
		) 
		if((s_out && ((s_out == "2") || (s_out == "33") || (s_out == "34"))) then 
		    case(s_out 
			("2" 
			    fprintf(port "L %d %d %d %d -1 16\n" lx 
				(ly + 12) 
				(lx + 34)
				ly
			    ) 
			    fprintf(port "L %d %d %d %d -1 16\n" lx 
				(ly - 12) 
				(lx + 34)
				ly
			    ) 
			    when((pl > 34) 
				fprintf(port "L %d %d %d %d -1 16\n" 
				    (lx + 34) ly 
				    (lx + pl)
				    ly
				)
			    )
			) 
			("33" 
			    fprintf(port "L %d %d %d %d -1 16\n" lx ly 
				(lx + 34)
				(ly + 12)
			    ) 
			    fprintf(port "L %d %d %d %d -1 16\n" lx ly 
				(lx + 34)
				(ly - 12)
			    ) 
			    fprintf(port "L %d %d %d %d -1 16\n" 
				(lx + 34) 
				(ly + 12) 
				(lx + 34)
				(ly - 12)
			    ) 
			    when((pl > 34) 
				fprintf(port "L %d %d %d %d -1 16\n" 
				    (lx + 34) ly 
				    (lx + pl)
				    ly
				)
			    )
			) 
			("34" 
			    fprintf(port "L %d %d %d %d -1 16\n" lx ly 
				(lx + 34)
				(ly + 12)
			    ) 
			    fprintf(port "L %d %d %d %d -1 16\n" lx ly 
				(lx + 34)
				(ly - 12)
			    ) 
			    fprintf(port "L %d %d %d %d -1 16\n" 
				(lx + 34) 
				(ly + 12) 
				(lx + 34)
				(ly - 12)
			    ) 
			    fprintf(port "L %d %d %d %d -1 16\n" 
				(lx + 34) ly 
				(lx + 40)
				ly
			    )
			    fprintf(port "L %d %d %d %d -1 16\n" 
				(lx + 40) 
				(ly + 12) 
				(lx + 40)
				(ly - 12)
			    ) 
			    fprintf(port "L %d %d %d %d -1 16\n" 
				(lx + 40) 
				(ly + 12) 
				(lx + 74)
				ly
			    ) 
			    fprintf(port "L %d %d %d %d -1 16\n" 
				(lx + 40) 
				(ly - 12) 
				(lx + 74)
				ly
			    ) 
			    when((pl > 74) 
				fprintf(port "L %d %d %d %d -1 16\n" 
				    (lx + 74) ly 
				    (lx + pl)
				    ly
				)
			    )
			)
		    ) else 
		    unless(electrical 
			(electrical = "0")
		    )
		    case(electrical 
			("2" 
			    fprintf(port "L %d %d %d %d -1 16\n" lx 
				(ly + 12) 
				(lx + 34)
				ly
			    ) 
			    fprintf(port "L %d %d %d %d -1 16\n" lx 
				(ly - 12) 
				(lx + 34)
				ly
			    ) 
			    when((pl > 34) 
				fprintf(port "L %d %d %d %d -1 16\n" 
				    (lx + 34) ly 
				    (lx + pl)
				    ly
				)
			    )
			) 
			("0" 
			    fprintf(port "L %d %d %d %d -1 16\n" lx ly 
				(lx + 34)
				(ly + 12)
			    ) 
			    fprintf(port "L %d %d %d %d -1 16\n" lx ly 
				(lx + 34)
				(ly - 12)
			    ) 
			    fprintf(port "L %d %d %d %d -1 16\n" 
				(lx + 34) 
				(ly + 10) 
				(lx + 34)
				(ly - 12)
			    ) 
			    when((pl > 34) 
				fprintf(port "L %d %d %d %d -1 16\n" 
				    (lx + 34) ly 
				    (lx + pl)
				    ly
				)
			    )
			) 
			("1" 
			    fprintf(port "L %d %d %d %d -1 16\n" lx ly 
				(lx + 34)
				(ly + 12)
			    ) 
			    fprintf(port "L %d %d %d %d -1 16\n" lx ly 
				(lx + 34)
				(ly - 12)
			    ) 
			    fprintf(port "L %d %d %d %d -1 16\n" 
				(lx + 34) 
				(ly + 12) 
				(lx + 34)
				(ly - 12)
			    ) 
			    fprintf(port "L %d %d %d %d -1 16\n" 
				(lx + 34) ly 
				(lx + 40)
				ly
			    )
			    fprintf(port "L %d %d %d %d -1 16\n" 
				(lx + 40) 
				(ly + 12) 
				(lx + 40)
				(ly - 12)
			    ) 
			    fprintf(port "L %d %d %d %d -1 16\n" 
				(lx + 40) 
				(ly + 12) 
				(lx + 74)
				ly
			    ) 
			    fprintf(port "L %d %d %d %d -1 16\n" 
				(lx + 40) 
				(ly - 12) 
				(lx + 74)
				ly
			    ) 
			    when((pl > 74) 
				fprintf(port "L %d %d %d %d -1 16\n" 
				    (lx + 74) ly 
				    (lx + pl)
				    ly
				)
			    )
			) 
			(t 
			    fprintf(port "L %d %d %d %d -1 16\n" lx ly 
				(lx + pl)
				ly
			    )
			)
		    )
		)
	    ) 
	    ("LEFT" 
		when(s_out_e 
		    case(s_out_e 
			("1" 
			    fprintf(port "A %d %d 17 0.00 360.0 74\n" 
				(lx - 17) ly
			    ) 
			    (lx = (lx - 34)) 
			    (pl = (pl - 34))
			)
		    )
		) 
		when(s_out 
		    printf("--LEFT s_out->%L\n" s_out)
		) 
		if((s_out && ((s_out == "2") || (s_out == "33") || (s_out == "34"))) then t else 
		    unless(electrical 
			(electrical = "0")
		    )
		    case(electrical 
			("2" 
			    fprintf(port "L %d %d %d %d -1 16\n" lx 
				(ly + 12) 
				(lx - 34)
				ly
			    ) 
			    fprintf(port "L %d %d %d %d -1 16\n" lx 
				(ly - 12) 
				(lx - 34)
				ly
			    ) 
			    when((pl > 34) 
				fprintf(port "L %d %d %d %d -1 16\n" 
				    (lx - 34) ly 
				    (lx - pl)
				    ly
				)
			    )
			) 
			("0" 
			    fprintf(port "L %d %d %d %d -1 16\n" lx ly 
				(lx - 34)
				(ly + 12)
			    ) 
			    fprintf(port "L %d %d %d %d -1 16\n" lx ly 
				(lx - 34)
				(ly - 12)
			    ) 
			    fprintf(port "L %d %d %d %d -1 16\n" 
				(lx - 34) 
				(ly + 12) 
				(lx - 34)
				(ly - 12)
			    ) 
			    when((pl > 34) 
				fprintf(port "L %d %d %d %d -1 16\n" 
				    (lx - 34) ly 
				    (lx - pl)
				    ly
				)
			    )
			) 
			("1" 
			    fprintf(port "L %d %d %d %d -1 16\n" lx ly 
				(lx - 34)
				(ly + 12)
			    ) 
			    fprintf(port "L %d %d %d %d -1 16\n" lx ly 
				(lx - 34)
				(ly - 12)
			    ) 
			    fprintf(port "L %d %d %d %d -1 16\n" 
				(lx - 34) 
				(ly + 12) 
				(lx - 34)
				(ly - 12)
			    ) 
			    fprintf(port "L %d %d %d %d -1 16\n" 
				(lx - 34) ly 
				(lx - 40)
				ly
			    )
			    fprintf(port "L %d %d %d %d -1 16\n" 
				(lx - 40) 
				(ly + 12) 
				(lx - 40)
				(ly - 12)
			    ) 
			    fprintf(port "L %d %d %d %d -1 16\n" 
				(lx - 40) 
				(ly + 12) 
				(lx - 74)
				ly
			    ) 
			    fprintf(port "L %d %d %d %d -1 16\n" 
				(lx - 40) 
				(ly - 12) 
				(lx - 74)
				ly
			    ) 
			    when((pl > 74) 
				fprintf(port "L %d %d %d %d -1 16\n" 
				    (lx - 74) ly 
				    (lx - pl)
				    ly
				)
			    )
			) 
			(t 
			    fprintf(port "L %d %d %d %d -1 16\n" lx ly 
				(lx - pl)
				ly
			    )
			)
		    )
		)
	    ) 
	    ("TOP" 
		when(s_out_e 
		    printf("--TOP s_out_e->%L\n" s_out_e) 
		    case(s_out_e 
			("1" 
			    fprintf(port "A %d %d 17 0.00 360.0 74\n" 
				(lx - 17) ly
			    ) 
			    (lx = (lx - 34)) 
			    (pl = (pl - 34))
			)
		    )
		) 
		when(s_out 
		    printf("--TOP s_out->%L\n" s_out)
		) 
		if((s_out && ((s_out == "2") || (s_out == "33") || (s_out == "34"))) then t else 
		    unless(electrical 
			(electrical = "0")
		    )
		    case(electrical 
			("2" 
			    fprintf(port "L %d %d %d %d -1 16\n" 
				(lx + 12) ly lx
				(ly + 34)
			    ) 
			    fprintf(port "L %d %d %d %d -1 16\n" 
				(lx - 12) ly lx
				(ly + 34)
			    ) 
			    when((pl > 34) 
				fprintf(port "L %d %d %d %d -1 16\n" lx 
				    (ly + 34) lx
				    (ly + pl)
				)
			    )
			) 
			("0" 
			    fprintf(port "L %d %d %d %d -1 16\n" lx ly 
				(lx + 12)
				(ly + 34)
			    ) 
			    fprintf(port "L %d %d %d %d -1 16\n" lx ly 
				(lx - 12)
				(ly + 34)
			    ) 
			    fprintf(port "L %d %d %d %d -1 16\n" 
				(lx - 12) 
				(ly + 34) 
				(lx + 12)
				(ly + 34)
			    ) 
			    when((pl > 34) 
				fprintf(port "L %d %d %d %d -1 16\n" lx 
				    (ly + 34) lx
				    (ly + pl)
				)
			    )
			) 
			("1" 
			    fprintf(port "L %d %d %d %d -1 16\n" lx ly 
				(lx + 12)
				(ly + 34)
			    ) 
			    fprintf(port "L %d %d %d %d -1 16\n" lx ly 
				(lx - 12)
				(ly + 34)
			    ) 
			    fprintf(port "L %d %d %d %d -1 16\n" 
				(lx - 12) 
				(ly + 34) 
				(lx + 12)
				(ly + 34)
			    ) 
			    fprintf(port "L %d %d %d %d -1 16\n" lx 
				(ly + 34) lx
				(ly + 40)
			    )
			    fprintf(port "L %d %d %d %d -1 16\n" 
				(lx + 12) 
				(ly + 40) 
				(lx - 12)
				(ly + 40)
			    ) 
			    fprintf(port "L %d %d %d %d -1 16\n" 
				(lx - 12) 
				(ly + 40) lx
				(ly + 74)
			    ) 
			    fprintf(port "L %d %d %d %d -1 16\n" 
				(lx + 12) 
				(ly + 40) lx
				(ly + 74)
			    ) 
			    when((pl > 74) 
				fprintf(port "L %d %d %d %d -1 16\n" lx 
				    (ly + 74) lx
				    (ly + pl)
				)
			    )
			) 
			(t 
			    fprintf(port "L %d %d %d %d -1 16\n" lx ly lx
				(ly + pl)
			    )
			)
		    )
		)
	    ) 
	    ("BOT" 
		when(s_out_e 
		    printf("--TOP s_out_e->%L\n" s_out_e) 
		    case(s_out_e 
			("1" 
			    fprintf(port "A %d %d 17 0.00 360.0 74\n" 
				(lx - 17) ly
			    ) 
			    (lx = (lx - 34)) 
			    (pl = (pl - 34))
			)
		    )
		) 
		when(s_out 
		    printf("--BOT s_out->%L\n" s_out)
		) 
		if((s_out && ((s_out == "2") || (s_out == "33") || (s_out == "34"))) then t else 
		    unless(electrical 
			(electrical = "0")
		    )
		    case(electrical 
			("2" 
			    fprintf(port "L %d %d %d %d -1 16\n" 
				(lx + 12) ly lx
				(ly - 34)
			    ) 
			    fprintf(port "L %d %d %d %d -1 16\n" 
				(lx - 12) ly lx
				(ly - 34)
			    ) 
			    when((pl > 34) 
				fprintf(port "L %d %d %d %d -1 16\n" lx 
				    (ly - 34) lx
				    (ly - pl)
				)
			    )
			) 
			("0" 
			    fprintf(port "L %d %d %d %d -1 16\n" lx ly 
				(lx + 12)
				(ly - 34)
			    ) 
			    fprintf(port "L %d %d %d %d -1 16\n" lx ly 
				(lx - 12)
				(ly - 34)
			    ) 
			    fprintf(port "L %d %d %d %d -1 16\n" 
				(lx - 12) 
				(ly - 34) 
				(lx + 12)
				(ly - 34)
			    ) 
			    when((pl > 34) 
				fprintf(port "L %d %d %d %d -1 16\n" lx 
				    (ly - 34) lx
				    (ly - pl)
				)
			    )
			) 
			("1" 
			    fprintf(port "L %d %d %d %d -1 16\n" lx ly 
				(lx + 12)
				(ly - 34)
			    ) 
			    fprintf(port "L %d %d %d %d -1 16\n" lx ly 
				(lx - 12)
				(ly - 34)
			    ) 
			    fprintf(port "L %d %d %d %d -1 16\n" 
				(lx - 12) 
				(ly - 34) 
				(lx + 12)
				(ly - 34)
			    ) 
			    fprintf(port "L %d %d %d %d -1 16\n" lx 
				(ly - 34) lx
				(ly - 40)
			    )
			    fprintf(port "L %d %d %d %d -1 16\n" 
				(lx + 12) 
				(ly - 40) 
				(lx - 12)
				(ly - 40)
			    ) 
			    fprintf(port "L %d %d %d %d -1 16\n" 
				(lx - 12) 
				(ly - 40) lx
				(ly - 74)
			    ) 
			    fprintf(port "L %d %d %d %d -1 16\n" 
				(lx + 12) 
				(ly - 40) lx
				(ly - 74)
			    ) 
			    when((pl > 74) 
				fprintf(port "L %d %d %d %d -1 16\n" lx 
				    (ly - 74) lx
				    (ly - pl)
				)
			    )
			) 
			(t 
			    fprintf(port "L %d %d %d %d -1 16\n" lx ly lx
				(ly - pl)
			    )
			)
		    )
		)
	    )
	    (t 
		printf("--side->%L\n" side)
	    )
	)
    )
)
procedure(TRL_ALTIUM2HDL_Create_Concept_Symbol_PolyLine(sym_rec curr_id loc_x loc_y rot
	mirr port cell_name display
    ) 
    let((id l_cnt l_points x_val y_val
	    start_x start_y x y min_x
	    max_y rotation ll solid record
	    disp_mode polyindex
	) 
	unless(cell_name 
	    printf("..Symbol_PolyLine->cell_name\n")
	) 
	(min_x = 1000000) 
	(max_y = -1000000) 
	(loc_x = atoi(loc_x))
	(loc_y = atoi(loc_y)) 
	(l_points = list()) 
	when(mirr 
	    (rotation = 0.0) 
	    (mirr = t)
	) 
	when(rot 
	    case(rot 
		("1" 
		    (rotation = -90.0)
		) 
		("2" 
		    (rotation = -180.0)
		) 
		("3" 
		    (rotation = -270.0)
		) 
		(t 
		    (trl_altium2hdl_global->exeption = cons(sprintf(nil "-->2.6.01 ERROR   - Symbol POLY -> Unknown Rotation Code: %L %L" rot mirr) 
			    (trl_altium2hdl_global->exeption)
			))
		)
	    )
	) 
	(polyindex = 1)
	foreach(rec sym_rec 
	    (record = get(rec 
		    'RECORD
		)) 
	    (id = get(rec 
		    'OWNERPARTID
		)) 
	    (disp_mode = get(rec 
		    'OWNERPARTDISPLAYMODE
		))
	    if(display then 
		if((disp_mode == display) then 
		    (disp_mode = t) else 
		    (disp_mode = nil)
		) else 
		if(disp_mode then 
		    (disp_mode = nil) else 
		    (disp_mode = t)
		)
	    ) 
	    when(((id == curr_id) && ((record == "7") || (record == "6")) && disp_mode) 
		(l_cnt = get(rec 
			'LOCATIONCOUNT
		    )) 
		(solid = get(rec 
			'ISSOLID
		    )) 
		when(l_cnt 
		    (l_cnt = atoi(l_cnt)) 
		    for(index 1 l_cnt 
			(x_val = stringToSymbol(sprintf(nil "X%d" index))) 
			(x_val = get(rec x_val))
			(y_val = stringToSymbol(sprintf(nil "Y%d" index))) 
			(y_val = get(rec y_val)) 
			unless(x_val 
			    (x_val = "0")
			) 
			unless(y_val 
			    (y_val = "0")
			) 
			(x_val = atoi(x_val))
			(y_val = atoi(y_val)) 
			(x_val = ((x_val - loc_x) * 5.0)) 
			(y_val = ((y_val - loc_y) * 5.0)) 
			if((rot || mirr) then 
			    (ll = (axlGeoRotatePt rotation 
				    (x_val:y_val) 
				    (0.0:0.0) mirr
				)) 
			    (ll = (round(car(ll)):round(cadr(ll)))) else
			    (ll = (round(x_val):round(y_val)))
			) 
			(l_points = cons(ll l_points))
			index++
		    ) 
		    when(l_points 
			(start_x = caar(l_points)) 
			(start_y = cadar(l_points)) 
			if((length(l_points) > 2) then 
			    foreach(l_coor 
				cdr(l_points) 
				(x = car(l_coor)) 
				(y = cadr(l_coor)) 
				fprintf(port "L %d %d %d %d -1 16\n" start_x start_y x
				    y
				)
				(start_x = x) 
				(start_y = y)
			    ) 
			    when(solid 
				fprintf(port "L %d %d %d %d -1 16\n" start_x start_y 
				    caar(l_points)
				    cadar(l_points)
				)
			    ) else
			    fprintf(port "L %d %d %d %d -1 16\n" start_x start_y 
				car(cadr(l_points))
				cadr(cadr(l_points))
			    )
			) 
			when((axlFormGetField 
				(trl_altium2hdl_global->formid) "verbose"
			    ) 
			    (trl_altium2hdl_global->exeption = cons(sprintf(nil "   2.6.03 INFO    - Symbol POLY -> L %d %d %d %d -1 16" start_x start_y 
					caar(l_points)
					cadar(l_points)
				    ) 
				    (trl_altium2hdl_global->exeption)
				)) 
			    polyindex++
			)
		    )
		)
	    ) 
	    (l_points = list())
	) 
	when((polyindex > 1) 
	    (trl_altium2hdl_global->exeption = cons(sprintf(nil "   2.6.03 INFO    - [%4d] Symbol POLYgons created" polyindex) 
		    (trl_altium2hdl_global->exeption)
		))
	) 
	list(min_x max_y)
    )
)
procedure(TRL_ALTIUM2HDL_Create_Concept_Symbol_RNDRectangle(sym_rec curr_id loc_x loc_y rot
	mirr port cell_name display
    ) 
    let((index id disp_mode min_x max_y
	    rotation ll solid record x1
	    y1 cx cy image_path ur
	) 
	(min_x = 1000000) 
	(max_y = -1000000) 
	(index = 0) 
	(loc_x = atoi(loc_x))
	(loc_y = atoi(loc_y)) 
	when(mirr 
	    (rotation = 0.0) 
	    (mirr = t)
	) 
	when(rot 
	    case(rot 
		("1" 
		    (rotation = -90.0)
		) 
		("2" 
		    (rotation = -180.0)
		) 
		("3" 
		    (rotation = -270.0)
		) 
		(t 
		    (trl_altium2hdl_global->exeption = cons(sprintf(nil "-->2.6.04 ERROR   - Symbol Rectangle -> Unknown Rotation Code: %L %L" rot mirr) 
			    (trl_altium2hdl_global->exeption)
			))
		)
	    )
	) 
	foreach(rec sym_rec 
	    (record = get(rec 
		    'RECORD
		)) 
	    (id = get(rec 
		    'OWNERPARTID
		)) 
	    (disp_mode = get(rec 
		    'OWNERPARTDISPLAYMODE
		))
	    if(display then 
		if((disp_mode == display) then 
		    (disp_mode = t) else 
		    (disp_mode = nil)
		) else 
		if(disp_mode then 
		    (disp_mode = nil) else 
		    (disp_mode = t)
		)
	    ) 
	    when(((id == curr_id) && (record == "10") && disp_mode) 
		(x1 = get(rec 
			'LOCATION\.X
		    )) 
		(y1 = get(rec 
			'LOCATION\.Y
		    )) 
		(cx = get(rec 
			'CORNER\.X
		    )) 
		(cy = get(rec 
			'CORNER\.Y
		    ))
		(solid = get(rec 
			'ISSOLID
		    )) 
		if((x1 && y1 && cx && cy) then 
		    (x1 = ((atoi(x1) - loc_x) * 5.0)) 
		    (y1 = ((atoi(y1) - loc_y) * 5.0)) 
		    (cx = ((atoi(cx) - loc_x) * 5.0))
		    (cy = ((atoi(cy) - loc_y) * 5.0)) 
		    if((rot || mirr) then 
			(ll = (axlGeoRotatePt rotation 
				(x1:y1) 
				(0.0:0.0) mirr
			    )) 
			(ur = (axlGeoRotatePt rotation 
				(cx:cy) 
				(0.0:0.0) mirr
			    )) 
			(x1 = round(car(ll)))
			(y1 = round(cadr(ll))) 
			(cx = round(car(ur))) 
			(cy = round(cadr(ur))) else 
			(x1 = round(x1))
			(y1 = round(y1)) 
			(cx = round(cx)) 
			(cy = round(cy))
		    ) 
		    fprintf(port "L %d %d %d %d -1 16\n" x1 y1 x1
			cy
		    ) 
		    fprintf(port "L %d %d %d %d -1 16\n" x1 cy cx
			cy
		    ) 
		    fprintf(port "L %d %d %d %d -1 16\n" cx cy cx
			y1
		    )
		    fprintf(port "L %d %d %d %d -1 16\n" cx y1 x1
			y1
		    ) 
		    when((solid == "T") 
			unless(((axlFormGetField 
				    (trl_altium2hdl_global->formid) "orcad_flow"
				) || (axlFormGetField 
				    (trl_altium2hdl_global->formid) "simple_sym_graphic"
				)) 
			    unless(isDir(strcat(cell_name "/" "images")) 
				createDir(strcat(cell_name "/" "images"))
			    ) 
			    (image_path = nth(4 
				    (trl_altium2hdl_global->files)
				)) 
			    (image_path = strcat(image_path "/" 
				    nth(5 
					(trl_altium2hdl_global->files)
				    )
				)) 
			    (image_path = strcat(image_path "/images"))
			    (axlOSFileCopy 
				strcat(image_path "/body.jpg") 
				strcat(cell_name "/images/body.jpg") nil
			    ) 
			    fprintf(port "T %d %d 0.00 0.00 47 0 0 1 0 30 0\n" 
				(x1 + ((cx - x1) / 2)) 
				(cy - ((cy - y1) / 2))
			    ) 
			    fprintf(port "$CDS_IMAGE|body.jpg|%d|%d\n" 
				(cx - x1) 
				(cy - y1)
			    )
			)
		    ) 
		    index++ else 
		    (trl_altium2hdl_global->exeption = cons(sprintf(nil "   2.7.07 ERROR   - Symbol RECTANGLE -> L %d %d %d %d -1 16" x1 y1 cx
				cy
			    ) 
			    (trl_altium2hdl_global->exeption)
			))
		)
	    )
	) 
	when((index > 0) 
	    (trl_altium2hdl_global->exeption = cons(sprintf(nil "   3.3.06 INFO    - [%5d] Symbol ROUNDRECTANGLE -> Created" index) 
		    (trl_altium2hdl_global->exeption)
		))
	)
	list(min_x max_y)
    )
)
procedure(TRL_ALTIUM2HDL_Create_Concept_Symbol_Rectangle(sym_rec curr_id loc_x loc_y rot
	mirr port cell_name display
    ) 
    let((index id disp_mode min_x max_y
	    rotation ll solid record x1
	    y1 cx cy image_path ur
	) 
	(min_x = 1000000) 
	(max_y = -1000000) 
	(index = 0) 
	(loc_x = atoi(loc_x))
	(loc_y = atoi(loc_y)) 
	when(mirr 
	    (rotation = 0.0) 
	    (mirr = t)
	) 
	when(rot 
	    case(rot 
		("1" 
		    (rotation = -90.0)
		) 
		("2" 
		    (rotation = -180.0)
		) 
		("3" 
		    (rotation = -270.0)
		) 
		(t 
		    (trl_altium2hdl_global->exeption = cons(sprintf(nil "-->3.3.07 ERROR   - Symbol Rectangle -> Unknown Rotation Code: %L %L" rot mirr) 
			    (trl_altium2hdl_global->exeption)
			))
		)
	    )
	) 
	foreach(rec sym_rec 
	    (record = get(rec 
		    'RECORD
		)) 
	    (id = get(rec 
		    'OWNERPARTID
		)) 
	    (disp_mode = get(rec 
		    'OWNERPARTDISPLAYMODE
		))
	    if(display then 
		if((disp_mode == display) then 
		    (disp_mode = t) else 
		    (disp_mode = nil)
		) else 
		if(disp_mode then 
		    (disp_mode = nil) else 
		    (disp_mode = t)
		)
	    ) 
	    when(((id == curr_id) && (record == "14") && disp_mode) 
		(x1 = get(rec 
			'LOCATION\.X
		    )) 
		(y1 = get(rec 
			'LOCATION\.Y
		    )) 
		(cx = get(rec 
			'CORNER\.X
		    )) 
		(cy = get(rec 
			'CORNER\.Y
		    ))
		(solid = get(rec 
			'ISSOLID
		    )) 
		if((x1 && y1 && cx && cy) then 
		    (x1 = ((atoi(x1) - loc_x) * 5.0)) 
		    (y1 = ((atoi(y1) - loc_y) * 5.0)) 
		    (cx = ((atoi(cx) - loc_x) * 5.0))
		    (cy = ((atoi(cy) - loc_y) * 5.0)) 
		    if((rot || mirr) then 
			(ll = (axlGeoRotatePt rotation 
				(x1:y1) 
				(0.0:0.0) mirr
			    )) 
			(ur = (axlGeoRotatePt rotation 
				(cx:cy) 
				(0.0:0.0) mirr
			    )) 
			(x1 = round(car(ll)))
			(y1 = round(cadr(ll))) 
			(cx = round(car(ur))) 
			(cy = round(cadr(ur))) else 
			(x1 = round(x1))
			(y1 = round(y1)) 
			(cx = round(cx)) 
			(cy = round(cy))
		    ) 
		    fprintf(port "L %d %d %d %d -1 16\n" x1 y1 x1
			cy
		    ) 
		    fprintf(port "L %d %d %d %d -1 16\n" x1 cy cx
			cy
		    ) 
		    fprintf(port "L %d %d %d %d -1 16\n" cx cy cx
			y1
		    )
		    fprintf(port "L %d %d %d %d -1 16\n" cx y1 x1
			y1
		    ) 
		    when((solid == "T") 
			unless(((axlFormGetField 
				    (trl_altium2hdl_global->formid) "orcad_flow"
				) || (axlFormGetField 
				    (trl_altium2hdl_global->formid) "simple_sym_graphic"
				)) 
			    unless(isDir(strcat(cell_name "/" "images")) 
				createDir(strcat(cell_name "/" "images"))
			    ) 
			    (image_path = nth(4 
				    (trl_altium2hdl_global->files)
				)) 
			    (image_path = strcat(image_path "/" 
				    nth(5 
					(trl_altium2hdl_global->files)
				    )
				)) 
			    (image_path = strcat(image_path "/images"))
			    (axlOSFileCopy 
				strcat(image_path "/body.jpg") 
				strcat(cell_name "/images/body.jpg") nil
			    ) 
			    fprintf(port "T %d %d 0.00 0.00 47 0 0 1 0 30 0\n" 
				(x1 + ((cx - x1) / 2)) 
				(cy - ((cy - y1) / 2))
			    ) 
			    fprintf(port "$CDS_IMAGE|body.jpg|%d|%d\n" 
				(cx - x1) 
				(cy - y1)
			    )
			)
		    ) 
		    index++ else 
		    (trl_altium2hdl_global->exeption = cons(sprintf(nil "   2.7.07 ERROR   - Symbol RECTANGLE -> L %d %d %d %d -1 16" x1 y1 cx
				cy
			    ) 
			    (trl_altium2hdl_global->exeption)
			))
		)
	    )
	) 
	when((index > 0) 
	    (trl_altium2hdl_global->exeption = cons(sprintf(nil "   3.3.07 INFO    - [%5d] Symbol RECTANGLE -> Created" index) 
		    (trl_altium2hdl_global->exeption)
		))
	)
	list(min_x max_y)
    )
)
procedure(TRL_ALTIUM2HDL_Create_Concept_Symbol_Text(sym_rec curr_id loc_x loc_y rot
	mirr port
    ) 
    let((lx ly prop_val prop_name prop_just
	    prop_vis prop_font prop_color ref_des_pref index
	    key_list sym_part prop_size prop_rot power_port
	    record created id
	) 
	(key_list = list()) 
	(index = 1) 
	foreach(rec sym_rec 
	    (record = get(rec 
		    'RECORD
		)) 
	    (id = get(rec 
		    'OWNERPARTID
		)) 
	    (power_port = get(rec 
		    'SHOWNETNAME
		))
	    unless(power_port 
		(prop_val = get(rec 
			'TEXT
		    )) 
		(prop_name = get(rec 
			'NAME
		    )) 
		when(prop_val 
		    (prop_name = get(rec 
			    'NAME
			)) 
		    unless((prop_name == "PinUniqueId") 
			(lx = get(rec 
				'LOCATION\.X
			    )) 
			(ly = get(rec 
				'LOCATION\.Y
			    )) 
			when((lx && ly) 
			    when(mirr 
				(mirr = t)
			    ) 
			    (lx = ((atoi(lx) - atoi(loc_x)) * 5)) 
			    (ly = ((atoi(ly) - atoi(loc_y)) * 5)) 
			    if((rot || mirr) then 
				(lx = round(lx)) 
				(ly = round(ly)) else
				(lx = round(lx)) 
				(ly = round(ly))
			    )
			    (prop_just = get(rec 
				    'JUSTIFICATION
				)) 
			    (prop_rot = get(rec 
				    'ORIENTATION
				)) 
			    (prop_vis = get(rec 
				    'ISHIDDEN
				)) 
			    (prop_font = get(rec 
				    'FONTID
				)) 
			    (prop_color = get(rec 
				    'COLOR
				))
			    if((prop_vis == "T") then 
				(prop_vis = 0) else 
				(prop_vis = 1)
			    ) 
			    unless(prop_just 
				(prop_just = "0")
			    ) 
			    if(prop_font then 
				(prop_size = TRL_ALTIUM2HDL_SCH_Util_Font_ID(prop_font)) 
				(prop_size = car(prop_size)) else
				(prop_size = 20)
			    ) 
			    if(prop_rot then 
				case(prop_rot 
				    ("1" 
					(prop_rot = 90.0)
				    ) 
				    ("2" 
					(prop_rot = 180.0)
				    ) 
				    ("3" 
					(prop_rot = 270.0)
				    ) 
				    (t 
					printf("----> was ist los hier bei rotate sym PROP ROT %L\n" rot)
				    )
				) else 
				(prop_rot = 0.0)
			    ) 
			    case(prop_just 
				("0" 
				    (prop_just = 0)
				) 
				("1" 
				    (prop_just = 1)
				) 
				("2" 
				    (prop_just = 2)
				) 
				("3" 
				    (prop_just = 0) 
				    (ly = (ly - (prop_size / 2)))
				)
				("4" 
				    (prop_just = 1) 
				    (ly = (ly - (prop_size / 2)))
				) 
				("5" 
				    (prop_just = 2) 
				    (ly = (ly - (prop_size / 2)))
				) 
				("6" 
				    (prop_just = 0) 
				    (ly = (ly - prop_size))
				) 
				("7" 
				    (prop_just = 1) 
				    (ly = (ly - prop_size))
				) 
				("8" 
				    (prop_just = 2) 
				    (ly = (ly - prop_size))
				)
				(t 
				    (prop_just = 0)
				)
			    )
			    if(prop_name then 
				(created = nil) 
				when((record == "34") 
				    (prop_name = "$LOCATION") 
				    (ref_des_pref = car(parseString(prop_val ""))) 
				    (prop_val = sprintf(nil "%s?" ref_des_pref)) 
				    (created = t)
				) 
				when((record == "4") 
				    printf("--REC4: %L %L\n" id curr_id) 
				    when((id == curr_id) 
					(created = t)
				    )
				)
				when(created 
				    fprintf(port "P %L %L %d %d %L 0.00 %d 0 0 %d 0 0 %d 0 10\n" prop_name prop_val lx
					ly prop_rot prop_size prop_just prop_vis
				    )
				) else 
				unless(prop_name 
				    (prop_name = sprintf(nil "tmp_prop_%d" index))
				) 
				fprintf(port "P %L %L %d %d %L 0.00 %d 0 0 %d 0 0 %d 0 10\n" prop_name prop_val lx
				    ly prop_rot prop_size prop_just prop_vis
				) 
				(trl_altium2hdl_global->exeption = cons(sprintf(nil "   3.5.1  INFO    - Symbols Property: %L Value: %L Vis: %L Created [%L %L %L %L %L]" prop_name prop_val prop_vis
					    lx ly prop_just prop_font prop_color
					) 
					(trl_altium2hdl_global->exeption)
				    ))
			    ) 
			    index++
			)
		    )
		)
	    )
	) 
	unless(sym_part 
	    fprintf(port "P \"PART_NUMBER\" \"?\" 0 0 0.00 0.00 47 0 0 0 0 0 0 0 32\n")
	)
	unless(ref_des_pref 
	    fprintf(port "P \"$LOCATION\" \"U?\" 0 0 0.00 0.00 47 0 0 0 0 0 1 0 32\n") 
	    (ref_des_pref = "U")
	) 
	fprintf(port "P \"PATH\" \"?\" 0 0 0.00 0.00 47 0 0 0 0 0 0 0 32\n") 
	list(ref_des_pref key_list)
    )
)
procedure(TRL_ALTIUM2HDL_Create_Concept_View_Tag(view_name tag) 
    let((outPort) 
	if(isWritable(view_name) then 
	    (outPort = outfile(strcat(view_name "/master.tag"))) 
	    when(outPort 
		fprintf(outPort "%s\n" tag) 
		close(outPort)
	    ) else
	    printf("--NO View_Tag created: %L\n" view_name)
	)
    )
)
procedure(TRL_ALTIUM2HDL_Create_Concept_symbols() 
    let((lib_rec lib_ref lib_ref_org loc_x loc_y
	    rot mirr cell_name view_name outPort
	    pins pinTable ind orcad_bb cmd_str
	    label_data pinImpli lib_name sym_views display
	    itemId partcount nc_list nc_pins PackShortGr
	    ret sh_pins
	) 
	(trl_altium2hdl_global->exeption = cons("-------------------------------------------------------------------------------" 
		(trl_altium2hdl_global->exeption)
	    )) 
	(trl_altium2hdl_global->exeption = cons("   3.1.0  INFO    - Start to Create Generic (HDL) Symbols.." 
		(trl_altium2hdl_global->exeption)
	    )) 
	(trl_altium2hdl_global->exeption = cons("-------------------------------------------------------------------------------" 
		(trl_altium2hdl_global->exeption)
	    )) 
	(lib_name = nth(4 
		(trl_altium2hdl_global->files)
	    ))
	(lib_name = strcat(lib_name "/" 
		nth(5 
		    (trl_altium2hdl_global->files)
		)
	    )) 
	(lib_name = strcat(lib_name "/" 
		nth(7 
		    (trl_altium2hdl_global->files)
		)
	    )) 
	TRL_ALTIUM2HDL_Create_Generic_Symbol_List() 
	(trl_altium2hdl_global->exeption = cons(sprintf(nil "-->3.1.02 INFO    - [%5d] Symbol Definitions -> HDL Library: %L!" 
		    length((trl_altium2hdl_global->LibRawList)) lib_name
		) 
		(trl_altium2hdl_global->exeption)
	    )) 
	(trl_altium2hdl_global->exeption = cons("-------------------------------------------------------------------------------" 
		(trl_altium2hdl_global->exeption)
	    ))
	if((trl_altium2hdl_global->LibRawList) then 
	    unless(isDir(lib_name) 
		createDir(lib_name)
	    ) 
	    (ind = 1) 
	    (display = nil)
	    (label_data = list()) 
	    foreach(sym 
		(trl_altium2hdl_global->LibRawList) 
		(lib_rec = car(sym)) 
		(lib_ref_org = get(lib_rec 
			'LIBREFERENCE
		    )) 
		(loc_x = get(lib_rec 
			'LOCATION\.X
		    ))
		(loc_y = get(lib_rec 
			'LOCATION\.Y
		    )) 
		(rot = get(lib_rec 
			'ORIENTATION
		    )) 
		(mirr = get(lib_rec 
			'ISMIRRORED
		    )) 
		(partcount = get(lib_rec 
			'PARTCOUNT
		    )) 
		(display = get(lib_rec 
			'DISPLAYMODE
		    ))
		(itemId = get(lib_rec 
			'DESIGNITEMID
		    )) 
		unless(lib_ref_org 
		    (lib_ref_org = itemId)
		) 
		(lib_ref = TRL_ALTIUM2HDL_PCB_Util_Namemaper(lib_ref_org)) 
		(cell_name = strcat(lib_name "/" lib_ref)) 
		(cell_name = lowerCase(cell_name))
		unless(isDir(cell_name) 
		    createDir(cell_name)
		) 
		(trl_altium2hdl_global->exeption = cons(sprintf(nil "   3.3.02 INFO    - [%5d] Org: %L --> %L X:%L Y:%L ROT:%L MIRR:%L" ind lib_ref_org lib_ref
			    loc_x loc_y rot mirr
			) 
			(trl_altium2hdl_global->exeption)
		    )) 
		ind++ 
		(trl_altium2hdl_global->exeption = cons("                    -----------------------------------------------------------" 
			(trl_altium2hdl_global->exeption)
		    )) 
		(sym_views = TRL_ALTIUM2HDL_Find_Concept_Symbol_Views(sym partcount))
		(pinTable = TRL_ALTIUM2HDL_Pin_Mapping(sym sym_views display)) 
		(pinImpli = caddr(pinTable)) 
		(pins = cadr(pinTable)) 
		(pinTable = car(pinTable)) 
		(nc_pins = list())
		(sh_pins = list()) 
		foreach(view sym_views 
		    (trl_altium2hdl_global->exeption = cons(sprintf(nil "   3.3.03 INFO    - View: %L" view) 
			    (trl_altium2hdl_global->exeption)
			)) 
		    (view_name = strcat(cell_name "/" "sym_" view)) 
		    unless(isDir(view_name) 
			createDir(view_name)
		    )
		    TRL_ALTIUM2HDL_Create_Concept_View_Tag(view_name "symbol.css") 
		    (outPort = outfile(strcat(view_name "/symbol.css"))) 
		    when(outPort 
			(orcad_bb = list()) 
			(nc_list = list()) 
			(PackShortGr = list()) 
			(ret = TRL_ALTIUM2HDL_Create_Concept_Symbol_Pin(pins view loc_x loc_y rot
				mirr outPort
			    ))
			(nc_list = nth(3 ret)) 
			(PackShortGr = nth(5 ret)) 
			when(nc_list 
			    foreach(nc nc_list 
				(nc_pins = cons(nc nc_pins))
			    )
			) 
			when(PackShortGr 
			    foreach(gr PackShortGr 
				(sh_pins = cons(gr sh_pins))
			    )
			) 
			(orcad_bb = list())
			(orcad_bb = cdr(orcad_bb)) 
			(orcad_bb = cons(TRL_ALTIUM2HDL_Create_Concept_Symbol_Line(sym view loc_x loc_y rot
				    mirr outPort display
				) orcad_bb
			    )) 
			(orcad_bb = cons(TRL_ALTIUM2HDL_Create_Concept_Symbol_Rectangle(sym view loc_x loc_y rot
				    mirr outPort cell_name display
				) orcad_bb
			    )) 
			(orcad_bb = cons(TRL_ALTIUM2HDL_Create_Concept_Symbol_RNDRectangle(sym view loc_x loc_y rot
				    mirr outPort cell_name display
				) orcad_bb
			    )) 
			(orcad_bb = cons(TRL_ALTIUM2HDL_Create_Concept_Symbol_PolyLine(sym view loc_x loc_y rot
				    mirr outPort cell_name display
				) orcad_bb
			    ))
			(orcad_bb = cons(TRL_ALTIUM2HDL_Create_Concept_Symbol_Arc(sym view loc_x loc_y rot
				    mirr outPort display
				) orcad_bb
			    )) 
			(orcad_bb = cons(TRL_ALTIUM2HDL_Create_Concept_Symbol_Ellipse(sym view loc_x loc_y rot
				    mirr outPort display
				) orcad_bb
			    )) 
			(orcad_bb = cons(TRL_ALTIUM2HDL_Create_Concept_Symbol_EllipseArc(sym view loc_x loc_y rot
				    mirr outPort display
				) orcad_bb
			    )) 
			if(pins then 
			    (label_data = TRL_ALTIUM2HDL_Create_Concept_Symbol_Label(sym view loc_x loc_y rot
				    mirr outPort display 
				    list(list("JEDEC_TYPE" "?"))
				)) else 
			    (trl_altium2hdl_global->PackIgnore = cons(lib_ref 
				    (trl_altium2hdl_global->PackIgnore)
				))
			    (label_data = TRL_ALTIUM2HDL_Create_Concept_Symbol_Label(sym view loc_x loc_y rot
				    mirr outPort display 
				    list(list("PACK_IGNORE" "TRUE"))
				))
			)
		    ) 
		    close(outPort) 
		    (trl_altium2hdl_global->exeption = cons("                    -----------------------------------------------------------" 
			    (trl_altium2hdl_global->exeption)
			))
		) 
		when(pins 
		    (view_name = strcat(cell_name "/" "chips")) 
		    unless(isDir(view_name) 
			createDir(view_name)
		    ) 
		    TRL_ALTIUM2HDL_Create_Concept_View_Tag(view_name "chips.prt") 
		    (outPort = outfile(strcat(view_name "/chips.prt")))
		    TRL_ALTIUM2HDL_Create_Concept_Chips_PRT(pins sym_views pinTable pinImpli lib_ref
			label_data outPort nc_pins sh_pins
		    ) 
		    close(outPort)
		) 
		when((axlFormGetField 
			(trl_altium2hdl_global->formid) "ppt_flow"
		    ) 
		    (view_name = strcat(cell_name "/" "part_table")) 
		    unless(isDir(view_name) 
			createDir(view_name)
		    ) 
		    TRL_ALTIUM2HDL_Create_Concept_View_Tag(view_name "part.ptf") 
		    (outPort = outfile(strcat(view_name "/part.ptf")))
		    TRL_ALTIUM2HDL_Create_Concept_Part_Table(sym sym_views pinTable lib_ref outPort
			label_data
		    ) 
		    close(outPort)
		) 
		(cmd_str = "newgenasym")
		(cmd_str = sprintf(nil "%s -i %s" cmd_str cell_name)) 
		(cmd_str = sprintf(nil "%s -n %s -M > log_run.txt 2>&1" cmd_str lib_ref)) 
		sh(cmd_str) 
		(trl_altium2hdl_global->exeption = cons("-------------------------------------------------------------------------------" 
			(trl_altium2hdl_global->exeption)
		    )) 
		(trl_altium2hdl_global->Reference = cons(list(lib_ref_org lib_ref 
			    list(list("JEDEC_TYPE" 
				    nth(2 label_data)
				)
			    )
			) 
			(trl_altium2hdl_global->Reference)
		    ))
	    ) else t
	) 
	when((trl_altium2hdl_global->Reference) 
	    (axlFormSetFieldEditable 
		(trl_altium2hdl_global->formid) "create_reference" t
	    )
	) 
	(trl_altium2hdl_global->Reference = list(nil 
		(trl_altium2hdl_global->Reference)
	    )) 
	println("--END SYM--")
    )
)
procedure(TRL_ALTIUM2HDL_Create_Flow_Graphic() 
    let((altium_flow_grapic_handle) 
	(altium_flow_grapic_handle = (axlGRPDrwInit 
		(trl_altium2hdl_global->formid) "flow_graphic" 
		'TRL_ALTIUM2HDL_flow_graphic
	    )) 
	(axlGRPDrwUpdate altium_flow_grapic_handle)
    )
)
procedure(TRL_ALTIUM2HDL_Create_Generic_Symbol_List() 
    let((libref mirr rot lib_ref_list itemId) 
	(lib_ref_list = list()) 
	(trl_altium2hdl_global->LibRawList = list()) 
	(trl_altium2hdl_global->exeption = cons("   3.2.01 INFO    - Start to Make Generic Schematic Symbols.." 
		(trl_altium2hdl_global->exeption)
	    )) 
	foreach(sch 
	    (trl_altium2hdl_global->SchRawList) 
	    foreach(sym 
		cadddr(sch) 
		foreach(rec sym 
		    (libref = get(rec 
			    'LIBREFERENCE
			)) 
		    (itemId = get(rec 
			    'DESIGNITEMID
			)) 
		    unless(libref 
			(libref = itemId)
		    )
		    when(libref 
			(mirr = get(rec 
				'ISMIRRORED
			    )) 
			(rot = get(rec 
				'ORIENTATION
			    )) 
			unless((mirr || rot) 
			    unless(member(libref lib_ref_list) 
				(trl_altium2hdl_global->LibRawList = cons(sym 
					(trl_altium2hdl_global->LibRawList)
				    )) 
				(lib_ref_list = cons(libref lib_ref_list))
			    )
			)
		    )
		)
	    )
	)
	foreach(sch 
	    (trl_altium2hdl_global->SchRawList) 
	    foreach(sym 
		cadddr(sch) 
		foreach(rec sym 
		    (libref = get(rec 
			    'LIBREFERENCE
			)) 
		    (itemId = get(rec 
			    'DESIGNITEMID
			)) 
		    unless(libref 
			(libref = itemId)
		    )
		    when(libref 
			(mirr = get(rec 
				'ISMIRRORED
			    )) 
			(rot = get(rec 
				'ORIENTATION
			    )) 
			unless(mirr 
			    unless(member(libref lib_ref_list) 
				(trl_altium2hdl_global->LibRawList = cons(sym 
					(trl_altium2hdl_global->LibRawList)
				    )) 
				(lib_ref_list = cons(libref lib_ref_list))
			    )
			)
		    )
		)
	    )
	) 
	foreach(sch 
	    (trl_altium2hdl_global->SchRawList) 
	    foreach(sym 
		cadddr(sch) 
		foreach(rec sym 
		    (libref = get(rec 
			    'LIBREFERENCE
			)) 
		    (itemId = get(rec 
			    'DESIGNITEMID
			)) 
		    unless(libref 
			(libref = itemId)
		    )
		    when(libref 
			(mirr = get(rec 
				'ISMIRRORED
			    )) 
			(rot = get(rec 
				'ORIENTATION
			    )) 
			unless(rot 
			    unless(member(libref lib_ref_list) 
				(trl_altium2hdl_global->LibRawList = cons(sym 
					(trl_altium2hdl_global->LibRawList)
				    )) 
				(lib_ref_list = cons(libref lib_ref_list))
			    )
			)
		    )
		)
	    )
	) 
	foreach(sch 
	    (trl_altium2hdl_global->SchRawList) 
	    foreach(sym 
		cadddr(sch) 
		foreach(rec sym 
		    (libref = get(rec 
			    'LIBREFERENCE
			)) 
		    (itemId = get(rec 
			    'DESIGNITEMID
			)) 
		    unless(libref 
			(libref = itemId)
		    )
		    when(libref 
			(mirr = get(rec 
				'ISMIRRORED
			    )) 
			(rot = get(rec 
				'ORIENTATION
			    )) 
			unless(member(libref lib_ref_list) 
			    (trl_altium2hdl_global->LibRawList = cons(sym 
				    (trl_altium2hdl_global->LibRawList)
				)) 
			    (lib_ref_list = cons(libref lib_ref_list))
			)
		    )
		)
	    )
	) 
	if((trl_altium2hdl_global->LibRawList) then 
	    (trl_altium2hdl_global->exeption = cons(sprintf(nil "-->3.2.02 INFO    - %L Generic Parts in the Altium Schematic!" 
			length((trl_altium2hdl_global->LibRawList))
		    ) 
		    (trl_altium2hdl_global->exeption)
		)) else 
	    (trl_altium2hdl_global->exeption = cons(sprintf(nil "-->3.2.02 ERROR   - Generic Parts Problem!%L %L" 
			(trl_altium2hdl_global->LibRawList) lib_ref_list
		    ) 
		    (trl_altium2hdl_global->exeption)
		))
	) 
	(trl_altium2hdl_global->exeption = cons("-------------------------------------------------------------------------------" 
		(trl_altium2hdl_global->exeption)
	    ))
    )
)
procedure(TRL_ALTIUM2HDL_Create_OrCAD_symbols() 
    let((cdslib celllib cells cmd_str olbpath
	    cell_content sym ind
	) 
	(olbpath = (axlFormGetField 
		(trl_altium2hdl_global->formid) "projloc_l"
	    )) 
	(olbpath = strcat(olbpath "/" 
		(axlFormGetField 
		    (trl_altium2hdl_global->formid) "projname_l"
		)
	    )) 
	unless(isDir(strcat(olbpath "/capture")) 
	    createDir(strcat(olbpath "/capture"))
	) 
	(cdslib = strcat(olbpath "/cds.lib"))
	(celllib = strcat(olbpath "/" 
		(axlFormGetField 
		    (trl_altium2hdl_global->formid) "libname_l"
		)
	    )) 
	(cells = getDirFiles(celllib)) 
	foreach(cell cells 
	    unless(((cell == ".") || (cell == "..")) 
		when(isDir(strcat(celllib "/" cell)) 
		    printf("--CELL1: %L -> %L\n" cell 
			getDirFiles(strcat(celllib "/" cell))
		    ) 
		    (cell_content = getDirFiles(strcat(celllib "/" cell))) 
		    when(member(("chips" && "entity" && "sym_1") cell_content) 
			if((length(cell_content) > 5) then 
			    (sym = "sym_1") 
			    (ind = 2) 
			    for(i 6 
				length(cell_content) 
				(sym = sprintf(nil "%s, sym_%d" sym ind)) 
				ind++
				i++
			    )
			    else 
			    (sym = "sym_1")
			) 
			printf("--SYM: %L\n" sym) 
			(cmd_str = "con2cap") 
			(cmd_str = sprintf(nil "%s -product PCB_LIBRARIAN_EXPERT" cmd_str))
			(cmd_str = sprintf(nil "%s -cdslib %s" cmd_str cdslib)) 
			(cmd_str = sprintf(nil "%s -conceptlib %s" cmd_str 
				(axlFormGetField 
				    (trl_altium2hdl_global->formid) "libname_l"
				)
			    )) 
			(cmd_str = sprintf(nil "%s -cell %s" cmd_str cell)) 
			(cmd_str = sprintf(nil "%s -olbpath %s/capture/proj.olb" cmd_str olbpath)) 
			(cmd_str = sprintf(nil "%s -symbollist %s" cmd_str sym))
			(cmd_str = sprintf(nil "%s -package %s  > log_run.txt 2>&1" cmd_str cell)) 
			sh(cmd_str) 
			printf("--CELL2: %L\n" cmd_str)
		    )
		)
	    )
	)
    )
)
procedure(TRL_ALTIUM2HDL_Create_Reference_File() 
    let((reference_file outPort) 
	(reference_file = (axlFormGetField 
		(trl_altium2hdl_global->formid) "reference_l"
	    )) 
	(outPort = outfile(reference_file)) 
	when(outPort 
	    if(cadr((trl_altium2hdl_global->Reference)) then 
		fprintf(outPort "(\n") 
		foreach(sym_ref 
		    cadr((trl_altium2hdl_global->Reference)) 
		    fprintf(outPort "%L\n" sym_ref)
		) 
		fprintf(outPort ")\n")
		else 
		(axlUIWPrint 
		    (trl_altium2hdl_global->formid) "E - *Error* Unable to Open Reference File, Check File Name"
		) 
		(trl_altium2hdl_global->exeption = cons("   7.2.08 WARNING - Unable to Open Reference File, OR File Name NOT specified!" 
			(trl_altium2hdl_global->exeption)
		    ))
	    ) 
	    close(outPort)
	)
    )
)
procedure(TRL_ALTIUM2HDL_Create_Symbol_Implicite_Pin(pinImpli outport) 
    let((pin_number pin_name nc_pins power_pins nc_Index
	    impliTable ppins power_strg
	) 
	(nc_pins = "NC_PINS='(") 
	(nc_Index = 1) 
	(impliTable = makeTable('listOFlists nil)) 
	(power_strg = "")
	(power_pins = list()) 
	foreach(ipin pinImpli 
	    (pin_name = cadr(ipin)) 
	    (pin_number = car(ipin)) 
	    if((pin_name == "NIL-NAMEMAPPER") then 
		if((nc_Index == 10) then 
		    (nc_pins = sprintf(nil "%s%s," nc_pins pin_number)) 
		    (nc_pins = sprintf(nil "%s\n" nc_pins)) 
		    rexCompile(",\n")
		    (nc_pins = rexReplace(nc_pins ")';\n" 0)) 
		    fprintf(outport "    %s" nc_pins) 
		    (nc_Index = 1) 
		    (nc_pins = "NC_PINS='(") else
		    (nc_pins = sprintf(nil "%s%s," nc_pins pin_number))
		) 
		nc_Index++ else
		(impliTable[pin_name] = list()) 
		(power_pins = cons(list(pin_name pin_number) power_pins))
	    )
	) 
	when((nc_Index > 1) 
	    (nc_pins = sprintf(nil "%s\n" nc_pins)) 
	    rexCompile(",\n") 
	    (nc_pins = rexReplace(nc_pins ")';\n" 0)) 
	    fprintf(outport "    %s" nc_pins)
	) 
	foreach(pin 
	    (impliTable->?) 
	    foreach(imp power_pins 
		when((pin == car(imp)) 
		    (impliTable[pin] = cons(cadr(imp) 
			    impliTable[pin]
			))
		)
	    )
	) 
	foreach(pin 
	    (impliTable->?) 
	    (nc_Index = 1) 
	    (ppins = impliTable[pin]) 
	    (power_strg = sprintf(nil "POWER_PINS='(%s:" pin))
	    foreach(pinval ppins 
		if((nc_Index == 10) then 
		    (power_strg = sprintf(nil "%s%s," power_strg pinval)) 
		    (power_strg = sprintf(nil "%s\n" power_strg)) 
		    rexCompile(",\n")
		    (power_strg = rexReplace(power_strg ")';\n" 0)) 
		    fprintf(outport "    %s" power_strg) 
		    printf("--> %s " power_strg) 
		    (nc_Index = 1) 
		    (power_strg = sprintf(nil "POWER_PINS='(%s:" pin))
		    else 
		    (power_strg = sprintf(nil "%s%s," power_strg pinval))
		) 
		nc_Index++
	    ) 
	    when((nc_Index > 1) 
		(power_strg = sprintf(nil "%s\n" power_strg)) 
		rexCompile(",\n") 
		(power_strg = rexReplace(power_strg ")';\n" 0)) 
		fprintf(outport "    %s" power_strg)
		printf("--> %d INDEX %s" nc_Index power_strg)
	    )
	)
    )
)
procedure(TRL_ALTIUM2HDL_Create_Symbol_NC_Pin(ncPins outport) 
    let((nc_pins nc_Index pin_number) 
	(nc_pins = "NC_PINS='(") 
	(nc_Index = 1) 
	foreach(nc ncPins 
	    (pin_number = caddr(nc)) 
	    if((nc_Index == 10) then 
		(nc_pins = sprintf(nil "%s%s," nc_pins pin_number)) 
		(nc_pins = sprintf(nil "%s\n" nc_pins)) 
		rexCompile(",\n")
		(nc_pins = rexReplace(nc_pins ")';\n" 0)) 
		fprintf(outport "    %s" nc_pins) 
		(nc_Index = 1) 
		(nc_pins = "NC_PINS='(") else
		(nc_pins = sprintf(nil "%s%s," nc_pins pin_number))
	    ) 
	    nc_Index++
	) 
	when((nc_Index > 1) 
	    (nc_pins = sprintf(nil "%s\n" nc_pins)) 
	    rexCompile(",\n") 
	    (nc_pins = rexReplace(nc_pins ")';\n" 0)) 
	    fprintf(outport "    %s" nc_pins)
	)
    )
)
procedure(TRL_ALTIUM2HDL_Create_Symbol_Short_Pin(shPins outport) 
    let((sh_pins strg strl) 
	(sh_pins = "PACK_SHORT='") 
	(strg = "") 
	foreach(shpin shPins 
	    (shpin = sprintf(nil "%L" shpin)) 
	    rexCompile(" ") 
	    (shpin = rexReplace(shpin "," 0))
	    rexCompile("\"") 
	    (shpin = rexReplace(shpin "" 0)) 
	    (strg = sprintf(nil "%s%s" strg shpin))
	) 
	(strg = sprintf(nil "%s%s';\n" sh_pins strg))
	(strl = parseString(strg "")) 
	if((length(strl) < 255) then 
	    fprintf(outport "    %s" strg) else 
	    (trl_altium2hdl_global->exeption = cons(sprintf(nil "-->3.3.10 ERROR   - [%5d] PACK_SHORT String too long - %L" 
			length(strl) strg
		    ) 
		    (trl_altium2hdl_global->exeption)
		))
	)
    )
)
procedure(TRL_ALTIUM2HDL_Find_Concept_Symbol_Views(sym_data_rec partcount) 
    let((part_id id_ref_list) 
	(id_ref_list = list()) 
	if(atoi(partcount) then 
	    (part_id = atoi(partcount)) 
	    for(i 1 
		(part_id - 1) 
		(id_ref_list = cons(sprintf(nil "%d" i) id_ref_list)) 
		i++
	    ) 
	    (id_ref_list = sort(id_ref_list nil))
	    else 
	    (trl_altium2hdl_global->exeption = cons(sprintf(nil "-->2.2.01 ERROR   - Symbol View DONOT Exisit!! %L" sym_data_rec) 
		    (trl_altium2hdl_global->exeption)
		)) id_ref_list
	)
    )
)
procedure(TRL_ALTIUM2HDL_Help_file() nil 
    let((outp) 
	(outp = outfile("alt2hdl_help.txt")) 
	fprintf(outp "======================================================================================================\n") 
	fprintf(outp "====                               Altium SCH Translator Help File                               =====\n") 
	fprintf(outp "======================================================================================================\n\n")
	fprintf(outp "1. Altium Settings: hier wird unterschieden zwieschen den optionen fuer die erstellung der PPT views\n") 
	fprintf(outp "   und den Attributen die im Symbol als sogenannte Labels angebracht werden. \n\n") 
	fprintf(outp "   ACHTUNG - FUER DEN TRANSLATOR LAUF WIRD DIE [LIBRARIEN EXPERT] LIZENZ BENOETIGT.\n\n") 
	fprintf(outp "2. Altium Files: Die einzulesende Altium Schematic Datei muss in ASCII verfuegbar sein und besitzt die \n") 
	fprintf(outp "   .SchDoc extention. Da wir auch gesamte Altium Projecte uebernehmen benoetigten wir Altium Project \n")
	fprintf(outp "   Datei mit der .PrjPCB extention. Um ConceptHDL Projektstruktur zu erzeugen wird ein Template Design \n") 
	fprintf(outp "   benoetigt mit der bezeichnung [FloWare/getting_started/altium_import/altium_proj_template] \n") 
	fprintf(outp "   und [altium_proj_template.cpm] wird dann ausgewaehlt.\n") 
	fprintf(outp "   Project, Design, Lib Name wird, falls vom Anwender nicht spezifiziert, aus dem Altium \n") 
	fprintf(outp "   ProjectFile (.PrjPCB) uebernommen. \n\n")
	fprintf(outp "3. Altium Flow: Erst jetzt kann mit dem Import der Altium Daten begonnen werden. Bitte die \n") 
	fprintf(outp "   Reihennfolge der Bearbeitungsschritte einhalten: Datei einlesen -> Load Altium (SCH File) \n") 
	fprintf(outp "   (Project Setup) erzeugt ConceptHDL Project Struktur entsprechend der Altium PrjPCB Vorgabe. \n") 
	fprintf(outp "   (Symbols) das Erzeugen der Schematic Symbole mit den entsprechenden chips, ppt, hdl views. \n") 
	fprintf(outp "   ACHTUNG - Inhalt der PPT Dateien, falls die PPT Support Option ausgewaehlt wurde, muss Projektweise \n")
	fprintf(outp "   inividuell eingestellt werden.\n") 
	fprintf(outp "   (Schematic) erzeugt hierarchische Schaltplaene inclusive der dazugehoerigen Bloecke. \n\n") 
	fprintf(outp "4. Report: Erzeugt eine ausfuehrliche Log-Datei, um die Qualitaet der Uebersetzung abschaetzen zu \n") 
	fprintf(outp "   koennen und ist die Grundlage bei der Fehlersuche.\n\n") 
	fprintf(outp "======================================================================================================\n\n")
	fprintf(outp "1. Altium Settings: Here we distinguish between PPT view and the symbol label option settings \n\n") 
	fprintf(outp "   NOTE! IN ORDER TO RUN THE ALTIUM TRANSLATOR LIBRARIEN EXPERT LICENSE IS NEEDED.\n\n") 
	fprintf(outp "2. Altium Files: For translation purposes the translator expects altium schematic file in ASCII representation \n") 
	fprintf(outp "   only, with the .SchDoc extention. For whole Altium Project translation an altium project file \n") 
	fprintf(outp "   with the .PrjPCB extension shall be selectet. Due to the fact the translation run will create \n")
	fprintf(outp "   conceptHDL project an hdl project template have to be considerd \n") 
	fprintf(outp "   [FloWare/getting_started/altium_import/altium_proj_template] and [altium_proj_template.cpm] selected.\n") 
	fprintf(outp "   Project, Design and Lib Name will be extracted from altium project directly, in case user did not specify differently. \n\n") 
	fprintf(outp "3. Altium Flow: .\n\n") 
	fprintf(outp "4. Report: Generates detailed log file which can also be used for debugging.\n\n")
	close(outp) 
	if(isFile("alt2hdl_help.txt") then 
	    (axlUIViewFileCreate "alt2hdl_help.txt" "Altium Translator HELP FILE" nil) else 
	    (axlUIConfirm "Unable to Open Help File, Check Permissions!")
	)
    )
)
procedure(TRL_ALTIUM2HDL_Init() 
    unless(boundp('trl_altium2hdl_global) 
	iliDefstruct('defstruct(trl_altium2hdl_global_struct index offset formid exeption
		    settings files new_txt_block_nr SchRawList LibRawList
		    CISRawList PRJRawList Harness Harness_Hier Harness_Adap
		    Block Nets Rest BusFromTo BusNames
		    PortTerminal PackIgnore Graphic Reference Global_GUI_Handling
		    ProjStr license
		)
	) 
	defvar(trl_altium2hdl_global nil)
    ) 
    if(!trl_altium2hdl_global then 
	(trl_altium2hdl_global = (make_trl_altium2hdl_global_struct ?formid nil ?exeption nil
		?license "Concept_HDL_studio"
	    )) else 
	(trl_altium2hdl_global->formid = nil)
	(trl_altium2hdl_global->ProjStr = nil) 
	(trl_altium2hdl_global->index = 1) 
	(trl_altium2hdl_global->new_txt_block_nr = nil) 
	(trl_altium2hdl_global->exeption = list()) 
	(trl_altium2hdl_global->settings = list())
	(trl_altium2hdl_global->files = list()) 
	(trl_altium2hdl_global->offset = list()) 
	(trl_altium2hdl_global->SchRawList = list()) 
	(trl_altium2hdl_global->LibRawList = list()) 
	(trl_altium2hdl_global->CISRawList = list())
	(trl_altium2hdl_global->PRJRawList = list()) 
	(trl_altium2hdl_global->Harness = list()) 
	(trl_altium2hdl_global->Harness_Hier = list()) 
	(trl_altium2hdl_global->Harness_Adap = list()) 
	(trl_altium2hdl_global->Block = list())
	(trl_altium2hdl_global->Nets = list()) 
	(trl_altium2hdl_global->Rest = list()) 
	(trl_altium2hdl_global->BusFromTo = list()) 
	(trl_altium2hdl_global->BusNames = list()) 
	(trl_altium2hdl_global->PortTerminal = list())
	(trl_altium2hdl_global->PackIgnore = list()) 
	(trl_altium2hdl_global->Graphic = list()) 
	(trl_altium2hdl_global->Reference = list()) 
	(trl_altium2hdl_global->license = "Concept_HDL_studio") 
	(trl_altium2hdl_global->Global_GUI_Handling = list())
    )
)
procedure(TRL_ALTIUM2HDL_Load_Reference_File() 
    let((inPort inFile) 
	if(isFile((axlFormGetField 
		    (trl_altium2hdl_global->formid) "reference_l"
		)
	    ) then 
	    if(isReadable((axlFormGetField 
			(trl_altium2hdl_global->formid) "reference_l"
		    )
		) then 
		(inPort = infile((axlFormGetField 
			    (trl_altium2hdl_global->formid) "reference_l"
			)
		    )) 
		if(inPort then 
		    (inFile = lineread(inPort)) 
		    when(inFile 
			(trl_altium2hdl_global->Reference = list(t 
				car(inFile)
			    ))
		    ) 
		    close(inPort)
		    else 
		    (axlUIWPrint 
			(trl_altium2hdl_global->formid) "E - *Error* Unable to Open Reference File File, Check Permissions"
		    ) 
		    (trl_altium2hdl_global->exeption = cons("-->7.2.05 ERROR   - Reference File don't exist or can't be accessed!" 
			    (trl_altium2hdl_global->exeption)
			))
		) else
		(axlUIWPrint 
		    (trl_altium2hdl_global->formid) "E - *Error* Unable to Open Reference File File, Check Permissions"
		) 
		(trl_altium2hdl_global->exeption = cons("-->7.2.06 ERROR   - Reference File don't exist or can't be accessed!" 
			(trl_altium2hdl_global->exeption)
		    ))
	    ) else 
	    (axlUIWPrint 
		(trl_altium2hdl_global->formid) "E - *Error* Unable to Open Reference File, Check File Name"
	    )
	    (trl_altium2hdl_global->exeption = cons("   7.2.07 WARNING - Unable to Open Reference File, OR File Name specified!" 
		    (trl_altium2hdl_global->exeption)
		))
	)
    )
)
procedure(TRL_ALTIUM2HDL_Load_SCH_Data(raw_data sch_name page_nr) 
    let((sch_raw_list lib_ref SchematicRecords LibraryRecords libRec
	    ind refDes sym_name sym_desc record
	    rest_rec net_rec wir_rec bus_rec tap_rec
	    dot_rec sup_rec lin_rec txt_rec port_rec
	    lin_loccnt poly_line rectangle rnd_rect arc_rec
	    pie_rec ellipse ellip_arc bezier note_box
	    block_rec harness_body harness_term harness_text harness_line
	    frame_rec
	) 
	(sch_raw_list = raw_data) 
	(net_rec = list()) 
	(wir_rec = list()) 
	(bus_rec = list())
	(tap_rec = list()) 
	(dot_rec = list()) 
	(lin_rec = list()) 
	(txt_rec = list()) 
	(arc_rec = list())
	(pie_rec = list()) 
	(port_rec = list()) 
	(block_rec = list()) 
	(lin_loccnt = list()) 
	(poly_line = list())
	(rectangle = list()) 
	(rnd_rect = list()) 
	(ellipse = list()) 
	(ellip_arc = list()) 
	(bezier = list())
	(frame_rec = list()) 
	(note_box = list()) 
	(harness_body = list()) 
	(harness_term = list()) 
	(harness_text = list())
	(harness_line = list()) 
	foreach(rec sch_raw_list 
	    (record = get(rec 
		    'RECORD
		)) 
	    case(record 
		("25" 
		    (net_rec = cons(rec net_rec))
		) 
		("27" 
		    (wir_rec = cons(rec wir_rec))
		) 
		("26" 
		    (bus_rec = cons(rec bus_rec))
		) 
		("37" 
		    (tap_rec = cons(rec tap_rec))
		)
		("29" 
		    (dot_rec = cons(rec dot_rec))
		) 
		("17" 
		    (sup_rec = cons(rec sup_rec))
		) 
		("18" 
		    (port_rec = cons(rec port_rec))
		) 
		("15" 
		    (block_rec = cons(rec block_rec))
		) 
		("16" 
		    (block_rec = cons(rec block_rec))
		)
		("32" 
		    (block_rec = cons(rec block_rec))
		) 
		("33" 
		    (block_rec = cons(rec block_rec))
		) 
		("31" 
		    (frame_rec = cons(rec frame_rec))
		) 
		("4" 
		    if((get(rec 
				'OWNERPARTID
			    ) == "-1") then 
			(txt_rec = cons(rec txt_rec)) else 
			(rest_rec = cons(rec rest_rec))
		    )
		) 
		("6" 
		    if((get(rec 
				'OWNERPARTID
			    ) == "-1") then 
			(lin_loccnt = cons(rec lin_loccnt)) else 
			(rest_rec = cons(rec rest_rec))
		    )
		)
		("7" 
		    if((get(rec 
				'OWNERPARTID
			    ) == "-1") then 
			(poly_line = cons(rec poly_line)) else 
			(rest_rec = cons(rec rest_rec))
		    )
		) 
		("8" 
		    if((get(rec 
				'OWNERPARTID
			    ) == "-1") then 
			(ellipse = cons(rec ellipse)) else 
			(rest_rec = cons(rec rest_rec))
		    )
		) 
		("9" 
		    if((get(rec 
				'OWNERPARTID
			    ) == "-1") then 
			(pie_rec = cons(rec pie_rec)) else 
			(rest_rec = cons(rec rest_rec))
		    )
		) 
		("10" 
		    if((get(rec 
				'OWNERPARTID
			    ) == "-1") then 
			(rnd_rect = cons(rec rnd_rect)) else 
			(rest_rec = cons(rec rest_rec))
		    )
		) 
		("11" 
		    if((get(rec 
				'OWNERPARTID
			    ) == "-1") then 
			(ellip_arc = cons(rec ellip_arc)) else 
			(rest_rec = cons(rec rest_rec))
		    )
		)
		("12" 
		    if((get(rec 
				'OWNERPARTID
			    ) == "-1") then 
			(arc_rec = cons(rec arc_rec)) else 
			(rest_rec = cons(rec rest_rec))
		    )
		) 
		("13" 
		    if((get(rec 
				'OWNERPARTID
			    ) == "-1") then 
			(lin_rec = cons(rec lin_rec)) else 
			(rest_rec = cons(rec rest_rec))
		    )
		) 
		("14" 
		    if((get(rec 
				'OWNERPARTID
			    ) == "-1") then 
			(rectangle = cons(rec rectangle)) else 
			(rest_rec = cons(rec rest_rec))
		    )
		) 
		("41" 
		    (rest_rec = cons(rec rest_rec))
		) 
		("209" 
		    (note_box = cons(rec note_box))
		)
		("215" 
		    (harness_body = cons(rec harness_body))
		) 
		("216" 
		    (harness_body = cons(rec harness_body))
		) 
		("217" 
		    (harness_body = cons(rec harness_body))
		) 
		("218" 
		    (harness_line = cons(rec harness_line))
		) 
		(t 
		    (rest_rec = cons(rec rest_rec))
		)
	    )
	) 
	(trl_altium2hdl_global->Harness = cons(list(sch_name page_nr 
		    list(harness_body harness_term harness_text harness_line)
		) 
		(trl_altium2hdl_global->Harness)
	    )) 
	(trl_altium2hdl_global->Nets = cons(list(sch_name page_nr 
		    list(wir_rec net_rec bus_rec tap_rec dot_rec
			sup_rec port_rec block_rec
		    )
		) 
		(trl_altium2hdl_global->Nets)
	    )) 
	(trl_altium2hdl_global->Graphic = cons(list(sch_name page_nr 
		    list(lin_rec txt_rec lin_loccnt poly_line rectangle
			rnd_rect arc_rec pie_rec ellipse ellip_arc
			bezier note_box frame_rec
		    )
		) 
		(trl_altium2hdl_global->Graphic)
	    ))
	if(rest_rec then 
	    (lib_ref = nil) 
	    (libRec = list()) 
	    (LibraryRecords = list())
	    (SchematicRecords = list()) 
	    foreach(sch_record 
		cdr(rest_rec) 
		when((get(sch_record 
			    'RECORD
			) == "1") 
		    (lib_ref = t) 
		    when(libRec 
			(LibraryRecords = cons(reverse(libRec) LibraryRecords)) 
			(libRec = list())
		    )
		) 
		if(lib_ref then 
		    (libRec = cons(sch_record libRec)) else 
		    (SchematicRecords = cons(sch_record SchematicRecords))
		)
	    ) 
	    when(libRec 
		(LibraryRecords = cons(reverse(libRec) LibraryRecords)) 
		(libRec = list())
	    ) 
	    (trl_altium2hdl_global->exeption = cons(sprintf(nil "-->1.4.01 INFO    - %L Parts in the Altium Schematic %L!" 
			length(LibraryRecords) sch_name
		    ) 
		    (trl_altium2hdl_global->exeption)
		)) 
	    (trl_altium2hdl_global->exeption = cons("                    -----------------------------------------------------------" 
		    (trl_altium2hdl_global->exeption)
		))
	    (ind = 1) 
	    foreach(sym LibraryRecords 
		foreach(rec sym 
		    when((get(rec 
				'NAME
			    ) == "Designator") 
			(refDes = get(rec 
				'TEXT
			    ))
		    ) 
		    when(get(rec 
			    'LIBREFERENCE
			) 
			(sym_name = get(rec 
				'LIBREFERENCE
			    )) 
			(sym_desc = get(rec 
				'COMPONENTDESCRIPTION
			    ))
		    )
		) 
		when((axlFormGetField 
			(trl_altium2hdl_global->formid) "verbose"
		    ) 
		    (trl_altium2hdl_global->exeption = cons(sprintf(nil "   1.4.02 INFO    - [%5d] %L %L %L %L" ind refDes sym_name
				sch_name sym_desc
			    ) 
			    (trl_altium2hdl_global->exeption)
			))
		) 
		ind++
	    ) 
	    (trl_altium2hdl_global->SchRawList = cons(list(sch_name page_nr 
			reverse(SchematicRecords) 
			reverse(LibraryRecords)
		    ) 
		    (trl_altium2hdl_global->SchRawList)
		)) else 
	    (axlUIWPrint 
		(trl_altium2hdl_global->formid) "E - *Error* Unable to Open Preprocessed Altium Raw Data"
	    )
	    (trl_altium2hdl_global->exeption = cons("-->1.3.01 ERROR   - Unable to Open Preprocessed Altium Raw Data!" 
		    (trl_altium2hdl_global->exeption)
		))
	)
    )
)
procedure(TRL_ALTIUM2HDL_Load_SCHematic() 
    let((sch_name raw_data name_pars design_name index
	    tmp sch_loaded_flag tmp_list page_nr page_ind
	) 
	(trl_altium2hdl_global->Harness = list()) 
	(trl_altium2hdl_global->Nets = list()) 
	(trl_altium2hdl_global->Graphic = list()) 
	(trl_altium2hdl_global->PRJRawList = list())
	(index = 1) 
	if((car((trl_altium2hdl_global->files)) != "") then 
	    (sch_loaded_flag = t) 
	    TRL_ALTIUM2HDL_SCH_Load_PrjPCB_File() 
	    when((trl_altium2hdl_global->PRJRawList) 
		foreach(design_str 
		    (trl_altium2hdl_global->PRJRawList) 
		    foreach(page design_str 
			(sch_name = caddr(page)) 
			(page_nr = cadr(page)) 
			(design_name = car(page))
			(trl_altium2hdl_global->exeption = cons("-------------------------------------------------------------------------------" 
				(trl_altium2hdl_global->exeption)
			    )) 
			(trl_altium2hdl_global->exeption = cons(sprintf(nil "   1.1.0  INFO    - [%3d] of [%3d] Start to Load %L SCH File %L" index 
				    (length(design_str) + 1) design_name
				    sch_name
				) 
				(trl_altium2hdl_global->exeption)
			    )) 
			(raw_data = TRL_ALTIUM2HDL_SCH_Load_File(sch_name)) 
			if(raw_data then 
			    TRL_ALTIUM2HDL_Load_SCH_Data(raw_data design_name page_nr) else 
			    (sch_loaded_flag = nil)
			) 
			index++
		    )
		)
	    )
	    unless(sch_loaded_flag 
		(trl_altium2hdl_global->SchRawList = list())
	    ) else 
	    if((caddr((trl_altium2hdl_global->files)) != "") then 
		(sch_loaded_flag = t) 
		(sch_name = (axlFormGetField 
			(trl_altium2hdl_global->formid) "SchDoc_l"
		    )) 
		(name_pars = parseString(sch_name "/"))
		(design_name = car(last(name_pars))) 
		(name_pars = parseString(design_name ".")) 
		(design_name = car(name_pars)) 
		when((length(name_pars) > 2) 
		    for(i 2 
			(length(name_pars) - 1) 
			(design_name = strcat(design_name "." 
				nth((i - 1) name_pars)
			    ))
		    )
		) 
		(design_name = TRL_ALTIUM2HDL_PCB_Util_Namemaper(design_name))
		(design_name = lowerCase(design_name)) 
		(trl_altium2hdl_global->PRJRawList = list(list(list(design_name design_name sch_name)) nil)) 
		when((trl_altium2hdl_global->PRJRawList) 
		    foreach(design_str 
			(trl_altium2hdl_global->PRJRawList) 
			foreach(page design_str 
			    (sch_name = caddr(page)) 
			    (page_nr = cadr(page)) 
			    (design_name = car(page))
			    (trl_altium2hdl_global->exeption = cons("-------------------------------------------------------------------------------" 
				    (trl_altium2hdl_global->exeption)
				)) 
			    (trl_altium2hdl_global->exeption = cons(sprintf(nil "   1.1.0  INFO    - [%3d] of [%3d] Start to Load %L SCH File %L" index 
					(length(design_str) + 1) design_name
					sch_name
				    ) 
				    (trl_altium2hdl_global->exeption)
				)) 
			    (raw_data = TRL_ALTIUM2HDL_SCH_Load_File(sch_name)) 
			    if(raw_data then 
				TRL_ALTIUM2HDL_Load_SCH_Data(raw_data design_name page_nr) else 
				(sch_loaded_flag = nil)
			    ) 
			    index++
			)
		    )
		) 
		unless(sch_loaded_flag 
		    (trl_altium2hdl_global->SchRawList = list())
		) 
		if((nth(6 
			    (trl_altium2hdl_global->files)
			) == "") then 
		    (tmp = (trl_altium2hdl_global->files)) 
		    (trl_altium2hdl_global->files = list(car(tmp) 
			    cadr(tmp) 
			    caddr(tmp) 
			    cadddr(tmp) 
			    nth(4 tmp)
			    nth(5 tmp) design_name 
			    nth(7 tmp)
			)) 
		    when((axlFormGetField 
			    (trl_altium2hdl_global->formid) "designname_l"
			) 
			(axlFormSetField 
			    (trl_altium2hdl_global->formid) "designname_l" design_name
			)
		    )
		)
		else 
		if((cadr((trl_altium2hdl_global->files)) != "") then 
		    (sch_loaded_flag = t) 
		    when(TRL_ALTIUM2HDL_SCH_Load_SchDocDir_File() 
			(page_ind = 1) 
			foreach(sch 
			    TRL_ALTIUM2HDL_SCH_Load_SchDocDir_File() 
			    (raw_data = TRL_ALTIUM2HDL_SCH_Load_File(sch)) 
			    (name_pars = parseString(sch "/")) 
			    (design_name = car(last(name_pars)))
			    (name_pars = parseString(design_name ".")) 
			    (design_name = car(name_pars)) 
			    when((length(name_pars) > 2) 
				for(i 2 
				    (length(name_pars) - 1) 
				    (design_name = strcat(design_name "." 
					    nth((i - 1) name_pars)
					))
				)
			    ) 
			    (design_name = TRL_ALTIUM2HDL_PCB_Util_Namemaper(design_name)) 
			    (design_name = lowerCase(design_name))
			    if((page_ind > 1) then 
				(tmp_list = cons(list(design_name page_ind sch) tmp_list)) else 
				(tmp_list = cons(list(design_name design_name sch) tmp_list))
			    )
			) 
			(tmp_list = reverse(tmp_list)) 
			(trl_altium2hdl_global->PRJRawList = list(list(car(tmp_list)) 
				cdr(tmp_list)
			    ))
			when((trl_altium2hdl_global->PRJRawList) 
			    foreach(design_str 
				(trl_altium2hdl_global->PRJRawList) 
				foreach(page design_str 
				    (sch_name = caddr(page)) 
				    (page_nr = cadr(page)) 
				    (design_name = car(page))
				    (trl_altium2hdl_global->exeption = cons("-------------------------------------------------------------------------------" 
					    (trl_altium2hdl_global->exeption)
					)) 
				    (trl_altium2hdl_global->exeption = cons(sprintf(nil "   1.1.0  INFO    - [%3d] of [%3d] Start to Load %L SCH File %L" index 
						(length(design_str) + 1) design_name
						sch_name
					    ) 
					    (trl_altium2hdl_global->exeption)
					)) 
				    (raw_data = TRL_ALTIUM2HDL_SCH_Load_File(sch_name)) 
				    if(raw_data then 
					TRL_ALTIUM2HDL_Load_SCH_Data(raw_data design_name page_nr) else 
					(sch_loaded_flag = nil)
				    ) 
				    index++
				)
			    )
			) 
			unless(sch_loaded_flag 
			    (trl_altium2hdl_global->SchRawList = list())
			) 
			if((nth(6 
				    (trl_altium2hdl_global->files)
				) == "") then 
			    (tmp = (trl_altium2hdl_global->files)) 
			    (design_name = caar(tmp_list)) 
			    (trl_altium2hdl_global->files = list(car(tmp) 
				    cadr(tmp) 
				    caddr(tmp) 
				    cadddr(tmp) 
				    nth(4 tmp)
				    nth(5 tmp) design_name 
				    nth(7 tmp)
				))
			    when((axlFormGetField 
				    (trl_altium2hdl_global->formid) "designname_l"
				) 
				(axlFormSetField 
				    (trl_altium2hdl_global->formid) "designname_l" design_name
				)
			    )
			)
		    ) else
		    (axlUIWPrint 
			(trl_altium2hdl_global->formid) "E - *Error* NO Schematic Definition File are specified!"
		    ) 
		    (trl_altium2hdl_global->exeption = cons("-->1.1.01 ERROR   - NO Schematic Definition File are specified!" 
			    (trl_altium2hdl_global->exeption)
			))
		)
	    )
	)
    )
)
procedure((TRL_ALTIUM2HDL_Main \@optional arg) 
    let((FC_VERSION SUB_VERSION SourcePrj FORM_FILE fid) 
	(FC_VERSION = "17.4") 
	(SUB_VERSION = "02") 
	when(TRL_LIC_Validate() 
	    TRL_ALTIUM2HDL_Init() 
	    (SourcePrj = strcat(axlGetVariable("allegro_install_root") "/share/pcb/translators/altium_proj_template/altium_proj_template.cpm")) 
	    (trl_altium2hdl_global->files = list("" "" "" SourcePrj ""
		    "" "" "altium_lib"
		)) 
	    (trl_altium2hdl_global->settings = list(t nil nil nil))
	    cond(((arg && (lowerCase(arg) == "version")) 
		    printf("Current version is: %s.%s\n" FC_VERSION SUB_VERSION)
		) 
		((arg && (lowerCase(arg) == "advanced")) 
		    (FORM_FILE = "trl_altium2hdl_adv.form") 
		    (fid = (axlFormCreate 
			    gensym() FORM_FILE 
			    '(e outer) 
			    'TRL_ALTIUM2HDL_Callback
			    t nil
			)) 
		    (trl_altium2hdl_global->formid = fid) 
		    (trl_altium2hdl_global->index = 1)
		    TRL_ALTIUM2HDL_SCH_SetUp_Advanced_Form() 
		    when(isFile(SourcePrj) 
			(axlFormSetField fid "source_projloc_l" SourcePrj) 
			(axlFormSetFieldEditable fid "source_projloc_l" nil)
		    ) 
		    (trl_altium2hdl_global->Global_GUI_Handling = list()) 
		    (trl_altium2hdl_global->Global_GUI_Handling = cons(list(nil) 
			    (trl_altium2hdl_global->Global_GUI_Handling)
			)) 
		    (trl_altium2hdl_global->Global_GUI_Handling = cons(list("darkgray" "darkgray" "darkgray" "darkgray") 
			    (trl_altium2hdl_global->Global_GUI_Handling)
			))
		    TRL_ALTIUM2HDL_Create_Flow_Graphic() 
		    (axlFormDisplay fid) 
		    (axlFormTitle fid "Altium HDL Translator")
		) 
		(t 
		    (FORM_FILE = "trl_altium2hdl.form") 
		    (fid = (axlFormCreate 
			    gensym("trlaltium2hdlform") FORM_FILE 
			    '(e outer) 
			    'TRL_ALTIUM2HDL_Callback_Basic
			    t nil
			)) 
		    (trl_altium2hdl_global->formid = fid) 
		    (trl_altium2hdl_global->index = 1)
		    (axlFormDisplay fid) 
		    (axlFormSetField fid "frame_size" "custom") 
		    (axlFormTitle fid "Altium Schematic to HDL Translator")
		)
	    )
	)
    )
)
procedure(TRL_ALTIUM2HDL_PCB_ComplexPolyPath(l_points) 
    let((r_path g_clockwise vx vy cx
	    cy sa ea end_pt e_path
	    mx my mid_pt s_path
	) 
	(r_path = (axlPathStart 
		list((caar(l_points):cadar(l_points)))
	    )) 
	(s_path = (caar(l_points):cadar(l_points))) 
	(end_pt = (caar(l_points):cadar(l_points))) 
	foreach(coor 
	    cdr(l_points) 
	    (vx = car(coor)) 
	    (vy = cadr(coor)) 
	    (cx = caddr(coor))
	    (cy = nth(3 coor)) 
	    (sa = nth(4 coor)) 
	    (ea = nth(5 coor)) 
	    (e_path = (vx:vy)) 
	    if(((cx == 0.0) && (cy == 0.0)) then 
		(r_path = (axlPathLine r_path 0.0 
			(vx:vy)
		    )) 
		(end_pt = (vx:vy)) else
		when((sa > ea) 
		    (ea = (ea + 360.0))
		) 
		(mid_pt = (axlGeoArcCenterAngle end_pt 
			(vx:vy) 
			(ea - sa) nil
		    )) 
		(g_clockwise = nil) 
		(mx = (axlMKS2UU 
			sprintf(nil "%f" 
			    car(mid_pt)
			)
		    )) 
		(my = (axlMKS2UU 
			sprintf(nil "%f" 
			    cadr(mid_pt)
			)
		    ))
		unless(((round(mx):round(my)) == (round(cx):round(cy))) 
		    (g_clockwise = t)
		) 
		(r_path = (axlPathArcCenter r_path 0.0 
			(car(coor):cadr(coor)) g_clockwise
			(caddr(coor):nth(3 coor))
		    )) 
		(end_pt = (vx:vy))
	    )
	)
	unless((s_path == e_path) 
	    (r_path = (axlPathLine r_path 0.0 s_path))
	) r_path
    )
)
procedure(TRL_ALTIUM2HDL_PCB_GetPolyPath(rec) 
    let((index result vx vy cx
	    cy sa ea r l_points
	) 
	(l_points = list()) 
	(index = 0) 
	(result = t) 
	while(result 
	    (vx = stringToSymbol(sprintf(nil "VX%d" index))) 
	    (vy = stringToSymbol(sprintf(nil "VY%d" index))) 
	    (cx = stringToSymbol(sprintf(nil "CX%d" index))) 
	    (cy = stringToSymbol(sprintf(nil "CY%d" index)))
	    (sa = stringToSymbol(sprintf(nil "SA%d" index))) 
	    (ea = stringToSymbol(sprintf(nil "EA%d" index))) 
	    (r = stringToSymbol(sprintf(nil "R%d" index))) 
	    (vx = get(rec vx)) 
	    (vy = get(rec vy))
	    (cx = get(rec cx)) 
	    (cy = get(rec cy)) 
	    (sa = get(rec sa)) 
	    (ea = get(rec ea)) 
	    (r = get(rec r))
	    if((vx && vy) then 
		(vx = TRL_ALTIUM2HDL_PCB_Util_DesignUnits(vx)) 
		(vy = TRL_ALTIUM2HDL_PCB_Util_DesignUnits(vy)) 
		(cx = TRL_ALTIUM2HDL_PCB_Util_DesignUnits(cx))
		(cy = TRL_ALTIUM2HDL_PCB_Util_DesignUnits(cy)) 
		(sa = atof(sa)) 
		(ea = atof(ea)) 
		(r = TRL_ALTIUM2HDL_PCB_Util_DesignUnits(r)) 
		(l_points = cons(list(vx vy cx cy sa
			    ea r
			) l_points
		    ))
		else 
		(result = nil)
	    ) 
	    index++
	)
	l_points
    )
)
procedure(TRL_ALTIUM2HDL_PCB_UTIL_Check_DBID() 
    let((dbid compdefs_lst symdefs_lst components_lst symbols_lst
	    padstacks_lst
	) 
	(axlDBRefreshId nil) 
	(dbid = (axlDBGetDesign)) 
	(compdefs_lst = list()) 
	(symdefs_lst = list())
	(components_lst = list()) 
	(symbols_lst = list()) 
	(padstacks_lst = list()) 
	when((dbid->compdefs) 
	    foreach(id 
		(dbid->compdefs) 
		(compdefs_lst = cons((id->name) compdefs_lst))
	    )
	) 
	when((dbid->symdefs) 
	    foreach(id 
		(dbid->symdefs) 
		(symdefs_lst = cons((id->name) symdefs_lst))
	    )
	)
	when((dbid->compdefs) 
	    foreach(id 
		(dbid->components) 
		(components_lst = cons((id->name) components_lst))
	    )
	) 
	when((dbid->symbols) 
	    foreach(id 
		(dbid->symbols) 
		(symbols_lst = cons((id->name) symbols_lst))
	    )
	) 
	when((dbid->padstacks) 
	    foreach(id 
		(dbid->padstacks) 
		(padstacks_lst = cons((id->name) padstacks_lst))
	    )
	) 
	(trl_altium2hdl_global->UtilsList = list(compdefs_lst symdefs_lst components_lst symbols_lst padstacks_lst))
    )
)
procedure(TRL_ALTIUM2HDL_PCB_UTIL_Default_Text_Blocks() 
    let((txt_param height) 
	(height = 25.0) 
	for(ind 1 32 
	    (txt_param = (axlGetParam 
		    sprintf(nil "paramTextBlock:%d" ind)
		)) 
	    (txt_param->height = height)
	    (txt_param->width = (height * 0.6)) 
	    (txt_param->lineSpace = (height / 3)) 
	    (txt_param->charSpace = (height * 0.14)) 
	    (txt_param->photoWidth = (height * 0.12)) 
	    (axlSetParam txt_param)
	    ind++ 
	    (height = (height * 1.1))
	) 
	(height = 25.0) 
	for(ind 33 64 
	    (txt_param = (axlGetParam 
		    sprintf(nil "paramTextBlock:%d" ind)
		)) 
	    (txt_param->height = height)
	    (txt_param->width = (height * 0.6)) 
	    (txt_param->lineSpace = (height / 3)) 
	    (txt_param->charSpace = (height * 0.18)) 
	    (txt_param->photoWidth = (height * 0.18)) 
	    (axlSetParam txt_param)
	    ind++ 
	    (height = (height * 1.1))
	)
    )
)
procedure(TRL_ALTIUM2HDL_PCB_UTIL_Find_Layer(altium_layer) 
    let((LayerStack preproc_layer algr_class algr_layer) 
	(LayerStack = (trl_altium2hdl_global->LayerStack)) 
	case(altium_layer 
	    ("TOP" 
		(algr_class = "ETCH") 
		(algr_layer = "TOP")
	    ) 
	    ("BOTTOM" 
		(algr_class = "ETCH") 
		(algr_layer = "BOTTOM")
	    ) 
	    ("TOPSOLDER" 
		(algr_class = "Board Geometry") 
		(algr_layer = "Soldermask_Top")
	    ) 
	    ("BOTTOMSOLDER" 
		(algr_class = "Board Geometry") 
		(algr_layer = "Soldermask_Bottom")
	    )
	    ("TOPOVERLAY" 
		(algr_class = "Board Geometry") 
		(algr_layer = "Silkscreen_Top")
	    ) 
	    ("BOTTOMOVERLAY" 
		(algr_class = "Board Geometry") 
		(algr_layer = "Silkscreen_Bottom")
	    ) 
	    ("TOPPASTE" 
		(algr_class = "Board Geometry") 
		(algr_layer = "Pastemask_Top")
	    ) 
	    ("BOTTOMPASTE" 
		(algr_class = "Board Geometry") 
		(algr_layer = "Pastemask_Bottom")
	    ) 
	    ("KEEPOUT" 
		(algr_class = "Areas") 
		(algr_layer = "KEEPOUT")
	    )
	    ("DRILLDRAWING" 
		(algr_class = "Manufacturing") 
		(algr_layer = "Ncdrill_Legend")
	    ) 
	    (t 
		(preproc_layer = atoi(car(parseString(altium_layer "MID")))) 
		if(preproc_layer then 
		    (preproc_layer = (preproc_layer + 1)) 
		    foreach(rec LayerStack 
			when((preproc_layer == car(rec)) 
			    (algr_class = "ETCH") 
			    (algr_layer = cadr(rec))
			)
		    ) else
		    (preproc_layer = atoi(car(parseString(altium_layer "PLANE")))) 
		    if(preproc_layer then 
			(preproc_layer = (preproc_layer + 38)) 
			foreach(rec LayerStack 
			    when((preproc_layer == car(rec)) 
				(algr_class = "ETCH") 
				(algr_layer = cadr(rec))
			    )
			) else
			foreach(m_lay 
			    (trl_altium2hdl_global->LayerMech) 
			    when((cadr(m_lay) == altium_layer) 
				(algr_class = "Board Geometry") 
				(algr_layer = caddr(m_lay))
			    )
			)
		    )
		)
	    )
	) 
	unless(algr_class 
	    printf("--No Allegro Class Specified-> %L\n" altium_layer) 
	    (algr_class = "Board Geometry")
	) 
	unless(algr_layer 
	    printf("--No Allegro SUBClass Specified-> %L\n" altium_layer) 
	    (algr_layer = "Assembly_Notes")
	)
	list(algr_class algr_layer)
    )
)
procedure(TRL_ALTIUM2HDL_PCB_UTIL_Find_Max_XY_Value(xy_actual_list xy_max_list) 
    let((x y max_x max_y) 
	(x = car(xy_actual_list)) 
	(y = cadr(xy_actual_list)) 
	(max_x = car(xy_max_list)) 
	(max_y = cadr(xy_max_list))
	when((abs(x) > max_x) 
	    (max_x = abs(x))
	) 
	when((abs(y) > max_y) 
	    (max_y = abs(y))
	) 
	(max_x:max_y)
    )
)
procedure(TRL_ALTIUM2HDL_PCB_UTIL_Find_Text_Block(height bold) 
    let((txt_param txt_block) 
	if(bold then 
	    prog(nil 
		(txt_block = 33) 
		for(ind 33 64 
		    (txt_param = (axlGetParam 
			    sprintf(nil "paramTextBlock:%d" ind)
			)) 
		    when(((txt_param->height) > height) 
			return((txt_block = (ind - 1)))
		    )
		    ind++
		)
	    ) else 
	    prog(nil 
		(txt_block = 1) 
		for(ind 1 32 
		    (txt_param = (axlGetParam 
			    sprintf(nil "paramTextBlock:%d" ind)
			)) 
		    when(((txt_param->height) > height) 
			return((txt_block = (ind - 1)))
		    )
		    ind++
		)
	    )
	) 
	when(zerop(txt_block) 
	    (txt_block = 1)
	) 
	(txt_block = sprintf(nil "%d" txt_block))
    )
)
procedure(TRL_ALTIUM2HDL_PCB_UTIL_Package_Layer_Map(mirror subclass) 
    let((class_subclass sym_layer layer_Id) 
	if(mirror then 
	    case(subclass 
		("TOPOVERLAY" 
		    (sym_layer = "Package Geometry/Silkscreen_Bottom")
		) 
		("BOTTOMOVERLAY" 
		    (sym_layer = "Package Geometry/Silkscreen_Top")
		) 
		("TOPSOLDER" 
		    (sym_layer = "Package Geometry/Soldermask_Bottom")
		) 
		("BOTTOMSOLDER" 
		    (sym_layer = "Package Geometry/Soldermask_Top")
		)
		("TOPPASTE" 
		    (sym_layer = "Package Geometry/Pastemask_Bottom")
		) 
		("BOTTOMPASTE" 
		    (sym_layer = "Package Geometry/Pastemask_Top")
		) 
		(t 
		    (class_subclass = sprintf(nil "ETCH/%s" subclass)) 
		    if((axlLayerGet class_subclass) then 
			(sym_layer = class_subclass) 
			case(upperCase(subclass) 
			    ("TOP" 
				(sym_layer = "ETCH/BOTTOM")
			    ) 
			    ("BOTTOM" 
				(sym_layer = "ETCH/TOP")
			    ) 
			    (t 
				(sym_layer = class_subclass)
			    )
			) else
			(class_subclass = sprintf(nil "Package Geometry/%s" subclass)) 
			(layer_Id = (axlLayerCreateNonConductor class_subclass)) 
			if(layer_Id then 
			    (sym_layer = class_subclass) else 
			    (sym_layer = "Package Geometry/Display_Top")
			    printf("-->Unknown Layer %L\n" subclass)
			)
		    )
		)
	    ) else 
	    case(subclass 
		("TOPOVERLAY" 
		    (sym_layer = "Package Geometry/Silkscreen_Top")
		) 
		("BOTTOMOVERLAY" 
		    (sym_layer = "Package Geometry/Silkscreen_Bottom")
		) 
		("TOPSOLDER" 
		    (sym_layer = "Package Geometry/Soldermask_Top")
		) 
		("BOTTOMSOLDER" 
		    (sym_layer = "Package Geometry/Soldermask_Bottom")
		)
		("TOPPASTE" 
		    (sym_layer = "Package Geometry/Pastemask_Top")
		) 
		("BOTTOMPASTE" 
		    (sym_layer = "Package Geometry/Pastemask_Bottom")
		) 
		(t 
		    (class_subclass = sprintf(nil "ETCH/%s" subclass)) 
		    if((axlLayerGet class_subclass) then 
			(sym_layer = class_subclass) else 
			(class_subclass = sprintf(nil "Package Geometry/%s" subclass))
			(layer_Id = (axlLayerCreateNonConductor class_subclass)) 
			if(layer_Id then 
			    (sym_layer = class_subclass) else 
			    (sym_layer = "Package Geometry/Display_Top")
			    printf("-->Unknown Layer %L\n" subclass)
			)
		    )
		)
	    )
	) sym_layer
    )
)
procedure(TRL_ALTIUM2HDL_PCB_UTIL_Poly_From_Text(txt_dbid tmp_layer) 
    let((tmp_plt_file orgvis orgactive seg_poly_list poly_info) 
	(orgvis = (axlVisibleGet)) 
	(orgactive = (axlDBControl 
		'activeLayer
	    )) 
	(tmp_plt_file = (axlTempFile t)) 
	(axlDetailSave tmp_plt_file 
	    (txt_dbid->bBox) 
	    list(txt_dbid)
	)
	(axlDBControl 
	    'activeLayer tmp_layer
	) 
	(axlDetailLoad tmp_plt_file 
	    car((txt_dbid->bBox)) 1.0 0
	    nil
	) 
	(axlVisibleDesign nil) 
	(axlVisibleLayer tmp_layer t) 
	(axlVisibleUpdate nil)
	(axlSetFindFilter ?enabled 
	    list("noall" "linesegs") ?onButtons 
	    list("all")
	) 
	(axlClearSelSet) 
	(axlSingleSelectBox 
	    (txt_dbid->bBox)
	) 
	if((axlGetSelSet) then 
	    foreach(seg 
		(axlGetSelSet) 
		when(((seg->width) != 0.0) 
		    foreach(p 
			(axlPolyFromDB seg ?endCapType 
			    'ROUND
			) 
			(seg_poly_list = cons(p seg_poly_list))
		    )
		)
	    ) 
	    if(onep(length(seg_poly_list)) then 
		(poly_info = seg_poly_list) else 
		(poly_info = (axlPolyOperation 
			cdr(seg_poly_list) 
			list(car(seg_poly_list)) 
			'OR
		    ))
	    ) poly_info
	    else t
	) 
	when(isFile(tmp_plt_file) 
	    (axlTempFileRemove tmp_plt_file)
	)
	(axlDeleteObject 
	    (axlGetSelSet)
	) 
	(axlVisibleSet orgvis) 
	(axlDBControl 
	    'activeLayer orgactive
	) 
	(axlVisibleUpdate nil) poly_info
    )
)
procedure(TRL_ALTIUM2HDL_PCB_Util_Convert_Long2RGB(long) 
    let((R G B) 
	(B = (long / 65536)) 
	(G = ((long - (B * 65536)) / 256)) 
	(R = (long - (B * 65536) - (G * 256))) 
	list(R G B)
    )
)
procedure(TRL_ALTIUM2HDL_PCB_Util_DesignUnits(input) 
    let((string num uni) 
	(num = list()) 
	(uni = list()) 
	if(input then 
	    (string = parseString(input "")) 
	    foreach(char string 
		if((atoi(char) || (char == ".")) then 
		    (num = cons(char num)) else 
		    (uni = cons(char uni))
		)
	    ) 
	    if((num && uni) then 
		(num = atof(buildString(reverse(num) ""))) 
		(uni = buildString(reverse(uni) "")) else
		(num = 0.0) 
		(uni = "mil") 
		(axlUIWPrint 
		    (trl_altium2hdl_global->formid) "-->2.1.04 ERROR - Unit Data Mismatch!!"
		) 
		(trl_altium2hdl_global->exeption = cons("-->2.1.04 ERROR   - Unit Data Mismatch!!" 
			(trl_altium2hdl_global->exeption)
		    ))
	    )
	    else 
	    (num = 0.0) 
	    (uni = "mil") 
	    (axlUIWPrint 
		(trl_altium2hdl_global->formid) "-->2.1.03 WARNING - Unit Data Missing!!"
	    ) 
	    (trl_altium2hdl_global->exeption = cons(sprintf(nil "-->2.1.03 WARNING - Unit Data Missing!! -> %L" input) 
		    (trl_altium2hdl_global->exeption)
		))
	) 
	(axlMKS2UU 
	    sprintf(nil "%f %s" num uni)
	)
    )
)
procedure(TRL_ALTIUM2HDL_PCB_Util_Find_BUS_Tap(input) 
    let((bus_name bit parse) 
	(bus_name = "") 
	(bit = "") 
	(parse = parseString(input "")) 
	foreach(char parse 
	    if(atoi(char) then 
		(bit = strcat(bit char)) else 
		(bus_name = strcat(bus_name char))
	    )
	)
	foreach(bus 
	    (trl_altium2hdl_global->BusNames) 
	    when((car(bus) == bus_name) 
		(input = strcat(bus_name "[" bit "]"))
	    )
	) input
    )
)
procedure(TRL_ALTIUM2HDL_PCB_Util_Namemaper(input) 
    let((replace_list pat) 
	if(input then 
	    rexCompile(" ") 
	    (input = rexReplace(input "_" 0)) 
	    rexCompile("-")
	    (input = rexReplace(input "_" 0)) 
	    rexCompile("\\[") 
	    (input = rexReplace(input "" 0)) 
	    rexCompile("\\]") 
	    (input = rexReplace(input "" 0))
	    rexCompile("[({!/%*+$=<>&?#:.,\\})]+") 
	    (input = rexReplace(input "_" 0)) 
	    (replace_list = list(list("\\355" "Deg") 
		    list("\\251" "C") 
		    list("\\334" "Ue") 
		    list("\\374" "ue") 
		    list("\\326" "Oe")
		    list("\\366" "oe") 
		    list("\\304" "Ae") 
		    list("\\344" "ae") 
		    list("\\265" "u") 
		    list("\\226" "_")
		    list("\\260" "deg") 
		    list("\\262" "sq") 
		    list("\\337" "ss") 
		    list("\\330" "o") 
		    list("\\370" "o")
		    list("\\231" "TM")
		)) 
	    foreach(specialChar replace_list 
		(pat = pcreCompile(car(specialChar))) 
		(input = pcreReplace(pat input 
			cadr(specialChar) 0
		    ))
	    ) else
	    (input = "NIL-NAMEMAPPER")
	) input
    )
)
procedure(TRL_ALTIUM2HDL_PCB_Util_Signal_Namemaper(input) 
    let((parse) 
	if(input then 
	    rexCompile(" ") 
	    (input = rexReplace(input "_" 0)) 
	    rexCompile("-")
	    (input = rexReplace(input "_" 0)) 
	    rexCompile("[({!/%*+$=&?:,})]+") 
	    (input = rexReplace(input "_" 0)) 
	    (parse = parseString(input "\\")) 
	    when((length(parse) > 1) 
		(input = car(parse)) 
		for(i 2 
		    length(parse) 
		    (input = strcat(input 
			    nth((i - 1) parse)
			))
		) 
		(input = strcat(input "*"))
	    )
	    (parse = parseString(input "")) 
	    when(atoi(car(last(parse))) 
		(input = TRL_ALTIUM2HDL_PCB_Util_Find_BUS_Tap(input))
	    ) input else 
	    (input = "NIL-NAMEMAPPER")
	)
    )
)
procedure(TRL_ALTIUM2HDL_Pin_Mapping(sym_rec sym_views display) 
    let((designator id pname pins pins_implicit
	    index pin_name_list pinTable pinOk des_list
	    disp_mode record
	) 
	(index = 1) 
	(pins = list()) 
	(pins_implicit = list()) 
	(pin_name_list = list())
	(des_list = list()) 
	foreach(rec sym_rec 
	    (id = get(rec 
		    'OWNERPARTID
		)) 
	    (pname = get(rec 
		    'NAME
		)) 
	    (designator = get(rec 
		    'DESIGNATOR
		))
	    (disp_mode = get(rec 
		    'OWNERPARTDISPLAYMODE
		)) 
	    (record = get(rec 
		    'RECORD
		)) 
	    if(display then 
		if((disp_mode == display) then 
		    (disp_mode = t) else 
		    (disp_mode = nil)
		) else 
		if(disp_mode then 
		    (disp_mode = nil) else 
		    (disp_mode = t)
		)
	    ) 
	    when(((record == "2") && disp_mode) 
		unless(member(designator des_list) 
		    (pname = TRL_ALTIUM2HDL_Preprocess_ASCII_File(pname)) 
		    (pname = TRL_ALTIUM2HDL_SCH_Util_PINNamemaper(pname)) 
		    (pname = upperCase(pname)) 
		    if(id then 
			if(member(list(pname id) pin_name_list) then 
			    (pname = sprintf(nil "%s_%d" pname index)) 
			    (pin_name_list = cons(list(pname id) pin_name_list)) 
			    (pins = cons(list(designator pname id rec) pins))
			    index++ else 
			    (pin_name_list = cons(list(pname id) pin_name_list)) 
			    (pins = cons(list(designator pname id rec) pins))
			) else 
			(pins_implicit = cons(list(designator pname rec) pins_implicit))
		    )
		    (des_list = cons(designator des_list))
		)
	    )
	) 
	(pinTable = makeTable('listOFlists nil)) 
	foreach(pin pins 
	    (pinTable[cadr(pin)] = list())
	) 
	foreach(sec sym_views 
	    foreach(pin 
		(pinTable->?) 
		(pinOk = nil) 
		foreach(rec pins 
		    when(((caddr(rec) == sec) && (cadr(rec) == pin)) 
			(pinTable[pin] = cons(car(rec) 
				pinTable[pin]
			    )) 
			(pinOk = t)
		    )
		) 
		unless(pinOk 
		    (pinTable[pin] = cons("0" 
			    pinTable[pin]
			))
		)
	    )
	)
	list(pinTable pins pins_implicit)
    )
)
procedure(TRL_ALTIUM2HDL_Preprocess_ASCII_File(string) 
    let((pcr_compil replace_list new_string) 
	(new_string = string) 
	unless(new_string 
	    (new_string = "NIL")
	) 
	(replace_list = list(list("\"" "") 
		list("\\006" "_") 
		list("\\355" "Deg") 
		list("\\251" "C") 
		list("\\334" "Ue")
		list("\\374" "ue") 
		list("\\326" "Oe") 
		list("\\366" "oe") 
		list("\\304" "Ae") 
		list("\\344" "ae")
		list("\\265" "u") 
		list("\\260" "deg") 
		list("\\262" "sq") 
		list("\\337" "ss") 
		list("\\330" "o")
		list("\\370" "o") 
		list("\\231" "TM") 
		list("\\327" "x") 
		list("\\134" "_") 
		list("\\204" "_")
		list("\\223" "_") 
		list("\\275" "_") 
		list("\\261" "+/-") 
		list("\\240" "_") 
		list("\\222" "_")
		list("\\226" "-") 
		list("\\256" "Reg")
	    )) 
	foreach(specialChar replace_list 
	    (pcr_compil = pcreCompile(car(specialChar))) 
	    (new_string = pcreReplace(pcr_compil new_string 
		    cadr(specialChar) 0
		))
	)
	new_string
    )
)
procedure(TRL_ALTIUM2HDL_ProjectSetUp() 
    let((flag proj_loc proj_name proj_dir oprt) 
	(proj_loc = (axlFormGetField 
		(trl_altium2hdl_global->formid) "projloc_l"
	    )) 
	when((proj_loc == "") 
	    (proj_loc = getWorkingDir()) 
	    (axlFormSetField 
		(trl_altium2hdl_global->formid) "projloc_l" proj_loc
	    )
	) 
	(proj_name = (axlFormGetField 
		(trl_altium2hdl_global->formid) "projname_l"
	    )) 
	when((proj_name = "") 
	    (proj_name = "project_1") 
	    (axlFormSetField 
		(trl_altium2hdl_global->formid) "projname_l" proj_name
	    )
	)
	(proj_dir = strcat(proj_loc "/" proj_name)) 
	if(isDir(proj_dir) then 
	    (flag = t) 
	    unless(isWritable(proj_dir) 
		(flag = nil)
	    ) else
	    createDir(proj_dir) 
	    when(isDir(proj_dir) 
		(flag = t)
	    )
	) 
	when((flag && (axlFormGetField 
		    (trl_altium2hdl_global->formid) "orcad_flow"
		)) 
	    createDir(strcat(proj_dir "/metadata")) 
	    createDir(strcat(proj_dir "/metadata/scmlib")) 
	    (oprt = outfile(strcat(proj_dir "/metadata/cds.lib"))) 
	    fprintf(oprt "DEFINE scmlib scmlib\n")
	    close(oprt)
	) flag
    )
)
procedure(TRL_ALTIUM2HDL_SCH_Create_BlockPort(outPort x y pin_side pin_styl
	io_type arrow image_path view_name harness
    ) 
    let((a) 
	(a = a) 
	case(arrow 
	    ("Block & Triangle" 
		case(pin_side 
		    ("0" 
			if(harness then 
			    TRL_ALTIUM2HDL_SCH_Create_BlockPort_Shape_Harness_Hori(outPort x y "/block_harness_right.jpg" image_path
				view_name
			    ) else 
			    if((io_type == "0") then 
				case(pin_styl 
				    ("0" 
					TRL_ALTIUM2HDL_SCH_Create_BlockPort_Shape_Passive_Hori(outPort x y "/block_non_hori_bt.jpg" image_path
					    view_name
					)
				    ) 
				    ("1" 
					TRL_ALTIUM2HDL_SCH_Create_BlockPort_Shape_Left_Hori(outPort x y "/block_left_bt.jpg" image_path
					    view_name
					)
				    ) 
				    ("2" 
					TRL_ALTIUM2HDL_SCH_Create_BlockPort_Shape_Right_Hori(outPort x y "/block_right_bt.jpg" image_path
					    view_name
					)
				    ) 
				    ("3" 
					TRL_ALTIUM2HDL_SCH_Create_BlockPort_Shape_LeftRight_Hori(outPort x y "/block_leftright_bt.jpg" image_path
					    view_name
					)
				    )
				    (t)
				) else 
				case(io_type 
				    ("1" 
					TRL_ALTIUM2HDL_SCH_Create_BlockPort_Shape_Left_Hori(outPort x y "/block_left_bt.jpg" image_path
					    view_name
					)
				    ) 
				    ("2" 
					TRL_ALTIUM2HDL_SCH_Create_BlockPort_Shape_Right_Hori(outPort x y "/block_right_bt.jpg" image_path
					    view_name
					)
				    ) 
				    ("3" 
					TRL_ALTIUM2HDL_SCH_Create_BlockPort_Shape_LeftRight_Hori(outPort x y "/block_leftright_bt.jpg" image_path
					    view_name
					)
				    ) 
				    (t)
				)
			    )
			)
		    ) 
		    ("1" 
			if(harness then 
			    TRL_ALTIUM2HDL_SCH_Create_BlockPort_Shape_Harness_Hori(outPort x y "/block_harness_right.jpg" image_path
				view_name
			    ) else 
			    if((io_type == "0") then 
				case(pin_styl 
				    ("0" 
					TRL_ALTIUM2HDL_SCH_Create_BlockPort_Shape_Passive_Hori(outPort x y "/block_non_hori_bt.jpg" image_path
					    view_name
					)
				    ) 
				    ("1" 
					TRL_ALTIUM2HDL_SCH_Create_BlockPort_Shape_Left_Hori(outPort x y "/block_left_bt.jpg" image_path
					    view_name
					)
				    ) 
				    ("2" 
					TRL_ALTIUM2HDL_SCH_Create_BlockPort_Shape_Right_Hori(outPort x y "/block_right_bt.jpg" image_path
					    view_name
					)
				    ) 
				    ("3" 
					TRL_ALTIUM2HDL_SCH_Create_BlockPort_Shape_LeftRight_Hori(outPort x y "/block_leftright_bt.jpg" image_path
					    view_name
					)
				    )
				    (t)
				) else 
				case(io_type 
				    ("1" 
					TRL_ALTIUM2HDL_SCH_Create_BlockPort_Shape_Right_Hori(outPort x y "/block_right_bt.jpg" image_path
					    view_name
					)
				    ) 
				    ("2" 
					TRL_ALTIUM2HDL_SCH_Create_BlockPort_Shape_Left_Hori(outPort x y "/block_left_bt.jpg" image_path
					    view_name
					)
				    ) 
				    ("3" 
					TRL_ALTIUM2HDL_SCH_Create_BlockPort_Shape_LeftRight_Hori(outPort x y "/block_leftright_bt.jpg" image_path
					    view_name
					)
				    ) 
				    (t)
				)
			    )
			)
		    ) 
		    ("2" 
			if(harness then 
			    TRL_ALTIUM2HDL_SCH_Create_BlockPort_Shape_Harness_Vert(outPort x y "/block_harness_bot.jpg" image_path
				view_name
			    ) else 
			    if((io_type == "0") then 
				case(pin_styl 
				    ("4" 
					TRL_ALTIUM2HDL_SCH_Create_BlockPort_Shape_Passive_Vert(outPort x y "/block_non_vert_bt.jpg" image_path
					    view_name
					)
				    ) 
				    ("5" 
					TRL_ALTIUM2HDL_SCH_Create_BlockPort_Shape_Top_Vert(outPort x y "/block_top_bt.jpg" image_path
					    view_name
					)
				    ) 
				    ("6" 
					TRL_ALTIUM2HDL_SCH_Create_BlockPort_Shape_Bot_Vert(outPort x y "/block_bot_bt.jpg" image_path
					    view_name
					)
				    ) 
				    ("7" 
					TRL_ALTIUM2HDL_SCH_Create_BlockPort_Shape_TopBot_Vert(outPort x y "/block_topbot_bt.jpg" image_path
					    view_name
					)
				    )
				    (t)
				) else 
				case(io_type 
				    ("1" 
					TRL_ALTIUM2HDL_SCH_Create_BlockPort_Shape_Top_Vert(outPort x y "/block_top_bt.jpg" image_path
					    view_name
					)
				    ) 
				    ("2" 
					TRL_ALTIUM2HDL_SCH_Create_BlockPort_Shape_Bot_Vert(outPort x y "/block_bot_bt.jpg" image_path
					    view_name
					)
				    ) 
				    ("3" 
					TRL_ALTIUM2HDL_SCH_Create_BlockPort_Shape_TopBot_Vert(outPort x y "/block_topbot_bt.jpg" image_path
					    view_name
					)
				    ) 
				    (t)
				)
			    )
			)
		    ) 
		    ("3" 
			if(harness then 
			    TRL_ALTIUM2HDL_SCH_Create_BlockPort_Shape_Harness_Vert(outPort x y "/block_harness_bot.jpg" image_path
				view_name
			    ) else 
			    if((io_type == "0") then 
				case(pin_styl 
				    ("3" 
					TRL_ALTIUM2HDL_SCH_Create_BlockPort_Shape_TopBot_Vert(outPort x y "/block_topbot_bt.jpg" image_path
					    view_name
					)
				    ) 
				    ("4" 
					TRL_ALTIUM2HDL_SCH_Create_BlockPort_Shape_Passive_Vert(outPort x y "/block_non_vert_bt.jpg" image_path
					    view_name
					)
				    ) 
				    ("5" 
					TRL_ALTIUM2HDL_SCH_Create_BlockPort_Shape_Top_Vert(outPort x y "/block_top_bt.jpg" image_path
					    view_name
					)
				    ) 
				    ("6" 
					TRL_ALTIUM2HDL_SCH_Create_BlockPort_Shape_Bot_Vert(outPort x y "/block_bot_bt.jpg" image_path
					    view_name
					)
				    )
				    ("7" 
					TRL_ALTIUM2HDL_SCH_Create_BlockPort_Shape_TopBot_Vert(outPort x y "/block_topbot_bt.jpg" image_path
					    view_name
					)
				    ) 
				    (t)
				) else 
				case(io_type 
				    ("2" 
					TRL_ALTIUM2HDL_SCH_Create_BlockPort_Shape_Top_Vert(outPort x y "/block_top_bt.jpg" image_path
					    view_name
					)
				    ) 
				    ("1" 
					TRL_ALTIUM2HDL_SCH_Create_BlockPort_Shape_Bot_Vert(outPort x y "/block_bot_bt.jpg" image_path
					    view_name
					)
				    ) 
				    ("3" 
					TRL_ALTIUM2HDL_SCH_Create_BlockPort_Shape_TopBot_Vert(outPort x y "/block_topbot_bt.jpg" image_path
					    view_name
					)
				    ) 
				    (t)
				)
			    )
			)
		    )
		    (t)
		)
	    ) 
	    (t 
		printf("case(arrow-> %L %L %L %L %L %L\n" x y pin_side pin_styl
		    io_type arrow
		)
	    )
	)
    )
)
procedure(TRL_ALTIUM2HDL_SCH_Create_BlockPort_Shape_Bot_Vert(outPort x y image image_path
	view_name
    ) 
    let(nil 
	fprintf(outPort "L %d %d %d %d -1 16\n" 
	    (x - 20) y 
	    (x - 20)
	    (y - 60)
	) 
	fprintf(outPort "L %d %d %d %d -1 16\n" 
	    (x - 20) 
	    (y - 60) x
	    (y - 80)
	) 
	fprintf(outPort "L %d %d %d %d -1 16\n" x 
	    (y - 80) 
	    (x + 20)
	    (y - 60)
	) 
	fprintf(outPort "L %d %d %d %d -1 16\n" 
	    (x + 20) 
	    (y - 60) 
	    (x + 20)
	    y
	)
	fprintf(outPort "L %d %d %d %d -1 16\n" 
	    (x - 20) y 
	    (x + 20)
	    y
	) 
	unless((axlFormGetField 
		(trl_altium2hdl_global->formid) "simple_sym_pin"
	    ) 
	    (axlOSFileCopy 
		strcat(image_path image) 
		strcat(view_name "/images" image) nil
	    ) 
	    fprintf(outPort "T %d %d 0.00 0.00 47 0 0 1 0 28 0\n" x 
		(y - 40)
	    ) 
	    fprintf(outPort "$CDS_IMAGE|block_bot_bt.jpg|40|80\n")
	)
    )
)
procedure(TRL_ALTIUM2HDL_SCH_Create_BlockPort_Shape_Harness_Hori(outPort x y image image_path
	view_name
    ) 
    let(nil 
	if((axlFormGetField 
		(trl_altium2hdl_global->formid) "simple_sym_pin"
	    ) then 
	    fprintf(outPort "M %d %d %d %d -1 16\n" x y 
		(x + 20)
		(y + 20)
	    ) 
	    fprintf(outPort "M %d %d %d %d -1 16\n" 
		(x + 20) 
		(y + 20) 
		(x + 60)
		(y + 20)
	    ) 
	    fprintf(outPort "M %d %d %d %d -1 16\n" 
		(x + 60) 
		(y + 20) 
		(x + 80)
		y
	    )
	    fprintf(outPort "M %d %d %d %d -1 16\n" 
		(x + 80) y 
		(x + 60)
		(y - 20)
	    ) 
	    fprintf(outPort "M %d %d %d %d -1 16\n" 
		(x + 60) 
		(y - 20) 
		(x + 20)
		(y - 20)
	    ) 
	    fprintf(outPort "M %d %d %d %d -1 16\n" 
		(x + 20) 
		(y - 20) x
		y
	    ) else 
	    fprintf(outPort "L %d %d %d %d -1 16\n" x y 
		(x + 20)
		(y + 20)
	    )
	    fprintf(outPort "L %d %d %d %d -1 16\n" 
		(x + 20) 
		(y + 20) 
		(x + 60)
		(y + 20)
	    ) 
	    fprintf(outPort "L %d %d %d %d -1 16\n" 
		(x + 60) 
		(y + 20) 
		(x + 80)
		y
	    ) 
	    fprintf(outPort "L %d %d %d %d -1 16\n" 
		(x + 80) y 
		(x + 60)
		(y - 20)
	    ) 
	    fprintf(outPort "L %d %d %d %d -1 16\n" 
		(x + 60) 
		(y - 20) 
		(x + 20)
		(y - 20)
	    ) 
	    fprintf(outPort "L %d %d %d %d -1 16\n" 
		(x + 20) 
		(y - 20) x
		y
	    )
	    (axlOSFileCopy 
		strcat(image_path image) 
		strcat(view_name "/images" image) nil
	    ) 
	    fprintf(outPort "T %d %d 0.00 0.00 47 0 0 1 0 38 0\n" 
		(x + 40) 
		(y + 2)
	    ) 
	    fprintf(outPort "$CDS_IMAGE|block_harness_right.jpg|80|50\n")
	)
    )
)
procedure(TRL_ALTIUM2HDL_SCH_Create_BlockPort_Shape_Harness_Vert(outPort x y image image_path
	view_name
    ) 
    let(nil 
	if((axlFormGetField 
		(trl_altium2hdl_global->formid) "simple_sym_pin"
	    ) then 
	    fprintf(outPort "M %d %d %d %d -1 16\n" x y 
		(x - 20)
		(y - 20)
	    ) 
	    fprintf(outPort "M %d %d %d %d -1 16\n" 
		(x - 20) 
		(y - 20) 
		(x - 20)
		(y - 60)
	    ) 
	    fprintf(outPort "M %d %d %d %d -1 16\n" 
		(x - 20) 
		(y - 60) x
		(y - 80)
	    )
	    fprintf(outPort "M %d %d %d %d -1 16\n" x 
		(y - 80) 
		(x + 20)
		(y - 60)
	    ) 
	    fprintf(outPort "M %d %d %d %d -1 16\n" 
		(x + 20) 
		(y - 60) 
		(x + 20)
		(y - 20)
	    ) 
	    fprintf(outPort "M %d %d %d %d -1 16\n" 
		(x + 20) 
		(y - 20) x
		y
	    ) else 
	    fprintf(outPort "L %d %d %d %d -1 16\n" x y 
		(x - 20)
		(y - 20)
	    )
	    fprintf(outPort "L %d %d %d %d -1 16\n" 
		(x - 20) 
		(y - 20) 
		(x - 20)
		(y - 60)
	    ) 
	    fprintf(outPort "L %d %d %d %d -1 16\n" 
		(x - 20) 
		(y - 60) x
		(y - 80)
	    ) 
	    fprintf(outPort "L %d %d %d %d -1 16\n" x 
		(y - 80) 
		(x + 20)
		(y - 60)
	    ) 
	    fprintf(outPort "L %d %d %d %d -1 16\n" 
		(x + 20) 
		(y - 60) 
		(x + 20)
		(y - 20)
	    ) 
	    fprintf(outPort "L %d %d %d %d -1 16\n" 
		(x + 20) 
		(y - 20) x
		y
	    )
	    (axlOSFileCopy 
		strcat(image_path image) 
		strcat(view_name "/images" image) nil
	    ) 
	    fprintf(outPort "T %d %d 0.00 0.00 47 0 0 1 0 28 0\n" x 
		(y - 40)
	    ) 
	    fprintf(outPort "$CDS_IMAGE|block_harness_bot.jpg|46|80\n")
	)
    )
)
procedure(TRL_ALTIUM2HDL_SCH_Create_BlockPort_Shape_LeftRight_Hori(outPort x y image image_path
	view_name
    ) 
    let(nil 
	fprintf(outPort "L %d %d %d %d -1 16\n" x y 
	    (x + 20)
	    (y + 20)
	) 
	fprintf(outPort "L %d %d %d %d -1 16\n" 
	    (x + 20) 
	    (y + 20) 
	    (x + 60)
	    (y + 20)
	) 
	fprintf(outPort "L %d %d %d %d -1 16\n" 
	    (x + 60) 
	    (y + 20) 
	    (x + 80)
	    y
	) 
	fprintf(outPort "L %d %d %d %d -1 16\n" 
	    (x + 80) y 
	    (x + 60)
	    (y - 20)
	)
	fprintf(outPort "L %d %d %d %d -1 16\n" 
	    (x + 60) 
	    (y - 20) 
	    (x + 20)
	    (y - 20)
	) 
	fprintf(outPort "L %d %d %d %d -1 16\n" 
	    (x + 20) 
	    (y - 20) x
	    y
	) 
	unless((axlFormGetField 
		(trl_altium2hdl_global->formid) "simple_sym_pin"
	    ) 
	    (axlOSFileCopy 
		strcat(image_path image) 
		strcat(view_name "/images" image) nil
	    ) 
	    fprintf(outPort "T %d %d 0.00 0.00 47 0 0 1 0 28 0\n" 
		(x + 40) y
	    ) 
	    fprintf(outPort "$CDS_IMAGE|block_leftright_bt.jpg|80|40\n")
	)
    )
)
procedure(TRL_ALTIUM2HDL_SCH_Create_BlockPort_Shape_Left_Hori(outPort x y image image_path
	view_name
    ) 
    let(nil 
	fprintf(outPort "L %d %d %d %d -1 16\n" x y 
	    (x + 20)
	    (y + 20)
	) 
	fprintf(outPort "L %d %d %d %d -1 16\n" 
	    (x + 20) 
	    (y + 20) 
	    (x + 80)
	    (y + 20)
	) 
	fprintf(outPort "L %d %d %d %d -1 16\n" 
	    (x + 80) 
	    (y + 20) 
	    (x + 80)
	    (y - 20)
	) 
	fprintf(outPort "L %d %d %d %d -1 16\n" 
	    (x + 80) 
	    (y - 20) 
	    (x + 20)
	    (y - 20)
	)
	fprintf(outPort "L %d %d %d %d -1 16\n" 
	    (x + 20) 
	    (y - 20) x
	    y
	) 
	unless((axlFormGetField 
		(trl_altium2hdl_global->formid) "simple_sym_pin"
	    ) 
	    (axlOSFileCopy 
		strcat(image_path image) 
		strcat(view_name "/images" image) nil
	    ) 
	    fprintf(outPort "T %d %d 0.00 0.00 47 0 0 1 0 28 0\n" 
		(x + 40) y
	    ) 
	    fprintf(outPort "$CDS_IMAGE|block_left_bt.jpg|80|40\n")
	)
    )
)
procedure(TRL_ALTIUM2HDL_SCH_Create_BlockPort_Shape_Passive_Hori(outPort x y image image_path
	view_name
    ) 
    let(nil 
	fprintf(outPort "L %d %d %d %d -1 16\n" x 
	    (y + 20) 
	    (x + 80)
	    (y + 20)
	) 
	fprintf(outPort "L %d %d %d %d -1 16\n" 
	    (x + 80) 
	    (y + 20) 
	    (x + 80)
	    (y - 20)
	) 
	fprintf(outPort "L %d %d %d %d -1 16\n" 
	    (x + 80) 
	    (y - 20) x
	    (y - 20)
	) 
	fprintf(outPort "L %d %d %d %d -1 16\n" x 
	    (y - 20) x
	    (y + 20)
	)
	unless((axlFormGetField 
		(trl_altium2hdl_global->formid) "simple_sym_pin"
	    ) 
	    (axlOSFileCopy 
		strcat(image_path image) 
		strcat(view_name "/images" image) nil
	    ) 
	    fprintf(outPort "T %d %d 0.00 0.00 47 0 0 1 0 28 0\n" 
		(x + 40) y
	    ) 
	    fprintf(outPort "$CDS_IMAGE|block_non_hori_bt.jpg|80|40\n")
	)
    )
)
procedure(TRL_ALTIUM2HDL_SCH_Create_BlockPort_Shape_Passive_Vert(outPort x y image image_path
	view_name
    ) 
    let(nil 
	fprintf(outPort "L %d %d %d %d -1 16\n" 
	    (x - 20) y 
	    (x - 20)
	    (y - 80)
	) 
	fprintf(outPort "L %d %d %d %d -1 16\n" 
	    (x - 20) 
	    (y - 80) 
	    (x + 20)
	    (y - 80)
	) 
	fprintf(outPort "L %d %d %d %d -1 16\n" 
	    (x + 20) 
	    (y - 80) 
	    (x + 20)
	    y
	) 
	fprintf(outPort "L %d %d %d %d -1 16\n" 
	    (x - 20) y 
	    (x + 20)
	    y
	)
	unless((axlFormGetField 
		(trl_altium2hdl_global->formid) "simple_sym_pin"
	    ) 
	    (axlOSFileCopy 
		strcat(image_path image) 
		strcat(view_name "/images" image) nil
	    ) 
	    fprintf(outPort "T %d %d 0.00 0.00 47 0 0 1 0 28 0\n" x 
		(y - 40)
	    ) 
	    fprintf(outPort "$CDS_IMAGE|block_non_vert_bt.jpg|40|80\n")
	)
    )
)
procedure(TRL_ALTIUM2HDL_SCH_Create_BlockPort_Shape_Right_Hori(outPort x y image image_path
	view_name
    ) 
    let(nil 
	fprintf(outPort "L %d %d %d %d -1 16\n" x 
	    (y + 20) 
	    (x + 60)
	    (y + 20)
	) 
	fprintf(outPort "L %d %d %d %d -1 16\n" 
	    (x + 60) 
	    (y + 20) 
	    (x + 80)
	    y
	) 
	fprintf(outPort "L %d %d %d %d -1 16\n" 
	    (x + 80) y 
	    (x + 60)
	    (y - 20)
	) 
	fprintf(outPort "L %d %d %d %d -1 16\n" 
	    (x + 60) 
	    (y - 20) x
	    (y - 20)
	)
	fprintf(outPort "L %d %d %d %d -1 16\n" x 
	    (y + 20) x
	    (y - 20)
	) 
	unless((axlFormGetField 
		(trl_altium2hdl_global->formid) "simple_sym_pin"
	    ) 
	    (axlOSFileCopy 
		strcat(image_path image) 
		strcat(view_name "/images" image) nil
	    ) 
	    fprintf(outPort "T %d %d 0.00 0.00 47 0 0 1 0 28 0\n" 
		(x + 40) y
	    ) 
	    fprintf(outPort "$CDS_IMAGE|block_right_bt.jpg|80|40\n")
	)
    )
)
procedure(TRL_ALTIUM2HDL_SCH_Create_BlockPort_Shape_TopBot_Vert(outPort x y image image_path
	view_name
    ) 
    let(nil 
	fprintf(outPort "L %d %d %d %d -1 16\n" x y 
	    (x - 20)
	    (y - 20)
	) 
	fprintf(outPort "L %d %d %d %d -1 16\n" 
	    (x - 20) 
	    (y - 20) 
	    (x - 20)
	    (y - 60)
	) 
	fprintf(outPort "L %d %d %d %d -1 16\n" 
	    (x - 20) 
	    (y - 60) x
	    (y - 80)
	) 
	fprintf(outPort "L %d %d %d %d -1 16\n" x 
	    (y - 80) 
	    (x + 20)
	    (y - 60)
	)
	fprintf(outPort "L %d %d %d %d -1 16\n" 
	    (x + 20) 
	    (y - 60) 
	    (x + 20)
	    (y - 20)
	) 
	fprintf(outPort "L %d %d %d %d -1 16\n" 
	    (x + 20) 
	    (y - 20) x
	    y
	) 
	unless((axlFormGetField 
		(trl_altium2hdl_global->formid) "simple_sym_pin"
	    ) 
	    (axlOSFileCopy 
		strcat(image_path image) 
		strcat(view_name "/images" image) nil
	    ) 
	    fprintf(outPort "T %d %d 0.00 0.00 47 0 0 1 0 28 0\n" x 
		(y - 40)
	    ) 
	    fprintf(outPort "$CDS_IMAGE|block_topbot_bt.jpg|40|80\n")
	)
    )
)
procedure(TRL_ALTIUM2HDL_SCH_Create_BlockPort_Shape_Top_Vert(outPort x y image image_path
	view_name
    ) 
    let(nil 
	fprintf(outPort "L %d %d %d %d -1 16\n" x y 
	    (x - 20)
	    (y - 20)
	) 
	fprintf(outPort "L %d %d %d %d -1 16\n" 
	    (x - 20) 
	    (y - 20) 
	    (x - 20)
	    (y - 80)
	) 
	fprintf(outPort "L %d %d %d %d -1 16\n" 
	    (x - 20) 
	    (y - 80) 
	    (x + 20)
	    (y - 80)
	) 
	fprintf(outPort "L %d %d %d %d -1 16\n" 
	    (x + 20) 
	    (y - 80) 
	    (x + 20)
	    (y - 20)
	)
	fprintf(outPort "L %d %d %d %d -1 16\n" 
	    (x + 20) 
	    (y - 20) x
	    y
	) 
	unless((axlFormGetField 
		(trl_altium2hdl_global->formid) "simple_sym_pin"
	    ) 
	    (axlOSFileCopy 
		strcat(image_path image) 
		strcat(view_name "/images") nil
	    ) 
	    fprintf(outPort "T %d %d 0.00 0.00 47 0 0 1 0 28 0\n" x 
		(y - 40)
	    ) 
	    fprintf(outPort "$CDS_IMAGE|block_top_bt.jpg|40|80\n")
	)
    )
)
procedure(TRL_ALTIUM2HDL_SCH_Create_BlockSymbol(block_name block_data refdes_data file_data port_list
	harnessPorts
    ) 
    let((lib_name cell_name view_name outPort size_x
	    size_y pin_name pin_side pin_stap pin_styl
	    t_size io_type arrow image_path cmd_str
	    type harness pin_text harness_X harness_Y
	    harness_S
	) 
	unless(refdes_data t) 
	unless(file_data t) 
	(trl_altium2hdl_global->exeption = cons("                  -------------------------------------------------------------" 
		(trl_altium2hdl_global->exeption)
	    )) 
	(trl_altium2hdl_global->exeption = cons(sprintf(nil "   3.8.3  INFO    - BLOCK: [%L] Start to Create BLOCK Symbols.." block_name) 
		(trl_altium2hdl_global->exeption)
	    ))
	(lib_name = nth(4 
		(trl_altium2hdl_global->files)
	    )) 
	(lib_name = strcat(lib_name "/" 
		nth(5 
		    (trl_altium2hdl_global->files)
		)
	    )) 
	(lib_name = strcat(lib_name "/worklib")) 
	if(lib_name then 
	    unless(isDir(lib_name) 
		createDir(lib_name)
	    ) 
	    (cell_name = strcat(lib_name "/" 
		    lowerCase(block_name)
		)) 
	    unless(isDir(cell_name) 
		createDir(cell_name)
	    )
	    (view_name = strcat(cell_name "/" "images")) 
	    unless(isDir(view_name) 
		createDir(view_name)
	    ) 
	    (image_path = nth(4 
		    (trl_altium2hdl_global->files)
		)) 
	    (image_path = strcat(image_path "/" 
		    nth(5 
			(trl_altium2hdl_global->files)
		    )
		)) 
	    (image_path = strcat(image_path "/images"))
	    (axlOSFileCopy 
		strcat(image_path "/block.jpg") 
		strcat(view_name "/block.jpg") nil
	    ) 
	    (view_name = strcat(cell_name "/" "sym_1")) 
	    unless(isDir(view_name) 
		createDir(view_name)
	    ) 
	    TRL_ALTIUM2HDL_Create_Concept_View_Tag(view_name "symbol.css") 
	    (outPort = outfile(strcat(view_name "/symbol.css")))
	    (size_x = (atoi(caddr(block_data)) * 5)) 
	    (size_y = (atoi(nth(3 block_data)) * 5)) 
	    fprintf(outPort "L 0 0 %d 0 -1 16\n" size_x) 
	    fprintf(outPort "L %d 0 %d %d -1 16\n" size_x size_x 
		(- size_y)
	    ) 
	    fprintf(outPort "L %d %d 0 %d -1 16\n" size_x 
		(- size_y) 
		(- size_y)
	    )
	    fprintf(outPort "L 0 %d 0 0 -1 16\n" 
		(- size_y)
	    ) 
	    foreach(pin port_list 
		(pin_name = get(pin 
			'NAME
		    )) 
		(pin_side = get(pin 
			'SIDE
		    )) 
		(pin_stap = get(pin 
			'DISTANCEFROMTOP
		    ))
		(pin_styl = get(pin 
			'STYLE
		    )) 
		(io_type = get(pin 
			'IOTYPE
		    )) 
		(arrow = get(pin 
			'ARROWKIND
		    )) 
		(harness = get(pin 
			'HARNESSTYPE
		    )) 
		unless(pin_stap 
		    (pin_stap = "1")
		)
		unless(pin_styl 
		    (pin_styl = "0")
		) 
		unless(io_type 
		    (io_type = "0")
		) 
		unless(pin_side 
		    (pin_side = "0")
		) 
		case(io_type 
		    ("0" 
			case(pin_styl 
			    ("0" 
				(type = "IN")
			    ) 
			    ("1" 
				(type = "IN")
			    ) 
			    ("2" 
				(type = "OUT")
			    ) 
			    ("3" 
				(type = "INOUT")
			    )
			    ("4" 
				(type = "IN")
			    ) 
			    ("5" 
				(type = "IN")
			    ) 
			    ("6" 
				(type = "OUT")
			    ) 
			    ("7" 
				(type = "INOUT")
			    ) 
			    (t 
				(type = "IN") 
				printf("--IOTYPE: %L Style: %L\n" io_type pin_styl)
			    )
			)
		    ) 
		    ("1" 
			(type = "IN")
		    ) 
		    ("2" 
			(type = "OUT")
		    ) 
		    ("3" 
			(type = "INOUT")
		    )
		    (t 
			(type = "IN") 
			printf("--IOTYPE: %L\n" io_type)
		    )
		) 
		(type = "INOUT")
		(pin_text = pin_name) 
		if(harness then 
		    if((trl_altium2hdl_global->Harness_Adap) then 
			foreach(adapter 
			    (trl_altium2hdl_global->Harness_Adap) 
			    when((car(adapter) == harness) 
				(pin_name = TRL_ALTIUM2HDL_PCB_Util_Signal_Namemaper(harness)) 
				when((length(cadr(adapter)) > 1) 
				    (pin_name = sprintf(nil "%s<0..%d>" pin_name 
					    (length(cadr(adapter)) - 1)
					))
				) 
				(harness_X = atoi(car(block_data))) 
				(harness_Y = atoi(cadr(block_data)))
				(harness_S = (atoi(pin_stap) * 10)) 
				when((pin_side == "0") 
				    (harness_Y = (harness_Y - harness_S))
				) 
				when((pin_side == "1") 
				    (harness_X = (harness_X + atoi(caddr(block_data)))) 
				    (harness_Y = (harness_Y - harness_S))
				) 
				when((pin_side == "2") 
				    (harness_X = (harness_X + harness_S))
				) 
				when((pin_side == "1") 
				    (harness_X = (harness_X + atoi(caddr(block_data)))) 
				    (harness_Y = (harness_Y - atoi(cadddr(block_data))))
				)
				(harnessPorts = cons(list((harness_X:harness_Y) harness 
					    cadr(adapter)
					) harnessPorts
				    ))
			    )
			) else 
			(pin_name = TRL_ALTIUM2HDL_PCB_Util_Signal_Namemaper(harness))
		    ) else 
		    (pin_name = TRL_ALTIUM2HDL_PCB_Util_Signal_Namemaper(pin_name))
		) 
		(pin_stap = (atoi(pin_stap) * 50)) 
		(t_size = 36) 
		case(pin_side 
		    ("0" 
			fprintf(outPort "C 0 %d %L -100 0 0 1 41 0 L\n" 
			    (- pin_stap) pin_name
			) 
			fprintf(outPort "X \"PIN_TEXT\" %L 100 %d 0.00 0.00 %d 0 0 0 0 0 1 0 70\n" pin_text 
			    ((- pin_stap) - 18) t_size
			) 
			fprintf(outPort "X \"VHDL_MODE\" %L 100 %d 0.00 0.00 %d 0 0 0 0 0 0 0 126\n" type 
			    ((- pin_stap) - 18) t_size
			) 
			fprintf(outPort "X \"VHDL_SCALAR_TYPE\" \"std_logic\" 100 %d 0.00 0.00 %d 0 0 0 0 0 0 0 126\n" 
			    ((- pin_stap) - 18) t_size
			)
			TRL_ALTIUM2HDL_SCH_Create_BlockPort(outPort 0 
			    (- pin_stap) pin_side pin_styl
			    io_type arrow image_path cell_name harness
			)
		    ) 
		    ("1" 
			fprintf(outPort "C %d %d %L -100 0 0 1 41 0 L\n" size_x 
			    (- pin_stap) pin_name
			) 
			fprintf(outPort "X \"PIN_TEXT\" %L %d %d 0.00 0.00 %d 0 0 2 0 0 1 0 70\n" pin_text 
			    (size_x - 100) 
			    ((- pin_stap) - 18)
			    t_size
			) 
			fprintf(outPort "X \"VHDL_MODE\" %L %d %d 0.00 0.00 %d 0 0 0 0 0 0 0 126\n" type 
			    (size_x - 100) 
			    ((- pin_stap) - 18)
			    t_size
			) 
			fprintf(outPort "X \"VHDL_SCALAR_TYPE\" \"std_logic\" %d %d 0.00 0.00 %d 0 0 0 0 0 0 0 126\n" 
			    (size_x - 100) 
			    ((- pin_stap) - 18) t_size
			)
			TRL_ALTIUM2HDL_SCH_Create_BlockPort(outPort 
			    (size_x - 80) 
			    (- pin_stap) pin_side pin_styl
			    io_type arrow image_path cell_name harness
			)
		    ) 
		    ("2" 
			fprintf(outPort "C %d 0 %L -100 0 0 1 41 0 L\n" pin_stap pin_name) 
			fprintf(outPort "X \"PIN_TEXT\" %L %d -100 90.00 0.00 %d 0 0 2 0 0 1 0 70\n" pin_text 
			    (pin_stap + 18) t_size
			) 
			fprintf(outPort "X \"VHDL_MODE\" %L %d -100 90.00 0.00 %d 0 0 0 0 0 0 0 126\n" type 
			    (pin_stap + 18) t_size
			) 
			fprintf(outPort "X \"VHDL_SCALAR_TYPE\" \"std_logic\" %d -100 90.00 0.00 %d 0 0 0 0 0 0 0 126\n" 
			    (pin_stap + 18) t_size
			)
			TRL_ALTIUM2HDL_SCH_Create_BlockPort(outPort pin_stap 0 pin_side pin_styl
			    io_type arrow image_path cell_name harness
			)
		    ) 
		    ("3" 
			fprintf(outPort "C %d %d %L -100 0 0 1 41 0 L\n" pin_stap 
			    (- size_y) pin_name
			) 
			fprintf(outPort "X \"PIN_TEXT\" %L %d %d 90.00 0.00 %d 0 0 0 0 0 1 0 70\n" pin_text 
			    (pin_stap + 18) 
			    ((- size_y) + 100)
			    t_size
			) 
			fprintf(outPort "X \"VHDL_MODE\" %L %d %d 90.00 0.00 %d 0 0 0 0 0 0 0 126\n" type 
			    (pin_stap + 18) 
			    ((- size_y) + 100)
			    t_size
			) 
			fprintf(outPort "X \"VHDL_SCALAR_TYPE\" \"std_logic\" %d %d 90.00 0.00 %d 0 0 0 0 0 0 0 126\n" 
			    (pin_stap + 18) 
			    ((- size_y) + 100) t_size
			)
			TRL_ALTIUM2HDL_SCH_Create_BlockPort(outPort pin_stap 
			    ((- size_y) + 80) pin_side pin_styl
			    io_type arrow image_path cell_name harness
			)
		    )
		    (t)
		)
	    ) 
	    fprintf(outPort "P \"LIBRARY1\" \"ieee\" 0 0 0.00 0.00 20 0 0 0 0 0 0 0 72\n") 
	    fprintf(outPort "P \"USE1\" \"ieee.std_logic_1164.all\" 0 0 0.00 0.00 20 0 0 0 0 0 0 0 72\n") 
	    fprintf(outPort "P \"USE2\" \"work.all\" 0 0 0.00 0.00 20 0 0 0 0 0 0 0 72\n")
	    fprintf(outPort "P \"BLOCK\" \"TRUE\" 0 0 0.00 0.00 47 0 0 1 0 0 0 0 32\n") 
	    fprintf(outPort "P \"PATH\" \"?\" 0 0 0.00 0.00 47 0 0 1 0 0 0 0 32\n") 
	    unless((axlFormGetField 
		    (trl_altium2hdl_global->formid) "simple_sym_graphic"
		) 
		fprintf(outPort "T %d %d 0.00 0.00 47 0 0 1 0 30 0\n" 
		    (size_x / 2) 
		    ((- size_y) / 2)
		) 
		fprintf(outPort "$CDS_IMAGE|block.jpg|%d|%d\n" size_x size_y)
	    ) 
	    close(outPort) 
	    (cmd_str = "newgenasym")
	    (cmd_str = sprintf(nil "%s -i %s" cmd_str cell_name)) 
	    (cmd_str = sprintf(nil "%s -n %s -M > log_run.txt 2>&1" cmd_str block_name)) 
	    sh(cmd_str) else 
	    (trl_altium2hdl_global->exeption = cons(sprintf(nil "-->3.8.03 ERROR   - HDL Library Name: %L!" lib_name) 
		    (trl_altium2hdl_global->exeption)
		))
	) 
	when(harnessPorts 
	    foreach(hPort harnessPorts 
		(trl_altium2hdl_global->exeption = cons(sprintf(nil "   3.8.4  INFO    - BLOCK  Harness Port %L - %L - %L" 
			    cadr(hPort) 
			    car(hPort) 
			    caddr(hPort)
			) 
			(trl_altium2hdl_global->exeption)
		    ))
	    )
	)
	harnessPorts
    )
)
procedure(TRL_ALTIUM2HDL_SCH_Create_Concept_ADD_ALIAS(port sig_name port_alis_list start_x start_y
	end_x end_y
    ) 
    let((a) 
	(a = a) 
	foreach(port_a port_alis_list 
	    when((car(port_a) == (start_x:start_y)) 
		unless((car(sig_name) == cadr(port_a)) 
		    if((start_y == end_y) then 
			if((start_x < end_x) then 
			    (start_x = (start_x + 50)) 
			    fprintf(port "FORCEADD %s..1\n" "ALTIUM_ALIAS") 
			    fprintf(port "(%d %d);\n" 
				(start_x - 25) start_y
			    )
			    fprintf(port "PAINT RED (%d %d);\n" 
				(start_x - 25) start_y
			    ) else 
			    (start_x = (start_x - 50)) 
			    fprintf(port "FORCEADD %s..1\n" "ALTIUM_ALIAS") 
			    fprintf(port "R 4\n")
			    fprintf(port "(%d %d);\n" 
				(start_x + 25) start_y
			    ) 
			    fprintf(port "PAINT RED (%d %d);\n" 
				(start_x + 25) start_y
			    )
			) else 
			printf("-->Signame VERT %L - %L Start\n" sig_name 
			    cadr(port_a)
			)
		    )
		)
	    ) 
	    when((car(port_a) == (end_x:end_y)) 
		unless((car(sig_name) == cadr(port_a)) 
		    if((start_y == end_y) then 
			if((start_x < end_x) then 
			    (end_x = (end_x - 50)) 
			    fprintf(port "FORCEADD %s..1\n" "ALTIUM_ALIAS") 
			    fprintf(port "R 4\n")
			    fprintf(port "(%d %d);\n" 
				(end_x + 25) end_y
			    ) 
			    fprintf(port "PAINT RED (%d %d);\n" 
				(end_x + 25) end_y
			    ) else 
			    (end_x = (end_x + 50)) 
			    fprintf(port "FORCEADD %s..1\n" "ALTIUM_ALIAS")
			    fprintf(port "(%d %d);\n" 
				(end_x - 25) end_y
			    ) 
			    fprintf(port "PAINT RED (%d %d);\n" 
				(end_x - 25) end_y
			    )
			) else 
			printf("-->Signame VERT %L - %L End\n" sig_name 
			    cadr(port_a)
			)
		    )
		)
	    )
	) 
	list(start_x start_y end_x end_y)
    )
)
procedure(TRL_ALTIUM2HDL_SCH_Create_Concept_ADD_Block(port sch_name pgnr) 
    let((block_recs record block_list blocks_lst id
	    lx ly xsize ysize Designator
	    File_Name block_data refdes_data file_data port_list
	    block_name block_name_list dx dy fx
	    fy harnessPorts
	) 
	unless(pgnr 
	    printf("..ADD_Block->pgnr\n")
	) 
	foreach(data 
	    (trl_altium2hdl_global->Nets) 
	    when((car(data) == sch_name) 
		(block_recs = caddr(data)) 
		(block_recs = nth(7 block_recs))
	    )
	) 
	(block_list = list()) 
	(blocks_lst = list())
	(block_name_list = list()) 
	when(block_recs 
	    foreach(rec block_recs 
		(record = get(rec 
			'RECORD
		    )) 
		if(((record == "15") && block_list) then 
		    (blocks_lst = cons(block_list blocks_lst)) 
		    (block_list = list()) 
		    (block_list = cons(rec block_list))
		    else 
		    (block_list = cons(rec block_list))
		)
	    ) 
	    (blocks_lst = cons(block_list blocks_lst)) 
	    if(blocks_lst then 
		foreach(block blocks_lst 
		    foreach(rec block 
			(record = get(rec 
				'RECORD
			    )) 
			(id = get(rec 
				'OWNERPARTID
			    )) 
			when(((record == "15") && (id == "-1")) 
			    (lx = get(rec 
				    'LOCATION\.X
				)) 
			    (ly = get(rec 
				    'LOCATION\.Y
				)) 
			    (xsize = get(rec 
				    'XSIZE
				)) 
			    (ysize = get(rec 
				    'YSIZE
				))
			    (block_data = list(lx ly xsize ysize))
			)
			when(((record == "32") && (id == "-1")) 
			    (dx = get(rec 
				    'LOCATION\.X
				)) 
			    (dy = get(rec 
				    'LOCATION\.Y
				)) 
			    (Designator = get(rec 
				    'TEXT
				)) 
			    (refdes_data = list(lx ly Designator))
			) 
			when(((record == "33") && (id == "-1")) 
			    (fx = get(rec 
				    'LOCATION\.X
				)) 
			    (fy = get(rec 
				    'LOCATION\.Y
				)) 
			    (File_Name = get(rec 
				    'TEXT
				)) 
			    (file_data = list(lx ly File_Name))
			) 
			when(((record == "16") && (id == "-1")) 
			    (port_list = cons(rec port_list))
			)
		    ) 
		    (block_name = parseString(File_Name ".")) 
		    if((length(block_name) == 2) then 
			(block_name = car(block_name)) else 
			(block_name = car(block_name))
			printf("-Block_File_Name-> %L\n" File_Name)
		    )
		    (block_name = TRL_ALTIUM2HDL_PCB_Util_Namemaper(block_name)) 
		    unless(member(block_name block_name_list) 
			(harnessPorts = TRL_ALTIUM2HDL_SCH_Create_BlockSymbol(block_name block_data refdes_data file_data port_list
				harnessPorts
			    )) 
			(block_name_list = cons(block_name block_name_list))
		    ) 
		    fprintf(port "FORCEADD %s..1\n" block_name) 
		    fprintf(port "(%d %d);\n" 
			(atoi(car(block_data)) * 5) 
			(atoi(cadr(block_data)) * 5)
		    ) 
		    when((Designator && dx && dy) 
			(dx = (atoi(dx) * 5)) 
			(dy = ((atoi(dy) * 5) + 5)) 
			fprintf(port "FORCEPROP 2 LAST BLOCK_REF %s\n" Designator) 
			fprintf(port "R 0\n")
			fprintf(port "J 0\n") 
			fprintf(port "(%d %d);\n" dx dy) 
			fprintf(port "DISPLAY %f (%d %d);\n" 0.68 dx dy) 
			fprintf(port "PAINT BLUE (%d %d);\n" dx dy)
		    )
		    when((File_Name && fx && fy) 
			(fx = (atoi(fx) * 5)) 
			(fy = ((atoi(fy) * 5) + 5)) 
			fprintf(port "FORCEPROP 2 LAST BLOCK_NAME %s\n" block_name) 
			fprintf(port "R 0\n")
			fprintf(port "J 0\n") 
			fprintf(port "(%d %d);\n" fx fy) 
			fprintf(port "DISPLAY %f (%d %d);\n" 0.68 fx fy) 
			fprintf(port "PAINT BLUE (%d %d);\n" fx fy)
		    ) 
		    (port_list = list())
		) else t
	    )
	) harnessPorts
    )
)
procedure(TRL_ALTIUM2HDL_SCH_Create_Concept_ADD_BusTaps(port pgnr taps) 
    let((id lx ly cx cy) 
	unless(pgnr t) 
	foreach(rec taps 
	    (id = get(rec 
		    'OWNERPARTID
		)) 
	    (lx = get(rec 
		    'LOCATION\.X
		)) 
	    (ly = get(rec 
		    'LOCATION\.Y
		))
	    (cx = get(rec 
		    'CORNER\.X
		)) 
	    (cy = get(rec 
		    'CORNER\.Y
		)) 
	    if((id == "-1") then 
		if((type(lx) == 'string) then 
		    (lx = (atoi(lx) * 5)) else 
		    (lx = nil)
		) 
		if((type(ly) == 'string) then 
		    (ly = (atoi(ly) * 5)) else 
		    (ly = nil)
		) 
		if((type(cx) == 'string) then 
		    (cx = (atoi(cx) * 5)) else 
		    (cx = nil)
		)
		if((type(cy) == 'string) then 
		    (cy = (atoi(cy) * 5)) else 
		    (cy = nil)
		) 
		if((lx && ly && cx && cy) then 
		    if((lx < cx) then 
			(lx = (lx + 1)) 
			(cx = (cx - 1)) else
			(lx = (lx - 1)) 
			(cx = (cx + 1))
		    ) 
		    if((ly < cy) then 
			(ly = (ly + 1)) 
			(cy = (cy - 1)) else
			(ly = (ly - 1)) 
			(cy = (cy + 1))
		    ) 
		    fprintf(port "WIRE 82 -1 (%d %d)(%d %d);\n" lx ly cx
			cy
		    )
		    else 
		    (trl_altium2hdl_global->exeption = cons(sprintf(nil "-->3.8.13 ERROR   - HDL ADD_BusTaps: %L!" taps) 
			    (trl_altium2hdl_global->exeption)
			))
		) else 
		printf("-..ADD_BusTaps->%L\n" rec)
	    )
	)
    )
)
procedure(TRL_ALTIUM2HDL_SCH_Create_Concept_ADD_Buses(port sch_name pgnr) 
    let((id lwidth l_cnt x_val y_val
	    l_points start_x start_y x y
	    sig_name bus_recs net_recs windex poly_sig_name
	    support_recs tap_recs
	) 
	(windex = 1) 
	foreach(data 
	    (trl_altium2hdl_global->Nets) 
	    when((car(data) == sch_name) 
		(support_recs = caddr(data)) 
		(bus_recs = caddr(support_recs)) 
		(net_recs = cadr(support_recs)) 
		(tap_recs = cadddr(support_recs))
	    )
	) 
	when(tap_recs 
	    TRL_ALTIUM2HDL_SCH_Create_Concept_ADD_BusTaps(port pgnr tap_recs)
	) 
	(trl_altium2hdl_global->exeption = cons(sprintf(nil "   5.6.01 INFO    - Buses: [%4d] - Nets: [%4d] Start Placing Buses of Page: %L" 
		    length(bus_recs) 
		    length(net_recs) pgnr
		) 
		(trl_altium2hdl_global->exeption)
	    ))
	if(bus_recs then 
	    foreach(rec bus_recs 
		(sig_name = nil) 
		(id = get(rec 
			'OWNERPARTID
		    )) 
		(lwidth = get(rec 
			'LINEWIDTH
		    ))
		(l_cnt = get(rec 
			'LOCATIONCOUNT
		    )) 
		if((id == "-1") then 
		    case(lwidth 
			("1" 
			    (lwidth = 82)
			) 
			("2" 
			    (lwidth = 83)
			) 
			("3" 
			    (lwidth = 83)
			) 
			(t 
			    (lwidth = 82)
			)
		    ) 
		    (lwidth = 83) 
		    if(l_cnt then 
			(l_cnt = atoi(l_cnt)) 
			(l_points = list()) 
			for(index 1 l_cnt 
			    (x_val = stringToSymbol(sprintf(nil "X%d" index))) 
			    (y_val = stringToSymbol(sprintf(nil "Y%d" index)))
			    (x_val = get(rec x_val)) 
			    (y_val = get(rec y_val)) 
			    if(x_val then 
				(x = (atoi(x_val) * 5)) else 
				(x = 0)
			    ) 
			    if(y_val then 
				(y = (atoi(y_val) * 5)) else 
				(y = 0)
			    ) 
			    (l_points = cons((x:y) l_points))
			    index++
			)
			if(l_points then 
			    (start_x = caar(l_points)) 
			    (start_y = cadar(l_points)) 
			    if((length(l_points) > 2) then 
				foreach(l_coor 
				    cdr(l_points) 
				    (x = car(l_coor)) 
				    (y = cadr(l_coor)) 
				    fprintf(port "WIRE %d -1 (%d %d)(%d %d);\n" lwidth start_x start_y
					x y
				    )
				    (trl_altium2hdl_global->BusFromTo = cons(list((start_x:start_y) 
						(x:y)
					    ) 
					    (trl_altium2hdl_global->BusFromTo)
					)) 
				    when(net_recs 
					(sig_name = TRL_ALTIUM2HDL_SCH_Create_Concept_Find_NetName(net_recs start_x start_y x y))
				    ) 
				    when(sig_name 
					TRL_ALTIUM2HDL_SCH_Create_Concept_ADD_NetName(port sig_name) 
					(poly_sig_name = car(sig_name)) 
					(sig_name = nil)
				    ) 
				    (start_x = x) 
				    (start_y = y)
				) 
				when((axlFormGetField 
					(trl_altium2hdl_global->formid) "verbose"
				    ) 
				    (trl_altium2hdl_global->exeption = cons(sprintf(nil "   5.6.05 INFO    - Bus [%4d] Net_Label: %L L-Width: %L => %L L-Cnt: %L -> %L" windex poly_sig_name 
						get(rec 
						    'LINEWIDTH
						)
						lwidth l_cnt l_points
					    ) 
					    (trl_altium2hdl_global->exeption)
					))
				) else
				fprintf(port "WIRE %d -1 (%d %d)(%d %d);\n" lwidth start_x start_y
				    car(cadr(l_points)) 
				    cadr(cadr(l_points))
				) 
				(trl_altium2hdl_global->BusFromTo = cons(list((start_x:start_y) 
					    (car(cadr(l_points)):cadr(cadr(l_points)))
					) 
					(trl_altium2hdl_global->BusFromTo)
				    )) 
				when(net_recs 
				    (sig_name = TRL_ALTIUM2HDL_SCH_Create_Concept_Find_NetName(net_recs start_x start_y 
					    car(cadr(l_points)) 
					    cadr(cadr(l_points))
					))
				) 
				if(sig_name then 
				    TRL_ALTIUM2HDL_SCH_Create_Concept_ADD_NetName(port sig_name) 
				    when((axlFormGetField 
					    (trl_altium2hdl_global->formid) "verbose"
					) 
					(trl_altium2hdl_global->exeption = cons(sprintf(nil "   5.6.05 INFO    - Bus [%4d] Net_Label: %L L-Width: %L => %L L-Cnt: %L -> %L" windex 
						    car(sig_name) 
						    get(rec 
							'LINEWIDTH
						    )
						    lwidth l_cnt l_points
						) 
						(trl_altium2hdl_global->exeption)
					    ))
				    ) 
				    (sig_name = nil)
				    else 
				    when((axlFormGetField 
					    (trl_altium2hdl_global->formid) "verbose"
					) 
					(trl_altium2hdl_global->exeption = cons(sprintf(nil "   5.6.05 INFO    - Bus [%4d] Net_Label: %L L-Width: %L => %L L-Cnt: %L -> %L" windex sig_name 
						    get(rec 
							'LINEWIDTH
						    )
						    lwidth l_cnt l_points
						) 
						(trl_altium2hdl_global->exeption)
					    ))
				    )
				)
			    )
			    else 
			    (trl_altium2hdl_global->exeption = cons(sprintf(nil "-->5.6.07 ERROR   - Bus [%4d] No Polygon Data Created: %L on Page: %L" windex rec pgnr) 
				    (trl_altium2hdl_global->exeption)
				))
			) else 
			(trl_altium2hdl_global->exeption = cons(sprintf(nil "   5.6.08 WARNING - Bus [%4d] No Polygon Indication: %L on Page: %L" windex rec pgnr) 
				(trl_altium2hdl_global->exeption)
			    ))
		    )
		    else 
		    (trl_altium2hdl_global->exeption = cons(sprintf(nil "   5.6.09 WARNING - Bus [%4d] OWNERPARTID: %L on Page: %L" windex id pgnr) 
			    (trl_altium2hdl_global->exeption)
			))
		) 
		windex++
	    ) else 
	    when((axlFormGetField 
		    (trl_altium2hdl_global->formid) "verbose"
		) 
		(trl_altium2hdl_global->exeption = cons(sprintf(nil "   5.6.10 INFO    - NO Bus Records on Page: %L" pgnr) 
			(trl_altium2hdl_global->exeption)
		    ))
	    )
	)
    )
)
procedure(TRL_ALTIUM2HDL_SCH_Create_Concept_ADD_Dots(port sch_name pgnr) 
    let((dot_recs id lx ly) 
	unless(pgnr t) 
	foreach(data 
	    (trl_altium2hdl_global->Nets) 
	    when((car(data) == sch_name) 
		(dot_recs = caddr(data)) 
		(dot_recs = nth(4 dot_recs))
	    )
	) 
	when(dot_recs 
	    foreach(rec dot_recs 
		(id = get(rec 
			'OWNERPARTID
		    )) 
		(lx = get(rec 
			'LOCATION\.X
		    )) 
		(ly = get(rec 
			'LOCATION\.Y
		    ))
		if((id == "-1") then 
		    (lx = (atoi(lx) * 5)) 
		    (ly = (atoi(ly) * 5)) 
		    fprintf(port "DOT 1 (%d %d);\n" lx ly)
		    else 
		    printf("..Concept_ADD_Dots %L\n" rec)
		)
	    )
	)
    )
)
procedure(TRL_ALTIUM2HDL_SCH_Create_Concept_ADD_Harness(port sch_name pgnr BlockHarnessPorts schematicPorts) 
    let((block_recs record block_list blocks_lst id
	    lx ly xsize Designator block_data
	    refdes_data file_data port_list block_name block_name_list
	    tloc_lx tloc_ly txt_hori txt_vert harness
	    harness_body harness_line side block_index org_block_name
	    adapterPorts
	) 
	unless(pgnr 
	    printf("..ADD_Harness->pgnr\n")
	) 
	when((trl_altium2hdl_global->Harness) 
	    foreach(schematic 
		(trl_altium2hdl_global->Harness) 
		when((car(schematic) == sch_name) 
		    (harness = caddr(schematic)) 
		    (harness_body = car(harness)) 
		    (harness_line = cadddr(harness))
		)
	    ) 
	    (block_list = list()) 
	    (blocks_lst = list()) 
	    (block_name_list = list())
	    when(harness_body 
		(block_recs = harness_body) 
		foreach(rec block_recs 
		    (record = get(rec 
			    'RECORD
			)) 
		    if(((record == "215") && block_list) then 
			(blocks_lst = cons(block_list blocks_lst)) 
			(block_list = list()) 
			(block_list = cons(rec block_list))
			else 
			(block_list = cons(rec block_list))
		    )
		) 
		(blocks_lst = cons(block_list blocks_lst)) 
		foreach(block blocks_lst 
		    (block_index = 1) 
		    (side = "0") 
		    foreach(rec block 
			(record = get(rec 
				'RECORD
			    )) 
			(id = get(rec 
				'OWNERPARTID
			    )) 
			when(((record == "215") && (id == "-1")) 
			    (lx = get(rec 
				    'LOCATION\.X
				)) 
			    (ly = get(rec 
				    'LOCATION\.Y
				)) 
			    (xsize = get(rec 
				    'XSIZE
				)) 
			    (side = get(rec 
				    'HARNESSCONNECTORSIDE
				))
			    (block_data = rec)
			)
			when(((record == "217") && (id == "-1")) 
			    (tloc_lx = get(rec 
				    'LOCATION\.X
				)) 
			    (tloc_ly = get(rec 
				    'LOCATION\.Y
				)) 
			    (txt_hori = get(rec 
				    'TEXTHORZANCHOR
				)) 
			    (txt_vert = get(rec 
				    'TEXTVERTANCHOR
				))
			    (Designator = get(rec 
				    'TEXT
				)) 
			    (refdes_data = list(tloc_lx tloc_ly Designator))
			) 
			when(((record == "216") && (id == "-1")) 
			    (port_list = cons(rec port_list))
			)
		    )
		    (org_block_name = Designator) 
		    (block_name = TRL_ALTIUM2HDL_PCB_Util_Namemaper(Designator)) 
		    (Designator = block_name) 
		    unless(member(block_name block_name_list) 
			while(member(block_name 
				(trl_altium2hdl_global->Harness_Hier)
			    ) 
			    (block_name = sprintf(nil "%s_%d" Designator block_index)) 
			    block_index++
			) 
			(adapterPorts = TRL_ALTIUM2HDL_SCH_Create_HarnessSymbol(block_name block_data refdes_data file_data port_list
				org_block_name adapterPorts
			    )) 
			(block_name_list = cons(block_name block_name_list)) 
			(trl_altium2hdl_global->Harness_Hier = cons(block_name 
				(trl_altium2hdl_global->Harness_Hier)
			    ))
		    ) 
		    fprintf(port "FORCEADD %s..1\n" block_name)
		    unless(side 
			fprintf(port "(%d %d);\n" 
			    (atoi(lx) * 5) 
			    (atoi(ly) * 5)
			) 
			fprintf(port "PAINT SKYBLUE (%d %d);\n" 
			    (atoi(lx) * 5) 
			    (atoi(ly) * 5)
			)
		    ) 
		    when((side == "0") 
			fprintf(port "(%d %d);\n" 
			    (atoi(lx) * 5) 
			    (atoi(ly) * 5)
			) 
			fprintf(port "PAINT SKYBLUE (%d %d);\n" 
			    (atoi(lx) * 5) 
			    (atoi(ly) * 5)
			)
		    ) 
		    when((side == "1") 
			fprintf(port "R 2\n") 
			fprintf(port "(%d %d);\n" 
			    ((atoi(lx) * 5) + (atoi(xsize) * 5)) 
			    (atoi(ly) * 5)
			) 
			fprintf(port "PAINT SKYBLUE (%d %d);\n" 
			    ((atoi(lx) * 5) + (atoi(xsize) * 5)) 
			    (atoi(ly) * 5)
			)
		    ) 
		    (tloc_lx = (atoi(tloc_lx) * 5)) 
		    (tloc_ly = (atoi(tloc_ly) * 5))
		    (txt_hori = txt_hori) 
		    (txt_vert = txt_vert) 
		    fprintf(port "FORCEPROP 2 LAST HARNESS_REF %s\n" Designator) 
		    fprintf(port "R 0\n") 
		    fprintf(port "J 0\n")
		    fprintf(port "(%d %d);\n" tloc_lx tloc_ly) 
		    fprintf(port "DISPLAY %f (%d %d);\n" 0.72 tloc_lx tloc_ly) 
		    fprintf(port "PAINT SKYBLUE (%d %d);\n" tloc_lx tloc_ly) 
		    (port_list = list())
		)
	    ) 
	    when(harness_line 
		TRL_ALTIUM2HDL_SCH_Create_Concept_HarnessBus(port sch_name harness_line pgnr BlockHarnessPorts
		    schematicPorts adapterPorts
		) 
		when(adapterPorts 
		    foreach(aPort adapterPorts 
			(trl_altium2hdl_global->exeption = cons(sprintf(nil "   3.8.34 INFO    - HARNESS Adapter Port: %L" aPort) 
				(trl_altium2hdl_global->exeption)
			    ))
		    )
		)
	    )
	)
    )
)
procedure(TRL_ALTIUM2HDL_SCH_Create_Concept_ADD_HarnessNetName(port sig_name disp_x disp_y) 
    let((txt_x txt_y harness_signal signals) 
	(signals = car(sig_name)) 
	(harness_signal = car(signals)) 
	foreach(sig 
	    cdr(signals) 
	    (harness_signal = sprintf(nil "%s:%s" harness_signal sig))
	) 
	(txt_x = (cadr(sig_name) * 5))
	(txt_y = (caddr(sig_name) * 5)) 
	(txt_x = txt_x) 
	(txt_y = txt_y) 
	fprintf(port "FORCEPROP 2 LAST SIG_NAME %s\n" harness_signal) 
	when(nth(4 sig_name) 
	    fprintf(port "%s\n" 
		nth(4 sig_name)
	    )
	)
	when(nth(6 sig_name) 
	    fprintf(port "%s\n" 
		nth(6 sig_name)
	    )
	) 
	fprintf(port "(%d %d);\n" disp_x disp_y) 
	fprintf(port "DISPLAY %f (%d %d);\n" 
	    cadddr(sig_name) disp_x disp_y
	) 
	fprintf(port "PAINT SKYBLUE (%d %d);\n" disp_x disp_y) 
	unless(nth(5 sig_name) 
	    fprintf(port "DISPLAY INVISIBLE (%d %d);\n" disp_x disp_y)
	)
    )
)
procedure(TRL_ALTIUM2HDL_SCH_Create_Concept_ADD_Line(port sym_rec) 
    let((id txt txt_x txt_y sig_name
	    lx ly cx cy lwidth
	    txt_rec
	) 
	foreach(rec sym_rec 
	    (id = get(rec 
		    'OWNERPARTID
		)) 
	    (txt = get(rec 
		    'TEXT
		)) 
	    (txt_rec = get(rec 
		    'RECORD
		))
	    when((txt && (txt_rec == "25")) 
		(txt_x = get(rec 
			'LOCATION\.X
		    )) 
		(txt_y = get(rec 
			'LOCATION\.Y
		    )) 
		when((txt_x && txt_y) 
		    (txt_x = (atoi(txt_x) * 5)) 
		    (txt_y = (atoi(txt_y) * 5))
		) 
		(sig_name = txt)
	    ) 
	    (lx = get(rec 
		    'LOCATION\.X
		)) 
	    (ly = get(rec 
		    'LOCATION\.Y
		)) 
	    (cx = get(rec 
		    'CORNER\.X
		)) 
	    (cy = get(rec 
		    'CORNER\.Y
		))
	    (lwidth = get(rec 
		    'LINEWIDTH
		)) 
	    case(lwidth 
		("1" 
		    (lwidth = 82)
		) 
		("2" 
		    (lwidth = 83)
		) 
		(t 
		    (lwidth = 82)
		)
	    ) 
	    when((cx && cy) 
		(lx = (atoi(lx) * 5)) 
		(ly = (atoi(ly) * 5)) 
		(cx = (atoi(cx) * 5)) 
		(cy = (atoi(cy) * 5))
		when((id == "-1") 
		    fprintf(port "WIRE 16 -1 (%d %d)(%d %d);\n" lx ly cx
			cy
		    ) 
		    if(sig_name then 
			if((txt_x && txt_y) then 
			    fprintf(port "FORCEPROP 2 LAST SIG_NAME %s\n" sig_name) 
			    fprintf(port "(%d %d);\n" txt_x txt_y) 
			    (sig_name = nil)
			    (trl_altium2hdl_global->exeption = cons(sprintf(nil "   5.3.06 INFO    - Drawing Line: %L L-Width: %L => %L | %L %L %L %L" sig_name 
					get(rec 
					    'LINEWIDTH
					) lwidth
					lx ly cx cy
				    ) 
				    (trl_altium2hdl_global->exeption)
				)) 
			    (sig_name = nil) else 
			    (trl_altium2hdl_global->exeption = cons(sprintf(nil "-->5.3.05 ERROR   - Drawing Wire: %L X: %L Y: %L L-Width: %L => %L %L %L %L %L" sig_name txt_x txt_y
					get(rec 
					    'LINEWIDTH
					) lwidth lx ly cx
					cy
				    ) 
				    (trl_altium2hdl_global->exeption)
				))
			) else 
			(trl_altium2hdl_global->exeption = cons(sprintf(nil "   5.3.06 INFO    - Drawing Line: %L L-Width: %L => %L | %L %L %L %L" sig_name 
				    get(rec 
					'LINEWIDTH
				    ) lwidth
				    lx ly cx cy
				) 
				(trl_altium2hdl_global->exeption)
			    ))
		    )
		)
	    )
	)
    )
)
procedure(TRL_ALTIUM2HDL_SCH_Create_Concept_ADD_LineLocCount(port pgnr) 
    let((lin_recs id lwidth l_cnt l_points
	    x_val y_val x y start_x
	    start_y
	) 
	(lin_recs = caddr((trl_altium2hdl_global->Graphic))) 
	when(lin_recs 
	    (trl_altium2hdl_global->exeption = cons("-------------------------------------------------------------------------------" 
		    (trl_altium2hdl_global->exeption)
		)) 
	    (trl_altium2hdl_global->exeption = cons(sprintf(nil "   5.5.08 INFO    - Start Placing %d Lines of Page: %L" 
			length(lin_recs) pgnr
		    ) 
		    (trl_altium2hdl_global->exeption)
		)) 
	    foreach(rec lin_recs 
		(id = get(rec 
			'OWNERPARTID
		    )) 
		(lwidth = get(rec 
			'LINEWIDTH
		    )) 
		(l_cnt = get(rec 
			'LOCATIONCOUNT
		    ))
		if((id == "-1") then 
		    case(lwidth 
			("1" 
			    (lwidth = 82)
			) 
			("2" 
			    (lwidth = 83)
			) 
			("3" 
			    (lwidth = 83)
			) 
			(t 
			    (lwidth = 82)
			)
		    ) 
		    if(l_cnt then 
			(l_cnt = atoi(l_cnt)) 
			(l_points = list()) 
			for(index 1 l_cnt 
			    (x_val = stringToSymbol(sprintf(nil "X%d" index))) 
			    (y_val = stringToSymbol(sprintf(nil "Y%d" index)))
			    (x_val = get(rec x_val)) 
			    (y_val = get(rec y_val)) 
			    if(x_val then 
				(x = (atoi(x_val) * 5)) else 
				(x = 0)
			    ) 
			    if(y_val then 
				(y = (atoi(y_val) * 5)) else 
				(y = 0)
			    ) 
			    (l_points = cons((x:y) l_points))
			    index++
			)
			if(l_points then 
			    (start_x = caar(l_points)) 
			    (start_y = cadar(l_points)) 
			    if((length(l_points) > 2) then 
				foreach(l_coor 
				    cdr(l_points) 
				    (x = car(l_coor)) 
				    (y = cadr(l_coor)) 
				    fprintf(port "WIRE %d -1 (%d %d)(%d %d);\n" lwidth start_x start_y
					x y
				    )
				    (start_x = x) 
				    (start_y = y)
				) else 
				fprintf(port "WIRE %d -1 (%d %d)(%d %d);\n" lwidth start_x start_y
				    car(cadr(l_points)) 
				    cadr(cadr(l_points))
				)
			    )
			    else 
			    (trl_altium2hdl_global->exeption = cons(sprintf(nil "-->5.5.07 ERROR   - Line No Polygon Data Created: %L on Page: %L" rec pgnr) 
				    (trl_altium2hdl_global->exeption)
				))
			) else 
			(trl_altium2hdl_global->exeption = cons(sprintf(nil "   5.5.08 WARNING - Line No Polygon Indication: %L on Page: %L" rec pgnr) 
				(trl_altium2hdl_global->exeption)
			    ))
		    ) else
		    (trl_altium2hdl_global->exeption = cons(sprintf(nil "   5.5.08 WARNING - Line OWNERPARTID: %L on Page: %L" id pgnr) 
			    (trl_altium2hdl_global->exeption)
			))
		)
	    )
	)
    )
)
procedure(TRL_ALTIUM2HDL_SCH_Create_Concept_ADD_LinesLocCNT(port sch_name pgnr) 
    let((line_recs lwidth l_cnt l_points x_val
	    y_val x y start_x start_y
	) 
	(pgnr = pgnr) 
	foreach(data 
	    (trl_altium2hdl_global->Graphic) 
	    when((car(data) == sch_name) 
		(data = caddr(data)) 
		(line_recs = caddr(data))
	    )
	) 
	when(line_recs 
	    foreach(rec line_recs 
		(lwidth = get(rec 
			'LINEWIDTH
		    )) 
		(l_cnt = get(rec 
			'LOCATIONCOUNT
		    )) 
		case(lwidth 
		    ("1" 
			(lwidth = 64)
		    ) 
		    ("2" 
			(lwidth = 65)
		    ) 
		    ("3" 
			(lwidth = 64)
		    ) 
		    (t 
			(lwidth = 64)
		    )
		)
		when(l_cnt 
		    (l_cnt = atoi(l_cnt)) 
		    (l_points = list()) 
		    for(index 1 l_cnt 
			(x_val = stringToSymbol(sprintf(nil "X%d" index))) 
			(y_val = stringToSymbol(sprintf(nil "Y%d" index)))
			(x_val = get(rec x_val)) 
			(y_val = get(rec y_val)) 
			if(x_val then 
			    (x = (atoi(x_val) * 5)) else 
			    (x = 0)
			) 
			if(y_val then 
			    (y = (atoi(y_val) * 5)) else 
			    (y = 0)
			) 
			(l_points = cons((x:y) l_points))
			index++
		    ) 
		    when(l_points 
			(x = caar(l_points)) 
			(y = cadar(l_points)) 
			foreach(l_coor 
			    cdr(l_points) 
			    (start_x = x) 
			    (start_y = y) 
			    (x = car(l_coor))
			    (y = cadr(l_coor)) 
			    fprintf(port "WIRE %d -1 (%d %d)(%d %d);\n" lwidth start_x start_y
				x y
			    )
			)
		    )
		)
	    )
	)
    )
)
procedure(TRL_ALTIUM2HDL_SCH_Create_Concept_ADD_Lines_OLD(port sch_name pgnr) 
    let((line_recs busFromTo id lx ly
	    cx cy onbus
	) 
	unless(pgnr t) 
	foreach(data 
	    (trl_altium2hdl_global->Graphic) 
	    when((car(data) == sch_name) 
		(line_recs = cadr(data)) 
		(line_recs = car(line_recs))
	    )
	) 
	(busFromTo = (trl_altium2hdl_global->BusFromTo)) 
	when(line_recs 
	    foreach(rec line_recs 
		(id = get(rec 
			'OWNERPARTID
		    )) 
		(lx = get(rec 
			'LOCATION\.X
		    )) 
		(ly = get(rec 
			'LOCATION\.Y
		    ))
		(cx = get(rec 
			'CORNER\.X
		    )) 
		(cy = get(rec 
			'CORNER\.Y
		    )) 
		if((id == "-1") then 
		    (lx = (atoi(lx) * 5)) 
		    (ly = (atoi(ly) * 5)) 
		    (cx = (atoi(cx) * 5))
		    (cy = (atoi(cy) * 5)) 
		    when(busFromTo 
			foreach(fromto busFromTo 
			    (onbus = (axlIsPointOnLine 
				    (lx:ly) fromto
				)) 
			    when(onbus 
				if(((lx != cx) && (ly != cy)) then 
				    if((lx < cx) then 
					(lx = (lx + 1)) else 
					(lx = (lx - 1))
				    ) 
				    if((ly < cy) then 
					(ly = (ly + 1)) else 
					(ly = (ly - 1))
				    ) else
				    if((lx == cx) then 
					if((ly < cy) then 
					    (ly = (ly + 1)) else 
					    (ly = (ly - 1))
					) else 
					if((lx < cx) then 
					    (lx = (lx + 1)) else 
					    (lx = (lx - 1))
					)
				    )
				)
			    ) 
			    (onbus = (axlIsPointOnLine 
				    (cx:cy) fromto
				))
			    when(onbus 
				if(((lx != cx) && (ly != cy)) then 
				    if((lx < cx) then 
					(cx = (cx - 1)) else 
					(cx = (cx + 1))
				    ) 
				    if((ly < cy) then 
					(cy = (cy - 1)) else 
					(cy = (cy + 1))
				    ) else
				    if((lx == cx) then 
					if((ly < cy) then 
					    (cy = (cy - 1)) else 
					    (cy = (cy + 1))
					) else 
					if((lx < cx) then 
					    (cx = (lx - 1)) else 
					    (cx = (lx + 1))
					)
				    )
				)
			    )
			)
		    ) 
		    fprintf(port "WIRE 82 -1 (%d %d)(%d %d);\n" lx ly cx
			cy
		    ) else 
		    printf("-..ADD_Lines->%L\n" rec)
		)
	    )
	)
    )
)
procedure(TRL_ALTIUM2HDL_SCH_Create_Concept_ADD_NetName(port sig_name) 
    let((txt_x txt_y) 
	(txt_x = cadr(sig_name)) 
	(txt_y = caddr(sig_name)) 
	fprintf(port "FORCEPROP 2 LAST SIG_NAME %s\n" 
	    car(sig_name)
	) 
	when(nth(4 sig_name) 
	    fprintf(port "%s\n" 
		nth(4 sig_name)
	    )
	)
	when(nth(6 sig_name) 
	    fprintf(port "%s\n" 
		nth(6 sig_name)
	    )
	) 
	fprintf(port "(%d %d);\n" txt_x txt_y) 
	fprintf(port "DISPLAY %f (%d %d);\n" 
	    cadddr(sig_name) txt_x txt_y
	) 
	fprintf(port "PAINT VIOLET (%d %d);\n" txt_x txt_y)
    )
)
procedure(TRL_ALTIUM2HDL_SCH_Create_Concept_ADD_Note(port sch_name pgnr cust_vars) 
    let((prop_val prop_name owner_id font_id rot
	    lx ly style font c_var
	    record prop_size txt_recs
	) 
	unless(pgnr t) 
	foreach(data 
	    (trl_altium2hdl_global->Graphic) 
	    when((car(data) == sch_name) 
		(txt_recs = caddr(data)) 
		(txt_recs = cadr(txt_recs))
	    )
	) 
	when(txt_recs 
	    foreach(rec txt_recs 
		(prop_val = get(rec 
			'TEXT
		    )) 
		(prop_name = get(rec 
			'NAME
		    )) 
		(style = get(rec 
			'STYLE
		    ))
		(owner_id = get(rec 
			'OWNERPARTID
		    )) 
		(record = get(rec 
			'RECORD
		    )) 
		unless((record == "25") 
		    when((prop_val && (owner_id == "-1")) 
			unless((prop_name || style) 
			    (c_var = get(cust_vars 
				    stringToSymbol(prop_val)
				)) 
			    unless(c_var 
				(font_id = get(rec 
					'FONTID
				    )) 
				(rot = get(rec 
					'ORIENTATION
				    )) 
				(lx = get(rec 
					'LOCATION\.X
				    )) 
				(ly = get(rec 
					'LOCATION\.Y
				    ))
				when(font_id 
				    (font = TRL_ALTIUM2HDL_SCH_Util_Font_ID(font_id)) 
				    (prop_size = (car(font) / 47.0))
				) 
				unless(prop_size 
				    (prop_size = 0.82)
				) 
				when((lx && ly) 
				    (lx = (atoi(lx) * 5)) 
				    (ly = (atoi(ly) * 5))
				) 
				unless(rot 
				    (rot = "0")
				) 
				if((lx && ly && prop_val) then 
				    fprintf(port "FORCENOTE\n") 
				    fprintf(port "%s\n" prop_val) 
				    fprintf(port "(%d %d) %s;\n" lx ly rot)
				    fprintf(port "DISPLAY LEFT (%d %d);\n" lx ly) 
				    fprintf(port "DISPLAY %f (%d %d);\n" prop_size lx ly) 
				    fprintf(port "PAINT BLUE (%d %d);\n" lx ly) else 
				    printf("-->Schematic Note: %L\n" rec)
				)
			    )
			)
		    )
		)
	    )
	)
    )
)
procedure(TRL_ALTIUM2HDL_SCH_Create_Concept_ADD_Part(port sym sym_i) 
    let((ref_des_prefix lib_ref_org lib_ref loc_x loc_y
	    mirr sym_name rot current lib_rec
	    itemId ret att_ref
	) 
	(loc_x = nil) 
	(loc_y = nil) 
	(ret = list()) 
	(att_ref = list())
	when(sym 
	    foreach(lib_recs 
		cdr(sym) 
		when(((get(lib_recs 
				'RECORD
			    ) == "34") && (get(lib_recs 
				'NAME
			    ) == "Designator")) 
		    (ref_des_prefix = get(lib_recs 
			    'TEXT
			)) 
		    if(ref_des_prefix then 
			(ref_des_prefix = parseString(ref_des_prefix "")) 
			(ref_des_prefix = upperCase(car(ref_des_prefix))) else
			(ref_des_prefix = "NN")
		    )
		)
	    ) 
	    (lib_rec = car(sym)) 
	    (lib_ref_org = get(lib_rec 
		    'LIBREFERENCE
		)) 
	    (loc_x = get(lib_rec 
		    'LOCATION\.X
		))
	    (loc_y = get(lib_rec 
		    'LOCATION\.Y
		)) 
	    (rot = get(lib_rec 
		    'ORIENTATION
		)) 
	    (mirr = get(lib_rec 
		    'ISMIRRORED
		)) 
	    (current = get(lib_rec 
		    'CURRENTPARTID
		)) 
	    (itemId = get(lib_rec 
		    'DESIGNITEMID
		))
	    unless(lib_ref_org 
		(lib_ref_org = itemId)
	    ) 
	    if((loc_x && loc_x) then 
		unless(current 
		    (current = "1")
		) 
		(loc_x = (atoi(loc_x) * 5)) 
		(loc_y = (atoi(loc_y) * 5))
		(lib_ref = "XXXXXXXXXXXXXXXXXXXXXXXXXXXX") 
		if(car((trl_altium2hdl_global->Reference)) then 
		    foreach(ref_part 
			cadr((trl_altium2hdl_global->Reference)) 
			when((car(ref_part) == lib_ref_org) 
			    (lib_ref = cadr(ref_part)) 
			    (att_ref = caddr(ref_part))
			)
		    ) else 
		    (lib_ref = TRL_ALTIUM2HDL_PCB_Util_Namemaper(lib_ref_org))
		) 
		(trl_altium2hdl_global->exeption = cons(sprintf(nil "   5.3.01 INFO    - [%4d] Placing Part: %L [%L] %L %L %L %L!" sym_i lib_ref lib_ref_org
			    loc_x loc_y rot mirr
			) 
			(trl_altium2hdl_global->exeption)
		    )) 
		(sym_name = sprintf(nil "%s..%s" lib_ref current)) 
		fprintf(port "FORCEADD %s\n" sym_name)
		if((mirr && (mirr == "T")) then 
		    if(rot then 
			case(rot 
			    ("1" 
				fprintf(port "R 7\n")
			    ) 
			    ("2" 
				fprintf(port "R 6\n")
			    ) 
			    ("3" 
				fprintf(port "R 3\n")
			    ) 
			    (t 
				printf("---UNKNOWN ROT/MIRR CODE %L %L %L %L %L\n" loc_x loc_y sym_name rot
				    mirr
				) 
				(trl_altium2hdl_global->exeption = cons(sprintf(nil "-->5.3.01 ERROR   - Placing Part: %L [%L] %L %L %L %L!" lib_ref lib_ref_org loc_x
					    loc_y rot mirr
					) 
					(trl_altium2hdl_global->exeption)
				    ))
			    )
			) else 
			fprintf(port "R 2\n")
		    ) else 
		    when(rot 
			case(rot 
			    ("1" 
				fprintf(port "R 1\n")
			    ) 
			    ("2" 
				fprintf(port "R 4\n")
			    ) 
			    ("3" 
				fprintf(port "R 5\n")
			    ) 
			    (t 
				printf("---UNKNOWN ROT CODE %L %L %L %L\n" loc_x loc_y sym_name rot) 
				(trl_altium2hdl_global->exeption = cons(sprintf(nil "-->5.3.01 ERROR   - Placing Part: %L [%L] %L %L %L %L!" lib_ref lib_ref_org loc_x
					    loc_y rot mirr
					) 
					(trl_altium2hdl_global->exeption)
				    ))
			    )
			)
		    )
		) 
		fprintf(port "(%d %d);\n" loc_x loc_y) 
		if(((ref_des_prefix == "R") || (ref_des_prefix == "C") || (ref_des_prefix == "L") || (ref_des_prefix == "T") || (ref_des_prefix == "Q") || (ref_des_prefix == "F") || (ref_des_prefix == "S") || (ref_des_prefix == "X")) then 
		    fprintf(port "PAINT BLUE (%d %d);\n" loc_x loc_y) else 
		    fprintf(port "PAINT BLACK (%d %d);\n" loc_x loc_y)
		) 
		(ret = list((loc_x:loc_y) lib_ref att_ref)) ret
	    )
	)
    )
)
procedure(TRL_ALTIUM2HDL_SCH_Create_Concept_ADD_PolyLine(port sym_rec) 
    let((id lwidth l_cnt x_val y_val
	    l_points start_x start_y x y
	    txt txt_x txt_y sig_name font_id
	    prop_size font txt_rec
	) 
	foreach(rec sym_rec 
	    (id = get(rec 
		    'OWNERPARTID
		)) 
	    (txt = get(rec 
		    'TEXT
		)) 
	    (txt_rec = get(rec 
		    'RECORD
		))
	    when((txt && (txt_rec == "25")) 
		(txt_x = get(rec 
			'LOCATION\.X
		    )) 
		(txt_y = get(rec 
			'LOCATION\.Y
		    )) 
		(font_id = get(rec 
			'FONTID
		    )) 
		when((txt_x && txt_y) 
		    (txt_x = (atoi(txt_x) * 5)) 
		    (txt_y = (atoi(txt_y) * 5))
		)
		(sig_name = txt)
	    ) 
	    when((id == "-1") 
		(lwidth = get(rec 
			'LINEWIDTH
		    )) 
		(l_cnt = get(rec 
			'LOCATIONCOUNT
		    )) 
		case(lwidth 
		    ("1" 
			(lwidth = 82)
		    ) 
		    ("2" 
			(lwidth = 83)
		    ) 
		    (t 
			(lwidth = 82)
		    )
		) 
		when(l_cnt 
		    (l_cnt = atoi(l_cnt)) 
		    (l_points = list()) 
		    for(index 1 l_cnt 
			(x_val = stringToSymbol(sprintf(nil "X%d" index))) 
			(y_val = stringToSymbol(sprintf(nil "Y%d" index)))
			(x_val = get(rec x_val)) 
			(y_val = get(rec y_val)) 
			if(x_val then 
			    (x = (atoi(x_val) * 5)) else 
			    (x = 0)
			) 
			if(y_val then 
			    (y = (atoi(y_val) * 5)) else 
			    (y = 0)
			) 
			(l_points = cons((x:y) l_points))
			index++
		    ) 
		    when(l_points 
			(start_x = caar(l_points)) 
			(start_y = cadar(l_points)) 
			if((length(l_points) > 2) then 
			    foreach(l_coor 
				cdr(l_points) 
				(x = car(l_coor)) 
				(y = cadr(l_coor)) 
				fprintf(port "WIRE %d -1 (%d %d)(%d %d);\n" lwidth start_x start_y
				    x y
				)
				(start_x = x) 
				(start_y = y)
			    ) else 
			    fprintf(port "WIRE %d -1 (%d %d)(%d %d);\n" lwidth start_x start_y
				car(cadr(l_points)) 
				cadr(cadr(l_points))
			    )
			) 
			if(sig_name then 
			    if((txt_x && txt_y) then 
				when(font_id 
				    (font = TRL_ALTIUM2HDL_SCH_Util_Font_ID(font_id)) 
				    (prop_size = (car(font) / 47.0))
				) 
				unless(prop_size 
				    (prop_size = 0.82)
				) 
				if(caddr(font) then t else 
				    (txt_y = (txt_y + 5))
				)
				fprintf(port "FORCEPROP 2 LAST SIG_NAME %s\n" sig_name) 
				fprintf(port "(%d %d);\n" txt_x txt_y) 
				fprintf(port "DISPLAY %f (%d %d);\n" prop_size txt_x txt_y) 
				unless(cadddr(font) 
				    fprintf(port "DISPLAY INVISIBLE (%d %d);\n" txt_x txt_y)
				) 
				(trl_altium2hdl_global->exeption = cons(sprintf(nil "   5.3.05 INFO    - Drawing Wire: %L L-Width: %L => %L L-Cnt: %L -> %L" sig_name 
					    get(rec 
						'LINEWIDTH
					    ) lwidth
					    l_cnt l_points
					) 
					(trl_altium2hdl_global->exeption)
				    ))
				(sig_name = nil) else 
				(trl_altium2hdl_global->exeption = cons(sprintf(nil "-->5.3.05 ERROR   - Drawing Wire: %L X: %L Y: %L L-Width: %L => %L L-Cnt: %L -> %L" sig_name txt_x txt_y
					    get(rec 
						'LINEWIDTH
					    ) lwidth l_cnt l_points
					) 
					(trl_altium2hdl_global->exeption)
				    ))
			    ) else 
			    (trl_altium2hdl_global->exeption = cons(sprintf(nil "   5.3.05 INFO    - Drawing Line: %L L-Width: %L => %L L-Cnt: %L -> %L" sig_name 
					get(rec 
					    'LINEWIDTH
					) lwidth
					l_cnt l_points
				    ) 
				    (trl_altium2hdl_global->exeption)
				))
			)
		    )
		)
	    )
	)
    )
)
procedure(TRL_ALTIUM2HDL_SCH_Create_Concept_ADD_Rectangle(port sch_name pgnr) 
    let((rec_recs lx ly cx cy) 
	(pgnr = pgnr) 
	foreach(data 
	    (trl_altium2hdl_global->Graphic) 
	    when((car(data) == sch_name) 
		(data = caddr(data)) 
		(rec_recs = nth(4 data))
	    )
	) 
	when(rec_recs 
	    foreach(rec rec_recs 
		(lx = get(rec 
			'LOCATION\.X
		    )) 
		(ly = get(rec 
			'LOCATION\.Y
		    )) 
		(cx = get(rec 
			'CORNER\.X
		    ))
		(cy = get(rec 
			'CORNER\.Y
		    )) 
		(lx = (atoi(lx) * 5)) 
		(ly = (atoi(ly) * 5)) 
		(cx = (atoi(cx) * 5)) 
		(cy = (atoi(cy) * 5))
		fprintf(port "WIRE 70 -1 (%d %d)(%d %d);\n" lx ly lx
		    cy
		) 
		fprintf(port "WIRE 70 -1 (%d %d)(%d %d);\n" lx cy cx
		    cy
		) 
		fprintf(port "WIRE 70 -1 (%d %d)(%d %d);\n" cx cy cx
		    ly
		) 
		fprintf(port "WIRE 70 -1 (%d %d)(%d %d);\n" cx ly lx
		    ly
		)
	    )
	)
    )
)
procedure(TRL_ALTIUM2HDL_SCH_Create_Concept_ADD_SupportSymbol_OffPage(port sch_name) 
    let((offpage style text loc_x loc_y
	    offpage_sym pin_x pin_y rot sup_recs
	    id just
	) 
	foreach(data 
	    (trl_altium2hdl_global->Nets) 
	    when((car(data) == sch_name) 
		(sup_recs = caddr(data)) 
		(sup_recs = nth(5 sup_recs))
	    )
	) 
	when(sup_recs 
	    foreach(rec sup_recs 
		(offpage = get(rec 
			'ISCROSSSHEETCONNECTOR
		    )) 
		(id = get(rec 
			'OWNERPARTID
		    )) 
		when((offpage && (offpage == "T")) 
		    if((id == "-1") then 
			(style = get(rec 
				'STYLE
			    )) 
			(text = get(rec 
				'TEXT
			    )) 
			(rot = get(rec 
				'ORIENTATION
			    ))
			(loc_x = get(rec 
				'LOCATION\.X
			    )) 
			(loc_y = get(rec 
				'LOCATION\.Y
			    )) 
			(loc_x = (atoi(loc_x) * 5)) 
			(loc_y = (atoi(loc_y) * 5)) 
			if(style then 
			    (offpage_sym = "ALTIUM_OFFPAGE_RIGHT") else 
			    (offpage_sym = "ALTIUM_OFFPAGE_LEFT")
			)
			fprintf(port "FORCEADD %s..1\n" offpage_sym) 
			if(rot then 
			    fprintf(port "R %s\n" rot) 
			    case(rot 
				("1" 
				    (pin_x = loc_x) 
				    (pin_y = (loc_y + 50))
				) 
				("2" 
				    (pin_x = (loc_x - 50)) 
				    (pin_y = loc_y)
				) 
				("3" 
				    (pin_x = loc_x) 
				    (pin_y = (loc_y - 50))
				) 
				(t 
				    printf("..Concept_ADD_SupportSymbol_Power_Port: %L\n" rot)
				)
			    ) else
			    (pin_x = (loc_x + 50)) 
			    (pin_y = loc_y)
			) 
			fprintf(port "(%d %d);\n" pin_x pin_y) 
			fprintf(port "PAINT RED (%d %d);\n" pin_x pin_y) 
			fprintf(port "FORCEPROP 0 LASTPIN (%d %d) SIG_NAME %s\n" loc_x loc_y text)
			if(rot then 
			    case(rot 
				("1" 
				    (just = "1") 
				    (loc_y = (loc_y + 68))
				) 
				("2" 
				    (just = "2") 
				    (loc_x = (loc_x - 58)) 
				    (loc_y = (loc_y - 14))
				) 
				("3" 
				    (just = "1") 
				    (loc_y = (loc_y - 108))
				) 
				(t 
				    printf("--> %L\n" rot)
				)
			    ) 
			    fprintf(port "J %s\n" just) else
			    (loc_x = (loc_x + 58)) 
			    (loc_y = (loc_y - 14))
			) 
			fprintf(port "(%d %d);\n" loc_x loc_y) 
			fprintf(port "DISPLAY 0.66 (%d %d);\n" loc_x loc_y) 
			fprintf(port "PAINT RED (%d %d);\n" loc_x loc_y) else
			printf("..Concept_ADD_SupportSymbol_OffPage %L\n" rec)
		    )
		)
	    )
	)
    )
)
procedure(TRL_ALTIUM2HDL_SCH_Create_Concept_ADD_SupportSymbol_Port(port sch_name pgnr harnessPorts) 
    let((sup_recs netname id width style
	    iotype align loc_x loc_y port_list
	    orient port_name type netn port_terminal
	    harness port_txt
	) 
	unless(pgnr t) 
	foreach(data 
	    (trl_altium2hdl_global->Nets) 
	    when((car(data) == sch_name) 
		(sup_recs = caddr(data)) 
		(sup_recs = nth(6 sup_recs))
	    )
	) 
	(port_list = list()) 
	(port_terminal = list())
	when(sup_recs 
	    foreach(rec sup_recs 
		(netn = get(rec 
			'NAME
		    )) 
		(id = get(rec 
			'OWNERPARTID
		    )) 
		when(netn 
		    if((id == "-1") then 
			(style = get(rec 
				'STYLE
			    )) 
			(iotype = get(rec 
				'IOTYPE
			    )) 
			(align = get(rec 
				'ALIGNMENT
			    ))
			(width = get(rec 
				'WIDTH
			    )) 
			(loc_x = get(rec 
				'LOCATION\.X
			    )) 
			(loc_y = get(rec 
				'LOCATION\.Y
			    )) 
			(harness = get(rec 
				'HARNESSTYPE
			    )) 
			(port_txt = netn)
			(netname = TRL_ALTIUM2HDL_PCB_Util_Signal_Namemaper(netn)) 
			unless(style 
			    (style = "0")
			) 
			if(harness then 
			    if(((style == "0") || (style == "1") || (style == "2") || (style == "3")) then 
				(harnessPorts = cons(list((atoi(loc_x):atoi(loc_y)) harness) harnessPorts)) 
				(harnessPorts = cons(list(((atoi(loc_x) + atoi(width)):atoi(loc_y)) harness) harnessPorts)) else
				(harnessPorts = cons(list((atoi(loc_x):atoi(loc_y)) harness) harnessPorts)) 
				(harnessPorts = cons(list((atoi(loc_x):(atoi(loc_y) + atoi(width))) harness) harnessPorts))
			    ) 
			    if((trl_altium2hdl_global->Harness_Adap) then 
				foreach(adapter 
				    (trl_altium2hdl_global->Harness_Adap) 
				    when((car(adapter) == harness) 
					if((length(cadr(adapter)) > 1) then 
					    (netname = TRL_ALTIUM2HDL_PCB_Util_Signal_Namemaper(harness)) 
					    (netname = sprintf(nil "%s<0..%d>" netname 
						    (length(cadr(adapter)) - 1)
						)) else
					    (netname = TRL_ALTIUM2HDL_PCB_Util_Signal_Namemaper(harness))
					)
				    )
				) else 
				(netname = TRL_ALTIUM2HDL_PCB_Util_Signal_Namemaper(harness))
			    ) else
			    (netname = TRL_ALTIUM2HDL_PCB_Util_Signal_Namemaper(netn))
			) 
			(loc_x = (atoi(loc_x) * 5)) 
			(loc_y = (atoi(loc_y) * 5))
			unless(style 
			    (style = "0")
			) 
			unless(iotype 
			    (iotype = "0")
			) 
			case(style 
			    ("0" 
				(orient = "HORI") 
				(loc_x = (loc_x + 50))
			    ) 
			    ("1" 
				(orient = "HORI") 
				(loc_x = (loc_x + 50))
			    ) 
			    ("2" 
				(orient = "HORI") 
				(loc_x = (loc_x + 50))
			    ) 
			    ("3" 
				(orient = "HORI") 
				(loc_x = (loc_x + 50))
			    )
			    ("4" 
				(orient = "VERT") 
				(loc_y = (loc_y + 50))
			    ) 
			    ("5" 
				(orient = "VERT") 
				(loc_y = (loc_y + 50))
			    ) 
			    ("6" 
				(orient = "VERT") 
				(loc_y = (loc_y + 50))
			    ) 
			    ("7" 
				(orient = "VERT") 
				(loc_y = (loc_y + 50))
			    ) 
			    (t 
				printf("--PORT-> %L %L %L %L %L %L %L\n" netname style iotype align
				    width loc_x loc_y
				)
			    )
			) 
			case(iotype 
			    ("0" 
				case(style 
				    ("0" 
					(type = "IN")
				    ) 
				    ("1" 
					(type = "IN")
				    ) 
				    ("2" 
					(type = "OUT")
				    ) 
				    ("3" 
					(type = "INOUT")
				    )
				    ("4" 
					(type = "IN")
				    ) 
				    ("5" 
					(type = "IN")
				    ) 
				    ("6" 
					(type = "OUT")
				    ) 
				    ("7" 
					(type = "INOUT")
				    ) 
				    (t 
					(type = "IN") 
					printf("--PORT1-> %L %L %L %L %L %L %L\n" netname style iotype align
					    width loc_x loc_y
					)
				    )
				)
			    ) 
			    ("1" 
				(type = "IN")
			    ) 
			    ("2" 
				(type = "OUT")
			    ) 
			    ("3" 
				(type = "INOUT")
			    )
			    (t 
				(type = "IN") 
				printf("--PORT2-> %L %L %L %L %L %L %L\n" netname style iotype align
				    width loc_x loc_y
				)
			    )
			) 
			(port_name = sprintf(nil "PORT_%s_%s_%s" orient type width))
			unless(member(port_name port_list) 
			    TRL_ALTIUM2HDL_SCH_Create_PortSymbol(port_name orient type width) 
			    (port_list = cons(port_name port_list))
			) 
			fprintf(port "FORCEADD %s..1\n" port_name) 
			fprintf(port "(%d %d);\n" loc_x loc_y) 
			fprintf(port "PAINT BROWN (%d %d);\n" loc_x loc_y) 
			if((orient == "HORI") then 
			    fprintf(port "FORCEPROP 0 LASTPIN (%d %d) SIG_NAME %s\n" 
				(loc_x - 50) loc_y netname
			    ) 
			    fprintf(port "(%d %d);\n" loc_x 
				(loc_y - 16)
			    ) 
			    fprintf(port "DISPLAY 0.72 (%d %d);\n" loc_x 
				(loc_y - 16)
			    )
			    fprintf(port "PAINT BROWN (%d %d);\n" loc_x 
				(loc_y - 16)
			    ) 
			    fprintf(port "DISPLAY INVISIBLE (%d %d);\n" loc_x 
				(loc_y - 16)
			    ) 
			    (port_terminal = cons(list(((loc_x - 50):loc_y) netname) port_terminal)) 
			    fprintf(port "FORCEPROP 0 LASTPIN (%d %d) PORT_TXT %s\n" 
				(loc_x - 50) loc_y port_txt
			    ) 
			    fprintf(port "(%d %d);\n" loc_x 
				(loc_y - 16)
			    )
			    fprintf(port "DISPLAY 0.72 (%d %d);\n" loc_x 
				(loc_y - 16)
			    ) 
			    fprintf(port "PAINT BROWN (%d %d);\n" loc_x 
				(loc_y - 16)
			    ) 
			    fprintf(port "FORCEPROP 0 LASTPIN (%d %d) SIG_NAME %s\n" 
				((loc_x + (atoi(width) * 5)) - 50) loc_y netname
			    ) 
			    fprintf(port "(%d %d);\n" loc_x 
				(loc_y - 16)
			    ) 
			    fprintf(port "DISPLAY 0.72 (%d %d);\n" loc_x 
				(loc_y - 16)
			    )
			    fprintf(port "PAINT BROWN (%d %d);\n" loc_x 
				(loc_y - 16)
			    ) 
			    fprintf(port "DISPLAY INVISIBLE (%d %d);\n" loc_x 
				(loc_y - 16)
			    ) 
			    (port_terminal = cons(list((((loc_x + (atoi(width) * 5)) - 50):loc_y) netname) port_terminal)) 
			    fprintf(port "FORCEPROP 0 LASTPIN (%d %d) PORT_TXT %s\n" 
				((loc_x + (atoi(width) * 5)) - 50) loc_y port_txt
			    ) 
			    fprintf(port "(%d %d);\n" loc_x 
				(loc_y - 16)
			    )
			    fprintf(port "DISPLAY 0.72 (%d %d);\n" loc_x 
				(loc_y - 16)
			    ) 
			    fprintf(port "PAINT BROWN (%d %d);\n" loc_x 
				(loc_y - 16)
			    ) else 
			    fprintf(port "FORCEPROP 0 LASTPIN (%d %d) SIG_NAME %s\n" loc_x 
				(loc_y - 50) netname
			    ) 
			    fprintf(port "R 1\n")
			    fprintf(port "(%d %d);\n" 
				(loc_x + 16) loc_y
			    ) 
			    fprintf(port "DISPLAY 0.72 (%d %d);\n" 
				(loc_x + 16) loc_y
			    ) 
			    fprintf(port "PAINT BROWN (%d %d);\n" 
				(loc_x + 16) loc_y
			    ) 
			    fprintf(port "DISPLAY INVISIBLE (%d %d);\n" 
				(loc_x + 16) loc_y
			    ) 
			    (port_terminal = cons(list((loc_x:(loc_y - 50)) netname) port_terminal))
			    fprintf(port "FORCEPROP 0 LASTPIN (%d %d) PORT_TXT %s\n" loc_x 
				(loc_y - 50) port_txt
			    ) 
			    fprintf(port "R 1\n") 
			    fprintf(port "(%d %d);\n" 
				(loc_x + 16) loc_y
			    ) 
			    fprintf(port "DISPLAY 0.72 (%d %d);\n" 
				(loc_x + 16) loc_y
			    ) 
			    fprintf(port "PAINT BROWN (%d %d);\n" 
				(loc_x + 16) loc_y
			    )
			    fprintf(port "FORCEPROP 0 LASTPIN (%d %d) SIG_NAME %s\n" loc_x 
				((loc_y + (atoi(width) * 5)) - 50) netname
			    ) 
			    fprintf(port "R 1\n") 
			    fprintf(port "(%d %d);\n" 
				(loc_x + 16) loc_y
			    ) 
			    fprintf(port "DISPLAY 0.72 (%d %d);\n" 
				(loc_x + 16) loc_y
			    ) 
			    fprintf(port "PAINT BROWN (%d %d);\n" 
				(loc_x + 16) loc_y
			    )
			    fprintf(port "DISPLAY INVISIBLE (%d %d);\n" 
				(loc_x + 16) loc_y
			    ) 
			    (port_terminal = cons(list((loc_x:((loc_y + (atoi(width) * 5)) - 50)) netname) port_terminal)) 
			    fprintf(port "FORCEPROP 0 LASTPIN (%d %d) PORT_TXT %s\n" loc_x 
				((loc_y + (atoi(width) * 5)) - 50) port_txt
			    ) 
			    fprintf(port "R 1\n") 
			    fprintf(port "(%d %d);\n" 
				(loc_x + 16) loc_y
			    )
			    fprintf(port "DISPLAY 0.72 (%d %d);\n" 
				(loc_x + 16) loc_y
			    ) 
			    fprintf(port "PAINT BROWN (%d %d);\n" 
				(loc_x + 16) loc_y
			    )
			)
			else 
			printf("..Concept_ADD_SupportSymbol_Port %L\n" rec)
		    )
		)
	    )
	) 
	when(port_terminal 
	    (trl_altium2hdl_global->PortTerminal = cons(list(sch_name port_terminal) 
		    (trl_altium2hdl_global->PortTerminal)
		))
	) harnessPorts
    )
)
procedure(TRL_ALTIUM2HDL_SCH_Create_Concept_ADD_SupportSymbol_Power_Port(port sch_name pgnr) 
    let((netname style loc_x loc_y rot
	    pow_symbol prop_val just offpage support_recs
	) 
	unless(pgnr t) 
	foreach(data 
	    (trl_altium2hdl_global->Nets) 
	    when((car(data) == sch_name) 
		(support_recs = caddr(data)) 
		(support_recs = nth(5 support_recs))
	    )
	) 
	when(support_recs 
	    foreach(rec support_recs 
		(netname = get(rec 
			'SHOWNETNAME
		    )) 
		(offpage = get(rec 
			'ISCROSSSHEETCONNECTOR
		    )) 
		when(netname 
		    unless(offpage 
			(style = get(rec 
				'STYLE
			    )) 
			(prop_val = get(rec 
				'TEXT
			    )) 
			(loc_x = get(rec 
				'LOCATION\.X
			    )) 
			(loc_y = get(rec 
				'LOCATION\.Y
			    ))
			(rot = get(rec 
				'ORIENTATION
			    )) 
			(loc_x = (atoi(loc_x) * 5)) 
			(loc_y = (atoi(loc_y) * 5)) 
			unless(style 
			    (style = "0")
			) 
			case(style 
			    ("0" 
				(pow_symbol = "CIRCLE")
			    ) 
			    ("1" 
				(pow_symbol = "ARROW")
			    ) 
			    ("2" 
				(pow_symbol = "BAR")
			    ) 
			    ("3" 
				(pow_symbol = "WAVE")
			    )
			    ("4" 
				(pow_symbol = "POWER_GROUND")
			    ) 
			    ("5" 
				(pow_symbol = "SIGNAL_GROUND")
			    ) 
			    ("6" 
				(pow_symbol = "EARTH")
			    ) 
			    (t 
				(pow_symbol = "BAR") 
				printf("--POWR_SYMBOL: %L\n" rec)
			    )
			)
			fprintf(port "FORCEADD %s..1\n" pow_symbol) 
			unless(rot 
			    when((pow_symbol == "CIRCLE") 
				(loc_x = (loc_x + 50))
			    )
			) 
			when(rot 
			    fprintf(port "R %s\n" rot) 
			    case(rot 
				("1" 
				    (loc_y = (loc_y + 50))
				) 
				("2" 
				    (loc_x = (loc_x - 50))
				) 
				("3" 
				    (loc_y = (loc_y - 50))
				) 
				(t 
				    printf("--ADD_SupportSymbol_Power_Port-> ORIENTATION:%L\n" rot)
				)
			    )
			) 
			fprintf(port "(%d %d);\n" loc_x loc_y) 
			fprintf(port "PAINT VIOLET (%d %d);\n" loc_x loc_y)
			fprintf(port "FORCEPROP 1 LAST HDL_POWER %s\n" prop_val) 
			if(rot then 
			    case(rot 
				("1" 
				    (just = "1") 
				    (loc_y = (loc_y + 6)) 
				    when(((pow_symbol == "POWER_GROUND") || (pow_symbol == "SIGNAL_GROUND") || (pow_symbol == "EARTH")) 
					(loc_y = (loc_y + 50))
				    )
				) 
				("2" 
				    (just = "2") 
				    (loc_x = loc_x) 
				    (loc_y = (loc_y - 20)) 
				    when(((pow_symbol == "POWER_GROUND") || (pow_symbol == "SIGNAL_GROUND") || (pow_symbol == "EARTH")) 
					(loc_x = (loc_x - 50))
				    )
				) 
				("3" 
				    (just = "1") 
				    (loc_y = (loc_y - 38)) 
				    when(((pow_symbol == "POWER_GROUND") || (pow_symbol == "SIGNAL_GROUND") || (pow_symbol == "EARTH")) 
					(loc_y = (loc_y - 50))
				    )
				) 
				(t 
				    printf("--> %L\n" rot)
				)
			    ) 
			    fprintf(port "J %s\n" just) else
			    (loc_x = (loc_x + 6)) 
			    (loc_y = (loc_y - 20)) 
			    when(((pow_symbol == "POWER_GROUND") || (pow_symbol == "SIGNAL_GROUND") || (pow_symbol == "EARTH")) 
				(loc_x = (loc_x + 50))
			    )
			) 
			fprintf(port "(%d %d);\n" loc_x loc_y) 
			fprintf(port "DISPLAY 0.82 (%d %d);\n" loc_x loc_y) 
			fprintf(port "PAINT VIOLET (%d %d);\n" loc_x loc_y)
			when((netname == "F") 
			    fprintf(port "DISPLAY INVISIBLE (%d %d);\n" loc_x loc_y)
			)
		    )
		)
	    )
	)
    )
)
procedure(TRL_ALTIUM2HDL_SCH_Create_Concept_ADD_SymLabel(port sym) 
    let((prop_val prop_name hidden owner_ind owner_id
	    font_id just lx ly prop_size
	    part_value part_loc sym_part_nu
	) 
	foreach(rec sym 
	    (prop_val = get(rec 
		    'TEXT
		)) 
	    (prop_name = get(rec 
		    'NAME
		)) 
	    (hidden = get(rec 
		    'ISHIDDEN
		))
	    (owner_ind = get(rec 
		    'OWNERINDEX
		)) 
	    (owner_id = get(rec 
		    'OWNERPARTID
		)) 
	    (font_id = get(rec 
		    'FONTID
		)) 
	    (just = get(rec 
		    'JUSTIFICATION
		)) 
	    (lx = get(rec 
		    'LOCATION\.X
		))
	    (ly = get(rec 
		    'LOCATION\.Y
		)) 
	    when((prop_val && prop_name) 
		unless((prop_name == "PinUniqueId") 
		    when(font_id 
			(prop_size = TRL_ALTIUM2HDL_SCH_Util_Font_ID(font_id)) 
			(prop_size = (car(prop_size) / 47.0))
		    ) 
		    unless(prop_size 
			(prop_size = 0.82)
		    ) 
		    if((lx && ly) then 
			(lx = (atoi(lx) * 5)) 
			(ly = (atoi(ly) * 5)) 
			(part_value = upperCase((axlFormGetField 
				    (trl_altium2hdl_global->formid) "part_value_l"
				)
			    ))
			(part_loc = upperCase((axlFormGetField 
				    (trl_altium2hdl_global->formid) "location_l"
				)
			    )) 
			(sym_part_nu = upperCase((axlFormGetField 
				    (trl_altium2hdl_global->formid) "sym_part_number_l"
				)
			    )) 
			when((upperCase(prop_name) == part_value) 
			    (prop_name = upperCase(prop_name))
			) 
			when((upperCase(prop_name) == part_loc) 
			    (prop_name = "LOCATION")
			) 
			when((upperCase(sym_part_nu) == part_loc) 
			    (prop_name = "PART_NUMBER")
			)
			fprintf(port "FORCEPROP 1 LAST %s %s\n" prop_name prop_val) 
			(trl_altium2hdl_global->exeption = cons(sprintf(nil "   5.3.02 INFO    - Placing Label: %L = %L" prop_name prop_val) 
				(trl_altium2hdl_global->exeption)
			    )) 
			fprintf(port "(%d %d);\n" lx ly) 
			fprintf(port "DISPLAY %f (%d %d);\n" prop_size lx ly) 
			when(hidden 
			    fprintf(port "DISPLAY INVISIBLE (%d %d);\n" lx ly)
			)
			else 
			printf("-->??SYMLABEL?? %L %L %L %L %L %L %L %L %L \n" prop_val prop_name hidden owner_ind
			    owner_id font_id just lx ly
			)
		    )
		)
	    )
	)
    )
)
procedure(TRL_ALTIUM2HDL_SCH_Create_Concept_ADD_Symbol_Attributes(port sym coor lib_ref) 
    let((record font_id prop_size lx ly
	    hidden prop_val prop_name just rot
	) 
	unless(coor t) 
	unless(lib_ref t) 
	foreach(rec sym 
	    (record = get(rec 
		    'RECORD
		)) 
	    (prop_name = get(rec 
		    'NAME
		)) 
	    when((prop_name && (record == "41") && (prop_name != "Comment") && (prop_name != "PinUniqueId")) 
		(prop_val = get(rec 
			'TEXT
		    )) 
		(hidden = get(rec 
			'ISHIDDEN
		    )) 
		(font_id = get(rec 
			'FONTID
		    )) 
		(just = get(rec 
			'JUSTIFICATION
		    ))
		(rot = get(rec 
			'ORIENTATION
		    )) 
		(lx = get(rec 
			'LOCATION\.X
		    )) 
		(ly = get(rec 
			'LOCATION\.Y
		    )) 
		when((prop_val && lx && ly) 
		    if((upperCase(prop_name) == "RULE") then 
			(trl_altium2hdl_global->exeption = cons(sprintf(nil "   5.3.45 INFO    - Placing Attribute RULE: %L - %L" 
				    upperCase(prop_name) prop_val
				) 
				(trl_altium2hdl_global->exeption)
			    )) else 
			when((upperCase(prop_name) == "SIZE") 
			    (prop_name = "CMP_SIZE")
			)
			(prop_name = TRL_ALTIUM2HDL_SCH_Util_PCB_Namemaper(prop_name)) 
			(lx = (atoi(lx) * 5)) 
			(ly = (atoi(ly) * 5)) 
			fprintf(port "FORCEPROP 2 LAST %s %s\n" 
			    upperCase(prop_name) prop_val
			) 
			when(rot 
			    case(rot 
				("1" 
				    fprintf(port "R 1\n")
				) 
				("2" 
				    fprintf(port "R 1\n")
				) 
				("3" 
				    fprintf(port "R 3\n")
				) 
				("4" 
				    fprintf(port "R 4\n")
				)
				("5" 
				    fprintf(port "R 6\n")
				) 
				("6" 
				    fprintf(port "R 5\n")
				) 
				("7" 
				    fprintf(port "R 7\n")
				) 
				(t 
				    printf("---UNKNOWN ROT/MIRR CODE %L %L %L\n" lx ly rot)
				)
			    )
			)
			when((just == "2") 
			    fprintf(port "J 2\n")
			) 
			when(font_id 
			    (prop_size = TRL_ALTIUM2HDL_SCH_Util_Font_ID(font_id)) 
			    (prop_size = (car(prop_size) / 47.0))
			) 
			unless(prop_size 
			    (prop_size = 0.82)
			) 
			when((prop_size > 5.0) 
			    (prop_size = 1.0)
			) 
			unless(rot 
			    (ly = (ly + round(((prop_size / 2) * 50))))
			)
			when((rot == "1") 
			    (lx = (lx - round(((prop_size / 2) * 50))))
			) 
			fprintf(port "(%d %d);\n" lx ly) 
			fprintf(port "DISPLAY %f (%d %d);\n" prop_size lx ly) 
			fprintf(port "PAINT BLACK (%d %d);\n" lx ly) 
			when((hidden == "T") 
			    fprintf(port "DISPLAY INVISIBLE (%d %d);\n" lx ly)
			)
		    )
		)
	    )
	)
    )
)
procedure(TRL_ALTIUM2HDL_SCH_Create_Concept_ADD_Symbol_Comment(port sym coor lib_ref) 
    let((record comment_rec comment font_id prop_size
	    lx ly hidden prop_val prop_name
	    just rot p_name p_val P_Val
	    rec
	) 
	(coor = coor) 
	(lib_ref = lib_ref) 
	(comment_rec = nil) 
	foreach(rc sym 
	    (record = get(rc 
		    'RECORD
		)) 
	    (prop_name = get(rc 
		    'NAME
		)) 
	    (hidden = get(rc 
		    'ISHIDDEN
		))
	    when(((record == "41") && (prop_name == "Comment")) 
		(comment_rec = rc)
	    )
	)
	when(comment_rec 
	    (rec = comment_rec) 
	    (prop_val = get(rec 
		    'TEXT
		)) 
	    (prop_name = get(rec 
		    'NAME
		)) 
	    (hidden = get(rec 
		    'ISHIDDEN
		))
	    (font_id = get(rec 
		    'FONTID
		)) 
	    (just = get(rec 
		    'JUSTIFICATION
		)) 
	    (rot = get(rec 
		    'ORIENTATION
		)) 
	    (lx = get(rec 
		    'LOCATION\.X
		)) 
	    (ly = get(rec 
		    'LOCATION\.Y
		))
	    when((prop_val && lx && ly) 
		(P_Val = nil) 
		foreach(rc sym 
		    (record = get(rc 
			    'RECORD
			)) 
		    (p_name = get(rc 
			    'NAME
			)) 
		    (p_val = get(rc 
			    'TEXT
			))
		    unless(p_name 
			(p_name = "")
		    ) 
		    when(((record == "41") && (p_name != "Comment")) 
			when((upperCase(p_name) == upperCase(prop_val)) 
			    (P_Val = p_val)
			)
		    )
		) 
		if(P_Val then 
		    (comment = P_Val) else 
		    (comment = prop_val)
		) 
		(lx = (atoi(lx) * 5))
		(ly = (atoi(ly) * 5)) 
		when(comment 
		    fprintf(port "FORCEPROP 2 LAST CDS_COMMENT %s\n" comment) 
		    when(rot 
			case(rot 
			    ("1" 
				fprintf(port "R 1\n")
			    ) 
			    ("2" 
				fprintf(port "R 1\n")
			    ) 
			    ("3" 
				fprintf(port "R 3\n")
			    ) 
			    ("4" 
				fprintf(port "R 4\n")
			    )
			    ("5" 
				fprintf(port "R 6\n")
			    ) 
			    ("6" 
				fprintf(port "R 5\n")
			    ) 
			    ("7" 
				fprintf(port "R 7\n")
			    ) 
			    (t 
				printf("---UNKNOWN ROT/MIRR CODE %L %L %L\n" lx ly rot)
			    )
			)
		    ) 
		    when((just == "2") 
			fprintf(port "J 2\n")
		    ) 
		    when(font_id 
			(prop_size = TRL_ALTIUM2HDL_SCH_Util_Font_ID(font_id)) 
			(prop_size = (car(prop_size) / 47.0))
		    )
		    unless(prop_size 
			(prop_size = 0.82)
		    ) 
		    when((prop_size > 5.0) 
			(prop_size = 1.0)
		    ) 
		    unless(rot 
			(ly = (ly + round(((prop_size / 2) * 50))))
		    ) 
		    when((rot == "1") 
			(lx = (lx - round(((prop_size / 2) * 50))))
		    ) 
		    fprintf(port "(%d %d);\n" lx ly)
		    fprintf(port "DISPLAY %f (%d %d);\n" prop_size lx ly) 
		    fprintf(port "PAINT BLACK (%d %d);\n" lx ly) 
		    when((hidden == "T") 
			fprintf(port "DISPLAY INVISIBLE (%d %d);\n" lx ly)
		    ) 
		    when((axlFormGetField 
			    (trl_altium2hdl_global->formid) "verbose"
			) 
			(trl_altium2hdl_global->exeption = cons(sprintf(nil "   5.3.24 INFO    - Placing Comment: %L" comment) 
				(trl_altium2hdl_global->exeption)
			    ))
		    )
		)
	    )
	) 
	unless(comment 
	    (trl_altium2hdl_global->exeption = cons(sprintf(nil "   5.3.24 ERROR   - Missing Comment: %L" sym) 
		    (trl_altium2hdl_global->exeption)
		))
	) comment
    )
)
procedure(TRL_ALTIUM2HDL_SCH_Create_Concept_ADD_Symbol_JedecType(port sym coor lib_ref) 
    let((record iscurrent modeltype modelname x
	    y letsgo
	) 
	(x = car(coor)) 
	(y = cadr(coor)) 
	(letsgo = t) 
	when((trl_altium2hdl_global->PackIgnore) 
	    foreach(packi 
		(trl_altium2hdl_global->PackIgnore) 
		when((packi == lib_ref) 
		    (letsgo = nil)
		)
	    )
	)
	if(letsgo then 
	    foreach(rec sym 
		(record = get(rec 
			'RECORD
		    )) 
		(iscurrent = get(rec 
			'ISCURRENT
		    )) 
		(modeltype = get(rec 
			'MODELTYPE
		    ))
		when(((record == "45") && (iscurrent == "T") && (modeltype == "PCBLIB")) 
		    (modelname = get(rec 
			    'MODELNAME
			)) 
		    when(modelname 
			(modelname = TRL_ALTIUM2HDL_SCH_Util_PCB_Namemaper(modelname)) 
			fprintf(port "FORCEPROP 1 LAST JEDEC_TYPE %s\n" modelname) 
			when((axlFormGetField 
				(trl_altium2hdl_global->formid) "verbose"
			    ) 
			    (trl_altium2hdl_global->exeption = cons(sprintf(nil "   5.3.21 INFO    - Placing JEDEC_TYPE: %L" modelname) 
				    (trl_altium2hdl_global->exeption)
				))
			) 
			fprintf(port "(%d %d);\n" x y)
			fprintf(port "DISPLAY %f (%d %d);\n" 52.0 x y) 
			fprintf(port "PAINT BLUE (%d %d);\n" x y) 
			fprintf(port "DISPLAY INVISIBLE (%d %d);\n" x y)
		    )
		)
	    ) 
	    unless(modelname 
		(trl_altium2hdl_global->exeption = cons(sprintf(nil "   5.3.21 ERROR   - Missing JEDEC_TYPE: %L" sym) 
			(trl_altium2hdl_global->exeption)
		    ))
	    ) else
	    (trl_altium2hdl_global->exeption = cons("   5.3.22 WARNIN  - NO JEDEC_TYPE Assigned" 
		    (trl_altium2hdl_global->exeption)
		))
	)
    )
)
procedure(TRL_ALTIUM2HDL_SCH_Create_Concept_ADD_Symbol_RefAttributes(port sym coor lib_ref att_ref) 
    let((record font_id prop_size lx ly
	    hidden prop_val prop_name just rot
	    new_prop_name
	) 
	unless(coor t) 
	unless(lib_ref t) 
	foreach(rec sym 
	    (record = get(rec 
		    'RECORD
		)) 
	    (prop_name = get(rec 
		    'NAME
		)) 
	    (new_prop_name = nil)
	    when((record == "41") 
		foreach(ref_rec att_ref 
		    when((upperCase(prop_name) == upperCase(car(ref_rec))) 
			(new_prop_name = cadr(ref_rec))
		    )
		) 
		when(new_prop_name 
		    (prop_val = get(rec 
			    'TEXT
			)) 
		    (hidden = get(rec 
			    'ISHIDDEN
			)) 
		    (font_id = get(rec 
			    'FONTID
			)) 
		    (just = get(rec 
			    'JUSTIFICATION
			))
		    (rot = get(rec 
			    'ORIENTATION
			)) 
		    (lx = get(rec 
			    'LOCATION\.X
			)) 
		    (ly = get(rec 
			    'LOCATION\.Y
			)) 
		    when((prop_val && lx && ly) 
			(prop_name = TRL_ALTIUM2HDL_SCH_Util_PCB_Namemaper(prop_name)) 
			(lx = (atoi(lx) * 5)) 
			(ly = (atoi(ly) * 5)) 
			fprintf(port "FORCEPROP 2 LAST %s %s\n" 
			    upperCase(new_prop_name) prop_val
			)
			when(rot 
			    case(rot 
				("1" 
				    fprintf(port "R 1\n")
				) 
				("2" 
				    fprintf(port "R 1\n")
				) 
				("3" 
				    fprintf(port "R 3\n")
				) 
				("4" 
				    fprintf(port "R 4\n")
				)
				("5" 
				    fprintf(port "R 6\n")
				) 
				("6" 
				    fprintf(port "R 5\n")
				) 
				("7" 
				    fprintf(port "R 7\n")
				) 
				(t 
				    printf("---UNKNOWN ROT/MIRR CODE %L %L %L\n" lx ly rot)
				)
			    )
			) 
			when((just == "2") 
			    fprintf(port "J 2\n")
			) 
			when(font_id 
			    (prop_size = TRL_ALTIUM2HDL_SCH_Util_Font_ID(font_id)) 
			    (prop_size = (car(prop_size) / 47.0))
			) 
			unless(prop_size 
			    (prop_size = 0.82)
			) 
			when((prop_size > 5.0) 
			    (prop_size = 1.0)
			)
			unless(rot 
			    (ly = (ly + round(((prop_size / 2) * 50))))
			) 
			when((rot == "1") 
			    (lx = (lx - round(((prop_size / 2) * 50))))
			) 
			fprintf(port "(%d %d);\n" lx ly) 
			fprintf(port "DISPLAY %f (%d %d);\n" prop_size lx ly) 
			fprintf(port "PAINT BLACK (%d %d);\n" lx ly)
			when((hidden == "T") 
			    fprintf(port "DISPLAY INVISIBLE (%d %d);\n" lx ly)
			)
		    )
		)
	    )
	)
    )
)
procedure(TRL_ALTIUM2HDL_SCH_Create_Concept_ADD_Symbol_RefDes(port sym coor lib_ref) 
    let((record ref_des_rec ref_des font_id prop_size
	    lx ly hidden rec prop_val
	    just rot
	) 
	(coor = coor) 
	(lib_ref = lib_ref) 
	foreach(rc sym 
	    (record = get(rc 
		    'RECORD
		)) 
	    when((record == "34") 
		(ref_des_rec = rc)
	    )
	) 
	if(ref_des_rec then 
	    (rec = ref_des_rec) 
	    (prop_val = get(rec 
		    'TEXT
		)) 
	    (hidden = get(rec 
		    'ISHIDDEN
		))
	    (font_id = get(rec 
		    'FONTID
		)) 
	    (just = get(rec 
		    'JUSTIFICATION
		)) 
	    (rot = get(rec 
		    'ORIENTATION
		)) 
	    (lx = get(rec 
		    'LOCATION\.X
		)) 
	    (ly = get(rec 
		    'LOCATION\.Y
		))
	    when((prop_val && lx && ly) 
		(ref_des = prop_val) 
		(lx = (atoi(lx) * 5)) 
		(ly = (atoi(ly) * 5)) 
		when((ref_des == "*") 
		    (ref_des = "ASTERIX")
		)
		fprintf(port "FORCEPROP 1 LAST LOCATION %s\n" ref_des) 
		when(rot 
		    case(rot 
			("1" 
			    fprintf(port "R 1\n")
			) 
			("2" 
			    fprintf(port "R 1\n")
			) 
			("3" 
			    fprintf(port "R 3\n")
			) 
			("4" 
			    fprintf(port "R 4\n")
			)
			("5" 
			    fprintf(port "R 6\n")
			) 
			("6" 
			    fprintf(port "R 5\n")
			) 
			("7" 
			    fprintf(port "R 7\n")
			) 
			(t 
			    printf("---UNKNOWN ROT/MIRR CODE %L %L %L\n" lx ly rot)
			)
		    )
		) 
		when((just == "2") 
		    fprintf(port "J 2\n")
		) 
		when(font_id 
		    (prop_size = TRL_ALTIUM2HDL_SCH_Util_Font_ID(font_id)) 
		    (prop_size = (car(prop_size) / 47.0))
		) 
		unless(prop_size 
		    (prop_size = 0.82)
		)
		when((prop_size > 5.0) 
		    (prop_size = 1.0)
		) 
		unless(rot 
		    (ly = (ly + round((prop_size * 5)))) 
		    (ly = (ly + 2))
		) 
		when((rot == "1") 
		    (lx = (lx - round((prop_size * 5)))) 
		    (lx = (lx - 4))
		) 
		fprintf(port "(%d %d);\n" lx ly) 
		fprintf(port "DISPLAY %f (%d %d);\n" prop_size lx ly)
		fprintf(port "PAINT BLUE (%d %d);\n" lx ly) 
		when(hidden 
		    fprintf(port "DISPLAY INVISIBLE (%d %d);\n" lx ly)
		) 
		when((axlFormGetField 
			(trl_altium2hdl_global->formid) "verbose"
		    ) 
		    (trl_altium2hdl_global->exeption = cons(sprintf(nil "   5.3.23 INFO    - Placing LOCATION: %L" ref_des) 
			    (trl_altium2hdl_global->exeption)
			))
		)
	    ) 
	    unless(ref_des 
		(trl_altium2hdl_global->exeption = cons(sprintf(nil "   5.3.23 ERROR   - Missing REF_DES: %L" sym) 
			(trl_altium2hdl_global->exeption)
		    ))
	    ) else 
	    (trl_altium2hdl_global->exeption = cons("   5.3.23 WARNIN  - NO LOCATION Assigned" 
		    (trl_altium2hdl_global->exeption)
		))
	)
    )
)
procedure(TRL_ALTIUM2HDL_SCH_Create_Concept_ADD_Wires(port sch_name pgnr) 
    let((id lwidth l_cnt x_val y_val
	    l_points start_x start_y x y
	    sig_name wir_recs net_recs windex poly_sig_name
	    sup_recs port_alis_list end_x end_y alias_sig_name
	    alias_offset
	) 
	(windex = 1) 
	foreach(data 
	    (trl_altium2hdl_global->Nets) 
	    when((car(data) == sch_name) 
		(sup_recs = caddr(data)) 
		(wir_recs = car(sup_recs)) 
		(net_recs = cadr(sup_recs))
	    )
	) 
	when((trl_altium2hdl_global->PortTerminal) 
	    foreach(sch 
		(trl_altium2hdl_global->PortTerminal) 
		when((car(sch) == sch_name) 
		    (port_alis_list = cadr(sch))
		)
	    )
	) 
	if(wir_recs then 
	    (trl_altium2hdl_global->exeption = cons(sprintf(nil "   5.5.01 INFO    - Wires: [%4d] - Nets: [%4d] Start Placing Wires on Page: %L " 
			length(wir_recs) 
			length(net_recs) pgnr
		    ) 
		    (trl_altium2hdl_global->exeption)
		)) 
	    foreach(rec wir_recs 
		(sig_name = nil) 
		(id = get(rec 
			'OWNERPARTID
		    )) 
		(lwidth = get(rec 
			'LINEWIDTH
		    ))
		(l_cnt = get(rec 
			'LOCATIONCOUNT
		    )) 
		if((id == "-1") then 
		    case(lwidth 
			("1" 
			    (lwidth = 82)
			) 
			("2" 
			    (lwidth = 83)
			) 
			("3" 
			    (lwidth = 83)
			) 
			(t 
			    (lwidth = 82)
			)
		    ) 
		    if(l_cnt then 
			(l_cnt = atoi(l_cnt)) 
			(l_points = list()) 
			for(i 1 l_cnt 
			    (x_val = stringToSymbol(sprintf(nil "X%d" i))) 
			    (y_val = stringToSymbol(sprintf(nil "Y%d" i)))
			    (x_val = get(rec x_val)) 
			    (y_val = get(rec y_val)) 
			    if(x_val then 
				(x = (atoi(x_val) * 5)) else 
				(x = 0)
			    ) 
			    if(y_val then 
				(y = (atoi(y_val) * 5)) else 
				(y = 0)
			    ) 
			    (l_points = cons((x:y) l_points))
			)
			if(l_points then 
			    (start_x = caar(l_points)) 
			    (start_y = cadar(l_points)) 
			    if((length(l_points) > 2) then 
				when(net_recs 
				    foreach(l_coor 
					cdr(l_points) 
					(x = car(l_coor)) 
					(y = cadr(l_coor)) 
					(alias_sig_name = TRL_ALTIUM2HDL_SCH_Create_Concept_Find_NetName(net_recs start_x start_y x y))
					(start_x = x) 
					(start_y = y)
				    )
				) 
				(start_x = caar(l_points)) 
				(start_y = cadar(l_points))
				foreach(l_coor 
				    cdr(l_points) 
				    (x = car(l_coor)) 
				    (y = cadr(l_coor)) 
				    when(net_recs 
					(sig_name = TRL_ALTIUM2HDL_SCH_Create_Concept_Find_NetName(net_recs start_x start_y x y))
				    )
				    when((alias_sig_name && port_alis_list) 
					(alias_offset = TRL_ALTIUM2HDL_SCH_Create_Concept_ADD_ALIAS(port alias_sig_name port_alis_list start_x start_y
						x y
					    ))
				    ) 
				    fprintf(port "WIRE %d -1 (%d %d)(%d %d);\n" lwidth start_x start_y
					x y
				    ) 
				    when(sig_name 
					TRL_ALTIUM2HDL_SCH_Create_Concept_ADD_NetName(port sig_name) 
					(poly_sig_name = car(sig_name)) 
					(sig_name = nil) 
					(alias_sig_name = nil)
				    ) 
				    (start_x = x) 
				    (start_y = y)
				) 
				when((axlFormGetField 
					(trl_altium2hdl_global->formid) "verbose"
				    ) 
				    (trl_altium2hdl_global->exeption = cons(sprintf(nil "   5.3.05 INFO    - Wire [%4d] Net_Label: %L L-Width: %L => %L L-Cnt: %L -> %L" windex poly_sig_name 
						get(rec 
						    'LINEWIDTH
						)
						lwidth l_cnt l_points
					    ) 
					    (trl_altium2hdl_global->exeption)
					))
				) else 
				(end_x = car(cadr(l_points))) 
				(end_y = cadr(cadr(l_points)))
				when(net_recs 
				    (sig_name = TRL_ALTIUM2HDL_SCH_Create_Concept_Find_NetName(net_recs start_x start_y end_x end_y))
				) 
				when((sig_name && port_alis_list) 
				    (alias_offset = TRL_ALTIUM2HDL_SCH_Create_Concept_ADD_ALIAS(port sig_name port_alis_list start_x start_y
					    end_x end_y
					))
				) 
				when(alias_offset 
				    (start_x = car(alias_offset)) 
				    (start_y = cadr(alias_offset)) 
				    (end_x = caddr(alias_offset)) 
				    (end_y = cadddr(alias_offset))
				    (alias_offset = nil)
				) 
				fprintf(port "WIRE %d -1 (%d %d)(%d %d);\n" lwidth start_x start_y
				    end_x end_y
				) 
				if(sig_name then 
				    TRL_ALTIUM2HDL_SCH_Create_Concept_ADD_NetName(port sig_name) 
				    when((axlFormGetField 
					    (trl_altium2hdl_global->formid) "verbose"
					) 
					(trl_altium2hdl_global->exeption = cons(sprintf(nil "   5.3.05 INFO    - Wire [%4d] On Page: %L Net_Label: %L L-Width: %L => %L L-Cnt: %L -> %L" windex sch_name 
						    car(sig_name)
						    get(rec 
							'LINEWIDTH
						    ) lwidth l_cnt l_points
						) 
						(trl_altium2hdl_global->exeption)
					    ))
				    ) 
				    (sig_name = nil)
				    else 
				    when((axlFormGetField 
					    (trl_altium2hdl_global->formid) "verbose"
					) 
					(trl_altium2hdl_global->exeption = cons(sprintf(nil "   5.3.05 INFO    - Wire [%4d] On SCH_Page: %L Net_Label: %L L-Width: %L => %L L-Cnt: %L -> %L" windex sch_name sig_name
						    get(rec 
							'LINEWIDTH
						    ) lwidth l_cnt l_points
						) 
						(trl_altium2hdl_global->exeption)
					    ))
				    )
				)
			    )
			    else 
			    (trl_altium2hdl_global->exeption = cons(sprintf(nil "-->5.5.07 ERROR   - Wire [%4d] No Polygon Data Created: %L on %L Page: %L" windex rec sch_name
					pgnr
				    ) 
				    (trl_altium2hdl_global->exeption)
				))
			) else 
			(trl_altium2hdl_global->exeption = cons(sprintf(nil "   5.5.08 WARNING - Wire [%4d] No Polygon Indication: %L on %L Page: %L" windex rec sch_name
				    pgnr
				) 
				(trl_altium2hdl_global->exeption)
			    ))
		    ) else
		    (trl_altium2hdl_global->exeption = cons(sprintf(nil "   5.5.09 WARNING - Wire [%4d] OWNERPARTID: %L on %L Page: %L" windex id sch_name
				pgnr
			    ) 
			    (trl_altium2hdl_global->exeption)
			))
		) 
		windex++
	    ) else
	    (trl_altium2hdl_global->exeption = cons(sprintf(nil "   5.5.10 INFO    - NO Wire Records on %L Page: %L" sch_name pgnr) 
		    (trl_altium2hdl_global->exeption)
		))
	)
    )
)
procedure(TRL_ALTIUM2HDL_SCH_Create_Concept_Block_Sort() 
    let((block_recs record blocks_lst block_list id
	    Designator block_name all_block_lst File_Name
	) 
	(all_block_lst = list()) 
	foreach(data 
	    (trl_altium2hdl_global->Nets) 
	    (block_recs = cadr(data)) 
	    (block_recs = nth(7 block_recs)) 
	    (block_list = list())
	    (block_list = list()) 
	    foreach(rec block_recs 
		(record = get(rec 
			'RECORD
		    )) 
		if(((record == "15") && block_list) then 
		    (blocks_lst = cons(block_list blocks_lst)) 
		    (block_list = list()) 
		    (block_list = cons(rec block_list))
		    else 
		    (block_list = cons(rec block_list))
		)
	    ) 
	    (blocks_lst = cons(block_list blocks_lst))
	) 
	when(blocks_lst 
	    foreach(block blocks_lst 
		foreach(rec block 
		    (record = get(rec 
			    'RECORD
			)) 
		    (id = get(rec 
			    'OWNERPARTID
			)) 
		    when(((record == "32") && (id == "-1")) 
			(Designator = get(rec 
				'TEXT
			    ))
		    )
		    when(((record == "33") && (id == "-1")) 
			(File_Name = get(rec 
				'TEXT
			    )) 
			(block_name = parseString(File_Name ".")) 
			if((length(block_name) == 2) then 
			    (block_name = car(block_name)) else 
			    (block_name = car(block_name))
			) 
			(block_name = TRL_ALTIUM2HDL_PCB_Util_Namemaper(block_name))
		    )
		) 
		(all_block_lst = cons(list(Designator block_name) all_block_lst))
	    )
	) 
	foreach(b all_block_lst 
	    printf("--BLOCK->%L\n" b)
	)
    )
)
procedure(TRL_ALTIUM2HDL_SCH_Create_Concept_Find_BUS_Names() 
    let((busus bus_name bus_list bus_n msb
	    lsb
	) 
	foreach(sch 
	    (trl_altium2hdl_global->Nets) 
	    (busus = caddr(sch)) 
	    (busus = cadr(busus)) 
	    when(busus 
		foreach(bus busus 
		    (bus_name = get(bus 
			    'TEXT
			)) 
		    if(bus_name then 
			rexCompile(" ") 
			(bus_name = rexReplace(bus_name "_" 0)) 
			rexCompile("[.][.]")
			(bus_name = rexReplace(bus_name " " 0)) 
			(bus_name = parseString(bus_name " ")) 
			when((length(bus_name) == 2) 
			    (bus_n = parseString(car(bus_name) "[")) 
			    (bus_n = car(bus_n)) 
			    (bus_n = TRL_ALTIUM2HDL_PCB_Util_Signal_Namemaper(bus_n)) 
			    (msb = parseString(car(bus_name) "["))
			    (msb = cadr(msb)) 
			    (lsb = car(last(bus_name))) 
			    (lsb = car(parseString(lsb "]"))) 
			    unless(member(list(bus_n msb lsb) bus_list) 
				(bus_list = cons(list(bus_n msb lsb) bus_list))
			    )
			) else 
			(trl_altium2hdl_global->exeption = cons(sprintf(nil "-->3.X.02 INFO    - Bus Record Missing Siganl Name: %L!" bus) 
				(trl_altium2hdl_global->exeption)
			    ))
		    )
		)
	    )
	) 
	(trl_altium2hdl_global->BusNames = bus_list)
    )
)
procedure(TRL_ALTIUM2HDL_SCH_Create_Concept_Find_NetName(net_recs start_x start_y x y) 
    let((sig_name id txt_x txt_y txt
	    font_id onlin font prop_size rot_strg
	    vis tx ty sig_data rot
	    just just_str
	) 
	(sig_data = list()) 
	(rot_strg = "R 0") 
	foreach(net_rec net_recs 
	    (tx = nil) 
	    (ty = nil) 
	    (id = get(net_rec 
		    'OWNERPARTID
		))
	    if((id == "-1") then 
		(txt_x = get(net_rec 
			'LOCATION\.X
		    )) 
		(txt_y = get(net_rec 
			'LOCATION\.Y
		    )) 
		(txt = get(net_rec 
			'TEXT
		    ))
		(font_id = get(net_rec 
			'FONTID
		    )) 
		(rot = get(net_rec 
			'ORIENTATION
		    )) 
		(just = get(net_rec 
			'JUSTIFICATION
		    )) 
		when((txt_x && txt_y) 
		    (tx = (atoi(txt_x) * 5)) 
		    (ty = (atoi(txt_y) * 5)) 
		    (onlin = (axlIsPointOnLine 
			    (tx:ty) 
			    list((start_x:start_y) 
				(x:y)
			    )
			)) 
		    when(onlin 
			(sig_name = TRL_ALTIUM2HDL_PCB_Util_Signal_Namemaper(txt)) 
			when(font_id 
			    (font = TRL_ALTIUM2HDL_SCH_Util_Font_ID(font_id)) 
			    (prop_size = (car(font) / 47.0))
			) 
			unless(prop_size 
			    (prop_size = 0.82)
			) 
			if(caddr(font) then 
			    case(caddr(font) 
				("90" 
				    (tx = (tx - 5)) 
				    (rot_strg = "R 1")
				) 
				("180" 
				    (ty = (ty - 5)) 
				    (rot_strg = "R 2")
				) 
				("270" 
				    (tx = (tx + 5)) 
				    (rot_strg = "R 3")
				) 
				(t 
				    (rot_strg = "R 3")
				)
			    ) else 
			    (ty = (ty + 5))
			    (rot_strg = nil)
			)
			(rot_strg = nil) 
			if(rot then 
			    case(rot 
				("1" 
				    (tx = (tx - 5)) 
				    (rot_strg = "R 1")
				) 
				("2" 
				    (ty = (ty - 5)) 
				    (rot_strg = "R 2")
				) 
				("3" 
				    (tx = (tx + 5)) 
				    (rot_strg = "R 3")
				) 
				(t 
				    (rot_strg = "R 0")
				)
			    ) else 
			    (ty = (ty + 6))
			) 
			(just_str = "J 0") 
			when(just 
			    case(just 
				("1" 
				    (just_str = "J 1")
				) 
				("2" 
				    (just_str = "J 2")
				) 
				("3" 
				    (just_str = "J 3")
				) 
				(t 
				    (just_str = "J 3")
				)
			    )
			) 
			(vis = t)
			when(font 
			    (vis = cadddr(font))
			) 
			(sig_data = list(sig_name tx ty prop_size rot_strg
				vis just_str
			    ))
		    )
		) else
		(trl_altium2hdl_global->exeption = cons(sprintf(nil "   5.6.09 WARNING - Net OWNERPARTID: %L " id) 
			(trl_altium2hdl_global->exeption)
		    ))
	    )
	) sig_data
    )
)
procedure(TRL_ALTIUM2HDL_SCH_Create_Concept_HarnessBus(port sch_name bus_recs pgnr harnessPorts
	schematicPorts adapterPorts
    ) 
    let((id lwidth l_cnt x_val y_val
	    l_points start_x start_y disp_x disp_y
	    x y sig_name net_recs windex
	    poly_sig_name l_coords sig_adapt h_sig_tmp
	) 
	(windex = 1) 
	(net_recs = list()) 
	(h_sig_tmp = list()) 
	unless(sch_name t)
	(net_recs = net_recs) 
	if(bus_recs then 
	    when(adapterPorts 
		foreach(harness adapterPorts 
		    unless(member(upperCase(cadr(harness)) h_sig_tmp) 
			(h_sig_tmp = cons(upperCase(cadr(harness)) h_sig_tmp))
		    )
		)
	    ) 
	    when(schematicPorts 
		foreach(harness schematicPorts 
		    unless(member(upperCase(cadr(harness)) h_sig_tmp) 
			(h_sig_tmp = cons(upperCase(cadr(harness)) h_sig_tmp))
		    )
		)
	    ) 
	    (trl_altium2hdl_global->exeption = cons(sprintf(nil "   5.6.71 INFO    - Start Placing [%L] Harness Buses of Page: %L" 
			length(bus_recs) pgnr
		    ) 
		    (trl_altium2hdl_global->exeption)
		))
	    foreach(rec bus_recs 
		(id = get(rec 
			'OWNERPARTID
		    )) 
		(lwidth = get(rec 
			'LINEWIDTH
		    )) 
		(l_cnt = get(rec 
			'LOCATIONCOUNT
		    ))
		if((id == "-1") then 
		    case(lwidth 
			("1" 
			    (lwidth = 72)
			) 
			("2" 
			    (lwidth = 73)
			) 
			("3" 
			    (lwidth = 73)
			) 
			(t 
			    (lwidth = 72)
			)
		    ) 
		    if(l_cnt then 
			(l_cnt = atoi(l_cnt)) 
			(l_points = list()) 
			(l_coords = list())
			for(index 1 l_cnt 
			    (x_val = stringToSymbol(sprintf(nil "X%d" index))) 
			    (y_val = stringToSymbol(sprintf(nil "Y%d" index)))
			    (x_val = get(rec x_val)) 
			    (y_val = get(rec y_val)) 
			    if(x_val then 
				(x = (atoi(x_val) * 5)) else 
				(x = 0)
			    ) 
			    if(y_val then 
				(y = (atoi(y_val) * 5)) else 
				(y = 0)
			    ) 
			    (l_coords = cons((atoi(x_val):atoi(y_val)) l_coords))
			    (l_points = cons((x:y) l_points))
			) 
			(sig_name = nil) 
			(sig_adapt = nil) 
			prog(nil 
			    when(l_coords 
				when(adapterPorts 
				    foreach(coor l_coords 
					foreach(harness adapterPorts 
					    when((car(harness) == coor) 
						return((sig_adapt = harness))
					    )
					)
				    )
				)
			    )
			) 
			unless(sig_adapt 
			    prog(nil 
				when(l_coords 
				    when(schematicPorts 
					foreach(coor l_coords 
					    foreach(harness schematicPorts 
						when((car(harness) == coor) 
						    return((sig_adapt = harness))
						)
					    )
					)
				    )
				)
			    )
			)
			unless(sig_adapt 
			    prog(nil 
				when(l_coords 
				    when(harnessPorts 
					foreach(coor l_coords 
					    foreach(harness harnessPorts 
						when((car(harness) == coor) 
						    unless(member(upperCase(cadr(harness)) h_sig_tmp) 
							(sig_name = list(caddr(harness) 
								car(coor) 
								cadr(coor) 0.6382979 nil
								nil
							    ))
						    ) 
						    return(sig_name)
						)
					    )
					)
				    )
				)
			    )
			) 
			if(l_points then 
			    (start_x = caar(l_points)) 
			    (start_y = cadar(l_points)) 
			    if((length(l_points) > 2) then 
				foreach(l_coor 
				    cdr(l_points) 
				    (x = car(l_coor)) 
				    (y = cadr(l_coor)) 
				    fprintf(port "WIRE %d -1 (%d %d)(%d %d);\n" lwidth start_x start_y
					x y
				    )
				    unless(sig_adapt 
					when(sig_name 
					    (disp_x = round((abs((x - start_x)) / 2))) 
					    (disp_x = (start_x - disp_x)) 
					    (disp_y = round((abs((y - start_y)) / 2))) 
					    (disp_y = (start_y - disp_y))
					    TRL_ALTIUM2HDL_SCH_Create_Concept_ADD_HarnessNetName(port sig_name disp_x disp_y) 
					    (poly_sig_name = car(sig_name)) 
					    (sig_name = nil)
					)
				    ) 
				    (start_x = x) 
				    (start_y = y)
				) 
				when((axlFormGetField 
					(trl_altium2hdl_global->formid) "verbose"
				    ) 
				    (trl_altium2hdl_global->exeption = cons(sprintf(nil "   5.6.75 INFO    - HARNESS Bus [%4d] Net_Label: %L L-Width: %L => %L L-Cnt: %L -> %L" windex poly_sig_name 
						get(rec 
						    'LINEWIDTH
						)
						lwidth l_cnt l_points
					    ) 
					    (trl_altium2hdl_global->exeption)
					))
				) else
				fprintf(port "WIRE %d -1 (%d %d)(%d %d);\n" lwidth start_x start_y
				    car(cadr(l_points)) 
				    cadr(cadr(l_points))
				) 
				(trl_altium2hdl_global->BusFromTo = cons(list((start_x:start_y) 
					    (car(cadr(l_points)):cadr(cadr(l_points)))
					) 
					(trl_altium2hdl_global->BusFromTo)
				    )) 
				if(sig_name then 
				    unless(sig_adapt 
					(disp_x = round((abs((car(cadr(l_points)) - start_x)) / 2))) 
					(disp_x = (start_x - disp_x)) 
					(disp_y = round((abs((cadr(cadr(l_points)) - start_y)) / 2))) 
					(disp_y = (start_y - disp_y))
					TRL_ALTIUM2HDL_SCH_Create_Concept_ADD_HarnessNetName(port sig_name disp_x disp_y) 
					when((axlFormGetField 
						(trl_altium2hdl_global->formid) "verbose"
					    ) 
					    (trl_altium2hdl_global->exeption = cons(sprintf(nil "   5.6.75 INFO    - HARNESS Bus [%4d] Net_Label: %L L-Width: %L => %L L-Cnt: %L -> %L" windex 
							car(sig_name) 
							get(rec 
							    'LINEWIDTH
							)
							lwidth l_cnt l_points
						    ) 
						    (trl_altium2hdl_global->exeption)
						))
					)
				    ) 
				    (sig_name = nil) else
				    when((axlFormGetField 
					    (trl_altium2hdl_global->formid) "verbose"
					) 
					(trl_altium2hdl_global->exeption = cons(sprintf(nil "   5.6.75 INFO    - HARNESS Bus [%4d] Net_Label: %L L-Width: %L => %L L-Cnt: %L -> %L" windex sig_name 
						    get(rec 
							'LINEWIDTH
						    )
						    lwidth l_cnt l_points
						) 
						(trl_altium2hdl_global->exeption)
					    ))
				    )
				)
			    )
			    else 
			    (trl_altium2hdl_global->exeption = cons(sprintf(nil "-->5.6.77 ERROR   - HARNESS Bus [%4d] No Polygon Data Created: %L on Page: %L" windex rec pgnr) 
				    (trl_altium2hdl_global->exeption)
				))
			) else 
			(trl_altium2hdl_global->exeption = cons(sprintf(nil "   5.6.78 WARNING - HARNESS Bus [%4d] No Polygon Indication: %L on Page: %L" windex rec pgnr) 
				(trl_altium2hdl_global->exeption)
			    ))
		    ) else
		    (trl_altium2hdl_global->exeption = cons(sprintf(nil "   5.6.79 WARNING - HARNESS Bus [%4d] OWNERPARTID: %L on Page: %L" windex id pgnr) 
			    (trl_altium2hdl_global->exeption)
			))
		) 
		windex++
	    ) else 
	    (trl_altium2hdl_global->exeption = cons(sprintf(nil "   5.6.70 INFO    - NO HARNESS Bus Records on Page: %L" pgnr) 
		    (trl_altium2hdl_global->exeption)
		))
	)
    )
)
procedure(TRL_ALTIUM2HDL_SCH_Create_Concept_Harness_Adapter_List() 
    let((harness harness_body blocks_lst record id
	    pin_name port_list Designator harness_lst harness_tmp_lst
	    index block_list
	) 
	(index = 1) 
	(blocks_lst = list()) 
	(harness_lst = list()) 
	(harness_tmp_lst = list())
	when((trl_altium2hdl_global->Harness) 
	    foreach(schematic 
		(trl_altium2hdl_global->Harness) 
		(harness = caddr(schematic)) 
		(harness_body = car(harness)) 
		when(harness_body 
		    (block_list = list()) 
		    foreach(rec harness_body 
			(record = get(rec 
				'RECORD
			    )) 
			if(((record == "215") && block_list) then 
			    (blocks_lst = cons(block_list blocks_lst)) 
			    (block_list = list()) 
			    (block_list = cons(rec block_list))
			    else 
			    (block_list = cons(rec block_list))
			)
		    ) 
		    (blocks_lst = cons(block_list blocks_lst))
		)
	    )
	) 
	when(blocks_lst 
	    foreach(block blocks_lst 
		(port_list = list()) 
		foreach(rec block 
		    (record = get(rec 
			    'RECORD
			)) 
		    (id = get(rec 
			    'OWNERPARTID
			)) 
		    when(((record == "217") && (id == "-1")) 
			(Designator = get(rec 
				'TEXT
			    ))
		    )
		    when(((record == "216") && (id == "-1")) 
			(pin_name = get(rec 
				'NAME
			    )) 
			(port_list = cons(pin_name port_list))
		    )
		) 
		unless(member(Designator harness_tmp_lst) 
		    (harness_lst = reverse(harness_lst)) 
		    (harness_lst = cons(list(Designator port_list) harness_lst)) 
		    (harness_tmp_lst = cons(Designator harness_tmp_lst))
		)
	    )
	) 
	when(harness_lst 
	    (trl_altium2hdl_global->Harness_Adap = harness_lst) 
	    (trl_altium2hdl_global->exeption = cons("-------------------------------------------------------------------------------" 
		    (trl_altium2hdl_global->exeption)
		)) 
	    (trl_altium2hdl_global->exeption = cons(sprintf(nil "   1.1.01 INFO    - [%3d] Harness Adapter found in the Project" 
			length(harness_lst)
		    ) 
		    (trl_altium2hdl_global->exeption)
		)) 
	    foreach(harness_item harness_lst 
		(trl_altium2hdl_global->exeption = cons("                  -------------------------------------------------------------" 
			(trl_altium2hdl_global->exeption)
		    )) 
		(trl_altium2hdl_global->exeption = cons(sprintf(nil "                    [%3d] Harness: [%L] with Pins: [%L]" index 
			    car(harness_item) 
			    cadr(harness_item)
			) 
			(trl_altium2hdl_global->exeption)
		    )) 
		index++
	    )
	)
    )
)
procedure(TRL_ALTIUM2HDL_SCH_Create_Concept_Header(port) 
    let((a) 
	(a = a) 
	fprintf(port "SET COLOR_WIRE YELLOW;\n") 
	fprintf(port "SET COLOR_PROP ORANGE;\n") 
	fprintf(port "SET COLOR_DOT WHITE;\n")
	fprintf(port "SET COLOR_ARC YELLOW;\n") 
	fprintf(port "SET COLOR_BODY GREEN;\n") 
	fprintf(port "SET COLOR_NOTE BLACK;\n") 
	fprintf(port "SET COLOR_NOTE WHITE;\n") 
	fprintf(port "SET PROP_DISPLAY VALUE;\n")
    )
)
procedure(TRL_ALTIUM2HDL_SCH_Create_Concept_PPT_Header(header outport label_data) 
    let((index str part_number part_value part_jedec
	    p_value p_number p_jedec prop1 prop2
	    s_value s_prop1 s_prop2 p_prop1 p_prop2
	    part_name vari
	) 
	(part_name = "XXX") 
	(part_number = upperCase((axlFormGetField 
		    (trl_altium2hdl_global->formid) "part_number_l"
		)
	    )) 
	(part_jedec = upperCase((axlFormGetField 
		    (trl_altium2hdl_global->formid) "part_jedec_l"
		)
	    )) 
	(index = 1)
	when(cadr(label_data) 
	    foreach(label 
		cadr(label_data) 
		case(label 
		    ("VALUE" 
			(s_value = label)
		    ) 
		    ("PROP1" 
			(s_prop1 = label)
		    ) 
		    ("PROP2" 
			(s_prop2 = label)
		    ) 
		    (t 
			printf("--Hier bei Header: %L\n" 
			    cadr(label_data)
			)
		    )
		)
	    )
	) 
	(str = ": PART_NUMBER") 
	when(s_value 
	    (part_value = upperCase((axlFormGetField 
			(trl_altium2hdl_global->formid) "part_value_l"
		    )
		)) 
	    (str = sprintf(nil "%s | %s" str 
		    TRL_ALTIUM2HDL_PCB_Util_Namemaper(part_value)
		))
	) 
	when(s_prop1 
	    (prop1 = upperCase((axlFormGetField 
			(trl_altium2hdl_global->formid) "prop1_l"
		    )
		)) 
	    (str = sprintf(nil "%s | %s" str 
		    TRL_ALTIUM2HDL_PCB_Util_Namemaper(prop1)
		))
	) 
	when(s_prop2 
	    (prop2 = upperCase((axlFormGetField 
			(trl_altium2hdl_global->formid) "prop2_l"
		    )
		)) 
	    (str = sprintf(nil "%s | %s" str 
		    TRL_ALTIUM2HDL_PCB_Util_Namemaper(prop2)
		))
	)
	(str = sprintf(nil "%s = " str)) 
	foreach(v 
	    cdr(header) 
	    (vari = upperCase(v)) 
	    when((vari == part_number) 
		(vari = "PART_NUMBER") 
		(p_number = index)
	    ) 
	    when((vari == part_value) 
		(p_value = index)
	    )
	    when((vari == part_jedec) 
		(vari = "JEDEC_TYPE") 
		(p_jedec = index)
	    ) 
	    when((vari == prop1) 
		(p_prop1 = index)
	    ) 
	    when((vari == prop2) 
		(p_prop2 = index)
	    ) 
	    (str = sprintf(nil "%s%s | " str 
		    TRL_ALTIUM2HDL_PCB_Util_Namemaper(vari)
		)) 
	    index++
	) 
	(str = sprintf(nil "%s;\n" str)) 
	rexCompile("| ;\n") 
	(str = rexReplace(str ";\n" 0))
	fprintf(outport "FILE_TYPE = MULTI_PHYS_TABLE;\n\n") 
	fprintf(outport "PART '%s'\n\n" part_name) 
	fprintf(outport "{========================================================================================}\n") 
	fprintf(outport str) 
	fprintf(outport "{========================================================================================}\n")
	(trl_altium2hdl_global->exeption = cons(sprintf(nil "   3.6.0  INFO    - Symbols MULTI_PHYS_TABLE: %L Created" str) 
		(trl_altium2hdl_global->exeption)
	    )) 
	list(p_number p_value p_jedec p_prop1 p_prop2
	    str
	)
    )
)
procedure(TRL_ALTIUM2HDL_SCH_Create_Concept_SCH(sch_name index multi_page) 
    let((page port cust_vars cel_name wiev_name
	    sym_recs coor lib_ref pgnr sym_i
	    att_ref harnessPorts schematicPorts
	) 
	if(multi_page then 
	    (pgnr = cadr(multi_page)) 
	    (page = sprintf(nil "page%d.csa" pgnr)) 
	    (cel_name = sprintf(nil "%s/%s/worklib/%s" 
		    nth(4 
			(trl_altium2hdl_global->files)
		    ) 
		    nth(5 
			(trl_altium2hdl_global->files)
		    ) 
		    lowerCase(car(multi_page))
		))
	    unless(isDir(cel_name) 
		createDir(cel_name)
	    ) 
	    (wiev_name = strcat(cel_name "/sch_1")) 
	    unless(isDir(wiev_name) 
		createDir(wiev_name)
	    ) 
	    (port = sprintf(nil "%s/%s" wiev_name page)) 
	    (port = outfile(port "w"))
	    else 
	    (pgnr = 1) 
	    (page = sprintf(nil "page%d.csa" pgnr)) 
	    (cel_name = sprintf(nil "%s/%s/worklib/%s" 
		    nth(4 
			(trl_altium2hdl_global->files)
		    ) 
		    nth(5 
			(trl_altium2hdl_global->files)
		    ) 
		    lowerCase(sch_name)
		)) 
	    unless(isDir(cel_name) 
		createDir(cel_name)
	    )
	    (wiev_name = strcat(cel_name "/sch_1")) 
	    unless(isDir(wiev_name) 
		createDir(wiev_name)
	    ) 
	    (port = sprintf(nil "%s/%s" wiev_name page)) 
	    (port = outfile(port "w"))
	) 
	fprintf(port "FILE_TYPE = MACRO_DRAWING;\n") 
	TRL_ALTIUM2HDL_SCH_Create_Concept_Header(port) 
	fprintf(port "SET PAGE_NUMBER P%d;\n" pgnr)
	(trl_altium2hdl_global->exeption = cons("*******************************************************************************" 
		(trl_altium2hdl_global->exeption)
	    )) 
	(trl_altium2hdl_global->exeption = cons(sprintf(nil "   5.1.02 INFO    - SCH: [%4d] Start of Page: %L Nr.: %L" index sch_name pgnr) 
		(trl_altium2hdl_global->exeption)
	    )) 
	(cust_vars = TRL_ALTIUM2HDL_SCH_Create_FrameSymbol(port sch_name pgnr)) 
	TRL_ALTIUM2HDL_SCH_Create_NoteBox(port sch_name pgnr) 
	(harnessPorts = list())
	(harnessPorts = TRL_ALTIUM2HDL_SCH_Create_Concept_ADD_Block(port sch_name pgnr)) 
	(schematicPorts = list()) 
	(schematicPorts = TRL_ALTIUM2HDL_SCH_Create_Concept_ADD_SupportSymbol_Port(port sch_name pgnr schematicPorts)) 
	TRL_ALTIUM2HDL_SCH_Create_Concept_ADD_Harness(port sch_name pgnr harnessPorts schematicPorts) 
	TRL_ALTIUM2HDL_SCH_Create_Concept_ADD_Wires(port sch_name pgnr)
	TRL_ALTIUM2HDL_SCH_Create_Concept_ADD_Buses(port sch_name pgnr) 
	TRL_ALTIUM2HDL_SCH_Create_Concept_ADD_Dots(port sch_name pgnr) 
	TRL_ALTIUM2HDL_SCH_Create_Concept_ADD_SupportSymbol_Power_Port(port sch_name pgnr) 
	TRL_ALTIUM2HDL_SCH_Create_Concept_ADD_SupportSymbol_OffPage(port sch_name) 
	TRL_ALTIUM2HDL_SCH_Create_Concept_ADD_LinesLocCNT(port sch_name pgnr)
	TRL_ALTIUM2HDL_SCH_Create_Concept_ADD_Rectangle(port sch_name pgnr) 
	TRL_ALTIUM2HDL_SCH_Create_Concept_ADD_Note(port sch_name pgnr cust_vars) 
	foreach(data 
	    (trl_altium2hdl_global->SchRawList) 
	    when((car(data) == sch_name) 
		(sym_recs = cadddr(data))
	    )
	) 
	if(sym_recs then 
	    (trl_altium2hdl_global->exeption = cons(sprintf(nil "   5.1.02 INFO    - Parts: [%4d] Start of Parts Placement" 
			length(sym_recs)
		    ) 
		    (trl_altium2hdl_global->exeption)
		)) 
	    (trl_altium2hdl_global->exeption = cons("                    -----------------------------------------------------------" 
		    (trl_altium2hdl_global->exeption)
		)) 
	    (sym_i = 1)
	    foreach(sym sym_recs 
		when((axlFormGetField 
			(trl_altium2hdl_global->formid) "verbose"
		    ) 
		    (trl_altium2hdl_global->exeption = cons("                    -----------------------------------------------------------" 
			    (trl_altium2hdl_global->exeption)
			))
		) 
		(coor = TRL_ALTIUM2HDL_SCH_Create_Concept_ADD_Part(port sym sym_i)) 
		(lib_ref = list())
		when(coor 
		    (lib_ref = cadr(coor)) 
		    (att_ref = caddr(coor)) 
		    (coor = car(coor))
		) 
		when(lib_ref t) 
		when(lib_ref 
		    TRL_ALTIUM2HDL_SCH_Create_Concept_ADD_Symbol_RefDes(port sym coor lib_ref) 
		    if(att_ref then 
			TRL_ALTIUM2HDL_SCH_Create_Concept_ADD_Symbol_RefAttributes(port sym coor lib_ref att_ref) else 
			TRL_ALTIUM2HDL_SCH_Create_Concept_ADD_Symbol_Comment(port sym coor lib_ref)
			TRL_ALTIUM2HDL_SCH_Create_Concept_ADD_Symbol_Attributes(port sym coor lib_ref)
		    )
		) 
		sym_i++
	    ) else t
	) 
	fprintf(port "QUIT\n")
	close(port) 
	when(isFile(strcat(wiev_name "/page1.csb")) 
	    deleteFile(strcat(wiev_name "/page1.csb"))
	)
    )
)
procedure(TRL_ALTIUM2HDL_SCH_Create_Concept_Schematic() 
    let((sch_name index page_nr) 
	TRL_ALTIUM2HDL_SCH_Create_Concept_Find_BUS_Names() 
	(index = 1) 
	(trl_altium2hdl_global->exeption = cons("*******************************************************************************" 
		(trl_altium2hdl_global->exeption)
	    )) 
	(trl_altium2hdl_global->exeption = cons(sprintf(nil "   5.1.00 INFO    - Start to process Project Schematics") 
		(trl_altium2hdl_global->exeption)
	    ))
	(trl_altium2hdl_global->exeption = cons("*******************************************************************************" 
		(trl_altium2hdl_global->exeption)
	    )) 
	when((trl_altium2hdl_global->PRJRawList) 
	    foreach(design_str 
		(trl_altium2hdl_global->PRJRawList) 
		foreach(page design_str 
		    (sch_name = car(page)) 
		    (page_nr = cadr(page)) 
		    if((type(page_nr) == 'fixnum) then 
			TRL_ALTIUM2HDL_SCH_Create_Concept_SCH(sch_name index 
			    list(caaar((trl_altium2hdl_global->PRJRawList)) page_nr)
			) else 
			TRL_ALTIUM2HDL_SCH_Create_Concept_SCH(sch_name index nil)
		    )
		) 
		index++
	    )
	) 
	(trl_altium2hdl_global->exeption = cons("*******************************************************************************" 
		(trl_altium2hdl_global->exeption)
	    )) 
	(trl_altium2hdl_global->exeption = cons(sprintf(nil "   5.1.00 INFO    - END to process %L Project Schematics" index) 
		(trl_altium2hdl_global->exeption)
	    )) 
	(trl_altium2hdl_global->exeption = cons("*******************************************************************************" 
		(trl_altium2hdl_global->exeption)
	    ))
    )
)
procedure(TRL_ALTIUM2HDL_SCH_Create_CustomText(port sch_name) 
    let((params prop_val prop_n cust_vars c_var
	    cust_vari cpm_file prop_name hidden owner_ind
	    owner_id font_id just lx ly
	    proj_dir var_file prop_size slash2backslash
	) 
	(slash2backslash = lambda((str) 
		let((arr index new_str) 
		    (arr = parseString(str "/")) 
		    (index = 1) 
		    (new_str = "") 
		    foreach(p arr 
			if(onep(index) then 
			    (new_str = sprintf(nil "%s%s" new_str p)) else 
			    (new_str = sprintf(nil "%s\\%s" new_str p))
			) 
			(index = (index + 1))
		    )
		    new_str
		)
	    )) 
	foreach(data 
	    (trl_altium2hdl_global->SchRawList) 
	    when((car(data) == sch_name) 
		(params = caddr(data))
	    )
	) 
	(cust_vars = ncons(nil)) 
	foreach(rec params 
	    (prop_val = get(rec 
		    'TEXT
		)) 
	    (prop_n = get(rec 
		    'NAME
		)) 
	    when((prop_val && prop_n) 
		putprop(cust_vars prop_val 
		    stringToSymbol(prop_n)
		)
	    )
	)
	when(cust_vars 
	    (proj_dir = nth(4 
		    (trl_altium2hdl_global->files)
		)) 
	    (proj_dir = strcat(proj_dir "/" 
		    nth(5 
			(trl_altium2hdl_global->files)
		    )
		)) 
	    (cust_vari = strcat(proj_dir "/cust_vari")) 
	    (cust_vari = outfile(cust_vari))
	    fprintf(cust_vari "\nSTART_CUSTOMVAR\n") 
	    foreach(var 
		(cust_vars->?) 
		fprintf(cust_vari "%s '%s'\n" var 
		    get(cust_vars var)
		)
	    ) 
	    fprintf(cust_vari "END_CUSTOMVAR\n") 
	    close(cust_vari) 
	    (cpm_file = funcall(slash2backslash 
		    strcat(proj_dir "/" 
			nth(4 
			    (trl_altium2hdl_global->files)
			) ".cpm"
		    )
		))
	    (var_file = funcall(slash2backslash 
		    strcat(proj_dir "/cust_vari")
		)) 
	    sh(sprintf(nil "copy /B %s + %s tmp_out" cpm_file var_file)) 
	    sh(sprintf(nil "move /y tmp_out %s" cpm_file))
	) 
	foreach(rec params 
	    (prop_val = get(rec 
		    'TEXT
		)) 
	    (prop_n = get(rec 
		    'NAME
		)) 
	    (hidden = get(rec 
		    'ISHIDDEN
		))
	    (owner_ind = get(rec 
		    'OWNERINDEX
		)) 
	    (owner_id = get(rec 
		    'OWNERPARTID
		)) 
	    (font_id = get(rec 
		    'FONTID
		)) 
	    (just = get(rec 
		    'JUSTIFICATION
		)) 
	    (lx = get(rec 
		    'LOCATION\.X
		))
	    (ly = get(rec 
		    'LOCATION\.Y
		)) 
	    when(prop_val 
		unless(prop_n 
		    (c_var = get(cust_vars 
			    stringToSymbol(prop_val)
			)) 
		    when(c_var 
			(prop_name = prop_val) 
			when(prop_name 
			    when(font_id 
				(prop_size = TRL_ALTIUM2HDL_SCH_Util_Font_ID(font_id)) 
				(prop_size = (car(prop_size) / 47.0))
			    ) 
			    unless(prop_size 
				(prop_size = 0.82)
			    ) 
			    if((lx && ly) then 
				(lx = (atoi(lx) * 5)) 
				(ly = (atoi(ly) * 5)) 
				fprintf(port "FORCEPROP 2 LAST %s <%s>\n" prop_name prop_val)
				(trl_altium2hdl_global->exeption = cons(sprintf(nil "   3.9.02 INFO    - Placing Label: %L = %L" prop_name prop_val) 
					(trl_altium2hdl_global->exeption)
				    )) 
				fprintf(port "(%d %d);\n" lx ly) 
				fprintf(port "DISPLAY %f (%d %d);\n" prop_size lx ly) 
				when(hidden 
				    fprintf(port "DISPLAY INVISIBLE (%d %d);\n" lx ly)
				) else
				printf("-->??SYMLABEL?? %L %L %L %L %L %L %L %L %L \n" prop_val prop_name hidden owner_ind
				    owner_id font_id just lx ly
				)
			    )
			)
		    )
		)
	    )
	) cust_vars
    )
)
procedure(TRL_ALTIUM2HDL_SCH_Create_FrameSymbol(port sch_name page_nr) 
    let((lib_name sym_name cell_name view_name outPort
	    cust_vars
	) 
	(trl_altium2hdl_global->exeption = cons("                  -------------------------------------------------------------" 
		(trl_altium2hdl_global->exeption)
	    )) 
	(lib_name = nth(4 
		(trl_altium2hdl_global->files)
	    )) 
	(lib_name = strcat(lib_name "/" 
		nth(5 
		    (trl_altium2hdl_global->files)
		)
	    )) 
	(lib_name = strcat(lib_name "/" 
		nth(7 
		    (trl_altium2hdl_global->files)
		)
	    ))
	if(lib_name then 
	    unless(isDir(lib_name) 
		createDir(lib_name)
	    ) 
	    (sym_name = sprintf(nil "FRAME_%s_%d" sch_name page_nr)) 
	    (sym_name = lowerCase(sym_name))
	    (cell_name = strcat(lib_name "/" sym_name)) 
	    unless(isDir(cell_name) 
		createDir(cell_name)
	    ) 
	    (view_name = strcat(cell_name "/" "sym_1")) 
	    unless(isDir(view_name) 
		createDir(view_name)
	    ) 
	    (trl_altium2hdl_global->exeption = cons(sprintf(nil "-->3.9.02 INFO    - HDL FrameSymbol: %L Library NAme: %L!" sym_name lib_name) 
		    (trl_altium2hdl_global->exeption)
		))
	    TRL_ALTIUM2HDL_Create_Concept_View_Tag(view_name "symbol.css") 
	    (outPort = outfile(strcat(view_name "/symbol.css"))) 
	    TRL_ALTIUM2HDL_SCH_Create_SheetFrame(outPort sch_name) 
	    close(outPort) 
	    fprintf(port "FORCEADD %s\n" sym_name)
	    fprintf(port "(%d %d);\n" 0 0) 
	    fprintf(port "FORCEPROP 0 LAST PAGE_NAME %s\n" sch_name) 
	    fprintf(port "J 0\n") 
	    fprintf(port "(0 0);\n") 
	    fprintf(port "DISPLAY 1.021277 (0 0);\n")
	    fprintf(port "PAINT BLUE (0 0);\n") 
	    fprintf(port "DISPLAY INVISIBLE (0 0);\n") 
	    (cust_vars = TRL_ALTIUM2HDL_SCH_Create_CustomText(port sch_name)) else 
	    (trl_altium2hdl_global->exeption = cons(sprintf(nil "-->3.9.03 ERROR   - HDL Library Name: %L!" lib_name) 
		    (trl_altium2hdl_global->exeption)
		))
	    printf("-->ERROR %L\n" lib_name)
	) cust_vars
    )
)
procedure(TRL_ALTIUM2HDL_SCH_Create_HarnessSymbol(block_name block_data refdes_data file_data port_list
	org_name harnessPorts
    ) 
    let((lib_name cell_name view_name outPort size_x
	    size_y side x y pin_name
	    pin_side pin_stap pin_styl t_size io_type
	    image_path cmd_str type primp adapter_pins
	    new_adapter_pin adapter_pin_index common_pin harness_X harness_Y
	    harness_S
	) 
	unless(file_data t) 
	unless(refdes_data t) 
	when((axlFormGetField 
		(trl_altium2hdl_global->formid) "verbose"
	    ) 
	    (trl_altium2hdl_global->exeption = cons("                  -------------------------------------------------------------" 
		    (trl_altium2hdl_global->exeption)
		)) 
	    (trl_altium2hdl_global->exeption = cons(sprintf(nil "   3.8.33 INFO    - Start to Create HARNESS Symbols: %L" block_name) 
		    (trl_altium2hdl_global->exeption)
		))
	) 
	(lib_name = nth(4 
		(trl_altium2hdl_global->files)
	    ))
	(lib_name = strcat(lib_name "/" 
		nth(5 
		    (trl_altium2hdl_global->files)
		)
	    )) 
	(lib_name = strcat(lib_name "/worklib")) 
	if(lib_name then 
	    unless(isDir(lib_name) 
		createDir(lib_name)
	    ) 
	    (cell_name = strcat(lib_name "/" block_name)) 
	    unless(isDir(cell_name) 
		createDir(cell_name)
	    )
	    (view_name = strcat(cell_name "/" "images")) 
	    unless(isDir(view_name) 
		createDir(view_name)
	    ) 
	    (image_path = nth(4 
		    (trl_altium2hdl_global->files)
		)) 
	    (image_path = strcat(image_path "/" 
		    nth(5 
			(trl_altium2hdl_global->files)
		    )
		)) 
	    (image_path = strcat(image_path "/images"))
	    (axlOSFileCopy 
		strcat(image_path "/harness_body.jpg") 
		strcat(view_name "/harness_body.jpg") nil
	    ) 
	    (view_name = strcat(cell_name "/" "sym_1")) 
	    unless(isDir(view_name) 
		createDir(view_name)
	    ) 
	    TRL_ALTIUM2HDL_Create_Concept_View_Tag(view_name "symbol.css") 
	    (outPort = outfile(strcat(view_name "/symbol.css")))
	    (size_x = get(block_data 
		    'XSIZE
		)) 
	    (size_y = get(block_data 
		    'YSIZE
		)) 
	    (x = get(block_data 
		    'LOCATION\.X
		)) 
	    (y = get(block_data 
		    'LOCATION\.Y
		)) 
	    (primp = get(block_data 
		    'PRIMARYCONNECTIONPOSITION
		))
	    (side = get(block_data 
		    'HARNESSCONNECTORSIDE
		)) 
	    (common_pin = "XYZ") 
	    unless(side 
		(side = "0")
	    ) 
	    (harness_X = atoi(x)) 
	    (harness_Y = atoi(y))
	    (harness_S = atoi(primp)) 
	    when((side == "0") 
		(harness_Y = (harness_Y - harness_S))
	    ) 
	    when((side == "1") 
		(harness_X = (harness_X + atoi(size_x))) 
		(harness_Y = (harness_Y - harness_S))
	    ) 
	    when((side == "2") 
		(harness_X = (harness_X + harness_S))
	    ) 
	    when((side == "3") 
		(harness_X = (harness_X + atoi(size_x))) 
		(harness_Y = (harness_Y - atoi(size_y)))
	    )
	    (harnessPorts = cons(list((harness_X:harness_Y) org_name) harnessPorts)) 
	    (size_x = (atoi(size_x) * 5)) 
	    (size_y = (atoi(size_y) * 5)) 
	    (primp = (atoi(primp) * 5)) 
	    fprintf(outPort "C 0 %d %L -100 0 0 1 41 0 L\n" 
		(- primp) common_pin
	    )
	    fprintf(outPort "L 0 %d 50 %d -1 16\n" 
		(primp * -1) 
		(primp * -1)
	    ) 
	    fprintf(outPort "L 50 0 50 %d -1 16\n" 
		(size_y * -1)
	    ) 
	    fprintf(outPort "L 50 0 100 0 -1 16\n") 
	    fprintf(outPort "L  50 %d 100 %d -1 16\n" 
		(size_y * -1) 
		(size_y * -1)
	    ) 
	    foreach(pin port_list 
		(new_adapter_pin = nil) 
		(pin_name = get(pin 
			'NAME
		    )) 
		(pin_side = get(pin 
			'SIDE
		    ))
		(pin_stap = get(pin 
			'DISTANCEFROMTOP
		    )) 
		(pin_styl = get(pin 
			'STYLE
		    )) 
		(io_type = get(pin 
			'IOTYPE
		    )) 
		unless(pin_styl 
		    (pin_styl = "0")
		) 
		unless(io_type 
		    (io_type = "0")
		)
		unless(pin_side 
		    (pin_side = "1")
		) 
		case(io_type 
		    ("0" 
			case(pin_styl 
			    ("0" 
				(type = "IN")
			    ) 
			    ("1" 
				(type = "IN")
			    ) 
			    ("2" 
				(type = "OUT")
			    ) 
			    ("3" 
				(type = "INOUT")
			    )
			    ("4" 
				(type = "IN")
			    ) 
			    ("5" 
				(type = "IN")
			    ) 
			    ("6" 
				(type = "OUT")
			    ) 
			    ("7" 
				(type = "INOUT")
			    ) 
			    (t 
				(type = "IN") 
				printf("--IOTYPE: %L Style: %L\n" io_type pin_styl)
			    )
			)
		    ) 
		    ("1" 
			(type = "IN")
		    ) 
		    ("2" 
			(type = "OUT")
		    ) 
		    ("3" 
			(type = "INOUT")
		    )
		    (t 
			(type = "IN") 
			printf("--IOTYPE: %L\n" io_type)
		    )
		) 
		(type = "INOUT") 
		foreach(adapter 
		    (trl_altium2hdl_global->Harness_Adap) 
		    when((car(adapter) == org_name) 
			(adapter_pins = cadr(adapter))
		    )
		) 
		(adapter_pin_index = 1)
		foreach(a_pin adapter_pins 
		    when((upperCase(a_pin) == upperCase(pin_name)) 
			(new_adapter_pin = sprintf(nil "%d" adapter_pin_index))
		    ) 
		    adapter_pin_index++
		) 
		unless(new_adapter_pin 
		    (new_adapter_pin = TRL_ALTIUM2HDL_PCB_Util_Signal_Namemaper(pin_name))
		) 
		if(pin_stap then 
		    (pin_stap = (atoi(pin_stap) * 50)) else 
		    (pin_stap = 0)
		) 
		(t_size = 32) 
		case(pin_side 
		    ("0" 
			fprintf(outPort "C 0 %d %L -100 0 0 1 41 0 L\n" 
			    (- pin_stap) new_adapter_pin
			) 
			fprintf(outPort "X \"PIN_TEXT\" %L 100 %d 0.00 0.00 %d 0 0 0 0 0 1 0 70\n" pin_name 
			    ((- pin_stap) - 16) t_size
			) 
			fprintf(outPort "X \"VHDL_MODE\" %L 100 %d 0.00 0.00 %d 0 0 0 0 0 0 0 126\n" type 
			    ((- pin_stap) - 18) t_size
			) 
			fprintf(outPort "X \"VHDL_SCALAR_TYPE\" \"std_logic\" 100 %d 0.00 0.00 %d 0 0 0 0 0 0 0 126\n" 
			    ((- pin_stap) - 18) t_size
			)
		    ) 
		    ("1" 
			fprintf(outPort "C %d %d %L -100 0 0 1 41 0 L\n" size_x 
			    (- pin_stap) new_adapter_pin
			) 
			fprintf(outPort "X \"PIN_TEXT\" %L %d %d 0.00 0.00 %d 0 0 2 0 0 1 0 70\n" pin_name 
			    (size_x - 10) 
			    ((- pin_stap) - 16)
			    t_size
			) 
			fprintf(outPort "X \"VHDL_MODE\" %L %d %d 0.00 0.00 %d 0 0 0 0 0 0 0 126\n" type 
			    (size_x - 100) 
			    ((- pin_stap) - 18)
			    t_size
			) 
			fprintf(outPort "X \"VHDL_SCALAR_TYPE\" \"std_logic\" %d %d 0.00 0.00 %d 0 0 0 0 0 0 0 126\n" 
			    (size_x - 100) 
			    ((- pin_stap) - 18) t_size
			)
		    ) 
		    ("2" 
			fprintf(outPort "C %d 0 %L -100 0 0 1 41 0 L\n" pin_stap new_adapter_pin) 
			fprintf(outPort "X \"PIN_TEXT\" %L %d -100 90.00 0.00 %d 0 0 2 0 0 1 0 70\n" pin_name 
			    (pin_stap + 16) t_size
			) 
			fprintf(outPort "X \"VHDL_MODE\" %L %d -100 90.00 0.00 %d 0 0 0 0 0 0 0 126\n" type 
			    (pin_stap + 18) t_size
			) 
			fprintf(outPort "X \"VHDL_SCALAR_TYPE\" \"std_logic\" %d -100 90.00 0.00 %d 0 0 0 0 0 0 0 126\n" 
			    (pin_stap + 18) t_size
			)
		    ) 
		    ("3" 
			fprintf(outPort "C %d %d %L -100 0 0 1 41 0 L\n" pin_stap 
			    (- size_y) new_adapter_pin
			) 
			fprintf(outPort "X \"PIN_TEXT\" %L %d %d 90.00 0.00 %d 0 0 0 0 0 1 0 70\n" pin_name 
			    (pin_stap + 16) 
			    ((- size_y) + 100)
			    t_size
			) 
			fprintf(outPort "X \"VHDL_MODE\" %L %d %d 90.00 0.00 %d 0 0 0 0 0 0 0 126\n" type 
			    (pin_stap + 18) 
			    ((- size_y) + 100)
			    t_size
			) 
			fprintf(outPort "X \"VHDL_SCALAR_TYPE\" \"std_logic\" %d %d 90.00 0.00 %d 0 0 0 0 0 0 0 126\n" 
			    (pin_stap + 18) 
			    ((- size_y) + 100) t_size
			)
			printf("---XXX3-> %L %L %L %L %L\n" pin_stap 
			    ((- size_y) + 80) pin_side pin_styl
			    io_type
			)
		    )
		    (t)
		)
	    )
	    fprintf(outPort "P \"LIBRARY1\" \"ieee\" 0 0 0.00 0.00 20 0 0 0 0 0 0 0 72\n") 
	    fprintf(outPort "P \"USE1\" \"ieee.std_logic_1164.all\" 0 0 0.00 0.00 20 0 0 0 0 0 0 0 72\n") 
	    fprintf(outPort "P \"USE2\" \"work.all\" 0 0 0.00 0.00 20 0 0 0 0 0 0 0 72\n") 
	    fprintf(outPort "P \"BLOCK\" \"TRUE\" 0 0 0.00 0.00 47 0 0 1 0 0 0 0 32\n") 
	    fprintf(outPort "P \"HDL_CONCAT\" \"TRUE\" 0 0 0.00 0.00 47 0 0 1 0 0 0 0 32\n")
	    fprintf(outPort "P \"PATH\" \"?\" 0 0 0.00 0.00 47 0 0 1 0 0 0 0 32\n") 
	    (size_x = (size_x - 50)) 
	    fprintf(outPort "T %d %d 0.00 0.00 47 0 0 1 0 30 0\n" 
		((size_x / 2) + 50) 
		((- size_y) / 2)
	    ) 
	    fprintf(outPort "$CDS_IMAGE|harness_body.jpg|%d|%d\n" size_x size_y) 
	    close(outPort)
	    (cmd_str = "newgenasym") 
	    (cmd_str = sprintf(nil "%s -i %s" cmd_str cell_name)) 
	    (cmd_str = sprintf(nil "%s -n %s -M > log_run.txt 2>&1" cmd_str block_name)) 
	    sh(cmd_str) else
	    (trl_altium2hdl_global->exeption = cons(sprintf(nil "-->3.8.03 ERROR   - HDL Library Name: %L!" lib_name) 
		    (trl_altium2hdl_global->exeption)
		)) 
	    printf("-->ERROR %L\n" lib_name)
	) harnessPorts
    )
)
procedure(TRL_ALTIUM2HDL_SCH_Create_NoteBox(port sch_name pgnr) 
    let((sup_recs note_box id fontid wordwrap
	    text loc_x loc_y cor_x cor_y
	    lib_name image_path index cell_name view_name
	    outPort text_box_name font_size
	) 
	unless(pgnr t) 
	foreach(data 
	    (trl_altium2hdl_global->Graphic) 
	    when((car(data) == sch_name) 
		(sup_recs = caddr(data)) 
		(note_box = nth(11 sup_recs))
	    )
	) 
	when(note_box 
	    (trl_altium2hdl_global->exeption = cons("-------------------------------------------------------------------------------" 
		    (trl_altium2hdl_global->exeption)
		)) 
	    (trl_altium2hdl_global->exeption = cons("   3.4.3  INFO    - Start to Create Note Box.." 
		    (trl_altium2hdl_global->exeption)
		)) 
	    (index = 1) 
	    foreach(rec note_box 
		(id = get(rec 
			'OWNERPARTID
		    )) 
		when((id == "-1") 
		    (fontid = get(rec 
			    'FONTID
			)) 
		    (wordwrap = get(rec 
			    'WORDWRAP
			)) 
		    (text = get(rec 
			    'TEXT
			)) 
		    (loc_x = get(rec 
			    'LOCATION\.X
			))
		    (loc_y = get(rec 
			    'LOCATION\.Y
			)) 
		    (cor_x = get(rec 
			    'CORNER\.X
			)) 
		    (cor_y = get(rec 
			    'CORNER\.Y
			)) 
		    when((loc_x && loc_y && cor_x && cor_y) 
			(loc_x = (atoi(loc_x) * 5)) 
			(loc_y = (atoi(loc_y) * 5)) 
			(cor_x = (atoi(cor_x) * 5)) 
			(cor_y = (atoi(cor_y) * 5))
			nth(4 
			    (trl_altium2hdl_global->files)
			) 
			(lib_name = nth(4 
				(trl_altium2hdl_global->files)
			    )) 
			(lib_name = strcat(lib_name "/" 
				nth(5 
				    (trl_altium2hdl_global->files)
				)
			    )) 
			(lib_name = strcat(lib_name "/" 
				nth(7 
				    (trl_altium2hdl_global->files)
				)
			    )) 
			(image_path = nth(4 
				(trl_altium2hdl_global->files)
			    ))
			(image_path = strcat(image_path "/" 
				nth(5 
				    (trl_altium2hdl_global->files)
				)
			    )) 
			(image_path = strcat(image_path "/images")) 
			if(lib_name then 
			    unless(isDir(lib_name) 
				createDir(lib_name)
			    ) 
			    (text_box_name = sprintf(nil "TEXT_BOX_%s_%d" 
				    upperCase(sch_name) index
				)) 
			    (text_box_name = lowerCase(text_box_name))
			    (cell_name = strcat(lib_name "/" text_box_name)) 
			    unless(isDir(cell_name) 
				createDir(cell_name)
			    ) 
			    (view_name = strcat(cell_name "/" "sym_1")) 
			    unless(isDir(view_name) 
				createDir(view_name)
			    ) 
			    unless(isDir(strcat(cell_name "/" "images")) 
				createDir(strcat(cell_name "/" "images"))
			    )
			    TRL_ALTIUM2HDL_Create_Concept_View_Tag(view_name "symbol.css") 
			    (outPort = outfile(strcat(view_name "/symbol.css"))) 
			    fprintf(outPort "L 0 0 0 %d -1 16\n" 
				(cor_y - loc_y)
			    ) 
			    fprintf(outPort "L 0 %d %d %d -1 16\n" 
				(cor_y - loc_y) 
				(cor_x - loc_x) 
				(cor_y - loc_y)
			    ) 
			    fprintf(outPort "L %d %d %d 50 -1 16\n" 
				(cor_x - loc_x) 
				(cor_y - loc_y) 
				(cor_x - loc_x)
			    )
			    fprintf(outPort "L %d 0 0 0 -1 16\n" 
				(cor_x - loc_x - 50)
			    ) 
			    (axlOSFileCopy 
				strcat(image_path "/text_lower_end1.jpg") 
				strcat(cell_name "/images/text_lower_end1.jpg") nil
			    ) 
			    fprintf(outPort "T %d %d 0.00 0.00 47 0 0 1 0 28 0\n" 
				(cor_x - loc_x) 0
			    ) 
			    fprintf(outPort "$CDS_IMAGE|text_lower_end1.jpg|100|100\n") 
			    (axlOSFileCopy 
				strcat(image_path "/text_rand.jpg") 
				strcat(cell_name "/images/text_randu.jpg") nil
			    )
			    fprintf(outPort "T %d %d 0.00 0.00 47 0 0 1 0 28 0\n" 
				(((cor_x - loc_x) / 2) - 14) -6
			    ) 
			    fprintf(outPort "$CDS_IMAGE|text_randu.jpg|%d|12\n" 
				(cor_x - loc_x - 60)
			    ) 
			    (axlOSFileCopy 
				strcat(image_path "/text_rand.jpg") 
				strcat(cell_name "/images/text_randr.jpg") nil
			    ) 
			    fprintf(outPort "T %d %d 0.00 0.00 47 0 0 1 0 28 0\n" 
				((cor_x - loc_x) + 6) 
				(((cor_y - loc_y) / 2) + 6)
			    ) 
			    fprintf(outPort "$CDS_IMAGE|text_randr.jpg|12|%d\n" 
				(cor_y - loc_y - 60)
			    )
			    (axlOSFileCopy 
				strcat(image_path "/text_upper_left.jpg") 
				strcat(cell_name "/images/text_upper_left.jpg") nil
			    ) 
			    fprintf(outPort "T 25 %d 0.00 0.00 47 0 0 1 0 28 0\n" 
				(cor_y - loc_y - 25)
			    ) 
			    fprintf(outPort "$CDS_IMAGE|text_upper_left.jpg|50|50\n") 
			    (axlOSFileCopy 
				strcat(image_path "/text_body.jpg") 
				strcat(cell_name "/images/text_body.jpg") nil
			    ) 
			    fprintf(outPort "T %d %d 0.00 0.00 47 0 0 1 0 28 0\n" 
				round(((cor_x - loc_x) / 2)) 
				round(((cor_y - loc_y) / 2))
			    )
			    fprintf(outPort "$CDS_IMAGE|text_body.jpg|%d|%d\n" 
				abs((cor_x - loc_x)) 
				abs((cor_y - loc_y))
			    ) 
			    (font_size = car(TRL_ALTIUM2HDL_SCH_Util_Font_ID(fontid))) 
			    if((wordwrap == "T") then 
				fprintf(outPort "P \"TEXT_LINE_1\" %L 50 %d 0.00 0.00 %d 0 0 0 0 0 1 0 0\n" text 
				    (cor_y - loc_y - 50) font_size
				) else t
			    ) 
			    fprintf(outPort "P \"COMMENT_BODY\" \"TRUE\" 50 375 0.00 0.00 48 0 0 0 0 0 1 0 8\n") 
			    close(outPort)
			    fprintf(port "FORCEADD %s..1\n" text_box_name) 
			    fprintf(port "(%d %d);\n" loc_x loc_y) 
			    index++ else t
			)
		    )
		)
	    )
	)
    )
)
procedure(TRL_ALTIUM2HDL_SCH_Create_PortSymbol(port_name orient type width) 
    let((lib_name cell_name view_name outPort image_path
	    io_type
	) 
	when((axlFormGetField 
		(trl_altium2hdl_global->formid) "verbose"
	    ) 
	    (trl_altium2hdl_global->exeption = cons("-------------------------------------------------------------------------------" 
		    (trl_altium2hdl_global->exeption)
		)) 
	    (trl_altium2hdl_global->exeption = cons("   3.9.3  INFO    - Start to Create Port Symbols.." 
		    (trl_altium2hdl_global->exeption)
		))
	) 
	(lib_name = nth(4 
		(trl_altium2hdl_global->files)
	    )) 
	(lib_name = strcat(lib_name "/" 
		nth(5 
		    (trl_altium2hdl_global->files)
		)
	    )) 
	(lib_name = strcat(lib_name "/" 
		nth(7 
		    (trl_altium2hdl_global->files)
		)
	    ))
	(image_path = nth(4 
		(trl_altium2hdl_global->files)
	    )) 
	(image_path = strcat(image_path "/" 
		nth(5 
		    (trl_altium2hdl_global->files)
		)
	    )) 
	(image_path = strcat(image_path "/images")) 
	if(lib_name then 
	    when((axlFormGetField 
		    (trl_altium2hdl_global->formid) "verbose"
		) 
		(trl_altium2hdl_global->exeption = cons(sprintf(nil "-->3.9.31 INFO    - HDL Library Name: %L!" lib_name) 
			(trl_altium2hdl_global->exeption)
		    ))
	    ) 
	    unless(isDir(lib_name) 
		createDir(lib_name)
	    ) 
	    (cell_name = strcat(lib_name "/" port_name))
	    (cell_name = lowerCase(cell_name)) 
	    unless(isDir(cell_name) 
		createDir(cell_name)
	    ) 
	    (view_name = strcat(cell_name "/" "sym_1")) 
	    unless(isDir(view_name) 
		createDir(view_name)
	    ) 
	    unless(isDir(strcat(cell_name "/" "images")) 
		createDir(strcat(cell_name "/" "images"))
	    )
	    (axlOSFileCopy 
		strcat(image_path "/port_body.jpg") 
		strcat(cell_name "/images/port_body.jpg") nil
	    ) 
	    TRL_ALTIUM2HDL_Create_Concept_View_Tag(view_name "symbol.css") 
	    (outPort = outfile(strcat(view_name "/symbol.css"))) 
	    (width = (atoi(width) * 5)) 
	    (io_type = "INOUT")
	    if((orient == "HORI") then 
		fprintf(outPort "C -50 0 \"A\" -100 0 0 1 41 0 L\n") 
		fprintf(outPort "X \"VHDL_PORT\" %L -35 -70 0.00 0.00 41 0 0 0 0 0 0 0 80\n" io_type) 
		fprintf(outPort "X \"HDL_PORT\" %L 325 -125 0.00 0.00 41 0 0 0 0 0 0 0 32\n" io_type)
		fprintf(outPort "C %d 0 \"A\" %d 0 0 1 41 0 L\n" 
		    (width - 50) width
		) 
		fprintf(outPort "X \"VHDL_PORT\" %L -35 -70 0.00 0.00 41 0 0 0 0 0 0 0 80\n" io_type) 
		fprintf(outPort "X \"HDL_PORT\" %L 325 -125 0.00 0.00 41 0 0 0 0 0 0 0 32\n" io_type) 
		if((type == "INOUT") then 
		    fprintf(outPort "L -50 0 -25 25 -1 16\n") 
		    fprintf(outPort "L -50 0 -25 -25 -1 16\n") 
		    fprintf(outPort "L -25 25 %d 25 -1 16\n" 
			(width - 75)
		    )
		    fprintf(outPort "L -25 -25 %d -25 -1 16\n" 
			(width - 75)
		    ) 
		    fprintf(outPort "L %d 25 %d 0 -1 16\n" 
			(width - 75) 
			(width - 50)
		    ) 
		    fprintf(outPort "L %d -25 %d 0 -1 16\n" 
			(width - 75) 
			(width - 50)
		    ) 
		    fprintf(outPort "T %d 0 0.00 0.00 47 0 0 1 0 28 0\n" 
			(round((width / 2)) - 50)
		    ) 
		    fprintf(outPort "$CDS_IMAGE|port_body.jpg|%d|50\n" 
			(width - 50)
		    )
		    (axlOSFileCopy 
			strcat(image_path "/port_left.jpg") 
			strcat(cell_name "/images/port_left.jpg") nil
		    ) 
		    fprintf(outPort "T -37 0 0.00 0.00 47 0 0 1 0 28 0\n") 
		    fprintf(outPort "$CDS_IMAGE|port_left.jpg|26|50\n") 
		    (axlOSFileCopy 
			strcat(image_path "/port_right.jpg") 
			strcat(cell_name "/images/port_right.jpg") nil
		    ) 
		    fprintf(outPort "T %d 0 0.00 0.00 47 0 0 1 0 28 0\n" 
			(width - 63)
		    )
		    fprintf(outPort "$CDS_IMAGE|port_right.jpg|26|50\n") else 
		    fprintf(outPort "L -50 -25 -50 25 -1 16\n") 
		    fprintf(outPort "L -50 25 %d 25 -1 16\n" 
			(width - 75)
		    ) 
		    fprintf(outPort "L -50 -25 %d -25 -1 16\n" 
			(width - 75)
		    )
		    fprintf(outPort "L %d 25 %d 0 -1 16\n" 
			(width - 75) 
			(width - 50)
		    ) 
		    fprintf(outPort "L %d -25 %d 0 -1 16\n" 
			(width - 75) 
			(width - 50)
		    ) 
		    fprintf(outPort "T %d 0 0.00 0.00 47 0 0 1 0 28 0\n" 
			(round((width / 2)) - 63)
		    ) 
		    fprintf(outPort "$CDS_IMAGE|port_body.jpg|%d|50\n" 
			(width - 25)
		    ) 
		    (axlOSFileCopy 
			strcat(image_path "/port_right.jpg") 
			strcat(cell_name "/images/port_right.jpg") nil
		    )
		    fprintf(outPort "T %d 0 0.00 0.00 47 0 0 1 0 28 0\n" 
			(width - 63)
		    ) 
		    fprintf(outPort "$CDS_IMAGE|port_right.jpg|26|50\n")
		) 
		fprintf(outPort "P \"OFFPAGE\" \"TRUE\" 25 100 0.00 0.00 47 0 0 0 0 0 0 0 32\n")
		fprintf(outPort "P \"PATH\" \"?\" 0 50 0.00 0.00 41 0 0 0 0 0 0 0 80\n") 
		fprintf(outPort "P \"BLOCK\" \"TRUE\" 25 75 0.00 0.00 47 0 0 0 0 0 0 0 32\n") else 
		fprintf(outPort "C 0 -50 \"A\" -100 0 0 1 41 0 L\n") 
		fprintf(outPort "X \"VHDL_PORT\" %L -35 -70 0.00 0.00 41 0 0 0 0 0 0 0 80\n" io_type)
		fprintf(outPort "X \"HDL_PORT\" %L 325 -125 0.00 0.00 41 0 0 0 0 0 0 0 32\n" io_type) 
		fprintf(outPort "C 0 %d \"A\" %d 0 0 1 41 0 L\n" 
		    (width - 50) width
		) 
		fprintf(outPort "X \"VHDL_PORT\" %L -35 -70 0.00 0.00 41 0 0 0 0 0 0 0 80\n" io_type) 
		fprintf(outPort "X \"HDL_PORT\" %L 325 -125 0.00 0.00 41 0 0 0 0 0 0 0 32\n" io_type) 
		if((type == "INOUT") then 
		    fprintf(outPort "L 0 -50 -25 -25 -1 16\n") 
		    fprintf(outPort "L 0 -50 25 -25 -1 16\n") 
		    fprintf(outPort "L -25 -25 -25 %d -1 16\n" 
			(width - 75)
		    )
		    fprintf(outPort "L 25 -25 25 %d -1 16\n" 
			(width - 75)
		    ) 
		    fprintf(outPort "L 25 %d 0 %d -1 16\n" 
			(width - 75) 
			(width - 50)
		    ) 
		    fprintf(outPort "L -25 %d 0 %d -1 16\n" 
			(width - 75) 
			(width - 50)
		    ) 
		    fprintf(outPort "T 0 %d 0.00 0.00 47 0 0 1 0 28 0\n" 
			(round((width / 2)) - 50)
		    ) 
		    fprintf(outPort "$CDS_IMAGE|port_body.jpg|50|%d\n" 
			(width - 50)
		    )
		    (axlOSFileCopy 
			strcat(image_path "/port_bot.jpg") 
			strcat(cell_name "/images/port_bot.jpg") nil
		    ) 
		    fprintf(outPort "T 0 %d 0.00 0.00 47 0 0 1 0 28 0\n" -37) 
		    fprintf(outPort "$CDS_IMAGE|port_bot.jpg|50|26\n") 
		    (axlOSFileCopy 
			strcat(image_path "/port_top.jpg") 
			strcat(cell_name "/images/port_top.jpg") nil
		    ) 
		    fprintf(outPort "T 0 %d 0.00 0.00 47 0 0 1 0 28 0\n" 
			(width - 63)
		    )
		    fprintf(outPort "$CDS_IMAGE|port_top.jpg|50|26\n") else 
		    fprintf(outPort "L 0 -50 -25 -25 -1 16\n") 
		    fprintf(outPort "L 0 -50 25 -25 -1 16\n") 
		    fprintf(outPort "L -25 -25 -25 %d -1 16\n" 
			(width - 50)
		    )
		    fprintf(outPort "L 25 -25 25 %d -1 16\n" 
			(width - 50)
		    ) 
		    fprintf(outPort "L -25 %d 25 %d -1 16\n" 
			(width - 50) 
			(width - 50)
		    ) 
		    fprintf(outPort "T 0 %d 0.00 0.00 47 0 0 1 0 28 0\n" 
			(round((width / 2)) - 37)
		    ) 
		    fprintf(outPort "$CDS_IMAGE|port_body.jpg|50|%d\n" 
			(width - 25)
		    ) 
		    (axlOSFileCopy 
			strcat(image_path "/port_bot.jpg") 
			strcat(cell_name "/images/port_bot.jpg") nil
		    )
		    fprintf(outPort "T 0 %d 0.00 0.00 47 0 0 1 0 28 0\n" -37) 
		    fprintf(outPort "$CDS_IMAGE|port_bot.jpg|50|26\n")
		)
		fprintf(outPort "P \"OFFPAGE\" \"TRUE\" 25 100 0.00 0.00 47 0 0 0 0 0 0 0 32\n") 
		fprintf(outPort "P \"PATH\" \"?\" 0 50 0.00 0.00 41 0 0 0 0 0 0 0 80\n")
	    ) 
	    close(outPort) else 
	    (trl_altium2hdl_global->exeption = cons(sprintf(nil "-->3.9.03 ERROR   - HDL Library Name: %L!" lib_name) 
		    (trl_altium2hdl_global->exeption)
		)) 
	    printf("-->ERROR %L\n" lib_name)
	)
    )
)
procedure(TRL_ALTIUM2HDL_SCH_Create_Project_Structure() 
    let((cmd_str pass source_proj new_proj new_sch
	    new_loc tmp_f new_path t_message s_level
	    tmp_cmd_str
	) 
	(source_proj = cadddr((trl_altium2hdl_global->files))) 
	(new_proj = nth(5 
		(trl_altium2hdl_global->files)
	    )) 
	(tmp_cmd_str = nil) 
	when((new_proj == "") 
	    (new_proj = strcat("proj_" 
		    TRL_ALTIUM2HDL_PCB_Util_Namemaper(getCurrentTime())
		)) 
	    (new_proj = lowerCase(new_proj)) 
	    when((axlFormGetField 
		    (trl_altium2hdl_global->formid) "projname_l"
		) 
		(axlFormSetField 
		    (trl_altium2hdl_global->formid) "projname_l" new_proj
		)
	    ) 
	    (tmp_f = (trl_altium2hdl_global->files))
	    (trl_altium2hdl_global->files = list(car(tmp_f) 
		    cadr(tmp_f) 
		    caddr(tmp_f) 
		    cadddr(tmp_f) 
		    nth(4 tmp_f)
		    new_proj 
		    nth(6 tmp_f) 
		    nth(7 tmp_f)
		))
	)
	(new_path = sprintf(nil "%s/%s" 
		nth(4 
		    (trl_altium2hdl_global->files)
		) new_proj
	    )) 
	if((length(parseString(new_path " ")) == 1) then 
	    (new_sch = nth(6 
		    (trl_altium2hdl_global->files)
		)) 
	    (new_loc = nth(4 
		    (trl_altium2hdl_global->files)
		)) 
	    if(((source_proj != "") && (new_proj != "") && (new_sch != "") && (new_loc != "")) then 
		(cmd_str = "copyproject.exe") 
		(cmd_str = sprintf(nil "%s -proj %s" cmd_str source_proj)) 
		(cmd_str = sprintf(nil "%s -newprojname %s.cpm" cmd_str new_proj))
		(cmd_str = sprintf(nil "%s -newlib %s_lib" cmd_str new_proj)) 
		(cmd_str = sprintf(nil "%s -newdesign %s" cmd_str new_sch)) 
		(cmd_str = sprintf(nil "%s -copytopath %s/%s" cmd_str new_loc new_proj)) 
		if((axlFormGetField 
			(trl_altium2hdl_global->formid) "license"
		    ) then 
		    (cmd_str = sprintf(nil "%s -product %s" cmd_str 
			    (axlFormGetField 
				(trl_altium2hdl_global->formid) "license"
			    )
			)) else 
		    cond((((axlLicFeatureExists "Concept_HDL_studio") && 
				(_axlLicCheckOut "Concept_HDL_studio")) 
			    (tmp_cmd_str = "Concept_HDL_studio") 
			    (_axlLicCheckIn tmp_cmd_str)
			) 
			(((axlLicFeatureExists "PCB_design_studio") && 
				(_axlLicCheckOut "PCB_design_studio")) 
			    (tmp_cmd_str = "PCB_design_studio") 
			    (_axlLicCheckIn tmp_cmd_str)
			) 
			(((axlLicFeatureExists "Allegro_performance") && 
				(_axlLicCheckOut "Allegro_performance")) 
			    (tmp_cmd_str = "Allegro_performance") 
			    (_axlLicCheckIn tmp_cmd_str)
			) 
			(((axlLicFeatureExists "Allegro_studio") && 
				(_axlLicCheckOut "Allegro_studio")) 
			    (tmp_cmd_str = "Allegro_studio") 
			    (_axlLicCheckIn tmp_cmd_str)
			) 
			(((axlLicFeatureExists "PCB_librarian_expert") && 
				(_axlLicCheckOut "PCB_librarian_expert")) 
			    (tmp_cmd_str = "PCB_librarian_expert") 
			    (_axlLicCheckIn tmp_cmd_str)
			)
			(t 
			    (trl_altium2hdl_global->exeption = cons(sprintf(nil "-->3.1.12 ERROR   - NO License for Project Structure found! - %L NOT CREATED" new_sch) 
				    (trl_altium2hdl_global->exeption)
				))
			)
		    )
		    if(tmp_cmd_str then 
			(tmp_cmd_str = sprintf(nil "%s -product %L" cmd_str tmp_cmd_str)) 
			(cmd_str = tmp_cmd_str) else
			(cmd_str = nil)
		    )
		) 
		if(cmd_str then 
		    sh(cmd_str) else 
		    (trl_altium2hdl_global->exeption = cons(sprintf(nil "-->3.1.12 ERROR   - NO License for Project Structure found! - %L NOT CREATED" new_sch) 
			    (trl_altium2hdl_global->exeption)
			))
		)
		(trl_altium2hdl_global->exeption = cons("-------------------------------------------------------------------------------" 
			(trl_altium2hdl_global->exeption)
		    )) 
		if(isDir(sprintf(nil "%s/%s/worklib/%s" new_loc new_proj new_sch)) then 
		    (trl_altium2hdl_global->exeption = cons(sprintf(nil "   3.1.11 INFO    - Project Structure for Design: %L CREATED" new_sch) 
			    (trl_altium2hdl_global->exeption)
			)) 
		    (pass = t) else
		    (trl_altium2hdl_global->exeption = cons(sprintf(nil "-->3.1.11 ERROR   - Project Structure for Design: %L NOT CREATED" new_sch) 
			    (trl_altium2hdl_global->exeption)
			))
		) else 
		(axlUIConfirm "Complete Project SetUp" 
		    'info
		) 
		printf("-->Complete Project SetUp\n")
	    )
	    else 
	    (t_message = sprintf(nil "ConceptHDL Project Location Directory includes SPACES!\n%L\nPlease remove all Spaces fom Path first" new_path)) 
	    (s_level = 'error) 
	    (axlUIConfirm t_message s_level)
	) pass
    )
)
procedure(TRL_ALTIUM2HDL_SCH_Create_SheetFrame(port sch_name) 
    let((params size_x size_y margin zone_x
	    zone_y zone_style orient docu_style block_on
	    step_y step_x y_inc alphabet z_char
	    font_size block_ori_x block_ori_y index x_inc
	) 
	foreach(data 
	    (trl_altium2hdl_global->Graphic) 
	    when((car(data) == sch_name) 
		(params = caddr(data))
	    )
	) 
	(params = nth(12 params)) 
	(params = car(params)) 
	if(params then 
	    (size_x = get(params 
		    'CUSTOMX
		)) 
	    (size_y = get(params 
		    'CUSTOMY
		)) 
	    (margin = get(params 
		    'CUSTOMMARGINWIDTH
		))
	    (zone_x = get(params 
		    'CUSTOMXZONES
		)) 
	    (zone_y = get(params 
		    'CUSTOMYZONES
		)) 
	    (zone_style = get(params 
		    'REFERENCEZONESTYLE
		)) 
	    (orient = get(params 
		    'WORKSPACEORIENTATION
		)) 
	    (docu_style = get(params 
		    'DOCUMENTBORDERSTYLE
		))
	    (block_on = get(params 
		    'TITLEBLOCKON
		)) 
	    case((axlFormGetField 
		    (trl_altium2hdl_global->formid) "frame_size"
		) 
		("a" 
		    (size_x = "950") 
		    (size_y = "750")
		) 
		("b" 
		    (size_x = "1500") 
		    (size_y = "950")
		) 
		("c" 
		    (size_x = "2000") 
		    (size_y = "1500")
		) 
		("d" 
		    (size_x = "3200") 
		    (size_y = "2000")
		)
		("e" 
		    (size_x = "4200") 
		    (size_y = "3200")
		) 
		("a4" 
		    (size_x = "1150") 
		    (size_y = "760")
		) 
		("a3" 
		    (size_x = "1550") 
		    (size_y = "1110")
		) 
		("a2" 
		    (size_x = "2230") 
		    (size_y = "1570")
		) 
		("a1" 
		    (size_x = "3150") 
		    (size_y = "2230")
		)
		("a0" 
		    (size_x = "4460") 
		    (size_y = "3150")
		) 
		("letter" 
		    (size_x = "1100") 
		    (size_y = "850")
		) 
		("legal" 
		    (size_x = "1400") 
		    (size_y = "850")
		) 
		("tabloid" 
		    (size_x = "1700") 
		    (size_y = "1100")
		) 
		(t)
	    ) 
	    when((orient && (orient == "1")) 
		(size_y = get(params 
			'CUSTOMX
		    )) 
		(size_x = get(params 
			'CUSTOMY
		    )) 
		(zone_y = get(params 
			'CUSTOMXZONES
		    )) 
		(zone_x = get(params 
			'CUSTOMYZONES
		    ))
		case((axlFormGetField 
			(trl_altium2hdl_global->formid) "frame_size"
		    ) 
		    ("a" 
			(size_y = "950") 
			(size_x = "750")
		    ) 
		    ("b" 
			(size_y = "1500") 
			(size_x = "950")
		    ) 
		    ("c" 
			(size_y = "2000") 
			(size_x = "1500")
		    ) 
		    ("d" 
			(size_y = "3200") 
			(size_x = "2000")
		    )
		    ("e" 
			(size_y = "4200") 
			(size_x = "3200")
		    ) 
		    ("a4" 
			(size_y = "1150") 
			(size_x = "760")
		    ) 
		    ("a3" 
			(size_y = "1550") 
			(size_x = "1110")
		    ) 
		    ("a2" 
			(size_y = "2230") 
			(size_x = "1570")
		    ) 
		    ("a1" 
			(size_y = "3150") 
			(size_x = "2230")
		    )
		    ("a0" 
			(size_y = "4460") 
			(size_x = "3150")
		    ) 
		    ("letter" 
			(size_y = "1100") 
			(size_x = "850")
		    ) 
		    ("legal" 
			(size_y = "1400") 
			(size_x = "850")
		    ) 
		    ("tabloid" 
			(size_y = "1700") 
			(size_x = "1100")
		    ) 
		    (t)
		)
	    ) 
	    (alphabet = list("A" "B" "C" "D" "E"
		    "F" "G" "H" "I" "J"
		    "K" "L" "M" "N" "O"
		    "P" "Q" "R" "S" "T"
		    "U" "V" "W" "X" "Y"
		    "Z"
		)) 
	    (font_size = (6 * 5))
	    (size_x = (atoi(size_x) * 5)) 
	    (size_y = (atoi(size_y) * 5)) 
	    fprintf(port "L 0 0 0 %d -1 16\n" size_y) 
	    fprintf(port "L 0 %d %d %d -1 16\n" size_y size_x size_y) 
	    fprintf(port "L %d %d %d 0 -1 16\n" size_x size_y size_x)
	    fprintf(port "L %d 0 0 0 -1 16\n" size_x) 
	    if(margin then 
		(margin = (atoi(margin) * 5)) else 
		(margin = (20 * 5))
	    ) 
	    fprintf(port "L %d %d %d %d -1 16\n" margin margin margin
		(size_y - margin)
	    ) 
	    fprintf(port "L %d %d %d %d -1 16\n" margin 
		(size_y - margin) 
		(size_x - margin)
		(size_y - margin)
	    ) 
	    fprintf(port "L %d %d %d %d -1 16\n" 
		(size_x - margin) 
		(size_y - margin) 
		(size_x - margin)
		margin
	    )
	    fprintf(port "L %d %d %d %d -1 16\n" 
		(size_x - margin) margin margin
		margin
	    ) 
	    if(zone_x then 
		(zone_x = atoi(zone_x)) else 
		(zone_x = 4)
	    ) 
	    (step_x = round((size_x / zone_x))) 
	    if(zone_y then 
		(zone_y = atoi(zone_y)) else 
		(zone_y = 4)
	    ) 
	    (step_y = round((size_y / zone_y)))
	    (index = 1) 
	    (y_inc = 0) 
	    for(incre 1 
		(zone_y - 1) 
		(y_inc = (y_inc + step_y)) 
		fprintf(port "L 0 %d %d %d -1 16\n" y_inc margin y_inc)
		if((zone_style && (zone_style == "1")) then 
		    (z_char = nth((index - 1) alphabet)) else 
		    (z_char = nth((zone_y - index) alphabet))
		) 
		fprintf(port "T %d %d 0.00 0.00 %d 0 0 1 0 5 0\n" 
		    (margin / 2) 
		    round((y_inc - (step_y / 2))) 36
		) 
		fprintf(port "%s\n" z_char) 
		index++
	    ) 
	    (y_inc = (y_inc + step_y)) 
	    if((zone_style && (zone_style == "1")) then 
		(z_char = nth((index - 1) alphabet)) else 
		(z_char = nth((zone_y - index) alphabet))
	    )
	    fprintf(port "T %d %d 0.00 0.00 %d 0 0 1 0 5 0\n" 
		(margin / 2) 
		round((y_inc - (step_y / 2))) 36
	    ) 
	    fprintf(port "%s\n" z_char) 
	    (index = 1) 
	    (y_inc = 0) 
	    for(incre 1 
		(zone_y - 1) 
		(y_inc = (y_inc + step_y)) 
		fprintf(port "L %d %d %d %d -1 16\n" 
		    (size_x - margin) y_inc size_x
		    y_inc
		)
		if((zone_style && (zone_style == "1")) then 
		    (z_char = nth((index - 1) alphabet)) else 
		    (z_char = nth((zone_y - index) alphabet))
		) 
		fprintf(port "T %d %d 0.00 0.00 %d 0 0 1 0 5 0\n" 
		    (size_x - (margin / 2)) 
		    round((y_inc - (step_y / 2))) 36
		) 
		fprintf(port "%s\n" z_char) 
		index++
	    )
	    (y_inc = (y_inc + step_y)) 
	    if((zone_style && (zone_style == "1")) then 
		(z_char = nth((index - 1) alphabet)) else 
		(z_char = nth((zone_y - index) alphabet))
	    ) 
	    fprintf(port "T %d %d 0.00 0.00 %d 0 0 1 0 5 0\n" 
		(size_x - (margin / 2)) 
		round((y_inc - (step_y / 2))) 36
	    ) 
	    fprintf(port "%s\n" z_char) 
	    (index = 1)
	    (x_inc = 0) 
	    for(incre 1 
		(zone_x - 1) 
		(x_inc = (x_inc + step_x)) 
		fprintf(port "L %d %d %d %d -1 16\n" x_inc size_y x_inc
		    (size_y - margin)
		)
		if((zone_style && (zone_style == "1")) then 
		    (z_char = sprintf(nil "%d" 
			    ((zone_x - index) + 1)
			)) else 
		    (z_char = sprintf(nil "%d" index))
		) 
		fprintf(port "T %d %d 0.00 0.00 %d 0 0 1 0 5 0\n" 
		    round((x_inc - (step_x / 2))) 
		    ((margin / 2) - round((font_size / 2))) 36
		) 
		fprintf(port "%s\n" z_char) 
		index++
	    ) 
	    (x_inc = (x_inc + step_x)) 
	    if((zone_style && (zone_style == "1")) then 
		(z_char = sprintf(nil "%d" 
			((zone_x - index) + 1)
		    )) else 
		(z_char = sprintf(nil "%d" index))
	    ) 
	    fprintf(port "T %d %d 0.00 0.00 %d 0 0 1 0 5 0\n" 
		round((x_inc - (step_x / 2))) 
		((margin / 2) - round((font_size / 2))) 36
	    )
	    fprintf(port "%s\n" z_char) 
	    (index = 1) 
	    (x_inc = 0) 
	    for(incre 1 
		(zone_x - 1) 
		(x_inc = (x_inc + step_x)) 
		fprintf(port "L %d 0 %d %d -1 16\n" x_inc x_inc margin)
		if((zone_style && (zone_style == "1")) then 
		    (z_char = sprintf(nil "%d" 
			    ((zone_x - index) + 1)
			)) else 
		    (z_char = sprintf(nil "%d" index))
		) 
		fprintf(port "T %d %d 0.00 0.00 %d 0 0 1 0 5 0\n" 
		    round((x_inc - (step_x / 2))) 
		    (size_y - (margin / 2) - round((font_size / 2))) 36
		) 
		fprintf(port "%s\n" z_char) 
		index++
	    ) 
	    (x_inc = (x_inc + step_x))
	    if((zone_style && (zone_style == "1")) then 
		(z_char = sprintf(nil "%d" 
			((zone_x - index) + 1)
		    )) else 
		(z_char = sprintf(nil "%d" index))
	    ) 
	    fprintf(port "T %d %d 0.00 0.00 %d 0 0 1 0 5 0\n" 
		round((x_inc - (step_x / 2))) 
		(size_y - (margin / 2) - round((font_size / 2))) 36
	    ) 
	    fprintf(port "%s\n" z_char)
	)
	when((block_on && (block_on == "T")) 
	    (block_ori_x = (size_x - margin)) 
	    (block_ori_y = margin) 
	    if((docu_style && (docu_style == "1")) then 
		fprintf(port "L %d %d %d %d -1 16\n" 
		    (block_ori_x - (630 * 5)) 
		    (block_ori_y + (180 * 5)) block_ori_x
		    (block_ori_y + (180 * 5))
		) 
		fprintf(port "L %d %d %d %d -1 16\n" 
		    (block_ori_x - (430 * 5)) 
		    (block_ori_y + (130 * 5)) block_ori_x
		    (block_ori_y + (130 * 5))
		) 
		fprintf(port "L %d %d %d %d -1 16\n" 
		    (block_ori_x - (430 * 5)) 
		    (block_ori_y + (70 * 5)) block_ori_x
		    (block_ori_y + (70 * 5))
		)
		fprintf(port "L %d %d %d %d -1 16\n" 
		    (block_ori_x - (430 * 5)) 
		    (block_ori_y + (30 * 5)) block_ori_x
		    (block_ori_y + (30 * 5))
		) 
		fprintf(port "L %d %d %d %d -1 16\n" 
		    (block_ori_x - (630 * 5)) 
		    (block_ori_y + (180 * 5)) 
		    (block_ori_x - (630 * 5))
		    block_ori_y
		) 
		fprintf(port "L %d %d %d %d -1 16\n" 
		    (block_ori_x - (430 * 5)) 
		    (block_ori_y + (180 * 5)) 
		    (block_ori_x - (430 * 5))
		    block_ori_y
		) 
		fprintf(port "L %d %d %d %d -1 16\n" 
		    (block_ori_x - (390 * 5)) 
		    (block_ori_y + (70 * 5)) 
		    (block_ori_x - (390 * 5))
		    (block_ori_y + (30 * 5))
		) 
		fprintf(port "L %d %d %d %d -1 16\n" 
		    (block_ori_x - (330 * 5)) 
		    (block_ori_y + (30 * 5)) 
		    (block_ori_x - (330 * 5))
		    block_ori_y
		)
		fprintf(port "L %d %d %d %d -1 16\n" 
		    (block_ori_x - (280 * 5)) 
		    (block_ori_y + (70 * 5)) 
		    (block_ori_x - (280 * 5))
		    (block_ori_y + (30 * 5))
		) 
		fprintf(port "L %d %d %d %d -1 16\n" 
		    (block_ori_x - (180 * 5)) 
		    (block_ori_y + (30 * 5)) 
		    (block_ori_x - (180 * 5))
		    block_ori_y
		) 
		fprintf(port "L %d %d %d %d -1 16\n" 
		    (block_ori_x - (40 * 5)) 
		    (block_ori_y + (70 * 5)) 
		    (block_ori_x - (40 * 5))
		    (block_ori_y + (30 * 5))
		) else 
		fprintf(port "L %d %d %d %d -1 16\n" 
		    (block_ori_x - (350 * 5)) 
		    (block_ori_y + (80 * 5)) block_ori_x
		    (block_ori_y + (80 * 5))
		)
		fprintf(port "L %d %d %d %d -1 16\n" 
		    (block_ori_x - (350 * 5)) 
		    (block_ori_y + (50 * 5)) block_ori_x
		    (block_ori_y + (50 * 5))
		) 
		fprintf(port "L %d %d %d %d -1 16\n" 
		    (block_ori_x - (350 * 5)) 
		    (block_ori_y + (20 * 5)) block_ori_x
		    (block_ori_y + (20 * 5))
		) 
		fprintf(port "L %d %d %d %d -1 16\n" 
		    (block_ori_x - (350 * 5)) 
		    (block_ori_y + (10 * 5)) block_ori_x
		    (block_ori_y + (10 * 5))
		) 
		fprintf(port "L %d %d %d %d -1 16\n" 
		    (block_ori_x - (350 * 5)) 
		    (block_ori_y + (80 * 5)) 
		    (block_ori_x - (350 * 5))
		    block_ori_y
		) 
		fprintf(port "L %d %d %d %d -1 16\n" 
		    (block_ori_x - (300 * 5)) 
		    (block_ori_y + (50 * 5)) 
		    (block_ori_x - (300 * 5))
		    (block_ori_y + (20 * 5))
		)
		fprintf(port "L %d %d %d %d -1 16\n" 
		    (block_ori_x - (150 * 5)) 
		    (block_ori_y + (20 * 5)) 
		    (block_ori_x - (150 * 5))
		    block_ori_y
		) 
		fprintf(port "L %d %d %d %d -1 16\n" 
		    (block_ori_x - (100 * 5)) 
		    (block_ori_y + (50 * 5)) 
		    (block_ori_x - (100 * 5))
		    (block_ori_y + (20 * 5))
		) 
		fprintf(port "T %d %d 0.00 0.00 %d 0 0 0 0 5 0\nTitle\n" 
		    ((block_ori_x - (350 * 5)) + 20) 
		    (block_ori_y + (70 * 5) + 9) 34
		) 
		fprintf(port "T %d %d 0.00 0.00 %d 0 0 0 0 5 0\nSize\n" 
		    ((block_ori_x - (350 * 5)) + 20) 
		    (block_ori_y + (40 * 5) + 9) 34
		) 
		fprintf(port "T %d %d 0.00 0.00 %d 0 0 0 0 5 0\nDate:\n" 
		    ((block_ori_x - (350 * 5)) + 20) 
		    (block_ori_y + (10 * 5) + 9) 34
		)
		fprintf(port "T %d %d 0.00 0.00 %d 0 0 0 0 5 0\nFile:\n" 
		    ((block_ori_x - (350 * 5)) + 20) 
		    (block_ori_y + 9) 34
		) 
		fprintf(port "T %d %d 0.00 0.00 %d 0 0 0 0 5 0\nNumber\n" 
		    ((block_ori_x - (300 * 5)) + 20) 
		    (block_ori_y + (40 * 5) + 9) 34
		) 
		fprintf(port "T %d %d 0.00 0.00 %d 0 0 0 0 5 0\nRevision\n" 
		    ((block_ori_x - (100 * 5)) + 20) 
		    (block_ori_y + (40 * 5) + 9) 34
		) 
		fprintf(port "T %d %d 0.00 0.00 %d 0 0 0 0 5 0\nDrawn By:\n" 
		    ((block_ori_x - (150 * 5)) + 20) 
		    (block_ori_y + 9) 34
		) 
		fprintf(port "P \"CUSTOM_TXT_CDS\" \"Sheet <CON_PAGE_NUM> of <CON_TOTAL_PAGES>\" %d %d 0.00 0.00 34 0 0 0 0 0 1 0 32\n" 
		    ((block_ori_x - (150 * 5)) + 20) 
		    (block_ori_y + (10 * 5) + 9)
		)
		fprintf(port "P \"CUSTOM_TXT_CDS\" \"<CON_LAST_MODIFIED>\" %d %d 0.00 0.00 34 0 0 0 0 0 1 0 32\n" 
		    ((block_ori_x - (300 * 5)) + 20) 
		    (block_ori_y + (10 * 5) + 9)
		)
	    )
	) 
	fprintf(port "P \"PATH\" \"?\" 50 100 0.00 0.00 48 0 0 0 0 0 0 0 68\n") 
	fprintf(port "P \"COMMENT_BODY\" \"TRUE\" 50 50 0.00 0.00 48 0 0 0 0 0 0 0 68\n") 
	println("--END--")
    )
)
procedure(TRL_ALTIUM2HDL_SCH_Load_CIS_File() 
    let((cis_inport parse_strg raw_list nline) 
	if(isFile((axlFormGetField 
		    (trl_altium2hdl_global->formid) "cis_l"
		)
	    ) then 
	    if(isReadable((axlFormGetField 
			(trl_altium2hdl_global->formid) "cis_l"
		    )
		) then 
		(cis_inport = infile((axlFormGetField 
			    (trl_altium2hdl_global->formid) "cis_l"
			)
		    )) else 
		(trl_altium2hdl_global->exeption = cons("-->7.2.01 ERROR   - CIS Definition File don't exist or can't be accessed!" 
			(trl_altium2hdl_global->exeption)
		    ))
	    ) else 
	    (trl_altium2hdl_global->exeption = cons("   7.2.01 WARNING - Unable to Open CIS Definition File, OR File Name specified!" 
		    (trl_altium2hdl_global->exeption)
		))
	) 
	if(cis_inport then 
	    (raw_list = list()) 
	    (trl_altium2hdl_global->exeption = cons("   7.3.01 INFO    - Altium CIS Definition File Opened!" 
		    (trl_altium2hdl_global->exeption)
		)) 
	    while((nline = _gets(cis_inport)) 
		(parse_strg = car(parseString(nline "\n"))) 
		(raw_list = cons(parseString(parse_strg ";") raw_list))
	    )
	    close(cis_inport) 
	    if(raw_list then 
		(trl_altium2hdl_global->CISRawList = reverse(raw_list)) else 
		(trl_altium2hdl_global->exeption = cons("-->7.2.02 ERROR   - CISRawList don't exist or can't be accessed!" 
			(trl_altium2hdl_global->exeption)
		    ))
	    ) else 
	    (trl_altium2hdl_global->exeption = cons("-->7.2.02 WARNING - CIS File don't exist or can't be accessed!" 
		    (trl_altium2hdl_global->exeption)
		))
	)
    )
)
procedure(TRL_ALTIUM2HDL_SCH_Load_File(sch_name) 
    let((sch_inport parse_strg info SchematicData nline
	    parse_list record rest str1 t_message
	    s_level
	) 
	if(isFile(sch_name) then 
	    if(isReadable(sch_name) then 
		(sch_inport = infile(sch_name)) else 
		(axlUIWPrint 
		    (trl_altium2hdl_global->formid) "E - *Error* Unable to Open Schematic Definition File, Check Permissions"
		)
		(trl_altium2hdl_global->exeption = cons(sprintf(nil "-->1.2.02 ERROR   - Schematic Definition File %L don't exist or can't be accessed!" sch_name) 
			(trl_altium2hdl_global->exeption)
		    ))
	    ) else 
	    (axlUIWPrint 
		(trl_altium2hdl_global->formid) "E - *Error* Unable to Open Schematic Definition File, Check File Name"
	    )
	    (trl_altium2hdl_global->exeption = cons(sprintf(nil "-->1.2.01 ERROR   - Unable to Open Schematic Definition File %L, Check File Name!" sch_name) 
		    (trl_altium2hdl_global->exeption)
		))
	) 
	(SchematicData = list()) 
	if(sch_inport then 
	    (nline = _gets(sch_inport)) 
	    close(sch_inport) 
	    (nline = parseString(nline "|"))
	    if((car(nline) == "HEADER=Protel for Windows - Schematic Capture Ascii File Version 5.0") then 
		(sch_inport = infile(sch_name)) 
		(parse_list = list()) 
		(record = "")
		(rest = list()) 
		while((nline = _gets(sch_inport)) 
		    (parse_strg = parseString(nline "\n")) 
		    (parse_strg = car(parse_strg)) 
		    when(parse_strg 
			rexCompile("||") 
			(parse_strg = rexReplace(parse_strg "|SPACE|" 0)) 
			(parse_strg = parseString(parse_strg "|")) 
			(record = car(parse_strg))
			(record = parseString(record "=")) 
			(record = car(record)) 
			if((record == "RECORD") then 
			    if((car(last(parse_strg)) == ">") then 
				(rest = parse_strg) else 
				(parse_list = cons(parse_strg parse_list))
				(rest = list())
			    ) else 
			    if(rest then 
				(rest = reverse(rest)) 
				(str1 = cadr(rest)) 
				(str1 = sprintf(nil "%s%s" str1 
					car(parse_strg)
				    ))
				(rest = cddr(rest)) 
				(rest = cons(str1 rest)) 
				(rest = reverse(rest)) 
				(parse_strg = cdr(parse_strg)) 
				when(parse_strg 
				    (rest = append(parse_strg rest))
				)
				(parse_list = cons(rest parse_list)) 
				(rest = list()) else 
				(trl_altium2hdl_global->Rest = cons(parse_strg 
					(trl_altium2hdl_global->Rest)
				    ))
			    )
			)
		    )
		) 
		when(rest 
		    printf("--REST-> %L \n" rest)
		) 
		close(sch_inport) 
		when(parse_list 
		    foreach(parse_l parse_list 
			(info = ncons(nil)) 
			foreach(prop_pair parse_l 
			    (parse_strg = parseString(prop_pair "=")) 
			    when((length(parse_strg) == 2) 
				putprop(info 
				    cadr(parse_strg) 
				    stringToSymbol(car(parse_strg))
				)
			    )
			) 
			(SchematicData = cons(info SchematicData))
			(info = ncons(nil))
		    )
		)
		else 
		(t_message = sprintf(nil "Altium %s file is stll binary file!\nPlease save the Altium Schematic file in ASCII Format first" sch_name)) 
		(s_level = 'error) 
		(axlUIConfirm t_message s_level)
	    ) else 
	    (trl_altium2hdl_global->exeption = cons("-->1.2.02 ERROR   - Altium SCH File don't exist or can't be accessed!" 
		    (trl_altium2hdl_global->exeption)
		))
	) 
	when(SchematicData 
	    (SchematicData = reverse(SchematicData))
	)
	SchematicData
    )
)
procedure(TRL_ALTIUM2HDL_SCH_Load_PrjPCB_File() 
    let((prjpcb_file prjpcb_new_f prjpcb_inport parse_strg raw_list
	    nline t_message s_level DocumentPath proj_raw_list
	    prjpcb_path tmp_root tmp_sch new_root new_sch
	    page_nr rest newSchName schName tmp_root_file
	    tmp_sch_file
	) 
	if(isFile((axlFormGetField 
		    (trl_altium2hdl_global->formid) "prjpcb_l"
		)
	    ) then 
	    (prjpcb_file = (axlFormGetField 
		    (trl_altium2hdl_global->formid) "prjpcb_l"
		)) 
	    (prjpcb_path = (axlDMFileParts prjpcb_file)) 
	    (prjpcb_path = car(prjpcb_path))
	    (proj_raw_list = list()) 
	    (page_nr = 2) 
	    if(isReadable(prjpcb_file) then 
		(prjpcb_inport = infile(prjpcb_file)) 
		if(prjpcb_inport then 
		    (trl_altium2hdl_global->exeption = cons("   7.3.02 INFO    - Altium PrjPCB Definition File Opened!" 
			    (trl_altium2hdl_global->exeption)
			)) 
		    while((nline = _gets(prjpcb_inport)) 
			(parse_strg = car(parseString(nline "\n"))) 
			when(parse_strg 
			    (parse_strg = parseString(parse_strg "=")) 
			    when((parse_strg && (car(parse_strg) == "DocumentPath")) 
				(DocumentPath = cadr(parse_strg)) 
				when(DocumentPath 
				    (parse_strg = parseString(DocumentPath ".")) 
				    when((parse_strg && (upperCase(car(last(parse_strg))) == "SCHDOC")) 
					(DocumentPath = (axlOSSlash DocumentPath)) 
					(proj_raw_list = cons(DocumentPath proj_raw_list))
				    )
				)
			    )
			)
		    ) 
		    close(prjpcb_inport)
		    (prjpcb_new_f = (axlDMFileParts prjpcb_file)) 
		    (prjpcb_new_f = strcat(prjpcb_path "/" 
			    cadr(prjpcb_new_f) ".PrjPcbStructure"
			)) 
		    if(isFile(prjpcb_new_f) then 
			(prjpcb_new_f = (axlDMFileParts prjpcb_file)) 
			(prjpcb_new_f = strcat(prjpcb_path "/" 
				cadr(prjpcb_new_f) ".PRJPCBSTRUCTURE"
			    )) 
			if(isFile(prjpcb_new_f) then 
			    if(isReadable(prjpcb_new_f) then 
				(prjpcb_inport = infile(prjpcb_new_f)) 
				if(prjpcb_inport then 
				    (raw_list = list()) 
				    (trl_altium2hdl_global->exeption = cons("   7.3.02 INFO    - Altium PrjStructure Definition File Opened!" 
					    (trl_altium2hdl_global->exeption)
					)) 
				    while((nline = _gets(prjpcb_inport)) 
					(parse_strg = car(parseString(nline "\n"))) 
					when(parse_strg 
					    (raw_list = cons(parse_strg raw_list))
					)
				    )
				    close(prjpcb_inport) 
				    if(raw_list then 
					(raw_list = TRL_ALTIUM2HDL_SCH_Parse_PrjPcbStructure_File(raw_list)) 
					(rest = list()) 
					(new_root = list())
					if((raw_list && caar(raw_list)) then 
					    (tmp_root = caar(raw_list)) 
					    (tmp_sch = cadr(raw_list)) 
					    when(tmp_root 
						(tmp_root_file = (axlDMFileParts 
							caddr(tmp_root)
						    )) 
						(tmp_root_file = caddr(tmp_root_file)) 
						when(tmp_root_file 
						    foreach(proj proj_raw_list 
							if((caddr((axlDMFileParts proj)) == tmp_root_file) then 
							    (new_root = list(car(tmp_root) 
								    cadr(tmp_root) 
								    strcat(prjpcb_path "/" proj)
								)) else 
							    (rest = cons(proj rest))
							)
						    )
						)
					    )
					    else 
					    when(proj_raw_list 
						when(car(proj_raw_list) 
						    (schName = cadr((axlDMFileParts 
								car(proj_raw_list)
							    )
							)) 
						    (schName = TRL_ALTIUM2HDL_PCB_Util_Namemaper(schName)) 
						    (new_root = list(schName schName 
							    strcat(prjpcb_path "/" 
								car(proj_raw_list)
							    )
							))
						) 
						when(cadr(proj_raw_list) 
						    (rest = cadr(proj_raw_list))
						)
					    )
					) 
					(new_sch = list()) 
					(newSchName = list()) 
					when(rest 
					    foreach(r rest 
						if(tmp_sch then 
						    (schName = caddr((axlDMFileParts r))) 
						    foreach(sch tmp_sch 
							(tmp_sch_file = (axlDMFileParts 
								caddr(sch)
							    )) 
							(tmp_sch_file = caddr(tmp_sch_file)) 
							when((tmp_sch_file == schName) 
							    (newSchName = list(car(sch) 
								    cadr(sch) 
								    strcat(prjpcb_path "/" r)
								))
							)
						    ) 
						    if(newSchName then 
							(new_sch = cons(newSchName new_sch)) else 
							(schName = TRL_ALTIUM2HDL_PCB_Util_Namemaper(schName))
							(new_sch = cons(list(schName page_nr 
								    strcat(prjpcb_path "/" r)
								) new_sch
							    )) 
							page_nr++
						    )
						    (newSchName = list()) else 
						    (schName = cadr((axlDMFileParts r))) 
						    (schName = TRL_ALTIUM2HDL_PCB_Util_Namemaper(schName)) 
						    (new_sch = cons(list(schName page_nr 
								strcat(prjpcb_path "/" r)
							    ) new_sch
							))
						    page_nr++
						)
					    )
					) 
					(trl_altium2hdl_global->PRJRawList = list(list(new_root) new_sch))
					else 
					(trl_altium2hdl_global->exeption = cons("-->7.2.02 ERROR   - PRJStrRawList don't exist or can't be accessed!" 
						(trl_altium2hdl_global->exeption)
					    ))
				    ) else 
				    (trl_altium2hdl_global->exeption = cons("-->7.2.01 ERROR   - PRJ File don't exist or can't be accessed!" 
					    (trl_altium2hdl_global->exeption)
					))
				) else
				(t_message = sprintf(nil "Altium %s file is NOT Readable!\nPlease follow Help instructions to fix this first." prjpcb_new_f)) 
				(s_level = 'error) 
				(axlUIConfirm t_message s_level) 
				(axlUIWPrint 
				    (trl_altium2hdl_global->formid) "E - *Error* Unable to Open PrjPcbStructure File, Check Permissions"
				) 
				(trl_altium2hdl_global->exeption = cons("-->7.2.03 ERROR   - PrjPcbStructure File don't exist or can't be accessed!" 
					(trl_altium2hdl_global->exeption)
				    ))
			    ) else 
			    (t_message = sprintf(nil "Altium %s file is missing!\nPlease follow Help instructions to fix this first." prjpcb_new_f))
			    (s_level = 'error) 
			    (axlUIConfirm t_message s_level)
			)
			else 
			(t_message = sprintf(nil "Altium %s file is missing!\nPlease follow Help instructions to fix this first." prjpcb_new_f)) 
			(s_level = 'error) 
			(axlUIConfirm t_message s_level)
		    ) else 
		    (axlUIWPrint 
			(trl_altium2hdl_global->formid) "E - *Error* Unable to Open PrjPCB File, Check Permissions"
		    )
		    (trl_altium2hdl_global->exeption = cons("-->7.2.03 ERROR   - PrjPCB File don't exist or can't be accessed!" 
			    (trl_altium2hdl_global->exeption)
			))
		) else
		(axlUIWPrint 
		    (trl_altium2hdl_global->formid) "E - *Error* Unable to Open PrjPCB File, Check Permissions"
		) 
		(trl_altium2hdl_global->exeption = cons("-->7.2.03 ERROR   - PrjPCB File don't exist or can't be accessed!" 
			(trl_altium2hdl_global->exeption)
		    ))
	    ) else 
	    (trl_altium2hdl_global->exeption = cons("-->7.2.02 ERROR   - PrjPCB File don't exist or can't be accessed!" 
		    (trl_altium2hdl_global->exeption)
		))
	    (t_message = sprintf(nil "Altium PcbPrj %s file is missing!\nPlease follow Help instructions to fix this first." 
		    (axlFormGetField 
			(trl_altium2hdl_global->formid) "prjpcb_l"
		    )
		)) 
	    (s_level = 'error) 
	    (axlUIConfirm t_message s_level)
	)
    )
)
procedure(TRL_ALTIUM2HDL_SCH_Load_SchDocDir_File() 
    let((SchDocDir DirFiles SchFile FileName filestr) 
	(SchFile = list()) 
	(SchDocDir = (axlFormGetField 
		(trl_altium2hdl_global->formid) "SchDocDir_l"
	    )) 
	(DirFiles = getDirFiles(SchDocDir)) 
	if(DirFiles then 
	    foreach(file DirFiles 
		(filestr = parseString(file ".")) 
		when((car(last(filestr)) == "SchDoc") 
		    (FileName = strcat(SchDocDir "/" file)) 
		    (SchFile = cons(FileName SchFile))
		)
	    ) else 
	    (trl_altium2hdl_global->exeption = cons("-->7.2.02 ERROR   - SCM Dir File don't exist or can't be accessed!" 
		    (trl_altium2hdl_global->exeption)
		))
	)
	unless(SchFile 
	    (trl_altium2hdl_global->exeption = cons("-->7.2.03 ERROR   - SCM Dir File don't exist or can't be accessed!" 
		    (trl_altium2hdl_global->exeption)
		))
	) SchFile
    )
)
procedure(TRL_ALTIUM2HDL_SCH_Parse_PrjPcbStructure_File(raw_data) 
    let((SchematicData parse_strg info TopLevelDoc FileName
	    proj_pars proj_name SheetSymbol file dir
	    TopName cdn_proj_name design_name record tmp
	) 
	(SchematicData = list()) 
	(file = (axlFormGetField 
		(trl_altium2hdl_global->formid) "prjpcb_l"
	    )) 
	(file = parseString(file "/")) 
	(file = car(last(file)))
	(file = parseString(file ".")) 
	(proj_name = car(file)) 
	when((length(file) > 2) 
	    for(i 2 
		(length(file) - 1) 
		(proj_name = strcat(proj_name "." 
			nth((i - 1) file)
		    ))
	    )
	) 
	(cdn_proj_name = TRL_ALTIUM2HDL_PCB_Util_Namemaper(proj_name)) 
	when(cdn_proj_name 
	    (cdn_proj_name = lowerCase(cdn_proj_name)) 
	    (tmp = (trl_altium2hdl_global->files)) 
	    (trl_altium2hdl_global->files = list(car(tmp) 
		    cadr(tmp) 
		    caddr(tmp) 
		    cadddr(tmp) 
		    nth(4 tmp)
		    cdn_proj_name 
		    nth(6 tmp) 
		    nth(7 tmp)
		)) 
	    when((axlFormGetField 
		    (trl_altium2hdl_global->formid) "projname_l"
		) 
		(axlFormSetField 
		    (trl_altium2hdl_global->formid) "projname_l" cdn_proj_name
		)
	    )
	)
	(file = (axlFormGetField 
		(trl_altium2hdl_global->formid) "prjpcb_l"
	    )) 
	(file = parseString(file "/")) 
	(dir = car(file)) 
	when((length(file) > 2) 
	    for(i 2 
		(length(file) - 1) 
		(dir = strcat(dir "/" 
			nth((i - 1) file)
		    ))
	    )
	) 
	(dir = strcat(dir "/"))
	foreach(data raw_data 
	    (parse_strg = parseString(data "|")) 
	    (info = ncons(nil)) 
	    foreach(prop_pair parse_strg 
		(parse_strg = parseString(prop_pair "=")) 
		when((length(parse_strg) == 2) 
		    putprop(info 
			cadr(parse_strg) 
			stringToSymbol(car(parse_strg))
		    )
		)
	    )
	    (SchematicData = cons(info SchematicData)) 
	    (info = ncons(nil))
	) 
	if(SchematicData then 
	    foreach(rec SchematicData 
		(record = get(rec 
			'Record
		    )) 
		(TopName = get(rec 
			'FileName
		    )) 
		when((record == "TopLevelDocument") 
		    (FileName = strcat(dir TopName)) 
		    (proj_pars = parseString(TopName ".")) 
		    (design_name = car(proj_pars)) 
		    when((length(proj_pars) > 2) 
			for(i 2 
			    (length(proj_pars) - 1) 
			    (design_name = strcat(design_name "." 
				    nth((i - 1) proj_pars)
				))
			)
		    )
		    (design_name = TRL_ALTIUM2HDL_PCB_Util_Namemaper(design_name)) 
		    (design_name = lowerCase(design_name)) 
		    (tmp = (trl_altium2hdl_global->files)) 
		    (trl_altium2hdl_global->files = list(car(tmp) 
			    cadr(tmp) 
			    caddr(tmp) 
			    cadddr(tmp) 
			    nth(4 tmp)
			    nth(5 tmp) design_name 
			    nth(7 tmp)
			)) 
		    when((axlFormGetField 
			    (trl_altium2hdl_global->formid) "designname_l"
			) 
			(axlFormSetField 
			    (trl_altium2hdl_global->formid) "designname_l" design_name
			)
		    )
		    (TopLevelDoc = list(list(design_name design_name TopName)))
		)
		when((record == "SheetSymbol") 
		    (FileName = strcat(dir TopName)) 
		    unless(isFile(FileName) 
			(FileName = nil)
		    ) 
		    (proj_pars = parseString(TopName ".")) 
		    (design_name = car(proj_pars))
		    when((length(proj_pars) > 2) 
			for(i 2 
			    (length(proj_pars) - 1) 
			    (design_name = strcat(design_name "." 
				    nth((i - 1) proj_pars)
				))
			)
		    ) 
		    (design_name = TRL_ALTIUM2HDL_PCB_Util_Namemaper(design_name)) 
		    (design_name = lowerCase(design_name)) 
		    (SheetSymbol = cons(list(design_name 
				lowerCase(TRL_ALTIUM2HDL_PCB_Util_Namemaper(get(rec 
					    'SchDesignator
					)
				    )
				) TopName
			    ) SheetSymbol
			))
		)
	    ) 
	    (trl_altium2hdl_global->exeption = cons(sprintf(nil "   7.2.06 INFO    - PRJRawList: CDS_Proj_Name: %L Proj_Name: %L Design_Name: %L" cdn_proj_name proj_name design_name) 
		    (trl_altium2hdl_global->exeption)
		)) else
	    (trl_altium2hdl_global->exeption = cons(sprintf(nil "-->7.2.06 ERROR   - PRJRawList NOT generated! row_data: %L proj_data: %L" raw_data SchematicData) 
		    (trl_altium2hdl_global->exeption)
		))
	) 
	list(TopLevelDoc SheetSymbol)
    )
)
procedure(TRL_ALTIUM2HDL_SCH_SetUp_Advanced_Form() 
    let(nil 
	(axlFormSetField 
	    (trl_altium2hdl_global->formid) "frame_size" "custom"
	) 
	(axlFormSetField 
	    (trl_altium2hdl_global->formid) "reference_l" "./reference.ref"
	) 
	(axlFormSetFieldEditable 
	    (trl_altium2hdl_global->formid) "create_reference" nil
	) 
	(axlFormSetFieldEditable 
	    (trl_altium2hdl_global->formid) "projloc_l" nil
	)
	(axlFormSetFieldEditable 
	    (trl_altium2hdl_global->formid) "libname" nil
	) 
	(axlFormSetFieldEditable 
	    (trl_altium2hdl_global->formid) "designname" nil
	) 
	(axlFormSetFieldEditable 
	    (trl_altium2hdl_global->formid) "SchDoc_l" nil
	) 
	(axlFormSetFieldEditable 
	    (trl_altium2hdl_global->formid) "SchDoc" t
	) 
	(axlFormSetFieldEditable 
	    (trl_altium2hdl_global->formid) "SchDocDir_l" nil
	)
	(axlFormSetFieldEditable 
	    (trl_altium2hdl_global->formid) "SchDocDir" t
	) 
	(axlFormSetFieldEditable 
	    (trl_altium2hdl_global->formid) "project_setup" nil
	) 
	(axlFormSetFieldEditable 
	    (trl_altium2hdl_global->formid) "create_symbols" nil
	) 
	(axlFormSetFieldEditable 
	    (trl_altium2hdl_global->formid) "create_sch" nil
	) 
	(axlFormSetFieldEditable 
	    (trl_altium2hdl_global->formid) "prjpcb_l" nil
	)
	(axlFormSetField 
	    (trl_altium2hdl_global->formid) "license" "Concept_HDL_studio"
	) 
	(axlFormSetField 
	    (trl_altium2hdl_global->formid) "libname_l" "altium_lib"
	) 
	(axlFormSetField 
	    (trl_altium2hdl_global->formid) "designname_l" ""
	)
    )
)
procedure(TRL_ALTIUM2HDL_SCH_Util_Font_ID(input) 
    let((params font_size font_name font_rot font_vis) 
	(params = car((trl_altium2hdl_global->SchRawList))) 
	(params = caddr(params)) 
	(params = car(params)) 
	if(params then 
	    (font_size = stringToSymbol(sprintf(nil "SIZE%s" input))) 
	    (font_name = stringToSymbol(sprintf(nil "FONTNAME%s" input))) 
	    (font_rot = stringToSymbol(sprintf(nil "ROTATION%s" input)))
	    (font_size = get(params font_size)) 
	    (font_name = get(params font_name)) 
	    (font_rot = get(params font_rot)) 
	    (font_vis = nil) 
	    if(font_size then 
		(font_size = abs((atoi(font_size) * 3))) 
		if((font_size > 0) then 
		    (font_vis = t) else 
		    (font_vis = nil)
		) else
		(font_size = 28)
	    )
	    else 
	    (font_size = 28) 
	    (font_name = nil) 
	    (font_rot = 0.0) 
	    (font_vis = t)
	)
	list(font_size font_name font_rot font_vis)
    )
)
procedure(TRL_ALTIUM2HDL_SCH_Util_Octal_Namemaper(inp_string) 
    let((replace_list pat new_string) 
	(replace_list = list(list('\\355 "Deg") 
		list('\\251 "C") 
		list('\\334 "Ue") 
		list('\\374 "ue") 
		list('\\326 "Oe")
		list('\\366 "oe") 
		list('\\304 "Ae") 
		list('\\344 "ae") 
		list('\\265 "u") 
		list('\\226 "_")
		list('\\260 "deg") 
		list('\\262 "sq") 
		list('\\223 "imp") 
		list('\\224 "imp") 
		list('\\042 "_")
	    )) 
	(new_string = inp_string) 
	foreach(specialChar replace_list 
	    (pat = pcreCompile(symbolToString(car(specialChar)))) 
	    (new_string = pcreReplace(pat new_string 
		    cadr(specialChar) 0
		))
	) new_string
    )
)
procedure(TRL_ALTIUM2HDL_SCH_Util_PCB_Namemaper(input) 
    let((a) 
	(a = a) 
	if(input then 
	    rexCompile(" ") 
	    (input = rexReplace(input "_" 0)) 
	    rexCompile("[(\"{!/%*+$=<>&?#:.,'\\})]+")
	    (input = rexReplace(input "_" 0)) else 
	    (input = "NIL-NAMEMAPPER")
	)
    )
)
procedure(TRL_ALTIUM2HDL_SCH_Util_PINNamemaper(input) 
    let((invert) 
	if(input then 
	    rexCompile(" ") 
	    (input = rexReplace(input "_" 0)) 
	    rexCompile("-")
	    (input = rexReplace(input "N" 0)) 
	    rexCompile("[+]") 
	    (input = rexReplace(input "P" 0)) 
	    rexCompile("(") 
	    (input = rexReplace(input "_" 0))
	    rexCompile(")") 
	    (input = rexReplace(input "_" 0)) 
	    rexCompile("\\[") 
	    (input = rexReplace(input "_" 0)) 
	    rexCompile("\\]")
	    (input = rexReplace(input "_" 0)) 
	    rexCompile("[({'!/%*$=<>&?#:.,~})]+") 
	    (input = rexReplace(input "_" 0)) 
	    (invert = parseString(input "\\")) 
	    if((length(invert) > 1) then 
		(input = "") 
		foreach(char invert 
		    (input = sprintf(nil "%s%s" input char))
		) 
		(input = sprintf(nil "%s_NNN" input))
		else 
		(input = car(invert))
	    )
	    else 
	    (input = "NIL-NAMEMAPPER")
	) input
    )
)
procedure(TRL_ALTIUM2HDL_SCH_Util_Property_Value_Mapper(input) 
    let((a) 
	(a = a) 
	if(input then input else 
	    (input = "NIL-NAMEMAPPER")
	)
    )
)
procedure(TRL_ALTIUM2HDL_Show_Detail(tree_item) 
    let((field index outp display) 
	(field = car(tree_item)) 
	(index = caddr(tree_item)) 
	(index = car(parseString(index "]"))) 
	when((type(index) == 'string) 
	    (index = (atoi(index) - 1)) 
	    case(field 
		("Signal" 
		    (display = list("TRL_ALTIUM2HDL_Global_SIGNAL"))
		) 
		(t t)
	    ) 
	    (display = reverse(display)) 
	    (outp = outfile("tmp.txt"))
	    foreach(i 
		reverse(display) 
		fprintf(outp "%L\n" i)
	    ) 
	    close(outp) 
	    if(isFile("tmp.txt") then 
		(axlUIViewFileCreate "tmp.txt" "Show Detail" nil) else 
		(axlUIConfirm "Unable to Open TMP File, Check Permissions!")
	    )
	)
    )
)
procedure(TRL_ALTIUM2HDL_Show_Report() 
    let((outp) 
	(outp = outfile("hdl_exeption.txt")) 
	foreach(i 
	    reverse((trl_altium2hdl_global->exeption)) 
	    fprintf(outp "%s\n" i)
	) 
	close(outp) 
	if(isFile("hdl_exeption.txt") then 
	    (axlUIViewFileCreate "hdl_exeption.txt" "Altium HDL_Translator" nil) else 
	    (axlUIConfirm "Unable to Open Help File, Check Permissions!")
	)
    )
)
procedure(TRL_ALTIUM2HDL_Tree_Item_Action(curValue) 
    let((tree_item tree_valu tree_type data) 
	(tree_item = parseString(curValue " ")) 
	(tree_valu = caddr(tree_item)) 
	(tree_valu = parseString(tree_valu "]")) 
	(tree_valu = car(tree_valu))
	if(atoi(tree_valu) then 
	    (tree_valu = (atoi(tree_valu) - 1)) else 
	    (tree_valu = nil)
	) 
	(tree_type = car(tree_item)) 
	if(tree_valu then 
	    case(tree_type 
		("sym" 
		    (data = nth(tree_valu 
			    cadr((trl_altium2hdl_global->SchRawList))
			)) 
		    when(data t)
		) 
		(t 
		    printf("tree: %L\n" curValue)
		)
	    ) else 
	    printf("tree: %L\n" curValue)
	)
    )
)
procedure(TRL_ALTIUM2HDL_Tree_View() 
    let((ind refDes sym_name sym_desc sym_tree) 
	if((trl_altium2hdl_global->SchRawList) then 
	    foreach(schematic 
		(trl_altium2hdl_global->SchRawList) 
		(sym_tree = (axlFormTreeViewAddItem 
			(trl_altium2hdl_global->formid) "tree" 
			sprintf(nil "Schematic: %L Symbols [%d]" 
			    car(schematic) 
			    length(cadddr(schematic))
			) nil
			nil nil
		    )) 
		(ind = 1) 
		foreach(sym 
		    cadddr(schematic) 
		    (refDes = length(sym)) 
		    foreach(rec sym 
			when((get(rec 
				    'NAME
				) == "Designator") 
			    (refDes = get(rec 
				    'TEXT
				))
			) 
			when(get(rec 
				'LIBREFERENCE
			    ) 
			    (sym_name = get(rec 
				    'LIBREFERENCE
				)) 
			    (sym_desc = get(rec 
				    'COMPONENTDESCRIPTION
				))
			)
		    ) 
		    (sym = sprintf(nil "sym [%4d] %L \t %L \t %L" ind refDes sym_name
			    sym_desc
			))
		    (axlFormTreeViewAddItem 
			(trl_altium2hdl_global->formid) "tree" sym sym_tree
			nil t
		    ) 
		    ind++
		)
	    ) else 
	    (sym_tree = (axlFormTreeViewAddItem 
		    (trl_altium2hdl_global->formid) "tree" "Schematic Symbols" nil
		    nil nil
		))
	    (axlFormTreeViewAddItem 
		(trl_altium2hdl_global->formid) "tree" "No Schematic Symbols found" sym_tree
		nil nil
	    )
	)
    )
)
procedure(TRL_ALTIUM2HDL_flow_graphic(handle) 
    let((color increment center_x center_y diameter) 
	(axlGRPDrwMapWindow handle 0 0) 
	(color = "darkgray") 
	(increment = 3600) 
	(center_x = 1700)
	(center_y = 1200) 
	(diameter = 1000) 
	foreach(color_in 
	    car((trl_altium2hdl_global->Global_GUI_Handling)) 
	    when(color_in 
		(color = color_in)
	    ) 
	    putprop(handle "filled" 
		'fill
	    ) 
	    putprop(handle color 
		'color
	    )
	    (axlGRPDrwCircle handle 
		(center_x:center_y) diameter
	    ) 
	    (center_y = (center_y + increment))
	)
    )
)
procedure(TRL_ALTIUM2PCB_BoardSetUp() 
    let((path) 
	(trl_altium2pcb_global->exeption = cons("-------------------------------------------------------------------------------" 
		(trl_altium2pcb_global->exeption)
	    )) 
	(trl_altium2pcb_global->exeption = cons("   3.0.0  INFO    - Start for Board Setup.." 
		(trl_altium2pcb_global->exeption)
	    )) 
	(trl_altium2pcb_global->exeption = cons("-------------------------------------------------------------------------------" 
		(trl_altium2pcb_global->exeption)
	    )) 
	(trl_altium2pcb_global->exeption = cons("   3.0.1  INFO    - Start to clear all existing data first" 
		(trl_altium2pcb_global->exeption)
	    ))
	(trl_altium2pcb_global->exeption = cons("-------------------------------------------------------------------------------" 
		(trl_altium2pcb_global->exeption)
	    )) 
	(axlSetFindFilter ?enabled 
	    list("all") ?onButtons 
	    list("all")
	) 
	(axlAddSelectAll) 
	(axlDeleteObject 
	    (axlGetSelSet)
	) 
	if(axlGetVariable("drawing_4mils") then 
	    (axlDBChangeDesignUnits "mils" 4) else 
	    (axlDBChangeDesignUnits "mils" 2)
	)
	(axlUIWPrint 
	    (trl_altium2pcb_global->formid) "   3.2.0  INFO    - Start to Add Board Records"
	) 
	(trl_altium2pcb_global->exeption = cons("   3.2.0  INFO    - Start to Add Board Records" 
		(trl_altium2pcb_global->exeption)
	    )) 
	(path = TRL_ALTIUM2PCB_Create_BoardRecords()) 
	TRL_ALTIUM2PCB_Create_BoardOutline(path) 
	(axlUIWPrint 
	    (trl_altium2pcb_global->formid) "   3.2.1  INFO    - Start to Add Board BoardOutline"
	)
	TRL_ALTIUM2PCB_Create_CutOut() 
	TRL_ALTIUM2PCB_CREATE_RoutPlace_Keepin(path) 
	(axlUIWPrint 
	    (trl_altium2pcb_global->formid) "   3.2.2  INFO    - Start to Add RoutPlace_Keepin"
	) 
	TRL_ALTIUM2PCB_CREATE_KeepOut() 
	(axlUIWPrint 
	    (trl_altium2pcb_global->formid) "   3.2.3  INFO    - Start to Add KeepOut"
	)
	(trl_altium2pcb_global->exeption = cons("   3.4.0  INFO    - Start to Add Negative Planes" 
		(trl_altium2pcb_global->exeption)
	    )) 
	(axlUIWPrint 
	    (trl_altium2pcb_global->formid) "   3.4.0  INFO    - Start to Add Negative Planes"
	) 
	TRL_ALTIUM2PCB_CreateNegativePlanes() 
	(trl_altium2pcb_global->exeption = cons("   3.5.0  INFO    - Start to Add Board Sheet Data" 
		(trl_altium2pcb_global->exeption)
	    )) 
	(axlUIWPrint 
	    (trl_altium2pcb_global->formid) "   3.5.0  INFO    - Start to Add Board Sheet Data"
	)
	TRL_ALTIUM2PCB_CreateSheet(path) 
	(trl_altium2pcb_global->exeption = cons("   3.6.0  INFO    - Start to Add Board Geometry Elements" 
		(trl_altium2pcb_global->exeption)
	    )) 
	(axlUIWPrint 
	    (trl_altium2pcb_global->formid) "   3.6.1  INFO    - Start to Add Board Geometry Elements"
	) 
	TRL_ALTIUM2PCB_CREATE_Board_Segments() 
	(axlUIWPrint 
	    (trl_altium2pcb_global->formid) "   3.6.2  INFO    - Start to Add Board Geometry Segments"
	)
	TRL_ALTIUM2PCB_CREATE_Board_Arcs() 
	(axlUIWPrint 
	    (trl_altium2pcb_global->formid) "   3.6.3  INFO    - Start to Add Board Geometry Arcs"
	) 
	TRL_ALTIUM2PCB_CREATE_Board_Fills() 
	(axlUIWPrint 
	    (trl_altium2pcb_global->formid) "   3.6.4  INFO    - Start to Add Board Geometry Fills"
	) 
	TRL_ALTIUM2PCB_CREATE_Board_Region()
	(axlUIWPrint 
	    (trl_altium2pcb_global->formid) "   3.6.5  INFO    - Start to Add Board Geometry Region"
	) 
	TRL_ALTIUM2PCB_CREATE_Mechanical_Holes() 
	(axlUIWPrint 
	    (trl_altium2pcb_global->formid) "   3.6.6  INFO    - Start to Add Board Geometry Holes"
	) 
	(trl_altium2pcb_global->exeption = cons("   3.7.0  INFO    - Start for Color Settings" 
		(trl_altium2pcb_global->exeption)
	    )) 
	(axlUIWPrint 
	    (trl_altium2pcb_global->formid) "   3.7.0  INFO    - Start for Color Settings"
	)
	TRL_ALTIUM2PCB_GetColorStack() 
	(trl_altium2pcb_global->exeption = cons("   3.8.0  INFO    - Start for Text Block Settings" 
		(trl_altium2pcb_global->exeption)
	    )) 
	(axlUIWPrint 
	    (trl_altium2pcb_global->formid) "   3.8.0  INFO    - Start for Text Block Settings"
	) 
	(trl_altium2pcb_global->exeption = cons("                  -------------------------------------------------------------" 
		(trl_altium2pcb_global->exeption)
	    )) 
	TRL_ALTIUM2PCB_CREATE_Board_Text()
	(trl_altium2pcb_global->exeption = cons("   3.9.0  INFO    - Start for Default Rules AND Settings" 
		(trl_altium2pcb_global->exeption)
	    )) 
	(axlUIWPrint 
	    (trl_altium2pcb_global->formid) "   3.9.0  INFO    - Start for Default Rules AND Settings"
	) 
	TRL_ALTIUM2PCB_Default_Rules()
    )
)
procedure(TRL_ALTIUM2PCB_CREATE_AltiumDefaultLayers() 
    let((Layer) 
	(Layer = (axlLayerGet "Board Geometry/Pastemask_Top")) 
	unless(Layer 
	    (axlLayerCreateNonConductor "Board Geometry/Pastemask_Top")
	) 
	(Layer = (axlLayerGet "Board Geometry/Pastemask_Bottom")) 
	unless(Layer 
	    (axlLayerCreateNonConductor "Board Geometry/Pastemask_Bottom")
	)
	(Layer = (axlLayerGet "Board Geometry/Soldermask_Top")) 
	unless(Layer 
	    (axlLayerCreateNonConductor "Board Geometry/Soldermask_Top")
	) 
	(Layer = (axlLayerGet "Board Geometry/Soldermask_Bottom")) 
	unless(Layer 
	    (axlLayerCreateNonConductor "Board Geometry/Soldermask_Bottom")
	) 
	(Layer = (axlLayerGet "Board Geometry/Silkscreen_Top"))
	unless(Layer 
	    (axlLayerCreateNonConductor "Board Geometry/Silkscreen_Top")
	) 
	(Layer = (axlLayerGet "Board Geometry/Silkscreen_Bottom")) 
	unless(Layer 
	    (axlLayerCreateNonConductor "Board Geometry/Silkscreen_Bottom")
	) 
	(Layer = (axlLayerGet "Board Geometry/Multilayer")) 
	unless(Layer 
	    (axlLayerCreateNonConductor "Board Geometry/Multilayer")
	)
	(Layer = (axlLayerGet "Package Geometry/Multilayer")) 
	unless(Layer 
	    (axlLayerCreateNonConductor "Package Geometry/Multilayer")
	) 
	(Layer = (axlLayerGet "Manufacturing/DRILLGUIDE")) 
	unless(Layer 
	    (axlLayerCreateNonConductor "Manufacturing/DRILLGUIDE")
	) 
	(Layer = (axlLayerGet "Package Geometry/Place_Bound_Top"))
	(Layer->pattern = 1) 
	(axlLayerSet Layer) 
	(Layer = (axlLayerGet "Package Geometry/Place_Bound_Bottom")) 
	(Layer->pattern = 1) 
	(axlLayerSet Layer)
	(Layer = (axlGetParam "paramLayerGroup:Constraint Region")) 
	(Layer->pattern = 2) 
	(axlSetParam Layer) 
	(Layer = (axlGetParam "paramLayerGroup:Route Keepout")) 
	(Layer->pattern = 2)
	(axlSetParam Layer) 
	(Layer = (axlGetParam "paramLayerGroup:Via Keepout")) 
	(Layer->pattern = 2) 
	(axlSetParam Layer) 
	(Layer = (axlGetParam "paramLayerGroup:Package Keepout"))
	(Layer->pattern = 2) 
	(axlSetParam Layer) 
	(axlLayerPrioritySet "PACKAGE GEOMETRY/Silkscreen_Top" 1) 
	(axlLayerPrioritySet "BOARD GEOMETRY/Silkscreen_Top" 2) 
	(axlLayerPrioritySet "PACKAGE GEOMETRY/Silkscreen_Bottom" 3)
	(axlLayerPrioritySet "BOARD GEOMETRY/Silkscreen_Bottom" 4) 
	(axlVisibleUpdate t)
    )
)
procedure(TRL_ALTIUM2PCB_CREATE_Arc_KeepOut(rec) 
    let((lay my r sa ea
	    w angle_s_rad angle_e_rad x1 y1
	    x2 y2 f_width t_layer V7
	    dbCreate mx pathPoly r_path shp
	) 
	(lay = get(rec 
		'LAYER
	    )) 
	(V7 = get(rec 
		'LAYER_V7
	    )) 
	(mx = TRL_ALTIUM2PCB_Util_DesignUnits(get(rec 
		    'LOCATION\.X
		)
	    )) 
	(my = TRL_ALTIUM2PCB_Util_DesignUnits(get(rec 
		    'LOCATION\.Y
		)
	    ))
	(r = TRL_ALTIUM2PCB_Util_DesignUnits(get(rec 
		    'RADIUS
		)
	    )) 
	(sa = atof(get(rec 
		    'STARTANGLE
		)
	    )) 
	(ea = atof(get(rec 
		    'ENDANGLE
		)
	    )) 
	(w = TRL_ALTIUM2PCB_Util_DesignUnits(get(rec 
		    'WIDTH
		)
	    )) 
	when((sa > ea) 
	    (ea = (ea + 360.0))
	)
	(angle_s_rad = ((sa / 360.0) * 2 * 3.141593)) 
	(angle_e_rad = ((ea / 360.0) * 2 * 3.141593)) 
	(x1 = ((cos(angle_s_rad) * r) + mx)) 
	(y1 = ((sin(angle_s_rad) * r) + my)) 
	(x2 = ((cos(angle_e_rad) * r) + mx))
	(y2 = ((sin(angle_e_rad) * r) + my)) 
	(r_path = (axlPathStart 
		list((x1:y1)) w
	    )) 
	(r_path = (axlPathArcCenter r_path w 
		(x2:y2) nil
		(mx:my)
	    )) 
	when(V7 
	    when(nth(8 
		    (trl_altium2pcb_global->settings)
		) 
		(trl_altium2pcb_global->exeption = cons(sprintf(nil "   3.3.11 INFO    - Arc Keepout V7:/%L" rec) 
			(trl_altium2pcb_global->exeption)
		    ))
	    )
	) 
	unless(lay 
	    when(nth(8 
		    (trl_altium2pcb_global->settings)
		) 
		(trl_altium2pcb_global->exeption = cons(sprintf(nil "   3.3.12 INFO    - Arc Keepout Layer:/%L" rec) 
			(trl_altium2pcb_global->exeption)
		    ))
	    ) 
	    (lay = "TOPOVERLAY")
	)
	(f_width = w) 
	(t_layer = TRL_ALTIUM2PCB_UTIL_Find_Layer(lay)) 
	(dbCreate = (axlDBCreatePath r_path "Board Geometry/ASSEMBLY_DETAIL")) 
	if(dbCreate then 
	    (pathPoly = (axlPolyFromDB 
		    caar(dbCreate)
		)) 
	    (axlDeleteObject 
		car(dbCreate)
	    ) 
	    case(upperCase(lay) 
		("KEEPOUT" 
		    (t_layer = "ROUTE KEEPOUT/ALL") 
		    (shp = (axlDBCreateShape 
			    car(pathPoly) t t_layer
			))
		) 
		("MULTILAYER" 
		    (t_layer = "ROUTE KEEPOUT/ALL") 
		    (shp = (axlDBCreateShape 
			    car(pathPoly) t t_layer
			))
		) 
		(t 
		    if((car(t_layer) == "ETCH") then 
			(t_layer = strcat("ROUTE KEEPOUT" "/" 
				cadr(t_layer)
			    )) 
			(shp = (axlDBCreateShape 
				car(pathPoly) t t_layer
			    )) else
			unless((axlLayerGet 
				sprintf(nil "BOARD GEOMETRY/Keepout_%s" 
				    cadr(t_layer)
				)
			    ) 
			    (axlLayerCreateNonConductor 
				sprintf(nil "BOARD GEOMETRY/Keepout_%s" 
				    cadr(t_layer)
				)
			    )
			) 
			(t_layer = sprintf(nil "BOARD GEOMETRY/Keepout_%s" 
				cadr(t_layer)
			    )) 
			(shp = (axlDBCreateShape 
				car(pathPoly) t t_layer
			    ))
		    )
		)
	    )
	    unless(shp 
		(trl_altium2pcb_global->exeption = cons(sprintf(nil "-->3.3.14 ERROR   - KEEPOUT NOT Created! Check ArcRecords %L !! %L %L" rec 
			    (mx:my) f_width
			) 
			(trl_altium2pcb_global->exeption)
		    ))
	    ) else 
	    (trl_altium2pcb_global->exeption = cons(sprintf(nil "-->3.3.15 ERROR   - KEEPOUT NOT Created! Check ArcRecords %L !! %L %L" rec 
			(mx:my) f_width
		    ) 
		    (trl_altium2pcb_global->exeption)
		))
	)
    )
)
procedure(TRL_ALTIUM2PCB_CREATE_Board_Arcs() 
    let((ArcRecords cmp net lay my
	    r sa ea w poly
	    keepout angle_s_rad angle_e_rad x1 y1
	    x2 y2 f_width t_layer V7
	    dbCreate mx r_path
	) 
	(ArcRecords = nth(7 
		(trl_altium2pcb_global->PcbRawList)
	    )) 
	when(ArcRecords 
	    foreach(rec ArcRecords 
		(keepout = get(rec 
			'KEEPOUT
		    )) 
		unless(keepout 
		    (cmp = get(rec 
			    'COMPONENT
			)) 
		    (net = get(rec 
			    'NET
			)) 
		    (lay = get(rec 
			    'LAYER
			)) 
		    (V7 = get(rec 
			    'LAYER_V7
			))
		    (mx = TRL_ALTIUM2PCB_Util_DesignUnits(get(rec 
				'LOCATION\.X
			    )
			)) 
		    (my = TRL_ALTIUM2PCB_Util_DesignUnits(get(rec 
				'LOCATION\.Y
			    )
			)) 
		    (r = TRL_ALTIUM2PCB_Util_DesignUnits(get(rec 
				'RADIUS
			    )
			)) 
		    (sa = atof(get(rec 
				'STARTANGLE
			    )
			)) 
		    (ea = atof(get(rec 
				'ENDANGLE
			    )
			))
		    (w = TRL_ALTIUM2PCB_Util_DesignUnits(get(rec 
				'WIDTH
			    )
			)) 
		    (poly = get(rec 
			    'POLYGON
			)) 
		    when((sa > ea) 
			(ea = (ea + 360.0))
		    ) 
		    (angle_s_rad = ((sa / 360.0) * 2 * 3.141593)) 
		    (angle_e_rad = ((ea / 360.0) * 2 * 3.141593))
		    (x1 = ((cos(angle_s_rad) * r) + mx)) 
		    (y1 = ((sin(angle_s_rad) * r) + my)) 
		    (x2 = ((cos(angle_e_rad) * r) + mx)) 
		    (y2 = ((sin(angle_e_rad) * r) + my)) 
		    (r_path = (axlPathStart 
			    list((x1:y1)) w
			))
		    (r_path = (axlPathArcCenter r_path w 
			    (x2:y2) nil
			    (mx:my)
			)) 
		    unless(cmp 
			unless(net 
			    when(V7 
				when(nth(8 
					(trl_altium2pcb_global->settings)
				    ) 
				    (trl_altium2pcb_global->exeption = cons(sprintf(nil "   3.6.21 INFO    - Fill Layer V7:/%L" rec) 
					    (trl_altium2pcb_global->exeption)
					))
				)
			    ) 
			    unless(lay 
				when(nth(8 
					(trl_altium2pcb_global->settings)
				    ) 
				    (trl_altium2pcb_global->exeption = cons(sprintf(nil "   3.6.22 INFO    - Fill Layer:/%L" rec) 
					    (trl_altium2pcb_global->exeption)
					))
				) 
				(lay = "TOPOVERLAY")
			    ) 
			    (f_width = w) 
			    (t_layer = TRL_ALTIUM2PCB_UTIL_Find_Layer(lay))
			    foreach(layer 
				(trl_altium2pcb_global->LayerStack) 
				when(((cadr(t_layer) == cadr(layer)) && (car(layer) < 55) && (car(layer) > 38)) 
				    (t_layer = list("ANTI ETCH" 
					    cadr(t_layer)
					))
				)
			    ) 
			    if(poly then 
				case(poly 
				    ("-2" 
					unless((axlLayerGet "Board Geometry/pullback") 
					    (axlLayerCreateNonConductor "Board Geometry/pullback")
					) 
					(dbCreate = (axlDBCreatePath r_path "Board Geometry/pullback"))
				    ) 
				    (t 
					(trl_altium2pcb_global->exeption = cons(sprintf(nil "-->3.6.24 ERROR   - ARC Poly here!%L" rec) 
						(trl_altium2pcb_global->exeption)
					    ))
				    )
				) else 
				if((cadr(t_layer) == "KEEPOUT") then 
				    (t_layer = "Board Geometry/Keepout_All") 
				    unless((axlLayerGet "Board Geometry/Keepout_All") 
					(axlLayerCreateNonConductor "Board Geometry/Keepout_All")
				    ) 
				    (dbCreate = (axlDBCreatePath r_path t_layer))
				    when(nth(8 
					    (trl_altium2pcb_global->settings)
					) 
					(trl_altium2pcb_global->exeption = cons(sprintf(nil "   3.6.28 WARNING - Track - Check ArcRecords This is unusall here %L %L %L" rec f_width t_layer) 
						(trl_altium2pcb_global->exeption)
					    ))
				    ) else 
				    (t_layer = strcat(car(t_layer) "/" 
					    cadr(t_layer)
					)) 
				    (dbCreate = (axlDBCreatePath r_path t_layer))
				)
				unless(dbCreate 
				    (trl_altium2pcb_global->exeption = cons(sprintf(nil "-->3.6.29 ERROR   - Arc NOT Created! Check TrackRecords %L !! %L %L %L" rec 
						(mx:my) f_width
						t_layer
					    ) 
					    (trl_altium2pcb_global->exeption)
					))
				)
			    )
			)
		    )
		)
	    )
	)
    )
)
procedure(TRL_ALTIUM2PCB_CREATE_Board_Fills() 
    let((FillRecords net lay cmp V7
	    x1 y1 x2 y2 rot
	    dbCreate signal l_points t_layer keepout
	) 
	(FillRecords = caddr(nth(13 
		    (trl_altium2pcb_global->PcbRawList)
		)
	    )) 
	if(FillRecords then 
	    foreach(rec FillRecords 
		(net = get(rec 
			'NET
		    )) 
		(lay = get(rec 
			'LAYER
		    )) 
		(cmp = get(rec 
			'COMPONENT
		    ))
		(V7 = get(rec 
			'LAYER_V7
		    )) 
		(x1 = TRL_ALTIUM2PCB_Util_DesignUnits(get(rec 
			    'X1
			)
		    )) 
		(y1 = TRL_ALTIUM2PCB_Util_DesignUnits(get(rec 
			    'Y1
			)
		    )) 
		(x2 = TRL_ALTIUM2PCB_Util_DesignUnits(get(rec 
			    'X2
			)
		    )) 
		(y2 = TRL_ALTIUM2PCB_Util_DesignUnits(get(rec 
			    'Y2
			)
		    ))
		(rot = atof(get(rec 
			    'ROTATION
			)
		    )) 
		(keepout = get(rec 
			'KEEPOUT
		    )) 
		when(V7 
		    when(nth(8 
			    (trl_altium2pcb_global->settings)
			) 
			(trl_altium2pcb_global->exeption = cons(sprintf(nil "   3.6.31 INFO    - Fill Layer V7:/%L" rec) 
				(trl_altium2pcb_global->exeption)
			    ))
		    )
		) 
		unless(lay 
		    when(nth(8 
			    (trl_altium2pcb_global->settings)
			) 
			(trl_altium2pcb_global->exeption = cons(sprintf(nil "   3.6.32 INFO    - Fill Layer:/%L" rec) 
				(trl_altium2pcb_global->exeption)
			    ))
		    ) 
		    (lay = "TOPOVERLAY")
		) 
		unless((net || cmp || keepout) 
		    (t_layer = TRL_ALTIUM2PCB_UTIL_Find_Layer(lay)) 
		    (t_layer = strcat(car(t_layer) "/" 
			    cadr(t_layer)
			)) 
		    (l_points = list((x1:y1) 
			    (x2:y2)
			)) 
		    (signal = nil)
		    (dbCreate = (axlDBCreateRectangle l_points t t_layer signal)) 
		    when((dbCreate && (rot > 0)) 
			(axlTransformObject dbCreate ?angle rot)
		    ) 
		    unless(dbCreate 
			(trl_altium2pcb_global->exeption = cons(sprintf(nil "-->3.6.33 ERROR   - Fill NOT Created! Check FillRecords %L !!" rec) 
				(trl_altium2pcb_global->exeption)
			    ))
		    )
		)
	    )
	)
    )
)
procedure(TRL_ALTIUM2PCB_CREATE_Board_Region() 
    let((RegionRecords layer spolyi l_points path
	    shp V7 t_layer keepout
	) 
	(RegionRecords = cadddr(nth(12 
		    (trl_altium2pcb_global->PcbRawList)
		)
	    )) 
	when(RegionRecords 
	    foreach(rec RegionRecords 
		(keepout = get(rec 
			'KEEPOUT
		    )) 
		unless(keepout 
		    (shp = nil) 
		    (layer = get(rec 
			    'LAYER
			)) 
		    (spolyi = get(rec 
			    'SUBPOLYINDEX
			)) 
		    (V7 = get(rec 
			    'LAYER_V7
			))
		    (l_points = TRL_ALTIUM2PCB_GetPolyPath(rec)) 
		    if(l_points then 
			(path = TRL_ALTIUM2PCB_ComplexPolyPath(l_points)) else 
			(trl_altium2pcb_global->exeption = cons(sprintf(nil "-->3.6.47 ERROR   - Shape Keepou NOT Created - Confused Path! Layer: %L / %L / REC: %L" layer spolyi rec) 
				(trl_altium2pcb_global->exeption)
			    ))
		    ) 
		    if((spolyi == "-1") then 
			if(path then 
			    when(V7 
				when(nth(8 
					(trl_altium2pcb_global->settings)
				    ) 
				    (trl_altium2pcb_global->exeption = cons(sprintf(nil "   3.6.41 INFO    - Shape Keepout V7:/%L" rec) 
					    (trl_altium2pcb_global->exeption)
					))
				)
			    ) 
			    unless(layer 
				when(nth(8 
					(trl_altium2pcb_global->settings)
				    ) 
				    (trl_altium2pcb_global->exeption = cons(sprintf(nil "   3.6.42 INFO    - Shape Keepout Layer:/%L" rec) 
					    (trl_altium2pcb_global->exeption)
					))
				) 
				(layer = "TOPOVERLAY")
			    ) 
			    (t_layer = TRL_ALTIUM2PCB_UTIL_Find_Layer(layer))
			    unless((axlLayerGet 
				    sprintf(nil "%s/%s" 
					car(t_layer) 
					cadr(t_layer)
				    )
				) 
				(axlLayerCreateNonConductor 
				    sprintf(nil "%s/%s" 
					car(t_layer) 
					cadr(t_layer)
				    )
				)
			    ) 
			    (t_layer = sprintf(nil "%s/%s" 
				    car(t_layer) 
				    cadr(t_layer)
				)) 
			    (shp = (axlDBCreateShape path t t_layer)) 
			    unless(shp 
				(axlDBCreatePath path "Board Geometry/Assembly_Detail") 
				(trl_altium2pcb_global->exeption = cons(sprintf(nil "-->3.6.45 ERROR   - Shape Keepou NOT Created! Path: %L Layer: %L / %L / SUBPOLYINDEX: %L" path t_layer layer
					    spolyi
					) 
					(trl_altium2pcb_global->exeption)
				    )) 
				(axlDBCreateShape path t "Board Geometry/Assembly_Detail")
			    ) else
			    when(l_points 
				(axlDBCreateLine l_points 1.0 "Board Geometry/Assembly_Detail")
			    ) 
			    (trl_altium2pcb_global->exeption = cons(sprintf(nil "-->3.6.46 ERROR   - Shape Keepout NOT Created! Check PolyRecords %L !!" rec) 
				    (trl_altium2pcb_global->exeption)
				))
			) else 
			when(path 
			    (axlDBCreatePath path "Board Geometry/Assembly_Detail")
			)
			when(nth(8 
				(trl_altium2pcb_global->settings)
			    ) 
			    (trl_altium2pcb_global->exeption = cons(sprintf(nil "   3.6.47 WARNING - Shape Keepou NOT Created! Layer: %L / %L / PolyI = %L" t_layer layer spolyi) 
				    (trl_altium2pcb_global->exeption)
				))
			)
		    )
		)
	    )
	)
    )
)
procedure(TRL_ALTIUM2PCB_CREATE_Board_Segments() 
    let((TrackRecords lay x1 y1 x2
	    y2 w t_layer l_points f_width
	    dbCreate V7 poly keepout pathPoly
	    PolyFromDB dbCreateS
	) 
	(TrackRecords = caddr(nth(10 
		    (trl_altium2pcb_global->PcbRawList)
		)
	    )) 
	when(TrackRecords 
	    foreach(rec TrackRecords 
		(keepout = get(rec 
			'KEEPOUT
		    )) 
		unless(keepout 
		    (lay = get(rec 
			    'LAYER
			)) 
		    (x1 = TRL_ALTIUM2PCB_Util_DesignUnits(get(rec 
				'X1
			    )
			)) 
		    (y1 = TRL_ALTIUM2PCB_Util_DesignUnits(get(rec 
				'Y1
			    )
			)) 
		    (x2 = TRL_ALTIUM2PCB_Util_DesignUnits(get(rec 
				'X2
			    )
			))
		    (y2 = TRL_ALTIUM2PCB_Util_DesignUnits(get(rec 
				'Y2
			    )
			)) 
		    (w = TRL_ALTIUM2PCB_Util_DesignUnits(get(rec 
				'WIDTH
			    )
			)) 
		    (poly = get(rec 
			    'POLYGON
			)) 
		    (V7 = get(rec 
			    'LAYER_V7
			)) 
		    when(V7 
			(lay = V7)
		    )
		    (l_points = list((x1:y1) 
			    (x2:y2)
			)) 
		    (f_width = w) 
		    (t_layer = TRL_ALTIUM2PCB_UTIL_Find_Layer(lay)) 
		    foreach(layer 
			(trl_altium2pcb_global->LayerStack) 
			when(((cadr(t_layer) == cadr(layer)) && (car(layer) < 55) && (car(layer) > 38)) 
			    (t_layer = list("ANTI ETCH" 
				    cadr(t_layer)
				))
			)
		    ) 
		    if(((lay == "KEEPOUT") && (keepout == "TRUE")) then 
			if(poly then 
			    printf("--Trac Poly here at keepout! %L\n" rec) else 
			    (dbCreate = (axlDBCreateLine l_points f_width "Board Geometry/ASSEMBLY_DETAIL"))
			    if(dbCreate then 
				(pathPoly = (axlPolyFromDB 
					caar(dbCreate) ?endCapType 
					'SQUARE
				    )) 
				(axlDeleteObject 
				    caar(dbCreate)
				) 
				(dbCreate = (axlDBCreateShape 
					car(pathPoly) t "PACKAGE KEEPOUT/ALL"
				    ))
				(dbCreate = (axlDBCreateShape 
					car(pathPoly) t "VIA KEEPOUT/ALL"
				    )) 
				(dbCreate = (axlDBCreateShape 
					car(pathPoly) t "ROUTE KEEPOUT/ALL"
				    )) 
				unless(dbCreate 
				    (trl_altium2pcb_global->exeption = cons(sprintf(nil "-->3.7.04 ERROR   - KEEPOUT NOT Created! Check TrackRecords %L !! %L %L" rec l_points f_width) 
					    (trl_altium2pcb_global->exeption)
					))
				) else 
				(trl_altium2pcb_global->exeption = cons(sprintf(nil "-->3.7.03 ERROR   - KEEPOUT NOT Created! Check TrackRecords %L !! %L %L" rec l_points f_width) 
					(trl_altium2pcb_global->exeption)
				    ))
			    )
			) else 
			if(poly then 
			    case(poly 
				("-2" 
				    unless((axlLayerGet "Board Geometry/pullback") 
					(axlLayerCreateNonConductor "Board Geometry/pullback")
				    ) 
				    (dbCreate = (axlDBCreateLine l_points f_width "Board Geometry/pullback"))
				) 
				(t 
				    (trl_altium2pcb_global->exeption = cons(sprintf(nil "-->3.7.02 WARNING - Track - Poly: %L Exist" rec) 
					    (trl_altium2pcb_global->exeption)
					))
				)
			    ) else 
			    if((cadr(t_layer) == "KEEPOUT") then 
				(t_layer = "Board Geometry/Keepout_All") 
				unless((axlLayerGet "Board Geometry/Keepout_All") 
				    (axlLayerCreateNonConductor "Board Geometry/Keepout_All")
				) 
				(dbCreate = (axlDBCreateLine l_points f_width t_layer))
				when(dbCreate 
				    (PolyFromDB = (axlPolyFromDB 
					    caar(dbCreate) ?endCapType 
					    'ROUND
					)) 
				    when(PolyFromDB 
					(dbCreateS = (axlDBCreateShape 
						car(PolyFromDB) t "PACKAGE KEEPOUT/ALL"
					    )) 
					(dbCreateS = (axlDBCreateShape 
						car(PolyFromDB) t "VIA KEEPOUT/ALL"
					    )) 
					(dbCreateS = (axlDBCreateShape 
						car(PolyFromDB) t "ROUTE KEEPOUT/ALL"
					    ))
				    ) 
				    when(dbCreateS 
					(axlDeleteObject 
					    caar(dbCreate)
					)
				    )
				) 
				when((axlFormGetField 
					(trl_altium2pcb_global->formid) "verbose"
				    ) 
				    (trl_altium2pcb_global->exeption = cons(sprintf(nil "   3.7.08 WARNING - Track - Check TrackRecords This is unusall here %L %L %L" l_points f_width t_layer) 
					    (trl_altium2pcb_global->exeption)
					))
				) else 
				(t_layer = strcat(car(t_layer) "/" 
					cadr(t_layer)
				    )) 
				(dbCreate = (axlDBCreateLine l_points f_width t_layer))
			    )
			    unless(dbCreate 
				(trl_altium2pcb_global->exeption = cons(sprintf(nil "-->3.7.02 ERROR   - Track NOT Created! Check TrackRecords %L !! %L %L %L" rec l_points f_width
					    t_layer
					) 
					(trl_altium2pcb_global->exeption)
				    ))
			    )
			)
		    )
		)
	    )
	)
    )
)
procedure(TRL_ALTIUM2PCB_CREATE_Board_Text() 
    let((lay a_layer x y x1
	    y1 x2 y2 rot height
	    txt_mirr des text txtorient textblock
	    ret ttfonts inverted invertedtb bold
	    TextRecords w font textkind l_points
	    shp t_layer
	) 
	(TextRecords = caddr(nth(11 
		    (trl_altium2pcb_global->PcbRawList)
		)
	    )) 
	when(TextRecords 
	    foreach(rec TextRecords 
		(lay = get(rec 
			'LAYER
		    )) 
		(x1 = TRL_ALTIUM2PCB_Util_DesignUnits(get(rec 
			    'X1
			)
		    )) 
		(y1 = TRL_ALTIUM2PCB_Util_DesignUnits(get(rec 
			    'Y1
			)
		    ))
		(x2 = TRL_ALTIUM2PCB_Util_DesignUnits(get(rec 
			    'X2
			)
		    )) 
		(y2 = TRL_ALTIUM2PCB_Util_DesignUnits(get(rec 
			    'Y2
			)
		    )) 
		(w = TRL_ALTIUM2PCB_Util_DesignUnits(get(rec 
			    'WIDTH
			)
		    )) 
		(x = TRL_ALTIUM2PCB_Util_DesignUnits(get(rec 
			    'X
			)
		    )) 
		(y = TRL_ALTIUM2PCB_Util_DesignUnits(get(rec 
			    'Y
			)
		    ))
		(rot = atof(get(rec 
			    'ROTATION
			)
		    )) 
		(height = TRL_ALTIUM2PCB_Util_DesignUnits(get(rec 
			    'HEIGHT
			)
		    )) 
		(txt_mirr = get(rec 
			'MIRROR
		    )) 
		(des = get(rec 
			'DESIGNATOR
		    )) 
		(text = get(rec 
			'TEXT
		    ))
		(ttfonts = get(rec 
			'USETTFONTS
		    )) 
		(inverted = get(rec 
			'INVERTED
		    )) 
		(invertedtb = TRL_ALTIUM2PCB_Util_DesignUnits(get(rec 
			    'INVERTEDTTTEXTBORDER
			)
		    )) 
		(bold = get(rec 
			'BOLD
		    )) 
		(textkind = get(rec 
			'TEXTKIND
		    ))
		(font = get(rec 
			'FONT
		    )) 
		unless(text 
		    when(nth(8 
			    (trl_altium2pcb_global->settings)
			) 
			(trl_altium2pcb_global->exeption = cons("   3.8.02 INFO    - Text string missing" 
				(trl_altium2pcb_global->exeption)
			    ))
		    )
		) 
		when(text 
		    if((txt_mirr == "TRUE") then 
			(txt_mirr = t) else 
			(txt_mirr = nil)
		    ) 
		    (l_points = (axlPathStart 
			    list((x1:y1) 
				(x1:y2) 
				(x2:y2) 
				(x2:y1) 
				(x1:y1)
			    )
			)) 
		    unless((axlLayerGet 
			    sprintf(nil "BOARD GEOMETRY/Text_%s" lay)
			) 
			(axlLayerCreateNonConductor 
			    sprintf(nil "BOARD GEOMETRY/Text_%s" lay)
			)
		    ) 
		    (t_layer = sprintf(nil "BOARD GEOMETRY/Text_%s" lay))
		    (shp = (axlDBCreateShape l_points t t_layer)) 
		    when((rot > 0) 
			when(shp 
			    (axlTransformObject shp ?angle rot)
			)
		    ) 
		    (a_layer = TRL_ALTIUM2PCB_UTIL_Find_Layer(lay)) 
		    (a_layer = strcat(car(a_layer) "/" 
			    cadr(a_layer)
			)) 
		    (textblock = nil)
		    case(textkind 
			("0" 
			    if((font == "DEFAULT") then 
				(textblock = TRL_ALTIUM2PCB_UTIL_Find_Text_Block(height w)) else 
				(textblock = TRL_ALTIUM2PCB_UTIL_Find_Serif_Text_Block(height w))
			    )
			) 
			("1" 
			    if((bold == "FALSE") then 
				(textblock = TRL_ALTIUM2PCB_UTIL_Find_TrueType_Text_Block(height w)) else 
				(textblock = TRL_ALTIUM2PCB_UTIL_Find_TrueTypeBold_Text_Block(height w))
			    )
			) 
			("2" 
			    TRL_ALTIUM2PCB_UTIL_Text_BarCode(text a_layer height x y
				rec
			    )
			) 
			(t 
			    (trl_altium2pcb_global->exeption = cons(sprintf(nil "   3.8.03 WARNING - Text BLOCK missing - %L" rec) 
				    (trl_altium2pcb_global->exeption)
				))
			)
		    ) 
		    if(textblock then 
			(txtorient = (make_axlTextOrientation ?textBlock textblock ?rotation rot
				?mirrored txt_mirr ?justify "left"
			    )) 
			(ret = (axlDBCreateText text 
				(x:y) txtorient a_layer
			    )) 
			if(ret then 
			    when(((inverted == "TRUE") && (textkind == "1")) 
				TRL_ALTIUM2PCB_UTIL_Poly_From_Text(caar(ret) a_layer l_points rec)
			    ) else 
			    (trl_altium2pcb_global->exeption = cons(sprintf(nil "-->3.8.05 ERROR   - Board_Text NOT Created! %L %L %L %L %L %L %L %L %L %L %L %L %L %L %L %L %L" lay x y
					x1 y1 x2 y2 rot
					height txt_mirr des text ttfonts
					inverted invertedtb bold w
				    ) 
				    (trl_altium2pcb_global->exeption)
				))
			)
			else 
			(trl_altium2pcb_global->exeption = cons(sprintf(nil "   3.8.04 WARNING - Text BLOCK missing - %L" rec) 
				(trl_altium2pcb_global->exeption)
			    ))
		    )
		)
	    )
	)
    )
)
procedure((TRL_ALTIUM2PCB_CREATE_Component \@optional cmp_lst) 
    let((cmp_id refDes sym_dbid mirror sym_x
	    sym_y layer rot NetsList ret_pattern
	    pins_list cmp_pins pin_nr net_id net_name
	    r_pads_list index dev_id component_id dev_name
	    symd_id symdefs_lst components_lst nets_list sch_footprint
	    sch_cmp_pins sch_cmp_pins_list electrical_pin_list electrical_pin mechanical_pin_list
	    net_dbid
	) 
	(trl_altium2pcb_global->exeption = cons("-------------------------------------------------------------------------------" 
		(trl_altium2pcb_global->exeption)
	    )) 
	unless(cmp_lst 
	    (cmp_lst = (trl_altium2pcb_global->PartsList))
	) 
	(trl_altium2pcb_global->exeption = cons(sprintf(nil "   4.0.0  INFO    - Start to Create [%L] Component Data.." 
		    length(cmp_lst)
		) 
		(trl_altium2pcb_global->exeption)
	    )) 
	if(nth(6 
		(trl_altium2pcb_global->settings)
	    ) then 
	    (trl_altium2pcb_global->exeption = cons("   4.0.1  INFO    - Footprint Mode set to Individual!" 
		    (trl_altium2pcb_global->exeption)
		)) else 
	    (trl_altium2pcb_global->exeption = cons("   4.0.1  INFO    - Footprint Mode set to Generic!" 
		    (trl_altium2pcb_global->exeption)
		))
	)
	(trl_altium2pcb_global->exeption = cons("-------------------------------------------------------------------------------" 
		(trl_altium2pcb_global->exeption)
	    )) 
	TRL_ALTIUM2PCB_UTIL_Check_DBID() 
	(symdefs_lst = cadr((trl_altium2pcb_global->UtilsList))) 
	(components_lst = caddr((trl_altium2pcb_global->UtilsList))) 
	(nets_list = nth(5 
		(trl_altium2pcb_global->UtilsList)
	    ))
	(index = 1) 
	(axlPurgePadstacks 
	    'padstacks nil
	) 
	if((nets_list && components_lst) then 
	    foreach(cmp cmp_lst 
		(electrical_pin_list = list()) 
		(dev_name = car(cmp)) 
		(refDes = nth(4 cmp))
		(sch_cmp_pins_list = list()) 
		(sch_cmp_pins = list()) 
		foreach(sch_cmp components_lst 
		    when(((sch_cmp->name) == refDes) 
			(sch_footprint = (sch_cmp->package)) 
			(sch_cmp_pins = (sch_cmp->pins)) 
			(dev_id = (sch_cmp->deviceType))
		    )
		) 
		when(sch_cmp_pins 
		    foreach(pin sch_cmp_pins 
			(sch_cmp_pins_list = cons((pin->number) sch_cmp_pins_list))
		    )
		) 
		(trl_altium2pcb_global->exeption = cons(sprintf(nil "   4.1.1  INFO    - [%L] Start Component %L with Footprint %L SCH_FOOTPRINT: %L - %L" index refDes dev_name
			    sch_footprint cmp
			) 
			(trl_altium2pcb_global->exeption)
		    ))
		(trl_altium2pcb_global->exeption = cons("-------------------------------------------------------------------------------" 
			(trl_altium2pcb_global->exeption)
		    )) 
		if(sch_footprint then 
		    (component_id = caddr(cmp)) 
		    (r_pads_list = TRL_ALTIUM2PCB_CREATE_Logical2Physical_PinMapping(sch_footprint component_id)) 
		    (pins_list = car(r_pads_list))
		    when(pins_list 
			foreach(pin pins_list 
			    if(sch_cmp_pins_list then 
				foreach(pin_s sch_cmp_pins_list 
				    when((car(pin) == pin_s) 
					(electrical_pin = pin)
				    )
				) 
				if(electrical_pin then 
				    (electrical_pin_list = cons(electrical_pin electrical_pin_list)) 
				    (electrical_pin = nil) else
				    (mechanical_pin_list = cons(pin mechanical_pin_list))
				) else
				(mechanical_pin_list = cons(pin mechanical_pin_list)) 
				printf("-->Keine SCh Pins_List: %L FOOTPRINT: %L PINS: %L %L \n" refDes sch_footprint 
				    car(pin) 
				    cadr(pin)
				)
			    )
			)
		    ) 
		    if(member(sch_footprint symdefs_lst) then 
			(trl_altium2pcb_global->exeption = cons(sprintf(nil "   4.1.2  INFO    - For Component %L Footprint %L already exist!" refDes sch_footprint) 
				(trl_altium2pcb_global->exeption)
			    )) else 
			(ret_pattern = TRL_ALTIUM2PCB_CREATE_Selected_Pattern(sch_footprint cmp sch_cmp_pins_list))
			(symd_id = car(ret_pattern)) 
			(pins_list = caadr(ret_pattern)) 
			if(symd_id then 
			    (symdefs_lst = cons(sch_footprint symdefs_lst)) 
			    (trl_altium2pcb_global->exeption = cons(sprintf(nil "   4.4.01 INFO    - Footprint %L ID: %L %L created" sch_footprint symd_id dev_id) 
				    (trl_altium2pcb_global->exeption)
				)) else
			    (trl_altium2pcb_global->exeption = cons(sprintf(nil "-->4.4.0  ERROR   - Footprint %L NOT created" symd_id) 
				    (trl_altium2pcb_global->exeption)
				))
			)
		    ) 
		    (mirror = nth(7 cmp)) 
		    if((mirror == "TOP") then 
			(mirror = nil) else 
			(mirror = t)
		    ) 
		    (sym_x = nth(5 cmp))
		    (sym_y = nth(6 cmp)) 
		    (rot = nth(9 cmp)) 
		    when(mirror 
			(rot = (rot - 180.0))
		    ) 
		    (sym_dbid = (axlDBCreateSymbol refDes 
			    (sym_x:sym_y) mirror rot
			)) 
		    if(sym_dbid then 
			(trl_altium2pcb_global->exeption = cons(sprintf(nil "   4.8.0  INFO    - Component %L placed [%L %L %L]" refDes 
				    (sym_x:sym_y) mirror
				    rot
				) 
				(trl_altium2pcb_global->exeption)
			    )) else 
			(trl_altium2pcb_global->exeption = cons(sprintf(nil "-->4.8.0  ERROR   - Component %L NOT placed [%L %L %L]" refDes 
				    (sym_x:sym_y) mirror
				    rot
				) 
				(trl_altium2pcb_global->exeption)
			    ))
		    )
		    else 
		    printf("COMPONENTS: RefDes: %L Brd:%L Sch: %L\n" refDes dev_name sch_footprint)
		) 
		(sch_footprint = nil) 
		(trl_altium2pcb_global->exeption = cons("-------------------------------------------------------------------------------" 
			(trl_altium2pcb_global->exeption)
		    )) 
		index++
	    ) else 
	    (NetsList = (trl_altium2pcb_global->NetsList))
	    foreach(cmp cmp_lst 
		(refDes = nth(4 cmp)) 
		if(refDes then 
		    if(nth(6 
			    (trl_altium2pcb_global->settings)
			) then 
			(dev_name = cadr(cmp)) else 
			(dev_name = car(cmp))
		    ) else 
		    if(nth(7 
			    (trl_altium2pcb_global->settings)
			) then 
			(dev_name = cadr(cmp)) else 
			(dev_name = car(cmp))
		    )
		) 
		(trl_altium2pcb_global->exeption = cons(sprintf(nil "   4.1.1  INFO    - [%L] Start Component %L %L with Footprint %L" index refDes cmp
			    dev_name
			) 
			(trl_altium2pcb_global->exeption)
		    ))
		if(member(dev_name symdefs_lst) then 
		    (trl_altium2pcb_global->exeption = cons(sprintf(nil "   4.1.2  INFO    - For Component %L Footprint %L already exist!" refDes dev_name) 
			    (trl_altium2pcb_global->exeption)
			)) 
		    (pins_list = nil) 
		    (component_id = caddr(cmp))
		    (r_pads_list = TRL_ALTIUM2PCB_CREATE_Logical2Physical_PinMapping(dev_name component_id)) 
		    (pins_list = car(r_pads_list)) else 
		    (trl_altium2pcb_global->exeption = cons(sprintf(nil "   4.2.0  INFO    - Start Footprint %L creation.." dev_name) 
			    (trl_altium2pcb_global->exeption)
			)) 
		    (ret_pattern = TRL_ALTIUM2PCB_CREATE_Selected_Pattern(dev_name cmp))
		    (symd_id = car(ret_pattern)) 
		    (pins_list = caadr(ret_pattern)) 
		    if(symd_id then 
			(dev_id = TRL_ALTIUM2PCB_CREATE_Device(dev_name pins_list)) 
			(trl_altium2pcb_global->exeption = cons(sprintf(nil "   4.4.01 INFO    - Footprint %L ID: %L %L created" dev_name symd_id dev_id) 
				(trl_altium2pcb_global->exeption)
			    )) 
			(symdefs_lst = cons(dev_name symdefs_lst))
			else 
			(trl_altium2pcb_global->exeption = cons(sprintf(nil "-->4.4.0  ERROR   - Footprint %L NOT created" symd_id) 
				(trl_altium2pcb_global->exeption)
			    ))
		    )
		) 
		if((refDes && pins_list) then 
		    (cmp_id = (axlDBCreateComponent refDes dev_name dev_name)) 
		    if(cmp_id then 
			(net_name = nil) 
			when(NetsList 
			    (cmp_pins = (cmp_id->pins)) 
			    foreach(pin cmp_pins 
				(pin_nr = (pin->number)) 
				foreach(rec pins_list 
				    when((upperCase(car(rec)) == upperCase(pin_nr)) 
					(net_id = nth(7 rec))
				    )
				) 
				foreach(net NetsList 
				    when((cadr(net) == net_id) 
					(net_name = car(net))
				    )
				)
				when(net_name 
				    (net_dbid = (axlChangeNet pin net_name))
				) 
				if(net_dbid then 
				    (trl_altium2pcb_global->exeption = cons(sprintf(nil "   4.7.1  INFO    - Pin: %L  Signal: %L  RefDes: %L  ID: %L created!" pin_nr net_name refDes
						net_id
					    ) 
					    (trl_altium2pcb_global->exeption)
					)) else 
				    (trl_altium2pcb_global->exeption = cons(sprintf(nil "   4.7.1  ERROR   - Pin: %L  Signal: %L  RefDes: %L  ID: %L NOT created!" pin_nr net_name refDes
						net_id
					    ) 
					    (trl_altium2pcb_global->exeption)
					))
				) 
				(net_name = nil) 
				(net_id = nil)
			    )
			) 
			(trl_altium2pcb_global->exeption = cons(sprintf(nil "   4.7.0  INFO    - Component %L created" refDes) 
				(trl_altium2pcb_global->exeption)
			    ))
			(mirror = t) 
			(sym_x = nth(5 cmp)) 
			(sym_y = nth(6 cmp)) 
			(layer = nth(7 cmp)) 
			(rot = nth(9 cmp))
			when((layer == "TOP") 
			    (mirror = nil)
			) 
			when(mirror 
			    (rot = (rot - 180.0))
			) 
			(sym_dbid = (axlDBCreateSymbol refDes 
				(sym_x:sym_y) mirror rot
			    )) 
			if(sym_dbid then 
			    (trl_altium2pcb_global->exeption = cons(sprintf(nil "   4.8.0  INFO    - Component %L placed [%L %L %L]" refDes 
					(sym_x:sym_y) mirror
					rot
				    ) 
				    (trl_altium2pcb_global->exeption)
				)) else 
			    (trl_altium2pcb_global->exeption = cons(sprintf(nil "-->4.8.0  ERROR   - Component %L NOT placed [%L %L %L]" refDes 
					(sym_x:sym_y) mirror
					rot
				    ) 
				    (trl_altium2pcb_global->exeption)
				))
			) else
			(trl_altium2pcb_global->exeption = cons(sprintf(nil "-->4.7.0  ERROR   - Component %L NOT created" refDes) 
				(trl_altium2pcb_global->exeption)
			    ))
		    ) else
		    (mirror = t) 
		    (sym_x = nth(5 cmp)) 
		    (sym_y = nth(6 cmp)) 
		    (layer = nth(7 cmp)) 
		    (rot = nth(9 cmp))
		    when((layer == "TOP") 
			(mirror = nil)
		    ) 
		    (sym_dbid = (axlDBCreateSymbol 
			    list(dev_name "mechanical") 
			    (sym_x:sym_y) mirror rot
			)) 
		    if(sym_dbid then 
			(trl_altium2pcb_global->exeption = cons(sprintf(nil "   4.8.0  INFO    - Mechanical_Cmp %L placed [%L %L %L]" dev_name 
				    (sym_x:sym_y) mirror
				    rot
				) 
				(trl_altium2pcb_global->exeption)
			    )) else 
			(trl_altium2pcb_global->exeption = cons(sprintf(nil "-->4.8.0  ERROR   - Mechanical_Cmp %L NOT placed [%L %L %L]" dev_name 
				    (sym_x:sym_y) mirror
				    rot
				) 
				(trl_altium2pcb_global->exeption)
			    ))
		    )
		) 
		(trl_altium2pcb_global->exeption = cons(sprintf(nil "   4.1.1  INFO    - END Component %L with Footprint %L" refDes dev_name) 
			(trl_altium2pcb_global->exeption)
		    )) 
		(trl_altium2pcb_global->exeption = cons("-------------------------------------------------------------------------------" 
			(trl_altium2pcb_global->exeption)
		    )) 
		index++
	    )
	)
    )
)
procedure((TRL_ALTIUM2PCB_CREATE_ComponentAndNetLogic \@optional cmp_lst) 
    let((index s_ind components_lst nets_list NetsList
	    refDes dev_name pins_list component_id r_pads_list
	    cmp_id net_name cmp_pins pin_nr net_id
	    net_dbid
	) 
	(index = 1) 
	(s_ind = 1) 
	unless(cmp_lst 
	    (cmp_lst = (trl_altium2pcb_global->PartsList))
	) 
	(trl_altium2pcb_global->exeption = cons("===============================================================================" 
		(trl_altium2pcb_global->exeption)
	    ))
	(trl_altium2pcb_global->exeption = cons(sprintf(nil "   4.7.0  INFO    - Start to Create [%L] Component AND Net Logic  - Start Time: %L" 
		    length(cmp_lst) 
		    getCurrentTime()
		) 
		(trl_altium2pcb_global->exeption)
	    )) 
	(trl_altium2pcb_global->exeption = cons("===============================================================================" 
		(trl_altium2pcb_global->exeption)
	    )) 
	if(nth(6 
		(trl_altium2pcb_global->settings)
	    ) then 
	    (trl_altium2pcb_global->exeption = cons("   4.7.1  INFO    - Footprint Mode set to Individual!" 
		    (trl_altium2pcb_global->exeption)
		)) else 
	    (trl_altium2pcb_global->exeption = cons("   4.7.1  INFO    - Footprint Mode set to Generic!" 
		    (trl_altium2pcb_global->exeption)
		))
	) 
	(trl_altium2pcb_global->exeption = cons("-------------------------------------------------------------------------------" 
		(trl_altium2pcb_global->exeption)
	    )) 
	(components_lst = caddr((trl_altium2pcb_global->UtilsList)))
	(nets_list = nth(5 
		(trl_altium2pcb_global->UtilsList)
	    )) 
	if((nets_list && components_lst) then 
	    (trl_altium2pcb_global->exeption = cons("   4.7.2  INFO    - DeviceFile and Netlist will came from Schematic!" 
		    (trl_altium2pcb_global->exeption)
		)) else 
	    TRL_ALTIUM2PCB_CREATE_NETS()
	    (NetsList = (trl_altium2pcb_global->NetsList)) 
	    foreach(cmp cmp_lst 
		(refDes = nth(4 cmp)) 
		if(refDes then 
		    if(nth(6 
			    (trl_altium2pcb_global->settings)
			) then 
			(dev_name = cadr(cmp)) else 
			(dev_name = car(cmp))
		    ) else 
		    if(nth(7 
			    (trl_altium2pcb_global->settings)
			) then 
			(dev_name = cadr(cmp)) else 
			(dev_name = car(cmp))
		    )
		) 
		(axlUIWPrint 
		    (trl_altium2pcb_global->formid) "   4.7.3  INFO    - [%L] Start Component && Net Logic %L with Footprint %L of %L Components" index refDes
		    dev_name 
		    length(cmp_lst)
		)
		(trl_altium2pcb_global->exeption = cons(sprintf(nil "   4.7.3  INFO    - [%5d] Start Component %L %L with Footprint %L" index refDes cmp
			    dev_name
			) 
			(trl_altium2pcb_global->exeption)
		    )) 
		(pins_list = nil) 
		(component_id = caddr(cmp)) 
		(r_pads_list = TRL_ALTIUM2PCB_CREATE_Logical2Physical_PinMapping(dev_name component_id)) 
		(pins_list = car(r_pads_list))
		(cmp_id = nil) 
		when((refDes && pins_list) 
		    if(refDes then 
			(cmp_id = (axlDBCreateComponent refDes dev_name dev_name))
		    ) 
		    if(cmp_id then 
			(net_name = nil) 
			when(NetsList 
			    (cmp_pins = (cmp_id->pins)) 
			    foreach(pin cmp_pins 
				(pin_nr = (pin->number)) 
				foreach(rec pins_list 
				    when((upperCase(car(rec)) == upperCase(pin_nr)) 
					(net_id = nth(7 rec))
				    )
				) 
				foreach(net NetsList 
				    when((cadr(net) == net_id) 
					(net_name = car(net))
				    )
				)
				when(net_name 
				    (net_dbid = (axlChangeNet pin net_name))
				) 
				if(net_dbid then 
				    (trl_altium2pcb_global->exeption = cons(sprintf(nil "   4.7.4  INFO    - Pin: %L  Signal: %L  RefDes: %L  ID: %L created!" pin_nr net_name refDes
						net_id
					    ) 
					    (trl_altium2pcb_global->exeption)
					)) else 
				    (trl_altium2pcb_global->exeption = cons(sprintf(nil "   4.7.4  ERROR   - Pin: %L  Signal: %L  RefDes: %L  ID: %L NOT created!" pin_nr net_name refDes
						net_id
					    ) 
					    (trl_altium2pcb_global->exeption)
					))
				) 
				(net_name = nil) 
				(net_id = nil)
			    )
			)
		    ) 
		    (trl_altium2pcb_global->exeption = cons(sprintf(nil "   4.7.0  INFO    - Component %L created" refDes) 
			    (trl_altium2pcb_global->exeption)
			)) 
		    (trl_altium2pcb_global->exeption = cons(sprintf(nil "   4.1.1  INFO    - END Component %L with Footprint %L" refDes dev_name) 
			    (trl_altium2pcb_global->exeption)
			))
		    (trl_altium2pcb_global->exeption = cons("-------------------------------------------------------------------------------" 
			    (trl_altium2pcb_global->exeption)
			)) 
		    index++ 
		    s_ind++
		)
	    )
	) 
	(trl_altium2pcb_global->exeption = cons("===============================================================================" 
		(trl_altium2pcb_global->exeption)
	    )) 
	(trl_altium2pcb_global->exeption = cons(sprintf(nil "   4.7.0  INFO    - END of [%5d] Successful Component AND Net Logic Creation of [%5d] Total - END Time: [%L]" s_ind index 
		    getCurrentTime()
		) 
		(trl_altium2pcb_global->exeption)
	    )) 
	(trl_altium2pcb_global->exeption = cons("===============================================================================" 
		(trl_altium2pcb_global->exeption)
	    ))
    )
)
procedure((TRL_ALTIUM2PCB_CREATE_ComponentPlacement \@optional cmp_lst) 
    let((index s_ind dev_name refDes mirror
	    sym_x sym_y layer rot sym_dbid
	) 
	(index = 1) 
	(s_ind = 1) 
	(trl_altium2pcb_global->exeption = cons("-------------------------------------------------------------------------------" 
		(trl_altium2pcb_global->exeption)
	    )) 
	unless(cmp_lst 
	    (cmp_lst = (trl_altium2pcb_global->PartsList))
	)
	(trl_altium2pcb_global->exeption = cons("===============================================================================" 
		(trl_altium2pcb_global->exeption)
	    )) 
	(trl_altium2pcb_global->exeption = cons(sprintf(nil "   4.8.0  INFO    - Start to Place [%L] Components.. - Start Time: [%L]" 
		    length(cmp_lst) 
		    getCurrentTime()
		) 
		(trl_altium2pcb_global->exeption)
	    )) 
	(trl_altium2pcb_global->exeption = cons("===============================================================================" 
		(trl_altium2pcb_global->exeption)
	    )) 
	if(nth(6 
		(trl_altium2pcb_global->settings)
	    ) then 
	    (trl_altium2pcb_global->exeption = cons("   4.8.1  INFO    - Footprint Mode set to Individual!" 
		    (trl_altium2pcb_global->exeption)
		)) else 
	    (trl_altium2pcb_global->exeption = cons("   4.8.1  INFO    - Footprint Mode set to Generic!" 
		    (trl_altium2pcb_global->exeption)
		))
	) 
	foreach(cmp cmp_lst 
	    (refDes = nth(4 cmp)) 
	    if(refDes then 
		if(nth(6 
			(trl_altium2pcb_global->settings)
		    ) then 
		    (dev_name = cadr(cmp)) else 
		    (dev_name = car(cmp))
		) else 
		if(nth(7 
			(trl_altium2pcb_global->settings)
		    ) then 
		    (dev_name = cadr(cmp)) else 
		    (dev_name = car(cmp))
		)
	    ) 
	    (axlUIWPrint 
		(trl_altium2pcb_global->formid) "   4.8.1  INFO    - [%L] Start Component %L with Footprint %L of [%L] Components" index refDes
		dev_name 
		length(cmp_lst)
	    )
	    (trl_altium2pcb_global->exeption = cons(sprintf(nil "   4.8.1  INFO    - [%L] Start Component %L %L with Footprint %L" index refDes cmp
			dev_name
		    ) 
		    (trl_altium2pcb_global->exeption)
		)) 
	    (mirror = t) 
	    (sym_x = nth(5 cmp)) 
	    (sym_y = nth(6 cmp)) 
	    (layer = nth(7 cmp))
	    (rot = nth(9 cmp)) 
	    when((layer == "TOP") 
		(mirror = nil)
	    ) 
	    when(mirror 
		(rot = (rot - 180.0))
	    ) 
	    (sym_dbid = (axlDBCreateSymbol refDes 
		    (sym_x:sym_y) mirror rot
		)) 
	    if(sym_dbid then 
		s_ind++ 
		(trl_altium2pcb_global->exeption = cons(sprintf(nil "   4.8.2  INFO    - Component %L placed [%L %L %L]" refDes 
			    (sym_x:sym_y) mirror
			    rot
			) 
			(trl_altium2pcb_global->exeption)
		    )) else
		(sym_dbid = (axlDBCreateSymbol 
			list(dev_name "mechanical") 
			(sym_x:sym_y) mirror rot
		    )) 
		unless(sym_dbid 
		    (sym_dbid = (axlDBCreateSymbol 
			    list(dev_name "package") 
			    (sym_x:sym_y) mirror rot
			))
		) 
		if(sym_dbid then 
		    s_ind++ 
		    (trl_altium2pcb_global->exeption = cons(sprintf(nil "   4.8.3  INFO    - Mechanical_Cmp %L placed [%L %L %L]" dev_name 
				(sym_x:sym_y) mirror
				rot
			    ) 
			    (trl_altium2pcb_global->exeption)
			)) else
		    (trl_altium2pcb_global->exeption = cons(sprintf(nil "-->4.8.2  ERROR   - Component %L NOT placed [%L %L %L %L]" refDes dev_name 
				(sym_x:sym_y)
				mirror rot
			    ) 
			    (trl_altium2pcb_global->exeption)
			))
		)
	    )
	    (trl_altium2pcb_global->exeption = cons("-------------------------------------------------------------------------------" 
		    (trl_altium2pcb_global->exeption)
		)) 
	    index++
	)
	(trl_altium2pcb_global->exeption = cons("===============================================================================" 
		(trl_altium2pcb_global->exeption)
	    )) 
	(trl_altium2pcb_global->exeption = cons(sprintf(nil "   4.8.0  INFO    - END of [%5d] Successful Placed Component of [%5d] Total - END Time: [%L]" s_ind index 
		    getCurrentTime()
		) 
		(trl_altium2pcb_global->exeption)
	    )) 
	(trl_altium2pcb_global->exeption = cons("===============================================================================" 
		(trl_altium2pcb_global->exeption)
	    ))
    )
)
procedure(TRL_ALTIUM2PCB_CREATE_Device(pattern_name pads_list) 
    let((devpath file_name port txt_str raw_pad
	    pin_typ alg_typ typ_str index ret
	) 
	unless(pattern_name 
	    printf("---> Hier bei Devicefile\n")
	) 
	(txt_str = "") 
	(typ_str = "") 
	(index = 1)
	(ret = nil) 
	foreach(pad pads_list 
	    (raw_pad = nth(8 pad)) 
	    (pin_typ = get(raw_pad 
		    'DAISYCHAIN
		)) 
	    case(pin_typ 
		("Source" 
		    (alg_typ = "OUT")
		) 
		("Load" 
		    (alg_typ = "IN")
		) 
		("Terminator" 
		    (alg_typ = "IN")
		) 
		(t 
		    (alg_typ = "IN") 
		    printf("-->Unusual Pin Type: %L\n" pin_typ)
		)
	    )
	    if((index <= 32) then 
		(txt_str = sprintf(nil "%s%s " txt_str 
			car(pad)
		    )) 
		(typ_str = sprintf(nil "%s%s " typ_str alg_typ)) else
		(txt_str = sprintf(nil "%s%s,\n    " txt_str 
			car(pad)
		    )) 
		(typ_str = sprintf(nil "%s%s,\n    " typ_str alg_typ)) 
		(index = 0)
	    ) 
	    index++
	) 
	(devpath = axlGetVariable("DEVPATH")) 
	(devpath = car(parseString(devpath " "))) 
	(file_name = sprintf(nil "%s/%s.txt" devpath 
		lowerCase(pattern_name)
	    ))
	if(isWritable(devpath) then 
	    (port = outfile(file_name)) 
	    if(port then 
		fprintf(port "(DEVICE FILE: )") 
		fprintf(port "PACKAGE  %s\n" pattern_name) 
		fprintf(port "CLASS IC\n")
		fprintf(port "PINCOUNT %d\n\n" 
		    length(pads_list)
		) 
		fprintf(port "PINORDER %s %s\n" pattern_name txt_str) 
		fprintf(port "PINUSE %s %s\n" pattern_name typ_str) 
		fprintf(port "FUNCTION G1 %s %s\n" pattern_name txt_str) 
		fprintf(port "END\n")
		close(port) 
		(ret = t) else 
		(trl_altium2pcb_global->exeption = cons(sprintf(nil "-->4.9.1  ERROR   - Device File %L NOT Created!" pattern_name) 
			(trl_altium2pcb_global->exeption)
		    ))
	    ) else
	    (trl_altium2pcb_global->exeption = cons(sprintf(nil "-->4.9.0  ERROR   - Device File %L NOT Created" pattern_name) 
		    (trl_altium2pcb_global->exeption)
		))
	) ret
    )
)
procedure((TRL_ALTIUM2PCB_CREATE_DeviceFileDump \@optional cmp_lst) 
    let((index s_ind symdefs_lst components_lst nets_list
	    refDes dev_name pins_list component_id r_pads_list
	    dev_id
	) 
	(index = 1) 
	(s_ind = 1) 
	unless(cmp_lst 
	    (cmp_lst = (trl_altium2pcb_global->PartsList))
	) 
	(trl_altium2pcb_global->exeption = cons("===============================================================================" 
		(trl_altium2pcb_global->exeption)
	    ))
	(trl_altium2pcb_global->exeption = cons(sprintf(nil "   4.0.0  INFO    - Start to Create Device File.. - Start Time: [%L]" 
		    getCurrentTime()
		) 
		(trl_altium2pcb_global->exeption)
	    )) 
	(trl_altium2pcb_global->exeption = cons("===============================================================================" 
		(trl_altium2pcb_global->exeption)
	    )) 
	if(nth(6 
		(trl_altium2pcb_global->settings)
	    ) then 
	    (trl_altium2pcb_global->exeption = cons("   4.0.1  INFO    - Footprint Mode set to Individual!" 
		    (trl_altium2pcb_global->exeption)
		)) else 
	    (trl_altium2pcb_global->exeption = cons("   4.0.1  INFO    - Footprint Mode set to Generic!" 
		    (trl_altium2pcb_global->exeption)
		))
	) 
	(trl_altium2pcb_global->exeption = cons("-------------------------------------------------------------------------------" 
		(trl_altium2pcb_global->exeption)
	    )) 
	(symdefs_lst = cadr((trl_altium2pcb_global->UtilsList)))
	(components_lst = caddr((trl_altium2pcb_global->UtilsList))) 
	(nets_list = nth(5 
		(trl_altium2pcb_global->UtilsList)
	    )) 
	if((nets_list && components_lst) then t else 
	    (symdefs_lst = list())
	    foreach(cmp cmp_lst 
		(refDes = nth(4 cmp)) 
		if(refDes then 
		    if(nth(6 
			    (trl_altium2pcb_global->settings)
			) then 
			(dev_name = cadr(cmp)) else 
			(dev_name = car(cmp))
		    ) else 
		    if(nth(7 
			    (trl_altium2pcb_global->settings)
			) then 
			(dev_name = cadr(cmp)) else 
			(dev_name = car(cmp))
		    )
		) 
		unless(member(dev_name symdefs_lst) 
		    (pins_list = nil) 
		    (component_id = caddr(cmp)) 
		    (r_pads_list = TRL_ALTIUM2PCB_CREATE_Logical2Physical_PinMapping(dev_name component_id)) 
		    (pins_list = car(r_pads_list))
		    (dev_id = TRL_ALTIUM2PCB_CREATE_Device(dev_name pins_list)) 
		    (axlUIWPrint 
			(trl_altium2pcb_global->formid) "   4.4.01 INFO    - [%5d] Device File %L %L of %L created" index dev_name
			dev_id 
			length(cmp_lst)
		    ) 
		    (trl_altium2pcb_global->exeption = cons(sprintf(nil "   4.4.01 INFO    - [%5d] Device File %L %L created" index dev_name dev_id) 
			    (trl_altium2pcb_global->exeption)
			)) 
		    (symdefs_lst = cons(dev_name symdefs_lst)) 
		    index++
		    s_ind++
		)
	    )
	) 
	(trl_altium2pcb_global->exeption = cons("===============================================================================" 
		(trl_altium2pcb_global->exeption)
	    )) 
	(trl_altium2pcb_global->exeption = cons(sprintf(nil "   4.0.0  INFO    - END of [%5d] Successful Device File Creation of [%5d] Total - END Time: [%L]" s_ind index 
		    getCurrentTime()
		) 
		(trl_altium2pcb_global->exeption)
	    ))
	(trl_altium2pcb_global->exeption = cons("===============================================================================" 
		(trl_altium2pcb_global->exeption)
	    ))
    )
)
procedure(TRL_ALTIUM2PCB_CREATE_Fills_KeepOut(rec) 
    let((lay V7 x1 y1 x2
	    y2 rot l_points t_layer shp
	) 
	(lay = get(rec 
		'LAYER
	    )) 
	(V7 = get(rec 
		'LAYER_V7
	    )) 
	(x1 = TRL_ALTIUM2PCB_Util_DesignUnits(get(rec 
		    'X1
		)
	    )) 
	(y1 = TRL_ALTIUM2PCB_Util_DesignUnits(get(rec 
		    'Y1
		)
	    ))
	(x2 = TRL_ALTIUM2PCB_Util_DesignUnits(get(rec 
		    'X2
		)
	    )) 
	(y2 = TRL_ALTIUM2PCB_Util_DesignUnits(get(rec 
		    'Y2
		)
	    )) 
	(rot = atof(get(rec 
		    'ROTATION
		)
	    )) 
	when(V7 
	    when(nth(8 
		    (trl_altium2pcb_global->settings)
		) 
		(trl_altium2pcb_global->exeption = cons(sprintf(nil "   3.3.31 INFO    - Shape Keepout V7:/%L" rec) 
			(trl_altium2pcb_global->exeption)
		    ))
	    )
	) 
	unless(lay 
	    when(nth(8 
		    (trl_altium2pcb_global->settings)
		) 
		(trl_altium2pcb_global->exeption = cons(sprintf(nil "   3.3.32 INFO    - Shape Keepout Layer:/%L" rec) 
			(trl_altium2pcb_global->exeption)
		    ))
	    ) 
	    (lay = "TOPOVERLAY")
	)
	(l_points = (axlPathStart 
		list((x1:y1) 
		    (x1:y2) 
		    (x2:y2) 
		    (x2:y1) 
		    (x1:y1)
		)
	    )) 
	(t_layer = TRL_ALTIUM2PCB_UTIL_Find_Layer(lay)) 
	case(upperCase(lay) 
	    ("KEEPOUT" 
		(t_layer = "ROUTE KEEPOUT/ALL") 
		(shp = (axlDBCreateShape l_points t t_layer))
	    ) 
	    ("MULTILAYER" 
		(t_layer = "ROUTE KEEPOUT/ALL") 
		(shp = (axlDBCreateShape l_points t t_layer))
	    ) 
	    (t 
		if((car(t_layer) == "ETCH") then 
		    (t_layer = strcat("ROUTE KEEPOUT" "/" 
			    cadr(t_layer)
			)) 
		    (shp = (axlDBCreateShape l_points t t_layer)) else
		    unless((axlLayerGet 
			    sprintf(nil "BOARD GEOMETRY/Keepout_%s" 
				cadr(t_layer)
			    )
			) 
			(axlLayerCreateNonConductor 
			    sprintf(nil "BOARD GEOMETRY/Keepout_%s" 
				cadr(t_layer)
			    )
			)
		    ) 
		    (t_layer = sprintf(nil "BOARD GEOMETRY/Keepout_%s" 
			    cadr(t_layer)
			)) 
		    (shp = (axlDBCreateShape l_points t t_layer))
		)
	    )
	) 
	when((shp && (rot > 0)) 
	    (axlTransformObject shp ?angle rot)
	) 
	unless(shp 
	    (trl_altium2pcb_global->exeption = cons(sprintf(nil "-->3.3.34 ERROR   - Fill KeepOut NOT Created! Check FillRecords %L !!" rec) 
		    (trl_altium2pcb_global->exeption)
		))
	)
    )
)
procedure(TRL_ALTIUM2PCB_CREATE_FootprintDef_Text(pattern max_val_lst) 
    let((lay pattern_layer mirror x1y1 x2y2
	    pattern_rot pattern_x pattern_y sym_layer txt_list
	    x y x1 y1 x2
	    y2 rot height txt_mirr des
	    text xy txtorient textblock comment
	    ref_des_silk ref_des_assy TextRecords width dbid
	) 
	(ref_des_silk = nil) 
	(ref_des_assy = nil) 
	(txt_list = list()) 
	(TextRecords = car(nth(11 
		    (trl_altium2pcb_global->PcbRawList)
		)
	    ))
	when(TextRecords 
	    foreach(rec TextRecords 
		when((get(rec 
			    'COMPONENT
			) == caddr(pattern)) 
		    (lay = get(rec 
			    'LAYER
			)) 
		    (x1 = TRL_ALTIUM2PCB_Util_DesignUnits(get(rec 
				'X1
			    )
			)) 
		    (y1 = TRL_ALTIUM2PCB_Util_DesignUnits(get(rec 
				'Y1
			    )
			)) 
		    (x2 = TRL_ALTIUM2PCB_Util_DesignUnits(get(rec 
				'X2
			    )
			))
		    (y2 = TRL_ALTIUM2PCB_Util_DesignUnits(get(rec 
				'Y2
			    )
			)) 
		    (width = TRL_ALTIUM2PCB_Util_DesignUnits(get(rec 
				'WIDTH
			    )
			)) 
		    (x = TRL_ALTIUM2PCB_Util_DesignUnits(get(rec 
				'X
			    )
			)) 
		    (y = TRL_ALTIUM2PCB_Util_DesignUnits(get(rec 
				'Y
			    )
			)) 
		    (rot = atof(get(rec 
				'ROTATION
			    )
			))
		    (height = TRL_ALTIUM2PCB_Util_DesignUnits(get(rec 
				'HEIGHT
			    )
			)) 
		    (txt_mirr = get(rec 
			    'MIRROR
			)) 
		    (des = get(rec 
			    'DESIGNATOR
			)) 
		    (comment = get(rec 
			    'COMMENT
			)) 
		    (text = get(rec 
			    'TEXT
			))
		    unless(text 
			(text = "XXX")
		    ) 
		    (textblock = TRL_ALTIUM2PCB_UTIL_Find_Text_Block(height width)) 
		    (sym_layer = TRL_ALTIUM2PCB_UTIL_Find_Layer(lay)) 
		    if((car(sym_layer) == "ETCH") then 
			(sym_layer = sprintf(nil "ETCH/%s" 
				cadr(sym_layer)
			    )) else 
			(sym_layer = sprintf(nil "Package Geometry/%s" 
				cadr(sym_layer)
			    ))
		    ) 
		    unless((axlLayerGet sym_layer) 
			(dbid = (axlLayerCreateNonConductor sym_layer)) 
			unless(dbid 
			    (trl_altium2pcb_global->exeption = cons(sprintf(nil "-->2.4.3  ERROR   - Package Geometry: %L NOT Created" sym_layer) 
				    (trl_altium2pcb_global->exeption)
				))
			)
		    )
		    when((lay == "MECHANICAL1") 
			(sym_layer = "Package Geometry/Assembly_Top")
		    ) 
		    when(((text == ".Designator") && (lay == "MECHANICAL1")) 
			(sym_layer = "Ref Des/Assembly_Top") 
			(ref_des_assy = t)
		    ) 
		    when(des 
			(sym_layer = "Ref Des/Silkscreen_Top") 
			(ref_des_silk = t)
		    ) 
		    when(comment 
			(sym_layer = parseString(sym_layer "/")) 
			(sym_layer = sprintf(nil "Component Value/%s" 
				cadr(sym_layer)
			    ))
		    ) 
		    (pattern_layer = nth(7 pattern))
		    (pattern_rot = nth(9 pattern)) 
		    (pattern_x = nth(5 pattern)) 
		    (pattern_y = nth(6 pattern)) 
		    (x = (x - pattern_x)) 
		    (y = (y - pattern_y))
		    (xy = (x:y)) 
		    (mirror = t) 
		    when((pattern_layer == "TOP") 
			(mirror = nil)
		    ) 
		    if(mirror then 
			(pattern_rot = (pattern_rot + 180)) else 
			(pattern_rot = (pattern_rot * -1))
		    ) 
		    (xy = (axlGeoRotatePt pattern_rot 
			    (x:y) 
			    (0.0:0.0) mirror
			))
		    (max_val_lst = TRL_ALTIUM2PCB_UTIL_Find_Max_XY_Value(xy max_val_lst)) 
		    (x1 = (x1 - pattern_x)) 
		    (y1 = (y1 - pattern_y)) 
		    (x1y1 = (axlGeoRotatePt pattern_rot 
			    (x1:y1) 
			    (0.0:0.0) mirror
			)) 
		    (max_val_lst = TRL_ALTIUM2PCB_UTIL_Find_Max_XY_Value(x1y1 max_val_lst))
		    (x2 = (x2 - pattern_x)) 
		    (y2 = (y2 - pattern_y)) 
		    (x2y2 = (axlGeoRotatePt pattern_rot 
			    (x2:y2) 
			    (0.0:0.0) mirror
			)) 
		    (max_val_lst = TRL_ALTIUM2PCB_UTIL_Find_Max_XY_Value(x2y2 max_val_lst)) 
		    (txtorient = (make_axlTextOrientation ?textBlock textblock ?rotation rot
			    ?mirrored txt_mirr ?justify "left"
			))
		    (txt_list = cons(list(text 
				(x:y) txtorient sym_layer max_val_lst
			    ) txt_list
			))
		)
	    )
	) 
	unless(ref_des_silk 
	    (txt_list = cons(list(".Designator" 
			(0.0:0.0) txtorient "Ref Des/Silkscreen_Top" max_val_lst
		    ) txt_list
		))
	) 
	unless(ref_des_assy 
	    (txt_list = cons(list(".Designator" 
			(0.0:0.0) txtorient "Ref Des/Assembly_Top" max_val_lst
		    ) txt_list
		))
	) txt_list
    )
)
procedure((TRL_ALTIUM2PCB_CREATE_FootprintDump \@optional cmp_lst) 
    let((symdefs_lst components_lst sym_write nets_list index
	    s_ind input_string refDes dev_name ret_pattern
	    symd_id sch_cmp_pins_list sch_cmp_pins dev_id sch_footprint
	) 
	(trl_altium2pcb_global->exeption = cons("-------------------------------------------------------------------------------" 
		(trl_altium2pcb_global->exeption)
	    )) 
	unless(cmp_lst 
	    (cmp_lst = (trl_altium2pcb_global->PartsList))
	) 
	(trl_altium2pcb_global->exeption = cons("===============================================================================" 
		(trl_altium2pcb_global->exeption)
	    )) 
	(trl_altium2pcb_global->exeption = cons(sprintf(nil "   4.3.0  INFO    - Start to Create Footprint Data.. - Start Time: [%L]" 
		    getCurrentTime()
		) 
		(trl_altium2pcb_global->exeption)
	    ))
	(trl_altium2pcb_global->exeption = cons("===============================================================================" 
		(trl_altium2pcb_global->exeption)
	    )) 
	if(nth(6 
		(trl_altium2pcb_global->settings)
	    ) then 
	    (trl_altium2pcb_global->exeption = cons("   4.3.1  INFO    - Footprint Mode set to Individual!" 
		    (trl_altium2pcb_global->exeption)
		)) else 
	    (trl_altium2pcb_global->exeption = cons("   4.3.1  INFO    - Footprint Mode set to Generic!" 
		    (trl_altium2pcb_global->exeption)
		))
	) 
	(symdefs_lst = list()) 
	(index = 1) 
	(s_ind = 0)
	(axlPurgePadstacks 
	    'padstacks nil
	) 
	(input_string = axlGetVariable("PSMPATH")) 
	if(isDir(input_string) then 
	    if(isWritable(input_string) then 
		(trl_altium2pcb_global->exeption = cons(sprintf(nil "   X.3.01 INFO    - Symbol Directory set: %L" input_string) 
			(trl_altium2pcb_global->exeption)
		    )) else 
		(trl_altium2pcb_global->exeption = cons(sprintf(nil "   X.3.01 INFO    - Symbol Directory: %L Not Writable" input_string) 
			(trl_altium2pcb_global->exeption)
		    ))
		(axlFormSetField 
		    (trl_altium2pcb_global->formid) "prts_l" ""
		)
	    ) else 
	    if(createDir(input_string) then 
		(trl_altium2pcb_global->exeption = cons(sprintf(nil "   X.3.01 INFO    - Symbol Directory set: %L" input_string) 
			(trl_altium2pcb_global->exeption)
		    )) else 
		(trl_altium2pcb_global->exeption = cons(sprintf(nil "   X.3.01 INFO    - Symbol Directory: %L Not Writable" input_string) 
			(trl_altium2pcb_global->exeption)
		    ))
		(axlFormSetField 
		    (trl_altium2pcb_global->formid) "prts_l" ""
		)
	    )
	) 
	(trl_altium2pcb_global->exeption = cons("-------------------------------------------------------------------------------" 
		(trl_altium2pcb_global->exeption)
	    )) 
	(symdefs_lst = cadr((trl_altium2pcb_global->UtilsList)))
	(components_lst = caddr((trl_altium2pcb_global->UtilsList))) 
	(nets_list = nth(5 
		(trl_altium2pcb_global->UtilsList)
	    )) 
	if((nets_list && components_lst) then 
	    foreach(cmp cmp_lst 
		(dev_name = car(cmp)) 
		(refDes = nth(4 cmp)) 
		(sch_cmp_pins_list = list())
		(sch_cmp_pins = list()) 
		foreach(sch_cmp components_lst 
		    when(((sch_cmp->name) == refDes) 
			(sch_footprint = (sch_cmp->package)) 
			(sch_cmp_pins = (sch_cmp->pins)) 
			(dev_id = (sch_cmp->deviceType))
		    )
		) 
		when(sch_cmp_pins 
		    foreach(pin sch_cmp_pins 
			(sch_cmp_pins_list = cons((pin->number) sch_cmp_pins_list))
		    )
		) 
		(trl_altium2pcb_global->exeption = cons(sprintf(nil "   4.3.1  INFO    - [%L] Start Component %L with Footprint %L SCH_FOOTPRINT: %L - %L" index refDes dev_name
			    sch_footprint cmp
			) 
			(trl_altium2pcb_global->exeption)
		    )) 
		(trl_altium2pcb_global->exeption = cons("-------------------------------------------------------------------------------" 
			(trl_altium2pcb_global->exeption)
		    ))
		unless((sch_cmp_pins_list && sch_footprint) 
		    (sch_footprint = dev_name)
		) 
		if(member(sch_footprint symdefs_lst) then 
		    (trl_altium2pcb_global->exeption = cons(sprintf(nil "   4.3.2  INFO    - For Component %L Footprint %L already exist!" refDes sch_footprint) 
			    (trl_altium2pcb_global->exeption)
			)) else 
		    (ret_pattern = TRL_ALTIUM2PCB_CREATE_Selected_Pattern(sch_footprint cmp sch_cmp_pins_list))
		    (symd_id = car(ret_pattern)) 
		    if(symd_id then 
			(symdefs_lst = cons(sch_footprint symdefs_lst)) 
			(trl_altium2pcb_global->exeption = cons(sprintf(nil "   4.3.01 INFO    - Footprint %L ID: %L %L created" sch_footprint symd_id dev_id) 
				(trl_altium2pcb_global->exeption)
			    )) else
			(trl_altium2pcb_global->exeption = cons(sprintf(nil "-->4.3.3  ERROR   - Footprint %L NOT created" symd_id) 
				(trl_altium2pcb_global->exeption)
			    ))
		    )
		) 
		(sym_write = (axlWritePackageFile symd_id input_string)) 
		if(sym_write then 
		    (trl_altium2pcb_global->exeption = cons(sprintf(nil "   4.3.11 INFO    - Footprint %L ID: %L %L created" dev_name symd_id sym_write) 
			    (trl_altium2pcb_global->exeption)
			)) 
		    s_ind++ else
		    (trl_altium2pcb_global->exeption = cons(sprintf(nil "-->4.3.4  ERROR   - Footprint Symbol: %L - Dump NOT created" sym_write) 
			    (trl_altium2pcb_global->exeption)
			))
		) 
		(sch_footprint = nil)
		(trl_altium2pcb_global->exeption = cons("-------------------------------------------------------------------------------" 
			(trl_altium2pcb_global->exeption)
		    )) 
		index++
	    ) else 
	    foreach(cmp cmp_lst 
		(refDes = nth(4 cmp)) 
		if(refDes then 
		    if(nth(6 
			    (trl_altium2pcb_global->settings)
			) then 
			(dev_name = cadr(cmp)) else 
			(dev_name = car(cmp))
		    ) else 
		    if(nth(7 
			    (trl_altium2pcb_global->settings)
			) then 
			(dev_name = cadr(cmp)) else 
			(dev_name = car(cmp))
		    )
		) 
		unless(member(dev_name symdefs_lst) 
		    (axlUIWPrint 
			(trl_altium2pcb_global->formid) "   4.3.5  INFO    - [%5d] Start Footprint %L of %L creation.." index dev_name
			length(cmp_lst)
		    ) 
		    (trl_altium2pcb_global->exeption = cons(sprintf(nil "   4.3.5  INFO    - [%5d] Start Footprint %L creation.." index dev_name) 
			    (trl_altium2pcb_global->exeption)
			)) 
		    (trl_altium2pcb_global->exeption = cons("                    -----------------------------------------------------------" 
			    (trl_altium2pcb_global->exeption)
			)) 
		    (ret_pattern = TRL_ALTIUM2PCB_CREATE_Selected_Pattern(dev_name cmp))
		    (symd_id = car(ret_pattern)) 
		    if(symd_id then 
			(sym_write = (axlWritePackageFile symd_id input_string)) 
			if(sym_write then 
			    (trl_altium2pcb_global->exeption = cons(sprintf(nil "   4.3.22 INFO    - Footprint %L ID: %L %L created" dev_name symd_id sym_write) 
				    (trl_altium2pcb_global->exeption)
				)) 
			    s_ind++ else
			    (trl_altium2pcb_global->exeption = cons(sprintf(nil "-->4.3.6  ERROR   - Footprint Symbol: %L - Dump NOT created" sym_write) 
				    (trl_altium2pcb_global->exeption)
				))
			) else
			(trl_altium2pcb_global->exeption = cons(sprintf(nil "-->4.3.7  ERROR   - Footprint Definition %L NOT created" symd_id) 
				(trl_altium2pcb_global->exeption)
			    ))
		    ) 
		    index++ 
		    (trl_altium2pcb_global->exeption = cons("-------------------------------------------------------------------------------" 
			    (trl_altium2pcb_global->exeption)
			))
		)
		(symdefs_lst = cons(dev_name symdefs_lst))
	    )
	) 
	(trl_altium2pcb_global->exeption = cons("===============================================================================" 
		(trl_altium2pcb_global->exeption)
	    )) 
	(trl_altium2pcb_global->exeption = cons(sprintf(nil "   4.3.0  INFO    - END of [%5d] Successful Footprints Creation of [%5d] Total - END Time: [%L]" s_ind 
		    (index - 1) 
		    getCurrentTime()
		) 
		(trl_altium2pcb_global->exeption)
	    ))
	(trl_altium2pcb_global->exeption = cons("===============================================================================" 
		(trl_altium2pcb_global->exeption)
	    ))
    )
)
procedure(TRL_ALTIUM2PCB_CREATE_Footprint_Arc(pattern max_val_lst) 
    let((ArcRecords lay mx my r
	    sa ea w pattern_layer mirror
	    mxmy x1y1 x2y2 pattern_rot pattern_x
	    pattern_y sym_layer arc_list _sa _ea
	    angle_s_rad angle_e_rad r_path x1 y1
	    x2 y2
	) 
	(ArcRecords = nth(7 
		(trl_altium2pcb_global->PcbRawList)
	    )) 
	when(ArcRecords 
	    foreach(rec ArcRecords 
		when((get(rec 
			    'COMPONENT
			) == caddr(pattern)) 
		    (lay = get(rec 
			    'LAYER
			)) 
		    (mx = TRL_ALTIUM2PCB_Util_DesignUnits(get(rec 
				'LOCATION\.X
			    )
			)) 
		    (my = TRL_ALTIUM2PCB_Util_DesignUnits(get(rec 
				'LOCATION\.Y
			    )
			)) 
		    (r = TRL_ALTIUM2PCB_Util_DesignUnits(get(rec 
				'RADIUS
			    )
			))
		    (sa = atof(get(rec 
				'STARTANGLE
			    )
			)) 
		    (ea = atof(get(rec 
				'ENDANGLE
			    )
			)) 
		    (w = TRL_ALTIUM2PCB_Util_DesignUnits(get(rec 
				'WIDTH
			    )
			)) 
		    (mirror = t) 
		    (pattern_layer = nth(7 pattern))
		    when((pattern_layer == "TOP") 
			(mirror = nil)
		    ) 
		    if(mirror then 
			(_sa = ea) 
			(_ea = sa) else
			(_sa = sa) 
			(_ea = ea)
		    ) 
		    when((_sa > _ea) 
			(_ea = (_ea + 360.0))
		    ) 
		    (angle_s_rad = ((_sa / 360.0) * 2 * 3.141593)) 
		    (angle_e_rad = ((_ea / 360.0) * 2 * 3.141593))
		    (x1 = ((cos(angle_s_rad) * r) + mx)) 
		    (y1 = ((sin(angle_s_rad) * r) + my)) 
		    (x2 = ((cos(angle_e_rad) * r) + mx)) 
		    (y2 = ((sin(angle_e_rad) * r) + my)) 
		    (pattern_rot = nth(9 pattern))
		    (pattern_x = nth(5 pattern)) 
		    (pattern_y = nth(6 pattern)) 
		    if(mirror then 
			(pattern_rot = (pattern_rot + 180)) else 
			(pattern_rot = (pattern_rot * -1))
		    ) 
		    (sym_layer = TRL_ALTIUM2PCB_UTIL_Package_Layer_Map(mirror lay)) 
		    when((lay == "MECHANICAL1") 
			(sym_layer = "Package Geometry/Assembly_Top")
		    )
		    (x1 = (x1 - pattern_x)) 
		    (y1 = (y1 - pattern_y)) 
		    (x1y1 = (axlGeoRotatePt pattern_rot 
			    (x1:y1) 
			    (0.0:0.0) mirror
			)) 
		    (max_val_lst = TRL_ALTIUM2PCB_UTIL_Find_Max_XY_Value(x1y1 max_val_lst)) 
		    (r_path = (axlPathStart 
			    list(x1y1) w
			))
		    (x2 = (x2 - pattern_x)) 
		    (y2 = (y2 - pattern_y)) 
		    (x2y2 = (axlGeoRotatePt pattern_rot 
			    (x2:y2) 
			    (0.0:0.0) mirror
			)) 
		    (max_val_lst = TRL_ALTIUM2PCB_UTIL_Find_Max_XY_Value(x2y2 max_val_lst)) 
		    (mx = (mx - pattern_x))
		    (my = (my - pattern_y)) 
		    (mxmy = (axlGeoRotatePt pattern_rot 
			    (mx:my) 
			    (0.0:0.0) mirror
			)) 
		    (max_val_lst = TRL_ALTIUM2PCB_UTIL_Find_Max_XY_Value(mxmy max_val_lst)) 
		    (r_path = (axlPathArcCenter r_path w x2y2 nil
			    mxmy
			)) 
		    (arc_list = cons(list(r_path sym_layer) arc_list))
		)
	    )
	) 
	list(arc_list max_val_lst)
    )
)
procedure(TRL_ALTIUM2PCB_CREATE_Footprint_Fills(pattern max_val_lst) 
    let((FillRecords lay V7 x1 y1
	    x2 y2 rot pattern_layer pattern_rot
	    pattern_x pattern_y mirror ll ur
	    seg_list sym_layer cx cy keep_out
	) 
	(FillRecords = car(nth(13 
		    (trl_altium2pcb_global->PcbRawList)
		)
	    )) 
	if(FillRecords then 
	    foreach(rec FillRecords 
		when((get(rec 
			    'COMPONENT
			) == caddr(pattern)) 
		    (lay = get(rec 
			    'LAYER
			)) 
		    (V7 = get(rec 
			    'LAYER_V7
			)) 
		    (x1 = TRL_ALTIUM2PCB_Util_DesignUnits(get(rec 
				'X1
			    )
			)) 
		    (y1 = TRL_ALTIUM2PCB_Util_DesignUnits(get(rec 
				'Y1
			    )
			))
		    (x2 = TRL_ALTIUM2PCB_Util_DesignUnits(get(rec 
				'X2
			    )
			)) 
		    (y2 = TRL_ALTIUM2PCB_Util_DesignUnits(get(rec 
				'Y2
			    )
			)) 
		    (rot = atof(get(rec 
				'ROTATION
			    )
			)) 
		    (keep_out = get(rec 
			    'KEEPOUT
			)) 
		    when(V7 
			printf("--Hier bei Fill V7: %L\n" rec)
		    )
		    (pattern_layer = nth(7 pattern)) 
		    (pattern_rot = nth(9 pattern)) 
		    (pattern_x = nth(5 pattern)) 
		    (pattern_y = nth(6 pattern)) 
		    (mirror = t)
		    when((pattern_layer == "TOP") 
			(mirror = nil)
		    ) 
		    (sym_layer = TRL_ALTIUM2PCB_UTIL_Package_Layer_Map(mirror lay)) 
		    when((lay == "MECHANICAL1") 
			(sym_layer = "Package Geometry/Assembly_Top")
		    ) 
		    when((keep_out == "TRUE") 
			(sym_layer = parseString(sym_layer "/")) 
			(sym_layer = cadr(sym_layer)) 
			when((sym_layer == "MULTILAYER") 
			    (sym_layer = "ALL")
			) 
			(sym_layer = sprintf(nil "ROUTE KEEPOUT/%s" sym_layer))
		    ) 
		    (x1 = (x1 - pattern_x))
		    (y1 = (y1 - pattern_y)) 
		    (x2 = (x2 - pattern_x)) 
		    (y2 = (y2 - pattern_y)) 
		    (cx = (x1 + ((x2 - x1) / 2))) 
		    (cy = (y1 + ((y2 - y1) / 2)))
		    when(((rot != 0) || (rot != 360)) 
			(ll = (axlGeoRotatePt rot 
				(x1:y1) 
				(cx:cy) mirror
			    )) 
			(ur = (axlGeoRotatePt rot 
				(x2:y2) 
				(cx:cy) mirror
			    ))
		    ) 
		    when((pattern_rot != 0) 
			(pattern_rot = (360 - pattern_rot)) 
			(ll = (axlGeoRotatePt pattern_rot ll 
				(0:0) mirror
			    )) 
			(ur = (axlGeoRotatePt pattern_rot ur 
				(0:0) mirror
			    ))
		    ) 
		    (max_val_lst = TRL_ALTIUM2PCB_UTIL_Find_Max_XY_Value(ll max_val_lst)) 
		    (max_val_lst = TRL_ALTIUM2PCB_UTIL_Find_Max_XY_Value(ur max_val_lst)) 
		    (seg_list = cons(list(list(ll ur) sym_layer rot) seg_list))
		)
	    )
	) 
	list(seg_list max_val_lst)
    )
)
procedure(TRL_ALTIUM2PCB_CREATE_Footprint_Misc(pattern) 
    let((ComponentBodyRecords lay V7 pattern_layer pattern_rot
	    pattern_x pattern_y mirror sym_layer l_points
	    path start_h end_h n_points path_list
	    obj_x obj_y poly_db tran_db dbid
	) 
	(ComponentBodyRecords = nth(14 
		(trl_altium2pcb_global->PcbRawList)
	    )) 
	(poly_db = list()) 
	if(ComponentBodyRecords then 
	    (ComponentBodyRecords = reverse(ComponentBodyRecords)) 
	    foreach(rec ComponentBodyRecords 
		when((get(rec 
			    'COMPONENT
			) == caddr(pattern)) 
		    (l_points = list()) 
		    (lay = get(rec 
			    'LAYER
			)) 
		    (V7 = get(rec 
			    'LAYER_V7
			)) 
		    (start_h = get(rec 
			    'STANDOFFHEIGHT
			))
		    (end_h = get(rec 
			    'OVERALLHEIGHT
			)) 
		    (l_points = TRL_ALTIUM2PCB_GetPolyPath(rec)) 
		    when(V7 
			printf("--Hier bei Fill V7: %L\n" rec)
		    ) 
		    (pattern_layer = nth(7 pattern)) 
		    (pattern_rot = nth(9 pattern))
		    (pattern_x = nth(5 pattern)) 
		    (pattern_y = nth(6 pattern)) 
		    (mirror = t) 
		    when((pattern_layer == "TOP") 
			(mirror = nil)
		    ) 
		    (sym_layer = TRL_ALTIUM2PCB_UTIL_Package_Layer_Map(mirror lay))
		    when((lay == "MECHANICAL1") 
			(sym_layer = "Package Geometry/Assembly_Top")
		    ) 
		    (n_points = list()) 
		    foreach(p l_points 
			(obj_x = car(p)) 
			(obj_x = (obj_x - pattern_x)) 
			(obj_y = cadr(p))
			(obj_y = (obj_y - pattern_y)) 
			(n_points = cons(list(obj_x obj_y 
				    caddr(p) 
				    nth(3 p) 
				    nth(4 p)
				    nth(5 p) 
				    nth(6 p)
				) n_points
			    ))
		    ) 
		    when(end_h 
			(start_h = TRL_ALTIUM2PCB_Util_DesignUnits(start_h)) 
			(end_h = TRL_ALTIUM2PCB_Util_DesignUnits(end_h)) 
			(sym_layer = "Package Geometry/Place_Bound_Top")
		    ) 
		    if(n_points then 
			if(mirror then 
			    (pattern_rot = (pattern_rot + 180.0)) else 
			    (pattern_rot = (pattern_rot * -1))
			) 
			(path = TRL_ALTIUM2PCB_ComplexPolyPath_OLD(l_points)) 
			if(path then 
			    (dbid = (axlDBCreateShape path t "ETCH/TOP")) 
			    unless(dbid 
				(path = TRL_ALTIUM2PCB_ComplexPolyPath(l_points)) 
				(dbid = (axlDBCreateShape path t "ETCH/TOP"))
			    ) 
			    if(dbid then 
				(tran_db = (axlTransformObject 
					car(dbid) ?move 
					((- pattern_x):(- pattern_y))
				    )) 
				when((pattern_rot && tran_db) 
				    (tran_db = (axlTransformObject tran_db ?mirror mirror ?angle
					    pattern_rot ?origin 
					    (0.0:0.0)
					))
				) 
				if(tran_db then 
				    (poly_db = (axlPolyFromDB tran_db)) 
				    (axlDeleteObject tran_db) 
				    if(poly_db then 
					(path_list = cons(list(car(poly_db) sym_layer start_h end_h) path_list)) else 
					(path = TRL_ALTIUM2PCB_ComplexPolyPath_NOReverse(l_points))
					(path_list = cons(list(path sym_layer start_h end_h) path_list))
				    )
				    else 
				    (path = TRL_ALTIUM2PCB_ComplexPolyPath(n_points)) 
				    (path_list = cons(list(path sym_layer start_h end_h) path_list))
				)
				else 
				(path = TRL_ALTIUM2PCB_ComplexPolyPath_NOReverse(n_points)) 
				(axlDBCreatePath path "ETCH/TOP") 
				(path_list = cons(list(path sym_layer start_h end_h) path_list))
			    )
			    else 
			    (trl_altium2pcb_global->exeption = cons("-->4.7.03 ERROR   - BodyRecords NOT Created! Path creation failed!!" 
				    (trl_altium2pcb_global->exeption)
				))
			)
			else 
			(trl_altium2pcb_global->exeption = cons("-->4.7.02 ERROR   - BodyRecords NOT Created! Check Polygon Date syntax!!" 
				(trl_altium2pcb_global->exeption)
			    ))
		    )
		)
	    )
	) path_list
    )
)
procedure(TRL_ALTIUM2PCB_CREATE_Footprint_Pin_Preprocessing(r_pads_list pins_list pattern pattern_name ref_des
	pin_str_lst max_val_lst
    ) 
    let((sond_list mech_l pads_list pin_nr_pad pin_str
	    component_id
	) 
	(component_id = caddr(pattern)) 
	(r_pads_list = TRL_ALTIUM2PCB_CREATE_Logical2Physical_PinMapping(pattern_name component_id)) 
	(sond_list = caddr(r_pads_list)) 
	(mech_l = cadr(r_pads_list))
	(pads_list = car(r_pads_list)) 
	(trl_altium2pcb_global->exeption = cons(sprintf(nil "   3.4.40 INFO    - Component Pin Statistic: [%L Pins] - [%L MechPins] - [%L SpecialPins]" 
		    length(pads_list) 
		    length(mech_l) 
		    length(sond_list)
		) 
		(trl_altium2pcb_global->exeption)
	    )) 
	when((mech_l && (type(mech_l) == 'list)) 
	    foreach(pad mech_l 
		(pin_nr_pad = TRL_ALTIUM2PCB_CREATE_PadStack(ref_des pattern pad mech_l)) 
		if(pins_list then 
		    if(member(car(pad) pins_list) then 
			(pin_str = TRL_ALTIUM2PCB_CREATE_Pin(pin_nr_pad pattern pattern_name max_val_lst pads_list)) 
			(pin_str_lst = cons(car(pin_str) pin_str_lst)) 
			(max_val_lst = TRL_ALTIUM2PCB_UTIL_Find_Max_XY_Value(cadr(pin_str) max_val_lst))
			else 
			(pin_str = TRL_ALTIUM2PCB_CREATE_Pin(pin_nr_pad pattern pattern_name max_val_lst pads_list
				t
			    )) 
			(pin_str_lst = cons(car(pin_str) pin_str_lst)) 
			(max_val_lst = TRL_ALTIUM2PCB_UTIL_Find_Max_XY_Value(cadr(pin_str) max_val_lst))
		    ) else 
		    (pin_str = TRL_ALTIUM2PCB_CREATE_Pin(pin_nr_pad pattern pattern_name max_val_lst pads_list))
		    (pin_str_lst = cons(car(pin_str) pin_str_lst)) 
		    (max_val_lst = TRL_ALTIUM2PCB_UTIL_Find_Max_XY_Value(cadr(pin_str) max_val_lst))
		)
	    )
	) 
	if((pads_list && (type(pads_list) == 'list)) then 
	    foreach(pad pads_list 
		(pin_nr_pad = TRL_ALTIUM2PCB_CREATE_PadStack(ref_des pattern pad pads_list)) 
		if(pins_list then 
		    if(member(car(pad) pins_list) then 
			(pin_str = TRL_ALTIUM2PCB_CREATE_Pin(pin_nr_pad pattern pattern_name max_val_lst pads_list)) 
			(pin_str_lst = cons(car(pin_str) pin_str_lst)) 
			(max_val_lst = TRL_ALTIUM2PCB_UTIL_Find_Max_XY_Value(cadr(pin_str) max_val_lst))
			else 
			(trl_altium2pcb_global->exeption = cons(sprintf(nil "   3.4.41 INFO    - Component Pin [%L] DO NOT EXISTS in the Schematic!" 
				    car(pad)
				) 
				(trl_altium2pcb_global->exeption)
			    )) 
			(pin_str = TRL_ALTIUM2PCB_CREATE_Pin(pin_nr_pad pattern pattern_name max_val_lst pads_list
				t
			    )) 
			(pin_str_lst = cons(car(pin_str) pin_str_lst)) 
			(max_val_lst = TRL_ALTIUM2PCB_UTIL_Find_Max_XY_Value(cadr(pin_str) max_val_lst))
		    ) else 
		    (pin_str = TRL_ALTIUM2PCB_CREATE_Pin(pin_nr_pad pattern pattern_name max_val_lst pads_list))
		    (pin_str_lst = cons(car(pin_str) pin_str_lst)) 
		    (max_val_lst = TRL_ALTIUM2PCB_UTIL_Find_Max_XY_Value(cadr(pin_str) max_val_lst))
		)
	    ) else 
	    (trl_altium2pcb_global->exeption = cons(sprintf(nil "-->4.2.01 WARNING - ComponentPins DO NOT exist!! %L %L" pattern_name component_id) 
		    (trl_altium2pcb_global->exeption)
		))
	) 
	list(pin_str_lst r_pads_list max_val_lst)
    )
)
procedure(TRL_ALTIUM2PCB_CREATE_Footprint_Region(pattern max_val_lst) 
    let((RegionRecords l_points layer path path_list
	    shape pattern_layer pattern_rot pattern_x pattern_y
	    mirror keep_out kind xy cxcy
	    n_points t_layer x1 y1 cx
	    cy poly_db tran_db dbid
	) 
	(RegionRecords = car(nth(12 
		    (trl_altium2pcb_global->PcbRawList)
		)
	    )) 
	if(RegionRecords then 
	    foreach(rec RegionRecords 
		(shape = nil) 
		(keep_out = nil) 
		when((get(rec 
			    'COMPONENT
			) == caddr(pattern)) 
		    (l_points = list()) 
		    (n_points = list()) 
		    (l_points = TRL_ALTIUM2PCB_GetPolyPath(rec)) 
		    (layer = get(rec 
			    'LAYER
			))
		    (shape = get(rec 
			    'ISSHAPEBASED
			)) 
		    (keep_out = get(rec 
			    'KEEPOUT
			)) 
		    (kind = get(rec 
			    'KIND
			)) 
		    (pattern_layer = nth(7 pattern)) 
		    (pattern_rot = nth(9 pattern))
		    (pattern_x = nth(5 pattern)) 
		    (pattern_y = nth(6 pattern)) 
		    (mirror = t) 
		    when((pattern_layer == "TOP") 
			(mirror = nil)
		    ) 
		    (t_layer = TRL_ALTIUM2PCB_UTIL_Package_Layer_Map(mirror layer))
		    when((layer == "MECHANICAL1") 
			(t_layer = "Package Geometry/Assembly_Top")
		    ) 
		    when((keep_out == "TRUE") 
			(t_layer = parseString(t_layer "/")) 
			(t_layer = cadr(t_layer)) 
			when((t_layer == "MULTILAYER") 
			    (t_layer = "ALL")
			) 
			(t_layer = sprintf(nil "ROUTE KEEPOUT/%s" t_layer))
		    ) 
		    when((kind == "1") 
			(t_layer = parseString(t_layer "/")) 
			(t_layer = cadr(t_layer)) 
			when((t_layer == "MULTILAYER") 
			    (t_layer = "ALL")
			) 
			(t_layer = sprintf(nil "ROUTE KEEPOUT/%s" t_layer))
		    ) 
		    if(mirror then 
			(pattern_rot = (pattern_rot + 180.0)) else 
			(pattern_rot = (pattern_rot * -1))
		    ) 
		    foreach(p l_points 
			(x1 = car(p)) 
			(y1 = cadr(p)) 
			(cx = caddr(p))
			(cy = cadddr(p)) 
			(x1 = (x1 - pattern_x)) 
			(y1 = (y1 - pattern_y)) 
			unless((cx == 0.0) 
			    (cx = (cx - pattern_x))
			) 
			unless((cy == 0.0) 
			    (cy = (cy - pattern_y))
			)
			(xy = (axlGeoRotatePt pattern_rot 
				(x1:y1) 
				(0.0:0.0) mirror
			    )) 
			(max_val_lst = TRL_ALTIUM2PCB_UTIL_Find_Max_XY_Value(xy max_val_lst)) 
			(cxcy = (axlGeoRotatePt pattern_rot 
				(cx:cy) 
				(0.0:0.0) mirror
			    )) 
			(max_val_lst = TRL_ALTIUM2PCB_UTIL_Find_Max_XY_Value(cxcy max_val_lst)) 
			(n_points = cons(list(car(xy) 
				    cadr(xy) 
				    car(cxcy) 
				    cadr(cxcy) 
				    nth(4 p)
				    nth(5 p) 
				    nth(6 p)
				) n_points
			    ))
		    )
		    if(n_points then 
			(path = TRL_ALTIUM2PCB_ComplexPolyPath_OLD(l_points)) 
			if(path then 
			    (dbid = (axlDBCreateShape path t "ETCH/TOP")) 
			    unless(dbid 
				(path = TRL_ALTIUM2PCB_ComplexPolyPath(l_points)) 
				(dbid = (axlDBCreateShape path t "ETCH/TOP"))
			    ) 
			    if(dbid then 
				(tran_db = (axlTransformObject 
					car(dbid) ?move 
					((- pattern_x):(- pattern_y))
				    )) 
				when((pattern_rot && tran_db) 
				    (tran_db = (axlTransformObject tran_db ?mirror mirror ?angle
					    pattern_rot ?origin 
					    (0.0:0.0)
					))
				) 
				if(tran_db then 
				    (poly_db = (axlPolyFromDB tran_db)) 
				    if(poly_db then 
					(axlDeleteObject tran_db) 
					(path_list = cons(list(car(poly_db) t_layer shape) path_list)) else
					(path = TRL_ALTIUM2PCB_ComplexPolyPath_OLD(n_points)) 
					(path_list = cons(list(path t_layer shape) path_list)) 
					(trl_altium2pcb_global->exeption = cons("-->4.5.16 ERROR   - Region Shape NOT Created! PolyFromDB failed!!" 
						(trl_altium2pcb_global->exeption)
					    ))
				    ) else
				    (path = TRL_ALTIUM2PCB_ComplexPolyPath_OLD(n_points)) 
				    (path_list = cons(list(path t_layer shape) path_list)) 
				    (trl_altium2pcb_global->exeption = cons("-->4.5.15 ERROR   - Region Shape NOT Created! Object transformation failed!!" 
					    (trl_altium2pcb_global->exeption)
					))
				)
				else 
				(path = TRL_ALTIUM2PCB_ComplexPolyPath_OLD(n_points)) 
				(path_list = cons(list(path t_layer shape) path_list)) 
				(trl_altium2pcb_global->exeption = cons("-->4.5.14 ERROR   - Region Shape NOT Created! Temporary Shape Structure failed!!" 
					(trl_altium2pcb_global->exeption)
				    ))
			    )
			    else 
			    (trl_altium2pcb_global->exeption = cons("-->4.5.13 ERROR   - Region Shape NOT Created! Polygon Path failed!!" 
				    (trl_altium2pcb_global->exeption)
				))
			) else
			(trl_altium2pcb_global->exeption = cons("-->4.5.12 ERROR   - Region Shape NOT Created! Check Polygon Date syntax!!" 
				(trl_altium2pcb_global->exeption)
			    ))
		    )
		)
	    ) else 
	    (trl_altium2pcb_global->exeption = cons("   4.5.13 INFO    - NO REGIONS exist!!" 
		    (trl_altium2pcb_global->exeption)
		))
	) 
	list(path_list max_val_lst)
    )
)
procedure(TRL_ALTIUM2PCB_CREATE_Footprint_Segment(pattern max_val_lst) 
    let((TrackRecords lay w pattern_layer mirror
	    x1y1 x2y2 pattern_rot pattern_x pattern_y
	    sym_layer seg_list l_points x1 y1
	    x2 y2
	) 
	(TrackRecords = car(nth(10 
		    (trl_altium2pcb_global->PcbRawList)
		)
	    )) 
	when(TrackRecords 
	    foreach(rec TrackRecords 
		when((get(rec 
			    'COMPONENT
			) == caddr(pattern)) 
		    (lay = get(rec 
			    'LAYER
			)) 
		    (x1 = TRL_ALTIUM2PCB_Util_DesignUnits(get(rec 
				'X1
			    )
			)) 
		    (y1 = TRL_ALTIUM2PCB_Util_DesignUnits(get(rec 
				'Y1
			    )
			)) 
		    (x2 = TRL_ALTIUM2PCB_Util_DesignUnits(get(rec 
				'X2
			    )
			))
		    (y2 = TRL_ALTIUM2PCB_Util_DesignUnits(get(rec 
				'Y2
			    )
			)) 
		    (w = TRL_ALTIUM2PCB_Util_DesignUnits(get(rec 
				'WIDTH
			    )
			)) 
		    (pattern_layer = nth(7 pattern)) 
		    (pattern_rot = nth(9 pattern)) 
		    (pattern_x = nth(5 pattern))
		    (pattern_y = nth(6 pattern)) 
		    (mirror = t) 
		    when((pattern_layer == "TOP") 
			(mirror = nil)
		    ) 
		    (sym_layer = TRL_ALTIUM2PCB_UTIL_Package_Layer_Map(mirror lay)) 
		    when((lay == "MECHANICAL1") 
			(sym_layer = "Package Geometry/Assembly_Top")
		    )
		    if(mirror then 
			(pattern_rot = (pattern_rot + 180)) else 
			(pattern_rot = (pattern_rot * -1))
		    ) 
		    (x1 = (x1 - pattern_x)) 
		    (y1 = (y1 - pattern_y)) 
		    (x1y1 = (axlGeoRotatePt pattern_rot 
			    (x1:y1) 
			    (0.0:0.0) mirror
			)) 
		    (max_val_lst = TRL_ALTIUM2PCB_UTIL_Find_Max_XY_Value(x1y1 max_val_lst))
		    (x2 = (x2 - pattern_x)) 
		    (y2 = (y2 - pattern_y)) 
		    (x2y2 = (axlGeoRotatePt pattern_rot 
			    (x2:y2) 
			    (0.0:0.0) mirror
			)) 
		    (max_val_lst = TRL_ALTIUM2PCB_UTIL_Find_Max_XY_Value(x2y2 max_val_lst)) 
		    (l_points = (axlPathStart 
			    list(x1y1 x2y2) w
			))
		    (seg_list = cons(list(l_points sym_layer) seg_list))
		)
	    )
	) 
	list(seg_list max_val_lst)
    )
)
procedure(TRL_ALTIUM2PCB_CREATE_Footprint_Text(cmp_id) 
    let((TextRecords lay sym_layer txt_list x
	    y rot height txt_mirr text
	    txtorient textblock comment ist_layer width
	) 
	(txt_list = list()) 
	(TextRecords = car(nth(11 
		    (trl_altium2pcb_global->PcbRawList)
		)
	    )) 
	when(TextRecords 
	    foreach(rec TextRecords 
		when((get(rec 
			    'COMPONENT
			) == cmp_id) 
		    (lay = get(rec 
			    'LAYER
			)) 
		    (width = TRL_ALTIUM2PCB_Util_DesignUnits(get(rec 
				'WIDTH
			    )
			)) 
		    (x = TRL_ALTIUM2PCB_Util_DesignUnits(get(rec 
				'X
			    )
			)) 
		    (y = TRL_ALTIUM2PCB_Util_DesignUnits(get(rec 
				'Y
			    )
			))
		    (rot = atof(get(rec 
				'ROTATION
			    )
			)) 
		    (height = TRL_ALTIUM2PCB_Util_DesignUnits(get(rec 
				'HEIGHT
			    )
			)) 
		    (txt_mirr = get(rec 
			    'MIRROR
			)) 
		    (comment = get(rec 
			    'COMMENT
			)) 
		    (text = get(rec 
			    'TEXT
			))
		    (textblock = TRL_ALTIUM2PCB_UTIL_Find_Text_Block(height width)) 
		    (sym_layer = TRL_ALTIUM2PCB_UTIL_Find_Layer(lay)) 
		    if(comment then 
			if((lay == "TOPOVERLAY") then 
			    (sym_layer = "Package Geometry/Display_Top") else 
			    if((lay == "BOTTOMOVERLAY") then 
				(sym_layer = "Package Geometry/Display_Bottom") else 
				(sym_layer = "Package Geometry/Misc")
				(ist_layer = (axlLayerGet sym_layer)) 
				unless(ist_layer 
				    (axlLayerCreateNonConductor sym_layer)
				)
			    )
			) else 
			(sym_layer = sprintf(nil "Package Geometry/%s" 
				cadr(sym_layer)
			    ))
			(ist_layer = (axlLayerGet sym_layer)) 
			unless(ist_layer 
			    (axlLayerCreateNonConductor sym_layer)
			)
		    ) 
		    (txtorient = (make_axlTextOrientation ?textBlock textblock ?rotation rot
			    ?mirrored txt_mirr ?justify "left"
			)) 
		    (txt_list = cons(list(text 
				(x:y) txtorient sym_layer
			    ) txt_list
			))
		)
	    )
	) txt_list
    )
)
procedure(TRL_ALTIUM2PCB_CREATE_Footprint_VIAs(pattern max_val_lst) 
    let((ViaRecords via_list via_typ net_id x
	    y pad_size drill start_lay end_lay
	    via_name ret db_via pad_path
	) 
	(via_list = list()) 
	(ViaRecords = car(nth(9 
		    (trl_altium2pcb_global->PcbRawList)
		)
	    )) 
	when(ViaRecords 
	    foreach(rec ViaRecords 
		when((get(rec 
			    'COMPONENT
			) == caddr(pattern)) 
		    (via_typ = get(rec 
			    'LAYER
			)) 
		    (net_id = get(rec 
			    'NET
			)) 
		    (x = TRL_ALTIUM2PCB_Util_DesignUnits(get(rec 
				'X
			    )
			)) 
		    (y = TRL_ALTIUM2PCB_Util_DesignUnits(get(rec 
				'Y
			    )
			))
		    (pad_size = TRL_ALTIUM2PCB_Util_DesignUnits(get(rec 
				'DIAMETER
			    )
			)) 
		    (drill = TRL_ALTIUM2PCB_Util_DesignUnits(get(rec 
				'HOLESIZE
			    )
			)) 
		    (start_lay = get(rec 
			    'STARTLAYER
			)) 
		    (end_lay = get(rec 
			    'ENDLAYER
			)) 
		    (ret = TRL_ALTIUM2PCB_Transform_Footprint_Coordinate(pattern 
			    (x:y) max_val_lst
			))
		    (x = car(ret)) 
		    (y = cadr(x)) 
		    (x = car(x)) 
		    (max_val_lst = caddr(ret)) 
		    if(((start_lay == "TOP") && (end_lay == "BOTTOM")) then 
			when((via_typ == "MULTILAYER") 
			    (via_name = sprintf(nil "via_%dd%d" 
				    round(pad_size) 
				    round(drill)
				))
			) else 
			when((via_typ == "MULTILAYER") 
			    (via_name = sprintf(nil "via_%dd%d_%s-%s" 
				    round(pad_size) 
				    round(drill) start_lay
				    end_lay
				))
			)
		    )
		    (db_via = (axlLoadPadstack via_name)) 
		    unless(db_via 
			(pad_path = nth(4 
				(trl_altium2pcb_global->settings)
			    )) 
			(pad_path = simplifyFilename(pad_path)) 
			(pad_path = (axlOSSlash pad_path)) 
			unless(isDir(pad_path) 
			    createDir(pad_path)
			)
			if((isDir(pad_path) && isReadable(pad_path)) then 
			    (ret = TRL_ALTIUM2PCB_CREATE_Footprint_VIAs_Process(via_name drill start_lay end_lay pad_path
				    pad_size
				)) else 
			    (trl_altium2pcb_global->exeption = cons(sprintf(nil "-->4.5.22 ERROR   - PADPATH DIR: %L don't exist or can't be accessed!" pad_path) 
				    (trl_altium2pcb_global->exeption)
				))
			) 
			if(ret then 
			    (db_via = (axlLoadPadstack via_name)) else 
			    (trl_altium2pcb_global->exeption = cons(sprintf(nil "-->4.5.23 ERROR   - VIA: %L PADPATH DIR: %L don't exist or can't be accessed!" via_name pad_path) 
				    (trl_altium2pcb_global->exeption)
				))
			)
		    ) 
		    if(db_via then 
			(via_list = cons(list(via_name 
				    (x:y)
				) via_list
			    )) 
			(ret = (axlCnsAddVia "DEFAULT" via_name)) 
			unless(ret 
			    (trl_altium2pcb_global->exeption = cons(sprintf(nil "-->4.5.26 WARNING - VIA:%L CANNOT ADD TO PHYSICAL CNS!" via_name) 
				    (trl_altium2pcb_global->exeption)
				))
			)
			when(nth(8 
				(trl_altium2pcb_global->settings)
			    ) 
			    (trl_altium2pcb_global->exeption = cons(sprintf(nil "   4.5.25 INFO    - VIA:%L via_typ:%L net_id:%L x:%L y:%L pad_size:%L drill:%L start_lay:%L end_lay:%L!" via_name via_typ net_id
					x y pad_size drill start_lay
					end_lay
				    ) 
				    (trl_altium2pcb_global->exeption)
				))
			) else 
			(trl_altium2pcb_global->exeption = cons(sprintf(nil "-->4.5.24 WARNING - VIA:%L via_typ:%L net_id:%L x:%L y:%L pad_size:%L drill:%L start_lay:%L end_lay:%L!" via_name via_typ net_id
				    x y pad_size drill start_lay
				    end_lay
				) 
				(trl_altium2pcb_global->exeption)
			    ))
		    )
		)
	    )
	) 
	list(via_list max_val_lst)
    )
)
procedure(TRL_ALTIUM2PCB_CREATE_Footprint_VIAs_Process(via_name drill start_lay end_lay pad_path
	pad_size
    ) 
    let((drill_handle pads_handle ps_id start_lay_nr end_lay_nr
	    go_index sorted_layer_stack ps_dbid
	) 
	(ps_id = nil) 
	(ps_dbid = nil) 
	if(zerop(drill) then 
	    (drill_handle = nil) else 
	    (drill_handle = (make_axlPadStackDrill ?drillDiameter drill ?plating 
		    'PLATED
		))
	) 
	(pads_handle = list())
	if(((start_lay == "TOP") && (end_lay == "BOTTOM")) then 
	    (pads_handle = cons((make_axlPadStackPad ?layer "TOP" ?type 
			'REGULAR
			?figure 
			'CIRCLE ?figureSize 
			(pad_size:pad_size)
		    ) pads_handle
		)) 
	    (pads_handle = cons((make_axlPadStackPad ?layer "DEFAULT INTERNAL" ?type 
			'REGULAR
			?figure 
			'CIRCLE ?figureSize 
			(pad_size:pad_size)
		    ) pads_handle
		)) 
	    (pads_handle = cons((make_axlPadStackPad ?layer "BOTTOM" ?type 
			'REGULAR
			?figure 
			'CIRCLE ?figureSize 
			(pad_size:pad_size)
		    ) pads_handle
		))
	    (ps_id = (axlDBCreatePadStack via_name drill_handle pads_handle t)) 
	    if(ps_id then 
		(ps_dbid = (axlPadstackToDisk via_name 
			sprintf(nil "%s/%s" pad_path via_name)
		    )) 
		when(nth(8 
			(trl_altium2pcb_global->settings)
		    ) 
		    (trl_altium2pcb_global->exeption = cons(sprintf(nil "   4.5.27 INFO    - VIA Padstack: %L created." via_name) 
			    (trl_altium2pcb_global->exeption)
			))
		) else
		(trl_altium2pcb_global->exeption = cons(sprintf(nil "-->4.5.27 ERROR   - VIA Padstack: %L NOT created!" via_name) 
			(trl_altium2pcb_global->exeption)
		    ))
	    ) else 
	    (start_lay_nr = TRL_ALTIUM2PCB_Util_Find_Layer_Number(start_lay)) 
	    (end_lay_nr = TRL_ALTIUM2PCB_Util_Find_Layer_Number(end_lay))
	    (go_index = nil) 
	    (sorted_layer_stack = TRL_ALTIUM2PCB_Util_Sort_Layer_Stack()) 
	    foreach(sorted_layer sorted_layer_stack 
		when((end_lay_nr == car(sorted_layer)) 
		    (go_index = nil) 
		    if((end_lay_nr == 32) then 
			(pads_handle = cons((make_axlPadStackPad ?layer "BOTTOM" ?type 
				    'REGULAR
				    ?figure 
				    'CIRCLE ?figureSize 
				    (pad_size:pad_size)
				) pads_handle
			    )) else 
			(pads_handle = cons((make_axlPadStackPad ?layer 
				    cadr(sorted_layer) ?type 
				    'REGULAR
				    ?figure 
				    'CIRCLE ?figureSize 
				    (pad_size:pad_size)
				) pads_handle
			    ))
		    )
		) 
		when(go_index 
		    (pads_handle = cons((make_axlPadStackPad ?layer 
				cadr(sorted_layer) ?type 
				'REGULAR
				?figure 
				'CIRCLE ?figureSize 
				(pad_size:pad_size)
			    ) pads_handle
			))
		) 
		when((start_lay_nr == car(sorted_layer)) 
		    (go_index = t) 
		    if(onep(start_lay_nr) then 
			(pads_handle = cons((make_axlPadStackPad ?layer "TOP" ?type 
				    'REGULAR
				    ?figure 
				    'CIRCLE ?figureSize 
				    (pad_size:pad_size)
				) pads_handle
			    )) else 
			(pads_handle = cons((make_axlPadStackPad ?layer 
				    cadr(sorted_layer) ?type 
				    'REGULAR
				    ?figure 
				    'CIRCLE ?figureSize 
				    (pad_size:pad_size)
				) pads_handle
			    ))
		    )
		)
	    ) 
	    (ps_id = (axlDBCreatePadStack via_name drill_handle pads_handle t)) 
	    if(ps_id then 
		(ps_dbid = (axlPadstackToDisk via_name 
			sprintf(nil "%s/%s" pad_path via_name)
		    )) 
		when(nth(8 
			(trl_altium2pcb_global->settings)
		    ) 
		    (trl_altium2pcb_global->exeption = cons(sprintf(nil "   4.5.28 INFO    - VIA Padstack: %L created." via_name) 
			    (trl_altium2pcb_global->exeption)
			))
		) else
		(trl_altium2pcb_global->exeption = cons(sprintf(nil "-->4.5.28 ERROR   - VIA Padstack: %L NOT created!" via_name) 
			(trl_altium2pcb_global->exeption)
		    ))
	    )
	) ps_dbid
    )
)
procedure(TRL_ALTIUM2PCB_CREATE_KeepOut() 
    let((reg_misc keepout FillRecords ArcRecords TrackRecords
	    k_layer
	) 
	(trl_altium2pcb_global->exeption = cons("   3.3.01 INFO    - Start to Create KeepOut" 
		(trl_altium2pcb_global->exeption)
	    )) 
	(reg_misc = nth(12 
		(trl_altium2pcb_global->PcbRawList)
	    )) 
	when(reg_misc 
	    (reg_misc = nth(3 reg_misc))
	) 
	when(reg_misc 
	    foreach(rec reg_misc 
		(keepout = get(rec 
			'KEEPOUT
		    )) 
		when((keepout && (keepout == "TRUE")) 
		    TRL_ALTIUM2PCB_CREATE_Shape_KeepOut(rec)
		)
	    )
	)
	(FillRecords = caddr(nth(13 
		    (trl_altium2pcb_global->PcbRawList)
		)
	    )) 
	when(FillRecords 
	    foreach(rec FillRecords 
		(keepout = get(rec 
			'KEEPOUT
		    )) 
		when((keepout && (keepout == "TRUE")) 
		    TRL_ALTIUM2PCB_CREATE_Fills_KeepOut(rec)
		)
	    )
	) 
	(TrackRecords = caddr(nth(10 
		    (trl_altium2pcb_global->PcbRawList)
		)
	    )) 
	when(TrackRecords 
	    foreach(rec TrackRecords 
		(keepout = get(rec 
			'KEEPOUT
		    )) 
		when((keepout && (keepout == "TRUE")) 
		    TRL_ALTIUM2PCB_CREATE_Track_KeepOut(rec)
		)
	    )
	) 
	(ArcRecords = nth(7 
		(trl_altium2pcb_global->PcbRawList)
	    ))
	when(ArcRecords 
	    foreach(rec ArcRecords 
		(keepout = get(rec 
			'KEEPOUT
		    )) 
		(k_layer = get(rec 
			'LAYER
		    )) 
		when(((keepout == "TRUE") || (k_layer == "KEEPOUT")) 
		    TRL_ALTIUM2PCB_CREATE_Arc_KeepOut(rec)
		)
	    )
	)
    )
)
procedure(TRL_ALTIUM2PCB_CREATE_Logical2Physical_PinMapping(pattern_name component_id) 
    let((Check_List PadRecords index net drill
	    layer pin_nr x y mid30
	    new_pin_name new_pins pin_list sonder_l mech_l
	    new_mech_l
	) 
	(Check_List = list()) 
	(mech_l = list()) 
	(PadRecords = car(nth(8 
		    (trl_altium2pcb_global->PcbRawList)
		)
	    )) 
	(index = 1)
	when(PadRecords 
	    foreach(rec PadRecords 
		when((get(rec 
			    'COMPONENT
			) == component_id) 
		    (pin_nr = get(rec 
			    'NAME
			)) 
		    (x = get(rec 
			    'X
			)) 
		    (y = get(rec 
			    'Y
			)) 
		    (layer = get(rec 
			    'LAYER
			))
		    (mid30 = get(rec 
			    'MID30XSIZE
			)) 
		    (drill = get(rec 
			    'HOLESIZE
			)) 
		    (net = get(rec 
			    'NET
			)) 
		    when((pin_nr == " ") 
			printf("--PIN NR SPACE-> %L %L %L\n" x y layer) 
			(pin_nr = "NN")
		    ) 
		    if(pin_nr then 
			(Check_List = cons(list(pin_nr x y layer mid30
				    drill net rec
				) Check_List
			    )) else 
			(mech_l = cons(list(pin_nr x y layer mid30
				    drill net rec
				) mech_l
			    ))
		    )
		)
	    )
	) 
	(pin_list = list()) 
	(sonder_l = list()) 
	(new_pins = list()) 
	if(Check_List then 
	    (Check_List = sortcar(Check_List nil)) 
	    (index = 1) 
	    foreach(pad Check_List 
		if(((nth(3 pad) == "TOPSOLDER") || 
			(nth(3 pad) == "BOTTOMSOLDER")) then 
		    (sonder_l = cons(pad sonder_l)) else 
		    if(member(car(pad) pin_list) then 
			(new_pin_name = sprintf(nil "%s_%d" 
				car(pad) index
			    )) 
			if(member(new_pin_name pin_list) then 
			    (new_pin_name = sprintf(nil "%s_%d" new_pin_name index)) 
			    (pin_list = cons(new_pin_name pin_list)) 
			    (new_pins = cons(cons(TRL_ALTIUM2PCB_Util_Namemaper(new_pin_name) pad) new_pins))
			    else 
			    (pin_list = cons(new_pin_name pin_list)) 
			    (new_pins = cons(cons(TRL_ALTIUM2PCB_Util_Namemaper(new_pin_name) pad) new_pins))
			) 
			index++
			else 
			(pin_list = cons(car(pad) pin_list)) 
			(new_pins = cons(cons(TRL_ALTIUM2PCB_Util_Namemaper(car(pad)) pad) new_pins))
		    )
		)
	    )
	    else 
	    (trl_altium2pcb_global->exeption = cons(sprintf(nil "-->4.2.04 WARNING - ComponentPins DO NOT exist!! %L %L" pattern_name component_id) 
		    (trl_altium2pcb_global->exeption)
		))
	)
	when(mech_l 
	    foreach(pad mech_l 
		(new_mech_l = cons(cons(nil pad) new_mech_l))
	    )
	) 
	list(new_pins new_mech_l sonder_l)
    )
)
procedure(TRL_ALTIUM2PCB_CREATE_Mechanical_Holes() 
    let((PadRecords net_id ref_des pattern net
	    x y sond_list ref_des_ind pattern_ind
	    name dbid padstack_name pad
	) 
	(PadRecords = cadr(nth(8 
		    (trl_altium2pcb_global->PcbRawList)
		)
	    )) 
	(ref_des_ind = 1) 
	(pattern_ind = 1) 
	(sond_list = list())
	when(PadRecords 
	    foreach(pad_data PadRecords 
		(net_id = get(pad_data 
			'NET
		    )) 
		(name = get(pad_data 
			'NAME
		    )) 
		(x = TRL_ALTIUM2PCB_Util_DesignUnits(get(pad_data 
			    'X
			)
		    ))
		(y = TRL_ALTIUM2PCB_Util_DesignUnits(get(pad_data 
			    'Y
			)
		    )) 
		when(net_id 
		    foreach(rec 
			(trl_altium2pcb_global->NetsList) 
			when((cadr(rec) == net_id) 
			    (net = car(rec))
			)
		    ) 
		    when(nth(8 
			    (trl_altium2pcb_global->settings)
			) 
			(trl_altium2pcb_global->exeption = cons(sprintf(nil "   3.7.5  INFO    - Mechanical Pad X:%L Y: %L Attached to Net: %L" x y net) 
				(trl_altium2pcb_global->exeption)
			    ))
		    )
		) 
		(ref_des = sprintf(nil "M_%d" ref_des_ind)) 
		(pattern = sprintf(nil "MEC_%d" pattern_ind)) 
		(pattern = list(nil nil pattern))
		(pad_data = list(name nil nil nil nil
			nil nil nil pad_data
		    )) 
		(pad_data = TRL_ALTIUM2PCB_CREATE_PadStack(ref_des pattern pad_data sond_list)) 
		(pad = car(pad_data)) 
		(padstack_name = cadr(pad_data)) 
		ref_des_ind++
		pattern_ind++ 
		if(padstack_name then 
		    (dbid = (axlDBCreateVia padstack_name 
			    (x:y) net
			)) 
		    if(dbid then 
			when(nth(8 
				(trl_altium2pcb_global->settings)
			    ) 
			    (trl_altium2pcb_global->exeption = cons(sprintf(nil "   3.7.1  INFO    - Mechanical Pad X:%L Y: %L Net: %L PadStack: %L CREATED" x y net
					padstack_name
				    ) 
				    (trl_altium2pcb_global->exeption)
				))
			) else 
			(trl_altium2pcb_global->exeption = cons(sprintf(nil "   3.7.1  ERROR   - Mechanical Pad %L X:%L Y: %L Net: %L PadStack: %L NOT CREATED" pad x y
				    net padstack_name
				) 
				(trl_altium2pcb_global->exeption)
			    ))
		    ) else
		    (trl_altium2pcb_global->exeption = cons(sprintf(nil "   3.7.4  WARNING - Mechanical Pad X:%L Y: %L Attached to Net: %L NOT Created" x y net) 
			    (trl_altium2pcb_global->exeption)
			))
		)
	    )
	)
    )
)
procedure(TRL_ALTIUM2PCB_CREATE_NETS() 
    let((NetRecords net_name net_name_lst id) 
	(net_name_lst = list()) 
	(trl_altium2pcb_global->NetsList = list()) 
	(NetRecords = caddr((trl_altium2pcb_global->PcbRawList))) 
	when(NetRecords 
	    foreach(rec NetRecords 
		(net_name = get(rec 
			'NAME
		    )) 
		(net_name = TRL_ALTIUM2PCB_Util_NetName_Namemaper(net_name)) 
		(id = get(rec 
			'ID
		    ))
		(net_name_lst = cons(list(net_name id) net_name_lst)) 
		(axlDBCreateNet net_name)
	    )
	)
	(trl_altium2pcb_global->NetsList = net_name_lst)
    )
)
procedure(TRL_ALTIUM2PCB_CREATE_PadStack(ref_des pattern pad sond_list) 
    let((pad_data drill_handle pads_handle drill_dia ps_id
	    padstack_name component_id layer x_offset y_offset
	    paste solder xsize ysize corner_rad
	    ss_name ps_name ls_name shape plating
	    pads_list pad_item pad_items lay_nr slot
	    holerot slot_size
	) 
	(component_id = caddr(pattern)) 
	(pad_data = nth(8 pad)) 
	(layer = get(pad_data 
		'LAYER
	    )) 
	(pads_list = list())
	(drill_dia = TRL_ALTIUM2PCB_Util_DesignUnits(get(pad_data 
		    'HOLESIZE
		)
	    )) 
	(plating = get(pad_data 
		'PLATED
	    )) 
	(slot = get(pad_data 
		'HOLEWIDTH
	    )) 
	(holerot = get(pad_data 
		'HOLEROTATION
	    )) 
	when(slot 
	    (slot = TRL_ALTIUM2PCB_Util_DesignUnits(slot))
	)
	(x_offset = get(pad_data 
		'PADXOFFSET0
	    )) 
	(y_offset = get(pad_data 
		'PADYOFFSET0
	    )) 
	if(x_offset then 
	    (x_offset = TRL_ALTIUM2PCB_Util_DesignUnits(x_offset)) else 
	    (x_offset = 0.0)
	) 
	if(y_offset then 
	    (y_offset = TRL_ALTIUM2PCB_Util_DesignUnits(y_offset)) else 
	    (y_offset = 0.0)
	) 
	if((layer == "MULTILAYER") then 
	    (pads_list = TRL_ALTIUM2PCB_Define_PadStack_Type(pad_data)) else 
	    (xsize = TRL_ALTIUM2PCB_Util_DesignUnits(get(pad_data 
			'XSIZE
		    )
		))
	    (ysize = TRL_ALTIUM2PCB_Util_DesignUnits(get(pad_data 
			'YSIZE
		    )
		)) 
	    (shape = get(pad_data 
		    'SHAPE
		)) 
	    (corner_rad = get(pad_data 
		    'TOPLAYERCRPCT
		)) 
	    when(corner_rad 
		(corner_rad = atoi(corner_rad))
	    ) 
	    when(((zerop(xsize) || zerop(ysize)) && (drill_dia > 0)) 
		(xsize = (drill_dia / 10)) 
		(ysize = (drill_dia / 10))
	    )
	    (shape = TRL_ALTIUM2PCB_Find_PadStack_Figure(shape xsize ysize)) 
	    (pads_list = list("SINGLE" layer 
		    list(list(layer xsize ysize shape corner_rad
			    x_offset y_offset
			)
		    )
		))
	)
	if(get(pad_data 
		'CPE
	    ) then 
	    (paste = (atoi(get(pad_data 
			    'CPE
			)
		    ) * 1.0)) else 
	    (paste = -1.0)
	) 
	if(get(pad_data 
		'CSE
	    ) then 
	    (solder = (atoi(get(pad_data 
			    'CSE
			)
		    ) * 1.0)) else 
	    (solder = -1.0)
	) 
	(padstack_name = TRL_ALTIUM2PCB_Util_Namemaper(car(pad))) 
	(padstack_name = sprintf(nil "%s-%s" ref_des padstack_name)) 
	(padstack_name = TRL_ALTIUM2PCB_Define_PadStack_name(padstack_name 
		list(drill_dia plating slot) pads_list paste solder
	    ))
	unless(member(padstack_name 
		(trl_altium2pcb_global->PadStacklist)
	    ) 
	    if(zerop(drill_dia) then 
		(drill_handle = nil) else 
		if((slot > 0) then 
		    (slot_size = (drill_dia:slot)) 
		    when((holerot == " 0.00000000000000E+0000") 
			(slot_size = (slot:drill_dia))
		    ) 
		    (drill_handle = (make_axlPadStackDrill ?holeType 
			    'OVAL_SLOT ?slotSize slot_size
			    ?plating 
			    'PLATED
			))
		    else 
		    (drill_handle = (make_axlPadStackDrill ?drillDiameter drill_dia ?plating 
			    'PLATED
			))
		)
	    ) 
	    (pads_handle = list()) 
	    if((car(pads_list) == "SINGLE") then 
		(pad_item = caaddr(pads_list)) 
		(layer = car(pad_item)) 
		(shape = (nth(3 pad_item)->figure))
		(xsize = cadr(pad_item)) 
		(ysize = caddr(pad_item)) 
		(corner_rad = nth(4 pad_item)) 
		when((nth(7 pattern) == "BOTTOM") 
		    case(layer 
			("TOP" 
			    (layer = "BOTTOM")
			) 
			("BOTTOM" 
			    (layer = "TOP")
			) 
			(t 
			    printf("--single case - unknown layer: %L\n" pads_list)
			)
		    )
		) 
		unless(((layer == "BOTTOM") || (layer == "TOP")) 
		    (lay_nr = TRL_ALTIUM2PCB_Util_Find_Layer_Number(layer)) 
		    foreach(lay 
			(trl_altium2pcb_global->LayerStack) 
			when((lay_nr == car(lay)) 
			    (layer = cadr(lay))
			)
		    )
		)
		if((shape == 'ROUNDEDRECTANGLE) then 
		    (ss_name = TRL_ALTIUM2PCB_Create_Pad_Shape(padstack_name xsize ysize corner_rad)) 
		    (pads_handle = cons((make_axlPadStackPad ?layer layer ?type 
				'REGULAR
				?figure ss_name ?figureSize 
				(xsize:ysize) ?offset
				(x_offset:y_offset)
			    ) pads_handle
			)) 
		    when((paste >= 0) 
			if(zerop(paste) then 
			    (ps_name = ss_name) else 
			    (ps_name = TRL_ALTIUM2PCB_Create_Pad_Shape(padstack_name 
				    (xsize + (2 * paste)) 
				    (ysize + (2 * paste)) corner_rad
				))
			) 
			(pads_handle = cons((make_axlPadStackPad ?layer 
				    sprintf(nil "PASTEMASK_%s" layer) ?type 
				    'REGULAR
				    ?figure ps_name ?figureSize 
				    (xsize:ysize)
				) pads_handle
			    ))
		    )
		    when((solder >= 0) 
			if(zerop(solder) then 
			    (ls_name = ss_name) else 
			    (ls_name = TRL_ALTIUM2PCB_Create_Pad_Shape(padstack_name 
				    (xsize + (2 * solder)) 
				    (ysize + (2 * solder)) corner_rad
				))
			) 
			(pads_handle = cons((make_axlPadStackPad ?layer 
				    sprintf(nil "SOLDERMASK_%s" layer) ?type 
				    'REGULAR
				    ?figure ls_name ?figureSize 
				    (xsize:ysize)
				) pads_handle
			    ))
		    ) else 
		    if((zerop(xsize) && zerop(ysize)) then 
			(pads_handle = cons((make_axlPadStackPad ?layer "TOP" ?type 
				    'REGULAR
				    ?figure 
				    'NULL ?figureSize 
				    (xsize:ysize) ?offset
				    (x_offset:y_offset)
				) pads_handle
			    )) 
			(pads_handle = cons((make_axlPadStackPad ?layer "FILMMASKTOP" ?type 
				    'REGULAR
				    ?figure shape ?figureSize 
				    (10.0:10.0) ?offset
				    (x_offset:y_offset)
				) pads_handle
			    )) else
			(pads_handle = cons((make_axlPadStackPad ?layer layer ?type 
				    'REGULAR
				    ?figure shape ?figureSize 
				    (xsize:ysize) ?offset
				    (x_offset:y_offset)
				) pads_handle
			    )) 
			when(((layer == "BOTTOM") || (layer == "TOP")) 
			    when((paste >= 0) 
				(pads_handle = cons((make_axlPadStackPad ?layer 
					    sprintf(nil "PASTEMASK_%s" layer) ?type 
					    'REGULAR
					    ?figure shape ?figureSize 
					    ((xsize + (2 * paste)):(ysize + (2 * paste))) ?offset
					    (x_offset:y_offset)
					) pads_handle
				    ))
			    ) 
			    when((solder >= 0) 
				(pads_handle = cons((make_axlPadStackPad ?layer 
					    sprintf(nil "SOLDERMASK_%s" layer) ?type 
					    'REGULAR
					    ?figure shape ?figureSize 
					    ((xsize + (2 * solder)):(ysize + (2 * solder))) ?offset
					    (x_offset:y_offset)
					) pads_handle
				    ))
			    )
			)
		    )
		) else 
		(pad_items = caddr(pads_list)) 
		when((nth(7 pattern) == "BOTTOM") 
		    (pad_items = reverse(pad_items))
		) 
		(pad_item = car(pad_items))
		(layer = car(pad_item)) 
		(shape = (nth(3 pad_item)->figure)) 
		(xsize = cadr(pad_item)) 
		(ysize = caddr(pad_item)) 
		(corner_rad = nth(4 pad_item))
		if((shape == 'ROUNDEDRECTANGLE) then 
		    (ss_name = TRL_ALTIUM2PCB_Create_Pad_Shape(padstack_name xsize ysize corner_rad)) 
		    (pads_handle = cons((make_axlPadStackPad ?layer "TOP" ?type 
				'REGULAR
				?figure ss_name ?figureSize 
				(xsize:ysize) ?offset
				(x_offset:y_offset)
			    ) pads_handle
			)) 
		    when((solder >= 0) 
			if(zerop(solder) then 
			    (ls_name = ss_name) else 
			    (ls_name = TRL_ALTIUM2PCB_Create_Pad_Shape(padstack_name 
				    (xsize + (2 * solder)) 
				    (ysize + (2 * solder)) corner_rad
				))
			) 
			(pads_handle = cons((make_axlPadStackPad ?layer "SOLDERMASK_TOP" ?type 
				    'REGULAR
				    ?figure ls_name ?figureSize 
				    (xsize:ysize) ?offset
				    (x_offset:y_offset)
				) pads_handle
			    ))
		    )
		    else 
		    (pads_handle = cons((make_axlPadStackPad ?layer "TOP" ?type 
				'REGULAR
				?figure shape ?figureSize 
				(xsize:ysize) ?offset
				(x_offset:y_offset)
			    ) pads_handle
			)) 
		    when((solder >= 0) 
			(pads_handle = cons((make_axlPadStackPad ?layer "SOLDERMASK_TOP" ?type 
				    'REGULAR
				    ?figure shape ?figureSize 
				    ((xsize + (2 * solder)):(ysize + (2 * solder))) ?offset
				    (x_offset:y_offset)
				) pads_handle
			    ))
		    )
		) 
		(pad_item = car(last(pad_items))) 
		(layer = car(pad_item)) 
		(shape = (nth(3 pad_item)->figure)) 
		(xsize = cadr(pad_item))
		(ysize = caddr(pad_item)) 
		(corner_rad = nth(4 pad_item)) 
		if((shape == 'ROUNDEDRECTANGLE) then 
		    (ss_name = TRL_ALTIUM2PCB_Create_Pad_Shape(padstack_name xsize ysize corner_rad)) 
		    (pads_handle = cons((make_axlPadStackPad ?layer "BOTTOM" ?type 
				'REGULAR
				?figure ss_name ?figureSize 
				(xsize:ysize) ?offset
				(x_offset:y_offset)
			    ) pads_handle
			)) 
		    when((solder >= 0) 
			if(zerop(solder) then 
			    (ls_name = ss_name) else 
			    (ls_name = TRL_ALTIUM2PCB_Create_Pad_Shape(padstack_name 
				    (xsize + (2 * solder)) 
				    (ysize + (2 * solder)) corner_rad
				))
			) 
			(pads_handle = cons((make_axlPadStackPad ?layer "SOLDERMASK_BOTTOM" ?type 
				    'REGULAR
				    ?figure ls_name ?figureSize 
				    (xsize:ysize) ?offset
				    (x_offset:y_offset)
				) pads_handle
			    ))
		    )
		    else 
		    (pads_handle = cons((make_axlPadStackPad ?layer "BOTTOM" ?type 
				'REGULAR
				?figure shape ?figureSize 
				(xsize:ysize) ?offset
				(x_offset:y_offset)
			    ) pads_handle
			)) 
		    when((solder >= 0) 
			(pads_handle = cons((make_axlPadStackPad ?layer "SOLDERMASK_BOTTOM" ?type 
				    'REGULAR
				    ?figure shape ?figureSize 
				    ((xsize + (2 * solder)):(ysize + (2 * solder))) ?offset
				    (x_offset:y_offset)
				) pads_handle
			    ))
		    )
		) 
		for(i 1 
		    (length(pad_items) - 2) 
		    (pad_item = nth(i pad_items)) 
		    (layer = car(pad_item))
		    (shape = (nth(3 pad_item)->figure)) 
		    (xsize = cadr(pad_item)) 
		    (ysize = caddr(pad_item)) 
		    (corner_rad = nth(4 pad_item)) 
		    if((shape == 'ROUNDEDRECTANGLE) then 
			(ss_name = TRL_ALTIUM2PCB_Create_Pad_Shape(padstack_name xsize ysize corner_rad)) 
			(pads_handle = cons((make_axlPadStackPad ?layer layer ?type 
				    'REGULAR
				    ?figure ss_name ?figureSize 
				    (xsize:ysize) ?offset
				    (x_offset:y_offset)
				) pads_handle
			    )) else
			(pads_handle = cons((make_axlPadStackPad ?layer layer ?type 
				    'REGULAR
				    ?figure shape ?figureSize 
				    (xsize:ysize) ?offset
				    (x_offset:y_offset)
				) pads_handle
			    ))
		    )
		)
	    ) 
	    (ps_id = (axlDBCreatePadStack padstack_name drill_handle pads_handle t))
	    if(ps_id then 
		(trl_altium2pcb_global->PadStacklist = cons(padstack_name 
			(trl_altium2pcb_global->PadStacklist)
		    )) 
		(trl_altium2pcb_global->exeption = cons(sprintf(nil "   4.4.1  INFO    - Padstack %L created %L" padstack_name ps_id) 
			(trl_altium2pcb_global->exeption)
		    )) else
		(trl_altium2pcb_global->exeption = cons(sprintf(nil "-->4.4.1  ERROR   - Padstack %L NOT created %L -> %L %L %L %L %L %L %L %L %L %L %L %L [%L %L] %L %L" padstack_name ps_id ref_des
			    car(pad) drill_dia plating shape layer
			    xsize ysize x_offset y_offset paste
			    solder drill_handle pads_handle sond_list component_id
			) 
			(trl_altium2pcb_global->exeption)
		    )) 
		(padstack_name = "VIA")
	    )
	) 
	list(pad padstack_name pad_data)
    )
)
procedure(TRL_ALTIUM2PCB_CREATE_Pattern_List() 
    let((ComponentRecords pattern_lst pattern id ind
	    refdes new_pattern_lst flt_pattern_lst gen_pattern_name pattern_id
	    pattern_refdes max_ind flat_str patt_n flat_pattern_name
	    pattern_x pattern_y pattern_layer pattern_locked pattern_rot
	    index refdes_str new_refdes pattern_orgref new_pattern
	    pattern_str org_pattern_name org_pattern org_refdes layer
	    rot locked x y inp
	    intermediate
	) 
	(pattern_lst = list()) 
	if((axlFormGetField 
		(trl_altium2pcb_global->formid) "load_intermediate"
	    ) then 
	    (intermediate = (axlFormGetField 
		    (trl_altium2pcb_global->formid) "intermediate_l"
		)) 
	    (intermediate = strcat(intermediate "/ComponentRecords.txt")) 
	    (inp = infile(intermediate))
	    (ComponentRecords = lineread(inp)) 
	    close(inp) else 
	    (ComponentRecords = nth(3 
		    (trl_altium2pcb_global->PcbRawList)
		))
	) 
	when(ComponentRecords 
	    foreach(rec ComponentRecords 
		(id = get(rec 
			'ID
		    )) 
		(org_pattern = get(rec 
			'PATTERN
		    )) 
		(pattern = TRL_ALTIUM2PCB_Util_Namemaper(org_pattern))
		(org_refdes = get(rec 
			'SOURCEDESIGNATOR
		    )) 
		foreach(pcb 
		    car(nth(11 
			    (trl_altium2pcb_global->PcbRawList)
			)
		    ) 
		    when((id == get(pcb 
				'COMPONENT
			    )) 
			when((get(pcb 
				    'DESIGNATOR
				) == "True") 
			    (org_refdes = get(pcb 
				    'TEXT
				))
			)
		    )
		) 
		when(org_refdes 
		    (refdes = TRL_ALTIUM2PCB_Util_Namemaper(org_refdes))
		) 
		when(refdes 
		    (refdes_str = parseString(refdes "")) 
		    if((length(refdes_str) <= 31) then 
			(new_refdes = refdes) else 
			(new_refdes = "")
			(index = 1) 
			for(i 1 28 
			    (new_refdes = sprintf(nil "%s%s" new_refdes 
				    nth(index refdes_str)
				)) 
			    index++
			) 
			(new_refdes = sprintf(nil "%s%d" new_refdes 
				(trl_altium2pcb_global->index)
			    )) 
			(trl_altium2pcb_global->index = ((trl_altium2pcb_global->index) + 1))
		    )
		) 
		when(pattern 
		    (layer = get(rec 
			    'LAYER
			)) 
		    (pattern_str = parseString(pattern "")) 
		    if((length(pattern_str) <= 31) then 
			(new_pattern = pattern) else 
			(new_pattern = "")
			(index = 1) 
			for(i 1 28 
			    (new_pattern = sprintf(nil "%s%s" new_pattern 
				    nth(index pattern_str)
				)) 
			    index++
			) 
			(new_pattern = sprintf(nil "%s%d" new_pattern 
				(trl_altium2pcb_global->index)
			    )) 
			(trl_altium2pcb_global->index = ((trl_altium2pcb_global->index) + 1))
		    )
		)
		(x = TRL_ALTIUM2PCB_Util_DesignUnits(get(rec 
			    'X
			)
		    )) 
		(y = TRL_ALTIUM2PCB_Util_DesignUnits(get(rec 
			    'Y
			)
		    )) 
		(locked = get(rec 
			'LOCKED
		    )) 
		(rot = atof(get(rec 
			    'ROTATION
			)
		    )) 
		(pattern_lst = cons(list(new_pattern id new_refdes x y
			    layer locked rot org_refdes org_pattern
			) pattern_lst
		    ))
	    )
	) 
	(pattern_lst = sortcar(pattern_lst nil))
	(new_pattern_lst = list()) 
	(flt_pattern_lst = list()) 
	foreach(patt pattern_lst 
	    (gen_pattern_name = car(patt)) 
	    (pattern_id = cadr(patt)) 
	    (pattern_refdes = caddr(patt))
	    (pattern_x = nth(3 patt)) 
	    (pattern_y = nth(4 patt)) 
	    (pattern_layer = nth(5 patt)) 
	    (pattern_locked = nth(6 patt)) 
	    (pattern_rot = nth(7 patt))
	    (pattern_orgref = nth(8 patt)) 
	    (org_pattern_name = nth(9 patt)) 
	    if(member(gen_pattern_name flt_pattern_lst) then 
		(max_ind = 0) 
		foreach(flat flt_pattern_lst 
		    unless((gen_pattern_name == flat) 
			(flat_str = parseString(flat "_")) 
			(ind = atoi(car(last(flat_str)))) 
			when(ind 
			    (patt_n = car(flat_str)) 
			    when((length(flat_str) > 2) 
				(flat_str = reverse(flat_str)) 
				(flat_str = cdr(flat_str)) 
				(flat_str = reverse(flat_str)) 
				(patt_n = buildString(flat_str "_"))
			    ) 
			    when((gen_pattern_name == patt_n) 
				when((ind > max_ind) 
				    (max_ind = ind)
				)
			    )
			)
		    )
		) 
		(flat_pattern_name = sprintf(nil "%s_%d" gen_pattern_name 
			(max_ind + 1)
		    ))
		(new_pattern_lst = cons(list(gen_pattern_name flat_pattern_name pattern_id 1 pattern_refdes
			    pattern_x pattern_y pattern_layer pattern_locked pattern_rot
			    pattern_orgref org_pattern_name
			) new_pattern_lst
		    )) 
		(flt_pattern_lst = cons(flat_pattern_name flt_pattern_lst)) else 
		(new_pattern_lst = cons(list(gen_pattern_name gen_pattern_name pattern_id 0 pattern_refdes
			    pattern_x pattern_y pattern_layer pattern_locked pattern_rot
			    pattern_orgref org_pattern_name
			) new_pattern_lst
		    )) 
		(flt_pattern_lst = cons(gen_pattern_name flt_pattern_lst))
	    )
	) 
	(intermediate = (trl_altium2pcb_global->intermediate)) 
	(trl_altium2pcb_global->intermediate = list(car(intermediate) t 
		caddr(intermediate)
	    ))
	(trl_altium2pcb_global->PartsList = new_pattern_lst)
    )
)
procedure((TRL_ALTIUM2PCB_CREATE_Pin pin_nr_pad pattern pattern_name xy_max_list
	pads_list \@optional mechanical
    ) 
    let((ref_des padstack layer rot mirror
	    x y pin pin_x pin_y
	    xy pin_str raw pin_rot
	) 
	(ref_des = nth(4 pattern)) 
	(padstack = cadr(pin_nr_pad)) 
	(layer = nth(7 pattern)) 
	(rot = nth(9 pattern))
	(mirror = t) 
	(pin_str = nil) 
	when((layer == "TOP") 
	    (mirror = nil)
	) 
	unless(ref_des 
	    (ref_des = pattern_name)
	) 
	(x = nth(5 pattern))
	(y = nth(6 pattern)) 
	(pin = car(pin_nr_pad)) 
	(raw = caddr(pin_nr_pad)) 
	(pin_x = (TRL_ALTIUM2PCB_Util_DesignUnits(caddr(pin)) - x)) 
	(pin_y = (TRL_ALTIUM2PCB_Util_DesignUnits(nth(3 pin)) - y))
	if(get(raw 
		'ROTATION
	    ) then 
	    (pin_rot = atof(get(raw 
			'ROTATION
		    )
		)) else 
	    (pin_rot = 0)
	) 
	(rot = (rot * -1)) 
	(pin_rot = (pin_rot - nth(9 pattern))) 
	when(mirror 
	    (rot = (nth(9 pattern) + 180.0)) 
	    if(get(raw 
		    'ROTATION
		) then 
		(pin_rot = atof(get(raw 
			    'ROTATION
			)
		    )) else 
		(pin_rot = 0)
	    ) 
	    (pin_rot = (nth(9 pattern) - pin_rot))
	) 
	(xy = (axlGeoRotatePt rot 
		(pin_x:pin_y) 
		(0.0:0.0) mirror
	    ))
	if(car(pin) then 
	    if(mechanical then 
		(pin_str = (make_axlPinData ?number "" ?padstack padstack
			?origin xy ?rotation pin_rot
		    )) else 
		(pin_str = (make_axlPinData ?number 
			car(pin) ?padstack padstack
			?origin xy ?rotation pin_rot
		    ))
	    ) else 
	    (pin_str = (make_axlPinData ?number "" ?padstack padstack
		    ?origin xy ?rotation pin_rot
		))
	) 
	when(pads_list t) 
	when(nth(8 
		(trl_altium2pcb_global->settings)
	    ) 
	    (trl_altium2pcb_global->exeption = cons(sprintf(nil "   4.4.02 INFO    - Pin Data Pin_Nr.: %L Padstack: %L XY: %L" 
			car(pin) 
			cadr(pin_nr_pad) xy
		    ) 
		    (trl_altium2pcb_global->exeption)
		))
	) 
	(xy_max_list = TRL_ALTIUM2PCB_UTIL_Find_Max_XY_Value(xy xy_max_list)) 
	list(pin_str xy_max_list)
    )
)
procedure(TRL_ALTIUM2PCB_CREATE_ROUTE() 
    let((TrackRecords net lay x1 y1
	    x2 y2 w f_width t_layer
	    signal dbCreate l_points r sa
	    ea mx my cmp V7
	    ArcRecords angle_s_rad angle_e_rad r_path arc_ind
	    seg_ind index
	) 
	(trl_altium2pcb_global->exeption = cons("===============================================================================" 
		(trl_altium2pcb_global->exeption)
	    )) 
	(trl_altium2pcb_global->exeption = cons(sprintf(nil "   7.1.0  INFO    - Start to Add Route Data - Start Time: [%L]" 
		    getCurrentTime()
		) 
		(trl_altium2pcb_global->exeption)
	    )) 
	(trl_altium2pcb_global->exeption = cons("===============================================================================" 
		(trl_altium2pcb_global->exeption)
	    )) 
	(TrackRecords = cadr(nth(10 
		    (trl_altium2pcb_global->PcbRawList)
		)
	    ))
	(ArcRecords = nth(7 
		(trl_altium2pcb_global->PcbRawList)
	    )) 
	(arc_ind = 0) 
	(index = 1) 
	when(ArcRecords 
	    foreach(rec ArcRecords 
		when(get(rec 
			'NET
		    ) 
		    (net = get(rec 
			    'NET
			)) 
		    (lay = get(rec 
			    'LAYER
			)) 
		    (V7 = get(rec 
			    'LAYER_V7
			)) 
		    (mx = TRL_ALTIUM2PCB_Util_DesignUnits(get(rec 
				'LOCATION\.X
			    )
			))
		    (my = TRL_ALTIUM2PCB_Util_DesignUnits(get(rec 
				'LOCATION\.Y
			    )
			)) 
		    (r = TRL_ALTIUM2PCB_Util_DesignUnits(get(rec 
				'RADIUS
			    )
			)) 
		    (sa = atof(get(rec 
				'STARTANGLE
			    )
			)) 
		    (ea = atof(get(rec 
				'ENDANGLE
			    )
			)) 
		    (w = TRL_ALTIUM2PCB_Util_DesignUnits(get(rec 
				'WIDTH
			    )
			))
		    when((sa > ea) 
			(ea = (ea + 360.0))
		    ) 
		    (angle_s_rad = ((sa / 360.0) * 2 * 3.141593)) 
		    (angle_e_rad = ((ea / 360.0) * 2 * 3.141593)) 
		    (x1 = ((cos(angle_s_rad) * r) + mx)) 
		    (y1 = ((sin(angle_s_rad) * r) + my))
		    (x2 = ((cos(angle_e_rad) * r) + mx)) 
		    (y2 = ((sin(angle_e_rad) * r) + my)) 
		    (r_path = (axlPathStart 
			    list((x1:y1)) w
			)) 
		    (r_path = (axlPathArcCenter r_path w 
			    (x2:y2) nil
			    (mx:my)
			)) 
		    when(V7 
			(lay = V7)
		    )
		    (t_layer = TRL_ALTIUM2PCB_UTIL_Find_Layer(lay)) 
		    (t_layer = strcat(car(t_layer) "/" 
			    cadr(t_layer)
			)) 
		    (l_points = list((x1:y1) 
			    (x2:y2)
			)) 
		    (f_width = w) 
		    (signal = nil)
		    foreach(neti 
			(trl_altium2pcb_global->NetsList) 
			when((cadr(neti) == net) 
			    (signal = car(neti))
			)
		    ) 
		    (dbCreate = (axlDBCreatePath r_path t_layer signal)) 
		    if(dbCreate then 
			arc_ind++ else 
			(trl_altium2pcb_global->exeption = cons(sprintf(nil "-->7.2.04 ERROR   - Track NOT Created! Check ArcRecords %L %L %L %L %L %L!!" dbCreate l_points f_width
				    t_layer signal rec
				) 
				(trl_altium2pcb_global->exeption)
			    ))
		    )
		) 
		index++ 
		when((modulo(index 100) == 0) 
		    (axlUIWPrint 
			(trl_altium2pcb_global->formid) "-->1.1.0  INFO - Processing ArcRec:[%5d] of [%5d] Records" index 
			length(ArcRecords)
		    )
		)
	    )
	) 
	(seg_ind = 0)
	(index = 1) 
	if(TrackRecords then 
	    foreach(rec TrackRecords 
		(net = get(rec 
			'NET
		    )) 
		(lay = get(rec 
			'LAYER
		    )) 
		(cmp = get(rec 
			'COMPONENT
		    ))
		(V7 = get(rec 
			'LAYER_V7
		    )) 
		(x1 = TRL_ALTIUM2PCB_Util_DesignUnits(get(rec 
			    'X1
			)
		    )) 
		(y1 = TRL_ALTIUM2PCB_Util_DesignUnits(get(rec 
			    'Y1
			)
		    )) 
		(x2 = TRL_ALTIUM2PCB_Util_DesignUnits(get(rec 
			    'X2
			)
		    )) 
		(y2 = TRL_ALTIUM2PCB_Util_DesignUnits(get(rec 
			    'Y2
			)
		    ))
		(w = TRL_ALTIUM2PCB_Util_DesignUnits(get(rec 
			    'WIDTH
			)
		    )) 
		when(net 
		    (t_layer = TRL_ALTIUM2PCB_UTIL_Find_Layer(lay)) 
		    (t_layer = strcat(car(t_layer) "/" 
			    cadr(t_layer)
			)) 
		    (l_points = list((x1:y1) 
			    (x2:y2)
			)) 
		    (f_width = w)
		    (signal = nil) 
		    foreach(neti 
			(trl_altium2pcb_global->NetsList) 
			when((cadr(neti) == net) 
			    (signal = car(neti))
			)
		    ) 
		    (dbCreate = (axlDBCreateLine l_points f_width t_layer signal)) 
		    if(dbCreate then 
			seg_ind++ else 
			(trl_altium2pcb_global->exeption = cons(sprintf(nil "-->7.2.02 ERROR   - Track NOT Created! Check TrackRecords %L %L %L %L %L %L!!" dbCreate l_points f_width
				    t_layer signal rec
				) 
				(trl_altium2pcb_global->exeption)
			    ))
		    )
		) 
		unless((net || cmp) 
		    if(get(rec 
			    'POLYGON
			) then 
			printf("--POLYGON-> %L\n" rec) 
			(t_layer = "Board Geometry/Assembly_Notes") 
			(l_points = list((x1:y1) 
				(x2:y2)
			    ))
			(f_width = w) 
			(signal = nil) 
			(dbCreate = (axlDBCreateLine l_points f_width t_layer signal)) else 
			when(V7 
			    (lay = V7)
			)
			(t_layer = TRL_ALTIUM2PCB_UTIL_Find_Layer(lay)) 
			if((cadr(t_layer) == "KEEPOUT") then 
			    printf("--KEEPOUT-> %L\n" rec) 
			    (t_layer = "Board Geometry/Assembly_Detail") 
			    (l_points = list((x1:y1) 
				    (x2:y2)
				))
			    (f_width = w) 
			    (signal = nil) 
			    (dbCreate = (axlDBCreateLine l_points f_width t_layer signal)) else 
			    (t_layer = strcat("Board Geometry/" 
				    cadr(t_layer)
				))
			    (l_points = list((x1:y1) 
				    (x2:y2)
				)) 
			    (f_width = w) 
			    (signal = nil) 
			    (dbCreate = (axlDBCreateLine l_points f_width t_layer signal)) 
			    unless(dbCreate 
				(trl_altium2pcb_global->exeption = cons(sprintf(nil "-->7.2.02 ERROR   - Track NOT Created! Check TrackRecords %L !!" rec) 
					(trl_altium2pcb_global->exeption)
				    ))
			    )
			)
		    )
		) 
		index++ 
		when((modulo(index 100) == 0) 
		    (axlUIWPrint 
			(trl_altium2pcb_global->formid) "-->1.1.0  INFO - Processing TracRec:[%5d] of [%5d] Records" index 
			length(TrackRecords)
		    )
		)
	    ) 
	    (trl_altium2pcb_global->exeption = cons("===============================================================================" 
		    (trl_altium2pcb_global->exeption)
		)) 
	    (trl_altium2pcb_global->exeption = cons(sprintf(nil "   7.1.00 INFO    - Done Route Data: [%d] TrackSegments AND [%d] ArcSegments Created. - End Time: [%L]" seg_ind arc_ind 
			getCurrentTime()
		    ) 
		    (trl_altium2pcb_global->exeption)
		))
	    (trl_altium2pcb_global->exeption = cons("===============================================================================" 
		    (trl_altium2pcb_global->exeption)
		)) else 
	    (trl_altium2pcb_global->exeption = cons("-->7.2.02 ERROR   - Routing Data DO NOT exist!!" 
		    (trl_altium2pcb_global->exeption)
		)) 
	    (trl_altium2pcb_global->exeption = cons("-------------------------------------------------------------------------------" 
		    (trl_altium2pcb_global->exeption)
		))
	)
    )
)
procedure(TRL_ALTIUM2PCB_CREATE_RoutPlace_Keepin(polygon) 
    let((layers brdobj layer_pb value_pb value_l
	    exp_pol layer out_pol o_sh
	) 
	when(polygon 
	    (axlDBCreateOpenShape polygon nil "PACKAGE KEEPIN/ALL") 
	    (axlDBCreateOpenShape polygon nil "ROUTE KEEPIN/ALL")
	) 
	(layers = (trl_altium2pcb_global->LayerStack)) 
	(brdobj = car((trl_altium2pcb_global->PcbRawList))) 
	(value_pb = 0)
	foreach(layer_g layers 
	    (value_l = nil) 
	    (out_pol = nil) 
	    (exp_pol = nil)
	    (o_sh = nil) 
	    when((car(layer_g) > 38) 
		(layer = (car(layer_g) - 38)) 
		(layer_pb = stringToSymbol(sprintf(nil "PLANE%dPULLBACK" layer))) 
		foreach(rec brdobj 
		    (value_l = get(rec layer_pb)) 
		    (value_l = TRL_ALTIUM2PCB_Util_DesignUnits(value_l))
		) 
		when(value_l 
		    when((value_l > value_pb) 
			(value_pb = value_l)
		    ) 
		    when((value_pb > 0) 
			(value_pb = (value_pb * -1))
		    ) 
		    (out_pol = (axlPolyFromDB polygon)) 
		    (exp_pol = (axlPolyExpand out_pol value_pb 
			    'NONE
			))
		    (o_sh = (axlDBCreateOpenShape polygon t 
			    sprintf(nil "ROUTE KEEPOUT/%s" 
				cadr(layer_g)
			    )
			)) 
		    when(o_sh 
			(axlDBCreateVoid o_sh 
			    car(exp_pol)
			)
		    ) 
		    (axlDBCreateCloseShape o_sh)
		)
	    )
	)
    )
)
procedure(TRL_ALTIUM2PCB_CREATE_SHAPES() 
    let((PolygonRecords l_points path net_id layer
	    net t_layer shp shp_ind extents
	) 
	(trl_altium2pcb_global->exeption = cons(sprintf(nil "   5.7.00 INFO    - Start to Add Shape Data - Start Time: %L" 
		    getCurrentTime()
		) 
		(trl_altium2pcb_global->exeption)
	    )) 
	(trl_altium2pcb_global->exeption = cons("-------------------------------------------------------------------------------" 
		(trl_altium2pcb_global->exeption)
	    )) "--Check if Shape Fill exists First---------------------------------------------" "-------------------------------------------------------------------------------"
	TRL_ALTIUM2PCB_CREATE_Shape_Fills() "--Check if Shape Region exists First-------------------------------------------" "-------------------------------------------------------------------------------" 
	TRL_ALTIUM2PCB_CREATE_Shape_Region() 
	(PolygonRecords = nth(4 
		(trl_altium2pcb_global->PcbRawList)
	    ))
	(shp_ind = 0) 
	if(PolygonRecords then 
	    foreach(rec PolygonRecords 
		(l_points = list()) 
		(net = nil) 
		when((get(rec 
			    'POLYGONTYPE
			) == "Polygon") 
		    (l_points = TRL_ALTIUM2PCB_GetPolyPath(rec)) 
		    (layer = get(rec 
			    'LAYER
			)) 
		    (net_id = get(rec 
			    'NET
			)) 
		    when(net_id 
			foreach(neti 
			    (trl_altium2pcb_global->NetsList) 
			    when((cadr(neti) == net_id) 
				(net = car(neti))
			    )
			)
		    )
		)
		(t_layer = TRL_ALTIUM2PCB_UTIL_Find_Layer(layer)) 
		if(net then 
		    (t_layer = strcat("Boundary/" 
			    cadr(t_layer)
			)) else 
		    (t_layer = strcat(car(t_layer) "/" 
			    cadr(t_layer)
			))
		) 
		if(l_points then 
		    (path = TRL_ALTIUM2PCB_ComplexPolyPath(l_points)) 
		    if(path then 
			(shp = (axlDBCreateShape path t t_layer net)) 
			if(shp then 
			    (trl_altium2pcb_global->exeption = cons(sprintf(nil "   5.7.01 INFO    - Shape %L %L CREATED" t_layer net) 
				    (trl_altium2pcb_global->exeption)
				)) else 
			    (axlDBCreatePath path "Board Geometry/Assembly_Detail")
			    (trl_altium2pcb_global->exeption = cons(sprintf(nil "-->5.7.04 ERROR   - Shape %L %L NOT Created! Check Polygon Date syntax. You will find Lines representation on Board Geometry/Assembly_Detail!!" t_layer net) 
				    (trl_altium2pcb_global->exeption)
				))
			) else
			(axlDBCreateLine l_points 1.0 "Board Geometry/Assembly_Detail") 
			(trl_altium2pcb_global->exeption = cons(sprintf(nil "-->5.7.03 ERROR   - Shape %L %L NOT Created! Check Polygon Date syntax!! %L" t_layer net rec) 
				(trl_altium2pcb_global->exeption)
			    ))
		    ) else
		    (trl_altium2pcb_global->exeption = cons(sprintf(nil "-->5.7.02 ERROR   - Shape NOT Created! Check Polygon Date syntax!! %L %L %L" t_layer net rec) 
			    (trl_altium2pcb_global->exeption)
			))
		) 
		shp_ind++
	    ) 
	    (trl_altium2pcb_global->exeption = cons("-------------------------------------------------------------------------------" 
		    (trl_altium2pcb_global->exeption)
		)) 
	    (trl_altium2pcb_global->exeption = cons(sprintf(nil "   5.7.02 INFO    - Done to Add Shape Data. %d Shapes Created - End Time: %L" shp_ind 
			getCurrentTime()
		    ) 
		    (trl_altium2pcb_global->exeption)
		))
	    (trl_altium2pcb_global->exeption = cons("===============================================================================" 
		    (trl_altium2pcb_global->exeption)
		)) else 
	    (trl_altium2pcb_global->exeption = cons("-->5.7.51 ERROR   - NO SHAPES exist!!" 
		    (trl_altium2pcb_global->exeption)
		))
	) 
	(axlShapeDynamicUpdate nil nil) 
	(extents = (axlExtentDB 
		'obstacle
	    )) 
	(extents = (bBoxAdd extents 
		list((-1000:-1000) 
		    (1000:1000)
		)
	    ))
	(axlDBChangeDesignExtents extents)
    )
)
procedure((TRL_ALTIUM2PCB_CREATE_Selected_Pattern pattern_name pattern \@optional pins_list) 
    let((component_id ref_des symdef pin_str_lst x
	    y rot r_pads_list max_x max_y
	    l_extents bod_list arc_list seg_list max_val_lst
	    txt_list reg_list shp dbret fill_list
	    dbCreate body_index RefDes ret txtorient
	    via_list all_pads_list
	) 
	(txt_list = list()) 
	(reg_list = list()) 
	(bod_list = list()) 
	(max_x = 30000)
	(max_y = 30000) 
	(max_val_lst = (max_x:max_y)) 
	(pin_str_lst = list()) 
	(component_id = caddr(pattern)) 
	(ref_des = nth(4 pattern))
	(x = nth(5 pattern)) 
	(y = nth(6 pattern)) 
	(rot = nth(9 pattern)) 
	unless(ref_des 
	    (ref_des = pattern_name) 
	    (trl_altium2pcb_global->exeption = cons(sprintf(nil "-->4.2.1  WARNING - Components DO NOT exist!! Footprints placed instead: %L %L %L [%L %L]" pattern_name component_id rot
			x y
		    ) 
		    (trl_altium2pcb_global->exeption)
		))
	) 
	(trl_altium2pcb_global->exeption = cons(sprintf(nil "   4.3.0  INFO    - Start Footprint %L pin preprocessing.." pattern_name) 
		(trl_altium2pcb_global->exeption)
	    ))
	(ret = TRL_ALTIUM2PCB_CREATE_Footprint_Pin_Preprocessing(r_pads_list pins_list pattern pattern_name ref_des
		pin_str_lst max_val_lst
	    )) 
	(pin_str_lst = car(ret)) 
	(all_pads_list = cadr(ret)) 
	(max_val_lst = caddr(ret)) 
	(via_list = TRL_ALTIUM2PCB_CREATE_Footprint_VIAs(pattern max_val_lst))
	(max_val_lst = TRL_ALTIUM2PCB_UTIL_Find_Max_XY_Value(cadr(via_list) max_val_lst)) 
	(arc_list = TRL_ALTIUM2PCB_CREATE_Footprint_Arc(pattern max_val_lst)) 
	(max_val_lst = TRL_ALTIUM2PCB_UTIL_Find_Max_XY_Value(cadr(arc_list) max_val_lst)) 
	(seg_list = TRL_ALTIUM2PCB_CREATE_Footprint_Segment(pattern max_val_lst)) 
	(max_val_lst = TRL_ALTIUM2PCB_UTIL_Find_Max_XY_Value(cadr(seg_list) max_val_lst))
	(fill_list = TRL_ALTIUM2PCB_CREATE_Footprint_Fills(pattern max_val_lst)) 
	(max_val_lst = TRL_ALTIUM2PCB_UTIL_Find_Max_XY_Value(cadr(fill_list) max_val_lst)) 
	(txt_list = TRL_ALTIUM2PCB_CREATE_FootprintDef_Text(pattern max_val_lst)) 
	(reg_list = TRL_ALTIUM2PCB_CREATE_Footprint_Region(pattern max_val_lst)) 
	(max_val_lst = TRL_ALTIUM2PCB_UTIL_Find_Max_XY_Value(cadr(reg_list) max_val_lst))
	(bod_list = TRL_ALTIUM2PCB_CREATE_Footprint_Misc(pattern)) 
	when((car(max_val_lst) > max_x) 
	    (max_x = (car(max_val_lst) * 1.5))
	) 
	when((cadr(max_val_lst) > max_y) 
	    (max_y = (cadr(max_val_lst) * 1.5))
	) 
	(l_extents = list(((- max_x):(- max_y)) 
		(max_x:max_y)
	    )) 
	if((pin_str_lst && car(all_pads_list)) then 
	    (symdef = (axlDBCreateSymDefSkeleton 
		    list(pattern_name "package") l_extents pin_str_lst
		)) else 
	    (symdef = (axlDBCreateSymDefSkeleton 
		    list(pattern_name "mechanical") l_extents
		))
	)
	when(symdef 
	    (txtorient = (make_axlTextOrientation ?textBlock "1" ?rotation 0.0
		    ?mirrored nil ?justify "center"
		)) 
	    foreach(arc 
		car(arc_list) 
		(axlDBCreatePath 
		    car(arc) 
		    cadr(arc) 
		    'line symdef
		)
	    ) 
	    when(car(via_list) 
		foreach(via 
		    car(via_list) 
		    (dbret = (axlDBCreateVia 
			    car(via) 
			    cadr(via) nil nil
			    0.0 symdef
			)) 
		    if(dbret then 
			when(nth(8 
				(trl_altium2pcb_global->settings)
			    ) 
			    (trl_altium2pcb_global->exeption = cons(sprintf(nil "   4.5.20 INFO    - Body VIA: %L %L %L " dbret 
					car(via) 
					cadr(via)
				    ) 
				    (trl_altium2pcb_global->exeption)
				))
			) else 
			(trl_altium2pcb_global->exeption = cons(sprintf(nil "-->4.5.20 ERROR   - Body VIA Problem: %L %L %L " dbret 
				    car(via) 
				    cadr(via)
				) 
				(trl_altium2pcb_global->exeption)
			    ))
		    )
		)
	    ) 
	    when(seg_list 
		foreach(seg 
		    car(seg_list) 
		    (dbret = (axlDBCreatePath 
			    car(seg) 
			    cadr(seg) 
			    'line symdef
			)) 
		    if(dbret then 
			when(nth(8 
				(trl_altium2pcb_global->settings)
			    ) 
			    (trl_altium2pcb_global->exeption = cons(sprintf(nil "   4.5.30 INFO    - Body Segment: %L %L %L " dbret 
					car(seg) 
					cadr(seg)
				    ) 
				    (trl_altium2pcb_global->exeption)
				))
			) else 
			(trl_altium2pcb_global->exeption = cons(sprintf(nil "-->4.5.30 ERROR   - Body Segment Problem: %L %L %L " dbret 
				    car(seg) 
				    cadr(seg)
				) 
				(trl_altium2pcb_global->exeption)
			    ))
		    )
		)
	    )
	    (RefDes = nil) 
	    when(txt_list 
		foreach(txt txt_list 
		    (dbret = (axlDBCreateText 
			    car(txt) 
			    cadr(txt) 
			    caddr(txt) 
			    cadddr(txt)
			    symdef
			)) 
		    if(dbret then 
			when((upperCase(cadddr(txt)) == "REF DES/ASSEMBLY_TOP") 
			    (RefDes = t)
			) 
			when(nth(8 
				(trl_altium2pcb_global->settings)
			    ) 
			    (trl_altium2pcb_global->exeption = cons(sprintf(nil "   4.5.40 INFO    - Body Text: %L %L %L %L %L" dbret 
					car(txt) 
					cadr(txt)
					caddr(txt) 
					cadddr(txt)
				    ) 
				    (trl_altium2pcb_global->exeption)
				))
			) else
			(trl_altium2pcb_global->exeption = cons(sprintf(nil "-->4.5.40 ERROR   - Body Text Problem: %L %L %L %L %L" dbret 
				    car(txt) 
				    cadr(txt)
				    caddr(txt) 
				    cadddr(txt)
				) 
				(trl_altium2pcb_global->exeption)
			    ))
		    )
		)
	    ) 
	    unless(RefDes 
		(ret = (axlDBCreateText "RefDes" 
			(0:0) txtorient "ref des/assembly_top"
			symdef
		    ))
	    ) 
	    when(ret t) 
	    foreach(fill 
		car(fill_list) 
		(dbCreate = (axlDBCreateRectangle 
			car(fill) t 
			cadr(fill) nil
			symdef
		    )) 
		if(dbCreate then 
		    when(nth(8 
			    (trl_altium2pcb_global->settings)
			) 
			(trl_altium2pcb_global->exeption = cons(sprintf(nil "   4.5.01 INFO    - Rectangle on Layer %L CREATED" fill) 
				(trl_altium2pcb_global->exeption)
			    ))
		    ) else 
		    (trl_altium2pcb_global->exeption = cons(sprintf(nil "-->4.5.01 ERROR   - Rectangle NOT Created! Check Polygon Date syntax!! %L" fill) 
			    (trl_altium2pcb_global->exeption)
			))
		)
	    )
	    when(car(reg_list) 
		foreach(rec 
		    car(reg_list) 
		    if((caddr(rec) == "TRUE") then 
			(shp = (axlDBCreateShape 
				car(rec) t 
				cadr(rec) nil
				symdef
			    )) else 
			(shp = (axlDBCreateOpenShape 
				car(rec) nil 
				cadr(rec) nil
				symdef
			    ))
		    ) 
		    if(shp then 
			when(nth(8 
				(trl_altium2pcb_global->settings)
			    ) 
			    (trl_altium2pcb_global->exeption = cons(sprintf(nil "   4.5.01 INFO    - Region on Layer %s CREATED" 
					cadr(rec)
				    ) 
				    (trl_altium2pcb_global->exeption)
				))
			) else 
			(trl_altium2pcb_global->exeption = cons(sprintf(nil "-->4.5.01 ERROR   - Region NOT Created! Check Polygon Date syntax!! %L" 
				    car(rec)
				) 
				(trl_altium2pcb_global->exeption)
			    ))
			unless((axlLayerGet "Package Geometry/POLYGON_ERROR") 
			    (axlLayerCreateNonConductor "Package Geometry/POLYGON_ERROR")
			) 
			(axlDBCreatePath 
			    car(rec) "Package Geometry/POLYGON_ERROR" 
			    'line symdef
			    nil
			)
		    )
		)
	    ) 
	    when(bod_list 
		(body_index = 1) 
		foreach(rec bod_list 
		    (shp = (axlDBCreateShape 
			    car(rec) t 
			    cadr(rec) nil
			    symdef
			)) 
		    if(shp then 
			when((caddr(rec) && cadddr(rec)) 
			    (axlDBAddProp 
				list(car(shp)) 
				list(list("PACKAGE_HEIGHT_MIN" 
					sprintf(nil "%f" 
					    caddr(rec)
					)
				    ) 
				    list("PACKAGE_HEIGHT_MAX" 
					sprintf(nil "%f" 
					    cadddr(rec)
					)
				    )
				)
			    )
			) 
			body_index++ else
			unless((axlLayerGet "Package Geometry/POLYGON_ERROR") 
			    (axlLayerCreateNonConductor "Package Geometry/POLYGON_ERROR")
			) 
			(axlDBCreatePath 
			    car(rec) "Package Geometry/POLYGON_ERROR" 
			    'line symdef
			    nil
			) 
			(trl_altium2pcb_global->exeption = cons(sprintf(nil "-->4.7.02 ERROR   - Body Records NOT Created! Check Polygon Date syntax!! -> %L" rec) 
				(trl_altium2pcb_global->exeption)
			    ))
		    )
		) 
		(trl_altium2pcb_global->exeption = cons(sprintf(nil "   4.7.01 INFO    - [%L] Body Records CREATED" body_index) 
			(trl_altium2pcb_global->exeption)
		    ))
	    )
	) 
	list(symdef r_pads_list)
    )
)
procedure(TRL_ALTIUM2PCB_CREATE_Shape_Fills() 
    let((FillRecords net lay V7 x1
	    y1 x2 y2 rot dbCreate
	    net_id l_points t_layer index
	) 
	(FillRecords = cadr(nth(13 
		    (trl_altium2pcb_global->PcbRawList)
		)
	    )) 
	(index = 1) 
	if(FillRecords then 
	    foreach(rec FillRecords 
		(net_id = get(rec 
			'NET
		    )) 
		(lay = get(rec 
			'LAYER
		    )) 
		(V7 = get(rec 
			'LAYER_V7
		    ))
		(x1 = TRL_ALTIUM2PCB_Util_DesignUnits(get(rec 
			    'X1
			)
		    )) 
		(y1 = TRL_ALTIUM2PCB_Util_DesignUnits(get(rec 
			    'Y1
			)
		    )) 
		(x2 = TRL_ALTIUM2PCB_Util_DesignUnits(get(rec 
			    'X2
			)
		    )) 
		(y2 = TRL_ALTIUM2PCB_Util_DesignUnits(get(rec 
			    'Y2
			)
		    )) 
		(rot = atof(get(rec 
			    'ROTATION
			)
		    ))
		when(net_id 
		    foreach(neti 
			(trl_altium2pcb_global->NetsList) 
			when((cadr(neti) == net_id) 
			    (net = car(neti))
			)
		    )
		) 
		(t_layer = TRL_ALTIUM2PCB_UTIL_Find_Layer(lay)) 
		if(net then 
		    (t_layer = strcat("Etch/" 
			    cadr(t_layer)
			)) else 
		    (t_layer = strcat(car(t_layer) "/" 
			    cadr(t_layer)
			))
		) 
		when(V7 
		    printf("--Hier vei Fill V7: %L\n" rec)
		) 
		(l_points = list((x1:y1) 
			(x2:y2)
		    ))
		if(net then 
		    (dbCreate = (axlDBCreateRectangle l_points t t_layer net)) else 
		    (dbCreate = (axlDBCreateRectangle l_points t t_layer))
		) 
		when((dbCreate && (rot > 0)) 
		    (axlTransformObject dbCreate ?angle rot)
		) 
		if(dbCreate then 
		    when(net 
			index++ 
			(trl_altium2pcb_global->exeption = cons(sprintf(nil "   5.7.04 INFO    - Fill Schape [%L] created! Layer: %L Net: %L" index t_layer t_layer) 
				(trl_altium2pcb_global->exeption)
			    ))
		    ) else 
		    (trl_altium2pcb_global->exeption = cons(sprintf(nil "-->5.7.07 ERROR   - Fill NOT Created! Check FillRecords %L !!" rec) 
			    (trl_altium2pcb_global->exeption)
			))
		)
	    ) 
	    (trl_altium2pcb_global->exeption = cons(sprintf(nil "   5.7.04 INFO    - Fill Schapes created [%L]" index) 
		    (trl_altium2pcb_global->exeption)
		))
	)
    )
)
procedure(TRL_ALTIUM2PCB_CREATE_Shape_KeepOut(rec) 
    let((layer spolyi l_points path shp
	    V7 t_layer
	) 
	when(rec 
	    (shp = nil) 
	    (layer = get(rec 
		    'LAYER
		)) 
	    (spolyi = get(rec 
		    'SUBPOLYINDEX
		)) 
	    (V7 = get(rec 
		    'LAYER_V7
		))
	    (l_points = TRL_ALTIUM2PCB_GetPolyPath(rec)) 
	    if(l_points then 
		(path = TRL_ALTIUM2PCB_ComplexPolyPath(l_points)) else 
		(trl_altium2pcb_global->exeption = cons(sprintf(nil "-->3.3.47 ERROR   - Shape Keepou NOT Created - Confused Path! Layer: %L / %L / REC: %L" layer spolyi rec) 
			(trl_altium2pcb_global->exeption)
		    ))
	    ) 
	    if((spolyi == "-1") then 
		if(path then 
		    when(V7 
			when(nth(8 
				(trl_altium2pcb_global->settings)
			    ) 
			    (trl_altium2pcb_global->exeption = cons(sprintf(nil "   3.3.41 INFO    - Shape Keepout V7:/%L" rec) 
				    (trl_altium2pcb_global->exeption)
				))
			)
		    ) 
		    unless(layer 
			when(nth(8 
				(trl_altium2pcb_global->settings)
			    ) 
			    (trl_altium2pcb_global->exeption = cons(sprintf(nil "   3.3.42 INFO    - Shape Keepout Layer:/%L" rec) 
				    (trl_altium2pcb_global->exeption)
				))
			) 
			(layer = "TOPOVERLAY")
		    ) 
		    (t_layer = TRL_ALTIUM2PCB_UTIL_Find_Layer(layer))
		    case(upperCase(layer) 
			("KEEPOUT" 
			    (t_layer = "ROUTE KEEPOUT/ALL") 
			    (shp = (axlDBCreateShape path t t_layer))
			) 
			("MULTILAYER" 
			    (t_layer = "ROUTE KEEPOUT/ALL") 
			    (shp = (axlDBCreateShape path t t_layer))
			) 
			(t 
			    if((car(t_layer) == "ETCH") then 
				(t_layer = strcat("ROUTE KEEPOUT" "/" 
					cadr(t_layer)
				    )) 
				(shp = (axlDBCreateShape path t t_layer)) else
				unless((axlLayerGet 
					sprintf(nil "BOARD GEOMETRY/Keepout_%s" 
					    cadr(t_layer)
					)
				    ) 
				    (axlLayerCreateNonConductor 
					sprintf(nil "BOARD GEOMETRY/Keepout_%s" 
					    cadr(t_layer)
					)
				    )
				) 
				(t_layer = sprintf(nil "BOARD GEOMETRY/Keepout_%s" 
					cadr(t_layer)
				    )) 
				(shp = (axlDBCreateShape path t t_layer))
			    )
			)
		    ) 
		    if(shp then t else 
			(axlDBCreatePath path "Board Geometry/Assembly_Detail")
			(trl_altium2pcb_global->exeption = cons(sprintf(nil "-->3.3.44 ERROR   - Shape Keepou NOT Created! Path: %L Layer: %L / %L / SUBPOLYINDEX: %L" path t_layer layer
				    spolyi
				) 
				(trl_altium2pcb_global->exeption)
			    ))
		    ) else 
		    when(l_points 
			(axlDBCreateLine l_points 1.0 "Board Geometry/Assembly_Detail")
		    ) 
		    (trl_altium2pcb_global->exeption = cons(sprintf(nil "-->3.3.45 ERROR   - Shape Keepout NOT Created! Check PolyRecords %L !!" rec) 
			    (trl_altium2pcb_global->exeption)
			))
		) else 
		when(path 
		    (axlDBCreatePath path "Board Geometry/Assembly_Detail")
		)
		when(nth(8 
			(trl_altium2pcb_global->settings)
		    ) 
		    (trl_altium2pcb_global->exeption = cons(sprintf(nil "   3.3.46 WARNING - Shape Keepou NOT Created! Layer: %L / %L / PolyI = %L" t_layer layer spolyi) 
			    (trl_altium2pcb_global->exeption)
			))
		)
	    )
	)
    )
)
procedure(TRL_ALTIUM2PCB_CREATE_Shape_Region() 
    let((RegionRecords layer spolyi l_points path
	    shp V7 t_layer keepout net_id
	    net index
	) 
	(RegionRecords = cadr(nth(12 
		    (trl_altium2pcb_global->PcbRawList)
		)
	    )) 
	(trl_altium2pcb_global->exeption = cons(sprintf(nil "   5.7.50 INFO    - Start to ADD [%d] Shape Regions" 
		    length(RegionRecords)
		) 
		(trl_altium2pcb_global->exeption)
	    )) 
	(index = 1) 
	when(RegionRecords 
	    foreach(rec RegionRecords 
		(keepout = get(rec 
			'KEEPOUT
		    )) 
		unless(keepout 
		    (shp = nil) 
		    (layer = get(rec 
			    'LAYER
			)) 
		    (net_id = get(rec 
			    'NET
			)) 
		    (spolyi = get(rec 
			    'SUBPOLYINDEX
			))
		    (V7 = get(rec 
			    'LAYER_V7
			)) 
		    (l_points = TRL_ALTIUM2PCB_GetPolyPath(rec)) 
		    if(l_points then 
			(path = TRL_ALTIUM2PCB_ComplexPolyPath(l_points)) else 
			(trl_altium2pcb_global->exeption = cons(sprintf(nil "-->5.7.51 ERROR   - Shape Region NOT Created - Confused Path! Layer: %L / %L / REC: %L" layer spolyi rec) 
				(trl_altium2pcb_global->exeption)
			    ))
		    ) 
		    if((spolyi == "-1") then 
			if(path then 
			    when(net_id 
				foreach(neti 
				    (trl_altium2pcb_global->NetsList) 
				    when((cadr(neti) == net_id) 
					(net = car(neti))
				    )
				)
			    ) 
			    when(V7 
				when(nth(8 
					(trl_altium2pcb_global->settings)
				    ) 
				    (trl_altium2pcb_global->exeption = cons(sprintf(nil "   5.7.52 INFO    - Shape Region V7:/%L" rec) 
					    (trl_altium2pcb_global->exeption)
					))
				)
			    ) 
			    unless(layer 
				when(nth(8 
					(trl_altium2pcb_global->settings)
				    ) 
				    (trl_altium2pcb_global->exeption = cons(sprintf(nil "   5.7.53 INFO    - Shape Region Layer:/%L" rec) 
					    (trl_altium2pcb_global->exeption)
					))
				) 
				(layer = "TOP")
			    )
			    (t_layer = TRL_ALTIUM2PCB_UTIL_Find_Layer(layer)) 
			    if(net then 
				(t_layer = strcat("Etch/" 
					cadr(t_layer)
				    )) else 
				(t_layer = strcat(car(t_layer) "/" 
					cadr(t_layer)
				    ))
			    ) 
			    if(net then 
				(shp = (axlDBCreateShape path t t_layer net)) else 
				(shp = (axlDBCreateShape path t t_layer))
			    ) 
			    unless(shp 
				(trl_altium2pcb_global->exeption = cons(sprintf(nil "-->5.7.54 ERROR   - Shape Region NOT Created! Path: %L Layer: %L / %L / SUBPOLYINDEX: %L" path t_layer layer
					    spolyi
					) 
					(trl_altium2pcb_global->exeption)
				    )) 
				(axlDBCreateShape path t "Board Geometry/Assembly_Detail")
			    ) else
			    when(l_points 
				(axlDBCreateLine l_points 1.0 "Board Geometry/Assembly_Detail")
			    ) 
			    (trl_altium2pcb_global->exeption = cons(sprintf(nil "-->5.7.55 ERROR   - Shape Region NOT Created! Check PolyRecords %L !!" rec) 
				    (trl_altium2pcb_global->exeption)
				))
			) else 
			when(path 
			    (axlDBCreatePath path "Board Geometry/Assembly_Detail")
			)
			when(nth(8 
				(trl_altium2pcb_global->settings)
			    ) 
			    (trl_altium2pcb_global->exeption = cons(sprintf(nil "   5.7.56 WARNING - Shape Region NOT Created! Layer: %L / %L / PolyI = %L" t_layer layer spolyi) 
				    (trl_altium2pcb_global->exeption)
				))
			)
		    )
		) 
		index++
	    )
	)
    )
)
procedure(TRL_ALTIUM2PCB_CREATE_Track_KeepOut(rec) 
    let((lay V7 x1 y1 x2
	    y2 t_layer width dbid r_path
	    shp
	) 
	(lay = get(rec 
		'LAYER
	    )) 
	(V7 = get(rec 
		'LAYER_V7
	    )) 
	(x1 = TRL_ALTIUM2PCB_Util_DesignUnits(get(rec 
		    'X1
		)
	    )) 
	(y1 = TRL_ALTIUM2PCB_Util_DesignUnits(get(rec 
		    'Y1
		)
	    ))
	(x2 = TRL_ALTIUM2PCB_Util_DesignUnits(get(rec 
		    'X2
		)
	    )) 
	(y2 = TRL_ALTIUM2PCB_Util_DesignUnits(get(rec 
		    'Y2
		)
	    )) 
	(width = TRL_ALTIUM2PCB_Util_DesignUnits(get(rec 
		    'WIDTH
		)
	    )) 
	when(V7 
	    when(nth(8 
		    (trl_altium2pcb_global->settings)
		) 
		(trl_altium2pcb_global->exeption = cons(sprintf(nil "   3.3.21 INFO    - Shape Keepout V7:/%L" rec) 
			(trl_altium2pcb_global->exeption)
		    ))
	    )
	) 
	unless(lay 
	    when(nth(8 
		    (trl_altium2pcb_global->settings)
		) 
		(trl_altium2pcb_global->exeption = cons(sprintf(nil "   3.3.22 INFO    - Shape Keepout Layer:/%L" rec) 
			(trl_altium2pcb_global->exeption)
		    ))
	    ) 
	    (lay = "TOPOVERLAY")
	)
	(dbid = (axlDBCreateLine 
		list((x1:y1) 
		    (x2:y2)
		) width "Board Geometry/Assembly_Detail"
	    )) 
	when(car(dbid) 
	    (r_path = car((axlPolyFromDB 
			caar(dbid)
		    )
		)) 
	    (axlDeleteObject 
		car(dbid)
	    ) 
	    when(r_path 
		(t_layer = TRL_ALTIUM2PCB_UTIL_Find_Layer(lay)) 
		case(upperCase(lay) 
		    ("KEEPOUT" 
			(t_layer = "ROUTE KEEPOUT/ALL") 
			(shp = (axlDBCreateShape r_path t t_layer))
		    ) 
		    ("MULTILAYER" 
			(t_layer = "ROUTE KEEPOUT/ALL") 
			(shp = (axlDBCreateShape r_path t t_layer))
		    ) 
		    (t 
			if((car(t_layer) == "ETCH") then 
			    (t_layer = strcat("ROUTE KEEPOUT" "/" 
				    cadr(t_layer)
				)) 
			    (shp = (axlDBCreateShape r_path t t_layer)) else
			    unless((axlLayerGet 
				    sprintf(nil "BOARD GEOMETRY/Keepout_%s" 
					cadr(t_layer)
				    )
				) 
				(axlLayerCreateNonConductor 
				    sprintf(nil "BOARD GEOMETRY/Keepout_%s" 
					cadr(t_layer)
				    )
				)
			    ) 
			    (t_layer = sprintf(nil "BOARD GEOMETRY/Keepout_%s" 
				    cadr(t_layer)
				)) 
			    (shp = (axlDBCreateShape r_path t t_layer))
			)
		    )
		)
	    )
	) 
	unless(shp 
	    (trl_altium2pcb_global->exeption = cons(sprintf(nil "-->3.3.24 ERROR   - Track KeepOut NOT Created! Check TrackRecords %L !!" rec) 
		    (trl_altium2pcb_global->exeption)
		))
	)
    )
)
procedure(TRL_ALTIUM2PCB_CREATE_VIAS() 
    let((ViaRecords via_typ net_id x y
	    pad_size drill start_lay end_lay via_name
	    via_list net via_id via_ind no_net_id
	    no_net_id_lst ret
	) 
	(trl_altium2pcb_global->exeption = cons("===============================================================================" 
		(trl_altium2pcb_global->exeption)
	    )) 
	(trl_altium2pcb_global->exeption = cons(sprintf(nil "   5.4.0  INFO    - Start to Add Via Data - Start Time: [%L]" 
		    getCurrentTime()
		) 
		(trl_altium2pcb_global->exeption)
	    )) 
	(trl_altium2pcb_global->exeption = cons("===============================================================================" 
		(trl_altium2pcb_global->exeption)
	    )) 
	(ViaRecords = nth(9 
		(trl_altium2pcb_global->PcbRawList)
	    ))
	when(ViaRecords 
	    (ViaRecords = cadr(ViaRecords))
	) 
	(via_list = list()) 
	(via_ind = 0) 
	(no_net_id = 0) 
	(no_net_id_lst = list())
	when(ViaRecords 
	    foreach(rec ViaRecords 
		(via_typ = get(rec 
			'LAYER
		    )) 
		(net_id = get(rec 
			'NET
		    )) 
		(x = TRL_ALTIUM2PCB_Util_DesignUnits(get(rec 
			    'X
			)
		    ))
		(y = TRL_ALTIUM2PCB_Util_DesignUnits(get(rec 
			    'Y
			)
		    )) 
		(pad_size = TRL_ALTIUM2PCB_Util_DesignUnits(get(rec 
			    'DIAMETER
			)
		    )) 
		(drill = TRL_ALTIUM2PCB_Util_DesignUnits(get(rec 
			    'HOLESIZE
			)
		    )) 
		(start_lay = get(rec 
			'STARTLAYER
		    )) 
		(end_lay = get(rec 
			'ENDLAYER
		    ))
		(net = nil) 
		if(net_id then 
		    foreach(neti 
			(trl_altium2pcb_global->NetsList) 
			when((cadr(neti) == net_id) 
			    (net = car(neti))
			)
		    ) 
		    unless(net 
			(no_net_id_lst = cons(net_id no_net_id_lst))
		    ) else
		    no_net_id++
		) 
		if(((start_lay == "TOP") && (end_lay == "BOTTOM")) then 
		    when((via_typ == "MULTILAYER") 
			(via_name = sprintf(nil "via_%dd%d" 
				round(pad_size) 
				round(drill)
			    ))
		    ) else 
		    when((via_typ == "MULTILAYER") 
			(via_name = sprintf(nil "via_%dd%d_%s-%s" 
				round(pad_size) 
				round(drill) start_lay
				end_lay
			    ))
		    )
		) 
		unless(memq(via_name via_list) 
		    (ret = TRL_ALTIUM2PCB_CREATE_VIA_PadStack(via_name drill pad_size start_lay end_lay
			    via_list
			)) 
		    (via_list = cadr(ret))
		) 
		if(net then 
		    (via_id = (axlDBCreateVia via_name 
			    (x:y) net
			)) else 
		    (via_id = (axlDBCreateVia via_name 
			    (x:y) nil
			))
		)
		if(via_id then 
		    via_ind++ else 
		    (trl_altium2pcb_global->exeption = cons(sprintf(nil "-->5.4.4  ERROR   - VIA: %L %L %L NOT created! Possibly PCB NetName DO NOT match with the Schematic NetName" via_name 
				(x:y) net
			    ) 
			    (trl_altium2pcb_global->exeption)
			))
		)
	    )
	) 
	if(axlGetVariable("drawing_4mils") then 
	    (axlDBChangeDesignUnits "mils" 4) else 
	    (axlDBChangeDesignUnits "mils" 2)
	) 
	unless((axlFormGetField 
		(trl_altium2pcb_global->formid) "derive_extended"
	    ) 
	    (axlShell "derive connectivity all")
	) 
	(trl_altium2pcb_global->exeption = cons("===============================================================================" 
		(trl_altium2pcb_global->exeption)
	    )) 
	(trl_altium2pcb_global->exeption = cons(sprintf(nil "   5.4.0  INFO    - VIA created: %L of total %L VIA's - End Time: [%L]" via_ind 
		    length(ViaRecords) 
		    getCurrentTime()
		) 
		(trl_altium2pcb_global->exeption)
	    ))
	when(((no_net_id > 0) || no_net_id_lst) 
	    (trl_altium2pcb_global->exeption = cons(sprintf(nil "   5.4.01 INFO    - VIA Statistic: [%L] Vias without Net_ID; For [%L] VIA's NET_Name NOT assigned" no_net_id 
			length(no_net_id_lst)
		    ) 
		    (trl_altium2pcb_global->exeption)
		))
	) 
	(trl_altium2pcb_global->exeption = cons("===============================================================================" 
		(trl_altium2pcb_global->exeption)
	    ))
    )
)
procedure(TRL_ALTIUM2PCB_CREATE_VIA_PadStack(via_name drill pad_size start_lay end_lay
	via_list
    ) 
    let((drill_handle pads_handle ps_id start_lay_nr end_lay_nr
	    go_index sorted_layer_stack
	) 
	if(zerop(drill) then 
	    (drill_handle = nil) else 
	    (drill_handle = (make_axlPadStackDrill ?drillDiameter drill ?plating 
		    'PLATED
		))
	) 
	(pads_handle = list()) 
	if(((start_lay == "TOP") && (end_lay == "BOTTOM")) then 
	    (pads_handle = cons((make_axlPadStackPad ?layer "TOP" ?type 
			'REGULAR
			?figure 
			'CIRCLE ?figureSize 
			(pad_size:pad_size)
		    ) pads_handle
		)) 
	    (pads_handle = cons((make_axlPadStackPad ?layer "DEFAULT INTERNAL" ?type 
			'REGULAR
			?figure 
			'CIRCLE ?figureSize 
			(pad_size:pad_size)
		    ) pads_handle
		)) 
	    (pads_handle = cons((make_axlPadStackPad ?layer "BOTTOM" ?type 
			'REGULAR
			?figure 
			'CIRCLE ?figureSize 
			(pad_size:pad_size)
		    ) pads_handle
		))
	    (ps_id = (axlDBCreatePadStack via_name drill_handle pads_handle t)) 
	    if(ps_id then 
		(via_list = cons(via_name via_list)) 
		(axlCnsAddVia "DEFAULT" via_name) 
		(trl_altium2pcb_global->exeption = cons(sprintf(nil "   5.4.3  INFO    - VIA Padstack: %L created." via_name) 
			(trl_altium2pcb_global->exeption)
		    ))
		else 
		(trl_altium2pcb_global->exeption = cons(sprintf(nil "-->5.4.4  ERROR   - VIA Padstack: %L NOT created!" via_name) 
			(trl_altium2pcb_global->exeption)
		    ))
	    ) else 
	    (start_lay_nr = TRL_ALTIUM2PCB_Util_Find_Layer_Number(start_lay)) 
	    (end_lay_nr = TRL_ALTIUM2PCB_Util_Find_Layer_Number(end_lay))
	    (go_index = nil) 
	    (sorted_layer_stack = TRL_ALTIUM2PCB_Util_Sort_Layer_Stack()) 
	    foreach(sorted_layer sorted_layer_stack 
		when((end_lay_nr == car(sorted_layer)) 
		    (go_index = nil) 
		    if((end_lay_nr == 32) then 
			(pads_handle = cons((make_axlPadStackPad ?layer "BOTTOM" ?type 
				    'REGULAR
				    ?figure 
				    'CIRCLE ?figureSize 
				    (pad_size:pad_size)
				) pads_handle
			    )) else 
			(pads_handle = cons((make_axlPadStackPad ?layer 
				    cadr(sorted_layer) ?type 
				    'REGULAR
				    ?figure 
				    'CIRCLE ?figureSize 
				    (pad_size:pad_size)
				) pads_handle
			    ))
		    )
		) 
		when(go_index 
		    (pads_handle = cons((make_axlPadStackPad ?layer 
				cadr(sorted_layer) ?type 
				'REGULAR
				?figure 
				'CIRCLE ?figureSize 
				(pad_size:pad_size)
			    ) pads_handle
			))
		) 
		when((start_lay_nr == car(sorted_layer)) 
		    (go_index = t) 
		    if(onep(start_lay_nr) then 
			(pads_handle = cons((make_axlPadStackPad ?layer "TOP" ?type 
				    'REGULAR
				    ?figure 
				    'CIRCLE ?figureSize 
				    (pad_size:pad_size)
				) pads_handle
			    )) else 
			(pads_handle = cons((make_axlPadStackPad ?layer 
				    cadr(sorted_layer) ?type 
				    'REGULAR
				    ?figure 
				    'CIRCLE ?figureSize 
				    (pad_size:pad_size)
				) pads_handle
			    ))
		    )
		)
	    ) 
	    (ps_id = (axlDBCreatePadStack via_name drill_handle pads_handle t)) 
	    if(ps_id then 
		(via_list = cons(via_name via_list)) 
		(axlCnsAddVia "DEFAULT" via_name) 
		(trl_altium2pcb_global->exeption = cons(sprintf(nil "   5.4.3  INFO    - VIA Padstack: %L created." via_name) 
			(trl_altium2pcb_global->exeption)
		    ))
		else 
		(trl_altium2pcb_global->exeption = cons(sprintf(nil "-->5.4.4  ERROR   - VIA Padstack: %L NOT created!" via_name) 
			(trl_altium2pcb_global->exeption)
		    )) 
		(pads_handle = cons((make_axlPadStackPad ?layer "TOP" ?type 
			    'REGULAR
			    ?figure 
			    'CIRCLE ?figureSize 
			    (pad_size:pad_size)
			) pads_handle
		    )) 
		(pads_handle = cons((make_axlPadStackPad ?layer "DEFAULT INTERNAL" ?type 
			    'REGULAR
			    ?figure 
			    'CIRCLE ?figureSize 
			    (pad_size:pad_size)
			) pads_handle
		    )) 
		(pads_handle = cons((make_axlPadStackPad ?layer "BOTTOM" ?type 
			    'REGULAR
			    ?figure 
			    'CIRCLE ?figureSize 
			    (pad_size:pad_size)
			) pads_handle
		    ))
		(ps_id = (axlDBCreatePadStack via_name drill_handle pads_handle t)) 
		when(ps_id 
		    (via_list = cons(via_name via_list)) 
		    (axlCnsAddVia "DEFAULT" via_name) 
		    (trl_altium2pcb_global->exeption = cons(sprintf(nil "-->5.4.5  ERROR   - VIA Padstack: %L NOT created! Using DUMMY Padstack instead" via_name) 
			    (trl_altium2pcb_global->exeption)
			))
		)
	    )
	) 
	list(ps_id via_list)
    )
)
procedure(TRL_ALTIUM2PCB_ComplexPolyPath(l_points) 
    let((r_path g_clockwise vx vy cx
	    cy sa ea r ex
	    ey f_width l_end_point index angle
	    x y ret_val f_angle
	) 
	(l_points = reverse(l_points)) 
	(r_path = (axlPathStart 
		list((caar(l_points):cadar(l_points)))
	    )) 
	(index = 1) 
	foreach(coor 
	    cdr(l_points) 
	    (vx = car(coor)) 
	    (vy = cadr(coor)) 
	    (cx = caddr(coor))
	    (cy = nth(3 coor)) 
	    (sa = nth(4 coor)) 
	    (ea = nth(5 coor)) 
	    (r = nth(6 coor)) 
	    if(((cx == 0.0) && (cy == 0.0)) then 
		(r_path = (axlPathLine r_path 0.0 
			(vx:vy)
		    )) else 
		(r_path = (axlPathLine r_path 0.0 
			(vx:vy)
		    ))
		when((sa > ea) 
		    (ea = (ea + 360.0))
		) 
		(l_end_point = nth((index + 1) l_points)) 
		when(l_end_point 
		    (ex = car(l_end_point)) 
		    (ey = cadr(l_end_point)) 
		    (l_end_point = (ex:ey)) 
		    (angle = (axlDegToRad 
			    nth(5 coor)
			))
		    (x = ((cos(angle) * r) + cx)) 
		    (y = ((sin(angle) * r) + cy))
		) 
		if(l_end_point then 
		    (f_width = 0.0) 
		    if(((abs(round(vx)) == abs(round(x))) && (abs(round(vy)) == abs(round(y)))) then 
			(g_clockwise = t) else 
			(g_clockwise = nil)
		    ) 
		    (f_angle = (ea - sa))
		    (ret_val = (axlPathArcAngle r_path f_width l_end_point g_clockwise
			    f_angle
			)) 
		    when(ret_val 
			(r_path = ret_val)
		    ) else 
		    (trl_altium2pcb_global->exeption = cons(sprintf(nil "-->2.1.13 WARNING - ComplexPolyPath Data Unrealistic!! -> %L %L %L %L %L" 
				(cx:cy) 
				(vx:vy) ea
				sa r
			    ) 
			    (trl_altium2pcb_global->exeption)
			))
		)
	    )
	    index++
	)
	r_path
    )
)
procedure(TRL_ALTIUM2PCB_ComplexPolyPath_NOReverse(l_points) 
    let((r_path g_clockwise vx vy cx
	    cy ex ey f_width l_end_point
	    index ret_val point ll_points l_center
	) 
	(point = car(l_points)) 
	(r_path = (axlPathStart 
		list((car(point):cadr(point)))
	    )) 
	if((nth(6 point) == 0.0) then 
	    (index = 1) 
	    (ll_points = cdr(l_points)) 
	    (g_clockwise = nil)
	    else 
	    (index = 0) 
	    (ll_points = l_points) 
	    (g_clockwise = t)
	) 
	foreach(coor ll_points 
	    (vx = car(coor)) 
	    (vy = cadr(coor)) 
	    (cx = caddr(coor))
	    (cy = nth(3 coor)) 
	    if(((cx == 0.0) && (cy == 0.0)) then 
		(r_path = (axlPathLine r_path 0.0 
			(vx:vy)
		    )) else 
		(r_path = (axlPathLine r_path 0.0 
			(vx:vy)
		    ))
		(f_width = 0.0) 
		(l_center = (cx:cy)) 
		if(nth((index + 1) l_points) then 
		    (l_end_point = nth((index + 1) l_points)) else 
		    (l_end_point = point)
		) 
		when(l_end_point 
		    (ex = car(l_end_point)) 
		    (ey = cadr(l_end_point)) 
		    (l_end_point = (ex:ey))
		) 
		when(l_end_point 
		    (ret_val = (axlPathArcCenter r_path f_width l_end_point g_clockwise
			    l_center
			))
		)
		when(ret_val 
		    (r_path = ret_val)
		)
	    ) 
	    index++
	)
	r_path
    )
)
procedure(TRL_ALTIUM2PCB_ComplexPolyPath_OLD(l_points) 
    let((r_path g_clockwise vx vy cx
	    cy sa ea r e_path
	    mx my s_path mid_pt
	) 
	(r_path = (axlPathStart 
		list((caar(l_points):cadar(l_points)))
	    )) 
	(s_path = (caar(l_points):cadar(l_points))) 
	foreach(coor 
	    cdr(l_points) 
	    (vx = car(coor)) 
	    (vy = cadr(coor)) 
	    (cx = caddr(coor))
	    (cy = nth(3 coor)) 
	    (sa = nth(4 coor)) 
	    (ea = nth(5 coor)) 
	    (r = nth(6 coor)) 
	    (e_path = (vx:vy))
	    if(((cx == 0.0) && (cy == 0.0)) then 
		(r_path = (axlPathLine r_path 0.0 
			(vx:vy)
		    )) else 
		when((sa > ea) 
		    (ea = (ea + 360.0))
		)
		(mid_pt = (axlGeoArcCenterAngle 
			(cx:cy) 
			(vx:vy) 
			(ea - sa) nil
		    )) 
		if(mid_pt then 
		    (g_clockwise = nil) 
		    (mx = car(mid_pt)) 
		    (my = cadr(mid_pt))
		    if((mx && my) then 
			unless(((round(mx):round(my)) == (round(cx):round(cy))) 
			    (g_clockwise = t)
			) 
			(r_path = (axlPathArcCenter r_path 0.0 
				(car(coor):cadr(coor)) g_clockwise
				(caddr(coor):nth(3 coor))
			    )) else
			(trl_altium2pcb_global->exeption = cons(sprintf(nil "-->2.1.17 WARNING - ComplexPolyPath Data Unrealistic!! -> %L %L %L %L %L" 
				    (cx:cy) 
				    (vx:vy) ea
				    sa r
				) 
				(trl_altium2pcb_global->exeption)
			    ))
		    ) else 
		    (trl_altium2pcb_global->exeption = cons(sprintf(nil "-->2.1.18 WARNING - ComplexPolyPath Data Missing!! -> %L %L %L %L %L" 
				(cx:cy) 
				(vx:vy) ea
				sa r
			    ) 
			    (trl_altium2pcb_global->exeption)
			))
		)
	    )
	) 
	unless((s_path == e_path) 
	    (r_path = (axlPathLine r_path 0.0 s_path))
	)
	r_path
    )
)
procedure(TRL_ALTIUM2PCB_CreateLayerStack(layer_data) 
    let((layer layers l_list next t_Prev_layerName
	    layer_type artwork_type del_l ret
	) 
	(l_list = list()) 
	(layers = (axlGetParam "paramLayerGroup:etch")) 
	(layers = (layers->groupMembers)) 
	when((length(layers) > 2) 
	    foreach(lay layers 
		unless(((lay == "TOP") || (lay == "BOTTOM")) 
		    (del_l = (axlLayerGet 
			    sprintf(nil "etch/%s" lay)
			)) 
		    (ret = (axlDeleteObject del_l)) 
		    (trl_altium2pcb_global->exeption = cons(sprintf(nil "-->3.2.05 WARNING - More then 2x Layers! Layer Removed: %L [%L] LayerStack SetUp requires Board from Scratch!!" lay ret) 
			    (trl_altium2pcb_global->exeption)
			))
		)
	    )
	)
	when((length(layers) > 2) 
	    (axlUIConfirm "ERROR - More then 2x Layers! LayerStack SetUp requires\nBoard from Scratch" 
		'error
	    ) 
	    (trl_altium2pcb_global->exeption = cons("-->3.2.04 ERROR   - More then 2x Layers! LayerStack SetUp requires Board from Scratch!!" 
		    (trl_altium2pcb_global->exeption)
		))
	) 
	(layer_data = reverse(layer_data)) 
	(layer = car(layer_data)) 
	(l_list = cons(layer l_list)) 
	(next = nth(3 layer))
	while((next != 0) 
	    (layer = nil) 
	    foreach(item 
		cdr(layer_data) 
		when((car(item) == next) 
		    (layer = item)
		)
	    ) 
	    (l_list = cons(layer l_list)) 
	    (next = nth(3 layer))
	) 
	if((caar(l_list) == 32) then 
	    (t_Prev_layerName = "BOTTOM") 
	    foreach(item 
		cdr(l_list) 
		unless(onep(car(item)) 
		    if(((car(item) >= 39) && (car(item) <= 54)) then 
			(layer_type = "PLANE") 
			(artwork_type = "POSITIVE") else
			(layer_type = "CONDUCTOR") 
			(artwork_type = "POSITIVE")
		    ) 
		    (axlLayerCreateCrossSection t_Prev_layerName layer_type "COPPER" 
			cadr(item)
			artwork_type
		    ) 
		    (t_Prev_layerName = cadr(item))
		)
	    ) else
	    printf("-->Hier %L\n" 
		caar(l_list)
	    )
	) 
	(l_list = list()) 
	(layers = (axlGetParam "paramLayerGroup:etch")) 
	(layers = (layers->groupMembers))
	when((length(layers) > 2) 
	    (layers = reverse(layers)) 
	    for(i 0 
		(length(layers) - 3) 
		(axlLayerCreateCrossSection 
		    nth(i layers) "DIELECTRIC" "FR-4"
		)
	    )
	) 
	(axlVisibleUpdate t)
    )
)
procedure(TRL_ALTIUM2PCB_CreateMechanicalStack() 
    let((layers dbid) 
	(layers = (axlGetParam "paramLayerGroup:board geometry")) 
	(layers = (layers->groupMembers)) 
	foreach(layer 
	    (trl_altium2pcb_global->LayerMech) 
	    unless(member(cadr(layer) layers) 
		(dbid = (axlLayerCreateNonConductor 
			sprintf(nil "BOARD GEOMETRY/%s" 
			    cadr(layer)
			)
		    )) 
		if(dbid then 
		    when(nth(8 
			    (trl_altium2pcb_global->settings)
			) 
			(trl_altium2pcb_global->exeption = cons(sprintf(nil "   3.4.3  INFO    - BOARD GEOMETRY/%L Created" 
				    cadr(layer)
				) 
				(trl_altium2pcb_global->exeption)
			    ))
		    ) else 
		    (trl_altium2pcb_global->exeption = cons(sprintf(nil "-->3.4.3  ERROR   - BOARD GEOMETRY/%L NOT Created" 
				cadr(layer)
			    ) 
			    (trl_altium2pcb_global->exeption)
			))
		)
	    )
	)
    )
)
procedure(TRL_ALTIUM2PCB_CreateNegativePlanes() 
    let((PolygonRecords net l_points layer net_id
	    t_layer path index shp
	) 
	(PolygonRecords = nth(4 
		(trl_altium2pcb_global->PcbRawList)
	    )) 
	(index = 0) 
	when(PolygonRecords 
	    foreach(rec PolygonRecords 
		(l_points = list()) 
		(net = nil) 
		when((get(rec 
			    'POLYGONTYPE
			) == "Split Plane") 
		    (l_points = TRL_ALTIUM2PCB_GetPolyPath(rec)) 
		    (layer = get(rec 
			    'LAYER
			)) 
		    (net_id = get(rec 
			    'NET
			)) 
		    when(net_id 
			foreach(neti 
			    (trl_altium2pcb_global->NetsList) 
			    when((cadr(neti) == net_id) 
				(net = car(neti))
			    )
			)
		    )
		    (t_layer = TRL_ALTIUM2PCB_UTIL_Find_Layer(layer)) 
		    (t_layer = strcat("Boundary/" 
			    cadr(t_layer)
			)) 
		    if(l_points then 
			(path = TRL_ALTIUM2PCB_ComplexPolyPath(l_points)) else 
			(trl_altium2pcb_global->exeption = cons("-->3.5.02 ERROR   - Shape NOT Created! Check Polygon Date syntax!!" 
				(trl_altium2pcb_global->exeption)
			    ))
		    ) 
		    if(path then 
			(shp = (axlDBCreateShape path t t_layer net)) else 
			(trl_altium2pcb_global->exeption = cons("-->3.5.03 ERROR   - Shape NOT Created! Check Polygon Date syntax!!" 
				(trl_altium2pcb_global->exeption)
			    ))
		    ) 
		    if(shp then 
			index++ else 
			(trl_altium2pcb_global->exeption = cons("-->3.5.04 ERROR   - Shape NOT Created! Check Polygon Date syntax!!" 
				(trl_altium2pcb_global->exeption)
			    ))
		    )
		)
	    ) 
	    when((index > 0) 
		(axlShapeDynamicUpdate nil nil) 
		(trl_altium2pcb_global->exeption = cons(sprintf(nil "   3.5.01 INFO    - Planes / SplitPlanes: %d CREATED" index) 
			(trl_altium2pcb_global->exeption)
		    ))
	    )
	)
    )
)
procedure(TRL_ALTIUM2PCB_CreateSheet(path) 
    let((sheet_obj sheet_area sheet_line sheet_text new_sheet
	    shape_dbid sheet
	) 
	(sheet_obj = cadr((trl_altium2pcb_global->BoardObjects))) 
	when(sheet_obj 
	    (sheet_area = (axlLayerGet "Drawing Format/Sheet_Area")) 
	    unless(sheet_area 
		(axlLayerCreateNonConductor "Drawing Format/Sheet_Area") 
		(sheet_area = (axlLayerGet "Drawing Format/Sheet_Area"))
	    ) 
	    (sheet_line = (axlLayerGet "Drawing Format/Sheet_Line")) 
	    unless(sheet_line 
		(axlLayerCreateNonConductor "Drawing Format/Sheet_Line") 
		(sheet_line = (axlLayerGet "Drawing Format/Sheet_Line"))
	    )
	    (sheet_text = (axlLayerGet "Drawing Format/Sheet_Text")) 
	    unless(sheet_text 
		(axlLayerCreateNonConductor "Drawing Format/Sheet_Text") 
		(sheet_text = (axlLayerGet "Drawing Format/Sheet_Text"))
	    ) 
	    (sheet = (axlDBCreateRectangle 
		    list((car(sheet_obj):cadr(sheet_obj)) 
			((car(sheet_obj) + caddr(sheet_obj)):(cadr(sheet_obj) + cadddr(sheet_obj)))
		    ) t "Drawing Format/Sheet_Area"
		)) 
	    (sheet = car(sheet)) 
	    if(sheet then 
		if(path then 
		    (new_sheet = car((axlPolyFromDB sheet))) 
		    (new_sheet = (axlPolyOperation new_sheet 
			    (axlPolyFromDB path) 
			    'ANDNOT
			)) 
		    (shape_dbid = (axlDBCreateShape 
			    car(new_sheet) t "Drawing Format/Sheet_Area"
			))
		    (axlDeleteObject sheet) 
		    if(shape_dbid then 
			(trl_altium2pcb_global->exeption = cons(sprintf(nil "   3.3.02 INFO    - Board Sheet GENERATED! Sheet_Size:%L" sheet_obj) 
				(trl_altium2pcb_global->exeption)
			    )) else 
			(trl_altium2pcb_global->exeption = cons(sprintf(nil "-->3.3.04 ERROR   - Board Sheet NOT GENERATED! Sheet_Obj.:%L Path:%L Shape_DBID:%L" sheet_obj path shape_dbid) 
				(trl_altium2pcb_global->exeption)
			    ))
		    ) else 
		    (trl_altium2pcb_global->exeption = cons(sprintf(nil "-->3.3.03 ERROR   - Board Sheet NOT GENERATED! Sheet_Obj.:%L Path:%L" sheet_obj path) 
			    (trl_altium2pcb_global->exeption)
			))
		) else 
		(trl_altium2pcb_global->exeption = cons(sprintf(nil "-->3.3.02 ERROR   - Board Sheet NOT GENERATED! Sheet_Obj.: %L" sheet_obj) 
			(trl_altium2pcb_global->exeption)
		    ))
	    )
	    when((nth(4 sheet_obj) == "FALSE") 
		(axlVisibleLayer "Drawing Format/Sheet_Area" nil)
	    )
	)
    )
)
procedure(TRL_ALTIUM2PCB_Create_BoardOutline(path) 
    let((shp) 
	if(path then 
	    if((axlIsLayer "Board Geometry/Design_Outline") then 
		(shp = (axlDBCreateOpenShape path nil "Board Geometry/Design_Outline")) else 
		(shp = (axlDBCreateOpenShape path nil "Board Geometry/Outline"))
	    ) else 
	    (trl_altium2pcb_global->exeption = cons("-->3.1.03 ERROR   - Board Outline NOT Created! Check Polygon Date syntax!!" 
		    (trl_altium2pcb_global->exeption)
		))
	) 
	if(shp then 
	    (trl_altium2pcb_global->exeption = cons("   3.1.01 INFO    - Board Outline CREATED" 
		    (trl_altium2pcb_global->exeption)
		)) else 
	    (axlDBCreatePath path "Board Geometry/Outline")
	    (trl_altium2pcb_global->exeption = cons("-->3.1.04 ERROR   - Board Outline NOT Created! Check Polygon Date syntax!!" 
		    (trl_altium2pcb_global->exeption)
		))
	)
    )
)
procedure(TRL_ALTIUM2PCB_Create_BoardRecords() 
    let((BoardRecords l_points path) 
	(BoardRecords = car((trl_altium2pcb_global->PcbRawList))) 
	(path = nil) 
	if(BoardRecords then 
	    (l_points = list()) 
	    foreach(rec BoardRecords 
		when((get(rec 
			    'POLYGONTYPE
			) == "Polygon") 
		    (l_points = TRL_ALTIUM2PCB_GetPolyPath(rec))
		) 
		when(get(rec 
			'ORIGINX
		    ) 
		    TRL_ALTIUM2PCB_GetBoardObjects(rec)
		)
	    ) 
	    if(l_points then 
		(path = TRL_ALTIUM2PCB_ComplexPolyPath(l_points)) else 
		(trl_altium2pcb_global->exeption = cons("-->3.1.02 ERROR   - Board Records NOT Created! Check Polygon Date syntax!!" 
			(trl_altium2pcb_global->exeption)
		    ))
	    )
	    else 
	    (trl_altium2pcb_global->exeption = cons("-->3.1.01 ERROR   - Board Data DO NOT exist!!" 
		    (trl_altium2pcb_global->exeption)
		))
	) path
    )
)
procedure(TRL_ALTIUM2PCB_Create_CutOut() 
    let((RegionRecords l_points cutout_path c_shp) 
	(RegionRecords = cadddr(nth(12 
		    (trl_altium2pcb_global->PcbRawList)
		)
	    )) 
	(l_points = list()) 
	if(RegionRecords then 
	    foreach(rec RegionRecords 
		when((get(rec 
			    'ISBOARDCUTOUT
			) == "TRUE") 
		    (l_points = TRL_ALTIUM2PCB_GetPolyPath(rec))
		)
	    ) 
	    when(l_points 
		(cutout_path = TRL_ALTIUM2PCB_ComplexPolyPath(l_points)) 
		if(cutout_path then 
		    if((axlIsLayer "Board Geometry/cutout") then 
			(c_shp = (axlDBCreateOpenShape cutout_path nil "Board Geometry/cutout")) else 
			(c_shp = (axlDBCreateOpenShape cutout_path nil "Board Geometry/Outline"))
		    ) else 
		    (trl_altium2pcb_global->exeption = cons("-->3.2.03 ERROR   - Board CutOut NOT Created! Check Polygon Date syntax!!" 
			    (trl_altium2pcb_global->exeption)
			))
		) 
		if(c_shp then 
		    when(nth(8 
			    (trl_altium2pcb_global->settings)
			) 
			(trl_altium2pcb_global->exeption = cons("   3.2.03 INFO    - Board CutOut CREATED" 
				(trl_altium2pcb_global->exeption)
			    ))
		    ) else 
		    (trl_altium2pcb_global->exeption = cons("   3.2.03 INFO    - Board CutOut NOT Created! Check Polygon Date syntax!!" 
			    (trl_altium2pcb_global->exeption)
			))
		)
	    ) else
	    when(nth(8 
		    (trl_altium2pcb_global->settings)
		) 
		(trl_altium2pcb_global->exeption = cons("   3.2.01 INFO    - Board CutOut Data DO NOT exist!!" 
			(trl_altium2pcb_global->exeption)
		    ))
	    )
	)
    )
)
procedure(TRL_ALTIUM2PCB_Create_Flow_Graphic() 
    let((cadesg_flow_grapic_handle) 
	(cadesg_flow_grapic_handle = (axlGRPDrwInit 
		(trl_altium2pcb_global->formid) "flow_graphic" 
		'TRL_ALTIUM2PCB_flow_graphic
	    )) 
	(axlGRPDrwUpdate cadesg_flow_grapic_handle)
    )
)
procedure(TRL_ALTIUM2PCB_Create_Graphic() 
    let((cadesg_graphic_handle) 
	(cadesg_graphic_handle = (axlGRPDrwInit 
		(trl_altium2pcb_global->formid) "graphic" 
		'cadesg_graphic
	    )) 
	(axlGRPDrwUpdate cadesg_graphic_handle)
    )
)
procedure(TRL_ALTIUM2PCB_Create_LayerStructure() 
    let((BoardRecords m_layers l_layers) 
	(BoardRecords = car((trl_altium2pcb_global->PcbRawList))) 
	if(BoardRecords then 
	    TRL_ALTIUM2PCB_GetLayerStack(BoardRecords) 
	    (m_layers = (trl_altium2pcb_global->LayerMech)) 
	    (l_layers = (trl_altium2pcb_global->LayerStack))
	    if(l_layers then 
		(trl_altium2pcb_global->exeption = cons("   3.4.2  INFO    - Start to Create Electrical LayerStack" 
			(trl_altium2pcb_global->exeption)
		    )) 
		(axlUIWPrint 
		    (trl_altium2pcb_global->formid) "   3.4.2  INFO    - Start to Create Electrical LayerStack"
		) 
		(trl_altium2pcb_global->exeption = cons("                    ========================================================================" 
			(trl_altium2pcb_global->exeption)
		    ))
		(trl_altium2pcb_global->exeption = cons("                    index\ts_name\ts_prev \ts_next s_mech s_copt s_diet s_diec s_dieh s_diem" 
			(trl_altium2pcb_global->exeption)
		    )) 
		(trl_altium2pcb_global->exeption = cons("                    ------------------------------------------------------------------------" 
			(trl_altium2pcb_global->exeption)
		    )) 
		foreach(lay l_layers 
		    (trl_altium2pcb_global->exeption = cons(sprintf(nil "                    %L" lay) 
			    (trl_altium2pcb_global->exeption)
			))
		) 
		TRL_ALTIUM2PCB_CreateLayerStack(l_layers) 
		(trl_altium2pcb_global->exeption = cons("                    ========================================================================" 
			(trl_altium2pcb_global->exeption)
		    ))
		else 
		(trl_altium2pcb_global->exeption = cons("-->3.4.03 ERROR   - Layer Stack NOT Created! Check Date syntax!!" 
			(trl_altium2pcb_global->exeption)
		    ))
	    ) 
	    if(m_layers then 
		(axlUIWPrint 
		    (trl_altium2pcb_global->formid) "   3.4.3  INFO    - Start to Create Mechanical LayerStack"
		) 
		(trl_altium2pcb_global->exeption = cons("   3.4.3  INFO    - Start to Create Mechanical LayerStack" 
			(trl_altium2pcb_global->exeption)
		    )) 
		(trl_altium2pcb_global->exeption = cons("                    ------------------------------------------------------------------------" 
			(trl_altium2pcb_global->exeption)
		    ))
		foreach(lay m_layers 
		    (trl_altium2pcb_global->exeption = cons(sprintf(nil "                    %L" lay) 
			    (trl_altium2pcb_global->exeption)
			))
		) 
		TRL_ALTIUM2PCB_CreateMechanicalStack() 
		(trl_altium2pcb_global->exeption = cons("                    ========================================================================" 
			(trl_altium2pcb_global->exeption)
		    )) else 
		(trl_altium2pcb_global->exeption = cons("   3.4.04 INFO    - NO Mechanical Layer Exist!" 
			(trl_altium2pcb_global->exeption)
		    ))
	    ) else 
	    (trl_altium2pcb_global->exeption = cons("-->3.4.02 ERROR   - Layer Data DO NOT exist!!" 
		    (trl_altium2pcb_global->exeption)
		))
	)
    )
)
procedure(TRL_ALTIUM2PCB_Create_Pad_Shape(padstack_name xsize ysize corner_rad) 
    let((ss_name dec format_str t_xsize t_ysize
	    c_rad padPath symdef cirPath ss_dbid
	) 
	rexCompile("[.]") 
	(dec = cadr((axlDBGetDesignUnits))) 
	(format_str = sprintf(nil "%d" dec)) 
	(format_str = strcat("%." format_str "f"))
	(t_xsize = sprintf(nil format_str xsize)) 
	(t_xsize = rexReplace(t_xsize "" 0)) 
	(t_ysize = sprintf(nil format_str ysize)) 
	(t_ysize = rexReplace(t_ysize "" 0)) 
	(ss_name = sprintf(nil "ss_%sx%sr%d" t_xsize t_ysize corner_rad))
	when(zerop(corner_rad) 
	    (corner_rad = 2)
	) 
	if((corner_rad > 0) then 
	    if((xsize <= ysize) then 
		(c_rad = (xsize / 2)) else 
		(c_rad = (ysize / 2))
	    ) 
	    (c_rad = ((c_rad * corner_rad) / 100)) 
	    (xsize = (xsize / 2))
	    (ysize = (ysize / 2)) 
	    (padPath = (axlPathStart 
		    list(((- xsize):(ysize - c_rad)))
		)) 
	    (padPath = (axlPathArcAngle padPath 0.0 
		    ((- (xsize - c_rad)):ysize) t
		    90.0
		)) 
	    (padPath = (axlPathLine padPath 0.0 
		    ((xsize - c_rad):ysize)
		)) 
	    (padPath = (axlPathArcAngle padPath 0.0 
		    (xsize:(ysize - c_rad)) t
		    90.0
		))
	    (padPath = (axlPathLine padPath 0.0 
		    (xsize:(- (ysize - c_rad)))
		)) 
	    (padPath = (axlPathArcAngle padPath 0.0 
		    ((xsize - c_rad):(- ysize)) t
		    90.0
		)) 
	    (padPath = (axlPathLine padPath 0.0 
		    ((- (xsize - c_rad)):(- ysize))
		)) 
	    (padPath = (axlPathArcAngle padPath 0.0 
		    ((- xsize):(- (ysize - c_rad))) t
		    90.0
		)) 
	    (padPath = (axlPathLine padPath 0.0 
		    ((- xsize):(ysize - c_rad))
		))
	    (symdef = (axlDBCreateSymDefSkeleton 
		    list(ss_name "shape") 
		    list(((- xsize):(- ysize)) 
			(xsize:ysize)
		    )
		)) 
	    (ss_dbid = (axlDBCreateShape padPath t "ETCH/TOP" nil
		    symdef
		)) 
	    unless(ss_dbid 
		(trl_altium2pcb_global->exeption = cons(sprintf(nil "-->4.4.2  ERROR   - PadShape %L NOT created %L -> %L %L %L " ss_name padstack_name symdef
			    ss_dbid cirPath
			) 
			(trl_altium2pcb_global->exeption)
		    ))
	    ) else 
	    (xsize = (xsize / 2))
	    (ysize = (ysize / 2)) 
	    (padPath = (axlPathStart 
		    list(((- xsize):(- ysize)) 
			((- xsize):ysize) 
			(xsize:ysize) 
			(xsize:(- ysize)) 
			((- xsize):(- ysize))
		    )
		)) 
	    (symdef = (axlDBCreateSymDefSkeleton 
		    list(ss_name "shape") 
		    list(((- xsize):(- ysize)) 
			(xsize:ysize)
		    )
		)) 
	    (ss_dbid = (axlDBCreateShape padPath t "ETCH/TOP" nil
		    symdef
		)) 
	    unless(ss_dbid 
		(trl_altium2pcb_global->exeption = cons(sprintf(nil "-->4.4.2  ERROR   - PadShape %L NOT created %L -> %L %L %L " ss_name padstack_name symdef
			    ss_dbid cirPath
			) 
			(trl_altium2pcb_global->exeption)
		    ))
	    )
	) ss_name
    )
)
procedure(TRL_ALTIUM2PCB_Create_StackUp() 
    let((intermediate) 
	(trl_altium2pcb_global->exeption = cons("   3.0.2  INFO    - Start to Add Altium Default Layers" 
		(trl_altium2pcb_global->exeption)
	    )) 
	TRL_ALTIUM2PCB_CREATE_AltiumDefaultLayers() 
	(trl_altium2pcb_global->exeption = cons("   3.1.0  INFO    - Start to Add Board LayerStack" 
		(trl_altium2pcb_global->exeption)
	    )) 
	TRL_ALTIUM2PCB_Create_LayerStructure()
	(intermediate = (trl_altium2pcb_global->intermediate)) 
	(trl_altium2pcb_global->intermediate = list(car(intermediate) 
		cadr(intermediate) t
	    ))
    )
)
procedure(TRL_ALTIUM2PCB_DXPRule_Sort(DXPRules) 
    let((rulekind prio enabled Clearance ShortCircuit
	    UnRoutedNet UnConnectedPin Width RoutingTopology RoutingPriority
	    RoutingLayers RoutingCorners RoutingVias FanoutControl DiffPairsRouting
	    SMDToCorner SMDToPlane SMDNeckDown SolderMaskExpansion PasteMaskExpansion
	    PlaneConnect PlaneClearance PolygonConnect UnpouredPolygon Electrical
	    Routing SMT Mask Plane Testpoint
	    Manufacturing High_Speed Placement Signal_Integrity
	) 
	(Clearance = list()) 
	(ShortCircuit = list()) 
	(UnRoutedNet = list()) 
	(UnConnectedPin = list())
	(Width = list()) 
	(RoutingTopology = list()) 
	(RoutingPriority = list()) 
	(RoutingLayers = list()) 
	(RoutingCorners = list())
	(RoutingVias = list()) 
	(FanoutControl = list()) 
	(DiffPairsRouting = list()) 
	(SMDToCorner = list()) 
	(SMDToPlane = list())
	(SMDNeckDown = list()) 
	(SolderMaskExpansion = list()) 
	(PasteMaskExpansion = list()) 
	(PlaneConnect = list()) 
	(PlaneClearance = list())
	(PolygonConnect = list()) 
	(UnpouredPolygon = list()) 
	(Electrical = list()) 
	(Routing = list()) 
	(SMT = list())
	(Mask = list()) 
	(Plane = list()) 
	(Testpoint = list()) 
	(Manufacturing = list()) 
	(High_Speed = list())
	(Placement = list()) 
	(Signal_Integrity = list()) 
	foreach(rec DXPRules 
	    (rulekind = get(rec 
		    'RULEKIND
		)) 
	    (prio = get(rec 
		    'PRIORITY
		)) 
	    (enabled = get(rec 
		    'ENABLED
		))
	    when((enabled == "TRUE") 
		(prio = atoi(prio)) 
		case(rulekind 
		    ("Clearance" 
			(Clearance = cons(list(prio rec) Clearance))
		    ) 
		    ("ShortCircuit" 
			(ShortCircuit = cons(list(prio rec) ShortCircuit))
		    ) 
		    ("UnRoutedNet" 
			(UnRoutedNet = cons(list(prio rec) UnRoutedNet))
		    ) 
		    ("UnConnectedPin" 
			(UnConnectedPin = cons(list(prio rec) UnConnectedPin))
		    )
		    ("Width" 
			(Width = cons(list(prio rec) Width))
		    ) 
		    ("RoutingTopology" 
			(RoutingTopology = cons(list(prio rec) RoutingTopology))
		    ) 
		    ("RoutingPriority" 
			(RoutingPriority = cons(list(prio rec) RoutingPriority))
		    ) 
		    ("RoutingLayers" 
			(RoutingLayers = cons(list(prio rec) RoutingLayers))
		    ) 
		    ("RoutingCorners" 
			(RoutingCorners = cons(list(prio rec) RoutingCorners))
		    )
		    ("RoutingVias" 
			(RoutingVias = cons(list(prio rec) RoutingVias))
		    ) 
		    ("FanoutControl" 
			(FanoutControl = cons(list(prio rec) FanoutControl))
		    ) 
		    ("DiffPairsRouting" 
			(DiffPairsRouting = cons(list(prio rec) DiffPairsRouting))
		    ) 
		    ("SMDToCorner" 
			(SMDToCorner = cons(list(prio rec) SMDToCorner))
		    ) 
		    ("SMDToPlane" 
			(SMDToPlane = cons(list(prio rec) SMDToPlane))
		    )
		    ("SMDNeckDown" 
			(SMDNeckDown = cons(list(prio rec) SMDNeckDown))
		    ) 
		    ("SolderMaskExpansion" 
			(SolderMaskExpansion = cons(list(prio rec) SolderMaskExpansion))
		    ) 
		    ("PasteMaskExpansion" 
			(PasteMaskExpansion = cons(list(prio rec) PasteMaskExpansion))
		    ) 
		    ("PlaneConnect" 
			(PlaneConnect = cons(list(prio rec) PlaneConnect))
		    ) 
		    ("PlaneClearance" 
			(PlaneClearance = cons(list(prio rec) PlaneClearance))
		    )
		    ("PolygonConnect" 
			(PolygonConnect = cons(list(prio rec) PolygonConnect))
		    ) 
		    ("UnpouredPolygon" 
			(UnpouredPolygon = cons(list(prio rec) UnpouredPolygon))
		    ) 
		    ("FabricationTestpoint" 
			(Testpoint = cons(list(prio rec) Testpoint))
		    ) 
		    ("FabricationTestPointUsage" 
			(Testpoint = cons(list(prio rec) Testpoint))
		    ) 
		    ("AssemblyTestpoint" 
			(Testpoint = cons(list(prio rec) Testpoint))
		    )
		    ("AssemblyTestPointUsage" 
			(Testpoint = cons(list(prio rec) Testpoint))
		    ) 
		    ("MinimumAnnularRing" 
			(Manufacturing = cons(list(prio rec) Manufacturing))
		    ) 
		    ("AcuteAngle" 
			(Manufacturing = cons(list(prio rec) Manufacturing))
		    ) 
		    ("HoleSize" 
			(Manufacturing = cons(list(prio rec) Manufacturing))
		    ) 
		    ("LayerPairs" 
			(Manufacturing = cons(list(prio rec) Manufacturing))
		    )
		    ("HoleToHoleClearance" 
			(Manufacturing = cons(list(prio rec) Manufacturing))
		    ) 
		    ("MinimumSolderMaskSliver" 
			(Manufacturing = cons(list(prio rec) Manufacturing))
		    ) 
		    ("SilkscreenOverComponentPads" 
			(Manufacturing = cons(list(prio rec) Manufacturing))
		    ) 
		    ("SilkToBoardRegionClearance" 
			(Manufacturing = cons(list(prio rec) Manufacturing))
		    ) 
		    ("SilkToSolderMaskClearance" 
			(Manufacturing = cons(list(prio rec) Manufacturing))
		    )
		    ("SilkToSilkClearance" 
			(Manufacturing = cons(list(prio rec) Manufacturing))
		    ) 
		    ("NetAntennae" 
			(Manufacturing = cons(list(prio rec) Manufacturing))
		    ) 
		    ("ParallelSegment" 
			(High_Speed = cons(list(prio rec) High_Speed))
		    ) 
		    ("Length" "Length" 
			(High_Speed = cons(list(prio rec) High_Speed))
		    ) 
		    ("MatchedLengths" 
			(High_Speed = cons(list(prio rec) High_Speed))
		    )
		    ("StubLength" 
			(High_Speed = cons(list(prio rec) High_Speed))
		    ) 
		    ("ViasUnderSMD" 
			(High_Speed = cons(list(prio rec) High_Speed))
		    ) 
		    ("MaximumViaCount" 
			(High_Speed = cons(list(prio rec) High_Speed))
		    ) 
		    ("RoomDefinition" 
			(Placement = cons(list(prio rec) Placement))
		    ) 
		    ("ComponentClearance" 
			(Placement = cons(list(prio rec) Placement))
		    )
		    ("ComponentOrientations" 
			(Placement = cons(list(prio rec) Placement))
		    ) 
		    ("PermittedLayers" 
			(Placement = cons(list(prio rec) Placement))
		    ) 
		    ("NetsToIgnore" 
			(Placement = cons(list(prio rec) Placement))
		    ) 
		    ("Height" 
			(Placement = cons(list(prio rec) Placement))
		    ) 
		    ("SignalStimulus" 
			(Signal_Integrity = cons(list(prio rec) Signal_Integrity))
		    )
		    ("OvershootFalling" 
			(Signal_Integrity = cons(list(prio rec) Signal_Integrity))
		    ) 
		    ("OvershootRising" 
			(Signal_Integrity = cons(list(prio rec) Signal_Integrity))
		    ) 
		    ("UndershootFalling" 
			(Signal_Integrity = cons(list(prio rec) Signal_Integrity))
		    ) 
		    ("UndershootRising" 
			(Signal_Integrity = cons(list(prio rec) Signal_Integrity))
		    ) 
		    ("MaxMinImpedance" 
			(Signal_Integrity = cons(list(prio rec) Signal_Integrity))
		    )
		    ("SignalTopValue" 
			(Signal_Integrity = cons(list(prio rec) Signal_Integrity))
		    ) 
		    ("SignalBaseValue" 
			(Signal_Integrity = cons(list(prio rec) Signal_Integrity))
		    ) 
		    ("FlightTimeRising" 
			(Signal_Integrity = cons(list(prio rec) Signal_Integrity))
		    ) 
		    ("FlightTimeFalling" 
			(Signal_Integrity = cons(list(prio rec) Signal_Integrity))
		    ) 
		    ("SlopeRising" 
			(Signal_Integrity = cons(list(prio rec) Signal_Integrity))
		    )
		    ("SlopeFalling" 
			(Signal_Integrity = cons(list(prio rec) Signal_Integrity))
		    ) 
		    ("SupplyNets" 
			(Signal_Integrity = cons(list(prio rec) Signal_Integrity))
		    ) 
		    (t 
			printf("--Rules-> %L %L\n" rulekind rec)
		    )
		)
	    )
	) 
	(Clearance = sortcar(Clearance 
		'lessp
	    )) 
	(Width = sortcar(Width 
		'lessp
	    ))
	(PolygonConnect = sortcar(PolygonConnect 
		'lessp
	    )) 
	(PlaneClearance = sortcar(PlaneClearance 
		'lessp
	    )) 
	(PlaneConnect = sortcar(PlaneConnect 
		'lessp
	    )) 
	(Electrical = list(Clearance ShortCircuit UnRoutedNet UnConnectedPin)) 
	(Routing = list(Width RoutingTopology RoutingPriority RoutingLayers RoutingCorners
		RoutingVias FanoutControl DiffPairsRouting
	    ))
	(SMT = list(SMDToCorner SMDToPlane SMDNeckDown)) 
	(Mask = list(SolderMaskExpansion PasteMaskExpansion)) 
	(Plane = list(PlaneConnect PlaneClearance PolygonConnect)) 
	list(Electrical Routing SMT Mask Plane
	    Testpoint Manufacturing High_Speed Placement Signal_Integrity
	)
    )
)
procedure(TRL_ALTIUM2PCB_Default_Rules() 
    let((DXPRule Electrical Routing Plane PolygonConnect
	    Width Clearance
	) 
	(trl_altium2pcb_global->exeption = cons("-------------------------------------------------------------------------------" 
		(trl_altium2pcb_global->exeption)
	    )) 
	(trl_altium2pcb_global->exeption = cons("   3.7.02 INFO    - Start to Add Default Rules" 
		(trl_altium2pcb_global->exeption)
	    )) 
	(trl_altium2pcb_global->exeption = cons("-------------------------------------------------------------------------------" 
		(trl_altium2pcb_global->exeption)
	    )) 
	(DXPRule = nth(5 
		(trl_altium2pcb_global->PcbRawList)
	    ))
	(Electrical = car(DXPRule)) 
	(Routing = cadr(DXPRule)) 
	(Plane = nth(4 DXPRule)) 
	when(Electrical 
	    (Clearance = car(Electrical)) 
	    when(Clearance 
		(Clearance = reverse(Clearance)) 
		foreach(rec Clearance 
		    TRL_ALTIUM2PCB_Rules_Clearance(cadr(rec))
		)
	    )
	) 
	when(Routing 
	    (Width = car(Routing)) 
	    when(Width 
		(Width = reverse(Width)) 
		foreach(rec Width 
		    TRL_ALTIUM2PCB_Rules_RoutingWidth(cadr(rec))
		)
	    )
	)
	when(Plane 
	    (PolygonConnect = caddr(Plane)) 
	    when(PolygonConnect 
		(PolygonConnect = reverse(PolygonConnect)) 
		foreach(rec PolygonConnect 
		    TRL_ALTIUM2PCB_Rules_PolygonConnect(cadr(rec))
		)
	    )
	)
    )
)
procedure(TRL_ALTIUM2PCB_Define_PadStack_Type(pad_data) 
    let((xsize ysize shape top_x_size top_y_size
	    mid_x_size mid_y_size bot_x_size bot_y_size top_shape
	    mid_shape bot_shape pad_type pads_list top_cor_r
	    mid_cor_r bot_cor_r x_off y_off drill_dia
	    midx30 midy30 simple
	) 
	(simple = t) 
	(xsize = get(pad_data 
		'XSIZE
	    )) 
	when(xsize 
	    (xsize = TRL_ALTIUM2PCB_Util_DesignUnits(xsize))
	) 
	(ysize = get(pad_data 
		'YSIZE
	    ))
	when(ysize 
	    (ysize = TRL_ALTIUM2PCB_Util_DesignUnits(ysize))
	) 
	(shape = get(pad_data 
		'SHAPE
	    )) 
	(x_off = TRL_ALTIUM2PCB_Util_DesignUnits(get(pad_data 
		    'PADXOFFSET0
		)
	    )) 
	(y_off = TRL_ALTIUM2PCB_Util_DesignUnits(get(pad_data 
		    'PADYOFFSET0
		)
	    )) 
	(drill_dia = TRL_ALTIUM2PCB_Util_DesignUnits(get(pad_data 
		    'HOLESIZE
		)
	    ))
	(midx30 = get(pad_data 
		'MID30XSIZE
	    )) 
	(midy30 = get(pad_data 
		'MID30YSIZE
	    )) 
	when((midx30 || midy30) 
	    (simple = nil)
	) 
	(pads_list = list()) 
	if((shape && xsize && ysize && simple) then 
	    (pad_type = "SIMPLE") 
	    when(((zerop(xsize) || zerop(ysize)) && (drill_dia > 0)) 
		(xsize = (drill_dia / 10)) 
		(ysize = (drill_dia / 10))
	    ) 
	    (top_x_size = xsize)
	    (top_y_size = ysize) 
	    (mid_x_size = xsize) 
	    (mid_y_size = ysize) 
	    (bot_x_size = xsize) 
	    (bot_y_size = ysize)
	    (top_shape = TRL_ALTIUM2PCB_Find_PadStack_Figure(shape top_x_size top_y_size)) 
	    (mid_shape = TRL_ALTIUM2PCB_Find_PadStack_Figure(shape mid_x_size mid_y_size)) 
	    (bot_shape = TRL_ALTIUM2PCB_Find_PadStack_Figure(shape bot_x_size bot_y_size)) 
	    (top_cor_r = get(pad_data 
		    'TOPLAYERCRPCT
		)) 
	    when(top_cor_r 
		(top_cor_r = atoi(top_cor_r))
	    )
	    (mid_cor_r = get(pad_data 
		    'TOPLAYERCRPCT
		)) 
	    when(mid_cor_r 
		(mid_cor_r = atoi(mid_cor_r))
	    ) 
	    (bot_cor_r = get(pad_data 
		    'TOPLAYERCRPCT
		)) 
	    when(bot_cor_r 
		(bot_cor_r = atoi(bot_cor_r))
	    ) 
	    (pads_list = list(pad_type nil 
		    list(list("TOP" top_x_size top_y_size top_shape top_cor_r
			    x_off y_off
			) 
			list("DEFAULT INTERNAL" mid_x_size mid_y_size mid_shape mid_cor_r
			    x_off y_off
			) 
			list("BOTTOM" bot_x_size bot_y_size bot_shape bot_cor_r
			    x_off y_off
			)
		    )
		))
	    else 
	    if((get(pad_data 
			'MID30XSIZE
		    ) || get(pad_data 
			'MID30YSIZE
		    )) then 
		(pad_type = "FULLSTACK") 
		when(get(pad_data 
			'TOPXSIZE
		    ) 
		    (top_x_size = TRL_ALTIUM2PCB_Util_DesignUnits(get(pad_data 
				'TOPXSIZE
			    )
			))
		) 
		unless(top_x_size 
		    (top_x_size = xsize)
		)
		when(get(pad_data 
			'TOPYSIZE
		    ) 
		    (top_y_size = TRL_ALTIUM2PCB_Util_DesignUnits(get(pad_data 
				'TOPYSIZE
			    )
			))
		) 
		unless(top_y_size 
		    (top_y_size = ysize)
		) 
		when(((zerop(top_x_size) || zerop(top_y_size)) && (drill_dia > 0)) 
		    (top_x_size = (drill_dia / 10)) 
		    (top_y_size = (drill_dia / 10))
		) 
		when(get(pad_data 
			'MIDXSIZE
		    ) 
		    (mid_x_size = TRL_ALTIUM2PCB_Util_DesignUnits(get(pad_data 
				'MIDXSIZE
			    )
			))
		) 
		unless(mid_x_size 
		    (mid_x_size = xsize)
		)
		when(get(pad_data 
			'MIDYSIZE
		    ) 
		    (mid_y_size = TRL_ALTIUM2PCB_Util_DesignUnits(get(pad_data 
				'MIDYSIZE
			    )
			))
		) 
		unless(mid_y_size 
		    (mid_y_size = ysize)
		) 
		when(get(pad_data 
			'BOTXSIZE
		    ) 
		    (bot_x_size = TRL_ALTIUM2PCB_Util_DesignUnits(get(pad_data 
				'BOTXSIZE
			    )
			))
		) 
		unless(bot_x_size 
		    (bot_x_size = xsize)
		) 
		when(get(pad_data 
			'BOTYSIZE
		    ) 
		    (bot_y_size = TRL_ALTIUM2PCB_Util_DesignUnits(get(pad_data 
				'BOTYSIZE
			    )
			))
		)
		unless(bot_y_size 
		    (bot_y_size = ysize)
		) 
		(top_shape = get(pad_data 
			'TOPSHAPE
		    )) 
		unless(top_shape 
		    (top_shape = get(pad_data 
			    'SHAPE
			))
		) 
		(top_shape = TRL_ALTIUM2PCB_Find_PadStack_Figure(top_shape top_x_size top_y_size)) 
		(top_cor_r = get(pad_data 
			'TOPLAYERCRPCT
		    ))
		when(top_cor_r 
		    (top_cor_r = atoi(top_cor_r))
		) 
		(mid_shape = get(pad_data 
			'MIDSHAPE
		    )) 
		unless(mid_shape 
		    (mid_shape = get(pad_data 
			    'SHAPE
			))
		) 
		(mid_shape = TRL_ALTIUM2PCB_Find_PadStack_Figure(mid_shape mid_x_size mid_y_size)) 
		(mid_cor_r = get(pad_data 
			'MIDLAYER1CRPCT
		    ))
		when(mid_cor_r 
		    (mid_cor_r = atoi(mid_cor_r))
		) 
		(bot_shape = get(pad_data 
			'BOTSHAPE
		    )) 
		unless(bot_shape 
		    (bot_shape = get(pad_data 
			    'SHAPE
			))
		) 
		(bot_shape = TRL_ALTIUM2PCB_Find_PadStack_Figure(bot_shape bot_x_size bot_y_size)) 
		(bot_cor_r = get(pad_data 
			'BOTTOMLAYERSHAPE
		    ))
		when(bot_cor_r 
		    (bot_cor_r = atoi(bot_cor_r))
		) 
		(pads_list = list(pad_type nil 
			list(list("TOP" top_x_size top_y_size top_shape top_cor_r
				x_off y_off
			    ) 
			    list("DEFAULT INTERNAL" mid_x_size mid_y_size mid_shape mid_cor_r
				x_off y_off
			    ) 
			    list("BOTTOM" bot_x_size bot_y_size bot_shape bot_cor_r
				x_off y_off
			    )
			)
		    )) else 
		(pad_type = "TOPMIDBOT") 
		when(get(pad_data 
			'TOPXSIZE
		    ) 
		    (top_x_size = TRL_ALTIUM2PCB_Util_DesignUnits(get(pad_data 
				'TOPXSIZE
			    )
			))
		)
		unless(top_x_size 
		    (top_x_size = xsize)
		) 
		when(get(pad_data 
			'TOPYSIZE
		    ) 
		    (top_y_size = TRL_ALTIUM2PCB_Util_DesignUnits(get(pad_data 
				'TOPYSIZE
			    )
			))
		) 
		unless(top_y_size 
		    (top_y_size = ysize)
		) 
		when(((zerop(top_x_size) || zerop(top_y_size)) && (drill_dia > 0)) 
		    (top_x_size = (drill_dia / 10)) 
		    (top_y_size = (drill_dia / 10)) 
		    (top_shape = "ROUND")
		) 
		when(get(pad_data 
			'MIDXSIZE
		    ) 
		    (mid_x_size = TRL_ALTIUM2PCB_Util_DesignUnits(get(pad_data 
				'MIDXSIZE
			    )
			))
		)
		unless(mid_x_size 
		    (mid_x_size = xsize)
		) 
		when(get(pad_data 
			'MIDYSIZE
		    ) 
		    (mid_y_size = TRL_ALTIUM2PCB_Util_DesignUnits(get(pad_data 
				'MIDYSIZE
			    )
			))
		) 
		unless(mid_y_size 
		    (mid_y_size = ysize)
		) 
		when(((zerop(mid_x_size) || zerop(mid_y_size)) && (drill_dia > 0)) 
		    (mid_x_size = (drill_dia / 10)) 
		    (mid_y_size = (drill_dia / 10)) 
		    (top_shape = "ROUND")
		) 
		when(get(pad_data 
			'BOTXSIZE
		    ) 
		    (bot_x_size = TRL_ALTIUM2PCB_Util_DesignUnits(get(pad_data 
				'BOTXSIZE
			    )
			))
		)
		unless(bot_x_size 
		    (bot_x_size = xsize)
		) 
		when(get(pad_data 
			'BOTYSIZE
		    ) 
		    (bot_y_size = TRL_ALTIUM2PCB_Util_DesignUnits(get(pad_data 
				'BOTYSIZE
			    )
			))
		) 
		unless(bot_y_size 
		    (bot_y_size = ysize)
		) 
		when(((zerop(bot_x_size) || zerop(bot_y_size)) && (drill_dia > 0)) 
		    (bot_x_size = (drill_dia / 10)) 
		    (bot_y_size = (drill_dia / 10)) 
		    (bot_shape = "ROUND")
		) 
		unless(top_shape 
		    (top_shape = get(pad_data 
			    'TOPSHAPE
			)) 
		    unless(top_shape 
			(top_shape = get(pad_data 
				'SHAPE
			    ))
		    )
		)
		(top_shape = TRL_ALTIUM2PCB_Find_PadStack_Figure(top_shape top_x_size top_y_size)) 
		(top_cor_r = get(pad_data 
			'TOPLAYERCRPCT
		    )) 
		when(top_cor_r 
		    (top_cor_r = atoi(top_cor_r))
		) 
		unless(mid_shape 
		    (mid_shape = get(pad_data 
			    'MIDSHAPE
			)) 
		    unless(mid_shape 
			(mid_shape = get(pad_data 
				'SHAPE
			    ))
		    )
		) 
		(mid_shape = TRL_ALTIUM2PCB_Find_PadStack_Figure(mid_shape mid_x_size mid_y_size))
		(mid_cor_r = get(pad_data 
			'MIDLAYER1CRPCT
		    )) 
		when(mid_cor_r 
		    (mid_cor_r = atoi(mid_cor_r))
		) 
		unless(bot_shape 
		    (bot_shape = get(pad_data 
			    'BOTSHAPE
			)) 
		    unless(bot_shape 
			(bot_shape = get(pad_data 
				'SHAPE
			    ))
		    )
		) 
		(bot_shape = TRL_ALTIUM2PCB_Find_PadStack_Figure(bot_shape bot_x_size bot_y_size)) 
		(bot_cor_r = get(pad_data 
			'BOTTOMLAYERCRPCT
		    ))
		when(bot_cor_r 
		    (bot_cor_r = atoi(bot_cor_r))
		) 
		(pads_list = list(pad_type nil 
			list(list("TOP" top_x_size top_y_size top_shape top_cor_r
				x_off y_off
			    ) 
			    list("DEFAULT INTERNAL" mid_x_size mid_y_size mid_shape mid_cor_r
				x_off y_off
			    ) 
			    list("BOTTOM" bot_x_size bot_y_size bot_shape bot_cor_r
				x_off y_off
			    )
			)
		    ))
	    )
	)
	pads_list
    )
)
procedure(TRL_ALTIUM2PCB_Define_PadStack_name(padstack_name drill_list pads_list paste solder) 
    let((new_name drill pad_figure xsize ysize
	    pad plating slot x_offset y_offset
	    string locindex pads pad_ind
	) 
	if((car(pads_list) == "FULLSTACK") then 
	    (new_name = padstack_name) 
	    (string = parseString(new_name "")) 
	    when((length(string) > 64) 
		(new_name = "") 
		for(i 0 22 
		    (new_name = strcat(new_name 
			    nth(i string)
			))
		) 
		(locindex = (trl_altium2pcb_global->index)) 
		locindex++
		(trl_altium2pcb_global->index = locindex) 
		(new_name = sprintf(nil "%s%d" new_name 
			(trl_altium2pcb_global->index)
		    ))
	    )
	    else 
	    case(car(pads_list) 
		("SINGLE" 
		    (new_name = "smd_") 
		    (pad_ind = 0) 
		    unless((cadr(pads_list) == "TOP") 
			(new_name = strcat(new_name 
				cadr(pads_list) "_"
			    ))
		    )
		) 
		("SIMPLE" 
		    (new_name = "pth_") 
		    (pad_ind = 0)
		) 
		("TOPMIDBOT" 
		    (new_name = "mlt_") 
		    (pad_ind = 2)
		) 
		(t 
		    (new_name = "exp_") 
		    (pad_ind = 0)
		)
	    ) 
	    (drill = car(drill_list)) 
	    (plating = cadr(drill_list)) 
	    (slot = caddr(drill_list))
	    (pads = caddr(pads_list)) 
	    for(i 0 pad_ind 
		(pad = nth(i pads)) 
		(xsize = cadr(pad))
		(ysize = caddr(pad)) 
		(x_offset = nth(5 pad)) 
		(y_offset = nth(6 pad)) 
		when(((xsize <= drill) || (ysize <= drill)) 
		    (new_name = "mec_")
		) 
		(xsize = sprintf(nil "%d" 
			round((xsize * 10))
		    ))
		(ysize = sprintf(nil "%d" 
			round((ysize * 10))
		    )) 
		when((car(pads_list) == "TOPMIDBOT") 
		    when((i == 0) 
			(new_name = strcat(new_name "t_"))
		    ) 
		    when((i == 1) 
			(new_name = strcat(new_name "_i_"))
		    ) 
		    when((i == 2) 
			(new_name = strcat(new_name "_b_"))
		    )
		) 
		caseq((nth(3 pad)->figure) 
		    (CIRCLE 
			(new_name = strcat(new_name "c" xsize))
		    ) 
		    (SQUARE 
			(new_name = strcat(new_name "s" xsize))
		    ) 
		    (RECTANGLE 
			(new_name = strcat(new_name "r" xsize "x" ysize))
		    ) 
		    (OBLONG_X 
			(new_name = strcat(new_name "o" xsize "x" ysize))
		    )
		    (OBLONG_Y 
			(new_name = strcat(new_name "o" xsize "x" ysize))
		    ) 
		    (ROUNDEDRECTANGLE 
			(new_name = sprintf(nil "%srr%sx%sr%d" new_name xsize ysize
				nth(4 pad)
			    ))
		    ) 
		    (t 
			(new_name = strcat(new_name "a" xsize)) 
			printf("--PadShape-> %L\n" 
			    (pad_figure->figure)
			)
		    )
		)
	    ) 
	    when((drill > 0) 
		if((slot > 0) then 
		    (new_name = sprintf(nil "%sslot%dx%d" new_name 
			    round((drill * 10)) 
			    round((slot * 10))
			)) 
		    unless((plating == "TRUE") 
			(new_name = strcat(new_name "_np"))
		    ) else
		    (new_name = sprintf(nil "%sd%d" new_name 
			    round((drill * 10))
			)) 
		    unless((plating == "TRUE") 
			(new_name = strcat(new_name "_np"))
		    )
		)
	    ) 
	    when((car(pads_list) == "SINGLE") 
		when((paste >= 0) 
		    (new_name = sprintf(nil "%sp%d" new_name 
			    round((paste * 10))
			))
		)
	    ) 
	    if((solder >= 0) then 
		(new_name = sprintf(nil "%ss%d" new_name 
			round((solder * 10))
		    ))
	    )
	    when(((x_offset != 0) || (y_offset != 0)) 
		(new_name = sprintf(nil "%soff%Lx%L" new_name 
			round((x_offset * 10)) 
			round((y_offset * 10))
		    ))
	    )
	) new_name
    )
)
procedure(TRL_ALTIUM2PCB_DumpDB2File() 
    let((outp input_string) 
	(input_string = (axlFormGetField 
		(trl_altium2pcb_global->formid) "intermediate_l"
	    )) 
	if(isDir(input_string) then 
	    if(isWritable(input_string) then 
		(trl_altium2pcb_global->exeption = cons(sprintf(nil "   X.1.01 INFO    - Intermediate Directory set: %L" input_string) 
			(trl_altium2pcb_global->exeption)
		    )) else 
		(trl_altium2pcb_global->exeption = cons(sprintf(nil "   X.1.01 INFO    - Intermediate Directory: %L Not Writable" input_string) 
			(trl_altium2pcb_global->exeption)
		    ))
		(input_string = nil)
	    ) else 
	    if(createDir(input_string) then 
		(trl_altium2pcb_global->exeption = cons(sprintf(nil "   X.1.01 INFO    - Intermediate Directory set: %L" input_string) 
			(trl_altium2pcb_global->exeption)
		    )) else 
		(trl_altium2pcb_global->exeption = cons(sprintf(nil "   X.1.01 INFO    - Intermediate Directory: %L Not Writable" input_string) 
			(trl_altium2pcb_global->exeption)
		    ))
		(input_string = nil)
	    )
	) 
	when(input_string 
	    (outp = outfile(strcat(input_string "/Intermediate.txt"))) 
	    foreach(rec 
		list((trl_altium2pcb_global->intermediate)) 
		fprintf(outp "%L" rec)
	    ) 
	    close(outp) 
	    (outp = outfile(strcat(input_string "/BoardRecords.txt")))
	    foreach(rec 
		nth(0 
		    (trl_altium2pcb_global->PcbRawList)
		) 
		fprintf(outp "%L" rec)
	    ) 
	    close(outp) 
	    (outp = outfile(strcat(input_string "/ClassRecords.txt"))) 
	    foreach(rec 
		nth(1 
		    (trl_altium2pcb_global->PcbRawList)
		) 
		fprintf(outp "%L" rec)
	    ) 
	    close(outp)
	    (outp = outfile(strcat(input_string "/NetRecords.txt"))) 
	    foreach(rec 
		nth(2 
		    (trl_altium2pcb_global->PcbRawList)
		) 
		fprintf(outp "%L" rec)
	    ) 
	    close(outp) 
	    (outp = outfile(strcat(input_string "/ComponentRecords.txt"))) 
	    foreach(rec 
		nth(3 
		    (trl_altium2pcb_global->PcbRawList)
		) 
		fprintf(outp "%L" rec)
	    )
	    close(outp) 
	    (outp = outfile(strcat(input_string "/PolygonRecords.txt"))) 
	    foreach(rec 
		nth(4 
		    (trl_altium2pcb_global->PcbRawList)
		) 
		fprintf(outp "%L" rec)
	    ) 
	    close(outp) 
	    (outp = outfile(strcat(input_string "/DXPRuleRecords.txt")))
	    foreach(rec 
		nth(5 
		    (trl_altium2pcb_global->PcbRawList)
		) 
		fprintf(outp "%L" rec)
	    ) 
	    close(outp) 
	    (outp = outfile(strcat(input_string "/RuleRecords.txt"))) 
	    foreach(rec 
		nth(6 
		    (trl_altium2pcb_global->PcbRawList)
		) 
		fprintf(outp "%L" rec)
	    ) 
	    close(outp)
	    (outp = outfile(strcat(input_string "/ArcRecords.txt"))) 
	    foreach(rec 
		nth(7 
		    (trl_altium2pcb_global->PcbRawList)
		) 
		fprintf(outp "%L" rec)
	    ) 
	    close(outp) 
	    (outp = outfile(strcat(input_string "/PadRecords_cmp.txt"))) 
	    foreach(rec 
		car(nth(8 
			(trl_altium2pcb_global->PcbRawList)
		    )
		) 
		fprintf(outp "%L" rec)
	    )
	    close(outp) 
	    (outp = outfile(strcat(input_string "/PadRecords_misc.txt"))) 
	    foreach(rec 
		cadr(nth(8 
			(trl_altium2pcb_global->PcbRawList)
		    )
		) 
		fprintf(outp "%L" rec)
	    ) 
	    close(outp) 
	    (outp = outfile(strcat(input_string "/ViaRecords_cmp.txt")))
	    foreach(rec 
		car(nth(9 
			(trl_altium2pcb_global->PcbRawList)
		    )
		) 
		fprintf(outp "%L" rec)
	    ) 
	    close(outp) 
	    (outp = outfile(strcat(input_string "/ViaRecords_net.txt"))) 
	    foreach(rec 
		cadr(nth(9 
			(trl_altium2pcb_global->PcbRawList)
		    )
		) 
		fprintf(outp "%L" rec)
	    ) 
	    close(outp)
	    (outp = outfile(strcat(input_string "/ViaRecords_misc.txt"))) 
	    foreach(rec 
		caddr(nth(9 
			(trl_altium2pcb_global->PcbRawList)
		    )
		) 
		fprintf(outp "%L" rec)
	    ) 
	    close(outp) 
	    (outp = outfile(strcat(input_string "/TrackRecords_cmp.txt"))) 
	    foreach(rec 
		car(nth(10 
			(trl_altium2pcb_global->PcbRawList)
		    )
		) 
		fprintf(outp "%L" rec)
	    )
	    close(outp) 
	    (outp = outfile(strcat(input_string "/TrackRecords_net.txt"))) 
	    foreach(rec 
		cadr(nth(10 
			(trl_altium2pcb_global->PcbRawList)
		    )
		) 
		fprintf(outp "%L" rec)
	    ) 
	    close(outp) 
	    (outp = outfile(strcat(input_string "/TrackRecords_misc.txt")))
	    foreach(rec 
		caddr(nth(10 
			(trl_altium2pcb_global->PcbRawList)
		    )
		) 
		fprintf(outp "%L" rec)
	    ) 
	    close(outp) 
	    (outp = outfile(strcat(input_string "/TextRecords_cmp.txt"))) 
	    foreach(rec 
		car(nth(11 
			(trl_altium2pcb_global->PcbRawList)
		    )
		) 
		fprintf(outp "%L" rec)
	    ) 
	    close(outp)
	    (outp = outfile(strcat(input_string "/TextRecords_net.txt"))) 
	    foreach(rec 
		cadr(nth(11 
			(trl_altium2pcb_global->PcbRawList)
		    )
		) 
		fprintf(outp "%L" rec)
	    ) 
	    close(outp) 
	    (outp = outfile(strcat(input_string "/TextRecords_misc.txt"))) 
	    foreach(rec 
		caddr(nth(11 
			(trl_altium2pcb_global->PcbRawList)
		    )
		) 
		fprintf(outp "%L" rec)
	    )
	    close(outp) 
	    (outp = outfile(strcat(input_string "/RegionRecords_cmp.txt"))) 
	    foreach(rec 
		car(nth(12 
			(trl_altium2pcb_global->PcbRawList)
		    )
		) 
		fprintf(outp "%L" rec)
	    ) 
	    close(outp) 
	    (outp = outfile(strcat(input_string "/RegionRecords_net.txt")))
	    foreach(rec 
		cadr(nth(12 
			(trl_altium2pcb_global->PcbRawList)
		    )
		) 
		fprintf(outp "%L" rec)
	    ) 
	    close(outp) 
	    (outp = outfile(strcat(input_string "/RegionRecords_poly.txt"))) 
	    foreach(rec 
		caddr(nth(12 
			(trl_altium2pcb_global->PcbRawList)
		    )
		) 
		fprintf(outp "%L" rec)
	    ) 
	    close(outp)
	    (outp = outfile(strcat(input_string "/RegionRecords_misc.txt"))) 
	    foreach(rec 
		cadddr(nth(12 
			(trl_altium2pcb_global->PcbRawList)
		    )
		) 
		fprintf(outp "%L" rec)
	    ) 
	    close(outp) 
	    (outp = outfile(strcat(input_string "/FillRecords_cmp.txt"))) 
	    foreach(rec 
		car(nth(13 
			(trl_altium2pcb_global->PcbRawList)
		    )
		) 
		fprintf(outp "%L" rec)
	    )
	    close(outp) 
	    (outp = outfile(strcat(input_string "/FillRecords_net.txt"))) 
	    foreach(rec 
		cadr(nth(13 
			(trl_altium2pcb_global->PcbRawList)
		    )
		) 
		fprintf(outp "%L" rec)
	    ) 
	    close(outp) 
	    (outp = outfile(strcat(input_string "/FillRecords_misc.txt")))
	    foreach(rec 
		caddr(nth(13 
			(trl_altium2pcb_global->PcbRawList)
		    )
		) 
		fprintf(outp "%L" rec)
	    ) 
	    close(outp) 
	    (outp = outfile(strcat(input_string "/CompBodyRecords.txt"))) 
	    foreach(rec 
		nth(14 
		    (trl_altium2pcb_global->PcbRawList)
		) 
		fprintf(outp "%L" rec)
	    ) 
	    close(outp)
	    (outp = outfile(strcat(input_string "/MiscRecords.txt"))) 
	    foreach(rec 
		nth(15 
		    (trl_altium2pcb_global->PcbRawList)
		) 
		fprintf(outp "%L" rec)
	    ) 
	    close(outp)
	)
    )
)
procedure(TRL_ALTIUM2PCB_Find_PadStack_Figure(shape xsize ysize) 
    let((pad_figure) 
	(pad_figure = ncons(nil)) 
	(pad_figure->figure = 'CIRCLE) 
	case(shape 
	    ("ROUND" 
		(pad_figure->figure = 'CIRCLE) 
		when((xsize > ysize) 
		    (pad_figure->figure = 'OBLONG_X)
		) 
		when((xsize < ysize) 
		    (pad_figure->figure = 'OBLONG_Y)
		)
	    ) 
	    ("OCTAGONAL" 
		(pad_figure->figure = 'OCTAGON) 
		when((xsize > ysize) 
		    (pad_figure->figure = 'OBLONG_X)
		) 
		when((xsize < ysize) 
		    (pad_figure->figure = 'OBLONG_Y)
		)
	    ) 
	    ("RECTANGLE" 
		(pad_figure->figure = 'RECTANGLE) 
		when((xsize == ysize) 
		    (pad_figure->figure = 'SQUARE)
		)
	    ) 
	    ("ROUNDEDRECTANGLE" 
		(pad_figure->figure = 'ROUNDEDRECTANGLE)
	    )
	    (t 
		(pad_figure->figure = 'RECTANGLE) 
		printf("--> unknown PadShape %L - %L - %L\n" shape xsize ysize) 
		(trl_altium2pcb_global->exeption = cons(sprintf(nil "   4.4.0  INFO    - Unknown Padshape-> %L " shape) 
			(trl_altium2pcb_global->exeption)
		    ))
	    )
	) pad_figure
    )
)
procedure(TRL_ALTIUM2PCB_Form_Action(form_handle) 
    let((input_string file_name index new_color OKToProceed
	    remaining org_color tmp_lst
	) 
	case((form_handle->curField) 
	    ("tree" 
		TRL_ALTIUM2PCB_Tree_Item_Action((form_handle->curValue))
	    ) 
	    ("tab" 
		when(((form_handle->curValue) == "Flow") 
		    TRL_ALTIUM2PCB_Create_Flow_Graphic()
		)
	    ) 
	    ("create_intermediate" 
		TRL_ALTIUM2PCB_DumpDB2File()
	    ) 
	    ("derive_clines" 
		(TBX_DERIVECONN_Process_Clines)
	    )
	    ("derive_shapes" 
		(TBX_DERIVECONN_Process_Shapes)
	    ) 
	    ("derive_extended" 
		if((form_handle->curValue) then 
		    (axlFormSetFieldEditable 
			(trl_altium2pcb_global->formid) "derive_clines" t
		    ) 
		    (axlFormSetFieldEditable 
			(trl_altium2pcb_global->formid) "derive_shapes" t
		    ) else
		    (axlFormSetFieldEditable 
			(trl_altium2pcb_global->formid) "derive_clines" nil
		    ) 
		    (axlFormSetFieldEditable 
			(trl_altium2pcb_global->formid) "derive_shapes" nil
		    )
		)
	    ) 
	    ("load_intermediate" 
		(OKToProceed = (axlOKToProceed)) 
		if(OKToProceed then 
		    (file_name = (axlFormGetField form_handle "intermediate_l")) 
		    if((file_name && isDir(file_name)) then 
			TRL_ALTIUM2PCB_LoadIntermediate_Init_Files() 
			if(caar((trl_altium2pcb_global->intermediate)) then 
			    (trl_altium2pcb_global->intermediate = caar((trl_altium2pcb_global->intermediate))) 
			    (trl_altium2pcb_global->intermediate = list((trl_altium2pcb_global->intermediate) nil nil)) 
			    (axlFormTreeViewSet form_handle "tree" 
				'TV_REMOVEALL nil
			    )
			    TRL_ALTIUM2PCB_Tree_View() 
			    (axlFormTreeViewSet form_handle "tree" 
				'TV_NOEDITLABEL nil
			    ) 
			    (axlFormSetFieldEditable form_handle "create_intermediate" nil) 
			    (axlFormSetFieldEditable form_handle "load_PcbDoc" nil) else
			    (axlFormSetFieldEditable form_handle "create_intermediate" t) 
			    (axlFormSetFieldEditable form_handle "load_PcbDoc" t) 
			    (axlFormSetField form_handle "load_intermediate" nil) 
			    (axlUIWPrint form_handle "E - Intermediate Data missing!")
			) 
			unless(caddr((trl_altium2pcb_global->intermediate)) 
			    TRL_ALTIUM2PCB_Create_StackUp()
			)
			else 
			(axlUIWPrint form_handle "E - Intermediate Data missing!")
		    ) else
		    (axlUIWPrint form_handle "E - Finish current command first!")
		)
	    ) 
	    ("create_misc" 
		(OKToProceed = (axlOKToProceed)) 
		if(OKToProceed then 
		    TRL_ALTIUM2PCB_CREATE_FootprintDump() else 
		    (axlUIWPrint form_handle "E - Finish current command first!")
		)
	    ) 
	    ("load_PcbDoc" 
		(file_name = (axlFormGetField form_handle "PcbDoc_l")) 
		if((file_name && isFile(file_name)) then 
		    (trl_altium2pcb_global->settings = cons(file_name 
			    cdr((trl_altium2pcb_global->settings))
			)) 
		    TRL_ALTIUM2PCB_Load_PCB_Data() 
		    if((trl_altium2pcb_global->PcbRawList) then 
			(trl_altium2pcb_global->PadStacklist = list()) 
			TRL_ALTIUM2PCB_UTIL_Check_DBID() 
			TRL_ALTIUM2PCB_CREATE_NETS()
			TRL_ALTIUM2PCB_Create_StackUp() 
			(axlFormTreeViewSet form_handle "tree" 
			    'TV_REMOVEALL nil
			) 
			TRL_ALTIUM2PCB_Tree_View() 
			(axlFormTreeViewSet form_handle "tree" 
			    'TV_NOEDITLABEL nil
			) 
			(org_color = car((trl_altium2pcb_global->GUI)))
			(remaining = cadr((trl_altium2pcb_global->GUI))) 
			(index = 1) 
			foreach(color org_color 
			    if(onep(index) then 
				(new_color = cons("green" new_color)) else 
				(new_color = cons(color new_color))
			    ) 
			    index++
			) 
			(new_color = reverse(new_color)) 
			(trl_altium2pcb_global->GUI = list(new_color remaining))
			TRL_ALTIUM2PCB_Create_Flow_Graphic() 
			(axlFormSetFieldEditable form_handle "board_setup" t) 
			(axlFormSetFieldEditable form_handle "create_intermediate" t) 
			(axlFormSetField form_handle "load_intermediate" nil) 
			(axlFormSetFieldEditable form_handle "load_intermediate" nil)
			else 
			(org_color = car((trl_altium2pcb_global->GUI))) 
			(remaining = cadr((trl_altium2pcb_global->GUI))) 
			(index = 1) 
			foreach(color org_color 
			    if(onep(index) then 
				(new_color = cons("red" new_color)) else 
				(new_color = cons(color new_color))
			    ) 
			    index++
			)
			(new_color = reverse(new_color)) 
			(trl_altium2pcb_global->GUI = list(new_color remaining)) 
			TRL_ALTIUM2PCB_Create_Flow_Graphic() 
			(axlFormSetFieldEditable form_handle "board_setup" nil)
		    )
		    else 
		    printf("Warning: Specify valid file to be translated.\n")
		)
	    )
	    ("create_footprints" 
		when((axlFormGetField 
			(trl_altium2pcb_global->formid) "load_intermediate"
		    ) 
		    TRL_ALTIUM2PCB_LoadIntermediateFootprintFiles() 
		    (trl_altium2pcb_global->PadStacklist = list()) 
		    unless((trl_altium2pcb_global->PartsList) 
			TRL_ALTIUM2PCB_CREATE_Pattern_List()
		    ) 
		    TRL_ALTIUM2PCB_Create_StackUp()
		    (axlFormSetFieldEditable form_handle "create_devices" nil) 
		    (axlFormSetFieldEditable form_handle "create_logic" nil) 
		    (axlFormSetFieldEditable form_handle "create_setup" nil) 
		    (axlFormSetFieldEditable form_handle "create_placement" nil) 
		    (axlFormSetFieldEditable form_handle "create_routing" nil)
		    (axlFormSetFieldEditable form_handle "create_shapes" nil) 
		    (trl_altium2pcb_global->exeption = cons("\t\t---------------------------------------------------------------------------------------------------------" 
			    (trl_altium2pcb_global->exeption)
			)) 
		    (trl_altium2pcb_global->exeption = cons("\t\tGen_Patt_Name     Unic_Patt_Name   ID IND REF X      Y      Layer  Fix    Rot   Org_refDes Org_Patt   " 
			    (trl_altium2pcb_global->exeption)
			)) 
		    (trl_altium2pcb_global->exeption = cons("\t\t---------------------------------------------------------------------------------------------------------" 
			    (trl_altium2pcb_global->exeption)
			)) 
		    foreach(part 
			(trl_altium2pcb_global->PartsList) 
			(trl_altium2pcb_global->exeption = cons(sprintf(nil "\t\t%L" part) 
				(trl_altium2pcb_global->exeption)
			    ))
		    )
		) 
		if((trl_altium2pcb_global->PartsList) then 
		    TRL_ALTIUM2PCB_CREATE_FootprintDump() 
		    (org_color = car((trl_altium2pcb_global->GUI))) 
		    (remaining = cadr((trl_altium2pcb_global->GUI)))
		    (index = 1) 
		    foreach(color org_color 
			if((index == 2) then 
			    (new_color = cons("green" new_color)) else 
			    (new_color = cons(color new_color))
			) 
			index++
		    ) 
		    (new_color = reverse(new_color)) 
		    (trl_altium2pcb_global->GUI = list(new_color remaining)) 
		    TRL_ALTIUM2PCB_Create_Flow_Graphic()
		    else 
		    (org_color = car((trl_altium2pcb_global->GUI))) 
		    (remaining = cadr((trl_altium2pcb_global->GUI))) 
		    (index = 1) 
		    foreach(color org_color 
			if((index == 2) then 
			    (new_color = cons("red" new_color)) else 
			    (new_color = cons(color new_color))
			) 
			index++
		    )
		    (new_color = reverse(new_color)) 
		    (trl_altium2pcb_global->GUI = list(new_color remaining)) 
		    TRL_ALTIUM2PCB_Create_Flow_Graphic() 
		    (axlFormSetFieldEditable form_handle "board_setup" nil)
		)
	    ) 
	    ("create_devices" 
		when((axlFormGetField 
			(trl_altium2pcb_global->formid) "load_intermediate"
		    ) 
		    TRL_ALTIUM2PCB_LoadIntermediateDeviceFiles() 
		    TRL_ALTIUM2PCB_UTIL_Check_DBID() 
		    if((caddr((trl_altium2pcb_global->UtilsList)) && nth(5 
				(trl_altium2pcb_global->UtilsList)
			    )) then 
			(trl_altium2pcb_global->exeption = cons("   4.7.2  INFO    - DeviceFile and Netlist will came from Schematic!" 
				(trl_altium2pcb_global->exeption)
			    )) 
			(axlUIWPrint form_handle "E - DeviceFile and Netlist will came from Schematic!") else
			TRL_ALTIUM2PCB_CREATE_Pattern_List() 
			(axlFormSetFieldEditable form_handle "create_footprints" nil) 
			(axlFormSetFieldEditable form_handle "create_logic" nil) 
			(axlFormSetFieldEditable form_handle "create_setup" nil) 
			(axlFormSetFieldEditable form_handle "create_placement" nil)
			(axlFormSetFieldEditable form_handle "create_routing" nil) 
			(axlFormSetFieldEditable form_handle "create_shapes" nil)
		    )
		) 
		if((trl_altium2pcb_global->PartsList) then 
		    TRL_ALTIUM2PCB_CREATE_DeviceFileDump() 
		    (org_color = car((trl_altium2pcb_global->GUI))) 
		    (remaining = cadr((trl_altium2pcb_global->GUI)))
		    (index = 1) 
		    foreach(color org_color 
			if((index == 3) then 
			    (new_color = cons("green" new_color)) else 
			    (new_color = cons(color new_color))
			) 
			index++
		    ) 
		    (new_color = reverse(new_color)) 
		    (trl_altium2pcb_global->GUI = list(new_color remaining)) 
		    TRL_ALTIUM2PCB_Create_Flow_Graphic()
		    else 
		    (org_color = car((trl_altium2pcb_global->GUI))) 
		    (remaining = cadr((trl_altium2pcb_global->GUI))) 
		    (index = 1) 
		    foreach(color org_color 
			if((index == 3) then 
			    (new_color = cons("red" new_color)) else 
			    (new_color = cons(color new_color))
			) 
			index++
		    )
		    (new_color = reverse(new_color)) 
		    (trl_altium2pcb_global->GUI = list(new_color remaining)) 
		    TRL_ALTIUM2PCB_Create_Flow_Graphic() 
		    (axlFormSetFieldEditable form_handle "board_setup" nil)
		)
	    ) 
	    ("create_logic" 
		when((axlFormGetField 
			(trl_altium2pcb_global->formid) "load_intermediate"
		    ) 
		    TRL_ALTIUM2PCB_LoadIntermediateNetLogicFiles() 
		    TRL_ALTIUM2PCB_UTIL_Check_DBID() 
		    if((caddr((trl_altium2pcb_global->UtilsList)) && nth(5 
				(trl_altium2pcb_global->UtilsList)
			    )) then 
			(trl_altium2pcb_global->exeption = cons("   4.7.2  INFO    - DeviceFile and Netlist will came from Schematic!" 
				(trl_altium2pcb_global->exeption)
			    )) 
			(axlUIWPrint form_handle "E - DeviceFile and Netlist will came from Schematic!") else
			TRL_ALTIUM2PCB_CREATE_Pattern_List() 
			(axlFormSetFieldEditable form_handle "create_footprints" nil) 
			(axlFormSetFieldEditable form_handle "create_devices" nil) 
			(axlFormSetFieldEditable form_handle "create_setup" nil) 
			(axlFormSetFieldEditable form_handle "create_placement" nil)
			(axlFormSetFieldEditable form_handle "create_routing" nil) 
			(axlFormSetFieldEditable form_handle "create_shapes" nil)
		    )
		) 
		if((trl_altium2pcb_global->PartsList) then 
		    TRL_ALTIUM2PCB_CREATE_ComponentAndNetLogic() 
		    (org_color = car((trl_altium2pcb_global->GUI))) 
		    (remaining = cadr((trl_altium2pcb_global->GUI)))
		    (index = 1) 
		    foreach(color org_color 
			if((index == 4) then 
			    (new_color = cons("green" new_color)) else 
			    (new_color = cons(color new_color))
			) 
			index++
		    ) 
		    (new_color = reverse(new_color)) 
		    (trl_altium2pcb_global->GUI = list(new_color remaining)) 
		    TRL_ALTIUM2PCB_Create_Flow_Graphic()
		    TRL_ALTIUM2PCB_SaveBoard(sprintf(nil "%s_Logic" 
			    car((trl_altium2pcb_global->intermediate))
			) 2
		    ) else 
		    (org_color = car((trl_altium2pcb_global->GUI))) 
		    (remaining = cadr((trl_altium2pcb_global->GUI))) 
		    (index = 1)
		    foreach(color org_color 
			if((index == 4) then 
			    (new_color = cons("red" new_color)) else 
			    (new_color = cons(color new_color))
			) 
			index++
		    ) 
		    (new_color = reverse(new_color)) 
		    (trl_altium2pcb_global->GUI = list(new_color remaining)) 
		    TRL_ALTIUM2PCB_Create_Flow_Graphic() 
		    (axlFormSetFieldEditable form_handle "board_setup" nil)
		)
	    ) 
	    ("create_setup" 
		when((axlFormGetField 
			(trl_altium2pcb_global->formid) "load_intermediate"
		    ) 
		    TRL_ALTIUM2PCB_LoadIntermediate_BoardSetUpFiles() 
		    (trl_altium2pcb_global->PadStacklist = list()) 
		    TRL_ALTIUM2PCB_CREATE_NETS() 
		    (axlFormSetFieldEditable form_handle "create_footprints" nil)
		    (axlFormSetFieldEditable form_handle "create_devices" nil) 
		    (axlFormSetFieldEditable form_handle "create_logic" nil) 
		    (axlFormSetFieldEditable form_handle "create_placement" nil) 
		    (axlFormSetFieldEditable form_handle "create_routing" nil) 
		    (axlFormSetFieldEditable form_handle "create_shapes" nil)
		    (trl_altium2pcb_global->PartsList = t)
		) 
		if((trl_altium2pcb_global->PartsList) then 
		    TRL_ALTIUM2PCB_Create_StackUp() 
		    TRL_ALTIUM2PCB_BoardSetUp() 
		    (org_color = car((trl_altium2pcb_global->GUI)))
		    (remaining = cadr((trl_altium2pcb_global->GUI))) 
		    (index = 1) 
		    foreach(color org_color 
			if((index == 5) then 
			    (new_color = cons("green" new_color)) else 
			    (new_color = cons(color new_color))
			) 
			index++
		    ) 
		    (new_color = reverse(new_color)) 
		    (trl_altium2pcb_global->GUI = list(new_color remaining))
		    TRL_ALTIUM2PCB_Create_Flow_Graphic() 
		    TRL_ALTIUM2PCB_SaveBoard(sprintf(nil "%s_BoardSetUp" 
			    car((trl_altium2pcb_global->intermediate))
			) 3
		    ) else 
		    (org_color = car((trl_altium2pcb_global->GUI))) 
		    (remaining = cadr((trl_altium2pcb_global->GUI)))
		    (index = 1) 
		    foreach(color org_color 
			if((index == 5) then 
			    (new_color = cons("red" new_color)) else 
			    (new_color = cons(color new_color))
			) 
			index++
		    ) 
		    (new_color = reverse(new_color)) 
		    (trl_altium2pcb_global->GUI = list(new_color remaining)) 
		    TRL_ALTIUM2PCB_Create_Flow_Graphic()
		    (axlFormSetFieldEditable form_handle "board_setup" nil)
		)
	    ) 
	    ("create_placement" 
		when((axlFormGetField 
			(trl_altium2pcb_global->formid) "load_intermediate"
		    ) 
		    TRL_ALTIUM2PCB_LoadIntermediate_Placement_Files() 
		    (trl_altium2pcb_global->PadStacklist = list()) 
		    unless((trl_altium2pcb_global->PartsList) 
			TRL_ALTIUM2PCB_CREATE_Pattern_List()
		    ) 
		    (axlFormSetFieldEditable form_handle "create_footprints" nil)
		    (axlFormSetFieldEditable form_handle "create_devices" nil) 
		    (axlFormSetFieldEditable form_handle "create_logic" nil) 
		    (axlFormSetFieldEditable form_handle "create_setup" nil) 
		    (axlFormSetFieldEditable form_handle "create_routing" nil) 
		    (axlFormSetFieldEditable form_handle "create_shapes" nil)
		) 
		if((trl_altium2pcb_global->PartsList) then 
		    TRL_ALTIUM2PCB_CREATE_ComponentPlacement() 
		    TRL_ALTIUM2PCB_SETUP_Footprint_Text() 
		    (org_color = car((trl_altium2pcb_global->GUI)))
		    (remaining = cadr((trl_altium2pcb_global->GUI))) 
		    (index = 1) 
		    foreach(color org_color 
			if((index == 6) then 
			    (new_color = cons("green" new_color)) else 
			    (new_color = cons(color new_color))
			) 
			index++
		    ) 
		    (new_color = reverse(new_color)) 
		    (trl_altium2pcb_global->GUI = list(new_color remaining))
		    TRL_ALTIUM2PCB_Create_Flow_Graphic() 
		    TRL_ALTIUM2PCB_SaveBoard(sprintf(nil "%s_Placed" 
			    car((trl_altium2pcb_global->intermediate))
			) 4
		    ) else 
		    (org_color = car((trl_altium2pcb_global->GUI))) 
		    (remaining = cadr((trl_altium2pcb_global->GUI)))
		    (index = 1) 
		    foreach(color org_color 
			if((index == 6) then 
			    (new_color = cons("red" new_color)) else 
			    (new_color = cons(color new_color))
			) 
			index++
		    ) 
		    (new_color = reverse(new_color)) 
		    (trl_altium2pcb_global->GUI = list(new_color remaining)) 
		    TRL_ALTIUM2PCB_Create_Flow_Graphic()
		    (axlFormSetFieldEditable form_handle "board_setup" nil)
		)
	    )
	    ("create_routing" 
		when((axlFormGetField 
			(trl_altium2pcb_global->formid) "load_intermediate"
		    ) 
		    TRL_ALTIUM2PCB_LoadIntermediate_Routing_Files() 
		    (trl_altium2pcb_global->PadStacklist = list()) 
		    TRL_ALTIUM2PCB_CREATE_NETS() 
		    (axlFormSetFieldEditable form_handle "create_footprints" nil)
		    (axlFormSetFieldEditable form_handle "create_devices" nil) 
		    (axlFormSetFieldEditable form_handle "create_logic" nil) 
		    (axlFormSetFieldEditable form_handle "create_setup" nil) 
		    (axlFormSetFieldEditable form_handle "create_placement" nil) 
		    (axlFormSetFieldEditable form_handle "create_shapes" nil)
		    (trl_altium2pcb_global->PartsList = t)
		) 
		if((trl_altium2pcb_global->PartsList) then 
		    TRL_ALTIUM2PCB_CREATE_ROUTE() 
		    TRL_ALTIUM2PCB_CREATE_VIAS() 
		    (org_color = car((trl_altium2pcb_global->GUI)))
		    (remaining = cadr((trl_altium2pcb_global->GUI))) 
		    (index = 1) 
		    foreach(color org_color 
			if((index == 7) then 
			    (new_color = cons("green" new_color)) else 
			    (new_color = cons(color new_color))
			) 
			index++
		    ) 
		    (new_color = reverse(new_color)) 
		    (trl_altium2pcb_global->GUI = list(new_color remaining))
		    TRL_ALTIUM2PCB_Create_Flow_Graphic() 
		    TRL_ALTIUM2PCB_SaveBoard(sprintf(nil "%s_Routed" 
			    car((trl_altium2pcb_global->intermediate))
			) 5
		    ) else 
		    (org_color = car((trl_altium2pcb_global->GUI))) 
		    (remaining = cadr((trl_altium2pcb_global->GUI)))
		    (index = 1) 
		    foreach(color org_color 
			if((index == 7) then 
			    (new_color = cons("red" new_color)) else 
			    (new_color = cons(color new_color))
			) 
			index++
		    ) 
		    (new_color = reverse(new_color)) 
		    (trl_altium2pcb_global->GUI = list(new_color remaining)) 
		    TRL_ALTIUM2PCB_Create_Flow_Graphic()
		    (axlFormSetFieldEditable form_handle "board_setup" nil)
		)
	    ) 
	    ("create_shapes" 
		when((axlFormGetField 
			(trl_altium2pcb_global->formid) "load_intermediate"
		    ) 
		    TRL_ALTIUM2PCB_LoadIntermediate_Shape_Files() 
		    (trl_altium2pcb_global->PadStacklist = list()) 
		    TRL_ALTIUM2PCB_CREATE_NETS() 
		    (axlFormSetFieldEditable form_handle "create_footprints" nil)
		    (axlFormSetFieldEditable form_handle "create_devices" nil) 
		    (axlFormSetFieldEditable form_handle "create_logic" nil) 
		    (axlFormSetFieldEditable form_handle "create_setup" nil) 
		    (axlFormSetFieldEditable form_handle "create_placement" nil) 
		    (axlFormSetFieldEditable form_handle "create_routing" nil)
		    (trl_altium2pcb_global->PartsList = t)
		) 
		if((trl_altium2pcb_global->PartsList) then 
		    TRL_ALTIUM2PCB_CREATE_SHAPES() 
		    (org_color = car((trl_altium2pcb_global->GUI))) 
		    (remaining = cadr((trl_altium2pcb_global->GUI)))
		    (index = 1) 
		    foreach(color org_color 
			if((index == 8) then 
			    (new_color = cons("green" new_color)) else 
			    (new_color = cons(color new_color))
			) 
			index++
		    ) 
		    (new_color = reverse(new_color)) 
		    (trl_altium2pcb_global->GUI = list(new_color remaining)) 
		    TRL_ALTIUM2PCB_Create_Flow_Graphic()
		    else 
		    (org_color = car((trl_altium2pcb_global->GUI))) 
		    (remaining = cadr((trl_altium2pcb_global->GUI))) 
		    (index = 1) 
		    foreach(color org_color 
			if((index == 8) then 
			    (new_color = cons("red" new_color)) else 
			    (new_color = cons(color new_color))
			) 
			index++
		    )
		    (new_color = reverse(new_color)) 
		    (trl_altium2pcb_global->GUI = list(new_color remaining)) 
		    TRL_ALTIUM2PCB_Create_Flow_Graphic() 
		    (axlFormSetFieldEditable form_handle "board_setup" nil)
		)
	    ) 
	    ("PCBSysColors" 
		(file_name = (axlDMFileBrowse nil nil ?optFilters "Altium PCB Files(*.PCBSysColors)|*.PCBSysColors")) 
		when((file_name && isFile(file_name)) 
		    (axlFormSetField form_handle "PCBSysColors_l" file_name) 
		    (tmp_lst = list()) 
		    for(i 1 
			length((trl_altium2pcb_global->settings)) 
			if((i == 2) then 
			    (tmp_lst = cons(file_name tmp_lst)) else 
			    (tmp_lst = cons(nth((i - 1) 
					(trl_altium2pcb_global->settings)
				    ) tmp_lst
				))
			)
		    ) 
		    (trl_altium2pcb_global->settings = reverse(tmp_lst))
		)
	    ) 
	    ("PcbDoc" 
		(file_name = (axlDMFileBrowse nil nil ?optFilters "Altium PCB Files(*.PcbDoc)|*.PcbDoc")) 
		when((file_name && isFile(file_name)) 
		    (axlFormSetField form_handle "PcbDoc_l" file_name)
		)
	    ) 
	    ("psms" 
		(input_string = (axlDMDirectoryBrowse "." t ?title "Pick psm directory")) 
		if(isWritable(input_string) then 
		    (axlSetVariable "PSMPATH" input_string) 
		    (trl_altium2pcb_global->exeption = cons(sprintf(nil "   X.1.01 INFO    - PSM Directory set: %L" input_string) 
			    (trl_altium2pcb_global->exeption)
			)) 
		    (axlFormSetField form_handle "psms_l" input_string)
		    else 
		    (trl_altium2pcb_global->exeption = cons(sprintf(nil "   X.1.01 INFO    - PSM Directory: %L Not Writable" input_string) 
			    (trl_altium2pcb_global->exeption)
			)) 
		    (axlFormSetField form_handle "psms_l" "")
		)
	    )
	    ("psms_l" 
		(input_string = (form_handle->curValue)) 
		if(isDir(input_string) then 
		    if(isWritable(input_string) then 
			(axlSetVariable "PSMPATH" input_string) 
			(trl_altium2pcb_global->exeption = cons(sprintf(nil "   X.1.01 INFO    - PSM Directory set: %L" input_string) 
				(trl_altium2pcb_global->exeption)
			    )) else
			(trl_altium2pcb_global->exeption = cons(sprintf(nil "   X.1.01 INFO    - PSM Directory: %L Not Writable" input_string) 
				(trl_altium2pcb_global->exeption)
			    )) 
			(axlFormSetField form_handle "psms_l" "")
		    ) else 
		    if(createDir(input_string) then 
			(axlSetVariable "PSMPATH" input_string) 
			(trl_altium2pcb_global->exeption = cons(sprintf(nil "   X.1.01 INFO    - PSM Directory set: %L" input_string) 
				(trl_altium2pcb_global->exeption)
			    )) else
			(trl_altium2pcb_global->exeption = cons(sprintf(nil "   X.1.01 INFO    - PSM Directory: %L Not Writable" input_string) 
				(trl_altium2pcb_global->exeption)
			    )) 
			(axlFormSetField 
			    (trl_altium2pcb_global->formid) "psms_l" ""
			)
		    )
		)
	    ) 
	    ("pads" 
		(input_string = (axlDMDirectoryBrowse "." t ?title "Pick psm directory")) 
		if(isWritable(input_string) then 
		    (axlSetVariable "PADPATH" input_string) 
		    (trl_altium2pcb_global->exeption = cons(sprintf(nil "   X.1.01 INFO    - PAD Directory set: %L" input_string) 
			    (trl_altium2pcb_global->exeption)
			)) 
		    (axlFormSetField form_handle "pads_l" input_string)
		    else 
		    (trl_altium2pcb_global->exeption = cons(sprintf(nil "   X.1.01 INFO    - PAD Directory: %L Not Writable" input_string) 
			    (trl_altium2pcb_global->exeption)
			)) 
		    (axlFormSetField form_handle "pads_l" "")
		)
	    ) 
	    ("pads_l" 
		(input_string = ((trl_altium2pcb_global->formid)->curValue)) 
		if(isDir(input_string) then 
		    if(isWritable(input_string) then 
			(axlSetVariable "PADPATH" input_string) 
			(trl_altium2pcb_global->exeption = cons(sprintf(nil "   X.1.01 INFO    - PAD Directory set: %L" input_string) 
				(trl_altium2pcb_global->exeption)
			    )) else
			(trl_altium2pcb_global->exeption = cons(sprintf(nil "   X.1.01 INFO    - PAD Directory: %L Not Writable" input_string) 
				(trl_altium2pcb_global->exeption)
			    )) 
			(axlFormSetField 
			    (trl_altium2pcb_global->formid) "pads_l" ""
			)
		    ) else 
		    if(createDir(input_string) then 
			(axlSetVariable "PADPATH" input_string) 
			(trl_altium2pcb_global->exeption = cons(sprintf(nil "   X.1.01 INFO    - PAD Directory set: %L" input_string) 
				(trl_altium2pcb_global->exeption)
			    )) else
			(trl_altium2pcb_global->exeption = cons(sprintf(nil "   X.1.01 INFO    - PAD Directory: %L Not Writable" input_string) 
				(trl_altium2pcb_global->exeption)
			    )) 
			(axlFormSetField 
			    (trl_altium2pcb_global->formid) "pads_l" ""
			)
		    )
		)
	    ) 
	    ("prts" 
		(input_string = (axlDMDirectoryBrowse "." t ?title "Pick dev directory")) 
		if(isWritable(input_string) then 
		    (axlSetVariable "DEVPATH" input_string) 
		    (trl_altium2pcb_global->exeption = cons(sprintf(nil "   X.1.01 INFO    - DEV Directory set: %L" input_string) 
			    (trl_altium2pcb_global->exeption)
			)) 
		    (axlFormSetField form_handle "prts_l" input_string)
		    else 
		    (trl_altium2pcb_global->exeption = cons(sprintf(nil "   X.1.01 INFO    - DEV Directory: %L Not Writable" input_string) 
			    (trl_altium2pcb_global->exeption)
			)) 
		    (axlFormSetField form_handle "prts_l" "")
		)
	    ) 
	    ("prts_l" 
		(input_string = ((trl_altium2pcb_global->formid)->curValue)) 
		if(isDir(input_string) then 
		    if(isWritable(input_string) then 
			(axlSetVariable "DEVPATH" input_string) 
			(trl_altium2pcb_global->exeption = cons(sprintf(nil "   X.1.01 INFO    - DEV Directory set: %L" input_string) 
				(trl_altium2pcb_global->exeption)
			    )) else
			(trl_altium2pcb_global->exeption = cons(sprintf(nil "   X.1.01 INFO    - DEV Directory: %L Not Writable" input_string) 
				(trl_altium2pcb_global->exeption)
			    )) 
			(axlFormSetField 
			    (trl_altium2pcb_global->formid) "prts_l" ""
			)
		    ) else 
		    if(createDir(input_string) then 
			(axlSetVariable "DEVPATH" input_string) 
			(trl_altium2pcb_global->exeption = cons(sprintf(nil "   X.1.01 INFO    - DEV Directory set: %L" input_string) 
				(trl_altium2pcb_global->exeption)
			    )) else
			(trl_altium2pcb_global->exeption = cons(sprintf(nil "   X.1.01 INFO    - DEV Directory: %L Not Writable" input_string) 
				(trl_altium2pcb_global->exeption)
			    )) 
			(axlFormSetField 
			    (trl_altium2pcb_global->formid) "prts_l" ""
			)
		    )
		)
	    )
	    ("report" 
		TRL_ALTIUM2PCB_Report()
	    ) 
	    ("close" 
		(axlSetVariable "DEVPATH" 
		    (trl_altium2pcb_global->devpath)
		) 
		(axlFormClose form_handle) 
		(axlCancelEnterFun)
	    ) 
	    ("my_help" 
		TRL_HELP_Launch("altium2pcb_adv")
	    )
	)
    )
)
procedure(TRL_ALTIUM2PCB_Form_Action_Basic(form_handle) 
    let((file_name loc_settings) 
	case((form_handle->curField) 
	    ("make_generic" 
		(loc_settings = (trl_altium2pcb_global->settings)) 
		if((form_handle->curValue) then 
		    (trl_altium2pcb_global->settings = list(car(loc_settings) 
			    cadr(loc_settings) 
			    caddr(loc_settings) 
			    cadddr(loc_settings) 
			    nth(4 loc_settings)
			    nth(5 loc_settings) t t nil
			)) else 
		    (trl_altium2pcb_global->settings = list(car(loc_settings) 
			    cadr(loc_settings) 
			    caddr(loc_settings) 
			    cadddr(loc_settings) 
			    nth(4 loc_settings)
			    nth(5 loc_settings) nil t nil
			))
		)
	    ) 
	    ("report" 
		TRL_ALTIUM2PCB_Report()
	    ) 
	    ("run_translator" 
		(file_name = (axlFormGetField form_handle "PcbDoc_l")) 
		if((file_name && isFile(file_name)) then 
		    (trl_altium2pcb_global->settings = cons(file_name 
			    cdr((trl_altium2pcb_global->settings))
			)) 
		    TRL_ALTIUM2PCB_Load_PCB_Data() 
		    when((trl_altium2pcb_global->PcbRawList) 
			(trl_altium2pcb_global->PadStacklist = list()) 
			TRL_ALTIUM2PCB_UTIL_Check_DBID() 
			TRL_ALTIUM2PCB_Create_StackUp() 
			TRL_ALTIUM2PCB_CREATE_FootprintDump()
			TRL_ALTIUM2PCB_CREATE_DeviceFileDump() 
			TRL_ALTIUM2PCB_CREATE_ComponentAndNetLogic() 
			TRL_ALTIUM2PCB_SaveBoard(sprintf(nil "%s_Logic" 
				car((trl_altium2pcb_global->intermediate))
			    ) 2
			) 
			TRL_ALTIUM2PCB_BoardSetUp() 
			TRL_ALTIUM2PCB_SaveBoard(sprintf(nil "%s_BoardSetUp" 
				car((trl_altium2pcb_global->intermediate))
			    ) 3
			)
			TRL_ALTIUM2PCB_CREATE_ComponentPlacement() 
			TRL_ALTIUM2PCB_SETUP_Footprint_Text() 
			TRL_ALTIUM2PCB_SaveBoard(sprintf(nil "%s_Placed" 
				car((trl_altium2pcb_global->intermediate))
			    ) 4
			) 
			TRL_ALTIUM2PCB_CREATE_ROUTE() 
			TRL_ALTIUM2PCB_CREATE_VIAS()
			TRL_ALTIUM2PCB_SaveBoard(sprintf(nil "%s_Routed" 
				car((trl_altium2pcb_global->intermediate))
			    ) 5
			) 
			TRL_ALTIUM2PCB_CREATE_SHAPES() 
			TRL_ALTIUM2PCB_SaveBoard(sprintf(nil "%s_Final" 
				car((trl_altium2pcb_global->intermediate))
			    ) 6
			) 
			TRL_ALTIUM2PCB_Report(car((trl_altium2pcb_global->intermediate)))
		    )
		    else 
		    printf("Please specify file to be translated.\n")
		)
	    ) 
	    ("PcbDoc" 
		(file_name = (axlDMFileBrowse nil nil ?optFilters "Altium PCB Files(*.PcbDoc)|*.PcbDoc")) 
		when((file_name && isFile(file_name)) 
		    (axlFormSetField form_handle "PcbDoc_l" file_name)
		)
	    )
	    ("close" 
		(axlSetVariable "DEVPATH" 
		    (trl_altium2pcb_global->devpath)
		) 
		(axlFormClose form_handle) 
		(axlCancelEnterFun)
	    ) 
	    ("my_help" 
		TRL_HELP_Launch("altium2pcb")
	    )
	)
    )
)
procedure(TRL_ALTIUM2PCB_Form_Settings_Advanced() 
    let((msg) 
	(axlFormSetFieldEditable 
	    (trl_altium2pcb_global->formid) "board_setup" nil
	) 
	(axlFormSetFieldEditable 
	    (trl_altium2pcb_global->formid) "create_components" nil
	) 
	(axlFormSetFieldEditable 
	    (trl_altium2pcb_global->formid) "routing" nil
	) 
	(axlFormSetFieldEditable 
	    (trl_altium2pcb_global->formid) "create_rules" nil
	)
	(axlFormSetFieldEditable 
	    (trl_altium2pcb_global->formid) "create_misc" nil
	) 
	(axlFormSetField 
	    (trl_altium2pcb_global->formid) "prts_l" "./devices"
	) 
	(axlFormSetField 
	    (trl_altium2pcb_global->formid) "psms_l" "./symbols"
	) 
	(axlFormSetField 
	    (trl_altium2pcb_global->formid) "pads_l" "./symbols"
	) 
	(axlFormSetField 
	    (trl_altium2pcb_global->formid) "intermediate_l" "./intermediate"
	)
	(msg = "") 
	(msg = strcat(msg "Components with same footprint name will usually reference the same (unique) ")) 
	(msg = strcat(msg "footprint library element. Altium however, although the same footprint name specified, ")) 
	(msg = strcat(msg "different footprint elements will be used. In this case do not use Generic option.")) 
	(axlFormSetField 
	    (trl_altium2pcb_global->formid) "msg_info" msg
	)
	TRL_ALTIUM2PCB_Set_Allegro_Paths() 
	(trl_altium2pcb_global->intermediate = list(nil nil nil)) 
	(axlFormSetFieldEditable 
	    (trl_altium2pcb_global->formid) "create_intermediate" nil
	) 
	(axlFormSetFieldEditable 
	    (trl_altium2pcb_global->formid) "load_intermediate" t
	) 
	(axlFormSetFieldEditable 
	    (trl_altium2pcb_global->formid) "derive_extended" t
	)
	(axlFormSetFieldEditable 
	    (trl_altium2pcb_global->formid) "derive_clines" nil
	) 
	(axlFormSetFieldEditable 
	    (trl_altium2pcb_global->formid) "derive_shapes" nil
	) 
	(axlFormSetFieldEditable 
	    (trl_altium2pcb_global->formid) "pads_l" nil
	) 
	(axlFormSetFieldEditable 
	    (trl_altium2pcb_global->formid) "pads" nil
	) 
	(axlFormSetFieldEditable 
	    (trl_altium2pcb_global->formid) "psms_l" nil
	)
	(axlFormSetFieldEditable 
	    (trl_altium2pcb_global->formid) "psms" nil
	) 
	(axlFormSetField 
	    (trl_altium2pcb_global->formid) "derive_extended" nil
	) 
	(axlFormSetField 
	    (trl_altium2pcb_global->formid) "width_factor" 0.9
	) 
	(axlFormSetField 
	    (trl_altium2pcb_global->formid) "line_space" 1.25
	) 
	(axlFormSetField 
	    (trl_altium2pcb_global->formid) "char_space" 0.1
	)
	(axlFormSetField 
	    (trl_altium2pcb_global->formid) "photo_width" 0
	) 
	(axlFormSetField 
	    (trl_altium2pcb_global->formid) "post_155" t
	) 
	(axlFormSetField 
	    (trl_altium2pcb_global->formid) "alt" t
	) 
	(axlFormSetField 
	    (trl_altium2pcb_global->formid) "version" 2
	) 
	(axlFormColorize 
	    (trl_altium2pcb_global->formid) "info" 
	    'text 
	    'red
	)
	(axlFormSetField 
	    (trl_altium2pcb_global->formid) "make_generic" t
	) 
	(axlFormSetField 
	    (trl_altium2pcb_global->formid) "mech_generic" nil
	) 
	(axlFormSetField 
	    (trl_altium2pcb_global->formid) "cmp_def_txt" t
	) 
	(axlFormSetField 
	    (trl_altium2pcb_global->formid) "debugging_mode_on" t
	) 
	(axlFormSetField 
	    (trl_altium2pcb_global->formid) "graphic_space" 3450
	)
	(axlFormSetField 
	    (trl_altium2pcb_global->formid) "graphic_size" 1000
	) 
	(axlFormSetField 
	    (trl_altium2pcb_global->formid) "graphic_center_x" 1600
	) 
	(axlFormSetField 
	    (trl_altium2pcb_global->formid) "graphic_center_y" 2000
	) 
	(axlLayerPrioritySet "BOARD GEOMETRY/Silkscreen_TOP" 1) 
	(axlLayerPrioritySet "PACKAGE GEOMETRY/Silkscreen_TOP" 2)
	(trl_altium2pcb_global->GUI = list()) 
	(trl_altium2pcb_global->GUI = cons(list(nil) 
		(trl_altium2pcb_global->GUI)
	    )) 
	(trl_altium2pcb_global->GUI = cons(list("darkgray" "darkgray" "darkgray" "darkgray" "darkgray"
		    "darkgray" "darkgray" "darkgray"
		) 
		(trl_altium2pcb_global->GUI)
	    )) 
	TRL_ALTIUM2PCB_Create_Flow_Graphic() 
	when(car((trl_altium2pcb_global->settings)) 
	    (axlFormSetField 
		(trl_altium2pcb_global->formid) "PcbDoc_l" 
		car((trl_altium2pcb_global->settings))
	    )
	)
	(trl_altium2pcb_global->settings = list("" "" 
		axlGetVariable("devpath") 
		axlGetVariable("psmpath") 
		axlGetVariable("padpath")
		t nil t nil
	    ))
    )
)
procedure(TRL_ALTIUM2PCB_GET_Pin_Data(component_id pad pads_raw) 
    let((Pad_List) 
	(Pad_List = list()) 
	when(pads_raw 
	    foreach(rec pads_raw 
		when(((get(rec 
				'COMPONENT
			    ) == component_id) && (get(rec 
				'NAME
			    ) == cadr(pad)) && (get(rec 
				'X
			    ) == caddr(pad)) && (get(rec 
				'Y
			    ) == nth(3 pad))) 
		    (Pad_List = rec)
		)
	    )
	) Pad_List
    )
)
procedure(TRL_ALTIUM2PCB_GetBoardObjects(rec) 
    let((originx originy sheetx sheety sheetwidth
	    sheetheight showsheet l_plane s_plane negative_plane
	    sheet_list
	) 
	(originx = TRL_ALTIUM2PCB_Util_DesignUnits(get(rec 
		    'ORIGINX
		)
	    )) 
	(originy = TRL_ALTIUM2PCB_Util_DesignUnits(get(rec 
		    'ORIGINY
		)
	    )) 
	(sheetx = TRL_ALTIUM2PCB_Util_DesignUnits(get(rec 
		    'SHEETX
		)
	    )) 
	(sheety = TRL_ALTIUM2PCB_Util_DesignUnits(get(rec 
		    'SHEETY
		)
	    ))
	(sheetwidth = TRL_ALTIUM2PCB_Util_DesignUnits(get(rec 
		    'SHEETWIDTH
		)
	    )) 
	(sheetheight = TRL_ALTIUM2PCB_Util_DesignUnits(get(rec 
		    'SHEETHEIGHT
		)
	    )) 
	(showsheet = get(rec 
		'SHOWSHEET
	    )) 
	if(sheetx then 
	    (sheet_list = list(sheetx sheety sheetwidth sheetheight showsheet)) else 
	    (sheet_list = list())
	) 
	(negative_plane = list())
	for(index 1 16 
	    (l_plane = stringToSymbol(sprintf(nil "PLANE%dNETNAME" index))) 
	    (s_plane = get(rec l_plane))
	    (s_plane = car(parseString(s_plane "\r"))) 
	    unless((s_plane == "(No Net)") 
		(negative_plane = cons(list((38 + index) 
			    sprintf(nil "PLANE%d" index) s_plane
			) negative_plane
		    ))
	    ) 
	    index++
	) 
	(trl_altium2pcb_global->BoardObjects = list((originx:originy) sheet_list negative_plane))
    )
)
procedure(TRL_ALTIUM2PCB_GetColorStack() 
    let((index l_pc long RGB rgb_list
	    obj_list ll_rgb col_nr lay_name obj_rgb
	    t_nr ColorFile lay_param param_str r_color
	) 
	(index = 1) 
	(r_color = car((trl_altium2pcb_global->color))) 
	(ColorFile = TRL_ALTIUM2PCB_Load_ColorFile()) 
	for(i 1 82 
	    (l_pc = stringToSymbol(sprintf(nil "PC%d" i))) 
	    (long = get(r_color l_pc))
	    (long = atoi(long)) 
	    (RGB = TRL_ALTIUM2PCB_Util_Convert_Long2RGB(long)) 
	    (rgb_list = cons(RGB rgb_list)) 
	    (obj_list = cons(list(i RGB) obj_list)) 
	    i++
	)
	(obj_list = cons(list(200 
		    list(255 255 255)
		) obj_list
	    )) 
	(obj_list = cons(list(201 
		    list(0 0 0)
		) obj_list
	    )) 
	(obj_list = cons(list(202 
		    list(0 0 0)
		) obj_list
	    )) 
	when((trl_altium2pcb_global->LayerMech) 
	    foreach(mech 
		(trl_altium2pcb_global->LayerMech) 
		when((length(mech) == 4) 
		    (rgb_list = cons(nth(3 mech) rgb_list))
		)
	    )
	) 
	when(ColorFile 
	    (obj_list = car(ColorFile)) 
	    (rgb_list = cadr(ColorFile))
	)
	(rgb_list = cons(list(255 255 255) rgb_list)) 
	(rgb_list = cons(list(0 0 0) rgb_list)) 
	(ll_rgb = cons(car(rgb_list) ll_rgb)) 
	foreach(rgb rgb_list 
	    unless(member(rgb ll_rgb) 
		(ll_rgb = cons(rgb ll_rgb))
	    )
	) 
	(ll_rgb = sortcar(ll_rgb 
		'lessp
	    ))
	(axlColorSet 
	    'all ll_rgb
	) 
	foreach(layer 
	    (trl_altium2pcb_global->LayerStack) 
	    (col_nr = car(layer)) 
	    (lay_name = cadr(layer)) 
	    foreach(obj obj_list 
		when((car(obj) == col_nr) 
		    (obj_rgb = cadr(obj))
		)
	    )
	    (index = 1) 
	    foreach(rgb ll_rgb 
		when((obj_rgb == rgb) 
		    (t_nr = index)
		) 
		index++
	    ) 
	    when(t_nr 
		when(onep(col_nr) 
		    (lay_name = "TOP")
		) 
		when((col_nr == 32) 
		    (lay_name = "BOTTOM")
		) 
		(param_str = sprintf(nil "paramLayerGroup:ETCH/paramLayer:%s" lay_name)) 
		(lay_param = (axlGetParam param_str))
		if(lay_param then 
		    (lay_param->color = t_nr) 
		    (axlSetParam lay_param) 
		    when(nth(8 
			    (trl_altium2pcb_global->settings)
			) 
			(trl_altium2pcb_global->exeption = cons(sprintf(nil "   3.7.2  INFO    - Layer (ETCH): %-13s Color: %-3d %L %L" lay_name t_nr obj_rgb
				    layer
				) 
				(trl_altium2pcb_global->exeption)
			    ))
		    )
		    else 
		    (trl_altium2pcb_global->exeption = cons(sprintf(nil "   3.7.2  ERROR   - Layer (ETCH): %-13s Color: %-3d %L %L" lay_name t_nr obj_rgb
				layer
			    ) 
			    (trl_altium2pcb_global->exeption)
			))
		) 
		(param_str = sprintf(nil "paramDesign:VIA CLASS/paramLayer:%s" lay_name)) 
		(lay_param = (axlGetParam param_str)) 
		if(lay_param then 
		    (lay_param->color = t_nr) 
		    (axlSetParam lay_param) 
		    when(nth(8 
			    (trl_altium2pcb_global->settings)
			) 
			(trl_altium2pcb_global->exeption = cons(sprintf(nil "   3.7.3  INFO    - VIA  (ETCH): %-13s Color: %-3d %L %L" lay_name t_nr obj_rgb
				    layer
				) 
				(trl_altium2pcb_global->exeption)
			    ))
		    )
		    else 
		    (trl_altium2pcb_global->exeption = cons(sprintf(nil "   3.5.3  ERROR   - VIA  (ETCH): %-13s Color: %-3d %L %L" lay_name t_nr obj_rgb
				layer
			    ) 
			    (trl_altium2pcb_global->exeption)
			))
		) 
		(param_str = sprintf(nil "paramDesign:PIN/paramLayer:%s" lay_name))
		(lay_param = (axlGetParam param_str)) 
		if(lay_param then 
		    (lay_param->color = t_nr) 
		    (axlSetParam lay_param) 
		    when(nth(8 
			    (trl_altium2pcb_global->settings)
			) 
			(trl_altium2pcb_global->exeption = cons(sprintf(nil "   3.7.4  INFO    - PIN  (ETCH): %-13s Color: %-3d %L %L" lay_name t_nr obj_rgb
				    layer
				) 
				(trl_altium2pcb_global->exeption)
			    ))
		    )
		    else 
		    (trl_altium2pcb_global->exeption = cons(sprintf(nil "   3.5.4  ERROR   - PIN  (ETCH): %-13s Color: %-3d %L %L" lay_name t_nr obj_rgb
				layer
			    ) 
			    (trl_altium2pcb_global->exeption)
			))
		) 
		(param_str = sprintf(nil "paramDesign:drc error class/paramLayer:%s" lay_name)) 
		(lay_param = (axlGetParam param_str)) 
		if(lay_param then 
		    (lay_param->color = t_nr) 
		    (axlSetParam lay_param) 
		    when(nth(8 
			    (trl_altium2pcb_global->settings)
			) 
			(trl_altium2pcb_global->exeption = cons(sprintf(nil "   3.5.5  INFO    - DRC : %-13s Color: %-3d %L %L" lay_name t_nr obj_rgb
				    layer
				) 
				(trl_altium2pcb_global->exeption)
			    ))
		    )
		    else 
		    (trl_altium2pcb_global->exeption = cons(sprintf(nil "   3.5.5  ERROR   - DRC  (ETCH): %-13s Color: %-3d %L %L" lay_name t_nr obj_rgb
				layer
			    ) 
			    (trl_altium2pcb_global->exeption)
			))
		)
	    )
	) 
	foreach(obj obj_list 
	    (col_nr = car(obj)) 
	    (obj_rgb = cadr(obj)) 
	    (index = 1)
	    foreach(rgb ll_rgb 
		when((obj_rgb == rgb) 
		    (t_nr = index)
		) 
		index++
	    ) 
	    case(col_nr 
		(200 
		    (lay_param = (axlLayerGet "Drawing Format/Sheet_Area")) 
		    (lay_param->color = t_nr) 
		    (axlLayerSet lay_param) 
		    when(nth(8 
			    (trl_altium2pcb_global->settings)
			) 
			(trl_altium2pcb_global->exeption = cons(sprintf(nil "   3.5.2  INFO    - Layer (DRWG): %-13s Color: %-3d %L" "Sheet_Area" t_nr obj_rgb) 
				(trl_altium2pcb_global->exeption)
			    ))
		    )
		) 
		(201 
		    (lay_param = (axlLayerGet "Drawing Format/Sheet_Line")) 
		    (lay_param->color = t_nr) 
		    (axlLayerSet lay_param) 
		    when(nth(8 
			    (trl_altium2pcb_global->settings)
			) 
			(trl_altium2pcb_global->exeption = cons(sprintf(nil "   3.5.2  INFO    - Layer (DRWG): %-13s Color: %-3d %L" "Sheet_Line" t_nr obj_rgb) 
				(trl_altium2pcb_global->exeption)
			    ))
		    )
		) 
		(202 
		    (lay_param = (axlLayerGet "Drawing Format/Sheet_Text")) 
		    (lay_param->color = t_nr) 
		    (axlLayerSet lay_param) 
		    when(nth(8 
			    (trl_altium2pcb_global->settings)
			) 
			(trl_altium2pcb_global->exeption = cons(sprintf(nil "   3.5.2  INFO    - Layer (DRWG): %-13s Color: %-3d %L" "Sheet_Text" t_nr obj_rgb) 
				(trl_altium2pcb_global->exeption)
			    ))
		    )
		) 
		(33 
		    (lay_param = (axlLayerGet "PACKAGE GEOMETRY/SILKSCREEN_TOP")) 
		    (lay_param->color = t_nr) 
		    (axlLayerSet lay_param) 
		    (lay_param = (axlLayerGet "BOARD GEOMETRY/SILKSCREEN_TOP"))
		    (lay_param->color = t_nr) 
		    (axlLayerSet lay_param) 
		    (lay_param = (axlLayerGet "REF DES/SILKSCREEN_TOP")) 
		    (lay_param->color = t_nr) 
		    (axlLayerSet lay_param)
		    when(nth(8 
			    (trl_altium2pcb_global->settings)
			) 
			(trl_altium2pcb_global->exeption = cons(sprintf(nil "   3.5.2  INFO    - Layer (SILK): %-13s Color: %-3d %L" "TOP" t_nr obj_rgb) 
				(trl_altium2pcb_global->exeption)
			    ))
		    )
		)
		(34 
		    (lay_param = (axlLayerGet "PACKAGE GEOMETRY/SILKSCREEN_BOTTOM")) 
		    (lay_param->color = t_nr) 
		    (axlLayerSet lay_param) 
		    (lay_param = (axlLayerGet "BOARD GEOMETRY/SILKSCREEN_BOTTOM"))
		    (lay_param->color = t_nr) 
		    (axlLayerSet lay_param) 
		    (lay_param = (axlLayerGet "REF DES/SILKSCREEN_BOTTOM")) 
		    (lay_param->color = t_nr) 
		    (axlLayerSet lay_param)
		    when(nth(8 
			    (trl_altium2pcb_global->settings)
			) 
			(trl_altium2pcb_global->exeption = cons(sprintf(nil "   3.5.2  INFO    - Layer (SILK): %-13s Color: %-3d %L" "BOTTOM" t_nr obj_rgb) 
				(trl_altium2pcb_global->exeption)
			    ))
		    )
		) 
		(35 
		    (lay_param = (axlLayerGet "PACKAGE GEOMETRY/PASTEMASK_TOP")) 
		    (lay_param->color = t_nr) 
		    (axlLayerSet lay_param) 
		    (lay_param = (axlGetParam "paramDesign:VIA CLASS/paramLayer:PASTEMASK_TOP"))
		    (lay_param->color = t_nr) 
		    (axlSetParam lay_param) 
		    (lay_param = (axlGetParam "paramDesign:PIN/paramLayer:PASTEMASK_TOP")) 
		    (lay_param->color = t_nr) 
		    (axlSetParam lay_param)
		    when(nth(8 
			    (trl_altium2pcb_global->settings)
			) 
			(trl_altium2pcb_global->exeption = cons(sprintf(nil "   3.5.2  INFO    - Layer (PAST): %-13s Color: %-3d %L" "TOP" t_nr obj_rgb) 
				(trl_altium2pcb_global->exeption)
			    ))
		    )
		) 
		(36 
		    (lay_param = (axlLayerGet "PACKAGE GEOMETRY/PASTEMASK_BOTTOM")) 
		    (lay_param->color = t_nr) 
		    (axlLayerSet lay_param) 
		    (lay_param = (axlGetParam "paramDesign:VIA CLASS/paramLayer:PASTEMASK_BOTTOM"))
		    (lay_param->color = t_nr) 
		    (axlSetParam lay_param) 
		    (lay_param = (axlGetParam "paramDesign:PIN/paramLayer:PASTEMASK_BOTTOM")) 
		    (lay_param->color = t_nr) 
		    (axlSetParam lay_param)
		    when(nth(8 
			    (trl_altium2pcb_global->settings)
			) 
			(trl_altium2pcb_global->exeption = cons(sprintf(nil "   3.5.2  INFO    - Layer (PAST): %-13s Color: %-3d %L" "BOTTOM" t_nr obj_rgb) 
				(trl_altium2pcb_global->exeption)
			    ))
		    )
		) 
		(37 
		    (lay_param = (axlLayerGet "PACKAGE GEOMETRY/SOLDERMASK_TOP")) 
		    (lay_param->color = t_nr) 
		    (axlLayerSet lay_param) 
		    (lay_param = (axlLayerGet "BOARD GEOMETRY/SOLDERMASK_TOP"))
		    (lay_param->color = t_nr) 
		    (axlLayerSet lay_param) 
		    (lay_param = (axlGetParam "paramDesign:VIA CLASS/paramLayer:SOLDERMASK_TOP")) 
		    (lay_param->color = t_nr) 
		    (axlSetParam lay_param)
		    (lay_param = (axlGetParam "paramDesign:PIN/paramLayer:SOLDERMASK_TOP")) 
		    (lay_param->color = t_nr) 
		    (axlSetParam lay_param) 
		    when(nth(8 
			    (trl_altium2pcb_global->settings)
			) 
			(trl_altium2pcb_global->exeption = cons(sprintf(nil "   3.5.2  INFO    - Layer (SOLD): %-13s Color: %-3d %L" "TOP" t_nr obj_rgb) 
				(trl_altium2pcb_global->exeption)
			    ))
		    )
		) 
		(38 
		    (lay_param = (axlLayerGet "PACKAGE GEOMETRY/SOLDERMASK_BOTTOM")) 
		    (lay_param->color = t_nr) 
		    (axlLayerSet lay_param) 
		    (lay_param = (axlLayerGet "BOARD GEOMETRY/SOLDERMASK_BOTTOM"))
		    (lay_param->color = t_nr) 
		    (axlLayerSet lay_param) 
		    (lay_param = (axlGetParam "paramDesign:VIA CLASS/paramLayer:SOLDERMASK_BOTTOM")) 
		    (lay_param->color = t_nr) 
		    (axlSetParam lay_param)
		    (lay_param = (axlGetParam "paramDesign:PIN/paramLayer:SOLDERMASK_BOTTOM")) 
		    (lay_param->color = t_nr) 
		    (axlSetParam lay_param) 
		    when(nth(8 
			    (trl_altium2pcb_global->settings)
			) 
			(trl_altium2pcb_global->exeption = cons(sprintf(nil "   3.5.2  INFO    - Layer (SOLD): %-13s Color: %-3d %L" "BOTTOM" t_nr obj_rgb) 
				(trl_altium2pcb_global->exeption)
			    ))
		    )
		)
		(t)
	    )
	) 
	when((trl_altium2pcb_global->LayerMech) 
	    foreach(mech 
		(trl_altium2pcb_global->LayerMech) 
		if((length(mech) == 4) then 
		    (lay_name = cadr(mech)) 
		    (index = 1) 
		    foreach(rgb ll_rgb 
			when((obj_rgb == rgb) 
			    (t_nr = index)
			) 
			index++
		    )
		    (lay_param = sprintf(nil "BOARD GEOMETRY/%s" lay_name)) 
		    (lay_param = (axlLayerGet lay_param)) 
		    (lay_param->color = t_nr) 
		    (axlLayerSet lay_param) 
		    when(nth(8 
			    (trl_altium2pcb_global->settings)
			) 
			(trl_altium2pcb_global->exeption = cons(sprintf(nil "   3.5.2  INFO    - Layer (MECH): %-13s Color: %-3d %L %L" lay_name t_nr obj_rgb
				    mech
				) 
				(trl_altium2pcb_global->exeption)
			    ))
		    )
		    else 
		    (col_nr = car(mech)) 
		    (lay_name = cadr(mech)) 
		    foreach(obj obj_list 
			when((car(obj) == col_nr) 
			    (obj_rgb = cadr(obj))
			)
		    ) 
		    (index = 1)
		    foreach(rgb ll_rgb 
			when((obj_rgb == rgb) 
			    (t_nr = index)
			) 
			index++
		    ) 
		    (lay_param = sprintf(nil "BOARD GEOMETRY/%s" lay_name)) 
		    (lay_param = (axlLayerGet lay_param)) 
		    (lay_param->color = t_nr) 
		    (axlLayerSet lay_param)
		    when(nth(8 
			    (trl_altium2pcb_global->settings)
			) 
			(trl_altium2pcb_global->exeption = cons(sprintf(nil "   3.5.2  INFO    - Layer (MECH): %-13s Color: %-3d %L %L" lay_name t_nr obj_rgb
				    mech
				) 
				(trl_altium2pcb_global->exeption)
			    ))
		    )
		)
	    )
	) 
	(axlVisibleUpdate t)
    )
)
procedure(TRL_ALTIUM2PCB_GetLayerStack(recs) 
    let((index result l_name l_prev l_next
	    l_mech l_copt l_diet l_diec l_dieh
	    l_diem l_layers s_name s_prev s_next
	    s_mech s_copt s_diet s_diec s_dieh
	    s_diem m_layers l_id s_id sys_name
	) 
	(l_layers = list()) 
	(m_layers = list()) 
	foreach(rec recs 
	    for(i 0 15 
		(l_name = stringToSymbol(sprintf(nil "LAYERV7_%dNAME" i))) 
		(l_mech = stringToSymbol(sprintf(nil "LAYERV7_%dMECHENABLED" i)))
		(l_id = stringToSymbol(sprintf(nil "LAYERV7_%dLAYERID" i))) 
		(s_name = get(rec l_name)) 
		(s_mech = get(rec l_mech)) 
		(s_id = get(rec l_id)) 
		when((s_mech == "TRUE") 
		    (sys_name = sprintf(nil "MECHANICAL%d" 
			    (i + 17)
			)) 
		    (s_id = TRL_ALTIUM2PCB_Util_Convert_Long2RGB(atoi(s_id))) 
		    (m_layers = cons(list(sprintf(nil "V7_%d" i) sys_name s_name s_id) m_layers))
		)
		i++
	    )
	) 
	(index = 1)
	(result = t) 
	foreach(rec recs 
	    while(result 
		(l_name = stringToSymbol(sprintf(nil "LAYER%dNAME" index))) 
		(l_prev = stringToSymbol(sprintf(nil "LAYER%dPREV" index))) 
		(l_next = stringToSymbol(sprintf(nil "LAYER%dNEXT" index))) 
		(l_mech = stringToSymbol(sprintf(nil "LAYER%dMECHENABLED" index)))
		(l_copt = stringToSymbol(sprintf(nil "LAYER%dCOPTHICK" index))) 
		(l_diet = stringToSymbol(sprintf(nil "LAYER%dDIELTYPE" index))) 
		(l_diec = stringToSymbol(sprintf(nil "LAYER%dDIELCONST" index))) 
		(l_dieh = stringToSymbol(sprintf(nil "LAYER%dDIELHEIGHT" index))) 
		(l_diem = stringToSymbol(sprintf(nil "LAYER%dDIELMATERIAL" index)))
		(s_name = get(rec l_name)) 
		(s_prev = get(rec l_prev)) 
		(s_next = get(rec l_next)) 
		(s_mech = get(rec l_mech)) 
		(s_copt = get(rec l_copt))
		(s_diet = get(rec l_diet)) 
		(s_diec = get(rec l_diec)) 
		(s_dieh = get(rec l_dieh)) 
		(s_diem = get(rec l_diem)) 
		when(((index >= 57) && (index <= 72) && (s_mech == "TRUE")) 
		    (sys_name = sprintf(nil "MECHANICAL%d" 
			    (index - 56)
			)) 
		    (m_layers = cons(list(index sys_name s_name) m_layers))
		)
		if((s_prev && s_next) then 
		    (s_prev = atoi(s_prev)) 
		    (s_next = atoi(s_next)) 
		    when(((s_prev > 0) || (s_next > 0)) 
			(l_layers = cons(list(index s_name s_prev s_next s_mech
				    s_copt s_diet s_diec s_dieh s_diem
				) l_layers
			    ))
		    )
		    else 
		    (result = nil)
		) 
		index++
	    )
	) 
	(trl_altium2pcb_global->LayerMech = m_layers) 
	(trl_altium2pcb_global->LayerStack = l_layers)
    )
)
procedure(TRL_ALTIUM2PCB_GetPolyPath(rec) 
    let((index result vx vy cx
	    cy sa ea r l_points
	) 
	(l_points = list()) 
	(index = 0) 
	(result = t) 
	while(result 
	    (vx = stringToSymbol(sprintf(nil "VX%d" index))) 
	    (vy = stringToSymbol(sprintf(nil "VY%d" index))) 
	    (cx = stringToSymbol(sprintf(nil "CX%d" index))) 
	    (cy = stringToSymbol(sprintf(nil "CY%d" index)))
	    (sa = stringToSymbol(sprintf(nil "SA%d" index))) 
	    (ea = stringToSymbol(sprintf(nil "EA%d" index))) 
	    (r = stringToSymbol(sprintf(nil "R%d" index))) 
	    (vx = get(rec vx)) 
	    (vy = get(rec vy))
	    (cx = get(rec cx)) 
	    (cy = get(rec cy)) 
	    (sa = get(rec sa)) 
	    (ea = get(rec ea)) 
	    (r = get(rec r))
	    if((vx && vy) then 
		(vx = TRL_ALTIUM2PCB_Util_DesignUnits(vx)) 
		(vy = TRL_ALTIUM2PCB_Util_DesignUnits(vy)) 
		(cx = TRL_ALTIUM2PCB_Util_DesignUnits(cx))
		(cy = TRL_ALTIUM2PCB_Util_DesignUnits(cy)) 
		(sa = atof(sa)) 
		(ea = atof(ea)) 
		(r = TRL_ALTIUM2PCB_Util_DesignUnits(r)) 
		(l_points = cons(list(vx vy cx cy sa
			    ea r
			) l_points
		    ))
		else 
		(result = nil)
	    ) 
	    index++
	)
	when(get(rec 
		'MAINCONTOURVERTEXCOUNT
	    ) 
	    when((atoi(get(rec 
			    'MAINCONTOURVERTEXCOUNT
			)
		    ) == length(l_points)) 
		(l_points = cons(car(last(l_points)) l_points))
	    )
	) l_points
    )
)
procedure(TRL_ALTIUM2PCB_Help_file() 
    let((outp help_file) 
	(help_file = "./altium2pcb_help.txt") 
	(outp = outfile(help_file)) 
	fprintf(outp "1. Altium Settings: Components with same footprint name will usually reference to the same (unique)\n") 
	fprintf(outp "   footprint library element. Altium however, although the same footprint name specified, different\n")
	fprintf(outp "   footprint elements will be used. In this case do not use [Generic Footprint!]\n\n") 
	fprintf(outp "2. Altium Files: For translation purposes the translator expects altium board file in ASCII representation only\n") 
	fprintf(outp "   with the .PcbDoc extention. Due to the fact that board logic will also be considered a folder\n") 
	fprintf(outp "   to store device files is needed. Usually this folder is controlled by devpath and will be automatically set to devices.\n\n") 
	fprintf(outp "3. Altium Flow: For debugging purposes user will switch to detailed flow.\n\n")
	fprintf(outp "4. Report: Generates detailed log file which can also be used for debugging.\n\n") 
	close(outp) 
	if(isFile(help_file) then 
	    (axlUIViewFileCreate help_file "Altium Translator Help File" nil) else 
	    (axlUIConfirm "Unable to Open Help File, Check Permissions!")
	)
    )
)
procedure(TRL_ALTIUM2PCB_Init() 
    unless(boundp('trl_altium2pcb_global) 
	iliDefstruct('defstruct(trl_altium2pcb_global_struct color index BoardObjects formid
		    new_txt_block_nr PcbRawList LayerStack LayerMech PartsList
		    exeption settings txtBlock UtilsList NetsList
		    PadStacklist intermediate devpath
		)
	) 
	defvar(trl_altium2pcb_global nil)
    ) 
    if(!trl_altium2pcb_global then 
	(trl_altium2pcb_global = (make_trl_altium2pcb_global_struct ?formid nil ?exeption nil
		?PadStacklist 
		list() ?settings 
		list() ?devpath
		axlGetVariable("devpath")
	    )) else 
	(trl_altium2pcb_global->formid = nil)
	(trl_altium2pcb_global->index = 1) 
	(trl_altium2pcb_global->new_txt_block_nr = nil) 
	(trl_altium2pcb_global->BoardObjects = list()) 
	(trl_altium2pcb_global->exeption = list()) 
	(trl_altium2pcb_global->settings = list())
	(trl_altium2pcb_global->txtBlock = list()) 
	(trl_altium2pcb_global->LayerStack = list()) 
	(trl_altium2pcb_global->LayerMech = list()) 
	(trl_altium2pcb_global->PcbRawList = list()) 
	(trl_altium2pcb_global->PartsList = list())
	(trl_altium2pcb_global->UtilsList = list()) 
	(trl_altium2pcb_global->NetsList = list()) 
	(trl_altium2pcb_global->PadStacklist = list()) 
	(trl_altium2pcb_global->GUI = list()) 
	(trl_altium2pcb_global->intermediate = list())
	(trl_altium2pcb_global->devpath = axlGetVariable("devpath"))
    )
)
procedure(TRL_ALTIUM2PCB_LoadFile2DB() 
    let((inp BoardRecords ClassRecords NetRecords ComponentRecords
	    PolygonRecords DXPRuleRecords RuleRecords ArcRecords PadRecords
	    ViaRecords TrackRecords TextRecords RegionRecords FillRecords
	    CompBodyRecords MiscRecords text_cmp text_net text_misc
	    pad_cmp pad_misc track_cmp track_net track_misc
	    reg_cmp reg_net reg_poly reg_misc input_string
	    via_cmp via_net via_misc fill_cmp fill_net
	    fill_misc
	) 
	(input_string = "./intermediate") 
	(inp = infile(strcat(input_string "/BoardRecords.txt"))) 
	(BoardRecords = lineread(inp)) 
	close(inp)
	(inp = infile(strcat(input_string "/ClassRecords.txt"))) 
	(ClassRecords = lineread(inp)) 
	close(inp) 
	(inp = infile(strcat(input_string "/NetRecords.txt"))) 
	(NetRecords = lineread(inp))
	close(inp) 
	(inp = infile(strcat(input_string "/ComponentRecords.txt"))) 
	(ComponentRecords = lineread(inp)) 
	close(inp) 
	(inp = infile(strcat(input_string "/PolygonRecords.txt")))
	(PolygonRecords = lineread(inp)) 
	close(inp) 
	(inp = infile(strcat(input_string "/DXPRuleRecords.txt"))) 
	(DXPRuleRecords = lineread(inp)) 
	close(inp)
	(inp = infile(strcat(input_string "/RuleRecords.txt"))) 
	(RuleRecords = lineread(inp)) 
	close(inp) 
	(inp = infile(strcat(input_string "/ArcRecords.txt"))) 
	(ArcRecords = lineread(inp))
	close(inp) 
	(inp = infile(strcat(input_string "/PadRecords_cmp.txt"))) 
	(pad_cmp = lineread(inp)) 
	close(inp) 
	(inp = infile(strcat(input_string "/PadRecords_misc.txt")))
	(pad_misc = lineread(inp)) 
	close(inp) 
	(inp = infile(strcat(input_string "/ViaRecords_cmp.txt"))) 
	(via_cmp = lineread(inp)) 
	close(inp)
	(inp = infile(strcat(input_string "/ViaRecords_net.txt"))) 
	(via_net = lineread(inp)) 
	close(inp) 
	(inp = infile(strcat(input_string "/ViaRecords_misc.txt"))) 
	(via_misc = lineread(inp))
	close(inp) 
	(inp = infile(strcat(input_string "/TrackRecords_cmp.txt"))) 
	(track_cmp = lineread(inp)) 
	close(inp) 
	(inp = infile(strcat(input_string "/TrackRecords_net.txt")))
	(track_net = lineread(inp)) 
	close(inp) 
	(inp = infile(strcat(input_string "/TrackRecords_misc.txt"))) 
	(track_misc = lineread(inp)) 
	close(inp)
	(inp = infile(strcat(input_string "/TextRecords_cmp.txt"))) 
	(text_cmp = lineread(inp)) 
	close(inp) 
	(inp = infile(strcat(input_string "/TextRecords_net.txt"))) 
	(text_net = lineread(inp))
	close(inp) 
	(inp = infile(strcat(input_string "/TextRecords_misc.txt"))) 
	(text_misc = lineread(inp)) 
	close(inp) 
	(inp = infile(strcat(input_string "/RegionRecords_cmp.txt")))
	(reg_cmp = lineread(inp)) 
	close(inp) 
	(inp = infile(strcat(input_string "/RegionRecords_net.txt"))) 
	(reg_net = lineread(inp)) 
	close(inp)
	(inp = infile(strcat(input_string "/RegionRecords_poly.txt"))) 
	(reg_poly = lineread(inp)) 
	close(inp) 
	(inp = infile(strcat(input_string "/RegionRecords_misc.txt"))) 
	(reg_misc = lineread(inp))
	close(inp) 
	(inp = infile(strcat(input_string "/FillRecords_cmp.txt"))) 
	(fill_cmp = lineread(inp)) 
	close(inp) 
	(inp = infile(strcat(input_string "/FillRecords_net.txt")))
	(fill_net = lineread(inp)) 
	close(inp) 
	(inp = infile(strcat(input_string "/FillRecords_misc.txt"))) 
	(fill_misc = lineread(inp)) 
	close(inp)
	(inp = infile(strcat(input_string "/CompBodyRecords.txt"))) 
	(CompBodyRecords = lineread(inp)) 
	close(inp) 
	(inp = infile(strcat(input_string "/MiscRecords.txt"))) 
	(MiscRecords = lineread(inp))
	close(inp) 
	(PadRecords = list(pad_cmp pad_misc)) 
	(TrackRecords = list(track_cmp track_net track_misc)) 
	(TextRecords = list(text_cmp text_net text_misc)) 
	(RegionRecords = list(reg_cmp reg_net reg_poly reg_misc))
	(FillRecords = list(fill_cmp fill_net fill_misc)) 
	(ViaRecords = list(via_cmp via_net via_misc)) 
	(trl_altium2pcb_global->PcbRawList = list(BoardRecords ClassRecords NetRecords ComponentRecords PolygonRecords
		DXPRuleRecords RuleRecords ArcRecords PadRecords ViaRecords
		TrackRecords TextRecords RegionRecords FillRecords CompBodyRecords
		MiscRecords
	    )) 
	println("--END--")
    )
)
procedure(TRL_ALTIUM2PCB_LoadIntermediateDeviceFiles() 
    let((inp BoardRecords ClassRecords NetRecords ComponentRecords
	    PolygonRecords DXPRuleRecords RuleRecords ArcRecords PadRecords
	    ViaRecords TrackRecords TextRecords RegionRecords FillRecords
	    CompBodyRecords MiscRecords text_cmp text_net text_misc
	    pad_cmp pad_misc track_cmp track_net track_misc
	    reg_cmp reg_net reg_poly reg_misc input_string
	    fill_cmp fill_net fill_misc via_cmp via_net
	    via_misc
	) 
	(input_string = (axlFormGetField 
		(trl_altium2pcb_global->formid) "intermediate_l"
	    )) 
	(inp = infile(strcat(input_string "/ComponentRecords.txt"))) 
	(ComponentRecords = lineread(inp)) 
	close(inp)
	(inp = infile(strcat(input_string "/NetRecords.txt"))) 
	(NetRecords = lineread(inp)) 
	close(inp) 
	(inp = infile(strcat(input_string "/PadRecords_cmp.txt"))) 
	(pad_cmp = lineread(inp))
	close(inp) 
	(PadRecords = list(pad_cmp pad_misc)) 
	(TrackRecords = list(track_cmp track_net track_misc)) 
	(TextRecords = list(text_cmp text_net text_misc)) 
	(RegionRecords = list(reg_cmp reg_net reg_poly reg_misc))
	(FillRecords = list(fill_cmp fill_net fill_misc)) 
	(ViaRecords = list(via_cmp via_net via_misc)) 
	(trl_altium2pcb_global->PcbRawList = list(BoardRecords ClassRecords NetRecords ComponentRecords PolygonRecords
		DXPRuleRecords RuleRecords ArcRecords PadRecords ViaRecords
		TrackRecords TextRecords RegionRecords FillRecords CompBodyRecords
		MiscRecords
	    )) 
	println("--END--")
    )
)
procedure(TRL_ALTIUM2PCB_LoadIntermediateFootprintFiles() 
    let((inp BoardRecords ClassRecords NetRecords ComponentRecords
	    PolygonRecords DXPRuleRecords RuleRecords ArcRecords PadRecords
	    ViaRecords TrackRecords TextRecords RegionRecords FillRecords
	    CompBodyRecords MiscRecords text_cmp text_net text_misc
	    pad_cmp pad_misc track_cmp track_net track_misc
	    reg_cmp reg_net reg_poly reg_misc input_string
	    fill_cmp fill_net fill_misc via_cmp via_net
	    via_misc
	) 
	(input_string = (axlFormGetField 
		(trl_altium2pcb_global->formid) "intermediate_l"
	    )) 
	(inp = infile(strcat(input_string "/BoardRecords.txt"))) 
	(BoardRecords = lineread(inp)) 
	close(inp)
	(inp = infile(strcat(input_string "/ComponentRecords.txt"))) 
	(ComponentRecords = lineread(inp)) 
	close(inp) 
	(inp = infile(strcat(input_string "/PolygonRecords.txt"))) 
	(PolygonRecords = lineread(inp))
	close(inp) 
	(inp = infile(strcat(input_string "/ArcRecords.txt"))) 
	(ArcRecords = lineread(inp)) 
	close(inp) 
	(inp = infile(strcat(input_string "/ViaRecords_cmp.txt")))
	(via_cmp = lineread(inp)) 
	close(inp) 
	(inp = infile(strcat(input_string "/PadRecords_cmp.txt"))) 
	(pad_cmp = lineread(inp)) 
	close(inp)
	(inp = infile(strcat(input_string "/TrackRecords_cmp.txt"))) 
	(track_cmp = lineread(inp)) 
	close(inp) 
	(inp = infile(strcat(input_string "/TextRecords_cmp.txt"))) 
	(text_cmp = lineread(inp))
	close(inp) 
	(inp = infile(strcat(input_string "/RegionRecords_cmp.txt"))) 
	(reg_cmp = lineread(inp)) 
	close(inp) 
	(inp = infile(strcat(input_string "/FillRecords_cmp.txt")))
	(fill_cmp = lineread(inp)) 
	close(inp) 
	(inp = infile(strcat(input_string "/CompBodyRecords.txt"))) 
	(CompBodyRecords = lineread(inp)) 
	close(inp)
	(inp = infile(strcat(input_string "/MiscRecords.txt"))) 
	(MiscRecords = lineread(inp)) 
	close(inp) 
	(PadRecords = list(pad_cmp pad_misc)) 
	(TrackRecords = list(track_cmp track_net track_misc))
	(TextRecords = list(text_cmp text_net text_misc)) 
	(RegionRecords = list(reg_cmp reg_net reg_poly reg_misc)) 
	(FillRecords = list(fill_cmp fill_net fill_misc)) 
	(ViaRecords = list(via_cmp via_net via_misc)) 
	(trl_altium2pcb_global->PcbRawList = list(BoardRecords ClassRecords NetRecords ComponentRecords PolygonRecords
		DXPRuleRecords RuleRecords ArcRecords PadRecords ViaRecords
		TrackRecords TextRecords RegionRecords FillRecords CompBodyRecords
		MiscRecords
	    ))
	println("--END--")
    )
)
procedure(TRL_ALTIUM2PCB_LoadIntermediateNetLogicFiles() 
    let((inp BoardRecords ClassRecords NetRecords ComponentRecords
	    PolygonRecords DXPRuleRecords RuleRecords ArcRecords PadRecords
	    ViaRecords TrackRecords TextRecords RegionRecords FillRecords
	    CompBodyRecords MiscRecords text_cmp text_net text_misc
	    pad_cmp pad_misc track_cmp track_net track_misc
	    reg_cmp reg_net reg_poly reg_misc input_string
	    fill_cmp fill_net fill_misc via_cmp via_net
	    via_misc
	) 
	(input_string = (axlFormGetField 
		(trl_altium2pcb_global->formid) "intermediate_l"
	    )) 
	(inp = infile(strcat(input_string "/ComponentRecords.txt"))) 
	(ComponentRecords = lineread(inp)) 
	close(inp)
	(inp = infile(strcat(input_string "/PadRecords_cmp.txt"))) 
	(pad_cmp = lineread(inp)) 
	close(inp) 
	(inp = infile(strcat(input_string "/NetRecords.txt"))) 
	(NetRecords = lineread(inp))
	close(inp) 
	(PadRecords = list(pad_cmp pad_misc)) 
	(TrackRecords = list(track_cmp track_net track_misc)) 
	(TextRecords = list(text_cmp text_net text_misc)) 
	(RegionRecords = list(reg_cmp reg_net reg_poly reg_misc))
	(FillRecords = list(fill_cmp fill_net fill_misc)) 
	(ViaRecords = list(via_cmp via_net via_misc)) 
	(trl_altium2pcb_global->PcbRawList = list(BoardRecords ClassRecords NetRecords ComponentRecords PolygonRecords
		DXPRuleRecords RuleRecords ArcRecords PadRecords ViaRecords
		TrackRecords TextRecords RegionRecords FillRecords CompBodyRecords
		MiscRecords
	    )) 
	println("--END--")
    )
)
procedure(TRL_ALTIUM2PCB_LoadIntermediate_BoardSetUpFiles() 
    let((inp BoardRecords ClassRecords NetRecords ComponentRecords
	    PolygonRecords DXPRuleRecords RuleRecords ArcRecords PadRecords
	    ViaRecords TrackRecords TextRecords RegionRecords FillRecords
	    CompBodyRecords MiscRecords text_cmp text_net text_misc
	    pad_cmp pad_misc track_cmp track_net track_misc
	    reg_cmp reg_net reg_poly reg_misc input_string
	    fill_cmp fill_net fill_misc via_cmp via_net
	    via_misc
	) 
	(input_string = (axlFormGetField 
		(trl_altium2pcb_global->formid) "intermediate_l"
	    )) 
	(inp = infile(strcat(input_string "/BoardRecords.txt"))) 
	(BoardRecords = lineread(inp)) 
	close(inp)
	(inp = infile(strcat(input_string "/RuleRecords.txt"))) 
	(RuleRecords = lineread(inp)) 
	close(inp) 
	(inp = infile(strcat(input_string "/TextRecords_misc.txt"))) 
	(text_misc = lineread(inp))
	close(inp) 
	(inp = infile(strcat(input_string "/PadRecords_misc.txt"))) 
	(pad_misc = lineread(inp)) 
	close(inp) 
	(inp = infile(strcat(input_string "/TrackRecords_misc.txt")))
	(track_misc = lineread(inp)) 
	close(inp) 
	(inp = infile(strcat(input_string "/PolygonRecords.txt"))) 
	(PolygonRecords = lineread(inp)) 
	close(inp)
	(inp = infile(strcat(input_string "/ArcRecords.txt"))) 
	(ArcRecords = lineread(inp)) 
	close(inp) 
	(inp = infile(strcat(input_string "/FillRecords_misc.txt"))) 
	(fill_misc = lineread(inp))
	close(inp) 
	(inp = infile(strcat(input_string "/RegionRecords_misc.txt"))) 
	(reg_misc = lineread(inp)) 
	close(inp) 
	(inp = infile(strcat(input_string "/NetRecords.txt")))
	(NetRecords = lineread(inp)) 
	close(inp) 
	(PadRecords = list(pad_cmp pad_misc)) 
	(TrackRecords = list(track_cmp track_net track_misc)) 
	(TextRecords = list(text_cmp text_net text_misc))
	(RegionRecords = list(reg_cmp reg_net reg_poly reg_misc)) 
	(FillRecords = list(fill_cmp fill_net fill_misc)) 
	(ViaRecords = list(via_cmp via_net via_misc)) 
	(trl_altium2pcb_global->PcbRawList = list(BoardRecords ClassRecords NetRecords ComponentRecords PolygonRecords
		DXPRuleRecords RuleRecords ArcRecords PadRecords ViaRecords
		TrackRecords TextRecords RegionRecords FillRecords CompBodyRecords
		MiscRecords
	    )) 
	println("--END--")
    )
)
procedure(TRL_ALTIUM2PCB_LoadIntermediate_Init_Files() 
    let((input_string inp) 
	(input_string = (axlFormGetField 
		(trl_altium2pcb_global->formid) "intermediate_l"
	    )) 
	(input_string = strcat(input_string "/Intermediate.txt")) 
	(inp = infile(input_string)) 
	(trl_altium2pcb_global->intermediate = lineread(inp))
	close(inp) 
	if(car((trl_altium2pcb_global->intermediate)) then 
	    (trl_altium2pcb_global->exeption = cons(sprintf(nil "   X.3.01 INFO    - Intermediate Directory set: %L" 
			(axlFormGetField 
			    (trl_altium2pcb_global->formid) "intermediate_l"
			)
		    ) 
		    (trl_altium2pcb_global->exeption)
		)) else 
	    (trl_altium2pcb_global->exeption = cons(sprintf(nil "   X.3.01 ERROR   - Intermediate Directory NOT set: %L" 
			(axlFormGetField 
			    (trl_altium2pcb_global->formid) "intermediate_l"
			)
		    ) 
		    (trl_altium2pcb_global->exeption)
		))
	)
    )
)
procedure(TRL_ALTIUM2PCB_LoadIntermediate_Placement_Files() 
    let((inp BoardRecords ClassRecords NetRecords ComponentRecords
	    PolygonRecords DXPRuleRecords RuleRecords ArcRecords PadRecords
	    ViaRecords TrackRecords TextRecords RegionRecords FillRecords
	    CompBodyRecords MiscRecords text_cmp text_net text_misc
	    pad_cmp pad_misc track_cmp track_net track_misc
	    reg_cmp reg_net reg_poly reg_misc input_string
	    fill_cmp fill_net fill_misc via_cmp via_net
	    via_misc
	) 
	(input_string = (axlFormGetField 
		(trl_altium2pcb_global->formid) "intermediate_l"
	    )) 
	(inp = infile(strcat(input_string "/ComponentRecords.txt"))) 
	(ComponentRecords = lineread(inp)) 
	close(inp)
	(inp = infile(strcat(input_string "/TextRecords_cmp.txt"))) 
	(text_cmp = lineread(inp)) 
	close(inp) 
	(PadRecords = list(pad_cmp pad_misc)) 
	(TrackRecords = list(track_cmp track_net track_misc))
	(TextRecords = list(text_cmp text_net text_misc)) 
	(RegionRecords = list(reg_cmp reg_net reg_poly reg_misc)) 
	(FillRecords = list(fill_cmp fill_net fill_misc)) 
	(ViaRecords = list(via_cmp via_net via_misc)) 
	(trl_altium2pcb_global->PcbRawList = list(BoardRecords ClassRecords NetRecords ComponentRecords PolygonRecords
		DXPRuleRecords RuleRecords ArcRecords PadRecords ViaRecords
		TrackRecords TextRecords RegionRecords FillRecords CompBodyRecords
		MiscRecords
	    ))
	println("--END--")
    )
)
procedure(TRL_ALTIUM2PCB_LoadIntermediate_Routing_Files() 
    let((inp BoardRecords ClassRecords NetRecords ComponentRecords
	    PolygonRecords DXPRuleRecords RuleRecords ArcRecords PadRecords
	    ViaRecords TrackRecords TextRecords RegionRecords FillRecords
	    CompBodyRecords MiscRecords text_cmp text_net text_misc
	    pad_cmp pad_misc track_cmp track_net track_misc
	    reg_cmp reg_net reg_poly reg_misc input_string
	    fill_cmp fill_net fill_misc via_cmp via_net
	    via_misc
	) 
	(input_string = (axlFormGetField 
		(trl_altium2pcb_global->formid) "intermediate_l"
	    )) 
	(inp = infile(strcat(input_string "/ViaRecords_net.txt"))) 
	(via_net = lineread(inp)) 
	close(inp)
	(inp = infile(strcat(input_string "/TrackRecords_net.txt"))) 
	(track_net = lineread(inp)) 
	close(inp) 
	(inp = infile(strcat(input_string "/ArcRecords.txt"))) 
	(ArcRecords = lineread(inp))
	close(inp) 
	(inp = infile(strcat(input_string "/NetRecords.txt"))) 
	(NetRecords = lineread(inp)) 
	close(inp) 
	(PadRecords = list(pad_cmp pad_misc))
	(TrackRecords = list(track_cmp track_net track_misc)) 
	(TextRecords = list(text_cmp text_net text_misc)) 
	(RegionRecords = list(reg_cmp reg_net reg_poly reg_misc)) 
	(FillRecords = list(fill_cmp fill_net fill_misc)) 
	(ViaRecords = list(via_cmp via_net via_misc))
	(trl_altium2pcb_global->PcbRawList = list(BoardRecords ClassRecords NetRecords ComponentRecords PolygonRecords
		DXPRuleRecords RuleRecords ArcRecords PadRecords ViaRecords
		TrackRecords TextRecords RegionRecords FillRecords CompBodyRecords
		MiscRecords
	    )) 
	println("--END--")
    )
)
procedure(TRL_ALTIUM2PCB_LoadIntermediate_Shape_Files() 
    let((inp BoardRecords ClassRecords NetRecords ComponentRecords
	    PolygonRecords DXPRuleRecords RuleRecords ArcRecords PadRecords
	    ViaRecords TrackRecords TextRecords RegionRecords FillRecords
	    CompBodyRecords MiscRecords text_cmp text_net text_misc
	    pad_cmp pad_misc track_cmp track_net track_misc
	    reg_cmp reg_net reg_poly reg_misc input_string
	    via_cmp via_net via_misc fill_cmp fill_net
	    fill_misc
	) 
	(input_string = (axlFormGetField 
		(trl_altium2pcb_global->formid) "intermediate_l"
	    )) 
	(inp = infile(strcat(input_string "/PolygonRecords.txt"))) 
	(PolygonRecords = lineread(inp)) 
	close(inp)
	(inp = infile(strcat(input_string "/RegionRecords_net.txt"))) 
	(reg_net = lineread(inp)) 
	close(inp) 
	(inp = infile(strcat(input_string "/FillRecords_net.txt"))) 
	(fill_net = lineread(inp))
	close(inp) 
	(inp = infile(strcat(input_string "/NetRecords.txt"))) 
	(NetRecords = lineread(inp)) 
	close(inp) 
	(PadRecords = list(pad_cmp pad_misc))
	(TrackRecords = list(track_cmp track_net track_misc)) 
	(TextRecords = list(text_cmp text_net text_misc)) 
	(RegionRecords = list(reg_cmp reg_net reg_poly reg_misc)) 
	(FillRecords = list(fill_cmp fill_net fill_misc)) 
	(ViaRecords = list(via_cmp via_net via_misc))
	(trl_altium2pcb_global->PcbRawList = list(BoardRecords ClassRecords NetRecords ComponentRecords PolygonRecords
		DXPRuleRecords RuleRecords ArcRecords PadRecords ViaRecords
		TrackRecords TextRecords RegionRecords FillRecords CompBodyRecords
		MiscRecords
	    )) 
	println("--END--")
    )
)
procedure(TRL_ALTIUM2PCB_Load_ColorFile() 
    let((pcb_inport parse_strg ColorData RGBData rgb
	    lay_col nline
	) 
	if(isFile(cadr((trl_altium2pcb_global->settings))) then 
	    if(isReadable(cadr((trl_altium2pcb_global->settings))) then 
		(pcb_inport = infile(cadr((trl_altium2pcb_global->settings)))) else 
		(trl_altium2pcb_global->exeption = cons("-->1.2.11 WARNING - PCBSysColors File don't exist or can't be accessed!" 
			(trl_altium2pcb_global->exeption)
		    ))
	    ) else 
	    (trl_altium2pcb_global->exeption = cons("-->1.2.11 WARNING - Unable to Open BPCBSysColors File, Check File Name!" 
		    (trl_altium2pcb_global->exeption)
		))
	) 
	if(pcb_inport then 
	    (ColorData = list()) 
	    (RGBData = list()) 
	    while((nline = _gets(pcb_inport)) 
		(parse_strg = parseString(nline "\n")) 
		(parse_strg = car(parse_strg)) 
		(parse_strg = parseString(parse_strg "=")) 
		when(parse_strg 
		    when((length(parse_strg) == 2) 
			(rgb = cadr(parse_strg)) 
			when(onep(length(parseString(rgb))) 
			    (rgb = TRL_ALTIUM2PCB_Util_Convert_Hex2RGB(rgb)) 
			    when(rgb 
				(lay_col = list()) 
				when((car(parse_strg) == "TopLayer") 
				    (lay_col = list(1 rgb))
				) 
				when((car(parse_strg) == "BottomLayer") 
				    (lay_col = list(32 rgb))
				) 
				when((car(parse_strg) == "TopOverlay") 
				    (lay_col = list(33 rgb))
				)
				when((car(parse_strg) == "BottomOverlay") 
				    (lay_col = list(34 rgb))
				) 
				when((car(parse_strg) == "TopPaste") 
				    (lay_col = list(35 rgb))
				) 
				when((car(parse_strg) == "BottomPaste") 
				    (lay_col = list(36 rgb))
				) 
				when((car(parse_strg) == "TopSolder") 
				    (lay_col = list(37 rgb))
				) 
				when((car(parse_strg) == "BottomSolder") 
				    (lay_col = list(38 rgb))
				)
				for(index 1 30 
				    when((sprintf(nil "MidLayer%d" index) == 
					    car(parse_strg)) 
					(lay_col = list((index + 1) rgb))
				    ) 
				    index++
				) 
				for(index 1 16 
				    when((sprintf(nil "InternalPlane%d" index) == 
					    car(parse_strg)) 
					(lay_col = list((index + 38) rgb))
				    ) 
				    index++
				) 
				when((car(parse_strg) == "DrillGuide") 
				    (lay_col = list(55 rgb))
				) 
				when((car(parse_strg) == "KeepOutLayer") 
				    (lay_col = list(56 rgb))
				) 
				for(index 1 16 
				    when((sprintf(nil "Mechanical%d" index) == 
					    car(parse_strg)) 
					(lay_col = list((index + 56) rgb))
				    ) 
				    index++
				)
				when((car(parse_strg) == "SheetAreaColor") 
				    (lay_col = list(200 rgb))
				) 
				when((car(parse_strg) == "SheetLineColor") 
				    (lay_col = list(201 rgb)) 
				    (lay_col = list(202 rgb))
				) 
				when(lay_col 
				    (ColorData = cons(lay_col ColorData)) 
				    (RGBData = cons(rgb RGBData))
				)
			    )
			)
		    )
		)
	    )
	    close(pcb_inport) else 
	    (trl_altium2pcb_global->exeption = cons("-->1.2.12 WARNING - Altium PCBSysColors File don't exist or can't be accessed!" 
		    (trl_altium2pcb_global->exeption)
		))
	) 
	when((ColorData && RGBData) 
	    list(ColorData RGBData)
	)
    )
)
procedure(TRL_ALTIUM2PCB_Load_File() 
    let((pcb_inport parse_strg info BoardData nline
	    t_message s_level intermediate
	) 
	if(isFile((axlFormGetField 
		    (trl_altium2pcb_global->formid) "PcbDoc_l"
		)
	    ) then 
	    if(isReadable((axlFormGetField 
			(trl_altium2pcb_global->formid) "PcbDoc_l"
		    )
		) then 
		(pcb_inport = infile((axlFormGetField 
			    (trl_altium2pcb_global->formid) "PcbDoc_l"
			)
		    )) 
		(intermediate = parseString((axlFormGetField 
			    (trl_altium2pcb_global->formid) "PcbDoc_l"
			) "/"
		    )) 
		(intermediate = car(last(intermediate)))
		(intermediate = parseString(intermediate ".")) 
		(intermediate = car(intermediate)) 
		if(intermediate then 
		    (trl_altium2pcb_global->intermediate = list(intermediate nil nil)) else 
		    (trl_altium2pcb_global->intermediate = list("alt2cdn" nil nil))
		) else 
		(axlUIWPrint 
		    (trl_altium2pcb_global->formid) "E - *Error* Unable to Open Board Definition File, Check Permissions"
		)
		(trl_altium2pcb_global->exeption = cons("-->1.2.01 ERROR   - Board Definition File don't exist or can't be accessed!" 
			(trl_altium2pcb_global->exeption)
		    ))
	    ) else 
	    (axlUIWPrint 
		(trl_altium2pcb_global->formid) "E - *Error* Unable to Open Board Definition File, Check File Name"
	    )
	    (trl_altium2pcb_global->exeption = cons("-->1.2.01 ERROR   - Unable to Open Board Definition File, Check File Name!" 
		    (trl_altium2pcb_global->exeption)
		))
	) 
	(BoardData = list()) 
	if(pcb_inport then 
	    (nline = _gets(pcb_inport)) 
	    close(pcb_inport) 
	    (nline = parseString(nline "|"))
	    if((car(nline) == "RECORD=Board") then 
		(pcb_inport = infile((axlFormGetField 
			    (trl_altium2pcb_global->formid) "PcbDoc_l"
			)
		    )) 
		while((nline = _gets(pcb_inport)) 
		    (parse_strg = parseString(nline "\n")) 
		    (parse_strg = car(parse_strg)) 
		    when(parse_strg 
			(parse_strg = parseString(parse_strg "|")) 
			(info = ncons(nil)) 
			foreach(prop_pair parse_strg 
			    (parse_strg = parseString(prop_pair "=")) 
			    when((length(parse_strg) == 2) 
				putprop(info 
				    cadr(parse_strg) 
				    stringToSymbol(car(parse_strg))
				)
			    )
			) 
			(BoardData = cons(info BoardData))
			(info = ncons(nil))
		    )
		) 
		close(pcb_inport)
		else 
		(axlUIWPrint 
		    (trl_altium2pcb_global->formid) "E - *Error* Altium .PcbDoc file is stll binary file!"
		) 
		(t_message = "Altium .PcbDoc file is stll binary file!\nPlease save the Altium PCB file in ASCII Format first") 
		(s_level = 'error) 
		(axlUIConfirm t_message s_level)
	    ) else 
	    (axlUIWPrint 
		(trl_altium2pcb_global->formid) "E - *Error* Altium PCB File don't exist or can't be accessed!"
	    ) 
	    (trl_altium2pcb_global->exeption = cons("-->1.2.02 ERROR   - Altium PCB File don't exist or can't be accessed!" 
		    (trl_altium2pcb_global->exeption)
		))
	) BoardData
    )
)
procedure(TRL_ALTIUM2PCB_Load_PCB_Data() 
    let((pcb_raw_list BoardRecords PrinterOptions ClassRecords NetRecords
	    ComponentRecords PolygonRecords DXPRuleRecords RuleRecords ArcRecords
	    PadRecords ViaRecords TrackRecords TextRecords RegionRecords
	    MiscRecords FillRecords CompBodyRecords track_cmp track_net
	    track_misc text_cmp text_net text_misc pad_cmp
	    pad_misc fill_cmp fill_net fill_misc reg_cmp
	    reg_net reg_poly reg_misc rec_length inc
	    via_cmp via_net via_misc
	) 
	(trl_altium2pcb_global->exeption = cons("-------------------------------------------------------------------------------" 
		(trl_altium2pcb_global->exeption)
	    )) 
	(trl_altium2pcb_global->exeption = cons(sprintf(nil "   1.1.0  INFO    - Start to Load PCB File.. | Start Time: %L" 
		    getCurrentTime()
		) 
		(trl_altium2pcb_global->exeption)
	    )) 
	(trl_altium2pcb_global->exeption = cons("-------------------------------------------------------------------------------" 
		(trl_altium2pcb_global->exeption)
	    )) 
	(pcb_raw_list = TRL_ALTIUM2PCB_Load_File())
	if(pcb_raw_list then 
	    if((type(pcb_raw_list) == 'list) then 
		(axlUIWPrint 
		    (trl_altium2pcb_global->formid) "-->1.1.0  INFO - PCB Raw Data generated"
		) 
		(trl_altium2pcb_global->exeption = cons("   1.1.1  INFO    - PCB Raw Data generated" 
			(trl_altium2pcb_global->exeption)
		    )) 
		(trl_altium2pcb_global->exeption = cons("-------------------------------------------------------------------------------" 
			(trl_altium2pcb_global->exeption)
		    ))
		(trl_altium2pcb_global->exeption = cons("   2.1.00 INFO    - Start to define Structured PCB Data for .." 
			(trl_altium2pcb_global->exeption)
		    )) 
		(trl_altium2pcb_global->exeption = cons("-------------------------------------------------------------------------------" 
			(trl_altium2pcb_global->exeption)
		    )) 
		(BoardRecords = list()) 
		(PrinterOptions = list()) 
		(ClassRecords = list())
		(NetRecords = list()) 
		(ComponentRecords = list()) 
		(PolygonRecords = list()) 
		(DXPRuleRecords = list()) 
		(RuleRecords = list())
		(ArcRecords = list()) 
		(PadRecords = list()) 
		(ViaRecords = list()) 
		(TrackRecords = list()) 
		(TextRecords = list())
		(RegionRecords = list()) 
		(MiscRecords = list()) 
		(FillRecords = list()) 
		(CompBodyRecords = list()) 
		(track_cmp = list())
		(track_net = list()) 
		(track_misc = list()) 
		(via_cmp = list()) 
		(via_net = list()) 
		(via_misc = list())
		(rec_length = length(pcb_raw_list)) 
		(inc = 1) 
		foreach(pcb_record pcb_raw_list 
		    case(get(pcb_record 
			    'RECORD
			) 
			("Board" 
			    (BoardRecords = cons(pcb_record BoardRecords))
			) 
			("Class" 
			    (ClassRecords = cons(pcb_record ClassRecords))
			) 
			("Net" 
			    (NetRecords = cons(pcb_record NetRecords))
			) 
			("Component" 
			    (ComponentRecords = cons(pcb_record ComponentRecords))
			)
			("Polygon" 
			    (PolygonRecords = cons(pcb_record PolygonRecords))
			) 
			("DXPRule" 
			    (DXPRuleRecords = cons(pcb_record DXPRuleRecords))
			) 
			("Rule" 
			    (RuleRecords = cons(pcb_record RuleRecords))
			) 
			("Arc" 
			    (ArcRecords = cons(pcb_record ArcRecords))
			) 
			("Via" 
			    if(get(pcb_record 
				    'COMPONENT
				) then 
				(via_cmp = cons(pcb_record via_cmp)) else 
				if(get(pcb_record 
					'NET
				    ) then 
				    (via_net = cons(pcb_record via_net)) else 
				    (via_misc = cons(pcb_record via_misc))
				)
			    )
			)
			("Pad" 
			    if(get(pcb_record 
				    'COMPONENT
				) then 
				(pad_cmp = cons(pcb_record pad_cmp)) else 
				(pad_misc = cons(pcb_record pad_misc))
			    )
			) 
			("Track" 
			    if(get(pcb_record 
				    'COMPONENT
				) then 
				(track_cmp = cons(pcb_record track_cmp)) else 
				if(get(pcb_record 
					'NET
				    ) then 
				    (track_net = cons(pcb_record track_net)) else 
				    (track_misc = cons(pcb_record track_misc))
				)
			    )
			) 
			("Text" 
			    if(get(pcb_record 
				    'COMPONENT
				) then 
				(text_cmp = cons(pcb_record text_cmp)) else 
				if(get(pcb_record 
					'NET
				    ) then 
				    (text_net = cons(pcb_record text_net)) else 
				    (text_misc = cons(pcb_record text_misc))
				)
			    )
			) 
			("Fill" 
			    if(get(pcb_record 
				    'COMPONENT
				) then 
				(fill_cmp = cons(pcb_record fill_cmp)) else 
				if(get(pcb_record 
					'NET
				    ) then 
				    (fill_net = cons(pcb_record fill_net)) else 
				    (fill_misc = cons(pcb_record fill_misc))
				)
			    )
			) 
			("Region" 
			    if(get(pcb_record 
				    'COMPONENT
				) then 
				(reg_cmp = cons(pcb_record reg_cmp)) else 
				if(get(pcb_record 
					'NET
				    ) then 
				    (reg_net = cons(pcb_record reg_net)) else 
				    if(get(pcb_record 
					    'POLYGON
					) then 
					(reg_poly = cons(pcb_record reg_poly)) else 
					(reg_misc = cons(pcb_record reg_misc))
				    )
				)
			    )
			)
			("ComponentBody" 
			    (CompBodyRecords = cons(pcb_record CompBodyRecords))
			) 
			("PrinterOptions" 
			    (PrinterOptions = cons(pcb_record PrinterOptions))
			) 
			(t 
			    (MiscRecords = cons(pcb_record MiscRecords))
			)
		    ) 
		    (axlMeterUpdate 15 
			sprintf(nil "Altium Files Loaded %d of %d Files" 15 100)
		    ) 
		    inc++
		    when((modulo(inc 100) == 0) 
			(axlUIWPrint 
			    (trl_altium2pcb_global->formid) "-->1.1.0  INFO - Processing Rec:[%5d] of [%5d] Records" inc rec_length
			)
		    )
		) 
		(TrackRecords = list(track_cmp track_net track_misc)) 
		(TextRecords = list(text_cmp text_net text_misc))
		(PadRecords = list(pad_cmp pad_misc)) 
		(FillRecords = list(fill_cmp fill_net fill_misc)) 
		(RegionRecords = list(reg_cmp reg_net reg_poly reg_misc)) 
		(ViaRecords = list(via_cmp via_net via_misc)) 
		(DXPRuleRecords = TRL_ALTIUM2PCB_DXPRule_Sort(DXPRuleRecords))
		(trl_altium2pcb_global->color = list()) 
		(trl_altium2pcb_global->color = PrinterOptions) 
		(trl_altium2pcb_global->PcbRawList = list(BoardRecords ClassRecords NetRecords ComponentRecords PolygonRecords
			DXPRuleRecords RuleRecords ArcRecords PadRecords ViaRecords
			TrackRecords TextRecords RegionRecords FillRecords CompBodyRecords
			MiscRecords
		    )) 
		if((BoardRecords && (type(BoardRecords) == 'list)) then 
		    (trl_altium2pcb_global->exeption = cons("   2.1.01 INFO    - Board data exist" 
			    (trl_altium2pcb_global->exeption)
			)) else 
		    (trl_altium2pcb_global->exeption = cons("   2.1.01 WARNING - Board data DO NOT exist!!" 
			    (trl_altium2pcb_global->exeption)
			))
		) 
		if((ClassRecords && (type(ClassRecords) == 'list)) then 
		    (trl_altium2pcb_global->exeption = cons("   2.1.02 INFO    - Class data exist" 
			    (trl_altium2pcb_global->exeption)
			)) else 
		    (trl_altium2pcb_global->exeption = cons("   2.1.02 WARNING - Class data DO NOT exist!!" 
			    (trl_altium2pcb_global->exeption)
			))
		)
		if((NetRecords && (type(NetRecords) == 'list)) then 
		    (trl_altium2pcb_global->exeption = cons("   2.1.03 INFO    - Net data exist" 
			    (trl_altium2pcb_global->exeption)
			)) else 
		    (trl_altium2pcb_global->exeption = cons("   2.1.03 WARNING - Net data DO NOT exist!!" 
			    (trl_altium2pcb_global->exeption)
			))
		) 
		if((ComponentRecords && (type(ComponentRecords) == 'list)) then 
		    (trl_altium2pcb_global->exeption = cons("   2.1.04 INFO    - Component data exist" 
			    (trl_altium2pcb_global->exeption)
			)) else 
		    (trl_altium2pcb_global->exeption = cons("-->2.1.04 WARNING - Component data DO NOT exist!!" 
			    (trl_altium2pcb_global->exeption)
			))
		) 
		if((PolygonRecords && (type(PolygonRecords) == 'list)) then 
		    (trl_altium2pcb_global->exeption = cons("   2.1.05 INFO    - Polygon data exist" 
			    (trl_altium2pcb_global->exeption)
			)) else 
		    (trl_altium2pcb_global->exeption = cons("   2.1.05 WARNING - Polygon data DO NOT exist!!" 
			    (trl_altium2pcb_global->exeption)
			))
		) 
		if((DXPRuleRecords && (type(DXPRuleRecords) == 'list)) then 
		    (trl_altium2pcb_global->exeption = cons("   2.1.06 INFO    - DXPRule data exist" 
			    (trl_altium2pcb_global->exeption)
			)) else 
		    (trl_altium2pcb_global->exeption = cons("   2.1.06 WARNING - DXPRule data DO NOT exist!!" 
			    (trl_altium2pcb_global->exeption)
			))
		) 
		if((RuleRecords && (type(RuleRecords) == 'list)) then 
		    (trl_altium2pcb_global->exeption = cons("   2.1.07 INFO    - Rule data exist" 
			    (trl_altium2pcb_global->exeption)
			)) else 
		    (trl_altium2pcb_global->exeption = cons("   2.1.07 WARNING - Rule data DO NOT exist!!" 
			    (trl_altium2pcb_global->exeption)
			))
		)
		if((ArcRecords && (type(ArcRecords) == 'list)) then 
		    (trl_altium2pcb_global->exeption = cons("   2.1.08 INFO    - Arc data exist" 
			    (trl_altium2pcb_global->exeption)
			)) else 
		    (trl_altium2pcb_global->exeption = cons("   2.1.08 WARNING - Arc data DO NOT exist!!" 
			    (trl_altium2pcb_global->exeption)
			))
		) 
		if((PadRecords && (type(PadRecords) == 'list)) then 
		    (trl_altium2pcb_global->exeption = cons("   2.1.09 INFO    - Pad data exist" 
			    (trl_altium2pcb_global->exeption)
			)) else 
		    (trl_altium2pcb_global->exeption = cons("   2.1.09 WARNING - Pad data DO NOT exist!!" 
			    (trl_altium2pcb_global->exeption)
			))
		) 
		if((ViaRecords && (type(ViaRecords) == 'list)) then 
		    (trl_altium2pcb_global->exeption = cons("   2.1.10 INFO    - Via data exist" 
			    (trl_altium2pcb_global->exeption)
			)) else 
		    (trl_altium2pcb_global->exeption = cons("   2.1.10 WARNING - Via data DO NOT exist!!" 
			    (trl_altium2pcb_global->exeption)
			))
		) 
		if((TrackRecords && (type(TrackRecords) == 'list)) then 
		    (trl_altium2pcb_global->exeption = cons("   2.1.11 INFO    - Track data exist" 
			    (trl_altium2pcb_global->exeption)
			)) else 
		    (trl_altium2pcb_global->exeption = cons("   2.1.11 WARNING - Track data DO NOT exist!!" 
			    (trl_altium2pcb_global->exeption)
			))
		) 
		if((TextRecords && (type(TextRecords) == 'list)) then 
		    (trl_altium2pcb_global->exeption = cons("   2.1.12 INFO    - Text data exist" 
			    (trl_altium2pcb_global->exeption)
			)) else 
		    (trl_altium2pcb_global->exeption = cons("   2.1.12 WARNING - Text data DO NOT exist!!" 
			    (trl_altium2pcb_global->exeption)
			))
		)
		if((RegionRecords && (type(RegionRecords) == 'list)) then 
		    (trl_altium2pcb_global->exeption = cons("   2.1.13 INFO    - Region data exist" 
			    (trl_altium2pcb_global->exeption)
			)) else 
		    (trl_altium2pcb_global->exeption = cons("   2.1.13 WARNING - Region data DO NOT exist!!" 
			    (trl_altium2pcb_global->exeption)
			))
		) 
		if((MiscRecords && (type(MiscRecords) == 'list)) then 
		    (trl_altium2pcb_global->exeption = cons("   2.1.14 INFO    - Misc data exist" 
			    (trl_altium2pcb_global->exeption)
			)) else 
		    (trl_altium2pcb_global->exeption = cons("   2.1.14 WARNING - Misc data DO NOT exist!!" 
			    (trl_altium2pcb_global->exeption)
			))
		) else 
		(trl_altium2pcb_global->exeption = cons(sprintf(nil "-->1.1.0  ERROR   - PCB Raw Data ERROR - %L" pcb_raw_list) 
			(trl_altium2pcb_global->exeption)
		    ))
	    ) 
	    if(nth(3 
		    (trl_altium2pcb_global->PcbRawList)
		) then 
		(trl_altium2pcb_global->exeption = cons("   2.2.01 INFO    - Component data exist" 
			(trl_altium2pcb_global->exeption)
		    )) 
		TRL_ALTIUM2PCB_CREATE_Pattern_List() 
		(trl_altium2pcb_global->exeption = cons("\t\t---------------------------------------------------------------------------------------------------------" 
			(trl_altium2pcb_global->exeption)
		    ))
		(trl_altium2pcb_global->exeption = cons("\t\tGen_Patt_Name     Unic_Patt_Name   ID IND REF X      Y      Layer  Fix    Rot   Org_refDes Org_Patt   " 
			(trl_altium2pcb_global->exeption)
		    )) 
		(trl_altium2pcb_global->exeption = cons("\t\t---------------------------------------------------------------------------------------------------------" 
			(trl_altium2pcb_global->exeption)
		    )) 
		foreach(part 
		    (trl_altium2pcb_global->PartsList) 
		    (trl_altium2pcb_global->exeption = cons(sprintf(nil "\t\t%L" part) 
			    (trl_altium2pcb_global->exeption)
			))
		) 
		if((trl_altium2pcb_global->PartsList) then 
		    (trl_altium2pcb_global->exeption = cons("   2.2.02 INFO    - Component data list created" 
			    (trl_altium2pcb_global->exeption)
			)) else 
		    (trl_altium2pcb_global->exeption = cons("-->2.2.02 ERROR   - Component data NOT list created!!" 
			    (trl_altium2pcb_global->exeption)
			))
		) else
		(trl_altium2pcb_global->exeption = cons("-->2.2.01 ERROR   - Component data DO NOT exist!!" 
			(trl_altium2pcb_global->exeption)
		    ))
	    ) else
	    (trl_altium2pcb_global->exeption = cons("-->1.1.01 ERROR   - PCB Raw Data NOT generated!!" 
		    (trl_altium2pcb_global->exeption)
		))
	) 
	(trl_altium2pcb_global->exeption = cons("===============================================================================" 
		(trl_altium2pcb_global->exeption)
	    )) 
	(trl_altium2pcb_global->exeption = cons(sprintf(nil "   1.1.0  INFO    - Finished to Load PCB File.. | End Time: [%L]" 
		    getCurrentTime()
		) 
		(trl_altium2pcb_global->exeption)
	    )) 
	(trl_altium2pcb_global->exeption = cons("===============================================================================" 
		(trl_altium2pcb_global->exeption)
	    ))
    )
)
procedure((TRL_ALTIUM2PCB_Main \@optional arg) 
    let((FC_VERSION SUB_VERSION fid FORM_FILE) 
	(FC_VERSION = "17.2") 
	(SUB_VERSION = "02") 
	when(TRL_LIC_Validate() 
	    TRL_ALTIUM2PCB_Init() 
	    TRL_ALTIUM2PCB_UTIL_Default_Text_Blocks() 
	    TRL_ALTIUM2PCB_UTIL_Default_Grid(1.0) 
	    (trl_altium2pcb_global->new_txt_block_nr = 2)
	    (trl_altium2pcb_global->index = 1) 
	    (trl_altium2pcb_global->txtBlock = list(1 25 33 57)) 
	    (axlDBControl 
		'maxNameLength 255
	    ) 
	    (axlDBControl 
		'drcEnable nil
	    ) 
	    (trl_altium2pcb_global->exeption = cons(sprintf(nil "   1.1.01 INFO    - Altium to Allegro Translator Version: %L Subversion: %L" FC_VERSION SUB_VERSION) 
		    (trl_altium2pcb_global->exeption)
		))
	    if(axlGetVariable("drawing_4mils") then 
		(axlDBChangeDesignUnits "mils" 4) else 
		(axlDBChangeDesignUnits "mils" 2)
	    ) 
	    if(axlGetVariable("drawing_4mils") then 
		(axlDBChangeDesignExtents 
		    list((-35000.0:-35000.0) 
			(99999.0:99999.0)
		    )
		) else 
		(axlDBChangeDesignExtents 
		    list((-4000000:-4000000) 
			(9999999:9999999)
		    )
		)
	    ) 
	    cond(((arg && (lowerCase(arg) == "version")) 
		    printf("Current version is: %s.%s\n" FC_VERSION SUB_VERSION)
		) 
		((arg && (lowerCase(arg) == "advanced")) 
		    (FORM_FILE = "trl_altium2pcb_adv.form") 
		    (fid = (axlFormCreate 
			    gensym("trlaltium2pcbadvform") FORM_FILE 
			    '(e outer) 
			    'TRL_ALTIUM2PCB_Form_Action
			    t nil
			)) 
		    (trl_altium2pcb_global->formid = fid) 
		    TRL_ALTIUM2PCB_Form_Settings_Advanced()
		    (axlFormDisplay fid) 
		    (axlFormTreeViewSet fid "tree" 
			'TV_REMOVEALL nil
		    ) 
		    TRL_ALTIUM2PCB_Tree_View() 
		    (axlFormTreeViewSet fid "tree" 
			'TV_NOEDITLABEL nil
		    ) 
		    when(isFile(FORM_FILE) 
			deleteFile(FORM_FILE)
		    )
		) 
		(t 
		    (FORM_FILE = "trl_altium2pcb") 
		    (fid = (axlFormCreate 
			    gensym("trlaltium2pcbform") FORM_FILE 
			    '(e outer) 
			    'TRL_ALTIUM2PCB_Form_Action_Basic
			    t nil
			)) 
		    (trl_altium2pcb_global->formid = fid) 
		    TRL_ALTIUM2PCB_Set_Allegro_Paths()
		    (trl_altium2pcb_global->intermediate = list(nil nil nil)) 
		    when(car((trl_altium2pcb_global->settings)) 
			(axlFormSetField fid "PcbDoc_l" 
			    car((trl_altium2pcb_global->settings))
			)
		    ) 
		    (trl_altium2pcb_global->settings = list("" "" 
			    axlGetVariable("devpath") 
			    axlGetVariable("psmpath") 
			    axlGetVariable("padpath")
			    t nil t nil
			)) 
		    (axlFormDisplay fid) 
		    (axlFormTitle fid "Altium PCB Translator")
		)
	    )
	)
    )
)
procedure((TRL_ALTIUM2PCB_Report \@optional arg) 
    let((out_f big_time report_file) 
	if(car((trl_altium2pcb_global->intermediate)) then 
	    (report_file = strcat(getWorkingDir() "/" 
		    car((trl_altium2pcb_global->intermediate)) "_altium2pcb.log"
		)) else 
	    (report_file = strcat(getWorkingDir() "/NO_BRD_altium2pcb.log"))
	) 
	(out_f = outfile(report_file)) 
	(big_time = getCurrentTime()) 
	fprintf(out_f "Altium PCB Translator\n")
	fprintf(out_f "\n") 
	fprintf(out_f "Date: %s\n\n" big_time) 
	foreach(i 
	    reverse((trl_altium2pcb_global->exeption)) 
	    fprintf(out_f "%s\n" i)
	) 
	when((length((trl_altium2pcb_global->exeption)) == 3) 
	    fprintf(out_f "\nALTIUM2PCB Translator NOT Executed!\n")
	) 
	close(out_f)
	unless(arg 
	    if(isFile(report_file) then 
		(axlUIViewFileCreate report_file "Altium Translator" nil) else 
		(axlUIConfirm 
		    sprintf(nil "Unable to open file %L, Check Permissions" report_file)
		)
	    )
	)
    )
)
procedure(TRL_ALTIUM2PCB_Rules() 
    let((DXPRule rulekind rulname netscope rulexpr1
	    rulexpr2 gap
	) 
	(trl_altium2pcb_global->exeption = cons("-------------------------------------------------------------------------------" 
		(trl_altium2pcb_global->exeption)
	    )) 
	(trl_altium2pcb_global->exeption = cons("   5.9.01 INFO    - Start to Add DRC's" 
		(trl_altium2pcb_global->exeption)
	    )) 
	(trl_altium2pcb_global->exeption = cons("-------------------------------------------------------------------------------" 
		(trl_altium2pcb_global->exeption)
	    )) 
	(DXPRule = nth(5 
		(trl_altium2pcb_global->PcbRawList)
	    ))
	foreach(rec DXPRule 
	    (rulekind = get(rec 
		    'RULEKIND
		)) 
	    (rulname = get(rec 
		    'NAME
		)) 
	    (netscope = get(rec 
		    'NETSCOPE
		))
	    (rulexpr1 = get(rec 
		    'SCOPE1EXPRESSION
		)) 
	    (rulexpr2 = get(rec 
		    'SCOPE2EXPRESSION
		)) 
	    (gap = get(rec 
		    'GAP
		)) 
	    case(rulekind 
		("Clearance" 
		    TRL_ALTIUM2PCB_Rules_Clearance(rec)
		) 
		("ShortCircuit" t) 
		("UnRoutedNet" t) 
		("UnConnectedPin" t)
		("Width" 
		    TRL_ALTIUM2PCB_Rules_RoutingWidth(rec)
		) 
		("RoutingTopology" t) 
		("RoutingPriority" t) 
		("RoutingLayers" t) 
		("RoutingCorners" t)
		("RoutingVias" t) 
		("FanoutControl" t) 
		("DiffPairsRouting" t) 
		("SMDToCorner" t) 
		("SMDToPlane" t)
		("SMDNeckDown" t) 
		("SolderMaskExpansion" t) 
		("PasteMaskExpansion" t) 
		("PlaneConnect") 
		("PlaneClearance" 
		    TRL_ALTIUM2PCB_Rules_PlaneClearance(rec)
		)
		("PolygonConnect" 
		    TRL_ALTIUM2PCB_Rules_PolygonConnect(rec)
		) 
		("FabricationTestpoint" t) 
		("FabricationTestPointUsage" t) 
		("AssemblyTestpoint" t) 
		("AssemblyTestPointUsage" t)
		("MinimumAnnularRing" t) 
		("AcuteAngle" t) 
		("HoleSize" t) 
		("LayerPairs" t) 
		("HoleToHoleClearance" t)
		("MinimumSolderMaskSliver" t) 
		("SilkscreenOverComponentPads" t) 
		("SilkToSilkClearance" t) 
		("NetAntennae" t) 
		("ParallelSegment" t)
		("Length" "Length" t) 
		("MatchedLengths" t) 
		("StubLength" t) 
		("ViasUnderSMD" t) 
		("MaximumViaCount" t)
		("RoomDefinition" t) 
		("ComponentClearance" t) 
		("ComponentOrientations" t) 
		("PermittedLayers" t) 
		("NetsToIgnore" t)
		("Height" t) 
		("SignalStimulus" t) 
		("OvershootFalling" t) 
		("OvershootRising" t) 
		("UndershootFalling" t)
		("UndershootRising" t) 
		("MaxMinImpedance" t) 
		("SignalTopValue" t) 
		("SignalBaseValue" t) 
		("FlightTimeRising" t)
		("FlightTimeFalling" t) 
		("SlopeRising" t) 
		("SlopeFalling" t) 
		("SupplyNets" t) 
		(t 
		    printf("--Rules-> %L %L %L %L %L %L\n" rulekind rulname netscope rulexpr1
			rulexpr2 gap
		    )
		)
	    )
	)
    )
)
procedure(TRL_ALTIUM2PCB_Rules_Clearance(rec) 
    let((rulname netscope rulexpr1 rulexpr2 gap
	    prio cs_ret enabled
	) 
	(gap = get(rec 
		'GAP
	    )) 
	(prio = get(rec 
		'PRIORITY
	    )) 
	(rulexpr1 = get(rec 
		'SCOPE2EXPRESSION
	    )) 
	(rulexpr2 = get(rec 
		'SCOPE1EXPRESSION
	    ))
	(netscope = get(rec 
		'NETSCOPE
	    )) 
	(enabled = get(rec 
		'ENABLED
	    )) 
	(rulname = get(rec 
		'NAME
	    )) 
	(gap = TRL_ALTIUM2PCB_Util_DesignUnits(gap)) 
	when(((rulexpr1 == "All") && (rulexpr2 == "All") && (enabled == "TRUE")) 
	    when((netscope == "DifferentNets") 
		(axlCNSMapClear) 
		(axlCNSSetSpacing "" nil 
		    'line_line gap
		) 
		(axlCNSSetSpacing "" nil 
		    'line_shape gap
		) 
		(axlCNSSetSpacing "" nil 
		    'thrupin_line gap
		)
		(axlCNSSetSpacing "" nil 
		    'thrupin_shape gap
		) 
		(axlCNSSetSpacing "" nil 
		    'thrupin_thrupin gap
		) 
		(axlCNSSetSpacing "" nil 
		    'thrupin_smdpin gap
		) 
		(axlCNSSetSpacing "" nil 
		    'thrupin_via gap
		) 
		(axlCNSSetSpacing "" nil 
		    'smdpin_line gap
		)
		(axlCNSSetSpacing "" nil 
		    'smdpin_shape gap
		) 
		(axlCNSSetSpacing "" nil 
		    'smdpin_smdpin gap
		) 
		(axlCNSSetSpacing "" nil 
		    'via_line gap
		) 
		(axlCNSSetSpacing "" nil 
		    'via_shape gap
		) 
		(axlCNSSetSpacing "" nil 
		    'via_via gap
		)
		(axlCNSSetSpacing "" nil 
		    'bbvia_line gap
		) 
		(axlCNSSetSpacing "" nil 
		    'bbvia_shape gap
		) 
		(axlCNSSetSpacing "" nil 
		    'bbvia_thrupin gap
		) 
		(axlCNSSetSpacing "" nil 
		    'bbvia_smdpin gap
		) 
		(axlCNSSetSpacing "" nil 
		    'bbvia_via gap
		)
		(axlCNSSetSpacing "" nil 
		    'bbvia_bbvia gap
		) 
		(axlCNSSetSpacing "" nil 
		    'uvia_line gap
		) 
		(axlCNSSetSpacing "" nil 
		    'uvia_shape gap
		) 
		(axlCNSSetSpacing "" nil 
		    'uvia_thrupin gap
		) 
		(axlCNSSetSpacing "" nil 
		    'uvia_smdpin gap
		)
		(axlCNSSetSpacing "" nil 
		    'uvia_via gap
		) 
		(axlCNSSetSpacing "" nil 
		    'uvia_bbvia gap
		) 
		(axlCNSSetSpacing "" nil 
		    'uvia_uvia gap
		) 
		(axlCNSSetSpacing "" nil 
		    'shape_shape gap
		) 
		(cs_ret = (axlCNSMapUpdate))
		if(cs_ret then 
		    (trl_altium2pcb_global->exeption = cons(sprintf(nil "   3.7.03 INFO    - Spacing       [Prio: %s] Name %s, Gap: %L, rulexpr1: %L, created!" prio rulname gap
				rulexpr1
			    ) 
			    (trl_altium2pcb_global->exeption)
			)) else 
		    (trl_altium2pcb_global->exeption = cons(sprintf(nil "-->3.7.03 ERROR   - Spacing       [Prio: %s] Name %s, Gap: %L, rulexpr1: %L, NOT created!" prio rulname gap
				rulexpr1
			    ) 
			    (trl_altium2pcb_global->exeption)
			))
		)
	    )
	)
    )
)
procedure(TRL_ALTIUM2PCB_Rules_PlaneClearance(rec) 
    let((rulexpr1 rulname gap cs_ret) 
	(rulexpr1 = get(rec 
		'SCOPE1EXPRESSION
	    )) 
	(rulname = get(rec 
		'NAME
	    )) 
	(gap = get(rec 
		'CLEARANCE
	    )) 
	if(gap then 
	    (gap = TRL_ALTIUM2PCB_Util_DesignUnits(gap)) else 
	    (trl_altium2pcb_global->exeption = cons(sprintf(nil "-->9.6.02 ERROR   - Rule: PlaneClearance.Name %L NOT created, NO CLEARANCE: %L" rulname rec) 
		    (trl_altium2pcb_global->exeption)
		))
	)
	if((rulexpr1 == "All") then 
	    (axlCNSMapClear) 
	    foreach(lay 
		(trl_altium2pcb_global->LayerStack) 
		when(((car(lay) >= 39) && (car(lay) <= 54)) 
		    (axlCNSSetSpacing "" 
			cadr(lay) 
			'line_shape gap
		    ) 
		    (axlCNSSetSpacing "" 
			cadr(lay) 
			'thrupin_shape gap
		    ) 
		    (axlCNSSetSpacing "" 
			cadr(lay) 
			'via_shape gap
		    )
		)
	    ) 
	    (cs_ret = (axlCNSMapUpdate))
	    if(cs_ret then 
		(trl_altium2pcb_global->exeption = cons(sprintf(nil "   9.6.02 INFO    - Rule: PlaneClearance.Name %L created! %L" rulname cs_ret) 
			(trl_altium2pcb_global->exeption)
		    )) else 
		(trl_altium2pcb_global->exeption = cons(sprintf(nil "-->9.6.03 ERROR   - Rule: PlaneClearance.Name %L NOT created: %L %L" rulname cs_ret rec) 
			(trl_altium2pcb_global->exeption)
		    ))
	    ) else 
	    (trl_altium2pcb_global->exeption = cons(sprintf(nil "   9.6.14 WARNING - Rule: PlaneClearance.Name.Name %L NOT Implemented: %L" rulname rulexpr1) 
		    (trl_altium2pcb_global->exeption)
		))
	)
    )
)
procedure(TRL_ALTIUM2PCB_Rules_PlaneConnect(rec) 
    let((gap scope1 scope2 cs_ret) 
	(gap = get(rec 
		'RELIEFAIRGAP
	    )) 
	(scope1 = get(rec 
		'SCOPE2EXPRESSION
	    )) 
	(scope2 = get(rec 
		'SCOPE1EXPRESSION
	    )) 
	(gap = TRL_ALTIUM2PCB_Util_DesignUnits(gap))
	if((scope1 == "All") then 
	    when((scope2 == "All") 
		(axlCNSMapClear) 
		(axlCNSSetSpacing nil nil 
		    'line_shape gap
		) 
		(axlCNSSetSpacing nil nil 
		    'thrupin_shape gap
		) 
		(axlCNSSetSpacing nil nil 
		    'smdpin_shape gap
		)
		(axlCNSSetSpacing nil nil 
		    'via_shape gap
		) 
		(axlCNSSetSpacing nil nil 
		    'bbvia_shape gap
		) 
		(axlCNSSetSpacing nil nil 
		    'uvia_shape gap
		) 
		(axlCNSSetSpacing nil nil 
		    'shape_shape gap
		) 
		(axlCNSSetSpacing nil nil 
		    'hole_shape gap
		)
		(cs_ret = (axlCNSMapUpdate)) 
		printf("-SHAPE_RET: %L\n" cs_ret)
	    ) else 
	    (trl_altium2pcb_global->exeption = cons(sprintf(nil "   9.6.03 WARNING - Rule: PlaneConnect. scope1: %L unknown: %L" scope1 rec) 
		    (trl_altium2pcb_global->exeption)
		))
	) 
	(axlDBControl 
	    'dynamicFillMode 
	    'wysiwyg
	)
    )
)
procedure(TRL_ALTIUM2PCB_Rules_PolygonConnect(rec) 
    let((rulexpr1 rulexpr2 angle entries width
	    style shape_param cmd r_name prio
	) 
	(rulexpr1 = get(rec 
		'SCOPE1EXPRESSION
	    )) 
	(rulexpr2 = get(rec 
		'SCOPE2EXPRESSION
	    )) 
	(angle = get(rec 
		'POLYGONRELIEFANGLE
	    )) 
	(entries = get(rec 
		'RELIEFENTRIES
	    ))
	(width = get(rec 
		'RELIEFCONDUCTORWIDTH
	    )) 
	(style = get(rec 
		'CONNECTSTYLE
	    )) 
	(r_name = get(rec 
		'NAME
	    )) 
	(prio = get(rec 
		'PRIORITY
	    )) 
	if((rulexpr1 == "All") then 
	    if((rulexpr2 == "All") then 
		(shape_param = strcat(getWorkingDir() "/default_shape.script")) 
		when(isFile(shape_param) 
		    deleteFile(shape_param)
		) 
		TRL_ALTIUM2PCB_Rules_ShapeParameters(angle entries width style r_name
		    prio
		)
		when(isFile(shape_param) 
		    (cmd = sprintf(nil "replay %s" shape_param)) 
		    (axlShell cmd) 
		    deleteFile(shape_param)
		) else t
	    ) else t
	)
    )
)
procedure(TRL_ALTIUM2PCB_Rules_RoutingWidth(rec) 
    let((rulexpr1 enabled) 
	(rulexpr1 = get(rec 
		'SCOPE1EXPRESSION
	    )) 
	(enabled = get(rec 
		'ENABLED
	    )) 
	if((rulexpr1 == "All") then 
	    when((enabled == "TRUE") 
		TRL_ALTIUM2PCB_Rules_Routing_Width(rec "All")
	    ) else 
	    (rulexpr1 = car(parseString(rulexpr1 "(")))
	    when(((rulexpr1 == "OnLayer") && (enabled == "TRUE")) 
		TRL_ALTIUM2PCB_Rules_Routing_Width(rec "All")
	    )
	)
    )
)
procedure(TRL_ALTIUM2PCB_Rules_Routing_Width(rec type) 
    let((rulname rulexpr1 prio cs_ret maxw
	    minw pref top_pref pars_str class
	    maxW minW maxLayerN minLayerN LayN
	) 
	if((type == "All") then 
	    (minw = get(rec 
		    'MINLIMIT
		)) 
	    (maxw = get(rec 
		    'MAXLIMIT
		)) 
	    (rulname = get(rec 
		    'NAME
		))
	    (prio = get(rec 
		    'PRIORITY
		)) 
	    (minw = TRL_ALTIUM2PCB_Util_DesignUnits(minw)) 
	    (maxw = TRL_ALTIUM2PCB_Util_DesignUnits(maxw)) 
	    (axlCNSMapClear) 
	    foreach(layer 
		(trl_altium2pcb_global->LayerStack) 
		(LayN = nil) 
		if(onep(car(layer)) then 
		    (maxW = get(rec 
			    'TOPLAYER_MAXWIDTH
			)) 
		    (minW = get(rec 
			    'TOPLAYER_MINWIDTH
			)) 
		    (LayN = "TOP")
		    else 
		    if((car(layer) == 32) then 
			(maxW = get(rec 
				'BOTTOMLAYER_MAXWIDTH
			    )) 
			(minW = get(rec 
				'BOTTOMLAYER_MAXWIDTH
			    )) 
			(LayN = "BOTTOM")
			else 
			(maxLayerN = stringToSymbol(sprintf(nil "MIDLAYER%d_MAXWIDTH" 
				    (car(layer) - 1)
				)
			    )) 
			(minLayerN = stringToSymbol(sprintf(nil "MIDLAYER%d_MINWIDTH" 
				    (car(layer) - 1)
				)
			    )) 
			(maxW = get(rec maxLayerN)) 
			(minW = get(rec minLayerN))
		    )
		) 
		if(maxW then 
		    (maxW = TRL_ALTIUM2PCB_Util_DesignUnits(maxW)) else 
		    (maxW = maxw)
		)
		if(minW then 
		    (minW = TRL_ALTIUM2PCB_Util_DesignUnits(minW)) else 
		    (minW = minw)
		) 
		unless(LayN 
		    (LayN = cadr(layer))
		) 
		unless(((LayN == "Bottom Solder") || (LayN == "Top Solder") || (LayN == "Bottom Paste") || (LayN == "Top Paste") || (LayN == "Bottom Overlay") || (LayN == "Top Overlay")) 
		    (axlCNSSetPhysical "" LayN 
			'width_min minW
		    ) 
		    (axlCNSSetPhysical "" LayN 
			'width_max maxW
		    )
		)
	    )
	    (cs_ret = (axlCNSMapUpdate)) 
	    if(cs_ret then 
		(trl_altium2pcb_global->exeption = cons(sprintf(nil "   3.7.04 INFO    - Physical      [Prio: %s] Name: %s,  Min: %L, Max: %L, rulexpr1: %L, created!" prio rulname minw
			    maxw rulexpr1
			) 
			(trl_altium2pcb_global->exeption)
		    )) 
		(cs_ret = nil) else
		(trl_altium2pcb_global->exeption = cons(sprintf(nil "-->3.7.04 ERROR   - Physical      [Prio: %s] Name: %s,  Min: %L, Max: %L, rulexpr1: %L, NOT created!" prio rulname minw
			    maxw rulexpr1
			) 
			(trl_altium2pcb_global->exeption)
		    ))
	    ) else 
	    (pref = get(rec 
		    'PREFEREDWIDTH
		)) 
	    (minw = get(rec 
		    'MINLIMIT
		))
	    (maxw = get(rec 
		    'MAXLIMIT
		)) 
	    (prio = get(rec 
		    'PRIORITY
		)) 
	    (rulname = get(rec 
		    'NAME
		)) 
	    (rulexpr1 = get(rec 
		    'SCOPE1EXPRESSION
		)) 
	    (top_pref = get(rec 
		    'TOPLAYER_PREFWIDTH
		))
	    (pref = TRL_ALTIUM2PCB_Util_DesignUnits(pref)) 
	    (minw = TRL_ALTIUM2PCB_Util_DesignUnits(minw)) 
	    (maxw = TRL_ALTIUM2PCB_Util_DesignUnits(maxw)) 
	    case(rulexpr1 
		("All" 
		    if(top_pref then 
			(axlCNSMapClear) 
			(axlCNSSetPhysical "" nil 
			    'width_min minw
			) 
			(axlCNSSetPhysical "" nil 
			    'width_max maxw
			)
			(cs_ret = (axlCNSMapUpdate)) else 
			(axlCNSMapClear) 
			(axlCNSSetPhysical "" nil 
			    'width_min minw
			) 
			(axlCNSSetPhysical "" nil 
			    'width_max maxw
			)
			(cs_ret = (axlCNSMapUpdate))
		    ) 
		    if(cs_ret then 
			(trl_altium2pcb_global->exeption = cons(sprintf(nil "   3.7.04 INFO    - Rule: DEFAULT -> Physical.Name %L created: %L" rulname rulexpr1) 
				(trl_altium2pcb_global->exeption)
			    )) 
			(cs_ret = nil) else
			(trl_altium2pcb_global->exeption = cons(sprintf(nil "-->3.7.04 ERROR   - Rule: DEFAULT -> Physical.Name %L NOT created: %L %L" rulname rulexpr1 rec) 
				(trl_altium2pcb_global->exeption)
			    ))
		    )
		) 
		(t 
		    (pars_str = parseString(rulexpr1 " ")) 
		    if((member("AND" pars_str) || 
			    member("OR" pars_str) || 
			    member("And" pars_str)) then 
			(trl_altium2pcb_global->exeption = cons(sprintf(nil "   9.3.14 WARNING - Rule: Physical.Name %L NOT Implemented: %L" rulname rulexpr1) 
				(trl_altium2pcb_global->exeption)
			    )) else 
			(pars_str = car(parseString(rulexpr1 "(")))
			case(pars_str 
			    ("InNetClass" 
				(rulexpr1 = cadr(parseString(rulexpr1 "("))) 
				(rulexpr1 = car(parseString(rulexpr1 ")"))) 
				(rulexpr1 = car(parseString(rulexpr1 "'"))) 
				(class = TRL_ALTIUM2PCB_Util_Get_Class(rulexpr1))
				(axlClearSelSet) 
				(axlSetFindFilter ?enabled 
				    list("noall" "nets") ?onButtons 
				    list("all")
				) 
				(axlSingleSelectName "NET" class) 
				(cs_ret = (axlDBAddProp 
					(axlGetSelSet) 
					list(list("MAX_LINE_WIDTH" maxw) 
					    list("MIN_LINE_WIDTH" minw)
					)
				    ))
			    ) 
			    ("InNet" 
				(rulexpr1 = cadr(parseString(rulexpr1 "("))) 
				(rulexpr1 = car(parseString(rulexpr1 ")"))) 
				(rulexpr1 = car(parseString(rulexpr1 "'"))) 
				(axlClearSelSet)
				(axlSetFindFilter ?enabled 
				    list("noall" "nets") ?onButtons 
				    list("all")
				) 
				(axlSingleSelectName "NET" 
				    list(rulexpr1)
				) 
				(cs_ret = (axlDBAddProp 
					(axlGetSelSet) 
					list(list("MAX_LINE_WIDTH" maxw) 
					    list("MIN_LINE_WIDTH" minw)
					)
				    ))
			    ) 
			    ("OnLayer" 
				(rulexpr1 = cadr(parseString(rulexpr1 "("))) 
				(rulexpr1 = car(parseString(rulexpr1 ")"))) 
				(rulexpr1 = car(parseString(rulexpr1 "'"))) 
				(axlCNSMapClear)
				(axlCNSSetPhysical "" rulexpr1 
				    'width_min minw
				) 
				(axlCNSSetPhysical "" rulexpr1 
				    'width_max pref
				) 
				(cs_ret = (axlCNSMapUpdate))
			    ) 
			    (t)
			) 
			if(cs_ret then 
			    (trl_altium2pcb_global->exeption = cons(sprintf(nil "   3.7.04 INFO    - Rule: Physical.Name %L created: %L" rulname rulexpr1) 
				    (trl_altium2pcb_global->exeption)
				)) 
			    (cs_ret = nil) else
			    (trl_altium2pcb_global->exeption = cons(sprintf(nil "-->3.7.04 ERROR   - Rule: Physical.Name %L NOT created: %L %L" rulname rulexpr1 rec) 
				    (trl_altium2pcb_global->exeption)
				))
			)
		    )
		)
	    )
	)
    )
)
procedure(TRL_ALTIUM2PCB_Rules_ShapeParameters(angle entries width style r_name
	prio
    ) 
    let((port shape_param therm_conn_type therm_conns therm_width) 
	(therm_conn_type = "Diagonal") 
	(therm_conns = "4") 
	(therm_width = 10) 
	when(entries 
	    (therm_conns = entries)
	)
	if((style == "Relief") then 
	    if((angle == "45 Angle") then 
		(therm_conn_type = "Diagonal") else 
		(therm_conn_type = "Orthogonal")
	    ) else 
	    if((style == "Direct") then 
		(therm_conn_type = "Full contact") else 
		(therm_conn_type = "None")
	    )
	) 
	(therm_width = TRL_ALTIUM2PCB_Util_DesignUnits(width)) 
	(shape_param = strcat(getWorkingDir() "/default_shape.script")) 
	(port = outfile(shape_param "w")) 
	fprintf(port "scriptmode +i +n\n")
	fprintf(port "setwindow pcb\n") 
	fprintf(port "trapsize 0\n") 
	fprintf(port "shape global param\n") 
	fprintf(port "setwindow form.dyn_xshape\n") 
	fprintf(port "FORM dyn_xshape thru_pin_therm_connects %s\n" therm_conn_type)
	fprintf(port "FORM dyn_xshape min_thru_pin_connects %s\n" therm_conns) 
	fprintf(port "FORM dyn_xshape max_thru_pin_connects %s\n" therm_conns) 
	fprintf(port "FORM dyn_xshape smd_pin_therm_connects %s\n" therm_conn_type) 
	fprintf(port "FORM dyn_xshape min_smd_pin_connects %s\n" therm_conns) 
	fprintf(port "FORM dyn_xshape max_smd_pin_connects %s\n" therm_conns)
	fprintf(port "FORM dyn_xshape via_therm_connects %s\n" therm_conn_type) 
	fprintf(port "FORM dyn_xshape min_via_connects %s\n" therm_conns) 
	fprintf(port "FORM dyn_xshape max_via_connects %s\n" therm_conns) 
	fprintf(port "FORM dyn_xshape therm_fixed_value_box YES\n") 
	fprintf(port "FORM dyn_xshape therm_fixed_value %d\n" 
	    round(therm_width)
	)
	fprintf(port "FORM dyn_xshape apply\n") 
	fprintf(port "FORM dyn_xshape done\n") 
	fprintf(port "setwindow pcb\n") 
	(trl_altium2pcb_global->exeption = cons(sprintf(nil "   3.7.05 INFO    - Shape Params: [Prio: %s] Name: %s Type: %s, Conns: %s, Width: %d" prio r_name therm_conn_type
		    therm_conns 
		    round(therm_width)
		) 
		(trl_altium2pcb_global->exeption)
	    )) 
	close(port)
    )
)
procedure(TRL_ALTIUM2PCB_Rules_Util_Physical_Layer_Map(rec) 
    let((min_w max_w lay_name lay_nr rul_list) 
	(lay_name = nil) 
	(rul_list = list()) 
	for(index 1 30 
	    (min_w = stringToSymbol(sprintf(nil "MIDLAYER%d_MINWIDTH" index))) 
	    (max_w = stringToSymbol(sprintf(nil "MIDLAYER%d_PREFWIDTH" index)))
	    (min_w = get(rec min_w)) 
	    (max_w = get(rec max_w)) 
	    when(min_w 
		(min_w = TRL_ALTIUM2PCB_Util_DesignUnits(min_w))
	    ) 
	    when(max_w 
		(max_w = TRL_ALTIUM2PCB_Util_DesignUnits(max_w))
	    ) 
	    (lay_nr = index)
	    foreach(lay 
		(trl_altium2pcb_global->LayerStack) 
		when((car(lay) == (lay_nr + 1)) 
		    (lay_name = cadr(lay))
		)
	    ) 
	    when(lay_name 
		(rul_list = cons(list(list(lay_name min_w) 
			    list(lay_name max_w)
			) rul_list
		    )) 
		(lay_name = nil)
	    ) 
	    index++
	) rul_list
    )
)
procedure(TRL_ALTIUM2PCB_SETUP_Footprint_Text() 
    let((all_syms refdes cmp_id txt_list) 
	(axlDBRefreshId nil) 
	(all_syms = ((axlDBGetDesign)->symbols)) 
	foreach(symdef all_syms 
	    (refdes = (symdef->refdes)) 
	    foreach(cmp 
		(trl_altium2pcb_global->PartsList) 
		when((refdes == nth(4 cmp)) 
		    (cmp_id = caddr(cmp))
		)
	    ) 
	    (txt_list = TRL_ALTIUM2PCB_CREATE_Footprint_Text(cmp_id))
	    foreach(txt txt_list 
		when(car(txt) 
		    (axlDBCreateText 
			car(txt) 
			cadr(txt) 
			caddr(txt) 
			cadddr(txt)
			symdef
		    )
		)
	    )
	) 
	(axlVisibleLayer "Component Value/All" nil)
	(axlVisibleLayer "Device Type/All" nil) 
	(axlVisibleLayer "Ref Des/All" nil) 
	(axlVisibleLayer "Tolerance/All" nil) 
	(axlVisibleLayer "User Part Number/All" nil)
    )
)
procedure(TRL_ALTIUM2PCB_SaveBoard(board_name nr) 
    let((SaveDesign) 
	(SaveDesign = (axlSaveDesign ?design board_name ?noMru t
		?noConfirm t ?writeModel t
	    )) 
	(trl_altium2pcb_global->exeption = cons("===============================================================================" 
		(trl_altium2pcb_global->exeption)
	    )) 
	if(SaveDesign then 
	    (trl_altium2pcb_global->exeption = cons(sprintf(nil "   X.1.0%d INFO    - Board File: %L saved" nr board_name) 
		    (trl_altium2pcb_global->exeption)
		)) else 
	    (trl_altium2pcb_global->exeption = cons(sprintf(nil "   X.1.0%d ERROR   - Board File: %L NOT saved!" nr board_name) 
		    (trl_altium2pcb_global->exeption)
		))
	    (trl_altium2pcb_global->exeption = cons("===============================================================================" 
		    (trl_altium2pcb_global->exeption)
		))
	)
    )
)
procedure(TRL_ALTIUM2PCB_Set_Allegro_Paths() 
    let((input_string) 
	(input_string = "./devices") 
	if(isDir(input_string) then 
	    if(isWritable(input_string) then 
		(axlSetVariable "DEVPATH" input_string) 
		(trl_altium2pcb_global->exeption = cons(sprintf(nil "   X.1.01 INFO    - DEV Directory set: %L" input_string) 
			(trl_altium2pcb_global->exeption)
		    )) else
		(trl_altium2pcb_global->exeption = cons(sprintf(nil "   X.1.01 INFO    - DEV Directory: %L Not Writable" input_string) 
			(trl_altium2pcb_global->exeption)
		    ))
	    ) else 
	    if(createDir(input_string) then 
		(axlSetVariable "DEVPATH" input_string) 
		(trl_altium2pcb_global->exeption = cons(sprintf(nil "   X.1.01 INFO    - DEV Directory set: %L" input_string) 
			(trl_altium2pcb_global->exeption)
		    )) else
		(trl_altium2pcb_global->exeption = cons(sprintf(nil "   X.1.01 INFO    - DEV Directory: %L Not Writable" input_string) 
			(trl_altium2pcb_global->exeption)
		    ))
	    )
	) 
	(input_string = "./symbols") 
	if(isDir(input_string) then 
	    if(isWritable(input_string) then 
		(axlSetVariable "PSMPATH" input_string) 
		(axlSetVariable "PADPATH" input_string) 
		(trl_altium2pcb_global->exeption = cons(sprintf(nil "   X.1.02 INFO    - PAD & PSM Directory set: %L" input_string) 
			(trl_altium2pcb_global->exeption)
		    ))
		else 
		(trl_altium2pcb_global->exeption = cons(sprintf(nil "   X.1.02 INFO    - PAD & PSM Directory: %L Not Writable" input_string) 
			(trl_altium2pcb_global->exeption)
		    ))
	    ) else 
	    if(createDir(input_string) then 
		(axlSetVariable "PSMPATH" input_string) 
		(axlSetVariable "PADPATH" input_string) 
		(trl_altium2pcb_global->exeption = cons(sprintf(nil "   X.1.01 INFO    - PAD & PSM Directory set: %L" input_string) 
			(trl_altium2pcb_global->exeption)
		    ))
		else 
		(trl_altium2pcb_global->exeption = cons(sprintf(nil "   X.1.01 INFO    - PAD & PSM Directory: %L Not Writable" input_string) 
			(trl_altium2pcb_global->exeption)
		    ))
	    )
	)
    )
)
procedure(TRL_ALTIUM2PCB_Set_Default_DynShape_Param() 
    let((param) 
	(param = (axlGetParam "shapeDynamic")) 
	when(param 
	    (param->thermalWidthOverSize = 0.0) 
	    (param->thermalWidthFixed = 10.0) 
	    (param->thermalWidthUseFixed = t) 
	    (param->thermalWidthUseXHatch = nil)
	    (param->shapeOversize = 0.0) 
	    (param->textOversize = 0.0) 
	    (param->lineOversize = 0.0) 
	    (param->viaMaxTherms = 4) 
	    (param->viaMinTherms = 1)
	    (param->viaBestFit = t) 
	    (param->viaThermalType = "Full contact") 
	    (param->viaOversize = 0.0) 
	    (param->viaClearanceOther = nil) 
	    (param->smdMaxTherms = 4)
	    (param->smdMinTherms = 1) 
	    (param->smdBestFit = t) 
	    (param->smdThermalType = "Orthogonal") 
	    (param->smdOversize = 0.0) 
	    (param->smdClearanceOther = nil)
	    (param->pinMaxTherms = 4) 
	    (param->pinMinTherms = 1) 
	    (param->pinBestFit = t) 
	    (param->pinThermalType = "Diagonal") 
	    (param->pinOversize = 0.0)
	    (param->pinClearanceOther = nil) 
	    (param->xHatchFillPartial = "Off") 
	    (param->xHatchSnapVoids = nil) 
	    (param->xHatchBorderWidth = 5.0) 
	    (param->xHatchOrigin = (0.0:0.0))
	    (param->xHatchLineAngle2 = 90.0) 
	    (param->xHatchLineSpacing2 = 5.0) 
	    (param->xHatchLineWidth2 = 5.0) 
	    (param->xHatchLineAngle1 = 0.0) 
	    (param->xHatchLineSpacing1 = 5.0)
	    (param->xHatchLineWidth1 = 5.0) 
	    (param->fillStyle = "Solid") 
	    (param->diffpair = nil) 
	    (param->acuteAngleTrim = "Round") 
	    (param->inlinePinVoid = 0.0)
	    (param->areaSuppress = 5.0) 
	    (param->minAperture = 2.0) 
	    (param->artwork = "Gerber RS274X") 
	    (axlSetParam param)
	)
    )
)
procedure(TRL_ALTIUM2PCB_Transform_Footprint_Coordinate(pattern xy_list max_val_lst) 
    let((pattern_layer pattern_rot pattern_x pattern_y mirror
	    x1 y1 x1y1 x2 y2
	    x2y2
	) 
	(pattern_layer = nth(7 pattern)) 
	(pattern_rot = nth(9 pattern)) 
	(pattern_x = nth(5 pattern)) 
	(pattern_y = nth(6 pattern))
	(mirror = t) 
	when((pattern_layer == "TOP") 
	    (mirror = nil)
	) 
	if(mirror then 
	    (pattern_rot = (pattern_rot + 180)) else 
	    (pattern_rot = (pattern_rot * -1))
	) 
	(x1 = car(xy_list)) 
	(y1 = cadr(xy_list))
	(x1 = (x1 - pattern_x)) 
	(y1 = (y1 - pattern_y)) 
	(x1y1 = (axlGeoRotatePt pattern_rot 
		(x1:y1) 
		(0.0:0.0) mirror
	    )) 
	(max_val_lst = TRL_ALTIUM2PCB_UTIL_Find_Max_XY_Value(x1y1 max_val_lst)) 
	when((length(xy_list) == 4) 
	    (x2 = caddr(xy_list)) 
	    (y2 = cadddr(xy_list)) 
	    (x2 = (x2 - pattern_x)) 
	    (y2 = (y2 - pattern_y))
	    (x2y2 = (axlGeoRotatePt pattern_rot 
		    (x2:y2) 
		    (0.0:0.0) mirror
		)) 
	    (max_val_lst = TRL_ALTIUM2PCB_UTIL_Find_Max_XY_Value(x2y2 max_val_lst))
	)
	if((length(xy_list) == 4) then 
	    list(list(x1 y1 x2 y2) mirror max_val_lst) else 
	    list((x1:y1) mirror max_val_lst)
	)
    )
)
procedure(TRL_ALTIUM2PCB_Tree_Item_Action(curValue) 
    let((tree_item tree_valu tree_type) 
	(tree_item = parseString(curValue " ")) 
	(tree_valu = nth(3 tree_item)) 
	(tree_type = car(tree_item)) 
	if(tree_valu then 
	    case(tree_type 
		("psm" 
		    foreach(pattern 
			(trl_altium2pcb_global->PartsList) 
			when((nth(4 pattern) == tree_valu) 
			    TRL_ALTIUM2PCB_CREATE_Component(list(pattern))
			)
		    )
		) 
		(t 
		    printf("tree: %L\n" curValue)
		)
	    ) else 
	    printf("tree: %L\n" curValue)
	)
    )
)
procedure(TRL_ALTIUM2PCB_Tree_View() 
    let((psm_tree ind refDes) 
	if((trl_altium2pcb_global->PartsList) then 
	    (psm_tree = (axlFormTreeViewAddItem 
		    (trl_altium2pcb_global->formid) "tree" 
		    sprintf(nil "Parts List for design [%s] [%d]" 
			car((trl_altium2pcb_global->intermediate)) 
			length((trl_altium2pcb_global->PartsList))
		    ) nil
		    nil nil
		)) 
	    (ind = 1) 
	    foreach(psm 
		(trl_altium2pcb_global->PartsList) 
		if(nth(4 psm) then 
		    (refDes = nth(4 psm)) else 
		    (refDes = "Mech")
		) 
		(psm = sprintf(nil "psm [%4d] %-9s \t %s \t %s" ind refDes 
			cadr(psm)
			car(psm)
		    )) 
		(axlFormTreeViewAddItem 
		    (trl_altium2pcb_global->formid) "tree" psm psm_tree
		    nil t
		)
		ind++
	    )
	    else 
	    (psm_tree = (axlFormTreeViewAddItem 
		    (trl_altium2pcb_global->formid) "tree" "Parts List" nil
		    nil nil
		)) 
	    (axlFormTreeViewAddItem 
		(trl_altium2pcb_global->formid) "tree" "No Parts List found" psm_tree
		nil nil
	    )
	)
    )
)
procedure(TRL_ALTIUM2PCB_UTIL_Check_DBID() 
    let((dbid compdefs_lst symdefs_lst components_lst symbols_lst
	    padstacks_lst nets_list
	) 
	(axlDBRefreshId nil) 
	(dbid = (axlDBGetDesign)) 
	(compdefs_lst = list()) 
	(symdefs_lst = list())
	(components_lst = list()) 
	(symbols_lst = list()) 
	(padstacks_lst = list()) 
	(nets_list = list()) 
	when((dbid->compdefs) 
	    foreach(id 
		(dbid->compdefs) 
		(compdefs_lst = cons((id->name) compdefs_lst))
	    )
	)
	when((dbid->symdefs) 
	    foreach(id 
		(dbid->symdefs) 
		(symdefs_lst = cons((id->name) symdefs_lst))
	    )
	) 
	when((dbid->compdefs) 
	    foreach(id 
		(dbid->components) 
		(components_lst = cons(id components_lst))
	    )
	) 
	when((dbid->symbols) 
	    foreach(id 
		(dbid->symbols) 
		(symbols_lst = cons((id->name) symbols_lst))
	    )
	) 
	when((dbid->padstacks) 
	    foreach(id 
		(dbid->padstacks) 
		(padstacks_lst = cons((id->name) padstacks_lst))
	    )
	) 
	when((dbid->nets) 
	    foreach(id 
		(dbid->nets) 
		(nets_list = cons(id nets_list))
	    )
	)
	(trl_altium2pcb_global->UtilsList = list(compdefs_lst symdefs_lst components_lst symbols_lst padstacks_lst
		nets_list
	    ))
    )
)
procedure(TRL_ALTIUM2PCB_UTIL_Default_Grid(grid_val) 
    let((grid) 
	(grid = (axlDBGridGet "TOP")) 
	(grid->name = 'all) 
	(grid->xGrids = grid_val) 
	(grid->yGrids = grid_val)
	(axlDBGridSet grid)
    )
)
procedure(TRL_ALTIUM2PCB_UTIL_Default_Text_Blocks() 
    let((txt_param height) 
	for(ind 1 16 
	    (txt_param = (axlGetParam 
		    sprintf(nil "paramTextBlock:%d" ind)
		)) 
	    (height = (txt_param->height))
	    (txt_param->photoWidth = (height * 0.12)) 
	    (axlSetParam txt_param)
	) 
	(height = 25.0) 
	for(ind 17 64 
	    (axlDBTextBlockCreate 1 ?width 15.0 ?height
		16.1
	    )
	)
    )
)
procedure(TRL_ALTIUM2PCB_UTIL_Find_Layer(altium_layer) 
    let((LayerStack preproc_layer algr_class algr_layer) 
	if(altium_layer then 
	    (LayerStack = (trl_altium2pcb_global->LayerStack)) 
	    case(altium_layer 
		("TOP" 
		    (algr_class = "ETCH") 
		    (algr_layer = "TOP")
		) 
		("BOTTOM" 
		    (algr_class = "ETCH") 
		    (algr_layer = "BOTTOM")
		) 
		("TOPSOLDER" 
		    (algr_class = "Board Geometry") 
		    (algr_layer = "Soldermask_Top")
		) 
		("BOTTOMSOLDER" 
		    (algr_class = "Board Geometry") 
		    (algr_layer = "Soldermask_Bottom")
		)
		("TOPOVERLAY" 
		    (algr_class = "Board Geometry") 
		    (algr_layer = "Silkscreen_Top")
		) 
		("BOTTOMOVERLAY" 
		    (algr_class = "Board Geometry") 
		    (algr_layer = "Silkscreen_Bottom")
		) 
		("TOPPASTE" 
		    (algr_class = "Board Geometry") 
		    (algr_layer = "Pastemask_Top")
		) 
		("BOTTOMPASTE" 
		    (algr_class = "Board Geometry") 
		    (algr_layer = "Pastemask_Bottom")
		) 
		("KEEPOUT" 
		    (algr_class = "Areas") 
		    (algr_layer = "KEEPOUT")
		)
		("DRILLDRAWING" 
		    (algr_class = "Manufacturing") 
		    (algr_layer = "Ncdrill_Legend")
		) 
		("DRILLGUIDE" 
		    (algr_class = "Manufacturing") 
		    (algr_layer = "DRILLGUIDE")
		) 
		(t 
		    (preproc_layer = atoi(car(parseString(altium_layer "MID")))) 
		    if(preproc_layer then 
			(preproc_layer = (preproc_layer + 1)) 
			foreach(rec LayerStack 
			    when((preproc_layer == car(rec)) 
				(algr_class = "ETCH") 
				(algr_layer = cadr(rec))
			    )
			) else
			(preproc_layer = atoi(car(parseString(altium_layer "PLANE")))) 
			if(preproc_layer then 
			    (preproc_layer = (preproc_layer + 38)) 
			    foreach(rec LayerStack 
				when((preproc_layer == car(rec)) 
				    (algr_class = "ETCH") 
				    (algr_layer = cadr(rec))
				)
			    ) else
			    foreach(m_lay 
				(trl_altium2pcb_global->LayerMech) 
				when((cadr(m_lay) == altium_layer) 
				    (algr_class = "Board Geometry") 
				    (algr_layer = cadr(m_lay))
				)
			    )
			)
		    )
		)
	    ) else
	    (trl_altium2pcb_global->exeption = cons(sprintf(nil "   X.4.01 WARNING - Altium Layer NOT Specified: [%L]" altium_layer) 
		    (trl_altium2pcb_global->exeption)
		))
	) 
	unless(algr_class 
	    (trl_altium2pcb_global->exeption = cons(sprintf(nil "   X.4.02 WARNING - Allegro Class NOT Specified: [Board Geometry]") 
		    (trl_altium2pcb_global->exeption)
		)) 
	    (algr_class = "Board Geometry")
	) 
	unless(algr_layer 
	    (trl_altium2pcb_global->exeption = cons(sprintf(nil "   X.4.03 WARNING - Allegro SUBClass NOT Specified: [Multilayer]") 
		    (trl_altium2pcb_global->exeption)
		)) 
	    (algr_layer = "Multilayer")
	) 
	list(algr_class algr_layer)
    )
)
procedure(TRL_ALTIUM2PCB_UTIL_Find_Max_XY_Value(xy_actual_list xy_max_list) 
    let((x y max_x max_y) 
	(x = car(xy_actual_list)) 
	(y = cadr(xy_actual_list)) 
	(max_x = car(xy_max_list)) 
	(max_y = cadr(xy_max_list))
	when((abs(x) > max_x) 
	    (max_x = abs(x))
	) 
	when((abs(y) > max_y) 
	    (max_y = abs(y))
	) 
	(max_x:max_y)
    )
)
procedure(TRL_ALTIUM2PCB_UTIL_Find_Serif_Text_Block(height width) 
    let((txt_param txt_block g_txtGlob setParam) 
	(height = round(height)) 
	(width = round(width)) 
	(txt_block = 1) 
	if((cadr((trl_altium2pcb_global->txtBlock)) == 32) then 
	    prog(nil 
		for(ind 24 32 
		    (txt_param = (axlGetParam 
			    sprintf(nil "paramTextBlock:%d" ind)
			)) 
		    when((((txt_param->height) == height) && ((txt_param->photoWidth) == width)) 
			return((txt_block = sprintf(nil "%d" ind)))
		    )
		    ind++
		) 
		when(onep(txt_block) 
		    for(ind 24 32 
			(txt_param = (axlGetParam 
				sprintf(nil "paramTextBlock:%d" ind)
			    )) 
			when((((txt_param->height) == height) && ((txt_param->photoWidth) < width)) 
			    return((txt_block = (txt_block = sprintf(nil "%d" ind))))
			)
			ind++
		    )
		) 
		when(onep(txt_block) 
		    for(ind 24 32 
			(txt_param = (axlGetParam 
				sprintf(nil "paramTextBlock:%d" ind)
			    )) 
			when(((txt_param->height) > height) 
			    return((txt_block = (txt_block = sprintf(nil "%d" 
					    (ind - 1)
					)))
			    )
			)
			ind++
		    )
		)
	    ) else 
	    for(ind 24 32 
		(txt_param = (axlGetParam 
			sprintf(nil "paramTextBlock:%d" ind)
		    )) 
		when(((round((txt_param->height)) == height) && (round((txt_param->photoWidth)) == width)) 
		    (txt_block = sprintf(nil "%d" ind))
		)
		ind++
	    )
	    when(onep(txt_block) 
		(g_txtGlob = (trl_altium2pcb_global->txtBlock)) 
		(txt_block = (cadr(g_txtGlob) + 1)) 
		(txt_param = (axlGetParam 
			sprintf(nil "paramTextBlock:%d" txt_block)
		    )) 
		(txt_param->height = (height * 1.0))
		(txt_param->width = (height * 0.62)) 
		(txt_param->lineSpace = (height / 3)) 
		(txt_param->charSpace = (height * 0.1)) 
		(txt_param->photoWidth = (width * 1.0)) 
		(setParam = (axlSetParam txt_param))
		when(setParam 
		    (trl_altium2pcb_global->exeption = cons(sprintf(nil "   3.6.07 INFO    - text BLOCK [%L] Stroke, Font: Serif Created! height: %L / width: %L" txt_block height width) 
			    (trl_altium2pcb_global->exeption)
			))
		) 
		(trl_altium2pcb_global->txtBlock = list(car(g_txtGlob) txt_block 
			caddr(g_txtGlob) 
			cadddr(g_txtGlob)
		    )) 
		(txt_block = sprintf(nil "%d" txt_block))
	    )
	)
	txt_block
    )
)
procedure(TRL_ALTIUM2PCB_UTIL_Find_Text_Block(height width) 
    let((txt_param txt_block g_txtGlob setParam) 
	(height = round(height)) 
	(width = round(width)) 
	(txt_block = 1) 
	if((car((trl_altium2pcb_global->txtBlock)) == 23) then 
	    prog(nil 
		for(ind 2 23 
		    (txt_param = (axlGetParam 
			    sprintf(nil "paramTextBlock:%d" ind)
			)) 
		    when((((txt_param->height) == height) && ((txt_param->photoWidth) == width)) 
			return((txt_block = sprintf(nil "%d" ind)))
		    )
		    ind++
		) 
		when(onep(txt_block) 
		    for(ind 2 23 
			(txt_param = (axlGetParam 
				sprintf(nil "paramTextBlock:%d" ind)
			    )) 
			when((((txt_param->height) == height) && ((txt_param->photoWidth) < width)) 
			    return((txt_block = (txt_block = sprintf(nil "%d" ind))))
			)
			ind++
		    )
		) 
		when(onep(txt_block) 
		    for(ind 2 23 
			(txt_param = (axlGetParam 
				sprintf(nil "paramTextBlock:%d" ind)
			    )) 
			when(((txt_param->height) > height) 
			    return((txt_block = (txt_block = sprintf(nil "%d" 
					    (ind - 1)
					)))
			    )
			)
			ind++
		    )
		)
	    ) else 
	    for(ind 2 23 
		(txt_param = (axlGetParam 
			sprintf(nil "paramTextBlock:%d" ind)
		    )) 
		when(((round((txt_param->height)) == height) && (round((txt_param->photoWidth)) == width)) 
		    (txt_block = sprintf(nil "%d" ind))
		)
		ind++
	    )
	    when(onep(txt_block) 
		(g_txtGlob = (trl_altium2pcb_global->txtBlock)) 
		(txt_block = (car(g_txtGlob) + 1)) 
		(txt_param = (axlGetParam 
			sprintf(nil "paramTextBlock:%d" txt_block)
		    )) 
		(txt_param->height = (height * 1.0))
		(txt_param->width = (height * 0.8)) 
		(txt_param->lineSpace = (height / 3)) 
		(txt_param->charSpace = (height * 0.16)) 
		(txt_param->photoWidth = (width * 1.0)) 
		(setParam = (axlSetParam txt_param))
		when(setParam 
		    (trl_altium2pcb_global->exeption = cons(sprintf(nil "   3.6.06 INFO    - text BLOCK [%L] Stroke, Font: Default Created! height: %L / width: %L" txt_block height width) 
			    (trl_altium2pcb_global->exeption)
			))
		) 
		(trl_altium2pcb_global->txtBlock = list(txt_block 
			cadr(g_txtGlob) 
			caddr(g_txtGlob) 
			cadddr(g_txtGlob)
		    )) 
		(txt_block = sprintf(nil "%d" txt_block))
	    )
	)
	txt_block
    )
)
procedure(TRL_ALTIUM2PCB_UTIL_Find_TrueTypeBold_Text_Block(height width) 
    let((txt_param txt_block g_txtGlob setParam) 
	(height = (round(height) * 0.5)) 
	(width = (height * 0.2)) 
	(txt_block = 1) 
	if((cadddr((trl_altium2pcb_global->txtBlock)) == 64) then 
	    prog(nil 
		for(ind 57 64 
		    (txt_param = (axlGetParam 
			    sprintf(nil "paramTextBlock:%d" ind)
			)) 
		    when((((txt_param->height) == height) && ((txt_param->photoWidth) == width)) 
			return((txt_block = sprintf(nil "%d" ind)))
		    )
		    ind++
		) 
		when(onep(txt_block) 
		    for(ind 57 64 
			(txt_param = (axlGetParam 
				sprintf(nil "paramTextBlock:%d" ind)
			    )) 
			when((((txt_param->height) == height) && ((txt_param->photoWidth) < width)) 
			    return((txt_block = (txt_block = sprintf(nil "%d" ind))))
			)
			ind++
		    )
		) 
		when(onep(txt_block) 
		    for(ind 57 64 
			(txt_param = (axlGetParam 
				sprintf(nil "paramTextBlock:%d" ind)
			    )) 
			when(((txt_param->height) > height) 
			    return((txt_block = (txt_block = sprintf(nil "%d" 
					    (ind - 1)
					)))
			    )
			)
			ind++
		    )
		)
	    ) else 
	    for(ind 57 64 
		(txt_param = (axlGetParam 
			sprintf(nil "paramTextBlock:%d" ind)
		    )) 
		when(((round((txt_param->height)) == height) && (round((txt_param->photoWidth)) == width)) 
		    (txt_block = sprintf(nil "%d" ind))
		)
		ind++
	    )
	    when(onep(txt_block) 
		(g_txtGlob = (trl_altium2pcb_global->txtBlock)) 
		(txt_block = (cadddr(g_txtGlob) + 1)) 
		(txt_param = (axlGetParam 
			sprintf(nil "paramTextBlock:%d" txt_block)
		    )) 
		(txt_param->height = (height * 1.0))
		(txt_param->width = (height * 0.73)) 
		(txt_param->lineSpace = (height * 0.25)) 
		(txt_param->charSpace = (height * 0.22)) 
		(txt_param->photoWidth = (height * 0.2)) 
		(setParam = (axlSetParam txt_param))
		when(setParam 
		    (trl_altium2pcb_global->exeption = cons(sprintf(nil "   3.6.09 INFO    - text BLOCK [%L] TrueType Bold, Font:  Created! height: %L / width: %L" txt_block height width) 
			    (trl_altium2pcb_global->exeption)
			))
		) 
		(trl_altium2pcb_global->txtBlock = list(car(g_txtGlob) 
			cadr(g_txtGlob) 
			caddr(g_txtGlob) txt_block
		    )) 
		(txt_block = sprintf(nil "%d" txt_block))
	    )
	)
	txt_block
    )
)
procedure(TRL_ALTIUM2PCB_UTIL_Find_TrueType_Text_Block(height width) 
    let((txt_param txt_block g_txtGlob setParam) 
	(height = (round(height) * 0.5)) 
	(width = (height * 0.1)) 
	(txt_block = 1) 
	if((caddr((trl_altium2pcb_global->txtBlock)) == 56) then 
	    prog(nil 
		for(ind 33 56 
		    (txt_param = (axlGetParam 
			    sprintf(nil "paramTextBlock:%d" ind)
			)) 
		    when((((txt_param->height) == height) && ((txt_param->photoWidth) == width)) 
			return((txt_block = sprintf(nil "%d" ind)))
		    )
		    ind++
		) 
		when(onep(txt_block) 
		    for(ind 33 56 
			(txt_param = (axlGetParam 
				sprintf(nil "paramTextBlock:%d" ind)
			    )) 
			when((((txt_param->height) == height) && ((txt_param->photoWidth) < width)) 
			    return((txt_block = (txt_block = sprintf(nil "%d" ind))))
			)
			ind++
		    )
		) 
		when(onep(txt_block) 
		    for(ind 33 56 
			(txt_param = (axlGetParam 
				sprintf(nil "paramTextBlock:%d" ind)
			    )) 
			when(((txt_param->height) > height) 
			    return((txt_block = (txt_block = sprintf(nil "%d" 
					    (ind - 1)
					)))
			    )
			)
			ind++
		    )
		)
	    ) else 
	    for(ind 33 56 
		(txt_param = (axlGetParam 
			sprintf(nil "paramTextBlock:%d" ind)
		    )) 
		when(((round((txt_param->height)) == height) && (round((txt_param->photoWidth)) == width)) 
		    (txt_block = sprintf(nil "%d" ind))
		)
		ind++
	    )
	    when(onep(txt_block) 
		(g_txtGlob = (trl_altium2pcb_global->txtBlock)) 
		(txt_block = (caddr(g_txtGlob) + 1)) 
		(txt_param = (axlGetParam 
			sprintf(nil "paramTextBlock:%d" txt_block)
		    )) 
		(txt_param->height = (height * 1.0))
		(txt_param->width = (height * 0.73)) 
		(txt_param->lineSpace = (height * 25.0)) 
		(txt_param->charSpace = (height * 0.22)) 
		(txt_param->photoWidth = (height * 0.1)) 
		(setParam = (axlSetParam txt_param))
		when(setParam 
		    (trl_altium2pcb_global->exeption = cons(sprintf(nil "   3.6.08 INFO    - text BLOCK [%L] TrueType, Font:  Created! height: %L / width: %L" txt_block height width) 
			    (trl_altium2pcb_global->exeption)
			))
		) 
		(trl_altium2pcb_global->txtBlock = list(car(g_txtGlob) 
			cadr(g_txtGlob) txt_block 
			cadddr(g_txtGlob)
		    )) 
		(txt_block = sprintf(nil "%d" txt_block))
	    )
	)
	txt_block
    )
)
procedure(TRL_ALTIUM2PCB_UTIL_Package_Layer_Map(mirror subclass) 
    let((class_subclass sym_layer layer_Id) 
	if(mirror then 
	    case(subclass 
		("TOPOVERLAY" 
		    (sym_layer = "Package Geometry/Silkscreen_Bottom")
		) 
		("BOTTOMOVERLAY" 
		    (sym_layer = "Package Geometry/Silkscreen_Top")
		) 
		("TOPSOLDER" 
		    (sym_layer = "Package Geometry/Soldermask_Bottom")
		) 
		("BOTTOMSOLDER" 
		    (sym_layer = "Package Geometry/Soldermask_Top")
		)
		("TOPPASTE" 
		    (sym_layer = "Package Geometry/Pastemask_Bottom")
		) 
		("BOTTOMPASTE" 
		    (sym_layer = "Package Geometry/Pastemask_Top")
		) 
		(t 
		    (class_subclass = sprintf(nil "ETCH/%s" subclass)) 
		    if((axlLayerGet class_subclass) then 
			(sym_layer = class_subclass) 
			case(upperCase(subclass) 
			    ("TOP" 
				(sym_layer = "ETCH/BOTTOM")
			    ) 
			    ("BOTTOM" 
				(sym_layer = "ETCH/TOP")
			    ) 
			    (t 
				(sym_layer = class_subclass)
			    )
			) else
			(class_subclass = sprintf(nil "Package Geometry/%s" subclass)) 
			(layer_Id = (axlLayerCreateNonConductor class_subclass)) 
			if(layer_Id then 
			    (sym_layer = class_subclass) else 
			    (sym_layer = "Package Geometry/Display_Top")
			    printf("-->Unknown Layer %L\n" subclass)
			)
		    )
		)
	    ) else 
	    case(subclass 
		("TOPOVERLAY" 
		    (sym_layer = "Package Geometry/Silkscreen_Top")
		) 
		("BOTTOMOVERLAY" 
		    (sym_layer = "Package Geometry/Silkscreen_Bottom")
		) 
		("TOPSOLDER" 
		    (sym_layer = "Package Geometry/Soldermask_Top")
		) 
		("BOTTOMSOLDER" 
		    (sym_layer = "Package Geometry/Soldermask_Bottom")
		)
		("TOPPASTE" 
		    (sym_layer = "Package Geometry/Pastemask_Top")
		) 
		("BOTTOMPASTE" 
		    (sym_layer = "Package Geometry/Pastemask_Bottom")
		) 
		(t 
		    (class_subclass = sprintf(nil "ETCH/%s" subclass)) 
		    if((axlLayerGet class_subclass) then 
			(sym_layer = class_subclass) else 
			(class_subclass = sprintf(nil "Package Geometry/%s" subclass))
			(layer_Id = (axlLayerCreateNonConductor class_subclass)) 
			if(layer_Id then 
			    (sym_layer = class_subclass) else 
			    (sym_layer = "Package Geometry/Display_Top")
			    printf("-->Unknown Layer %L\n" subclass)
			)
		    )
		)
	    )
	) sym_layer
    )
)
procedure(TRL_ALTIUM2PCB_UTIL_Poly_From_Text(txt_dbid t_layer l_points rec) 
    let((tmp_layer tmp_plt_file orgvis orgactive seg_poly_list
	    poly_info shp poly_andnot txt_just txt_off
	    inv_width inv_height txt_box x_offset y_offset
	) 
	(tmp_layer = "DRAWING FORMAT/TMP_InvertedText") 
	unless((axlLayerGet tmp_layer) 
	    (axlLayerCreateNonConductor tmp_layer)
	) 
	(orgvis = (axlVisibleGet)) 
	(orgactive = (axlDBControl 
		'activeLayer
	    ))
	when((get(rec 
		    'USEINVERTEDRECTANGLE
		) == "TRUE") 
	    (txt_off = TRL_ALTIUM2PCB_Util_DesignUnits(get(rec 
			'TTFOFFSETFROMINVERTEDRECT
		    )
		)) 
	    (inv_width = TRL_ALTIUM2PCB_Util_DesignUnits(get(rec 
			'INVRECTWIDTH
		    )
		)) 
	    (inv_height = TRL_ALTIUM2PCB_Util_DesignUnits(get(rec 
			'INVRECTHEIGHT
		    )
		)) 
	    (txt_just = atoi(get(rec 
			'TTFINVERTEDTEXTJUSTIFY
		    )
		))
	    (txt_box = (txt_dbid->bBox)) 
	    (x_offset = abs((caar(txt_box) - caadr(txt_box)))) 
	    (y_offset = abs((cadar(txt_box) - cadadr(txt_box)))) 
	    case(txt_just 
		(1 
		    (y_offset = (inv_height - y_offset - txt_off)) 
		    (axlTransformObject txt_dbid ?move 
			(txt_off:y_offset)
		    )
		) 
		(2 
		    (y_offset = ((inv_height - y_offset) / 2.0)) 
		    (axlTransformObject txt_dbid ?move 
			(txt_off:y_offset)
		    )
		) 
		(3 
		    (axlTransformObject txt_dbid ?move 
			(txt_off:txt_off)
		    )
		) 
		(4 
		    (y_offset = (inv_height - y_offset - txt_off)) 
		    (x_offset = ((inv_width - x_offset) / 2.0)) 
		    (axlTransformObject txt_dbid ?move 
			(x_offset:y_offset)
		    )
		)
		(5 
		    (x_offset = ((inv_width - x_offset) / 2.0)) 
		    (y_offset = ((inv_height - y_offset) / 2.0)) 
		    (axlTransformObject txt_dbid ?move 
			(x_offset:y_offset)
		    )
		) 
		(6 
		    (x_offset = ((inv_width - x_offset) / 2.0)) 
		    (axlTransformObject txt_dbid ?move 
			(x_offset:txt_off)
		    )
		) 
		(7 
		    (x_offset = (inv_width - x_offset - txt_off)) 
		    (y_offset = (inv_height - y_offset - txt_off)) 
		    (axlTransformObject txt_dbid ?move 
			(x_offset:y_offset)
		    )
		) 
		(8 
		    (x_offset = (inv_width - x_offset - txt_off)) 
		    (y_offset = ((inv_height - y_offset) / 2.0)) 
		    (axlTransformObject txt_dbid ?move 
			(x_offset:y_offset)
		    )
		) 
		(9 
		    (x_offset = (inv_width - x_offset - txt_off)) 
		    (axlTransformObject txt_dbid ?move 
			(x_offset:txt_off)
		    )
		)
	    )
	) 
	(tmp_plt_file = (axlTempFile t)) 
	(axlDetailSave tmp_plt_file 
	    (txt_dbid->bBox) 
	    list(txt_dbid)
	) 
	(axlDBControl 
	    'activeLayer tmp_layer
	) 
	(axlDetailLoad tmp_plt_file 
	    car((txt_dbid->bBox)) 1.0 0
	    nil
	)
	(axlVisibleDesign nil) 
	(axlVisibleLayer tmp_layer t) 
	(axlVisibleUpdate nil) 
	(axlSetFindFilter ?enabled 
	    list("noall" "linesegs") ?onButtons 
	    list("all")
	) 
	(axlClearSelSet)
	(axlSingleSelectBox 
	    (txt_dbid->bBox)
	) 
	if((axlGetSelSet) then 
	    foreach(seg 
		(axlGetSelSet) 
		when(((seg->width) != 0.0) 
		    foreach(p 
			(axlPolyFromDB seg ?endCapType 
			    'ROUND
			) 
			(seg_poly_list = cons(p seg_poly_list))
		    )
		)
	    ) 
	    if(onep(length(seg_poly_list)) then 
		(poly_info = seg_poly_list) else 
		(poly_info = (axlPolyOperation 
			cdr(seg_poly_list) 
			list(car(seg_poly_list)) 
			'OR
		    ))
	    ) poly_info
	    else 
	    (trl_altium2pcb_global->exeption = cons(sprintf(nil "   3.6.11 ERROR   - Inverted TrueType Text NOT Created %L" rec) 
		    (trl_altium2pcb_global->exeption)
		))
	) 
	when(isFile(tmp_plt_file) 
	    (axlTempFileRemove tmp_plt_file)
	) 
	(axlDeleteObject 
	    (axlGetSelSet)
	) 
	(axlVisibleSet orgvis)
	(axlDBControl 
	    'activeLayer orgactive
	) 
	(axlVisibleUpdate nil) 
	if(poly_info then 
	    (poly_andnot = (axlPolyOperation 
		    car((axlPolyFromDB l_points)) poly_info 
		    'ANDNOT
		)) 
	    if(poly_andnot then 
		foreach(poly poly_andnot 
		    (shp = (axlDBCreateShape poly t t_layer)) 
		    unless(shp 
			(trl_altium2pcb_global->exeption = cons(sprintf(nil "   3.6.14 ERROR   - Inverted TrueType Text Shape NOT Created %L" rec) 
				(trl_altium2pcb_global->exeption)
			    ))
		    )
		) 
		(axlDeleteObject txt_dbid) else
		(trl_altium2pcb_global->exeption = cons(sprintf(nil "   3.6.13 ERROR   - Inverted TrueType Text NOT Created %L" rec) 
			(trl_altium2pcb_global->exeption)
		    ))
	    ) else
	    (trl_altium2pcb_global->exeption = cons(sprintf(nil "   3.6.12 ERROR   - TrueType Text POLY NOT Created %L" rec) 
		    (trl_altium2pcb_global->exeption)
		))
	) poly_andnot
    )
)
procedure(TRL_ALTIUM2PCB_UTIL_Text_BarCode(text layer t_hight x y
	rec
    ) 
    let((BarCodeScript port code height marginX
	    marginY mode barmin barfull barinvert
	    showtext cmd text_block session_param
	) 
	(session_param = eval('tbx_session_param)) 
	when(boundp('tbx_session_param) 
	    (session_param["tmp"] = (axlTempFile))
	) 
	(axlCmdRegister "tbx barcode" 
	    'TBX_BARCODE_Main ?cmdType "interactive"
	) 
	(height = TRL_ALTIUM2PCB_Util_DesignUnits(get(rec 
		    'BARCODEFULLHEIGHT
		)
	    ))
	(marginX = TRL_ALTIUM2PCB_Util_DesignUnits(get(rec 
		    'BARCODEXMARGIN
		)
	    )) 
	(marginY = TRL_ALTIUM2PCB_Util_DesignUnits(get(rec 
		    'BARCODEYMARGIN
		)
	    )) 
	(barmin = TRL_ALTIUM2PCB_Util_DesignUnits(get(rec 
		    'BARCODEMINWIDTH
		)
	    )) 
	(barfull = TRL_ALTIUM2PCB_Util_DesignUnits(get(rec 
		    'BARCODEFULLWIDTH
		)
	    )) 
	(mode = get(rec 
		'BARCODERENDERMODE
	    ))
	(barinvert = get(rec 
		'BARCODEINVERTED
	    )) 
	(showtext = get(rec 
		'BARCODESHOWTEXT
	    )) 
	(code = get(rec 
		'BARCODEKIND
	    )) 
	unless((barinvert == "TRUE") 
	    (marginX = 0.0) 
	    (marginY = 0.0)
	) 
	(BarCodeScript = strcat(getWorkingDir() "/BarCode.script"))
	(port = outfile(BarCodeScript "w")) 
	fprintf(port "scriptmode +i +n\n") 
	fprintf(port "setwindow pcb\n") 
	fprintf(port "trapsize 0\n") 
	fprintf(port "tbx barcode linear\n")
	fprintf(port "setwindow form.tbx_barcodelinear_main\n") 
	fprintf(port "FORM tbx_barcodelinear_main text_value %s\n" text) 
	fprintf(port "FORM tbx_barcodelinear_main class_name %s\n" 
	    car(parseString(layer "/"))
	) 
	fprintf(port "FORM tbx_barcodelinear_main subclass_name %s\n" 
	    cadr(parseString(layer "/"))
	) 
	if((code == "0") then 
	    fprintf(port "FORM tbx_barcodelinear_main code39 YES\n") else 
	    fprintf(port "FORM tbx_barcodelinear_main code128 YES\n")
	)
	fprintf(port "FORM tbx_barcodelinear_main barcode_height %L\n" height) 
	fprintf(port "FORM tbx_barcodelinear_main margin_top_bottom %L\n" marginY) 
	fprintf(port "FORM tbx_barcodelinear_main margin_left_right %L\n" marginX) 
	if((mode == "0") then 
	    fprintf(port "FORM tbx_barcodelinear_main fix_min_bar_width YES\n") 
	    fprintf(port "FORM tbx_barcodelinear_main min_bar_width %L\n" barmin) else
	    fprintf(port "FORM tbx_barcodelinear_main fix_barcode_width YES\n") 
	    fprintf(port "FORM tbx_barcodelinear_main barcode_width %L\n" barfull)
	) 
	when((barinvert == "TRUE") 
	    fprintf(port "FORM tbx_barcodelinear_main invert_structure YES\n")
	)
	when((showtext == "TRUE") 
	    fprintf(port "FORM tbx_barcodelinear_main embed_text YES\n") 
	    (text_block = TRL_ALTIUM2PCB_UTIL_Find_TrueType_Text_Block(t_hight t)) 
	    fprintf(port "FORM tbx_barcodelinear_main text_block %s\n" text_block)
	) 
	fprintf(port "FORM tbx_barcodelinear_main place\n") 
	fprintf(port "setwindow pcb\n") 
	fprintf(port "pick grid %L %L\n" x y) 
	fprintf(port "setwindow form.tbx_barcodelinear_main\n")
	fprintf(port "FORM tbx_barcodelinear_main done\n") 
	fprintf(port "setwindow pcb\n") 
	close(port) 
	(cmd = sprintf(nil "replay %L" BarCodeScript)) 
	(axlShell cmd)
	when(isFile(BarCodeScript) 
	    deleteFile(BarCodeScript)
	) 
	when(boundp('tbx_session_param) 
	    remove("tmp" session_param)
	) t
    )
)
procedure(TRL_ALTIUM2PCB_Util_Convert_Hex2RGB(hex) 
    let((string strg_l R G B) 
	(strg_l = list()) 
	(string = parseString(hex "")) 
	foreach(i string 
	    if(atoi(i) then 
		(strg_l = cons(atoi(i) strg_l)) else 
		case(upperCase(i) 
		    ("A" 
			(strg_l = cons(10 strg_l))
		    ) 
		    ("B" 
			(strg_l = cons(11 strg_l))
		    ) 
		    ("C" 
			(strg_l = cons(12 strg_l))
		    ) 
		    ("D" 
			(strg_l = cons(13 strg_l))
		    )
		    ("E" 
			(strg_l = cons(14 strg_l))
		    ) 
		    ("F" 
			(strg_l = cons(15 strg_l))
		    ) 
		    (t 
			printf("--HEX2RGB: was ist das -> %L\n" i)
		    )
		)
	    )
	) 
	(strg_l = reverse(strg_l))
	(B = ((caddr(strg_l) * 16) + nth(3 strg_l))) 
	(G = ((nth(4 strg_l) * 16) + 
		nth(5 strg_l))) 
	(R = ((nth(6 strg_l) * 16) + 
		nth(7 strg_l))) 
	list(R G B)
    )
)
procedure(TRL_ALTIUM2PCB_Util_Convert_Long2RGB(long) 
    let((R G B) 
	(B = (long / 65536)) 
	(G = ((long - (B * 65536)) / 256)) 
	(R = (long - (B * 65536) - (G * 256))) 
	list(R G B)
    )
)
procedure(TRL_ALTIUM2PCB_Util_DesignUnits(input) 
    let((string num uni negativ new_val) 
	(num = list()) 
	(uni = list()) 
	(negativ = nil) 
	if(input then 
	    (string = parseString(input "")) 
	    when((car(string) == "-") 
		(negativ = t)
	    ) 
	    foreach(char string 
		if((atoi(char) || (char == ".")) then 
		    (num = cons(char num)) else 
		    (uni = cons(char uni))
		)
	    )
	    if((num && uni) then 
		(num = atof(buildString(reverse(num) ""))) 
		(uni = buildString(reverse(uni) "")) else
		(num = 0.0) 
		(uni = "mil") 
		(axlUIWPrint 
		    (trl_altium2pcb_global->formid) "-->2.1.04 ERROR - Unit Data Mismatch!!"
		) 
		(trl_altium2pcb_global->exeption = cons("-->2.1.04 ERROR   - Unit Data Mismatch!!" 
			(trl_altium2pcb_global->exeption)
		    ))
	    ) else 
	    (num = 0.0) 
	    (uni = "mil") 
	    (axlUIWPrint 
		(trl_altium2pcb_global->formid) "-->2.1.03 WARNING - Unit Data Missing!!"
	    )
	    (trl_altium2pcb_global->exeption = cons(sprintf(nil "-->2.1.03 WARNING - Unit Data Missing!! -> %L" input) 
		    (trl_altium2pcb_global->exeption)
		))
	)
	(new_val = (axlMKS2UU 
		sprintf(nil "%f %s" num uni)
	    )) 
	(new_val = TRL_MATH_Round(new_val "absolute" 2)) 
	when(negativ 
	    (new_val = (new_val * -1))
	) new_val
    )
)
procedure(TRL_ALTIUM2PCB_Util_Find_Layer_Number(layer_name) 
    let((lay_nr) 
	when((layer_name == "TOP") 
	    (lay_nr = 1)
	) 
	when((layer_name == "BOTTOM") 
	    (lay_nr = 32)
	) 
	for(index 1 30 
	    when((sprintf(nil "MID%d" index) == layer_name) 
		(lay_nr = (index + 1))
	    ) 
	    index++
	) 
	for(index 1 16 
	    when((sprintf(nil "PLANE%d" index) == layer_name) 
		(lay_nr = (index + 38))
	    ) 
	    index++
	)
	lay_nr
    )
)
procedure(TRL_ALTIUM2PCB_Util_Get_Class(class_name) 
    let((classes c_name class_list index result
	    mx
	) 
	(classes = cadr((trl_altium2pcb_global->PcbRawList))) 
	foreach(rec classes 
	    (c_name = get(rec 
		    'NAME
		)) 
	    when((c_name == class_name) 
		(class_list = list()) 
		(index = 0) 
		(result = t) 
		while(result 
		    (mx = stringToSymbol(sprintf(nil "M%d" index))) 
		    (mx = get(rec mx)) 
		    if(mx then 
			(class_list = cons(mx class_list)) else 
			(result = nil)
		    ) 
		    index++
		)
	    )
	) class_list
    )
)
procedure(TRL_ALTIUM2PCB_Util_Namemaper(input) 
    if(input then 
	rexCompile(" ") 
	(input = rexReplace(input "_" 0)) 
	rexCompile("[][(\"{!/%*+$@=<>&?#:.,'\\})]+")
	(input = rexReplace(input "_" 0)) else 
	(input = "NIL-NAMEMAPPER")
    )
)
procedure(TRL_ALTIUM2PCB_Util_NetName_Namemaper(input) 
    if(input then 
	rexCompile(" ") 
	(input = rexReplace(input "_" 0)) 
	rexCompile("[\\!']+")
	(input = rexReplace(input "_" 0)) else 
	(input = "NIL-NAMEMAPPER")
    )
)
procedure(TRL_ALTIUM2PCB_Util_Sort_Layer_Stack() 
    let((layer_stack layer_nr new_layer new_layer_stack) 
	(layer_stack = reverse((trl_altium2pcb_global->LayerStack))) 
	(layer_nr = 1) 
	(new_layer = list()) 
	(new_layer_stack = list())
	for(index 1 
	    length(layer_stack) 
	    foreach(layer layer_stack 
		when((car(layer) == layer_nr) 
		    (new_layer = layer)
		)
	    ) 
	    when(new_layer 
		(layer_nr = nth(3 new_layer)) 
		(new_layer_stack = cons(new_layer new_layer_stack)) 
		(new_layer = list())
	    )
	    index++
	) 
	reverse(new_layer_stack)
    )
)
procedure(TRL_ALTIUM2PCB_flow_graphic(handle) 
    let((increment center_x center_y diameter) 
	(axlGRPDrwMapWindow handle 0 0) 
	(increment = (axlFormGetField 
		(trl_altium2pcb_global->formid) "graphic_space"
	    )) 
	(center_x = (axlFormGetField 
		(trl_altium2pcb_global->formid) "graphic_center_x"
	    )) 
	(center_y = (axlFormGetField 
		(trl_altium2pcb_global->formid) "graphic_center_y"
	    ))
	(diameter = (axlFormGetField 
		(trl_altium2pcb_global->formid) "graphic_size"
	    )) 
	foreach(color 
	    car((trl_altium2pcb_global->GUI)) 
	    putprop(handle "filled" 
		'fill
	    ) 
	    putprop(handle color 
		'color
	    ) 
	    (axlGRPDrwCircle handle 
		(center_x:center_y) diameter
	    )
	    (center_y = (center_y + increment))
	)
    )
)
procedure(TRL_HELP_Get_Version() 
    let((trl_version) 
	(trl_version = "17.4.03 Build Date: Dec 06 2017") 
	printf("Translator Version: %s\n" trl_version) trl_version
    )
)
procedure((TRL_HELP_Launch \@optional module_name) 
    let((cmd floware_doc_path html_file) 
	if((module_name && (lowerCase(cdsPlat()) == "wint")) then 
	    if(isDir(sprintf(nil "%s/local/doc/%s" 
			axlGetVariable("allegro_install_root") module_name
		    )
		) then 
		(cmd = sprintf(nil "cdnshelp FloWare %s" module_name)) 
		(axlShell cmd) else
		(floware_doc_path = strcat(axlGetVariable("allegro_install_root") "/share/pcb/translators/help")) 
		(floware_doc_path = (axlOSSlash floware_doc_path)) 
		(cmd = sprintf(nil "acroread %s/%s.pdf" floware_doc_path module_name)) 
		(axlShell cmd)
	    ) else 
	    (html_file = sprintf(nil "file:///%s/share/pcb/translators/help/trl.htm" 
		    axlGetVariable("allegro_install_root")
		))
	    (cmd = sprintf(nil "http %s" html_file)) 
	    (axlShell cmd)
	)
    )
)
procedure(TRL_LIC_Validate() 
    let((ok_translate license_used) 
	(license_used = (axlLicIsProductEnabled 
		'all
	    )) 
	if((!license_used || exists(x license_used 
		    (upperCase(x) == "ALLEGRO_VIEWER_PLUS")
		)) then 
	    (ok_translate = nil) 
	    printf("Error: Alitum translator not supported in lite or viewer mode.\n") else
	    (ok_translate = t)
	) ok_translate
    )
)
procedure((TRL_MATH_Round data \@optional mode acc) 
    let((design_accuracy new_accuracy factor return_data int_value
	    dec_value
	) 
	(design_accuracy = cadr((axlDBGetDesignUnits))) 
	(new_accuracy = design_accuracy) 
	when((mode && acc) 
	    case(mode 
		("absolute" 
		    (new_accuracy = acc)
		) 
		("reduce" 
		    (new_accuracy = (design_accuracy - acc)) 
		    when((new_accuracy < 0) 
			(new_accuracy = 0)
		    )
		) 
		(t 
		    printf("Warning: Unknown rounding mode %L\n" mode) 
		    (new_accuracy = design_accuracy)
		)
	    )
	) 
	(factor = ((10**new_accuracy) * 1.0))
	cond(((eq(type(data) 
			'flonum
		    ) || eq(type(data) 
			'fixnum
		    )) 
		(int_value = int(data)) 
		(dec_value = (data - int_value)) 
		(dec_value = (dec_value * factor)) 
		(dec_value = round(dec_value))
		(dec_value = (dec_value / factor)) 
		(return_data = (int_value + dec_value))
	    ) 
	    (eq(type(data) 
		    'list
		) 
		foreach(entry data 
		    (int_value = int(entry)) 
		    (dec_value = (entry - int_value)) 
		    (dec_value = (dec_value * factor))
		    (dec_value = round(dec_value)) 
		    (dec_value = (dec_value / factor)) 
		    (return_data = cons((int_value + dec_value) return_data))
		) 
		(return_data = reverse(return_data))
	    )
	) return_data
    )
)
