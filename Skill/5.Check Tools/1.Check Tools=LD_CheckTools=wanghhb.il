axlCmdRegister("LD_CheckTools" 'LD_CheckTools)

/*	----





*/

defun(LD_CheckTools ()
let(()
	ChcekList_list = '(checklist
		;First_Checking (			
		;	(t "\315\370\261\355\266\324\261\310" "\265\274\263\366\267\275\312\275\243\272File--Export--Netline w/Properties.\n\nPCB\265\274\263\366\265\304\315\370\261\355\275\370\320\320\266\324\261\310\243\254\325\322\263\366\260\346\261\276\262\356\322\354\241\243")
		;)
		Place_Checking (
			(Check_Marker() 
				"Mark\265\343"
				"Mark\265\343\325\375\267\264\326\301\311\331\270\3672\270\366,\307\322\300\353\260\345\261\337\241\3355mm."
			)
			(Check_No2SMT()
				"\273\330\301\367\260\332\267\305"
				"BGA\241\242\264\363\265\304QFP\241\242PLCC\241\242\304\243\277\351\265\310\322\324\274\260\262\273\304\334\266\376\264\316\273\330\301\367\265\304\306\367\274\376\322\252\267\305\265\275\315\254\322\273\303\346"
			)
			(SilkOnSold()
				"\260\327\323\315\321\271\272\270\305\314" 
				"\260\327\323\315\324\332\277\252\264\260\265\304\272\270\305\314\311\317\303\346"
			)
			;白油压焊盘;白油在开窗的焊盘上面。
			;(Check_Outline() "Outline\274\354\262\351")
			(Check_Past_To_Past(0.195)
				"\270\326\315\370\274\354\262\351" 
				;钢网检查
			)
		)
		Layout_Checking (
			(Check_NoCon() 
				"\271\302\315\255" 
				"\274\354\262\351\270\241\277\325\317\337/\271\375\277\327"
			)
			;孤铜，孤岛
			(Check_KeyVia(0.6) 
				"\260\264\274\374\271\375\277\327" 
				"\260\264\274\374\265\304VIA\312\307\267\361\264\362\324\332\260\264\274\374\265\304\326\320\320\304\273\362\325\337\300\353\326\320\320\304\267\307\263\243\275\374"
			)
			;按键过孔，按键的Via是否打在按键中心或者离中心非常近。
			(Check_ViaInRCL() 
				"\327\350\310\335\322\375\275\305\274\344\271\375\277\327" 
				"\274\354\262\351 \265\347\310\335 \265\347\327\350 \265\347\270\320 \301\275\270\366PIN\274\344\312\307\267\361\323\320VIA\n\314\330\261\360\312\307\265\347\324\264\327\252\273\273\265\304\264\363\265\347\270\320\243\254\264\363\265\347\310\335\243\250\263\375\267\307\327\337\317\337\267\307\263\243\323\265\274\267\262\273\265\303\322\321\243\251"
			)
			;阻容引脚间过孔；检查电容电阻电感两PIN间是否有Via。
			(Check_Thermal(0.2) 
				"\322\375\317\337\266\324\263\306" 
				"\316\252\267\300\326\271\272\270\275\323\312\261\241\260\301\242\261\256\241\261\317\326\317\363\243\254\266\324\323\3320402\241\2420603\306\367\274\376\265\304\272\270\305\314\301\275\266\313\327\337\317\337\322\252\266\324\263\306\243\254\275\373\326\271\322\273\266\313\326\261\275\323\323\303\264\363\303\346\273\375\315\255\262\255\270\262\270\307\241\243"
			)
			;引线对称，为了防止立碑，对于0402，0603的阻容两引脚走线要对称。
			;(Check_ViaI(1.34/2) "\271\375\277\327\306\245\305\344" "\274\354\262\342\271\375\277\327\323\353\317\337\277\355\271\330\317\265\241\243\305\320\266\317\271\375\277\327\263\301\315\255\303\346\273\375\312\307\267\361\264\363\323\332\327\337\317\337\303\346\273\375\241\243")
			;过孔匹配，检查过孔与线宽关系，判断过孔内壁铜截面积是否大于走线截面积。
		)
		DFT_Checking (
			
			(Check_DFT_Tp2FixHoles() 
				"\323\353\266\245\325\353\277\327\276\340\300\353" 
				"\262\342\312\324\265\343\323\353\266\245\325\353\277\327\276\340\300\353\323\246\270\303\262\273\320\241\323\3325mm\243\254\322\324\303\342\314\275\325\353\323\353\266\245\325\353\326\371\270\311\311\346\241\243"
			)
			;测试点到顶针孔；测试点与顶针孔距离应该不小于5mm，以免探针与顶针柱干涉。
			
			(Check_DFT_Tp2HighPlaceBound() 
				"\323\353\270\337\306\367\274\376\276\340\300\353" 
				"\271\346\267\266\243\272H\243\272\306\367\274\376\270\337\266\310 Ds\243\272\306\367\274\376\261\337\323\353\262\342\312\324\265\343\326\320\320\304\276\340\300\353\241\243\n\265\261H >= 10mm\312\261\243\254Ds = H/2\n\265\2615mm <= H <= 10 mm\312\261\243\254Ds = 5mm\n\265\261H <= 5mm\312\261\243\254Ds\267\342\327\260\312\265\317\326\261\334\310\303\241\243\n"
			)
			;测试点到高器件距离；
			(WaveSold() 
				"\323\353\262\250\267\345\272\270\276\340\300\353" 
				"\262\342\312\324\265\343\300\353\262\250\267\345\272\270\265\343\261\330\320\353\264\363\323\3325mm\241\243"
			)
			;测试点离波峰焊距离；测试点离波峰焊点必须大于5mm。
			
			/*
			(Check_DFT_TP2Place_Bound() 
				"\323\353BGA\276\340\300\353" 
				"BGA\261\263\303\346\262\342\312\324\265\343\324\266\300\353BGA\265\304Placebound 5mm"
			)
			;测试点与BGA距离;BGA背面测试点远离BGA的Placebound 5mm
			*/
			
			(TPOnDiffpair() 
				"\262\356\267\326\262\342\312\324\265\343\276\340\300\353" 
				"\262\356\267\326\320\305\272\305\265\304\262\342\312\324\265\343\265\304\276\340\300\353\262\273\263\254\271\3752mm\241\243"
			)
			;差分测试点距离；差分信号的测试点的距离不超过2mm。
			(TPNumber(3)
				"\265\330\262\342\312\324\265\343\312\375/\267\342\327\260" 
				"\274\354\262\351\265\330\262\342\312\324\265\343\265\304\312\375\301\277"
			)
		)
	)

		
	CheckTools_form = axlFormCreate((gensym) strcat(FormPath "LD_CheckTools.form") 
		nil 'LD_CheckTools_Form_callBack t nil
	)
	;axlUIWPerm(CheckTools_form nil)
	
	;------------------------添加文件夹-----------------------
	;First_PID = axlFormTreeViewAddItem(CheckTools_form "TreeeView0" "First Checking" nil nil nil)
	Place_PID = axlFormTreeViewAddItem(CheckTools_form "TreeeView0" "\262\274\276\326\274\354\262\351" nil nil t)
	Layout_PID = axlFormTreeViewAddItem(CheckTools_form "TreeeView0" "\262\274\317\337\274\354\262\351" nil nil t)
	DFT_PID = axlFormTreeViewAddItem(CheckTools_form "TreeeView0" "\262\342\312\324\265\343\274\354\262\351" nil nil t)
	
	
	
	;------------------------定义数组-------------------------
	;declare(First_ID[length(ChcekList_list->First_Checking)])
	declare(Place_ID[length(ChcekList_list->Place_Checking)])
	declare(Layout_ID[length(ChcekList_list->Layout_Checking)])
	declare(DFT_ID[length(ChcekList_list->DFT_Checking)])
	
	
	;----------------------添加子项----------------------------
	;for(i 0 length(ChcekList_list->First_Checking)-1
	;	First_ID[i] = axlFormTreeViewAddItem(CheckTools_form "TreeeView0"  cadr(nth(i ChcekList_list->First_Checking)) First_PID nil nil)
	;)
	
	for(i 0 length(ChcekList_list->Place_Checking)-1
		Place_ID[i] = axlFormTreeViewAddItem(CheckTools_form "TreeeView0"  cadr(nth(i ChcekList_list->Place_Checking)) Place_PID nil t)
	)
	
	for(i 0 length(ChcekList_list->Layout_Checking)-1
		Layout_ID[i] = axlFormTreeViewAddItem(CheckTools_form "TreeeView0"  cadr(nth(i ChcekList_list->Layout_Checking)) Layout_PID nil t)
	)
	
	for(i 0 length(ChcekList_list->DFT_Checking)-1
		DFT_ID[i] = axlFormTreeViewAddItem(CheckTools_form "TreeeView0"  cadr(nth(i ChcekList_list->DFT_Checking)) DFT_PID nil t)
	)
	
	axlFormTreeViewSet(CheckTools_form "TreeeView0" 'TV_NOEDITLABEL nil)	
	axlFormAutoResize(CheckTools_form)	
	axlFormSetFieldVisible(CheckTools_form "TreeeView0" 1)	
	axlFormDisplay(CheckTools_form)
	
)
)

defun(LD_CheckTools_Form_callBack (CheckTools_form)
	prog( (listerror allerrorsel)
		;println(CheckTools_form->curField)
		;println(axlFormGetFieldType(CheckTools_form CheckTools_form->curField))
    case(CheckTools_form->curField
			("TreeeView0"			
				;axlFormListSelAll(CheckTools_form "ErrorList" t)
				;List_Sel_Items = axlFormListGetSelItems(CheckTools_form "ErrorList")
				;axlFormListDeleteItem(CheckTools_form "ErrorList" List_Sel_Items)
				
;---------------------说明显示-------------------------------------------------
				;DesHelpCtrl(ChcekList_list->First_Checking First_ID)
				DesHelpCtrl(ChcekList_list->Place_Checking Place_ID)
				DesHelpCtrl(ChcekList_list->Layout_Checking Layout_ID)
				DesHelpCtrl(ChcekList_list->DFT_Checking DFT_ID)

				if(CheckTools_form->curValue == "" then
;-------------------------多选控制---------------------------------				
					TreeViewMultiSelCtrl(ChcekList_list->Place_Checking Place_PID Place_ID)
					TreeViewMultiSelCtrl(ChcekList_list->Layout_Checking Layout_PID Layout_ID)
					TreeViewMultiSelCtrl(ChcekList_list->DFT_Checking DFT_PID DFT_ID)
				)
      )
      
			("MenuCheck0"
				PCBCheck()
      )
			("FileButton"
				PlaceFile = axlDMFileBrowse("ALLEGRO_TEXT" nil)
				when(rexMatchp(".+.txt$" PlaceFile)
					axlFormSetField(CheckTools_form "Input1" PlaceFile)
				)
      )
      
			("FileButton1"
				Valor_Html_File = axlDMFileBrowse(nil nil ?optFilters "Valor Html File(*.html)|*.html|")
				when(rexMatchp(".+.html$" Valor_Html_File)
					axlFormSetField(CheckTools_form "Input2" Valor_Html_File)
				)
      )
      
			("MenuCheck1"
	  		No_Con_Pin()
			)
			
	  	("MenuCheck2"
				TPCheck()
			)
	  	("MenuCheck3"
				Valor_Mark()
			)
	  	("ErrorList0" || "ErrorList1" || "ErrorList2" || "ErrorList3"
				MarkToXY()
			)
    )
    if(nequal(CheckTools_form->doneState 0) then
    	axlFormClose(CheckTools_form)
    );if
	);prog
);procedure


defun(PCBCheck ()
let((p)
	if(axlOKToProceed() == nil then
		axlUIConfirm("\307\353\315\352\263\311\265\261\307\260\262\331\327\367!!!!!") 
		return(nil)
	else
		axlFinishEnterFun()
		axlFormListSelAll(CheckTools_form "ErrorList0" t)
		List_Sel_Items = axlFormListGetSelItems(CheckTools_form "ErrorList0")
		axlFormListDeleteItem(CheckTools_form "ErrorList0" List_Sel_Items)
		List_Error = '()
		
		VisList = axlVisibleGet()		
		for(i 0 length(ChcekList_list->Place_Checking)-1
			if(axlFormTreeViewGetSelectState(CheckTools_form "TreeeView0" Place_ID[i]) == 1 then
				eval(car(nth(i ChcekList_list->Place_Checking)))
			)
		)
		for(i 0 length(ChcekList_list->Layout_Checking)-1
			if(axlFormTreeViewGetSelectState(CheckTools_form "TreeeView0" Layout_ID[i]) == 1 then
				eval(car(nth(i ChcekList_list->Layout_Checking)))
			)
		)
		
		for(i 0 length(ChcekList_list->DFT_Checking)-1
			if(axlFormTreeViewGetSelectState(CheckTools_form "TreeeView0" DFT_ID[i]) == 1 then
				eval(car(nth(i ChcekList_list->DFT_Checking)))
			)
		)
		axlVisibleSet(VisList)
		
		n_Error = 1
		foreach(n0 List_Error
			axlFormGridInsertRows(CheckTools_form "ErrorList0" 0 1)
			axlFormListAddItem(CheckTools_form "ErrorList0" concat(n_Error ": " cadr(n0)) -1)
			;axlFormColorize(CheckTools_form "ErrorList0" 'text 'green)
			n_Error++
		)
		unless(List_Error
			axlFormListAddItem(CheckTools_form "ErrorList0" "PASS!" -1)
		;检查通过。		
		)
		;p = make_formGridCol()	
	;	p->fieldType = 'CHECKITEM
		;p->colWidth = 6
		;p->align = 'center
		;p->headText = "Check"
	; Set scripting label for column
		;p->scriptLabel = "check"
		;println(p->??)
		;println(axlFormGridInsertCol(CheckTools_form "ErrorList0" p))
	)
)
)




/*
------------------------------------------------------
函数：Valor_Mark()
输入：
输出：无
说明：Valor软件错误定位
------------------------------------------------------
*/



defun(Valor_Mark ()
let((List_Sel_Items MarkFile TempNum0 ValueTemp chkChar X0 Y0 chkNum chkNumStr RefNum RefNumStr LayerT LayerT0 Layer t12340 t1234 sst ssb spt spb smt smb drill)
	
	axlFormListSelAll(CheckTools_form "ErrorList3" t)
	List_Sel_Items = axlFormListGetSelItems(CheckTools_form "ErrorList3")
	axlFormListDeleteItem(CheckTools_form "ErrorList3" List_Sel_Items)
	List_Error = '()
	sst = '("BOARD GEOMETRY/OUTLINE"  
		"PACKAGE GEOMETRY/SILKSCREEN_TOP" "BOARD GEOMETRY/SILKSCREEN_TOP"
	);白油
	ssb = '("BOARD GEOMETRY/OUTLINE"  
		"PACKAGE GEOMETRY/SILKSCREEN_BOTTOM" "BOARD GEOMETRY/SILKSCREEN_BOTTOM"
	)
	spt = '("BOARD GEOMETRY/OUTLINE" "PIN/PASTEMASK_TOP" 
		"PACKAGE GEOMETRY/PASTEMASK_TOP");钢网
	spb = '("BOARD GEOMETRY/OUTLINE" "PIN/PASTEMASK_BOTTOM" 
		"PACKAGE GEOMETRY/PASTEMASK_BOTTOM")
	smt = '("BOARD GEOMETRY/OUTLINE" "PIN/SOLDERMASK_TOP" 
		"PACKAGE GEOMETRY/SOLDERMASK_TOP" "BOARD GEOMETRY/SOLDERMASK_TOP"
	);开窗
	smb = '("BOARD GEOMETRY/OUTLINE" "PIN/SOLDERMASK_BOTTOM" 
		"PACKAGE GEOMETRY/SOLDERMASK_BOTTOM" "BOARD GEOMETRY/SOLDERMASK_BOTTOM"
	)
	drill = '(
		"VIA CLASS"
	);装孔
	
	MarkFile = infile(axlOSSlash(axlFormGetField(CheckTools_form "Input2")))
	when(MarkFile && MarkFile != "*.html"
		while(gets(n0 MarkFile)
			cond(
				(rexMatchp("<tr>\n" n0) TempNum0 = 0)
				(rexMatchp("</tr>\n" n0) TempNum0 = 10)
				(rexMatchp("<td>+" n0) TempNum0++)
			)
			when(strlen(n0)-14>0
				ValueTemp = substring(n0 10 (strlen(n0)-15))
				case(TempNum0
					(1 chkChar = ValueTemp)
					(3 X0 = atof(ValueTemp)/0.0254)
					(4 Y0 = atof(ValueTemp)/0.0254)
					(5 
						chkNum = atof(ValueTemp)/0.0254
						chkNumStr = symbolToString(concat(truncate(chkNum) "." truncate(1000*(chkNum-truncate(chkNum)))))
					)
					(6 LayerT = parseString(ValueTemp "; "))
					(9 
						RefNum = atof(car(parseString(nth(4 parseString(ValueTemp "=")))))
						RefNumStr = car(parseString(nth(4 parseString(ValueTemp "="))))
					)
				)
			)
			if(TempNum0 == 9 then
				Layer = '()
				LayerT0 = '()
				foreach(n1 LayerT
					unless(rexMatchList(n1 LayerT0)
						LayerT0 = append1(LayerT0 n1)
						case(n1
							("sst" Layer = append(Layer sst))
							("ssb" Layer = append(Layer ssb))
							("spt" Layer = append(Layer spt))
							("spb" Layer = append(Layer spb))
							("smt" Layer = append(Layer smt))
							("smb" Layer = append(Layer smb))
							("drill" Layer = append(Layer drill))
						)
						cond(
							(rexMatchp("^d_+" n1) Layer = append(Layer drill))
							(rexMatchList(upperCase(n1) axlSubclasses("ETCH"))
								Layer = append(Layer list("BOARD GEOMETRY/OUTLINE" 
									strcat("ETCH/" upperCase(n1)) 
									strcat("PIN/" upperCase(n1)) 
									strcat("VIA CLASS/" upperCase(n1))
									)
								)
							)
						)
					)
				)
				chkChar = concat("Ref=" RefNumStr "    " chkNumStr "  " chkChar)
				ErrorOne = list(list(list(X0-RefNum Y0-RefNum) list(X0+RefNum Y0+RefNum)) chkChar Layer)
				List_Error = append1(List_Error ErrorOne)
			)
		)
	)
	
		n_Error = 1
		foreach(n0 List_Error
			axlFormGridInsertRows(CheckTools_form "ErrorList3" 0 1)
			axlFormListAddItem(CheckTools_form "ErrorList3" concat(n_Error ": " cadr(n0)) -1)
			;axlFormColorize(CheckTools_form "ErrorList3" 'text 'green)
			n_Error++
		)
		unless(List_Error
			axlFormListAddItem(CheckTools_form "ErrorList0" "PASS!" -1)
		;检查通过。		
		)
)
)




