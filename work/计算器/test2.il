procedure(loadiii()
;loadi(strcat(axlOSSlash(getShellEnvVar("HOME")) "/pcbenv/LD_Skill_Load.il") "chenhs");
loadi(strcat(axlOSSlash(getShellEnvVar("HOME")) "/pcbenv/test2.il") "chenhs");
;loadi(strcat(axlOSSlash(getShellEnvVar("HOME")) "/pcbenv/1.test=test=test.il") "chenhs");
loadi(strcat(axlOSSlash(getShellEnvVar("HOME")) "/pcbenv/auto_text_20161025.il") "chenhs");
);procedure



procedure(MyStart()
;printf("1234\n")
;li = '("q" 23 "ni" 90)
;printf("%L\n" car(li))
;nthelem(2 li);list中获取第2个项
;compress("1.ile" "new.il")//解密il，仅用于无加密
/*(FORMFILE = outfile("./calc.form"))
fprintf(FORMFILE "FILE_TYPE=FORM_DEFN VERSION=2\n")
fprintf(FORMFILE "FORM\n")
fprintf(FORMFILE "FIXED\n")
fprintf(FORMFILE "PORT 45 30\n")
fprintf(FORMFILE "HEADER calc\n")
fprintf(FORMFILE "\n")
fprintf(FORMFILE "\n")
fprintf(FORMFILE "TILE\n")
    fprintf(FORMFILE "GROUP jisuanqi\n") 
    fprintf(FORMFILE "GLOC 2 2\n") 
    fprintf(FORMFILE "GSIZE 40 6\n") 
    fprintf(FORMFILE "ENDGROUP\n") 
    fprintf(FORMFILE "TEXT\n") 
    fprintf(FORMFILE "TLOC 15 10\n") 
    fprintf(FORMFILE "INFO sinfo 60\n")
    fprintf(FORMFILE "OPTIONS underline BOLD\n") 
    fprintf(FORMFILE "ENDTEXT\n") 
    fprintf(FORMFILE "FIELD silk_auto_ok\n") 
    fprintf(FORMFILE "FLOC 10 13\n") 
    fprintf(FORMFILE "MENUBUTTON jisuan 10 4\n")
    fprintf(FORMFILE "ENDFIELD\n") 
fprintf(FORMFILE "\n")
fprintf(FORMFILE "ENDTILE\n")
fprintf(FORMFILE "\n")
fprintf(FORMFILE "ENDFORM\n")
close(FORMFILE) 
*/
form = axlFormCreate(gensym() "calc.form" `("E" "OUTER") `chs_Callback t)
axlFormDisplay(form) 
;axlFormSetField(form "silk_layer" "TOP");
;axlFormSetField(form "silk_size" "3");
;axlFlushDisplay()
;axlVisibleUpdate(t)
)

procedure(chs_Callback(form)
	case((form->curField)
	("clear" printf("clear")
		axlFormSetField(form "biaodashi" "");
		axlFormSetField(form "zhi" "");
		axlFormSetField(form "Mmzhi" "");
		axlFormSetField(form "Milzhi" "");
	)
	("aquit" printf("aquit")
		axlFormClose(form);
		;printf("%L" rexMatchList("[a-z][0-9]*" '(a01 Q02 "003" aa01 "abc")))
	)
	("biaodashi" printf("biaodashi")

		s = form->curValue;
		if(nindex(s "+")  then
			list = parseString(s "+")
			a1 = nth(0 list)
			b1 = nth(1 list)
			printf("a=%s,b = %s" a1 b1)
			fa = atof(a1)
			fb = atof(b1);
			axlFormSetField(form "zhi" fa+fb);
		)

		if(nindex(s "-")  then
			list = parseString(s "-")
			a = nth(0 list)
			b = nth(1 list)
			printf("a=%s,b = %s" a b)
			fa = atof(a)
			fb = atof(b);
			axlFormSetField(form "zhi" fa-fb);
		)
		
		if(nindex(s "*") then
			list = parseString(s "*")
			a = nth(0 list)
			b = nth(1 list)
			printf("a=%s,b = %s" a b)
			fa = atof(a)
			fb = atof(b);
			axlFormSetField(form "zhi" fa*fb);
		)
		
	  if(nindex(s "/") then
			list = parseString(s "/")
			a = nth(0 list)
			b = nth(1 list)
			printf("a=%s,b = %s" a b)
			fa = atof(a)
			fb = atof(b);
			axlFormSetField(form "zhi" fa/fb);
		)
		;len = strlen(s);
		/*for(i 1 len
			if(getchar(s i) == +
			
			)
			printf("%c," );
		
		)*/
	)
	("zhi" printf("zhi")
	
	)
	("Mmzhi" printf("Mmzhi")
		a = form->curValue;
		axlFormSetField(form "Milzhi" a/0.0254);
	)
	("Milzhi" printf("Milzhi")
		a = form->curValue;
		axlFormSetField(form "Mmzhi" a*0.0254);
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
)