procedure(loadiii()
;loadi(strcat(axlOSSlash(getShellEnvVar("HOME")) "/pcbenv/LD_Skill_Load.il") "chenhs");
loadi(strcat(axlOSSlash(getShellEnvVar("HOME")) "/pcbenv/test2.il") "chenhs");
;loadi(strcat(axlOSSlash(getShellEnvVar("HOME")) "/pcbenv/1.test=test=test.il") "chenhs");
loadi(strcat(axlOSSlash(getShellEnvVar("HOME")) "/pcbenv/auto_text_20161025.il") "chenhs");
axlShell("generaledit")
);procedure



procedure(MyStart()
form = axlFormCreate(gensym() "measure.form" `("E" "OUTER") `chs_Callback t)
axlFormDisplay(form) 
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
		println("select first PIN")
		axlSetFindFilter(?enabled '("PINS") ?onButtons '("ALLTYPES"))
		while(length(axlGetSelSet())<1
			axlSingleSelectPoint(axlEnterPoint())
			println("select first PIN")
		)
		while(length(axlGetSelSet())<2
			axlAddSelectPoint(axlEnterPoint())
			println("select second PIN")
		)
		l_dbid = axlGetSelSet()
		;printf("%L" l_dbid)
		printf("\n\n\n")
		defvar(l_first_dbid nth(0 l_dbid))
		defvar(l_second_dbid nth(1 l_dbid))
		;l_first_dbid = nth(0 l_dbid)
		;l_second_dbid = nth(1 l_dbid)
		println(l_first_dbid->??)
		println(l_second_dbid->??)
		printf("\n\n\n")
		
		defvar(Air_Out 0)
		defvar(Air_Gap 0)
		defvar(Total_Dist 0)
		defvar(Dx 0)
		defvar(Dy 0)
		
		Air_Out = Get_Air_Out();
		Total_Dist = Get_Total_Dist();
		
		printf("measure Pin: (%s %s)\n" l_first_dbid->objType l_second_dbid->objType)
		printf("Air Out: %fmil(%fmm)\n" Air_Out Air_Out*0.0254)
		printf("Air Gap: %fmil(%fmm)\n" nth(2 axlAirGap(l_first_dbid l_second_dbid)) nth(2 axlAirGap(l_first_dbid l_second_dbid))*0.0254)
		printf("Total Dist: %fmil(%fmm)\n" Total_Dist Total_Dist*0.0254)
		printf("Dx: %fmil(%fmm)\n" Dx Dx*0.0254)
		printf("Dy: %fmil(%fmm)\n" Dy Dy*0.0254)
		sprintf(s1 "measure Pin: (%s %s)\n" l_first_dbid->objType l_second_dbid->objType)
		sprintf(s2 "Air Out: %fmil(%fmm)\n" Air_Out Air_Out*0.0254)
		sprintf(s3 "Air Gap: %fmil(%fmm)\n" nth(2 axlAirGap(l_first_dbid l_second_dbid)) nth(2 axlAirGap(l_first_dbid l_second_dbid))*0.0254)
		sprintf(s4 "Total Dist: %fmil(%fmm)\n" Total_Dist Total_Dist*0.0254)
		sprintf(s5 "Dx: %fmil(%fmm)\n" Dx Dx*0.0254)
		sprintf(s6 "Dy: %fmil(%fmm)\n" Dy Dy*0.0254)
		myorient = make_axlTextOrientation(?textBlock "30", ?rotation 0,?mirrored nil, ?justify "center")
  ;ret = axlDBCreateText("Chamfer both sides", 1488:887, myorient, "etch/top", nil)
	axlDynamicsObject(car(axlDBCreateText(strcat(s1 s2 s3 s4 s5 s6), 1488:887, myorient, "etch/top", nil)))
	)
	("aquit"
		;axlFormClose(form);
		axlSubSelectAll()
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