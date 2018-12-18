
/*###########################################################
#  Function : 
#  Descript : 窗口显示函数,
#  Input    :      
#  Output   : 
#  Author   : 王恒辉
#  mail     ：wanghhb@landicorp.com
###########################################################*/

/*
MenuFile = strcat("ATTRIB -R " axlOSSlash(getShellEnvVar("CDSROOT")) 
	"/share/pcb/text/cuimenus/allegro.men"
)
shell(MenuFile)
*/
SkillPath = strcat(axlOSSlash(getShellEnvVar("LD_SKILL_PATH")) "/" "Skill")
FormPath = strcat(axlOSSlash(getShellEnvVar("LD_SKILL_PATH")) "/" "Form/")

axlSetAlias( "~Q" "skill LD_SkillStart")
axlSetAlias( "~W" "skill LD_CNS_Setting")
defun(LD_SkillStart ()
let(()
	List_Error = '()
	LD_AddMenu()
	
	;ChangeToCH()
	;Check_Marker()
	;Check_No2SMT()
	;Change_TO_Outline()
	;Check_Past_To_Past(0.25)
	;----------
	;Check_NoCon()
	;Check_KeyVia(0.6)
	;Check_ViaInRCL()
	;Check_Thermal(0.2)
	;Check_ViaI(1.34)
	;-----------------
	;Check_DFT_Tp2FixHoles()
	;Check_DFT_Tp2HighPlaceBound()
	;SilkOnSold()
	;WaveSold()
	;TPOnDiffpair()
	;TPToBGA(5)
	;TPNumber(4)
	;--------------
	;LD_CheckTools()
	;Check_USBLayout()
	;LD_Encrypt_File()
	;Page_Playce()
	;MeshLayout()
	;TP_XY_Checking()
	;Layout_Tools()
	;CNS_Test()
	;lcbAddDevLabel()
	;align_sym()
	;Centre_Text()
	;List_Symbel_pad()
	;LD_CNS_Int()
	;Del_NoTP()
	;LD_Design_Setting()
	;LD_CNS_Setting()
	;OutFiles_WJG()
	;axlShell("OutFiles_WJG")
	;Files_Input()
	;OutFiles_Gerber()
	;test()
	;CMenuList()
	;Add_RA4_DML_Model()
	;Add_Con_DML_Model()
	;Add_SI_Model()
	;Add_SI_Model_RLC()
	;IO_3DFile()
	;Addmenu()
	;Form2il()
	;NoMount()
	;OutWJG()
	;Valor_Mark()
	;Pad_Bom()
)
)


deleteFile("allegro.men")