/*
------------------------------------------------------
函数：TPCheck()
输入：
输出：无
说明：测试点移动增加检查。
------------------------------------------------------
*/
defun(TPCheck ()
let((L_TPxy List_Sel_Items)
	axlFormListSelAll(CheckTools_form "ErrorList2" t)
	List_Sel_Items = axlFormListGetSelItems(CheckTools_form "ErrorList2")
	axlFormListDeleteItem(CheckTools_form "ErrorList2" List_Sel_Items)
	List_Error = '()
	L_TPxy = '()
	TPSymbolID = axlSelectByName("SYMTYPE" "TP*" t)
	PlaceFile_Input = infile(axlOSSlash(axlFormGetField(CheckTools_form "Input1")))
	when(PlaceFile_Input && PlaceFile_Input != "*.txt"
		while(gets(n0 PlaceFile_Input)
			if(rexMatchp("^TP+" n0) then
				L_TPxy = append1(L_TPxy n0)
			)
		)
	)
	Dref = axlMKSConvert(0.001 "mm" car(axlDBGetDesignUnits()))
	foreach(n0 L_TPxy
		KK = parseString(n0)
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
				;println(car(TPOneID->pins)->bBox)
				ErrorOne = list(car(TPOneID->pins)->bBox concat(TPOneID->refdes "\316\273\326\303\323\320\322\306\266\257") Vis_Temp)
				List_Error = append1(List_Error ErrorOne)
			)
		else
			ErrorOne = list(nil concat("\310\245\262\342\312\324\265\343" car(KK)))
			List_Error = append1(List_Error ErrorOne)	
		)
	)
	
	foreach(n0 TPSymbolID
		if(n0->isMirrored then
			Vis_Temp = list("BOARD GEOMETRY/OUTLINE" "PACKAGE GEOMETRY/SILKSCREEN_BOTTOM" "PIN/BOTTOM")
		else
			Vis_Temp = list("BOARD GEOMETRY/OUTLINE" "PACKAGE GEOMETRY/SILKSCREEN_TOP" "PIN/TOP")
		)
		ErrorOne = list(car(n0->pins)->bBox concat("\324\366\262\342\312\324\265\343" n0->refdes) Vis_Temp)
		List_Error = append1(List_Error ErrorOne)
	)
	
	
	n_Error = 1
	foreach(n0 List_Error
		axlFormListAddItem(CheckTools_form "ErrorList2" concat(n_Error ": " cadr(n0)) -1)
		n_Error++
	)
	unless(List_Error
		axlFormListAddItem(CheckTools_form "ErrorList2" "PASS!" -1)
	)
)
)



