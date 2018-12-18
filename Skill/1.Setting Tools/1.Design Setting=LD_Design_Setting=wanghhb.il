
;函数LD_Design_Setting() 窗口设计设置（线宽，线距。。）
axlCmdRegister("LD_Design_Setting" 'LD_Design_Setting)
defun(LD_Design_Setting ()
  form = axlFormCreate( (gensym) strcat(FormPath,"LD_Design_Setting.form")  nil `LD_Design_Setting_Form_callBack t)
  Design_Setting_initCols()
  Design_Setting_initRows()
  axlFormAutoResize(form)

  axlFormDisplay(form)
  ;axlUIWPrint(form "Note: 2013-07-21")
)

procedure( Design_Setting_initCols()
let( (lf pp)

	lf = form

	p = make_formGridCol()
	
	p->fieldType = 'TEXT
	p->colWidth = 4
	p->headText = "Net Name"
	p->scriptLabel = nil
	axlFormGridInsertCol(lf "GridNet" p)
	
	p->fieldType = 'ENUMSET
	p->colWidth = 4
	p->align = 'left
	p->popup = "penum"
	p->headText = "\312\364\320\324"
	axlFormGridInsertCol(lf "GridNet" p)
	p->popup = nil
	
	
/*	
	p->fieldType = 'TEXT
	p->colWidth = 4
	p->headText = "Text"
	p->scriptLabel = nil
	axlFormGridInsertCol(lf "GridNet" p)

	p->fieldType = 'CHECKITEM
	p->colWidth = 4
	p->align = 'center
	p->headText = "Check"
	p->scriptLabel = "check"
	axlFormGridInsertCol(lf "GridNet" p)


	p->fieldType = 'ENUMSET
	p->colWidth = 4
	p->align = 'left
	p->popup = "penum"
	p->headText = "DropDown"
	axlFormGridInsertCol(lf "GridNet" p)
	p->popup = nil

	p->fieldType = 'STRING
	p->colWidth = 4
	p->align = 'left
	p->fieldLength = 32
	p->headText = "Fillin Data"
	axlFormGridInsertCol(lf "GridNet" p)

	p->fieldType = 'LONG
	p->colWidth = 4
	p->align = 'right
	p->fieldLength = 4
	p->min = 1
	p->max = 50
	p->headText = "Integer"
	axlFormGridInsertCol(lf "GridNet" p)

	p->fieldType = 'REAL
	p->colWidth = 4
	p->fieldLength = 8
	p->min = 0.0
	p->max = 32.0
	p->decimals = 1
	p->headText = "Real"
	axlFormGridInsertCol(lf "GridNet" p)

*/





)
)

procedure( Design_Setting_initRows()
prog( (lf)
	lf = form
	axlFormGridInsertRows(lf "GridNet" 0 1)
	;axlFormGridSetBatch(lf, "GridNet" `rowsCB, readOnly)
)







) 

procedure( LD_Design_Setting_Form_callBack(form)
prog( ()
    ;axlUIWPrint(form,form->curField)
    case(form->curField
        ("Label3"
            ;if( form->curValue then 
                
            ;);if
        );Label3

        ("Label1"
            ;if( form->curValue then 
                
            ;);if
        );Label1

        ("Combo1"
            ;if( form->curValue then 
            ;    print(form->curValue)
            ;);if
        );Combo1

        ("Label2"
            ;if( form->curValue then 
                
            ;);if
        );Label2

        ("Combo2"
            ;if( form->curValue then 
            ;   print(form->curValue)
            ;);if
        );Combo2

        ("Combo3"
            ;if( form->curValue then 
            ;    print(form->curValue)
            ;);if
        );Combo3

        ("Label4"
            ;if( form->curValue then 
                
            ;);if
        );Label4

        ("Combo4"
            ;if( form->curValue then 
            ;   
            ;);if
        );Combo4

        ("Label5"
            ;if( form->curValue then 
                
            ;);if
        );Label5

        ("PCB_Name"
            if( form->curValue then 
                print(form->curValue) 
            );if
        );PCB_Name

        ("Label6"
            ;if( form->curValue then 
                
            ;);if
        );Label6

        ("Input2"
            ;if( form->curValue then 
                
            ;);if
        );Input2

        ("Label7"
            ;if( form->curValue then 
                
            ;);if
        );Label7

        ("Label8"
            ;if( form->curValue then 
                
            ;);if
        );Label8

        ("Input3"
            ;if( form->curValue then 
                
            ;);if
        );Input3

        ("Updown1"
            ;if( form->curValue then 
                
            ;);if
        );Updown1

        ("Label9"
            ;if( form->curValue then 
                
            ;);if
        );Label9

        ("NetView1"
            if( form->curValue then 
                 print(form->curValue) 
            );if
        );NetView1

        ("Net_Select"
            if( form->curValue then 
                axlUIDataBrowse('NET '(RETRIEVE_NAME) "NET\321\241\324\361" t)
              
            );if
        );Net_Select

        ("Input4"
            ;if( form->curValue then 
                
            ;);if
        );Input4

        ("OK"
            ;if( form->curValue then 
                
            ;);if
        );Button3

        ("Cancel"
            ;if( form->curValue then 
                
            ;);if
        );Button4

        ("Apply"
            ;if( form->curValue then 
                
            ;);if
        );Button5

        (t printf("Good Bye.\n")  )

    );case
    if(nequal(form->doneState 0) then
    axlFormClose(form));if
);prog
);procedure