axlCmdRegister("LD_AddMenu" 'LD_AddMenu)
defun(LD_AddMenu ()
let((MenuFile)
	axlUIMenuDump("menu.txt")
	MenuFile = "menu.txt"
	ChangeMenu(MenuFile t)
)
)

defun(ChangeMenuFile ()
let((MenuFile)
	MenuFile = strcat(axlOSSlash(getShellEnvVar("CDSROOT")) 
		"/share/pcb/text/cuimenus/allegro.men"
	)
	ChangeMenu(MenuFile nil)
)
)


defun(ChangeMenu (S_File Y_del)
let((q FilesMenu L_menu Top_Menu Bot_Menu LD_Menu PassWord CurDir CurilFileList)
	FilesMenu = infile(S_File)
	L_menu = '()
	while(gets(n0 FilesMenu)
		L_menu = append1(L_menu n0)
	)
	close(FilesMenu)
	LD_Menu = '(
		"    POPUP \"L&D Tools\"\n"
		"    BEGIN\n"
		"        MENUITEM \"[Working Directory]\",\t\t\"filemgr\"\n"
		"        MENUITEM \"[Update Tools]\",\t\t\t\"LD_AddMenu\"\n"
		"        MENUITEM \"[Clean File]\",\t\t\t\"LD_Clean\"\n"
		"        MENUITEM SEPARATOR\n"
	)
	LD_Menu0 = '(
		"        MENUITEM SEPARATOR\n"
		"        MENUITEM \"[Email For Help]\",\t\t\"LD_Help\"\n"
		"        MENUITEM \"[About...]\",\t\t\t\"LD_Abaout\"\n"
		"    END\n"
	)
	foreach(n0 getDirFiles(SkillPath)
		if(isDir(strcat(SkillPath "/" n0)) && rexMatchp("^[0-9][.]" n0) then
			CurDir = strcat(SkillPath "/" n0)
			CurilFileList = rexMatchList("^[0-9][.].+[=].+[=].*.il$" getDirFiles(CurDir))
			when(CurilFileList
				LD_Menu = append1(LD_Menu strcat("        POPUP \"" n0 "\"\n"))
				LD_Menu = append1(LD_Menu "        BEGIN\n")
				foreach(n1 CurilFileList
					PassWord = nth(2 parseString(substring(n1 1 strlen(n1)-3) "="))
					load(strcat(CurDir "/" n1) PassWord)
					LD_Menu = append1(LD_Menu 
						strcat("            MENUITEM \"" car(parseString(n1,"=")) "\", \t\t\"" 
							cadr(parseString(n1,"=")) "\"\n"
						)
					)
				)
				LD_Menu = append1(LD_Menu "        END\n")
			)
		)
	)
	LD_Menu = append(LD_Menu LD_Menu0)

	if(rexMatchList("    POPUP \"L&D Tools\"\n" L_menu) then  			
		Top_Menu = remove("    POPUP \"L&D Tools\"\n" 
			reverse(member("    POPUP \"L&D Tools\"\n" reverse(L_menu)))
		)
	else
		Top_Menu = L_menu
	)
	if(rexMatchList("    POPUP \"&Help\"\n" Top_Menu) then
		Top_Menu = remove("    POPUP \"&Help\"\n" 
			reverse(member("    POPUP \"&Help\"\n" reverse(L_menu)))
		)
	)
	Bot_Menu = member("    POPUP \"&Help\"\n" L_menu)
	L_menu = append(Top_Menu LD_Menu)
	L_menu = append(L_menu Bot_Menu)
	FilesMenu = outfile(S_File)
	foreach(n0 L_menu
		fprintf(FilesMenu "%s" n0)
	)
	close(FilesMenu)
	when(Y_del
		axlUIMenuLoad(S_File)
		deleteFile(S_File)
	)
	t
)
)