/*
------------------------------------------------------
函数：No_Con_Pin()
输入：
输出：无
说明：没连接引脚
------------------------------------------------------
*/
defun(No_Con_Pin ()
let((PinNum)
	axlFinishEnterFun()
	axlFormListSelAll(CheckTools_form "ErrorList1" t)
	List_Sel_Items = axlFormListGetSelItems(CheckTools_form "ErrorList1")
	axlFormListDeleteItem(CheckTools_form "ErrorList1" List_Sel_Items)
	List_Error = '()
	
	foreach(n0 axlDBGetDesign()->nets
		when(n0->ratsnest == nil && n0->prop->VOLTAGE == nil
			if(car(car(n0->branches)->children)->isMirrored then
				Vis_Temp = list("BOARD GEOMETRY/OUTLINE" 
					"PACKAGE GEOMETRY/SILKSCREEN_BOTTOM" "PIN/BOTTOM" "ETCH/BOTTOM")				
			else
				Vis_Temp = list("BOARD GEOMETRY/OUTLINE" 
					"PACKAGE GEOMETRY/SILKSCREEN_TOP" "PIN/TOP" "ETCH/TOP")
			)
			when(car(car(n0->branches)->children)->parent->objType == "symbol"
				PinNum = strcat(car(car(n0->branches)->children)->parent->refdes
					 "." car(car(n0->branches)->children)->number "   (" n0->name ")")
				ErrorOne = list(car(car(n0->branches)->children)->bBox 
					strcat(PinNum "\270\241\277\325") Vis_Temp)
				List_Error = append1(List_Error ErrorOne)
			)
		)
	)
	n_Error = 1
	foreach(n0 List_Error
		axlFormListAddItem(CheckTools_form "ErrorList1" concat(n_Error ": " cadr(n0)) -1)
		n_Error++
	)
	unless(List_Error
		axlFormListAddItem(CheckTools_form "ErrorList1" "PASS!" -1)
	)
)
)




/*
------------------------------------------------------
函数：MarkToXY()
输入：
输出：无
说明：bBox定位问题点函数
显示格式：(bBox "文字描述" list("层" "层"))
------------------------------------------------------
*/
defun(MarkToXY ()
let((ObjBbox SubBbox)
	axlFinishEnterFun()
	axlVisibleDesign(nil)
	
	for(i 0 length(List_Error)-1
		if(concat(car(parseString(CheckTools_form->curValue ":"))) == concat(i+1) then
			ObjBbox = car(nth(i List_Error))
			SubBbox = axlMXYSub(cadr(ObjBbox) car(ObjBbox))
			ObjBbox = list(axlMXYSub(car(ObjBbox) SubBbox) 
				axlMXYAdd(cadr(ObjBbox) SubBbox)
			)
			axlWindowBoxSet(ObjBbox)
			foreach(n0 nth(2 nth(i List_Error))
				axlVisibleLayer(n0 t)
			)
			axlVisibleUpdate(nil)
		)
	)
)
)





/*
------------------------------------------------------
函数：TreeViewMultiSelCtrl(n_Checking n_PID n_ID)
输入：n_Checking n_PID n_ID
输出：无
说明：多选框函数，全选，全非选
------------------------------------------------------
*/
					
defun(TreeViewMultiSelCtrl (n_Checking n_PID n_ID)
let((Sel_Temp)
	for(i 0 length(n_Checking)-1
		cond(
			(CheckTools_form->curValueInt == n_PID && CheckTools_form->treeViewSelState == 1
				axlFormTreeViewSetSelectState(CheckTools_form "TreeeView0" n_ID[i] t)
			)
			(CheckTools_form->curValueInt == n_PID && CheckTools_form->treeViewSelState == 0
				axlFormTreeViewSetSelectState(CheckTools_form "TreeeView0" n_ID[i] nil)							
			)
			(CheckTools_form->curValueInt == n_ID[i]
				Sel_Temp = 1
				for(j 0 length(n_Checking)-1
					Sel_Temp = Sel_Temp & axlFormTreeViewGetSelectState(CheckTools_form "TreeeView0" n_ID[j])
				)
				if(Sel_Temp == 1 then
					axlFormTreeViewSetSelectState(CheckTools_form "TreeeView0" n_PID t)
				else
					axlFormTreeViewSetSelectState(CheckTools_form "TreeeView0" n_PID nil)
				)
			)
		)
	)
)
)
					
/*
------------------------------------------------------
函数：DesHelpCtrl(n_Checking n_ID)
输入：n_Checking n_ID
输出：无
说明：规范说明
------------------------------------------------------
*/
defun(DesHelpCtrl (n_Checking n_ID)
let(()
	for(i 0 length(n_Checking)-1
		if(CheckTools_form->curValue == axlFormTreeViewGetLabel(CheckTools_form "TreeeView0" n_ID[i]) then
			axlFormSetField(CheckTools_form "Label4" caddr(nth(i n_Checking)))
		)
	)
)
)




/*
-----------------------------------------------
函数：Check_Marker()
输入：无
说明：检查mark点正反面数.后添加板边距
------------------------------------------------
*/

