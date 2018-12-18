



;采用生成临时文件 script的方法，读取后删除临时文件。

axlCmdRegister( "g" 'g)

defun( g (@optional (n_e "") (a_e ""))
 
cond( 
		((n_e != "")&&(a_e != "")
		runscr(n_e a_e) 
		)
		
		((n_e != "")&&(a_e = "")
		a_e=n_e	
		runscr(n_e a_e)
		)
		
		((n_e = "")&&(a_e = "")
		axlShell("define grid")
		)
)

)


defun( runscr (n_e a_e) ;创建一个script 函数

ScriptFileName=axlTempFile()  ;获得临时目录下的唯一的一个临时文件名
Script_File=axlDMOpenFile("Grid_SCRIPT", ScriptFileName, "w") 

fprintf(Script_File "scriptmode +i\n\n")
fprintf(Script_File "setwindow pcb\n")
;fprintf(Script_File "generaledit \n")
;fprintf(Script_File "grid toggle \n")
fprintf(Script_File "define grid \n")
fprintf(Script_File "setwindow form.grid\n")
fprintf(Script_File "FORM grid non_etch non_etch_x_grids %L \n" n_e)
fprintf(Script_File "FORM grid non_etch non_etch_y_grids %L \n" n_e)
fprintf(Script_File "FORM grid all_etch all_etch_x_grids %L \n" a_e)
fprintf(Script_File "FORM grid all_etch all_etch_y_grids %L \n" a_e)
fprintf(Script_File "FORM grid done \n")

axlDMClose(Script_File) 
sprintf(runScript,"replay %s",ScriptFileName) 
axlShell(runScript)
deleteFile(ScriptFileName)
)