/*

defun(Add_SI_Model ()
let((AllCom Ndx_ModelValue)
	AllCom = axlDBGetDesign()->components
	foreach(n0 AllCom	
		if(n0->class == "DISCRETE" || n0->class == "IO" then
			foreach(n1 n0->pins
				axlDBAddProp(n1 list("PINUSE" "UNSPEC"))
			)
		)
		unless(rexMatchp("^R_R+" n0->deviceType) || rexMatchp("^C_C+" n0->deviceType)
			ComValue = lastelem(assoc('VALUE axlDBGetProperties(n0->compdef)))
			NdxFileInport = infile("X:/work/skill/Silib/DML_Model/NdxLib.ndx")
			while(gets(n1 NdxFileInport)
				if(car(parseString(n1)) == "PackagedDevice" then
					Ndx_ModelValue = lastelem(parseString(nth(1 parseString(n1)) "_"))
					if(rexMatchp(Ndx_ModelValue ComValue) then
						axlDBAddProp(n0 list("SIGNAL_MODEL" nth(1 parseString(n1))))
						
					)
				)
			)
			close(NdxFileInport)
		)
	)
)
)


defun(Add_SI_Model_RLC ()
let((CapValue N_Value S_Value List_R List_C PortOutFile_DML)
	List_RC = axlSelectByName("DEVTYPE" list("C_C*" "R_R*" "FB_*") t)
	axlClearSelSet()
	foreach(n0 List_RC		
		foreach(n1 n0->pins
			axlDBAddProp(n1 list("PINUSE" "UNSPEC"))
		)
		CapValue = upperCase(lastelem(assoc('VALUE axlDBGetProperties(n0->compdef))))
		cond(
			(rexMatchp("^C_C*" n0->deviceType)
				cond(
					(rexMatchp("[0-9]PF+" CapValue)
						rexCompile( "[A-Z ]+" )
						CapValue = rexReplace(CapValue "" 0)
						N_Value = atof(CapValue) * expt(10 -12)
					)
					(rexMatchp("[0-9]NF+" CapValue)
						rexCompile( "[A-Z]+" )
						CapValue = rexReplace(CapValue "" 0)
						N_Value = atof(CapValue) * expt(10 -9)
					)
					(rexMatchp("[0-9]UF+" CapValue)
						rexCompile( "[A-Z]+" )
						CapValue = rexReplace(CapValue "" 0)
						N_Value = atof(CapValue) * expt(10 -6)
					)
					(rexMatchp("^[0-9][0-9][0-9]" CapValue)
						CapValue = substring(CapValue 1 3)
						N_Value = atoi(substring(CapValue 1 2)) * expt(10 atoi(substring(CapValue 3 3))) * expt(10 -12)
					)
					(t
						N_Value = nil
						S_Value = nil
						println(n0->deviceType)
					)
				)
				when(N_Value && atof(CapValue)
					cond(
						(N_Value < expt(10 -9)
							S_Value = strcat("CAP_" sprintf(nil "%g" atof(CapValue)) "PF")
						)
						(N_Value < expt(10 -6)
							S_Value = strcat("CAP_" sprintf(nil "%g" N_Value*expt(10 9)) "NF")
						)
						(N_Value <= expt(10 -3)
							S_Value = strcat("CAP_" sprintf(nil "%g" N_Value*expt(10 6)) "UF")
						)
					)
				)
			)
			(rexMatchp("^R_R*" n0->deviceType)
				cond(
					(rexMatchp("[0-9]K+" CapValue)
						rexCompile( "[A-Z]+" )
						CapValue = rexReplace(CapValue "" 0)
						N_Value = atof(CapValue) * expt(10 3)
					)
					(rexMatchp("[0-9]M+" CapValue)
						rexCompile( "[A-Z]+" )
						CapValue = rexReplace(CapValue "" 0)
						N_Value = atof(CapValue) * expt(10 6)
					)
					(rexMatchp("^[0-9]+" CapValue)
						N_Value = atof(CapValue)
						rexCompile( "[A-Z ]+" )
						CapValue = rexReplace(CapValue "" 0)
					)
					(rexMatchp("[0-9]+" CapValue)
						N_Value = atof(CapValue)
						rexCompile( "[A-Z ]+" )
						CapValue = rexReplace(CapValue "" 0)
					)
					(t
						N_Value = nil
						S_Value = nil
						println(n0->deviceType)
					)
				)
				when(N_Value && atof(CapValue)
					cond(
						(N_Value < expt(10 3)
							S_Value = strcat("RES_" CapValue)
						)
						(N_Value < expt(10 6)
							S_Value = strcat("RES_" sprintf(nil "%g" N_Value*expt(10 -3)) "K")
						)
						(N_Value <= expt(10 9)
							S_Value = strcat("RES_" sprintf(nil "%g" N_Value*expt(10 -6)) "M")
						)
					)
				)
			)
			(rexMatchp("^FB_L*" n0->deviceType)
				S_Value = "RES_0"
			)
			(t
				S_Value = nil
			)
		)
		;
		;println(axlDBGetProperties(n0))
		;println(n0->class)
		when(S_Value
			;axlDBAddProp(n0 list("SIGNAL_MODEL" S_Value))
			Add_RCL_DML_Model(S_Value N_Value)
		)
	)
)
)



defun(Add_RCL_DML_Model (S_Name N_ObjValue)
let((Z ZZ FinPort FoutPort ExitYes lastline)
	ExitYes = nil
	ZZ = "X:/work/skill/Silib/DML_Model/Si_RLC.dml"
	FinPort = infile(ZZ)
	Z = axlTempFile()
	FoutPort = outfile(Z)
	while(gets(n0 FinPort)
		if(n0 == strcat("  (\"" S_Name "\"\n") then
			ExitYes = t
		)
		if(rexMatchp(".*LibraryVersion*" n0) then
			close(FinPort)
			lastline = n0
		else
			if("    (2 1 ) ) ) ) \n" == n0 then
				fprintf(FoutPort "    (2 1 ) ) ) \n" )
			else
				fprintf(FoutPort "%s" n0)
			)
		)
	)
	unless(ExitYes
		fprintf(FoutPort "  (\"%s\"\n" S_Name)
		fprintf(FoutPort "   (ESpice \".subckt %s 1 2\n" S_Name)
		fprintf(FoutPort "    %s1 1 2 %g\n" getchar(S_Name 1) N_ObjValue)
		fprintf(FoutPort "    .ends %s\n" S_Name)
		fprintf(FoutPort "    \" )\n" )
		fprintf(FoutPort "   (PinConnections \n" )
		fprintf(FoutPort "    (1 2 )\n" )
		fprintf(FoutPort "    (2 1 ) ) ) ) \n" )
		fprintf(FoutPort "%s" lastline)
	)
	close(FoutPort)
	unless(ExitYes
		axlOSFileCopy(Z ZZ nil)
	)
	axlTempFileRemove(Z)

)
)

defun(Add_RA4_DML_Model ()
let((CapValue N_Value)
	foreach(n0 axlDBGetDesign()->compdefs
		cond(
			(rexMatchp("^RA4_RA4*" n0->deviceType)
				CapValue = upperCase(lastelem(parseString(n0->deviceType "_")))
				cond(
					(rexMatchp("[0-9]K+" CapValue)
						rexCompile( "[A-Z]+" )
						CapValue = rexReplace(CapValue "" 0)
						N_Value = atof(CapValue) * expt(10 3)
					)
					(rexMatchp("[0-9]M+" CapValue)
						rexCompile( "[A-Z]+" )
						CapValue = rexReplace(CapValue "" 0)
						N_Value = atof(CapValue) * expt(10 6)
					)
					(rexMatchp("^[0-9]+" CapValue)
						N_Value = atof(CapValue)
						rexCompile( "[A-Z ]+" )
						CapValue = rexReplace(CapValue "" 0)
					)
					(rexMatchp("[0-9]+" CapValue)
						N_Value = atof(CapValue)
						rexCompile( "[A-Z ]+" )
						CapValue = rexReplace(CapValue "" 0)
					)
					(t
						N_Value = nil
						S_Value = nil
						println(n0->deviceType)
					)
				)
				when(N_Value && atof(CapValue)
					cond(
						(N_Value < expt(10 3)
							S_Value = strcat("RA4_" CapValue)
						)
						(N_Value < expt(10 6)
							S_Value = strcat("RA4_" sprintf(nil "%g" N_Value*expt(10 -3)) "K")
						)
						(N_Value <= expt(10 9)
							S_Value = strcat("RA4_" sprintf(nil "%g" N_Value*expt(10 -6)) "M")
						)
					)
				)
				when(S_Value
					axlDBAddProp(n0 list("SIGNAL_MODEL" S_Value))
				)
			)
			(rexMatchp("^CD_CD*" n0->deviceType) || rexMatchp("^CT_CT*" n0->deviceType)
				CapValue = upperCase(lastelem(parseString(n0->deviceType "_")))
				CapValue = upperCase(car(parseString(CapValue "/")))
				S_Value = strcat("CD_" CapValue)
				N_Value = atof(CapValue) * expt(10 -6)
				axlDBAddProp(n0 list("SIGNAL_MODEL" S_Value))
				Add_RCL_DML_Model(S_Value N_Value)
			)
			(
			
			)
			(
			
			)
			(
			
			)
		
		)
	)
)
)
*/