defun(Check_Marker ()
let((MSID NumBot NumTop)
	axlClearSelSet()
	NumBot = 0
	NumTop = 0
	MSID = axlSelectByName("SYMTYPE" "MARK" t)
	axlClearSelSet()	
	foreach(n0 MSID
		if(n0->isMirrored then
			NumBot++
		else
			NumTop++
		)
	)
	unless(NumTop >= 2 && NumBot >= 2
		foreach(n0 MSID
			;ErrorOne = list(n0 "\266\245\262\343\273\362\265\327\262\343mark\265\343\320\241\323\3322\270\366")
			if(n0->isMirrored then
				Vis_Temp = list("BOARD GEOMETRY/OUTLINE" "PACKAGE GEOMETRY/SILKSCREEN_BOTTOM" "PIN/BOTTOM" "ETCH/BOTTOM")				
			else
				Vis_Temp = list("BOARD GEOMETRY/OUTLINE" "PACKAGE GEOMETRY/SILKSCREEN_TOP" "PIN/TOP" "ETCH/TOP")
			)
			ErrorOne = list(car(n0->pins)->bBox "\266\245\262\343\273\362\265\327\262\343mark\265\343\320\241\323\3322\270\366" Vis_Temp)
			;顶层或底层mark点小于2个
			List_Error = append1(List_Error ErrorOne)
		)
		
	)
)
)

