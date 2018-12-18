
/*
-----------------------------------
函数：LD_CNS_Int()
输入：无
说明：约束设置初始化
----------------------------------
*/
axlCmdRegister("LD_CNS_Setting" 'LD_CNS_Setting)


defun(LD_CNS_Setting ()
let(()
	;println(axlDBGetDesign()->nets)
	foreach(n0 axlDBGetDesign()->nets
		crp_print_all_seg_on_the_net(n0)
	)
)
)



procedure( crp_print_all_seg_on_the_net(net)
	foreach(branch net->branches
	println(branch)
		foreach(children branch->children
			if(children->objType=="via" then	
				fprintf(the_outfile_port "%.4f\t%.4f\t0\t%.4f\t1856\t%s THERMAL\n" car(children->xy) cadr(children->xy) the_daulf_cline_with children->name)
			)
			if(children->objType=="path"	then
				foreach(seg children->segments
					if(seg->objType=="line"	then
						layerindex=axlLayerGet(seg->layer)->number+1
						fprintf(the_outfile_port "%.4f %.4f\t%d %.4f 1280\n" caar(seg->startEnd) cadar(seg->startEnd) layerindex seg->width)
						fprintf(the_outfile_port "%.4f %.4f\t0 %.4f 768\n" caadr(seg->startEnd) cadadr(seg->startEnd) seg->width)
					)
					if(seg->objType=="arc"	then
						layerindex=axlLayerGet(seg->layer)->number+1
						fprintf(the_outfile_port "%.4f %.4f\t%d %.4f 1280\n" caar(seg->startEnd) cadar(seg->startEnd) layerindex seg->width)
						if(seg->isClockwise==t then
							clock="CW"
						else
							clock="CCW"
						)
						fprintf(the_outfile_port "%.4f %.4f\t%d %.4f 5888 %s\n" car(seg->xy) cadr(seg->xy) layerindex seg->width clock)
						fprintf(the_outfile_port "%.4f %.4f\t0 %.4f 768\n" caadr(seg->startEnd) cadadr(seg->startEnd) seg->width)
					)
				)
			)
		)
	)
	
)


	;axlDeleteObject(axlDBGetDesign()->nets 'ripup)
	
	;axlDeleteObject(axlDBGetDesign()->xnet 'ripup)
	;axlDeleteObject()
/*	VisList = axlVisibleGet()
	foreach(n0 axlDBGetShapes("ETCH")
		t;axlDeleteObject(n0->shapeBoundary)
	)
	
	axlVisibleDesign(nil)	
	axlVisibleLayer("ETCH" t)
	axlVisibleLayer("VIA CLASS" t)
	axlSetFindFilter(
		?enabled '("NOALL" "CLINES" "VIAS" "NETS")
		?onButtons '("ALLTYPES")
	)
	axlAddSelectAll()
	SS = axlGetSelSet()
	axlClearSelSet()
	axlDeleteObject(SS 'ripup)
	axlVisibleSet(VisList)
	axlVisibleUpdate(nil)	
*/
	;Dx = caadr(axlExtentDB())
	;dertar = axlMKSConvert(20 "mm" car(axlDBGetDesignUnits()))
	;Dx = Dx+dertar
	;Dy = lastelem(cadr(axlExtentDB()))
	;tt=strcat("setwindow form.nc_drilllegend\n" "FORM nc_drilllegend done \n" "setwindow pcb\n" "pick grid 0 0\n" "generaledit  \n")
	;axlRunBatchDBProgram("ncdrill legend" tt)
	;axlRunBatchDBProgram("artwork" strcat("artwork -f TOP " axlCurrentDesign(), ".brd"))