/*
-----------------------------------
函数：LD_CNS_Int()
输入：无
说明：约束设置初始化（zz需求）
----------------------------------


defun(LD_CNS_Int ()
let((CnsDesignValue_Int)
	CnsDesignValue_Int = '((Negative_Plane_Islands 0.0) (Pad_Soldermask_Alignment 0.0) (Pad_Soldermask_to_Pad_Soldermask_Spacing 3.0) (Pad_Pastemask_to_Pad_Pastemask_Spacing 7.9) (Soldermask_to_Pad_and_Cline_Spacing 2.0) (Soldermask_to_Shape_Spacing 2.0) (Testpoint_Pad_to_Component_Spacing 0.0) (Testpoint_Location_to_Component_Spacing 0.0) (Mechanical_Drill_Hole_to_Mechanical_Drill_Hole_Spacing 0.0) (Mechanical_Drill_Hole_to_Line_Spacing 0.0) (Minimum_Bonding_Wire_Length 0.0) (Maximum_Bonding_Wire_Length 0.0) (Negative_Plane_Antipad_to_Plane_Boundary_Spacing 0.0))
	CnsDesignMode_Int = '((Package_to_Package_Spacing on) (Package_to_Place_Keepin_Spacing on) (Package_to_Place_Keepout_Spacing on) (Package_to_Room_Spacing on) (Negative_Plane_Islands on) (Pad_Soldermask_Alignment off) (Pad_Soldermask_to_Pad_Soldermask_Spacing on) (Pad_Pastemask_to_Pad_Pastemask_Spacing on) (Soldermask_to_Pad_and_Cline_Spacing on) (Soldermask_to_Shape_Spacing on) (Testpoint_Pad_to_Component_Spacing off) (Testpoint_Location_to_Component_Spacing off) (Testpoint_Under_Component off) (Mechanical_Drill_Hole_to_Mechanical_Drill_Hole_Spacing off) (Mechanical_Drill_Hole_to_Line_Spacing off) (Etch_turn_under_SMD_pad on) (Via_at_SMD_pad on) (Via_at_SMD_fit on) (Via_at_SMD_thru off) (Minimum_Bonding_Wire_Length off) (Maximum_Bonding_Wire_Length off) (Thru_Pin_to_Route_Keepout_Spacing on) (Negative_Plane_Antipad_to_Plane_Boundary_Spacing off))
	CnsEcsetMode_Int = '((Maximum_Stub_Length off) (Maximum_Via_Count off) (Match_Via_Count off) (Maximum_Exposed_Length off) (Impedance off) (Propagation_Delay off) (Relative_Propagation_Delay off) (Parallelism off) (Maximum_Crosstalk off) (Maximum_Peak_Crosstalk off) (Total_Etch_Length off) (Differential_Pair_Primary_Gap off) (Minimum_Line_Width on) (Maximum_Line_Width off) (LayerSet_group off))
	CnsPhysicalMode_Int = '((allow_padconnect on) (allow_ts on) (allow_etch on) (bbvia_stagger_max off) (bbvia_stagger_min on) (vias on) (width_max off) (width_min on))
	axlCNSDesignValueSet(CnsDesignValue_Int)
	axlCNSDesignModeSet(CnsDesignMode_Int)
	axlCNSEcsetModeSet(CnsEcsetMode_Int)
	axlCNSPhysicalModeSet(CnsPhysicalMode_Int)
	axlCNSSpacingModeSet('all 'on)
	axlCNSSameNetModeSet('all 'on)
	axlDRCUpdate(t)
)
)


*/