/*
---------------------------------------------------------------
函数：Check_Outline()
输入：无
说明：
---------------------------------------------------------------
*/
defun(Change_TO_Outline ()
let((Change_TO_Outline_Popup nCSMark List_Lines)
Change_TO_Outline_Popup = axlUIPopupDefine(nil list(
		list("Done" 'Change_TO_Outline_Done) 
		list("Oops" 'Change_TO_Outline_Undo) 
		list("Cancel" 'Change_TO_Outline_Cancel)
	))
	axlUIPopupSet(Change_TO_Outline_Popup)
	
	
	axlSetFindFilter(?enabled '("NOALL" "LINES") ?onButtons '("ALLTYPES"))
	nCSMark = axlDBTransactionStart()
	
	Path_Outline = nil
	while(axlSelect()
		axlDBTransactionMark(nCSMark)
		List_Lines = axlGetSelSet()
		unless(Path_Outline
			Path_Outline = axlDB2Path(car(List_Lines))
		)
		foreach(n0 List_Lines
			case(n0->objType
				
				("path"
					
					println(axlDBCreatePath(Path_Outline "BOARD GEOMETRY/OUTLINE" ))
				)
				("arc"  
					t
					
				)
			
			)
		)
		
	)
	
)
)





defun(Change_TO_Outline_Done ()
prog(()
	axlDBTransactionCommit(nCSMark)
	axlCancelEnterFun()
)
)


defun(Change_TO_Outline_Undo ()
prog(()
	axlDBTransactionOops(nCSMark)
)
)


defun(Change_TO_Outline_Cancel ()
prog(()
	axlDBTransactionRollback(nCSMark)
	axlClearSelSet()
	axlCancelEnterFun()
)
)



/*
---------------------------------------------------------------
函数：Check_Past_To_Past(N_Dis)
输入：N_Dis  小数输入钢网开窗间的最小缝隙。
说明：钢网开窗见的缝隙太小，刷锡膏的时候会有问题。
---------------------------------------------------------------
*/


defun(Check_Past_To_Past (N_Dis)
let((PastID SS Disref ActValue LagbBox)
	Disref = axlMKSConvert(N_Dis "mm" car(axlDBGetDesignUnits()))
	for(i 0 1
		if(i == 1 then
			Vis_Temp = list("PACKAGE GEOMETRY/PASTEMASK_TOP" "PIN/PASTEMASK_TOP")
		else
			Vis_Temp = list("PACKAGE GEOMETRY/PASTEMASK_BOTTOM" "PIN/PASTEMASK_BOTTOM")
		)
		axlVisibleDesign(nil)
		foreach(n0 Vis_Temp
			axlVisibleLayer(n0 t)
		)
		axlSetFindFilter(?enabled '("NOALL" "PINS") ?onButtons "ALLTYPES")
		axlAddSelectAll()
		PastID = axlGetSelSet()
		axlClearSelSet()
		axlSetFindFilter(?enabled '("NOALL" "SHAPES") ?onButtons "ALLTYPES")
		axlAddSelectAll()
		PastID = append(PastID axlGetSelSet())
		axlClearSelSet()
		axlSetFindFilter(?enabled '("NOALL" "SHAPES" "PINS") ?onButtons "ALLTYPES")
		foreach(n0 PastID
			LagbBox = bBoxAdd(n0->bBox list(list(-Disref -Disref) list(Disref Disref)))
			axlSingleSelectBox(LagbBox)
			SS = exists(n1 axlGetSelSet() n1!=n0&&n0->parent->name!="MARK")
			axlClearSelSet()
			foreach(n2 SS
				ActValue = axlAirGap(n0 n2 nil 'anyLayer)
				when(ActValue
					ActValue = axlMKSConvert(ActValue car(axlDBGetDesignUnits()) "mm")
					Vis_Temp = append1(Vis_Temp "BOARD GEOMETRY/OUTLINE")
					if(ActValue == 0 then
						ErrorOne = list(n2->bBox "\270\326\315\370\277\252\264\260\326\330\265\376\241\243" Vis_Temp)
						List_Error = append1(List_Error ErrorOne)
					else
						if(ActValue < N_Dis-0.001 then
							ErrorOne = list(n2->bBox concat("\301\275\270\366\270\326\315\370\277\252\264\260\320\241\323\332" axlGeo2Str(N_Dis) "MM" "\243\254\312\265\262\342\316\252  " axlGeo2Str(ActValue) "MM") Vis_Temp)
							List_Error = append1(List_Error ErrorOne)
						)
					)
				)
			)
		)
		
	)
	axlClearSelSet()
)
)






/*
---------------------------------------------------------------
函数：Check_No2SMT()
输入：无
说明：BGA、大的QFP、PLCC、模块等以及不能二次回流的器件要放到同一面
---------------------------------------------------------------
*/

defun(Check_No2SMT ()
let((SymID Num_Top Num_Bot)
	axlClearSelSet()
	Num_Top = 0
	Num_Bot = 0
	SymID = axlSelectByName("SYMTYPE" '("*BGA*" "*QFP*" "JBB_*") t)
	axlClearSelSet()
	foreach(n0 SymID
		if(n0->isMirrored then
			Num_Bot++
		else
			Num_Top++
		)
	)
	unless(Num_Bot == 0 || Num_Top == 0
		foreach(n0 SymID
			if(n0->isMirrored then
				Vis_Temp = list("BOARD GEOMETRY/OUTLINE" "PACKAGE GEOMETRY/SILKSCREEN_BOTTOM" "PIN/BOTTOM")				
			else
				Vis_Temp = list("BOARD GEOMETRY/OUTLINE" "PACKAGE GEOMETRY/SILKSCREEN_TOP" "PIN/TOP")
			)
			ErrorOne = list(n0->bBox concat(n0->refdes "\262\273\304\334\266\376\264\316\273\330\301\367\306\367\274\376\324\332\262\273\315\254\303\346\301\313") Vis_Temp)
			;不能二次回流器件在不同面了。
			List_Error = append1(List_Error ErrorOne)
		)		
	)
)
)





/*
---------------------------------------------------------------
函数：Check_NoCon()
输入：无
说明：无连接Net，Via。输入list，，返回t/nil，打印出问题数量。
---------------------------------------------------------------
*/

defun(Check_NoCon ()
let((VoidID)
	axlClearSelSet()
	axlVisibleDesign(nil) 
	axlVisibleLayer("ETCH" t)
	axlVisibleLayer("VIA CLASS" t)
	axlSetFindFilter( ?enabled  '("NOALL" "CLINES" "VIAS" "SHAPES" "LINES") ?onButtons  '("CLINES" "VIAS" "SHAPES" "LINES"))	
	axlAddSelectAll()
	VoidID = axlGetSelSet()
	axlClearSelSet()
	foreach(n0 VoidID
		unless(n0->net->name
			Vis_Temp = list("BOARD GEOMETRY/OUTLINE" n0->layer)
			ErrorOne = list(n0->bBox "\270\241\277\325\317\337/\271\375\277\327/\315\255\306\244" Vis_Temp)
			List_Error = append1(List_Error ErrorOne)
		)
	)
)
)




/*
---------------------------------------------------------------------
函数：Check_KeyVia(n_percent)
输入：百分比小数。
说明：对锅仔按键中的过孔进行检查，找出不符合规范按键，高亮。
---------------------------------------------------------------------
*/

defun(Check_KeyVia (n_percent);n_percent
let((KeyID Pin1ID DisPadVia LengPad PercVia2Pad Vis_Temp)
	axlClearSelSet()
	Pin1ID == '()
	KeyID = axlSelectByName("SYMTYPE" '("KEY_DOME*" "key_e097_ptf") t)
	axlClearSelSet()
	foreach(n0 KeyID
		foreach(n1 n0->pins
			if(n1->number == "1" then
				Pin1ID = append1(Pin1ID n1)
			)
		)	
	)	
	axlSetFindFilter(?enabled '("NOALL" "VIAS") ?onButtons '("VIAS"))
	foreach(n0 Pin1ID
		axlVisibleDesign(nil)
		if(n0->isMirrored then			
			axlVisibleLayer("VIA CLASS/BOTTOM" t)
			Vis_Temp = list("BOARD GEOMETRY/OUTLINE" "VIA CLASS/BOTTOM" "PIN/BOTTOM")
		else
			axlVisibleLayer("VIA CLASS/TOP" t)
			Vis_Temp = list("BOARD GEOMETRY/OUTLINE" "VIA CLASS/TOP" "PIN/TOP")
		)
		axlSingleSelectBox(n0->bBox)
		ViaID = axlGetSelSet()
		foreach(n1 ViaID
			Pin1H = car(axlMXYSub(cadr(n0->bBox) car(n0->bBox)))/2
			DisPadVia = axlDistance(n0->xy n1->xy)
			PercVia2Pad = DisPadVia/Pin1H
			if(n_percent > PercVia2Pad then
				ErrorOne = list(n0->bBox concat("\271\370\327\320\260\264\274\374" n0->parent->refdes "  PIN1" "\311\317\265\275\326\320\320\304\276\340\300\353\325\274\260\353\276\266\265\304" axlGeo2Str(100*PercVia2Pad) "%,\320\241\323\332\271\346\266\250\265\304" axlGeo2Str(100*n_percent) "%") Vis_Temp)
				List_Error = append1(List_Error ErrorOne)
			)	
		)
	)
)
)



/*
------------------------------------------------------
函数：Check_ViaInRCL()
输入：无
说明：检查 电容 电阻 电感 两个PIN间是否有VIA。
------------------------------------------------------
*/

defun(Check_ViaInRCL ()
let((RCLID ViaID X1 Y1 X2 Y2 KeepOutPinbBox Vis_Temp)
	ViaID = '()
	NoViaList = list(".*1206$" ".*0805$" ".*0603$" ".*0402$" ".*0201$")
	RCLID = axlSelectByName("SYMTYPE" '("*1206" "*0805" "*0603" "*0402" "*0201") t)
	DFARCLID = '()
	DFAID = append(axlDBGetShapes("PACKAGE GEOMETRY/DFA_BOUND_TOP") axlDBGetShapes("PACKAGE GEOMETRY/DFA_BOUND_BOTTOM"))
	foreach(n0 DFAID
		foreach(n1 NoViaList
			if(rexMatchp(n1 n0->parent->name) then
				DFARCLID = append1(DFARCLID n0)
			)
		)
	)
	axlClearSelSet()
	axlVisibleDesign(nil)
	axlVisibleLayer("VIA CLASS/TOP" t)
	axlSetFindFilter(?enabled '("NOALL" "vias") ?onButtons '("vias"))	
	foreach(n0 DFARCLID
		axlSingleSelectBox(n0->bBox)
		ViaID = axlGetSelSet()		
		foreach(n1 ViaID
			if(axlAirGap(n0 n1 nil 'anyLayer) == 0 && n1->isThrough then
				if(n0->parent->isMirrored then	
					Vis_Temp = list("BOARD GEOMETRY/OUTLINE" "VIA CLASS/BOTTOM" "PIN/BOTTOM" "PACKAGE GEOMETRY/SILKSCREEN_BOTTOM")
				else
					Vis_Temp = list("BOARD GEOMETRY/OUTLINE" "VIA CLASS/BOTTOM" "PIN/TOP" "PACKAGE GEOMETRY/SILKSCREEN_TOP")
				)
				ErrorOne = list(n0->bBox concat(n0->parent->refdes "\301\275\275\305\326\256\274\344\323\320\271\375\277\327") Vis_Temp)
				List_Error = append1(List_Error ErrorOne)
			)
		)
	)
	axlClearSelSet()
)
)


/*
-------------------------------------------
函数：Check_Thermal(n_percent)
输入：n_percent 百分比小数 。（Pin1宽-Pin2宽）×2/（Pin1宽+Pin2宽）
说明：对0402/0603的散热焊盘检查。
-------------------------------------------
*/
defun(Check_Thermal (n_percent)
let((SymID Pin1Width Pin2Width Pin1ID Pin2ID DifWidth ErrorOne P_temp SymBBox)
	axlClearSelSet()
	List_Error_Temp = '()
	SymID = axlSelectByName("SYMTYPE" '("*0805" "*0603" "*0402" "*0201") t)
	axlClearSelSet()
	foreach(n0 SymID
		Pin1Width = 0
		Pin2Width = 0
		Pin1ID = car(n0->pins)
		Pin2ID = cadr(n0->pins)
		SymBBox = list(car(Pin1ID->bBox) cadr(Pin2ID->bBox))
		unless(axlIsPointInsideBox(cadr(Pin1ID->bBox) SymBBox)
			SymBBox = list(car(Pin2ID->bBox) cadr(Pin1ID->bBox))
		)
		foreach(n1 axlDBGetConnect(Pin1ID t)
			foreach(n2 n1->segments
				if(Pin1ID->xy == car(n2->startEnd) || Pin1ID->xy == cadr(n2->startEnd) then
					Pin1Width = n2->width + Pin1Width				
				)
			)
		)
		foreach(n1 axlDBGetConnect(Pin2ID t)
			foreach(n2 n1->segments
				if(Pin2ID->xy == car(n2->startEnd) || Pin2ID->xy == cadr(n2->startEnd) then	
					Pin2Width = n2->width + Pin2Width
				)
			)
		)
		if(Pin1Width == 0 || Pin2Width == 0 then
			if(n0->isMirrored then
				Vis_Temp = list("BOARD GEOMETRY/OUTLINE" "ETCH/BOTTOM" "PIN/BOTTOM" "VIA CLASS/BOTTOM" "PACKAGE GEOMETRY/SILKSCREEN_BOTTOM")
			else
				Vis_Temp = list("BOARD GEOMETRY/OUTLINE" "ETCH/TOP" "PIN/TOP" "VIA CLASS/TOP" "PACKAGE GEOMETRY/SILKSCREEN_TOP")
			)
			
			ErrorOne = list(SymBBox concat(n0->refdes "\270\241\277\325\273\362\326\261\301\254\315\255\306\244\322\375\275\305") Vis_Temp)
			List_Error = append1(List_Error ErrorOne)	
		else
			DifWidth = min(Pin1Width Pin2Width)/(Pin1Width+Pin2Width)
			when(DifWidth < n_percent
				if(n0->isMirrored then
					Vis_Temp = list("BOARD GEOMETRY/OUTLINE" "ETCH/BOTTOM" "VIA CLASS/BOTTOM" "PIN/BOTTOM" "PACKAGE GEOMETRY/SILKSCREEN_BOTTOM")
				else
					Vis_Temp = list("BOARD GEOMETRY/OUTLINE" "ETCH/TOP" "VIA CLASS/TOP" "PIN/TOP" "PACKAGE GEOMETRY/SILKSCREEN_TOP")
				)
				
				ErrorOne = list(SymBBox concat(n0->refdes "\301\275\322\375\275\305\322\375\317\337\262\356\322\354\264\363") Vis_Temp)
				List_Error = append1(List_Error ErrorOne)
			)
		)
	)
)
)




/*
---------------------------------------------------------------------
函数：Check_ViaI(n_High_Layer)
输入：n_High_Layer（板沉铜厚，如1.34mil(1oz)） 过孔厚度，普通0.7mil/埋孔0.5mil/激光孔0.4mil）
说明：针对过孔合理性检查，过孔宽度>走线宽度
-------------------------------------------------------------------------
*/
defun(Check_ViaI (n_High_Layer);
let((VisList ViaID W D S1 S2 Wlist n_ThickVia ErrorOne List_Error_Temp)
	axlClearSelSet()
	ViaID = '()	
	VisList = '()
	List_Error_Temp = '()
	VisList = axlVisibleGet()
	axlVisibleDesign(t)
	axlSetFindFilter(?enabled '("NOALL" "vias") ?onButtons '("vias"))
	axlAddSelectAll()
	ViaID = axlGetSelSet()
	axlClearSelSet()
	axlVisibleSet(VisList)
	foreach(n0 ViaID
		when(n0->objType == "via" && n0->net->name != "GND"	
			if(n0->startEnd == '("ETCH/TOP" "ETCH/BOTTOM") then
				n_ThickVia = 0.7
			else
				n_ThickVia = 0.5
			)
			foreach(n1 axlDBGetConnect(n0 nil)
				if(n1->objType == "path" then	
					Wlist = '()	
					foreach(n2 n1->segments					
						if(n0->xy == car(n2->startEnd) || n0->xy == cadr(n2->startEnd) then
							Wlist = append1(Wlist n2->width)
						)
					)
					if(length(Wlist) == 1 then
						W = car(Wlist)
					else
						W = min(Wlist)
					)
					D = car(n0->pads)->parent->drillDiameter
					S1 = W*n_High_Layer
					S2 = 3.1416*(D+n_ThickVia)*n_ThickVia
					unless(S2 >= S1
						if(n0->bBox != car(last(List_Error_Temp)) then
							ErrorOne = list(n0->bBox "\271\375\277\327\323\353\322\375\317\337\275\330\303\346\273\375\317\340\262\356\314\253\264\363")
							;过孔与引线截面积相差太大
							List_Error_Temp = append1(List_Error_Temp ErrorOne)
						)
					)
				)
			)
		)
	)
	List_Error = append(List_Error List_Error_Temp)
)
)



/*
------------------------------------------------------
函数：SilkOnSold()
输入：无
说明：白油压开窗
规范：焊盘Soldermast中不能有Silkscreen
------------------------------------------------------
*/

defun(SilkOnSold ()
let((PINID VisList tRectLayer List_Error_Temp DetarDis0 DetarDis1 Rec_bBox)
	List_Error_Temp = '()
	DetarDis0 = axlMKSConvert(0.05 "mm" car(axlDBGetDesignUnits()))
	DetarDis1 = axlMKSConvert(0.2 "mm" car(axlDBGetDesignUnits()))
	tRectLayer = "BOARD GEOMETRY/DIMENSION"
	for(i 0 1
		if(i == 0 then
			VisList = list("PACKAGE GEOMETRY/SOLDERMASK_TOP" "BOARD GEOMETRY/SOLDERMASK_TOP" "PIN/SOLDERMASK_TOP")
		else
			VisList = list("PACKAGE GEOMETRY/SOLDERMASK_BOTTOM" "BOARD GEOMETRY/SOLDERMASK_BOTTOM" "PIN/SOLDERMASK_BOTTOM")
		)
		axlVisibleDesign(nil)
		foreach(n0 VisList
			axlVisibleLayer(n0 t)
		)
		axlSetFindFilter(?enabled '("NOALL" "SHAPES" "PINS" "LINESEGS") ?onButtons '("SHAPES" "PINS" "LINESEGS"))
		axlAddSelectAll()
		PINID = axlGetSelSet()
		axlClearSelSet()
		axlVisibleDesign(nil)
		if(i == 0 then
			VisList = list("PACKAGE GEOMETRY/SILKSCREEN_TOP" "BOARD GEOMETRY/SILKSCREEN_TOP" "REF DES/SILKSCREEN_TOP") ;"BOARD GEOMETRY/DIMENSION"
		else
			VisList = list("PACKAGE GEOMETRY/SILKSCREEN_BOTTOM" "BOARD GEOMETRY/SILKSCREEN_BOTTOM" "REF DES/SILKSCREEN_BOTTOM"); "BOARD GEOMETRY/DIMENSION"
		)
		foreach(n0 VisList
			axlVisibleLayer(n0 t)
		)
		axlSetFindFilter(?enabled '("NOALL" "LINESEGS" "SHAPES" "TEXT") ?onButtons '("LINESEGS" "SHAPES" "TEXT"))
		foreach(n0 PINID
			axlSingleSelectBox(n0->bBox)
			foreach(n1 axlGetSelSet()
				when(n1->objType == "text"
					;bBoxAdd(n1->bBox list(list(DetarDis DetarDis) list(-DetarDis -DetarDis)))
					case(n1->rotation
						(0.0 		Rec_bBox =  bBoxAdd(n1->bBox list(list(DetarDis0 DetarDis1) list(-DetarDis0 0))))
						(90.0 	Rec_bBox =  bBoxAdd(n1->bBox list(list(0 DetarDis0) list(-DetarDis1 -DetarDis0))))
						(180.0 	Rec_bBox =  bBoxAdd(n1->bBox list(list(DetarDis0 0) list(-DetarDis0 -DetarDis1))))
						(270.0 	Rec_bBox =  bBoxAdd(n1->bBox list(list(DetarDis1 DetarDis0) list(0 -DetarDis0))))
						(t 			Rec_bBox =  n1->bBox)
					)
					n1 = car(axlDBCreateRectangle(Rec_bBox nil tRectLayer nil nil))
				)
				when(axlAirGap(n0 n1 nil 'anyLayer) == 0 && caar(last(List_Error_Temp)) != n0->bBox
					if(i == 0 then
						ErrorOne = list(n0->bBox "\302\314\323\315\277\252\264\260\311\317\323\320\260\327\323\315" list("BOARD GEOMETRY/OUTLINE" "PACKAGE GEOMETRY/SILKSCREEN_TOP" "BOARD GEOMETRY/SILKSCREEN_TOP" "REF DES/SILKSCREEN_TOP" "PACKAGE GEOMETRY/SOLDERMASK_TOP" "BOARD GEOMETRY/SOLDERMASK_TOP" "PIN/SOLDERMASK_TOP"))							
					else
						ErrorOne = list(n0->bBox "\302\314\323\315\277\252\264\260\311\317\323\320\260\327\323\315" list("BOARD GEOMETRY/OUTLINE" "PACKAGE GEOMETRY/SILKSCREEN_BOTTOM" "BOARD GEOMETRY/SILKSCREEN_BOTTOM" "REF DES/SILKSCREEN_BOTTOM" "PACKAGE GEOMETRY/SOLDERMASK_BOTTOM" "BOARD GEOMETRY/SOLDERMASK_BOTTOM" "PIN/SOLDERMASK_BOTTOM"))							
					)
					List_Error_Temp = append1(List_Error_Temp ErrorOne)
				)
				when(n1->layer == "BOARD GEOMETRY/DIMENSION"
					axlDeleteObject(n1)
				)
			)
		)
	)
	axlClearSelSet()
	List_Error = append(List_Error_Temp List_Error)
)
)



/*
------------------------------------------------------
函数：Check_DFT_TP2Place_Bound()
输入：无
输出：问题测试点DBID List_Error
说明：测试点离BGA封装底部距离.
规范：BGA背面5mm范围内不得有测试点。
------------------------------------------------------

defun(Check_DFT_TP2Place_Bound ()
let((TPID Same_Mirror_ID Place_Bound_ID Drmm)
	axlClearSelSet()
	Same_Place_Bound_ID = '()
	TPID = axlSelectByName("SYMTYPE" "TP*" t)
	foreach(n0 axlSelectByName("SYMTYPE" "*" t)
		when(car(TPID)->isMirrored = n0->isMirrored
			Same_Mirror_ID = append1(Same_Mirror_ID n0)
		)
	)
	println(Same_Place_Bound_ID)
	TP_Place_Bound_ID = '()
	Other_Place_Bound_ID = '()
	foreach(n0 Same_Mirror_ID
		foreach(n1 TPID
			foreach(n2 n1->children
				if(rexMatchp("^PACKAGE GEOMETRY/PLACE_BOUND*" n2->layer) then
					TP_Place_Bound_ID = n2
				)
			)
			foreach(n3 n0->children
				if(rexMatchp("^PACKAGE GEOMETRY/PLACE_BOUND*" n3->layer) then
					Other_Place_Bound_ID = n3
				)
			)
			Drmm = axlMKSConvert(axlAirGap(TP_Place_Bound_ID Other_Place_Bound_ID nil 'anyLayer) car(axlDBGetDesignUnits()) "mm")
			when(Drmm == 0
				Vis_Temp = list("BOARD GEOMETRY/OUTLINE" "PACKAGE GEOMETRY/SILKSCREEN_TOP" "PIN/TOP" "PACKAGE GEOMETRY/SILKSCREEN_BOTTOM" "PIN/BOTTOM")
				ErrorOne = list(car(n1->pins)->bBox concat(n1->refdes "\262\342\312\324\265\343\314\253\277\277\275\374" n0->refdes "\312\265\262\342:" axlGeo2Str(Drmm) "mm  \271\346\267\266:"  "mm") Vis_Temp)
				List_Error = append1(List_Error ErrorOne)
			)
		)
	)
)
)
*/

/*
------------------------------------------------------
函数：TPNumber(n_number)
输入：无
输出：问题测试点DBID List_Error
说明：测试点数量/名称检测。
规范：
------------------------------------------------------
*/


defun(TPNumber (n_number) 
let((TPGND_Number TPPinID TPSym)
	TPGND_Number = 0
	TPPinID = '()
	TPID = axlSelectByName("SYMTYPE" "TP*" t)
	axlClearSelSet()
	TPSym = list("TP_C1_70DC1_10" "TP_ATB" "TP_C1_60DC1_00" "TP1_00MM-2_20MM" "TP254" "TP_1MM" "TP0_80MM-2_20MM" "TP_2MM" "TP1_00MM-2_00MM" "TP_C1_60DC1_00")
	foreach(n0 TPID
		unless(rexMatchList(n0->name TPSym)
			println(n0->name)
			if(n0->isMirrored then
				Vis_Temp = list("BOARD GEOMETRY/OUTLINE" "PACKAGE GEOMETRY/SILKSCREEN_BOTTOM" "PIN/BOTTOM")
			else
				Vis_Temp = list("BOARD GEOMETRY/OUTLINE" "PACKAGE GEOMETRY/SILKSCREEN_TOP" "PIN/TOP")
			)
			ErrorOne = list(car(n0->pins)->bBox concat(n0->refdes "\267\342\327\260\262\273\316\252" car(TPSym) "\273\362" cadr(TPSym)) Vis_Temp)
			List_Error = append1(List_Error ErrorOne)
		)
	)
	foreach(n0 TPID
		if(car(n0->pins)->net->name == "GND" then
			TPGND_Number++
			TPPinID = append1(TPPinID car(n0->pins))
		)
	)
	if(TPGND_Number < n_number then
		foreach(n0 TPPinID
			if(n0->isMirrored then
				Vis_Temp = list("BOARD GEOMETRY/OUTLINE" "PACKAGE GEOMETRY/SILKSCREEN_BOTTOM" "PIN/BOTTOM")
			else
				Vis_Temp = list("BOARD GEOMETRY/OUTLINE" "PACKAGE GEOMETRY/SILKSCREEN_TOP" "PIN/TOP")
			)
			ErrorOne = list(n0->bBox concat("\265\330\262\342\312\324\265\343\326\273\323\320" TPGND_Number "\270\366  \271\346\267\266\316\252" n_number "\270\366") Vis_Temp) 
			List_Error = append1(List_Error ErrorOne)
		)
	)
)
)

defun(TP2TP ()
let((TPID)
	;println(11)
	TPID = axlSelectByName("SYMTYPE" "TP*" t)
	foreach(n0 TPID
		foreach(n1 n0->component->symbol->children->?
			println(n1->layer )
		)
	)
)
)
		
/*
------------------------------------------------------
函数：WaveSold()
输入：无
输出：问题测试点DBID List_Error
说明：测试点离波峰焊引脚5mm
规范：
------------------------------------------------------
*/


defun(WaveSold ()
let((SymID ThroughPinID Dr TPID Dismm PadID TPPinID LL AllSMTEn)
	axlClearSelSet()
	SymID = axlDBGetDesign()->symbols
	Dr = axlMKSConvert(5 "mm" car(axlDBGetDesignUnits()))
	TPID = axlSelectByName("COMPREFDES" "TP*" t)
	axlClearSelSet()
	PinID = '()
	TPPinID = '()
	ThroughPinID = '()
	foreach(n0 SymID
		AllSMTEn = t
		foreach(n1 n0->pins
			AllSMTEn = AllSMTEn && n1->isThrough
		)
		when(AllSMTEn && n0->pins
			PinID = append(PinID n0->pins)
		)
	)
	foreach(n0 TPID
		when(n0->pins
			TPPinID = append(TPPinID n0->pins)
		)
	)
	foreach(n0 PinID
		when(n0->isThrough && axlDBGetDrillPlating(n0->definition->name) == "PLATED"
			ThroughPinID = append1(ThroughPinID n0)
		)
	)
	foreach(n0 ThroughPinID
		foreach(n1 TPPinID
			LL = axlAirGap(n0 n1 nil 'anyLayer)
			when(LL
			
				if((LL < Dr) && ((n0->isThrough) == !(n1->isThrough)) then
					Dismm = axlMKSConvert(LL car(axlDBGetDesignUnits()) "mm")
					if(n1->isMirrored then
						Vis_Temp = list("BOARD GEOMETRY/OUTLINE" 
							"PACKAGE GEOMETRY/SILKSCREEN_BOTTOM" 
							"PIN/BOTTOM"
						)
					else
						Vis_Temp = list("BOARD GEOMETRY/OUTLINE" 
							"PACKAGE GEOMETRY/SILKSCREEN_TOP" 
							"PIN/TOP"
						)
					)
					ErrorOne = list(n1->bBox concat(n1->parent->refdes 
						"\314\253\277\277\275\374\262\250\267\345\272\270\306\367\274\376" 
						n0->parent->refdes "  PIN" n0->number 
						"\265\304\276\340\300\353\316\252\243\272" axlGeo2Str(Dismm) 
						"mm  \271\346\267\266\316\2525mm") Vis_Temp
					)
					List_Error = append1(List_Error ErrorOne)
				)
			)
		)
	)
	t
	
)
)





/*
------------------------------------------------------
函数：Check_DFT_Tp2FixHoles()
输入：无
说明：测试点到定位孔距离不小于5mm。
------------------------------------------------------
*/

defun(Check_DFT_Tp2FixHoles ()
let((Outline_iscicle OutlineID R1 R2 Rt FixHolesList TPID Dn Dt)

	;-----初始化------
	axlClearSelSet()
	Dn = axlMKSConvert(5 "mm" car(axlDBGetDesignUnits())) ;定位孔到测试点中心距离为5mm	
	FixHolesList = '()	
	OutlineID = '()
	;-----------------
	
	axlVisibleDesign(nil)
	axlVisibleLayer("BOARD GEOMETRY/OUTLINE" t)
	axlSetFindFilter(?enabled '("NOALL" "lines" "shapes") ?onButtons '("lines" "shapes"))
	axlAddSelectAll()
	OutlineID = axlGetSelSet()
	axlClearSelSet()
	
	foreach(n0 OutlineID
		if(n0->objType == "polygon" || n0->objType == "path" then
			Outline_iscicle = 1
			foreach(n1 n0->segments
				unless(n1->radius
					Outline_iscicle = 0
				)
			)
			if(Outline_iscicle == 1 then
				Rt = (car(n0->segments)->radius)*2
				R1 = axlMKSConvert(1.7 "mm" car(axlDBGetDesignUnits()))
				R2 = axlMKSConvert(5.5 "mm" car(axlDBGetDesignUnits()))
				if(Rt>=R1 && Rt<=R2 then
					FixHolesList = append1(FixHolesList n0)
				)
			)
		)
	)
	TPID = axlSelectByName("SYMTYPE" "TP*" t)
	axlClearSelSet()
	foreach(n2 FixHolesList
		foreach(n3 TPID
			Dt = axlDistance(car(n2->segments)->xy n3->xy)
			if(Dt < Dn then
				if(n3->isMirrored then
					Vis_Temp = list("BOARD GEOMETRY/OUTLINE" "PACKAGE GEOMETRY/SILKSCREEN_BOTTOM" "PIN/BOTTOM")
				else
					Vis_Temp = list("BOARD GEOMETRY/OUTLINE" "PACKAGE GEOMETRY/SILKSCREEN_TOP" "PIN/TOP")
				)
				ErrorOne = list(car(n3->pins)->bBox concat(n3->refdes "\314\253\277\277\275\374\266\250\316\273\277\327\241\243\271\346\266\250\312\307:5mm") Vis_Temp)
				List_Error = append1(List_Error ErrorOne)
			)
		)
	)
)
)

/*
------------------------------------------------------
函数：TPOnDiffpair()
输入：无
说明：测试点在差分信号中的约束
规范：两测试点中心距小于2mm。测试点靠近连接器位置10mm内(未编写)
------------------------------------------------------
*/
defun(TPOnDiffpair ()
let((DifPair TPDifPairID TPID Dr Dis ErrorOne Dismm TT)
	axlClearSelSet()
	DifPair = axlDBGetDesign()->diffpair
	TPDifPairID = '()
	Dr = axlMKSConvert(2 "mm" car(axlDBGetDesignUnits()))
	TPID = axlSelectByName("SYMTYPE" "TP*" t)
	axlClearSelSet()
	foreach(n0 DifPair
		foreach(n1 TPID
			if(car(n1->pins)->net->diffpair == n0 then
				TPDifPairID = append1(TPDifPairID car(n1->pins))
				if(n1->isMirrored then
					Vis_Temp = list("BOARD GEOMETRY/OUTLINE" "PACKAGE GEOMETRY/SILKSCREEN_BOTTOM" "PIN/BOTTOM")
				else
					Vis_Temp = list("BOARD GEOMETRY/OUTLINE" "PACKAGE GEOMETRY/SILKSCREEN_TOP" "PIN/TOP")
				)
			)
		)
	)
	for(i 0 length(TPDifPairID)/2-1
		Dis = axlAirGap(nth(i*2 TPDifPairID) nth(i*2+1 TPDifPairID) "PIN/SOLDERMASK_TOP" 'anyLayer)
		if(Dis > Dr then
			Dismm = axlMKSConvert(Dis car(axlDBGetDesignUnits()) "mm")
			ErrorOne = list(nth(i*2 TPDifPairID)->bBox concat("\262\356\267\326\262\342\312\324\265\343" nth(i*2 TPDifPairID)->parent->refdes "\323\353" nth(i*2+1 TPDifPairID)->parent->refdes "\276\340\300\353\314\253\324\266\243\254\312\265\262\342\243\272" axlGeo2Str(Dismm) "mm, \271\346\267\266\316\2522mm") Vis_Temp)
			List_Error =	append1(List_Error ErrorOne)
			ErrorOne = list(nth(i*2+1 TPDifPairID)->bBox concat("\262\356\267\326\262\342\312\324\265\343" nth(i*2+1 TPDifPairID)->parent->refdes "\323\353" nth(i*2 TPDifPairID)->parent->refdes "\276\340\300\353\314\253\324\266\243\254\312\265\262\342\243\272" axlGeo2Str(Dismm) "mm, \271\346\267\266\316\2522mm") Vis_Temp)
			List_Error =	append1(List_Error ErrorOne)
		)
	)
	
)
)



/*
------------------------------------------------------
函数：Check_DFT_Tp2HighPlaceBound()
输入：无
说明：测试点到高器件的距离
规范：H：器件高度 Ds：器件边与测试点中心距离。
			当H >= 6mm时，Ds = H/2
			当H <= 5mm时，Ds封装实现避让.
------------------------------------------------------
*/

defun(Check_DFT_Tp2HighPlaceBound ()
let((PBSID Hpb TPID Hpb6MM Hpb5MM H6mmPBID TPPBID ErrorOne tt)
	axlClearSelSet()
	TPID = axlSelectByName("SYMTYPE" "TP*" t)
	axlClearSelSet()
	H6mmPBID = '()
	TPPBID = '()
	if(car(TPID)->isMirrored then
		PBSID = axlDBGetShapes("PACKAGE GEOMETRY/PLACE_BOUND_BOTTOM")
	else
		PBSID = axlDBGetShapes("PACKAGE GEOMETRY/PLACE_BOUND_TOP")
	)	
	Hpb6MM = axlMKSConvert(6 "mm" car(axlDBGetDesignUnits()))
	foreach(n0 PBSID
		tt = cadar(rexMatchAssocList("PACKAGE_HEIGHT_MAX" axlDBGetProperties(n0)))
		when(tt
			Hpb = atof(car(parseString(tt)))
			cond(
				(rexMatchp("^TP+" n0->parent->name)
					TPPBID = append1(TPPBID n0)
					remd(n0 PBSID)
				)
				(Hpb >= Hpb6MM 	H6mmPBID = append1(H6mmPBID n0))
				(t nil)
			)
		)
	)
	
	foreach(n0 H6mmPBID
		tt = cadar(rexMatchAssocList("PACKAGE_HEIGHT_MAX" axlDBGetProperties(n0)))
		if(n0->parent->isMirrored then
			Vis_Temp = list("BOARD GEOMETRY/OUTLINE" "PACKAGE GEOMETRY/PLACE_BOUND_BOTTOM" "PACKAGE GEOMETRY/SILKSCREEN_BOTTOM" "PIN/BOTTOM")
		else
			Vis_Temp = list("BOARD GEOMETRY/OUTLINE" "PACKAGE GEOMETRY/PLACE_BOUND_TOP" "PACKAGE GEOMETRY/SILKSCREEN_TOP" "PIN/TOP")
		)
		when(tt
			Hpb = atof(car(parseString(tt)))
			foreach(n1 TPPBID
				if(axlAirGap(n0 n1 nil 'anyLayer) < Hpb/2 && rexMatchp("^TP*" n1->parent->refdes) then
 					ErrorOne = list(n1->bBox concat(n1->parent->refdes "\314\253\277\277\275\374\270\337\306\332\274\344" n0->parent->refdes) Vis_Temp)
					List_Error = append1(List_Error ErrorOne)
				)	
			)
		)
	)
	foreach(n0 PBSID
		tt = cadar(rexMatchAssocList("PACKAGE_HEIGHT_MAX" axlDBGetProperties(n0)))
		if(n0->parent->isMirrored then
			Vis_Temp = list("BOARD GEOMETRY/OUTLINE" "PACKAGE GEOMETRY/PLACE_BOUND_BOTTOM" "PACKAGE GEOMETRY/SILKSCREEN_BOTTOM" "PIN/BOTTOM")
		else
			Vis_Temp = list("BOARD GEOMETRY/OUTLINE" "PACKAGE GEOMETRY/PLACE_BOUND_TOP" "PACKAGE GEOMETRY/SILKSCREEN_TOP" "PIN/TOP")
		)
		when(tt
			Hpb = atof(car(parseString(tt)))
			foreach(n1 TPPBID				
				if(axlAirGap(n0 n1 nil 'anyLayer) == 0 then
					ErrorOne = list(n1->bBox concat(n1->parent->refdes "\323\353" n0->parent->refdes "\327\262\274\376") Vis_Temp)
					List_Error = append1(List_Error ErrorOne)
				)
			)
		)
	)
)
)





/*
--------------------------------------------------------------------------
函数：Check_Crystal_Layout()
输入：无
说明：晶振走线检查。
已完成:底部是否有走线检查
待完成：1、走线间距，2、器件布局（特别是电容）
--------------------------------------------------------------------------
*/

defun(Check_Crystal_Layout ()
let((CryID VisList CryPinNetID ViaID)
	
	ViaID = '()
	CryPinNetID = '()	
	axlClearSelSet()
	CryID = axlSelectByName("SYMTYPE" '("Y_SMCE*") t)	
	axlHighlightObject(CryID)
	axlClearSelSet()
	axlVisibleDesign(nil)
	axlVisibleLayer("ETCH" t)
	axlSetFindFilter(?enabled '("NOALL" "nets") ?onButtons '("nets"))
	foreach(n0 CryID
		foreach(n1 n0->pins
			CryPinNetID = append1(CryPinNetID n1->net)
		)
		foreach(n2 n0->children
			if(n2->layer == "PACKAGE GEOMETRY/PLACE_BOUND_TOP" || n2->layer == "PACKAGE GEOMETRY/PLACE_BOUND_BOTTOM" then
				axlAddSelectBox(n2->bBox)
			)
		)
	)	
	ViaID = axlGetSelSet()	
	axlClearSelSet()
	axlHighlightObject(CryID)
	foreach(n3 CryPinNetID	
		ViaID = remdq(n3 ViaID)
	)
	if(ViaID then		
		axlHighlightObject(ViaID)
		printf("\271\346\267\266\243\272\276\247\325\361\265\327\262\277\262\273\304\334\323\320\327\337\317\337\241\243\312\265\262\342\243\272\323\320%d\270\371\327\337\317\337\243\254\322\321\270\337\301\301\241\243\n" length(ViaID))
		;规范：晶振底部不能有走线。实测：有%d根走线，已高亮。
	)

)
)




/*
------------------------------------------------------
函数：Check_Crystal_Place(n_length)
输入：距离(mm)
说明：针对较脆的器件进行布局，离板边多少距离（待定）
------------------------------------------------------
*/


defun(Check_Crystal_Place (n_length)
	let((LSymCryID n_lengthCon)
		n_lengthCon = axlMKSConvert(n_length+1.5 "mm" car(axlDBGetDesignUnits()))
		axlClearSelSet()
		OutlineShapeID = axlDBGetShapes("BOARD GEOMETRY/OUTLINE")	
		OutlineShapePlog = axlPolyFromDB(car(OutlineShapeID))
		OutlineShapeSmallPlog = axlPolyExpand(OutlineShapePlog -n_lengthCon 'ALL_ARC)
		DesignID = axlDBGetDesign()->symbols
		shapeID = append(axlDBGetShapes("PACKAGE GEOMETRY/PLACE_BOUND_TOP") axlDBGetShapes("PACKAGE GEOMETRY/PLACE_BOUND_BOTTOM"))
		ployID = '()
		foreach(n0 shapeID
			unless(rexMatchp("^[J].*" n0->parent->name)
				axlPolyFromDB(n0)
				ployID = append(axlPolyFromDB(n0) ployID)
			)
		)
		;println(car(axlPolyOperation(ployID OutlineShapeSmallPlog 'OR))->bBox)
		;println(car(OutlineShapeSmallPlog)->bBox)
		if(axlPolyOperation(ployID OutlineShapeSmallPlog 'OR) == OutlineShapeSmallPlog then
			t;println(11)		
		
		)
	)
)


/*
------------------------------------------------------
函数：Check_BT_Layout()
输入：无
说明：对电池下端走线进行检查。
------------------------------------------------------
*/
defun(Check_BT_Layout ()
	BTonTom = car(axlSelectByName("SYMTYPE" "BT_*" t))->isMirrored
	if(BTonTom = nil then
		BTOnLayer = "TOP"
	else
		BTOnLayer = "BOTTOM"
	)
	L_KEY = axlSelectByName("SYMTYPE" "KEY_*" t)
	NumTopKey = 0
	NumBotKey = 0
	foreach(n0 L_KEY
		if(n0->isMirrored then
			NumBotKey++
		else
			NumTopKey++
		)
	)
	if(NumTopKey >= NumBotKey then
		KeyOnLayer = "TOP"
	else
		KeyOnLayer = "BOTTOM"
	)
	if(BTOnLayer = KeyOnLayer then
		println("BT and Key Are On The Same Layer")
	else
		println("BT and Key Are On Difference Layer")	
	)
	axlClearSelSet()
)



