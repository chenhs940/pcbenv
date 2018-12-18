procedure(loadiii()
;loadi(strcat(axlOSSlash(getShellEnvVar("HOME")) "/pcbenv/LD_Skill_Load.il") "chenhs");
loadi(strcat(axlOSSlash(getShellEnvVar("HOME")) "/pcbenv/test2.il") "chenhs");
;loadi(strcat(axlOSSlash(getShellEnvVar("HOME")) "/pcbenv/1.test=test=test.il") "chenhs");
loadi(strcat(axlOSSlash(getShellEnvVar("HOME")) "/pcbenv/auto_text_20161025.il") "chenhs");
axlShell("generaledit")
);procedure



procedure(MyStart()
defvar(count 0)
form = axlFormCreate(gensym() "replace.form" `("E" "OUTER") `chs_Callback t)
axlFormDisplay(form) 
defvar(listVIA nil)
listVIA = axlGetAllViaList()
for(i 0 length(listVIA)-1
	;axlFormListAddItem(form "AllPin" nth(i listVIA)->name -1)
	t
)
printf("111");
axlFormListAddItem(form "AllPin" "SMD1_5C1_5NP" -1)
axlFormListAddItem(form "AllPin" "SMDR2M30X2M50" -1)
axlFormListAddItem(form "AllPin" "SMDQ0M60" -1)
axlFormListAddItem(form "AllPin" "SMDR6M00X7M00" -1)
axlFormListAddItem(form "AllPin" "SMDF0M60X2M00" -1)
axlFormListAddItem(form "AllPin" "SMDR1M02X1M22" -1)
println(axlAddSelectAll())
;axlFormSetField(form "silk_layer" "TOP");
;axlFormSetField(form "silk_size" "3");
;axlFlushDisplay()
;axlVisibleUpdate(t)
)

procedure(Get_Total_Dist()
	center1_x = (caar(l_first_dbid->bBox) + caadr(l_first_dbid->bBox))/2;
	center1_y = (cadar(l_first_dbid->bBox) + cadadr(l_first_dbid->bBox))/2;
	center2_x = (caar(l_second_dbid->bBox) + caadr(l_second_dbid->bBox))/2;
	center2_y = (cadar(l_second_dbid->bBox) + cadadr(l_second_dbid->bBox))/2;
	Dx = abs(center1_x-center2_x)
	Dy = abs(center1_y-center2_y)
	sqrt(expt(abs(center1_x - center2_x) 2) + expt(abs(center1_y - center2_y) 2))
)

procedure(Get_Air_Out()
	left1 = caar(l_first_dbid->bBox)
	left2 = caar(l_second_dbid->bBox)
	buttom1 = cadar(l_first_dbid->bBox)
	buttom2 = cadar(l_second_dbid->bBox)
	if((left1<=left2) then
		dx = abs(caar(l_first_dbid->bBox)-caadr(l_second_dbid->bBox))
		if((buttom1<=buttom2) then
			dy = abs(cadar(l_first_dbid->bBox)-cadadr(l_second_dbid->bBox))
			else
			dy = abs(cadadr(l_first_dbid->bBox) - cadar(l_second_dbid->bBox))
		)
		else
		dx = abs(caar(l_second_dbid->bBox)-caadr(l_first_dbid->bBox))
		if((buttom1<=buttom2) then
			dy = abs(cadar(l_first_dbid->bBox)-cadadr(l_second_dbid->bBox))
			else
			dy = abs(cadadr(l_first_dbid->bBox) - cadar(l_second_dbid->bBox))
		)
	)
		printf("\n\n\n")
		;printf("dx = %f,,,dy = %f " dx dy)
		sqrt(expt(dx 2)+expt(dy 2))

)

procedure(chs_Callback(form)
case((form->curField)
	("measure" printf("measure")
	axlFormSetField(form "Select_Pin" "")
		count++
		axlSubSelectAll()
		axlSetFindFilter(?enabled '("PINS") ?onButtons '("ALLTYPES"))
		while(length(axlGetSelSet()) < 1
			axlSingleSelectPoint(axlEnterPoint())
		)
		
			println("select PINS")
			defvar(Select_list)
			Select_list = axlGetSelSet();
			println(car(Select_list)->name)
			axlFormSetField(form "Select_Pin" car(Select_list)->name)
			
	)
	("aquit"
		axlReplacePadstack(car(Select_list) axlFormGetField(form "Replace_Pin"))
		
		axlSubSelectAll()
		
	)
	("AllPin"
		printf("Allpin");
		;println(axlFormListGetSelItems(form "AllPin"))
		axlFormSetField(form "Replace_Pin" car(axlFormListGetSelItems(form "AllPin")))
	
	)
)
)


;_ashTestDll = axlDllOpen("axlecho_plugin")
;_ashEcho = axlDllSym(_ashTestDll "ashEcho")
;_chenhs = axlDllSym(_ashTestDll "chenhs")
;axlDllCall(_ashEcho "inl" ret);

;printf("%L" axlDllDump())
    ;ret = axlDllCall(_ashEcho 3 2.0 t "is a string" 10.1:20.2)
    ;ret = axlDllCall(_chenhs 3 2.0 t "is a string" 10.1:20.2)
    ;printf("Return  %L\n" ret)
  
;print(axlDllDump())
   ; axlDllClose(_ashTestDll)
;printf(out)