;                     Conversion Utility
;                     ------------------

; This routine is a very simple conversion utility that will
; convert between mils and mm. Simply enter the value to be
; converted in the required box, and the conversion is done.

; The form can be displayed at the same time as other forms
; in Allegro, for example the 'Show Measure' form, so values
; can be typed in directly from one form to the other. 

; To run the utility type "conv" on the Allegro command line.

; -----------------------------------------------------------------

; Tested on Allegro 11.0

; Pete Court
; PCB Design Engineer
; While working at:

; Fujitsu Telecommunications Europe Limited
; Solihull Parkway
; Birmingham Business Park
; Birmingham
; B37 7YU
; UK

; I can now be reached at the following address:

; E-Mail: pc@earthling.net
 
; -----------------------------------------------------------------
 axlCmdRegister( "conv" 'conv)
defun(conv ()
prog((mm mils convform)
	mm=nil
	mils=nil
	createconvform()
	convform = axlFormCreate( (gensym) "conv.form" nil 'Conv_Action t)
	deleteFile("./conv.form")
	axlFormDisplay(convform)
	axlFormAutoResize(convform)
)
)


defun(createconvform ()
let(()
	convform = outfile("./conv.form")
	fprintf(convform "FILE_TYPE=FORM_DEFN VERSION=2\n")
	fprintf(convform "FORM\n")
	fprintf(convform "FIXED\n")
	fprintf(convform "PORT 37 10\n")
	fprintf(convform "HEADER \"mils\323\353mm\273\273\313\343\306\367\"\n")
	
	fprintf(convform "TILE\n")
	fprintf(convform "FIELD mils\n")
	fprintf(convform "FLOC 1 2\n")
	fprintf(convform "STRFILLIN 10 10\n")
	fprintf(convform "ENDFIELD\n")
	
	fprintf(convform "FIELD mm\n")
	fprintf(convform "FLOC 22 2\n")
	fprintf(convform "STRFILLIN 10 10\n")
	fprintf(convform "ENDFIELD\n")
	
	fprintf(convform "TEXT \"mils\"\n")
	fprintf(convform "TLOC 13 2\n")
	fprintf(convform "ENDTEXT\n")
	
	fprintf(convform "TEXT \"mm\"\n")
	fprintf(convform "TLOC 34 2\n")
	fprintf(convform "ENDTEXT\n")
	
	fprintf(convform "TEXT \"<-->\"\n")
	fprintf(convform "TLOC 17 2\n")
	fprintf(convform "ENDTEXT\n")
	
	fprintf(convform "TEXT \"\312\344\310\353\317\340\323\246\312\375\327\326\243\254\275\341\271\373\317\324\312\276\324\332\301\355\322\273\312\344\310\353\277\362\241\243\"\n")
	fprintf(convform "TLOC 2 8\n")
	fprintf(convform "ENDTEXT\n")
	
	fprintf(convform "GROUP \"\313\265\303\367\"\n")
	fprintf(convform "GLOC 1 5\n")
	fprintf(convform "GSIZE 36 6\n")
	fprintf(convform "ENDGROUP\n")
	
	fprintf(convform "ENDTILE\n")
	fprintf(convform "ENDFORM\n")
	close(convform)
)
)

 
defun(Conv_Action (convform)
prog(()
	(case convform->curField
	   ("mils"
	    mils = convform->curValue
			if(rexMatchp("[^0-9.]+" mils) then
				axlFormSetField(convform "mils" "Error")
			else
	    	mils = evalstring(mils)
				if( mils > 393700787 then
					mm = "Error"
				else
		    	mm = axlMKSConvert(mils "MILS" "MM")
					sprintf(mm "%.3f" , mm)
				)
				axlFormSetField(convform "mm" mm)
			)
			t
    )
	 
    ("mm"
	    mm = convform->curValue
	 		if(rexMatchp("[^0-9.]+" mm) then 
				axlFormSetField(convform "mm" "Error") 
			else 
				mm = evalstring(mm)
				if(mm > 2539999 then
					mils = "Error"
				else
					mils = axlMKSConvert(mm "MM" "MILS")
					sprintf(mils "%.2f" , mils)
				)
				axlFormSetField(convform "mils" mils)
			)
	  	t
    )
    (t t)
	) 
)
)