/*
-----------------------------------
函数：List_Symbel_pad()
输入：无
说明：统计封装，焊盘函数(张野需求)。
----------------------------------

defun(List_Symbel_pad ()
let((filename logfile)
	changeWorkingDir("G:/symbol")
	filename = getDirFiles("G:/symbol")
	logfile = outfile("List_Symbel_pad.txt")
	foreach(n0 filename
		if(rexMatchp(".dra$" n0) then
			axlOpenDesign(?design n0)
			;println(axlDBGetDesign()->??)
			fprintf(logfile "%s" n0)
			axlSetFindFilter(?enabled '("NOALL" "PINS") ?onButtons '("ALLTYPES"))
			axlAddSelectAll()
			foreach(n1 axlGetSelSet()
				fprintf(logfile "\t%s" n1->name)
				fprintf(logfile "\t%s\n" n1->number)
			)
			;axlClearSelSet()
		)
	)
	close(logfile)
)
)

*/




/*
-----------------------------------
函数：LD_Encrypt_File()
输入：无
说明：加密il文件。
----------------------------------
*/

axlCmdRegister("LD_Encrypt_File" 'LD_Encrypt_File)
defun(LD_Encrypt_File ()
let((NoEncrypt_File_Dirlist)
	NoEncrypt_File_Dirlist = rexMatchList("^[0-9].+$" getDirFiles("X:/work/skill/LD_SKILL/Skill/"))	
	shell("
		rd /s /q F:/LD_SKILL/Skill
		md F:/LD_SKILL/Skill/
		del /f /s /q F:/LD_SKILL/Form/*.*
		xcopy X:/work/skill/LD_SKILL/Form/*.* F:/LD_SKILL/Form/
		del /f /s /q F:/LD_SKILL/Picture/*.*
		xcopy X:/work/skill/LD_SKILL/Picture/*.* F:/LD_SKILL/Picture
	")
	foreach(n0 NoEncrypt_File_Dirlist
		createDir(strcat("F:/LD_SKILL/Skill/" n0 "/"))
		foreach(n1 rexMatchList("^[0-9].+$" getDirFiles(strcat("X:/work/skill/LD_SKILL/Skill/" n0)))
			encrypt(strcat("X:/work/skill/LD_SKILL/Skill/" n0 "/" n1) strcat("F:/LD_SKILL/Skill/" n0 "/" n1) "wanghhb")
		)
	)
	encrypt("X:/work/skill/LD_SKILL/LD_Skill_Load.il" "F:/LD_SKILL/LD_Skill_Load.il" "wanghhb")
	
)
)

;encrypt("X:/work/skill/H_SKILL/H_Skill_Load.il" "D:/H_Skill_Load.il" "wanghhb")
;encrypt("X:/work/skill/H_SKILL/3.Cut Shape=cutshape=wanghhb.il" "F:/3.Cut Shape=cutshape=wanghhb.il" "wanghhb")
;3.Cut Shape=cutshape=wanghhb.il
;AddHTime(10)


/*
------------------------------------------------------
函数：LD_Help()
输入：无
说明：跳出邮件发送窗口，邮件地址为：wanghhb@landicorp.com
------------------------------------------------------
*/
axlCmdRegister("LD_Help" 'LD_Help)
defun(LD_Help ()
	unless(shell("start Mailto:wanghhb@landicorp.com")
		printf("\307\353\260\262\327\260outlook.................")
	)
)


/*
------------------------------------------------------
函数：LD_Clean()
输入：无
说明：跳出邮件发送窗口，邮件地址为：wanghhb@landicorp.com
------------------------------------------------------
*/
axlCmdRegister("LD_Clean" 'LD_Clean)
defun(LD_Clean ()
	shell("
		del /f /s /q  *.log
		del /f /s /q  *.dbk
		del /f /s /q  *.opj
		del /f /s /q  *.jrl
		del /f /s /q  *.cnv
		del /f /s /q  *.sav
		del /f /s /q  *.ldf
		del /f /s /q  *.csv
		del /f /s /q  *.xml
		del /f /s /q  *.bdf
		del /f /s /q  *.tag
		del /f /s /q  *.form
		rd /s /q Indesign
		rd /s /q signoise.run
	")
)




/*
------------------------------------------------------
函数：LD_Abaout()
输入：无
说明：工具说明
------------------------------------------------------
*/
axlCmdRegister("LD_Abaout" 'LD_Abaout)
defun(LD_Abaout ()
	axlUIConfirm("Landi SKILL")
)




/*
; 获取时间，day，month，year，date

        time = getCurrentTime()
        time = parseString(time)
        day = nth(1 time)
        month = car(time)
        month = upperCase(month)
				year = nth(3 time)
        date = strcat(" Date: " day " " month " " year)
        axlUIWPrint(myform date)  ;窗口上显示时间

defun(loadchina (fileName @optional password)
	let((chin enout list11 list12 list13)
		chin = infile(fileName)
		enout = outfile("tempfile.il")
		when(chin
			while(gets(w chin)
				rexCompile("Ch2En\\(.+\\)")
				if(rexExecute(w) then
					list11 = rexSubstitute("\\0")
					println(list11)
					list12 = substring(list11 1 nindex(list11 ")"))
					list13 = stringToSymbol(cadr(parseString(list12 "()")))
					printf("%s" substring(w 1 nindex(w list12)-1))
					printf("%L" list13)
					printf("%s" substring(w nindex(w list12)+strlen(list12) strlen(w)))
				else
					printf("%s" w)
				)
			)
			close(chin)
		)
		close(enout)
		if(password then
			load("tempfile.il" password)
		else
			load("tempfile.il")
		)
		axlTempFileRemove("tempfile.il")
		t
	)
)

*/


;ChangeMenuFile()

;AliasSetting()