;DESCRIPTION: 2 layers PCB quick layer/colour view switch
;AUTHOR: Richard L.   fpmontreal@gmail.com
;
;some pre-define color, legal numbers are 1 to 24

axlCmdRegister( "qview" `QView)

c_white =1 c_qing   =6 	c_ltgreen=12 c_dkzi =17
c_ltblue=2 c_red    =7	c_golden =13 c_gray =19
c_pink  =3 c_yellow =8 	c_ltpink =14 c_jiang=22
c_cyan  =4 c_dkblue =9 	c_mud    =15 c_black=23
c_zi    =5 c_dkgray =11	c_blue   =16

qvcs='(
; you may add many layers as you want:)
;  q_name            q_layers
("Top_etch"          ("ETCH/TOP" "VIA CLASS/TOP" "PIN/TOP" "BOARD GEOMETRY/OUTLINE"))
("Top_silk"          ("PACKAGE GEOMETRY/SILKSCREEN_TOP" "REF DES/SILKSCREEN_TOP" "PIN/TOP" "BOARD GEOMETRY/OUTLINE"))
("Top_auto_silk"     ("MANUFACTURING/AUTOSILK_TOP" "PIN/TOP" "BOARD GEOMETRY/OUTLINE"))
("Top_assembly"      ("PIN/TOP" "REF DES/ASSEMBLY_TOP" "PACKAGE GEOMETRY/ASSEMBLY_TOP" "BOARD GEOMETRY/ASSEMBLY_TOP" "BOARD GEOMETRY/OUTLINE"))
("Top_value"         ("PIN/TOP" "COMPONENT VALUE/ASSEMBLY_TOP" "PACKAGE GEOMETRY/ASSEMBLY_TOP" "BOARD GEOMETRY/ASSEMBLY_TOP" "BOARD GEOMETRY/OUTLINE"))

("Bottom_etch"       ("ETCH/BOTTOM" "VIA CLASS/BOTTOM" "PIN/BOTTOM" "BOARD GEOMETRY/OUTLINE"))
("Bottom_silk"       ("PACKAGE GEOMETRY/SILKSCREEN_BOTTOM" "REF DES/SILKSCREEN_BOTTOM" "PIN/BOTTOM" "BOARD GEOMETRY/OUTLINE"))
("Bottom_auto_silk"  ("MANUFACTURING/AUTOSILK_BOTTOM" "PIN/BOTTOM" "BOARD GEOMETRY/OUTLINE"))
("Bottom_assembly"   ("PIN/BOTTOM" "REF DES/ASSEMBLY_BOTTOM" "PACKAGE GEOMETRY/ASSEMBLY_BOTTOM" "BOARD GEOMETRY/ASSEMBLY_BOTTOM" "BOARD GEOMETRY/OUTLINE"))
("Bottom_value"      ("PIN/BOTTOM" "COMPONENT VALUE/ASSEMBLY_BOTTOM" "PACKAGE GEOMETRY/ASSEMBLY_BOTTOM" "BOARD GEOMETRY/ASSEMBLY_BOTTOM" "BOARD GEOMETRY/OUTLINE"))
)

/*---------------------------------
ChangeColor()
---------------------------------*/
defun( ChangeColor (whichone)
	axlVisibleDesign(nil)

	foreach(one qvcs 
		if(whichone==car(one) then
			foreach(lName cadr(one)
				l_sep=parseString(lName "/")
				sprintf(strOrg,"paramLayerGroup:%s/paramLayer:%s",car(l_sep),cadr(l_sep))
				p=axlGetParam(strOrg)
				if(p then 
					p->visible=t 
					c1=1
					cond(
					(rexMatchp("AUTOSILK" lName)                   c1=c_gray   )
					(rexMatchp("PIN/TOP" lName)                    c1=c_golden )
					(rexMatchp("VIA CLASS/TOP" lName)              c1=c_golden )
					(rexMatchp("ETCH/TOP" lName)                   c1=c_golden )
					(rexMatchp("PIN/BOTTOM" lName)                 c1=c_ltgreen)
					(rexMatchp("VIA CLASS/BOTTOM" lName)           c1=c_ltgreen)
					(rexMatchp("ETCH/BOTTOM" lName)                c1=c_ltgreen)

					(rexMatchp("VALUE" lName)                      c1=c_pink)
					(rexMatchp("REF DES" lName)                    c1=c_cyan)
					(rexMatchp("PACKAGE GEOMETRY/ASSEMBLY_" lName) c1=c_gray)
					(rexMatchp("BOARD GEOMETRY/ASSEMBLY_" lName)   c1=c_gray)
					(rexMatchp("COMPONENT VALUE/ASSEMBLY_" lName)  c1=c_gray)
					(rexMatchp("OUTLINE" lName)                    c1=c_red )
					)                                                         
					p->color=c1
					axlSetParam(p)
				)
			)
		)
	)
	axlUIWRedraw(nil)
)

/*---------------------------------
CreateQViewForm()
---------------------------------*/
defun( CreateQViewForm ()
	fn = axlTempFile()
	p = outfile(fn "w")
	f_FormBegin(p 20 16 "Quick Viewer V0.1" "TOOLWINDOW")

	i=0
	foreach(onec qvcs f_CheckList(p car(onec) 0 i car(onec) "cg") i=i+2)

	f_FormEnd(p)
	close(p)
	fn
)
defun( QView ()
    QVFormFile = CreateQViewForm()    
    fw = axlFormCreate((gensym) QVFormFile '("NE" "msglines" 0) 'QViewAction t nil)
    axlUIWPerm(fw t)
    axlFormDisplay(fw)
    axlTempFileRemove(QVFormFile)
)

defun( QViewAction (fw)
    if(fw->curField then 
        foreach(onec qvcs if(fw->curField==car(onec) ChangeColor(fw->curField)))
    )
)
defun( f_FormBegin (p w h @optional (form_title "form by Richard") (form_opt "")) ;form_opt(FIXED_FONT TOOLWINDOW AUTOGREYTEXT UNIXHGT)
      sprintf(dest,"FILE_TYPE=FORM_DEFN VERSION=2\nFORM %s\nFIXED\nPORT %d %d\nHEADER \"%s\"\nTILE\n\n",form_opt,w,h,form_title)
      if(p fprintf(p,"%s",dest))
      dest)
defun( f_FormEnd (p @optional flexmode)
     if(flexmode sprintf(dest,"FLEXMODE %s\nENDTILE\nENDFORM\n",flexmode)
                 sprintf(dest,"ENDTILE\nENDFORM\n")
       )
     if(p fprintf(p,"%s",dest))
     dest)
defun( f_CheckList (handle field x y label \@optional (group nil))
        when(handle
            if( group then
                        fprintf(handle "FIELD %s\nFLOC %d %d\nCHECKLIST \"%s\" \"%s\"\nENDFIELD\n\n" field x y label group)
                else
                        fprintf(handle "FIELD %s\nFLOC %d %d\nCHECKLIST \"%s\" \nENDFIELD\n\n" field x y label)
            )
        )
)