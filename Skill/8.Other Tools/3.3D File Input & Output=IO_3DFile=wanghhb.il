

axlCmdRegister("IO_3DFile" 'IO_3DFile ?cmdType "general")
defun(IO_3DFile ()
let((mm mils)
	DrawName = axlCurrentDesign()
	IO_3DFilecreateform()
	IO_3DFileform = axlFormCreate( (gensym) "IO_3DFile.form" nil 'IO_3DFile_Action t)
	deleteFile("./IO_3DFile.form")
	axlFormDisplay(IO_3DFileform)
	axlFormAutoResize(IO_3DFileform)
)
)


defun(IO_3DFilecreateform ()
let((FormFile)
	FormFile = outfile("./IO_3DFile.form")
	fprintf(FormFile "FILE_TYPE=FORM_DEFN	VERSION=2\n" )
	fprintf(FormFile "FORM\n" )
	fprintf(FormFile "FIXED\n" )
	fprintf(FormFile "PORT 54	58\n" )
	fprintf(FormFile "HEADER \"MCAD\323\353ECAD\273\245\315\250\271\244\276\337 - V0.10\"\n" )
	
	fprintf(FormFile "TILE\n" )
	
	fprintf(FormFile "FIELD	ImportButton\n" )
	fprintf(FormFile "FLOC 39 20\n" )
	fprintf(FormFile "MENUBUTTON \"\260\357\326\372\"	10 3\n" )
	fprintf(FormFile "ENDFIELD\n" )
	
	fprintf(FormFile "FIELD Input1\n" )
	fprintf(FormFile "FLOC 2 4\n" )
	fprintf(FormFile "FSIZE 19 2\n" )
	fprintf(FormFile "STRFILLIN 22 150\n" )
	fprintf(FormFile "VALUE \"\"\n" )
	fprintf(FormFile "FGROUP \"Group1\"\n" )
	fprintf(FormFile "ENDFIELD\n" )
	fprintf(FormFile "FIELD	FileButton1\n" )
	fprintf(FormFile "FLOC 26	4\n" )
	fprintf(FormFile "MENUBUTTON \"...\"	4 3\n" )
	fprintf(FormFile "FGROUP \"Group1\"\n" )
	fprintf(FormFile "ENDFIELD\n" )
	fprintf(FormFile "FIELD	ImportButton\n" )
	fprintf(FormFile "FLOC 36 4\n" )
	fprintf(FormFile "MENUBUTTON \"\265\274\310\353\"	12 4\n" )
	fprintf(FormFile "FGROUP \"Group1\"\n" )
	fprintf(FormFile "ENDFIELD\n" )
	
	fprintf(FormFile "FIELD	ExportButton\n" )
	fprintf(FormFile "FLOC 36 13\n" )
	fprintf(FormFile "MENUBUTTON \"\265\274\263\366\"	12 4\n" )
	fprintf(FormFile "FGROUP \"Group2\"\n" )
	fprintf(FormFile "ENDFIELD\n" )
	
	fprintf(FormFile "FIELD	ExportButtonAB\n" )
	fprintf(FormFile "FLOC 8 13\n" )
	fprintf(FormFile "MENUBUTTON \"AB\265\274\263\366\"	12 4\n" )
	fprintf(FormFile "FGROUP \"Group2\"\n" )
	fprintf(FormFile "ENDFIELD\n" )
	
	fprintf(FormFile "GROUP \"3D\316\304\274\376\312\344\310\353\" \"Group1\"\n" )
	fprintf(FormFile "GLOC 1 1\n" )
	fprintf(FormFile "GSIZE 50 8\n" )
	fprintf(FormFile "ENDGROUP\n" )
	fprintf(FormFile "GROUP \"3D\316\304\274\376\312\344\263\366\" \"Group2\"\n" )
	fprintf(FormFile "GLOC 1 10\n" )
	fprintf(FormFile "GSIZE 50 8\n" )
	fprintf(FormFile "ENDGROUP\n" )
	fprintf(FormFile "ENDTILE\n" )
	fprintf(FormFile "ENDFORM\n" )

	close(FormFile)
)
)

 
defun(IO_3DFile_Action (IO_3DFileform)
prog((PlaceFile File_IDF)
	case(IO_3DFileform->curField
		("FileButton1"
			PlaceFile = axlDMFileBrowse(nil nil ?optFilters "IDF Files(*.emn)|*.emn|")
			when(PlaceFile
				if(substring(PlaceFile strlen(PlaceFile)-3 strlen(PlaceFile)) == ".emn" then
					axlFormSetField(IO_3DFileform "Input1" PlaceFile)
				)
			)
		)
		
		("ImportButton"
			File_IDF = axlOSSlash(axlFormGetField(IO_3DFileform "Input1"))
			when(File_IDF != "" 
				Input_IDFfile(File_IDF)
				ChangeSymbolToOutline()
			)
		)
		
		("ExportButton"
			Output_IDFfile(DrawName)
			FileManager()
		)
		("ExportButtonAB"
			Output_IDFfile(strcat(DrawName "_AB"))
			FileManager()
		)
	)
)
)



defun(Input_IDFfile (S_Port)
let((Out_Port)
	Out_Port = outfile("./scr_file.scr")
	fprintf( Out_Port "version 16.3\n" )
	fprintf( Out_Port "\n" )
	fprintf( Out_Port "idf in \n" )
	fprintf( Out_Port "FORM idf_in drawingnamefield %s\n" S_Port)
	fprintf( Out_Port "FORM idf_in execute  \n" )
	fprintf( Out_Port "setwindow form.idf_in\n" )
	fprintf( Out_Port "FORM idf_in cancel  \n" )
	close( Out_Port )	
	axlShell( "replay ./scr_file.scr" )
	deleteFile( "./scr_file.scr" )
)
)


defun(ChangeSymbolToOutline ()
let((DesID DXY MDC PloyID)
	DesID = axlDBGetDesign()->symbols
	foreach(n0 DesID
		if(n0->type == "MECHANICAL" then
			if(rexMatchp("^NPIN[0-9]+$" n0->name) && 
				lastelem(assoc('IDF_OWNER axlDBGetProperties(n0))) == "MCAD" then
				PloyID = car(axlPolyFromDB(car(n0->pins)))
				ShapeID = axlDBCreateShape(PloyID nil "BOARD GEOMETRY/OUTLINE" nil nil)
				axlDBAddProp(ShapeID list("IDF_OWNER" "MCAD"))
				axlDBAddProp(ShapeID list("FIXED" t))
				axlDBDeleteProp(n0 "FIXED")
				axlDeleteObject(n0 'ripup)
			)
		)
	)
)
)

