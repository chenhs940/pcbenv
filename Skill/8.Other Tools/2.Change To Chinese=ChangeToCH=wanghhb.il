axlCmdRegister("ChangeToCH" 'ChangeToCH)
defun(readData (cid data)
let((CNSList CNSList0)
	CNSList = '()
	foreach(n0 parseString(data "{}\n,")
		CNSList0 = '()
		foreach(n1 parseString(n0 " :")
			CNSList0 = append1(CNSList0 car(parseString(n1 "'")))
		)
		CNSList = append1(CNSList CNSList0)
	)
	println(CNSList)
;println(axlCNSGetPhysical("" "TOP" 'width_min))
;axlCNSSetPhysical(nil nil 'width_min 5)
;println(axlCNSGetPhysical("" "TOP" 'width_min))
;println(axlCNSGetSpacing(nil nil nil))
;println(axlCNSGetSpacing("" "TOP" 'line_line))
t

)
)
defun(post (cid data)
	println("post")
)
defun(ChangeToCH ()
let((cid x)
;axlUIPrompt("Code:",sprintf(nil,"%L",axlUIPrompt("Please Input Chinese:")))
;cid = ipcBeginProcess( "G:/dist/skill_ext.exe"  "" "readData" nil "post" "G:/dist/ls.log")
;ipcWaitForProcess(cid)
;ipcActivateBatch(cid)

;when(x printf(" New string : %s", x ))
;ipcKillProcess( cid )
;println(x)
;axlShell(x)

t
)
)




