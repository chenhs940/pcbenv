axlCmdRegister( "sym_ver" 'x_sym_ver ?cmdType "general")

(defun x_sym_ver ()
		axlVisibleDesign(nil)
		axlVisibleLayer("BOARD GEOMETRY/OUTLINE" t)
		axlVisibleLayer("MANUFACTURING/TITLE" t)
		axlVisibleLayer("REF DES/SILKSCREEN_TOP" t)
		axlVisibleLayer("REF DES/SILKSCREEN_BOT" t)
		axlUIWUpdate(nil);	
		axlVisibleUpdate(t)
/*
		axlSetFindFilter( ?enabled list("noall")
				?onButtons "noall")
		axlSetFindFilter( ?enabled list("symbols")
				?onButtons "symbols")
;Ϊ�����������϶���¼�汾��Ϣ��׼��
*/
		axlSetFindFilter(?enabled '("NOALL" "TEXT") ?onButtons '("TEXT"))
		axlAddSelectAll()
		allsym = axlGetSelSet()
		sym_num = axlGetSelSetCount()/6                         ;���㺸�����Ϸ�װ���������ڶ�λ�ס�mark�ȷǺ��ӷ�װ������
		printf("Total  %d  symbols!" sym_num)
		tbom = "./BOM.txt" 
		sym_text(tbom)	
		formname = "./updatesym.scr" 
		scr_form(formname)		
		tbom = "./BOM1.txt" 
		sym_text(tbom)	
		resultform = "./com_result.txt"
		compare(resultform)
		note()
	;	resultform1 = "./result.log"
	;	finallog(resultform1)
)
/********************************************************************
�����к����������ı������У�ÿ����װ���汾Ϊһ��
*********************************************************************/
(defun sym_text (tbom) 
			axlSetFindFilter( ?enabled list("noall")
				?onButtons "noall")
			axlSetFindFilter( ?enabled list("symbols")
				?onButtons "symbols")
			axlAddSelectAll()
				allsym = axlGetSelSet()
		bom = outfile(tbom "w")	
	foreach(eachsym allsym
	 alltext = axlDBGetAttachedText(eachsym) 
		foreach(thistext alltext    			    
                 	if(thistext -> layer == "MANUFACTURING/TITLE" && rexMatchp("VERSION" thistext->text)
			then
				fprintf(bom eachsym -> name)
				fprintf(bom " " )   
				fprintf(bom  thistext -> text )
				fprintf(bom  "\n")  
			)  
			)   			        			
		     )  					 
		close(bom)
		axlClearSelSet()
)
/********************************************************************
�������з�װ
*********************************************************************/
(defun scr_form (formname)
	updatesym = outfile(formname "w")
		fprintf(updatesym "version 16.3\n")
		fprintf(updatesym "refresh symbol\n")
		fprintf(updatesym "setwindow form.upd_element\n")
		fprintf(updatesym "FORM upd_element tree 'MULTISEL YES' 'Package symbols'    \n")
		fprintf(updatesym "FORM upd_element tree  'Package symbols'    \n")
		fprintf(updatesym "FORM upd_element tree 'MULTISEL YES' 'Shape and flash symbols'    \n")
		fprintf(updatesym "FORM upd_element tree  'Package symbols'    \n")
		fprintf(updatesym "FORM upd_element tree  'Shape and flash symbols'   \n")
		fprintf(updatesym "FORM upd_element padstacks YES\n")
		fprintf(updatesym "FORM upd_element reset_drill_data YES\n")
		fprintf(updatesym "FORM upd_element reset_symbol_text YES\n")
		fprintf(updatesym "FORM upd_element ignore_fixed YES \n")
		fprintf(updatesym "FORM upd_element refresh \n")
		fprintf(updatesym "FORM upd_element close \n")
		fprintf(updatesym "generaledit  \n")
		
		close(updatesym)
	axlShell("replay updatesym.scr")
		;printf("\n===symbol update is finished !====\n ## Thank you for using it ##\n")
		;axlGetDrawingName()
		;shell("del *.scr")
)
/********************************************************************
�Ƚϸ���ǰ���б仯�ķ�װ����ӡ���ı������û�в�ͬ����ʾ��˵���޲�ͬ
*********************************************************************/
(defun compare (resultform)	
(prog ()
	q0 = list()
	q1 = list()	
	result = outfile(resultform "w")
	b0 = infile("./BOM.txt")
	b1 = infile("./BOM1.txt")
	when( b0
		while(gets(currentline0 b0)
		q0 = append1(q0 currentline0 )
			) 
	close(b0)  
	   	)
	when( b1
		while(gets(currentline1 b1)
		q1 = append1(q1 currentline1 )
			) 
	close(b1)        
		)
	q0 = ( sort q0 nil)
	q1 = ( sort q1 nil)
        l_q0 = length(q0)
;	println(q0)
;	println(q1)
	for(x 0 l_q0-1

			if(nth(x q0) != nth(x q1)
			fprintf(result "%s" nth(x q0))
			)
				)	
	close(b0)
	close(b1)	
	close(result)		
)
)
/********************************************************************
����Ϊ���°汾�������������ʾ�������ӡ���
*********************************************************************/
(defun note ()
	c1 = infile("./com_result.txt")
	if(
		gets(vline c1) == nil
	then	println("\n===ALL SYMBOLS ARE LASTEST VERSION !====\n")
	else    resultform1 = "./result.log"
		finallog(resultform1)
	)
	close(c1)
	shell("del *.txt")
)
/********************************************************************
���ȶԽ��ȥ�ز���ʾ��log�ļ��У�ɾ�������ļ�
*********************************************************************/
(defun finallog (resultform1)
(prog ()
	t1 = list()
	t2 = list()
	;	resultform1 = "./result.log"
		result1 = outfile(resultform1 "w")
		fprintf(result1 "************************************\n") 
		fprintf(result1 "symbol version is different!\n")
		fprintf(result1 "************************************\n")
		f1 = infile("./com_result.txt")	
		when( f1
			while(gets( nextline f1)		
		t1 = append1( t1 nextline )			
				)
		close(f1)	
			) 
		t1 = ( sort t1 nil)
		t2 = append1(t2 car(t1))
		l_t1 = length(t1)
		l_t2 = length(t2)
		for(m 0 l_t1-1
			for(n 0 l_t2-1 
				if(nth(m t1) != nth(l_t2-1 t2)
				t2 = append1(t2 nth(m t1))								
		 		)
			l_t2 = length(t2)	
			)
		) 
		for(o 0 length(t2)-1
			fprintf(result1 "%s" nth(o t2))	   
		 )
		close(result1)
))



	
		

	
	
		
	




