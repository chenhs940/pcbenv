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
	axlFormListAddItem(form "replaceVIA" nth(i listVIA)->name -1)
)

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
		count++
		axlSetFindFilter(?enabled '("VIAS") ?onButtons '("ALLTYPES"))
		while(length(axlGetSelSet())<count
			axlAddSelectPoint(axlEnterPoint())
			println("select VIA")
		)
		;printf("\n\n\n");
		;println(car(axlGetSelSet())->??)
		axlFormListAddItem(form "selectVIA" car(axlGetSelSet())->name -1)
		println(axlGetAllViaList())
	)
	("aquit"
		println(axlFormListGetSelItems(form "replaceVIA"))
		foreach(x listVIA
		println(x)
			if(strcmp(car(axlFormListGetSelItems(form "replaceVIA")) x->name)==0
					axlReplacePadstack(axlGetSelSet() x)
					;axlClearSelSet();
			)
			
		)
		axlSubSelectAll()
		count = 0;
		axlFormListDeleteAll(form "selectVIA")
		;axlReplacePadstack(axlGetSelSet() )
		;axlFormClose(form);
		;axlSubSelectAll()
		;printf("%L" rexMatchList("[a-z][0-9]*" '(a01 Q02 "003" aa01 "abc")))
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