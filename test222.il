/****************************************************/
/*程序名称 :  AUTOTXT
/*调用命令 :  
/*作    者 :  
/*功能说明 : 自动调整PCB中的TEXT
/*更新说明 :
R1.0-20180927
1、参考Allegro Productivity Toolbox中的 Label Tune编写
2、参考XYX365的tt_V1.60编写
3、将from改为中文
R1.1-20181018
1、修正其他skill执行中调用本skill会卡死的bug
R1.2-20181104
1、文字位置的偏移修正选项增加帮助提示
2、层设定中的"外层名称"改为"器件外框"
3、增加AUTOTXT_data->visList的全局变量，用于还原用户视图
4、新增退出skill时还原视图修改的功能
5、增加移动文字到器件边缘的功能（主要更新）
6、增加操作报告
7、增加操作进度条
8、对显示控制进行增强
/****************************************************/

; 使用方法：
; 1、通过显示控制部分的操作，切换到比较合适的显示状态
; 2、根据自己的需要设置好操作内容
; 3、在进阶设定中进一步设置好操作内容的相关参数
; 4、在pcb上框选或点选text字体来执行字体调整操作

axlCmdRegister( "test" `AUTOTXT ?cmdType "interactive" )


/****************************************************/
/*函数名称 : AUTOTXT		
/*函数功能 : 主函数，设置右键菜单，并创建窗口
/****************************************************/
defun( AUTOTXT (\@optional (mode "debug"))
let((form formfile)

	;初始化全局变量	
	AUTOTXT_Init() 
	AUTOTXT_data->mode = mode
	;创建窗口	
	formfile = AUTOTXT_FormCreate()
	form = axlFormCreate((gensym) formfile '(E INNER) 'AUTOTXT_Callback t)
	AUTOTXT_data->formid = form
	;设置窗口默认值	
	axlUIWPrint(form "Author : mojinpan@formail.com")
	AUTOTXT_FormInit(form)
	;激活窗口		
	axlFormDisplay(form)
	;循环执行任务
	AUTOTXT_Event_Loop()
)
)

/****************************************************/
/*函数名称 : AUTOTXT_Init
/*函数功能 : skill初始化，主要是初始化全局变量
/****************************************************/
procedure( AUTOTXT_Init() 
    let((userdata text_param text_list height_list block_list
	    min_height max_height min_block max_block text_info
	) 
	(userdata = (axlUIGetUserData)) 
	remprop(userdata 
	    'transaction
	) 
	putprop(userdata 
	    (userdata->popupId) 
	    'oldPopupId
	) 
	for(n 1 200 
	    (text_param = (axlGetParam 
		    sprintf(nil "paramTextBlock:%d" n)
		)) 
	    when(((text_param->height) && (text_param->width) && ((text_param->height) > 0.0) && ((text_param->width) > 0.0)) 
		(height_list = cons((text_param->height) height_list)) 
		(block_list = cons(n block_list)) 
		(text_list = cons(list((text_param->height) n) text_list))
	    )
	)
	(height_list = sort(height_list 
		'lessp
	    )) 
	(block_list = sort(block_list 
		'lessp
	    )) 
	(min_block = car(block_list)) 
	(max_block = (lastelem block_list)) 
	(min_height = car(height_list))
	(max_height = (lastelem height_list)) 
	(text_info = ncons(nil)) 
	(text_info->minBlock = min_block) 
	(text_info->maxBlock = max_block) 
	(text_info->minHeight = min_height)
	(text_info->maxHeight = max_height) 
	(text_list = sortcar(text_list 
		'lessp
	    )) 
	unless(boundp('AUTOTXT_data) 
	    iliDefstruct('defstruct(AUTOTXT_data_struct formid tmplayer mark textList
			textInfo blockInfo popupInfo visList report mode cklayer cklayerview
		    )
	    ) 
	    defvar(AUTOTXT_data nil)
	) 
	if(!AUTOTXT_data 
	then 
	    AUTOTXT_data = (make_AUTOTXT_data_struct ?formid nil ?tmplayer "DRAWING FORMAT/OUTLINE"
		    ?mark nil ?popupInfo nil ?textList text_list ?textInfo text_info ?blockInfo nil 
			?visList nil ?report nil ?mode nil ?cklayer nil ?cklayerview nil
			)
	else 
	    (AUTOTXT_data->formid = nil)
	    (AUTOTXT_data->tmplayer = "DRAWING FORMAT/OUTLINE") 
	    (AUTOTXT_data->mark = nil) 
	    (AUTOTXT_data->popupInfo = nil) 
	    (AUTOTXT_data->textList = text_list) 
	    (AUTOTXT_data->textInfo = text_info)
	    (AUTOTXT_data->blockInfo = nil)
		(AUTOTXT_data->visList = axlVisibleGet())
		(AUTOTXT_data->report = nil)
		(AUTOTXT_data->mode = nil)
		(AUTOTXT_data->cklayer = nil)
		(AUTOTXT_data->cklayerview = nil)
	)
)
)

/****************************************************/
/*函数名称 : AUTOTXT_FormInit()
/*函数功能 : from默认值设置
/****************************************************/
procedure( AUTOTXT_FormInit(fid) 
let(( FORM_FILE  port info_file default_value) 
	(AUTOTXT_data->popupInfo = AUTOTXT_Layer_Popup_Setup())
	(default_value = AUTOTXT_Get_Defaults()) 
	axlFormSetField( fid "toggle_top" t) 
	axlFormSetField( fid "toggle_bottom" t) 
	when((default_value->outlineLayer) 
	(default_value->outlineLayer = AUTOTXT_UTIL_Map_Layer_Name((default_value->outlineLayer) nil))
	) 
	when((default_value->labelLayer) 
	(default_value->labelLayer = AUTOTXT_UTIL_Map_Layer_Name((default_value->labelLayer) nil))
	) 
	
	axlFormSetField( fid "label_name" (default_value->labelName)) 
	axlFormBuildPopup( fid "label_layer" (AUTOTXT_data->popupInfo)[(default_value->labelName)])
	axlFormSetField( fid "label_layer" (default_value->labelLayer)) 
	axlFormBuildPopup( fid "outline_layer" (AUTOTXT_data->popupInfo)["package_geom"]) 
	axlFormSetField( fid "outline_layer" (default_value->outlineLayer)) 
	axlFormSetField( fid "mirror_bottom" (default_value->mirrorBottom)) 
	axlFormSetField( fid "rotate_text" (default_value->rotateText))
	axlFormSetField( fid "center_text" (default_value->centerText)) 
	axlFormSetField( fid "symedge_text" (default_value->symedgeText))
	axlFormSetField( fid "fit_text" (default_value->fitText)) 
	axlFormSetField( fid "offset_x" (default_value->offsetX)) 
	axlFormSetField( fid "offset_y" (default_value->offsetY)) 
	axlFormSetField( fid "text_match_minmax_height" (default_value->textMatchMinMaxHeight))
	axlFormSetField( fid "text_match_block_range" (default_value->textMatchBlockRange)) 
	axlFormSetField( fid "min_height" (default_value->minHeight)) 
	axlFormSetField( fid "max_height" (default_value->maxHeight)) 
	axlFormSetField( fid "block_range" (default_value->blockRange)) 
	(AUTOTXT_data->blockInfo = AUTOTXT_Get_Block_Info(fid))
	axlFormSetField( fid "spin_long_side" (default_value->spinLongSide)) 
	axlFormSetField( fid "spin_absolute" (default_value->spinAbsolute)) 
	axlFormSetField( fid "spin_relative" (default_value->spinRelative)) 
	axlFormSetField( fid "deg_top_horizontal" (default_value->degTopHorizontal)) 
	axlFormSetField( fid "deg_top_vertical" (default_value->degTopVertical))
	axlFormSetField( fid "deg_bottom_horizontal" (default_value->degBottomHorizontal)) 
	axlFormSetField( fid "deg_bottom_vertical" (default_value->degBottomVertical)) 
	axlFormSetField( fid "deg_absolute" (default_value->degAbsolute)) 
	axlFormSetField( fid "offset_correction" (default_value->offsetCorrection)) 
	axlFormSetField( fid "boundary_clearance" (default_value->boundaryClearance))
	axlFormSetField( fid "outline_clearance" (default_value->outlineClearance))
	axlFormSetField( fid "update_bar" nil) 
	axlFormSetFieldVisible( fid "update_bar" 1)
	
	if((axlFormGetField fid "text_match_minmax_height") 
	then 
		axlFormSetFieldEditable( fid "min_height" t) 
		axlFormSetFieldEditable( fid "max_height" t) 
		axlFormSetFieldEditable( fid "block_range" nil)
	else 
		axlFormSetFieldEditable( fid "min_height" nil) 
		axlFormSetFieldEditable( fid "max_height" nil) 
		axlFormSetFieldEditable( fid "block_range" t)
	) 
	
	if((axlFormGetField fid "center_text") 
	then 
		axlFormSetFieldEditable( fid "offset_x" t) 
		axlFormSetFieldEditable( fid "offset_y" t)
		axlFormSetFieldEditable( fid "label_layer" t)		
	else
		axlFormSetFieldEditable( fid "offset_x" nil) 
		axlFormSetFieldEditable( fid "offset_y" nil)
	)

	if(axlFormGetField(fid "symedge_text") 
	then 
		(axlFormSetFieldEditable fid "offset_x" nil) 
		(axlFormSetFieldEditable fid "offset_y" nil) 
		(axlFormSetField fid "center_text" nil)
		(axlFormSetField fid "rotate_text" t)
		(axlFormSetField fid "spin_relative" t)
		axlFormSetFieldEditable( fid "label_layer" nil) 
		axlFormSetFieldEditable( fid "deg_top_horizontal" nil) 
		axlFormSetFieldEditable( fid "deg_top_vertical" nil) 
		axlFormSetFieldEditable( fid "deg_bottom_horizontal" nil) 
		axlFormSetFieldEditable( fid "deg_bottom_vertical" nil)
		axlFormSetFieldEditable( fid "deg_absolute" nil)
		
	else
		axlFormSetFieldEditable( fid "label_layer" t)
		(axlFormSetFieldEditable fid "offset_x" t) 
		(axlFormSetFieldEditable fid "offset_y" t)
	)

	
	cond(
	(axlFormGetField( fid "spin_long_side") 
		axlFormSetFieldEditable( fid "deg_top_horizontal" t) 
		axlFormSetFieldEditable( fid "deg_top_vertical" t) 
		axlFormSetFieldEditable( fid "deg_bottom_horizontal" t) 
		axlFormSetFieldEditable( fid "deg_bottom_vertical" t)
		axlFormSetFieldEditable( fid "deg_absolute" nil)
	) 
	(axlFormGetField( fid "spin_absolute") 
		axlFormSetFieldEditable( fid "deg_top_horizontal" nil) 
		axlFormSetFieldEditable( fid "deg_top_vertical" nil) 
		axlFormSetFieldEditable( fid "deg_bottom_horizontal" nil) 
		axlFormSetFieldEditable( fid "deg_bottom_vertical" nil)
		axlFormSetFieldEditable( fid "deg_absolute" t)
	) 
	(axlFormGetField( fid "spin_relative") 
		axlFormSetFieldEditable( fid "deg_top_horizontal" nil) 
		axlFormSetFieldEditable( fid "deg_top_vertical" nil) 
		axlFormSetFieldEditable( fid "deg_bottom_horizontal" nil) 
		axlFormSetFieldEditable( fid "deg_bottom_vertical" nil)
		axlFormSetFieldEditable( fid "deg_absolute" nil)
	)
	) 

    )
)


/****************************************************/
/*函数名称 : AUTOTXT_Callback()
/*函数功能 : 窗口回调函数
/****************************************************/
procedure( AUTOTXT_Callback(form_handle) 
    let((max_val min_val label_name msg) 
	case((form_handle->curField) 
	    ("done" 
			axlVisibleSet((AUTOTXT_data->visList))
			when(AUTOTXT_data->mode == "debug" AUTOTXT_ClearDebugMark())
			axlFinishEnterFun()	
	    ) 
		
	    ("cancel" 
			axlVisibleSet(AUTOTXT_data->visList)
			when(AUTOTXT_data->mode == "debug" AUTOTXT_ClearDebugMark())
			axlCancelEnterFun()
	    ) 
		
	    ("label_name" 
			label_name = form_handle->curValue 
			axlFormBuildPopup( form_handle "label_layer" (AUTOTXT_data->popupInfo)[label_name]) 
			axlFormSetField( form_handle "label_layer" cadar((AUTOTXT_data->popupInfo)[label_name]))
	    ) 
		
	    ("limit_layers" 			
			AUTOTXT_Limit_Layer_Visibility(form_handle)
	    )
		
	    ("toggle_top" 

			AUTOTXT_Display_Toggle(form_handle->curValue form_handle "top")

	    ) 
		
	    ("toggle_bottom" 
			AUTOTXT_Display_Toggle(form_handle->curValue form_handle "bottom")
	    )

	    ("PIN_TOP" 
			
			axlVisibleLayer("PIN/TOP"  form_handle->curValue)
			axlVisibleLayer("PIN/SOLDERMASK_TOP"  form_handle->curValue)
			axlVisibleUpdate(t)
			if(form_handle->curValue		
			then	
				 axlFormSetField(form_handle, "PIN_TOP", axlLayerGet("PIN/TOP") ->color)     

			else
				axlFormSetField(form_handle, "PIN_TOP", 'black)            
			)			
	    )

	    ("PIN_BOTTOM" 
			axlVisibleLayer("PIN/BOTTOM"  form_handle->curValue)
			axlVisibleLayer("PIN/SOLDERMASK_TOP"  form_handle->curValue)	
			axlVisibleUpdate(t)
			
			if(form_handle->curValue		
			then	
				 axlFormSetField(form_handle, "PIN_BOTTOM", axlLayerGet("PIN/BOTTOM") ->color)     

			else
				axlFormSetField(form_handle, "PIN_BOTTOM", 'black)            
			)

		)		

	    ("VIA_TOP" 
			
			(axlVisibleLayer "VIA CLASS/TOP"  form_handle->curValue)
			(axlVisibleLayer "VIA CLASS/SOLDERMASK_TOP"  form_handle->curValue)
			axlVisibleUpdate(t)
			if(form_handle->curValue		
			then	
				 axlFormSetField(form_handle, "VIA_TOP", axlLayerGet("VIA CLASS/TOP") ->color)     

			else
				axlFormSetField(form_handle, "VIA_TOP", 'black)            
			)			
	    )

	    ("VIA_BOTTOM" 
			(axlVisibleLayer "VIA CLASS/BOTTOM"  form_handle->curValue)
			(axlVisibleLayer "VIA CLASS/SOLDERMASK_BOTTOM"  form_handle->curValue)	
			axlVisibleUpdate(t)
			
			if(form_handle->curValue		
			then	
				 axlFormSetField(form_handle, "VIA_BOTTOM", axlLayerGet("VIA CLASS/BOTTOM") ->color)     

			else
				axlFormSetField(form_handle, "VIA_BOTTOM", 'black)            
			)

		)

	    ("SILKSCREEN_TOP" 
			
			axlVisibleLayer("REF DES/SILKSCREEN_TOP"  form_handle->curValue)
			axlVisibleLayer("PACKAGE GEOMETRY/SILKSCREEN_TOP"  form_handle->curValue)
			axlVisibleLayer("BOARD GEOMETRY/SILKSCREEN_TOP"  form_handle->curValue)
			axlVisibleUpdate(t)
			if(form_handle->curValue		
			then	
				 axlFormSetField(form_handle, "SILKSCREEN_TOP", axlLayerGet("REF DES/SILKSCREEN_TOP") ->color)     

			else
				axlFormSetField(form_handle, "SILKSCREEN_TOP", 'black)            
			)			
	    )

	    ("SILKSCREEN_BOTTOM" 
			axlVisibleLayer("REF DES/SILKSCREEN_BOTTOM"  form_handle->curValue)
			axlVisibleLayer("PACKAGE GEOMETRY/SILKSCREEN_BOTTOM"  form_handle->curValue)
			axlVisibleLayer("BOARD GEOMETRY/SILKSCREEN_BOTTOM"  form_handle->curValue)	
			axlVisibleUpdate(t)
			
			if(form_handle->curValue		
			then	
				 axlFormSetField(form_handle, "SILKSCREEN_BOTTOM", axlLayerGet("REF DES/SILKSCREEN_BOTTOM") ->color)     

			else
				axlFormSetField(form_handle, "SILKSCREEN_BOTTOM", 'black)            
			)

		)		
		

	    ("ASSEMBLY_TOP" 
			
			axlVisibleLayer("REF DES/ASSEMBLY_TOP"  form_handle->curValue)
			axlVisibleLayer("PACKAGE GEOMETRY/ASSEMBLY_TOP"  form_handle->curValue)
			axlVisibleUpdate(t)
			if(form_handle->curValue		
			then	
				 axlFormSetField(form_handle, "ASSEMBLY_TOP", axlLayerGet("REF DES/ASSEMBLY_TOP") ->color)     

			else
				axlFormSetField(form_handle, "ASSEMBLY_TOP", 'black)            
			)			
	    )

	    ("ASSEMBLY_BOTTOM" 
			axlVisibleLayer("REF DES/ASSEMBLY_BOTTOM"  form_handle->curValue)
			axlVisibleLayer("PACKAGE GEOMETRY/ASSEMBLY_BOTTOM"  form_handle->curValue)	
			axlVisibleUpdate(t)
			
			if(form_handle->curValue		
			then	
				 axlFormSetField(form_handle, "ASSEMBLY_BOTTOM", axlLayerGet("REF DES/ASSEMBLY_BOTTOM") ->color)     

			else
				axlFormSetField(form_handle, "ASSEMBLY_BOTTOM", 'black)            
			)

		)
		
	    ("text_match_minmax_height" 
			if(form_handle->curValue 
			then 
				axlFormSetFieldEditable( form_handle "min_height" t) 
				axlFormSetFieldEditable( form_handle "max_height" t) 
				axlFormSetFieldEditable( form_handle "block_range" nil)
			   else 
				axlFormSetFieldEditable( form_handle "min_height" nil) 
				axlFormSetFieldEditable( form_handle "max_height" nil) 
				axlFormSetFieldEditable( form_handle "block_range" t)
			) 
			AUTOTXT_data->blockInfo = AUTOTXT_Get_Block_Info(form_handle)
	    )
		
	    ("min_height" 
			when(((form_handle->curValue) > axlFormGetField( form_handle "max_height")) 
				axlUIWPrint( form_handle "Error: \327\326\314\345\327\356\320\241\326\265\261\330\320\353\320\241\323\332\327\356\264\363\326\265!") ;字体最小值必须小于最大值 
				(max_val = axlFormGetField( form_handle "max_height")) 
				axlFormSetField( form_handle "min_height" max_val)
			) 
			(AUTOTXT_data->blockInfo = AUTOTXT_Get_Block_Info(form_handle))
	    )
		
	    ("max_height" 
			when(((form_handle->curValue) < axlFormGetField( form_handle "min_height")) 
				axlUIWPrint( form_handle "Error: \327\326\314\345\327\356\264\363\326\265\261\330\320\353\264\363\323\332\327\356\320\241\326\265!");字体最大值必须大于最小值 
				(min_val = axlFormGetField( form_handle "min_height")) 
				axlFormSetField( form_handle "max_height" min_val)
			) 
			(AUTOTXT_data->blockInfo = AUTOTXT_Get_Block_Info(form_handle))
	    )
		
	    ("text_match_block_range" 
			if((form_handle->curValue) then 
				(axlFormSetFieldEditable form_handle "min_height" nil) 
				(axlFormSetFieldEditable form_handle "max_height" nil) 
				(axlFormSetFieldEditable form_handle "block_range" t)
				else 
				(axlFormSetFieldEditable form_handle "min_height" t) 
				(axlFormSetFieldEditable form_handle "max_height" t) 
				(axlFormSetFieldEditable form_handle "block_range" nil)
			) 
			(AUTOTXT_data->blockInfo = AUTOTXT_Get_Block_Info(form_handle))
	    )
		
	    ("user_info" 
			(msg = "") 
			(msg = strcat(msg "\322\324\277\325\270\361\316\252\274\344\270\364\301\320\263\366\277\311\323\303\327\326\272\305\243\250\313\263\320\362\310\316\322\342\243\251\243\254\301\254\320\370\327\326\272\305\277\311\323\303\326\320\273\256\317\337\314\346\264\372\n"));以空格为间隔列出可用字号（顺序任意），连续字号可用中划线替代 
			(msg = strcat(msg "\n")) 
			(msg = strcat(msg "\300\375\310\347: \"1 2 3 4-10 15 30-35\" "));例如：1 2 3 4-10 15 30-35
			(msg = sprintf(nil "%s\n\n\327\242: \327\356\264\363\265\304\327\326\272\305\316\252 %d" msg 
				((AUTOTXT_data->textInfo)->maxBlock)
				)) 
			axlUIConfirm(msg)
	    ) 

	    ("offset_info" 
			(msg = "") 
			(msg = strcat(msg "\327\326\314\345\322\306\266\257\265\275\306\367\274\376\326\320\320\304\312\261\243\254\327\326\314\345\317\340\266\324\326\320\320\304\317\337\311\317\317\302\306\253\322\306\243\250-0.5~0.5\243\251\n"));字体移动到器件中心时，字体相对中心线上下偏移（-0.5~0.5）
			(msg = strcat(msg "\300\375\310\347 \n")) ;例如
			(msg = strcat(msg " 0.5\243\272\327\326\314\345\325\373\314\345\324\332\326\320\320\304\317\337\311\317\267\275\n")); 0.5：字体整体在中心线上方
			(msg = strcat(msg "    0\243\272\327\326\314\345\326\320\320\304\324\332\326\320\320\304\317\337\326\320\320\304\n")); 0：字体中心在中心线中心
			(msg = strcat(msg "-0.5\243\272\327\326\314\345\325\373\314\345\324\332\326\320\320\304\317\337\317\302\267\275"));-0.5：字体整体在中心线下方 

			axlUIConfirm(msg)
	    )

	    ("symedge_info" 
			(msg = "") 
			(msg = strcat(msg "\263\242\312\324\322\306\266\257\327\326\314\345\265\275\306\367\274\376\261\337\324\265\243\254\310\347\312\247\260\334\324\362\322\306\266\257\265\275\306\367\274\376\326\320\320\304\262\242\270\337\301\301\306\367\274\376"));字体相对中心线上下偏移（-0.5~0.5）
			axlUIConfirm(msg)
	    )
		("outline_clearance_info" 
			(msg = "") 
			(msg = strcat(msg "\316\304\327\326\322\306\266\257\265\275\306\367\274\376\261\337\324\265\312\261\243\254\316\304\327\326\323\353\306\367\274\376\265\304\261\337\324\265\276\340\300\353"));文字移动到器件边缘时，文字与器件的边缘距离
			axlUIConfirm(msg)
		)
	    ("block_range" 
			(AUTOTXT_data->blockInfo = AUTOTXT_Get_Block_Info(form_handle))
	    ) 
		
	    ("rotate_text" 
			unless((axlFormGetField form_handle "rotate_text") 
				(axlFormSetField form_handle "fit_text" nil)
				(axlFormSetField form_handle "symedge_text" nil)
			)
	    ) 
		
	    ("center_text" 
			if((form_handle->curValue) 
			then 
				(axlFormSetFieldEditable form_handle "offset_x" t) 
				(axlFormSetFieldEditable form_handle "offset_y" t)
				(axlFormSetField form_handle "symedge_text" nil)
				axlFormSetFieldEditable( form_handle "label_layer" t) 				
			else
				(axlFormSetField form_handle "fit_text" nil) 
				(axlFormSetFieldEditable form_handle "offset_x" nil) 
				(axlFormSetFieldEditable form_handle "offset_y" nil)
			)
	    )

	    ("symedge_text" 
			if((form_handle->curValue) 
			then 
				(axlFormSetField form_handle "label_layer" cadr(nth(2 ((AUTOTXT_data->popupInfo)["refdes"]))) ) 
				(axlFormSetFieldEditable form_handle "offset_x" nil) 
				(axlFormSetFieldEditable form_handle "offset_y" nil) 
				(axlFormSetField form_handle "center_text" nil)
				(axlFormSetField form_handle "rotate_text" t)
				(axlFormSetField form_handle "spin_relative" t)
				axlFormSetFieldEditable( form_handle "label_layer" nil)
				axlFormSetFieldEditable( form_handle "deg_top_horizontal" nil) 
				axlFormSetFieldEditable( form_handle "deg_top_vertical" nil) 
				axlFormSetFieldEditable( form_handle "deg_bottom_horizontal" nil) 
				axlFormSetFieldEditable( form_handle "deg_bottom_vertical" nil)
				axlFormSetFieldEditable( form_handle "deg_absolute" nil)
			else
				axlFormSetFieldEditable( form_handle "label_layer" t)
				(axlFormSetFieldEditable form_handle "offset_x" t) 
				(axlFormSetFieldEditable form_handle "offset_y" t)
			)
	    )

		
	    ("fit_text" 
			if((axlFormGetField form_handle "fit_text") 
			then 
				(axlFormSetField form_handle "rotate_text" t)
				unless((axlFormGetField form_handle "symedge_text")				
					(axlFormSetField form_handle "center_text" t) 
					(axlFormSetFieldEditable form_handle "offset_x" t)
					(axlFormSetFieldEditable form_handle "offset_y" t) 
				)
 
			else t
			)
	    )
		
	    ("mirror_bottom" 
		if((form_handle->curValue) 
			then 
				(axlFormSetField form_handle "deg_bottom_horizontal" 0.0) 
				(axlFormSetField form_handle "deg_bottom_vertical" 270.0) 
			else
				(axlFormSetField form_handle "deg_bottom_horizontal" 0.0) 
				(axlFormSetField form_handle "deg_bottom_vertical" 90.0)
			)
	    )
		
	    ("spin_long_side" 
			axlFormSetFieldEditable( form_handle "deg_top_horizontal" t) 
			axlFormSetFieldEditable( form_handle "deg_top_vertical" t) 
			axlFormSetFieldEditable( form_handle "deg_bottom_horizontal" t) 
			axlFormSetFieldEditable( form_handle "deg_bottom_vertical" t)
			axlFormSetFieldEditable( form_handle "deg_absolute" nil)
	    ) 
	    ("spin_absolute" 
			axlFormSetFieldEditable( form_handle "deg_top_horizontal" nil) 
			axlFormSetFieldEditable( form_handle "deg_top_vertical" nil) 
			axlFormSetFieldEditable( form_handle "deg_bottom_horizontal" nil) 
			axlFormSetFieldEditable( form_handle "deg_bottom_vertical" nil)
			axlFormSetFieldEditable( form_handle "deg_absolute" t)
	    ) 
	    ("spin_relative" 
			axlFormSetFieldEditable( form_handle "deg_top_horizontal" nil) 
			axlFormSetFieldEditable( form_handle "deg_top_vertical" nil) 
			axlFormSetFieldEditable( form_handle "deg_bottom_horizontal" nil) 
			axlFormSetFieldEditable( form_handle "deg_bottom_vertical" nil)
			axlFormSetFieldEditable( form_handle "deg_absolute" nil)
	    )
		
	    ("myhelp" 
			AUTOTXT_Help()
	    ) 
		
	    ("report" 
			AUTOTXT_Report()
	    )		
	    (t t)
	)
    )
)
/****************************************************/
/*函数名称 : AUTOTXT_Event_Loop()
/*函数功能 : 用户操作执行函数
/****************************************************/
procedure( AUTOTXT_Event_Loop() 
    let((eventMask loop bBox comp_list event) 
	(axlSetFindFilter ?enabled 
	    list("noall" "components") ?onButtons 
	    list("all")
	) 
	(axlEventSetStartPopup 
	    'AUTOTXT_Popup
	) 
	(eventMask = list('STARTDRAG 
		'STOPDRAG 
		'PICK
	    )) 
	(loop = t)
	(AUTOTXT_data->mark = (axlDBTransactionStart)) 
	while(loop 
	    (event = (axlEnterEvent eventMask nil nil)) 
	    (axlClearDynamics) 
	    caseq((event->type) 
		(STARTDRAG 
		    (axlAddSimpleRbandDynamics 
			(event->xy) "box" ?origin 
			(0.0:0.0)
		    ) 
		    (bBox = (event->xy))
		) 
		(STOPDRAG 
		    (comp_list = list()) 
		    (bBox = list(bBox 
			    (event->xy)
			)) 
		    (axlSingleSelectBox bBox) 
		    (comp_list = (axlGetSelSet))
		    when(comp_list 
			(axlDBTransactionMark 
			    (AUTOTXT_data->mark)
			) 
			AUTOTXT_Modify_Text(comp_list)
		    ) 
		    (bBox = nil) 
		    (axlClearSelSet)
		) 
		(PICK 
		    (comp_list = list()) 
		    (bBox = nil) 
		    (axlSingleSelectPoint 
			(event->xy)
		    ) 
		    (comp_list = (axlGetSelSet))
		    when(comp_list 
			(axlDBTransactionMark 
			    (AUTOTXT_data->mark)
			) 
			AUTOTXT_Modify_Text(comp_list)
		    ) 
		    (axlClearSelSet)
		) 
		(DONE 
		    (loop = nil) 
		    (axlFinishEnterFun) 
		    (axlDBTransactionCommit 
			(AUTOTXT_data->mark)
		    )
		    (axlFormClose 
			(AUTOTXT_data->formid)
		    ) 
		    (axlClearDynamics) 
		    (axlVisibleUpdate t)
		)
		(CANCEL 
		    (loop = nil) 
		    (axlCancelEnterFun) 
		    (axlDBTransactionOops 
			(AUTOTXT_data->mark)
		    ) 
		    (axlDBTransactionCommit 
			(AUTOTXT_data->mark)
		    )
		    (axlClearDynamics) 
		    (axlFormClose 
			(AUTOTXT_data->formid)
		    ) 
		    (axlClearDynamics) 
		    (axlVisibleUpdate t)
		)
	    )
	) 
	(axlEventSetStartPopup)
    )
)
/****************************************************/
/*函数名称 : 
/*函数功能 : 
/****************************************************/
procedure( AUTOTXT_UTIL_Map_Layer_Name(layer mode) 
    let((arr cls subcls cls_mapped layer_new
	    mcm_name pcb_name
	) 
	(mcm_name = makeTable("mcm_name_table" nil)) 
	(mcm_name["BOARD GEOMETRY"] = "SUBSTRATE GEOMETRY") 
	(mcm_name["ETCH"] = "CONDUCTOR") 
	(mcm_name["ANTI ETCH"] = "ANTI CONDUCTOR")
	(mcm_name["PACKAGE GEOMETRY"] = "COMPONENT GEOMETRY") 
	(mcm_name["PACKAGE KEEPIN"] = "COMPONENT KEEPIN") 
	(mcm_name["PACKAGE KEEPOUT"] = "COMPONENT KEEPOUT") 
	(pcb_name = makeTable("pcb_name_table" nil)) 
	(pcb_name["SUBSTRATE GEOMETRY"] = "BOARD GEOMETRY")
	(pcb_name["CONDUCTOR"] = "ETCH") 
	(pcb_name["ANTI CONDUCTOR"] = "ANTI ETCH") 
	(pcb_name["COMPONENT GEOMETRY"] = "PACKAGE GEOMETRY") 
	(pcb_name["COMPONENT KEEPIN"] = "PACKAGE KEEPIN") 
	(pcb_name["COMPONENT KEEPOUT"] = "PACKAGE KEEPOUT")
	(layer_new = layer) 
	(arr = parseString(upperCase(layer) "/")) 
	cond((onep(length(arr)) 
		(cls = layer)
	    ) 
	    ((length(arr) == 2) 
		(cls = car(arr)) 
		(subcls = cadr(arr))
	    )
	) 
	when(cls 
	    (cls_mapped = cls) 
	    cond((eq(mode t) 
		    (cls_mapped = (axlMapClassName cls t))
		) 
		(eq(mode nil) 
		    (cls_mapped = (axlMapClassName cls nil))
		) 
		(eq(mode 
			'forceMCM
		    ) 
		    when(mcm_name[cls] 
			(cls_mapped = mcm_name[cls])
		    )
		) 
		(eq(mode 
			'forcePCB
		    ) 
		    when(pcb_name[cls] 
			(cls_mapped = pcb_name[cls])
		    )
		)
	    ) 
	    if(subcls then 
		(layer_new = strcat(cls_mapped "/" subcls)) else 
		(layer_new = cls_mapped)
	    )
	) layer_new
    )
)

/****************************************************/
/*函数名称 : 
/*函数功能 : 
/****************************************************/
procedure( AUTOTXT_Calculate_Text_Block(sym_inst_data sym_def_data text_value text_rotation text_rotation_def) 
    let((sym_box_corners sym_box_center text_xy text_block block_nr
	    block_height block_width block_space loop char_cnt
	    text_width text_height boundary_clearance max_text_width max_text_height
	    sym_box_width sym_box_height cnt fit_cnt block_info
	) 
	(sym_box_center = car(sym_inst_data)) 
	cond((((axlFormGetField 
			(AUTOTXT_data->formid) "spin_long_side"
		    ) || (axlFormGetField 
			(AUTOTXT_data->formid) "spin_absolute"
		    )) 
		(sym_box_corners = cadr(sym_inst_data)) 
		(sym_box_width = abs((car((upperRight sym_box_corners)) - 
			    car((lowerLeft sym_box_corners)))
		    )) 
		(sym_box_height = abs((cadr((upperRight sym_box_corners)) - 
			    cadr((lowerLeft sym_box_corners)))
		    )) 
		if((zerop(round(text_rotation)) || (round(text_rotation) == 180)) then 
		    (max_text_width = sym_box_width) 
		    (max_text_height = sym_box_height) else
		    (max_text_width = sym_box_height) 
		    (max_text_height = sym_box_width)
		)
	    ) 
	    ((axlFormGetField 
		    (AUTOTXT_data->formid) "spin_relative"
		) 
		(sym_box_corners = cadr(sym_def_data)) 
		(sym_box_width = abs((car((upperRight sym_box_corners)) - 
			    car((lowerLeft sym_box_corners)))
		    )) 
		(sym_box_height = abs((cadr((upperRight sym_box_corners)) - 
			    cadr((lowerLeft sym_box_corners)))
		    )) 
		cond((((text_rotation_def >= 0.0) && (text_rotation_def <= 45.0)) 
			(max_text_width = sym_box_width) 
			(max_text_height = sym_box_height)
		    ) 
		    (((text_rotation_def > 45.0) && (text_rotation_def < 135.0)) 
			(max_text_width = sym_box_height) 
			(max_text_height = sym_box_width)
		    ) 
		    (((text_rotation_def >= 135.0) && (text_rotation_def <= 225.0)) 
			(max_text_width = sym_box_width) 
			(max_text_height = sym_box_height)
		    ) 
		    (((text_rotation_def > 225.0) && (text_rotation_def < 315.0)) 
			(max_text_width = sym_box_height) 
			(max_text_height = sym_box_width)
		    ) 
		    (((text_rotation_def >= 315.0) && (text_rotation_def <= 360.0)) 
			(max_text_width = sym_box_width) 
			(max_text_height = sym_box_height)
		    )
		)
	    ) 
	    (t t)
	) 
	(block_info = listToVector((AUTOTXT_data->blockInfo))) 
	(cnt = 0)
	(loop = t) 
	while(loop 
	    if(((cnt < length(block_info)) && block_info[cnt]) then 
		(block_height = cadr(block_info[cnt])) 
		(block_width = caddr(block_info[cnt])) 
		(block_space = nth(3 
			block_info[cnt]
		    ))
		(char_cnt = strlen(text_value)) 
		(text_width = ((char_cnt * block_width) + ((char_cnt - 1) * block_space))) 
		(text_height = block_height) 
		(boundary_clearance = (axlFormGetField 
			(AUTOTXT_data->formid) "boundary_clearance"
		    )) 
		when((boundary_clearance > 0.0) 
		    (text_width = (text_width + (2 * boundary_clearance))) 
		    (text_height = (text_height + (2 * boundary_clearance)))
		)
		if(((text_width > max_text_width) || (text_height > max_text_height)) then 
		    (loop = nil) else 
		    (fit_cnt = cnt)
		    ++cnt
		) else 
		(loop = nil)
	    )
	) 
	if(fit_cnt then 
	    (block_nr = car(block_info[fit_cnt])) else 
	    (block_nr = car(block_info[0]))
	    (block_height = cadr(block_info[0])) 
	    printf("Warning: Cannot fit text within component %s, using minimum block %d with height %.4f\n" text_value block_nr block_height)
	) 
	(text_block = sprintf(nil "%d" block_nr)) 
	(text_xy = AUTOTXT_Offset_Correction(sym_box_center text_block text_rotation))
	list(text_xy text_block)
    )
)
/****************************************************/
/*函数名称 : 
/*函数功能 : 
/****************************************************/
procedure( AUTOTXT_Calculate_Text_Rotation(sym_inst_data sym_def_data text_inst_dbid text_def_dbid) 
    let((text_rotation text_rotation_def rotation_top_h rotation_top_v rotation_bot_h
	    rotation_bot_v total_rotation rotation_mode odd_angle sym_box_width
	    sym_box_height factor sym_inst_corners sym_inst_rotation sym_inst_mirror
	    rotation_force
	) 
	(text_inst_dbid = text_inst_dbid) 
	(sym_def_data = sym_def_data) 
	(rotation_top_h = atof((axlFormGetField 
		    (AUTOTXT_data->formid) "deg_top_horizontal"
		)
	    )) 
	(rotation_top_v = atof((axlFormGetField 
		    (AUTOTXT_data->formid) "deg_top_vertical"
		)
	    ))
	(rotation_bot_h = atof((axlFormGetField 
		    (AUTOTXT_data->formid) "deg_bottom_horizontal"
		)
	    )) 
	(rotation_bot_v = atof((axlFormGetField 
		    (AUTOTXT_data->formid) "deg_bottom_vertical"
		)
	    )) 
	(rotation_force = atof((axlFormGetField 
		    (AUTOTXT_data->formid) "deg_absolute"
		)
	    )) 
	cond(((axlFormGetField 
		    (AUTOTXT_data->formid) "spin_long_side"
		) 
		(rotation_mode = "long_side")
	    ) 
	    ((axlFormGetField 
		    (AUTOTXT_data->formid) "spin_relative"
		) 
		(rotation_mode = "label_angle")
	    ) 
	    ((axlFormGetField 
		    (AUTOTXT_data->formid) "spin_absolute"
		) 
		(rotation_mode = "deg_absolute")
	    )
	) 
	(sym_inst_corners = cadr(sym_inst_data))
	(sym_inst_rotation = caddr(sym_inst_data)) 
	(sym_inst_mirror = nth(3 sym_inst_data)) 
	unless(((sym_inst_rotation == 0.0) || (sym_inst_rotation == 90.0) || (sym_inst_rotation == 180.0) || (sym_inst_rotation == 270.0)) 
	    (odd_angle = t)
	) 
	(odd_angle = odd_angle) 
	case(rotation_mode 
	    ("long_side" 
		(sym_box_height = abs((cadr((upperRight sym_inst_corners)) - 
			    cadr((lowerLeft sym_inst_corners)))
		    )) 
		(sym_box_width = abs((car((upperRight sym_inst_corners)) - 
			    car((lowerLeft sym_inst_corners)))
		    )) 
		(factor = cadr((axlDBGetDesignUnits))) 
		(sym_box_width = (sym_box_width + (1.0 / (10.0**factor))))
		if(((sym_box_height - sym_box_width) > 0.0) then 
		    if(sym_inst_mirror then 
			(text_rotation = rotation_bot_v) else 
			(text_rotation = rotation_top_v)
		    ) else 
		    if(sym_inst_mirror then 
			(text_rotation = rotation_bot_h) else 
			(text_rotation = rotation_top_h)
		    )
		)
	    ) 
	    ("label_angle" 
		(text_rotation_def = (text_def_dbid->rotation)) 
		(total_rotation = (sym_inst_rotation + text_rotation_def)) 
		(total_rotation = (total_rotation * 10.0)) 
		(total_rotation = round(total_rotation))
		(total_rotation = (total_rotation / 10.0)) 
		when((total_rotation >= 360.0) 
		    (total_rotation = (total_rotation - 360.0))
		) 
		if((sym_inst_mirror && (axlFormGetField 
			    (AUTOTXT_data->formid) "mirror_bottom"
			)) then 
		    cond((((total_rotation >= 0.0) && (total_rotation <= 45.0)) 
			    (text_rotation = total_rotation)
			) 
			(((total_rotation > 45.0) && (total_rotation <= 225.0)) 
			    (text_rotation = (total_rotation + 180.0)) 
			    when((text_rotation >= 360.0) 
				(text_rotation = (text_rotation - 360.0))
			    )
			) 
			(((total_rotation > 225.0) && (total_rotation <= 360.0)) 
			    (text_rotation = total_rotation)
			)
		    ) else 
		    cond((((total_rotation >= 0.0) && (total_rotation < 135.0)) 
			    (text_rotation = total_rotation)
			) 
			(((total_rotation >= 135.0) && (total_rotation < 315.0)) 
			    (text_rotation = (total_rotation + 180.0)) 
			    when((text_rotation >= 360.0) 
				(text_rotation = (text_rotation - 360.0))
			    )
			) 
			(((total_rotation >= 315.0) && (total_rotation <= 360.0)) 
			    (text_rotation = total_rotation)
			)
		    )
		)
	    ) 
	    ("deg_absolute" 
		(text_rotation = rotation_force)
	    )
	)
	text_rotation
    )
)



/****************************************************/
/*函数名称 : 
/*函数功能 : 
/****************************************************/
procedure( AUTOTXT_Display_Toggle(view_en form_handle side) 
    let((text_layer_top text_layer_bottom comp_outline_layer_top comp_outline_layer_bottom layer_list) 
	(text_layer_top = strcat((axlFormGetField form_handle "label_layer") "TOP")) 
	(text_layer_bottom = strcat((axlFormGetField form_handle "label_layer") "BOTTOM")) 
	(comp_outline_layer_top = strcat((axlFormGetField form_handle "outline_layer") "TOP")) 
	(comp_outline_layer_bottom = strcat((axlFormGetField form_handle "outline_layer") "BOTTOM"))
	case(side 
	    ("top" 
		(layer_list = list(text_layer_top comp_outline_layer_top))
	    ) 
	    ("bottom" 
		(layer_list = list(text_layer_bottom comp_outline_layer_bottom))
	    ) 
	    (t 
		printf("Invalid value, nothing to toggle\n")
	    )
	) 
	foreach(lyr layer_list 
		axlVisibleLayer( lyr view_en)		
	) 
	(axlVisibleUpdate t) t
    )
)

/****************************************************/
/*函数名称 : 
/*函数功能 : 
/****************************************************/
procedure( AUTOTXT_Get_Block_Info(form_handle) 
    let((cur_block_range cur_height cur_block range_str text_param
	    int_block_list max_height min_height arr start
	    end tmp_list full_block_range ret_data block_range_init
	) 
	(full_block_range = tconc(nil nil)) 
	(cur_block_range = tconc(nil nil)) 
	cond(((axlFormGetField form_handle "text_match_minmax_height") 
		(min_height = (axlFormGetField form_handle "min_height")) 
		(max_height = (axlFormGetField form_handle "max_height")) 
		foreach(entry 
		    (AUTOTXT_data->textList) 
		    (cur_height = car(entry)) 
		    (cur_block = cadr(entry)) 
		    (text_param = (axlGetParam 
			    sprintf(nil "paramTextBlock:%d" cur_block)
			))
		    tconc(full_block_range 
			list(cur_block 
			    (text_param->height) 
			    (text_param->width) 
			    (text_param->charSpace)
			)
		    ) 
		    when(((min_height <= cur_height) && (cur_height <= max_height)) 
			tconc(cur_block_range 
			    list(cur_block 
				(text_param->height) 
				(text_param->width) 
				(text_param->charSpace)
			    )
			)
		    )
		) 
		(full_block_range = cdar(full_block_range))
		(cur_block_range = cdar(cur_block_range)) 
		if((length(cur_block_range) > 0) then 
		    (ret_data = cur_block_range) else 
		    printf("Warning: Invalid block min/max height settings. Using defaults  min = %L  max = %L\n" 
			((AUTOTXT_data->textInfo)->minHeight) 
			((AUTOTXT_data->textInfo)->maxHeight)
		    )
		    (axlFormSetField form_handle "min_height" 
			((AUTOTXT_data->textInfo)->minHeight)
		    ) 
		    (axlFormSetField form_handle "max_height" 
			((AUTOTXT_data->textInfo)->maxHeight)
		    ) 
		    (ret_data = full_block_range)
		)
	    ) 
	    (t 
		(range_str = (axlFormGetField form_handle "block_range")) 
		rexCompile(" *- *") 
		(range_str = rexReplace(range_str "-" 0)) 
		rexCompile("  *")
		(range_str = rexReplace(range_str " " 0)) 
		(range_str = (axlStringRemoveSpaces range_str)) 
		foreach(spec 
		    parseString(range_str " ") 
		    cond((rexMatchp("-" spec) 
			    (arr = parseString(spec "-")) 
			    if(((length(arr) == 2) && atoi(car(arr)) && atoi(cadr(arr))) then 
				(tmp_list = list(atoi(car(arr)) 
					atoi(cadr(arr))
				    )) 
				(tmp_list = sort(tmp_list 
					'lessp
				    )) 
				(start = car(tmp_list))
				(end = cadr(tmp_list)) 
				for(i start end 
				    unless(member(i int_block_list) 
					(int_block_list = cons(i int_block_list))
				    )
				) else 
				printf("Warning: Ignoring invalid block specifier %L\n" spec)
			    )
			) 
			(atoi(spec) 
			    unless(member(atoi(spec) int_block_list) 
				(int_block_list = cons(atoi(spec) int_block_list))
			    )
			) 
			(t 
			    printf("Warning: Ignoring invalid block specifier %L\n" spec)
			)
		    )
		) 
		foreach(entry 
		    (AUTOTXT_data->textList) 
		    (cur_block = cadr(entry)) 
		    (text_param = (axlGetParam 
			    sprintf(nil "paramTextBlock:%d" cur_block)
			)) 
		    tconc(full_block_range 
			list(cur_block 
			    (text_param->height) 
			    (text_param->width) 
			    (text_param->charSpace)
			)
		    )
		    when(member(cur_block int_block_list) 
			tconc(cur_block_range 
			    list(cur_block 
				(text_param->height) 
				(text_param->width) 
				(text_param->charSpace)
			    )
			)
		    )
		) 
		(full_block_range = cdar(full_block_range))
		(cur_block_range = cdar(cur_block_range)) 
		if((length(cur_block_range) > 0) then 
		    (ret_data = cur_block_range) else 
		    (block_range_init = sprintf(nil "%d-%d" 
			    ((AUTOTXT_data->textInfo)->minBlock) 
			    ((AUTOTXT_data->textInfo)->maxBlock)
			))
		    printf("Warning: Invalid block range settings. Using default range %s\n" block_range_init) 
		    (axlFormSetField form_handle "block_range" block_range_init) 
		    (ret_data = full_block_range)
		)
	    )
	) ret_data
    )
)
/****************************************************/
/*函数名称 : 
/*函数功能 : 
/****************************************************/
procedure( AUTOTXT_Get_Box_Center(box) 
    let((x_ll y_ll x_ur y_ur x_center
	    y_center ret
	) 
	(x_ll = car((lowerLeft box))) 
	(y_ll = cadr((lowerLeft box))) 
	(x_ur = car((upperRight box))) 
	(y_ur = cadr((upperRight box)))
	foreach(xy box 
	    when((car(xy) < x_ll) 
		(x_ll = car(xy))
	    ) 
	    when((cadr(xy) < y_ll) 
		(y_ll = cadr(xy))
	    ) 
	    when((car(xy) > x_ur) 
		(x_ur = car(xy))
	    )
	    when((cadr(xy) > y_ur) 
		(y_ur = cadr(xy))
	    )
	) 
	(x_ll = (x_ll * 1.0)) 
	(y_ll = (y_ll * 1.0)) 
	(x_ur = (x_ur * 1.0)) 
	(y_ur = (y_ur * 1.0))
	(x_center = (x_ll + ((x_ur - x_ll) / 2.0))) 
	(y_center = (y_ll + ((y_ur - y_ll) / 2.0))) 
	(ret = (x_center:y_center)) ret
    )
)
/****************************************************/
/*函数名称 : 
/*函数功能 : 
/****************************************************/
procedure( AUTOTXT_Get_Defaults() 
    let((cfg_file default_dpl file_data design_units session_param
	    cur_value
	) 
	(default_dpl = ncons(nil)) 
	(design_units = lowerCase(car((axlDBGetDesignUnits)))) 
	if(((design_units == "microns") || (design_units == "millimeters") || (design_units == "centimeters")) then 
	    (default_dpl->minHeight = (axlMKSConvert "0.5 MM" design_units)) 
	    (default_dpl->maxHeight = (axlMKSConvert "5.0 MM" design_units)) 
	    (default_dpl->boundaryClearance = (axlMKSConvert "0.2 MM" design_units))
		(default_dpl->outlineClearance = (axlMKSConvert "0.15 MM" design_units))
	    else 
	    (default_dpl->minHeight = (axlMKSConvert "20.0 MILS" design_units)) 
	    (default_dpl->maxHeight = (axlMKSConvert "200.0 MILS" design_units)) 
	    (default_dpl->boundaryClearance = (axlMKSConvert "8.0 MILS" design_units))
		(default_dpl->outlineClearance = (axlMKSConvert "6.0 MILS" design_units))
	) 
	(default_dpl->offsetX = 0.0)
	(default_dpl->offsetY = 0.0) 
	(default_dpl->offsetCorrection = 0.0) 
	(default_dpl->labelName = "refdes") 
	(default_dpl->labelLayer = 	 cadr(nth(2 ((AUTOTXT_data->popupInfo)["refdes"]))) ) 
	(default_dpl->outlineLayer = cadr(nth(3 ((AUTOTXT_data->popupInfo)["package_geom"]))) )
	(default_dpl->mirrorBottom = t) 
	(default_dpl->rotateText = t) 
	(default_dpl->centerText = nil)
	(default_dpl->symedgeText = t)	
	(default_dpl->fitText = nil) 
	(default_dpl->textMatchMinMaxHeight = nil)
	(default_dpl->textMatchBlockRange = t) 
	(default_dpl->blockRange = sprintf(nil "%d-%d" 
		((AUTOTXT_data->textInfo)->minBlock) 
		((AUTOTXT_data->textInfo)->maxBlock)
	    )) 
	(default_dpl->spinLongSide = t) 
	(default_dpl->spinAbsolute = nil) 
	(default_dpl->spinRelative = nil)
	(default_dpl->degTopHorizontal = "0") 
	(default_dpl->degTopVertical = "90") 
	(default_dpl->degBottomHorizontal = "0") 
	(default_dpl->degBottomVertical = "90") 
	(default_dpl->degAbsolute = "0")
	default_dpl
    )
)
/****************************************************/
/*函数名称 : 
/*函数功能 : 
/****************************************************/
procedure( AUTOTXT_Get_Label(comp_dbid sym_type) 
    let((label_layer_pat text_dbid sym_dbid result) 
	(label_layer_pat = (axlFormGetField 
		(AUTOTXT_data->formid) "label_layer"
	    )) 
	case(sym_type 
	    ("instance" 
		(sym_dbid = (comp_dbid->symbol))
	    ) 
	    ("definition" 
		(sym_dbid = ((comp_dbid->symbol)->definition))
	    )
	) 
	(result = setof(ch 
		(sym_dbid->children) 
		(((ch->objType) == "text") && rexMatchp(label_layer_pat 
			(ch->layer)
		    ))
	    )) 
	if(result then 
	    (text_dbid = car(result)) else t
	)
	text_dbid
    )
)
/****************************************************/
/*函数名称 : 
/*函数功能 : 
/****************************************************/
procedure( AUTOTXT_Get_Max_Extents(box_list) 
    let((x_ll y_ll x_ur y_ur ret_list) 
	foreach(b box_list 
	    unless(x_ll 
		(x_ll = car((lowerLeft b)))
	    ) 
	    unless(y_ll 
		(y_ll = cadr((lowerLeft b)))
	    ) 
	    unless(x_ur 
		(x_ur = car((upperRight b)))
	    )
	    unless(y_ur 
		(y_ur = cadr((upperRight b)))
	    ) 
	    when((car((lowerLeft b)) < x_ll) 
		(x_ll = car((lowerLeft b)))
	    ) 
	    when((cadr((lowerLeft b)) < y_ll) 
		(y_ll = cadr((lowerLeft b)))
	    ) 
	    when((car((upperRight b)) > x_ur) 
		(x_ur = car((upperRight b)))
	    ) 
	    when((cadr((upperRight b)) > y_ur) 
		(y_ur = cadr((upperRight b)))
	    )
	) 
	(ret_list = list((x_ll:y_ll) 
		(x_ur:y_ur)
	    )) ret_list
    )
)
/****************************************************/
/*函数名称 : 
/*函数功能 : 
/****************************************************/
procedure( AUTOTXT_Get_Outline(comp_dbid sym_type text_dbid) 
    let((outline_layer_pat outline_layer sym_dbid list_of_boxes box_corners
	    box_center ret_list pp pm x
	    y x_ll y_ll x_ul y_ul
	    rotation mirror result
	) 
	(outline_layer_pat = (axlFormGetField 
		(AUTOTXT_data->formid) "outline_layer"
	    )) 
	cond((rexMatchp("_TOP$" 
		    (text_dbid->layer)
		) 
		(outline_layer = strcat(outline_layer_pat "TOP"))
	    ) 
	    (rexMatchp("_BOTTOM$" 
		    (text_dbid->layer)
		) 
		(outline_layer = strcat(outline_layer_pat "BOTTOM"))
	    )
	) 
	case(sym_type 
	    ("instance" 
		(sym_dbid = (comp_dbid->symbol))
	    ) 
	    ("definition" 
		(sym_dbid = ((comp_dbid->symbol)->definition))
	    ) 
	    (t)
	) 
	if(sym_dbid then 
	    (result = setof(ch 
		    (sym_dbid->children) 
		    ((ch->layer) && (upperCase((ch->layer)) == outline_layer))
		)) 
	    foreach(ch result 
		when((((ch->objType) == "path") || ((ch->objType) == "shape") || ((ch->objType) == "polygon")) 
		    (list_of_boxes = cons((ch->bBox) list_of_boxes))
		)
	    ) 
	    if((length(list_of_boxes) > 0) then 
		(box_corners = AUTOTXT_Get_Max_Extents(list_of_boxes)) 
		(box_center = AUTOTXT_Get_Box_Center(box_corners)) 
		(rotation = (sym_dbid->rotation))
		(mirror = (sym_dbid->isMirrored)) else 
		(pp = (1.0 / (10**cadr((axlDBGetDesignUnits))))) 
		(pm = (pp * -1.0)) 
		if((sym_dbid->xy) then 
		    (x = car((sym_dbid->xy))) 
		    (y = cadr((sym_dbid->xy))) 
		    (x_ll = (x - pp))
		    (y_ll = (y - pp)) 
		    (x_ul = (x + pp)) 
		    (y_ul = (y + pp)) 
		    (box_corners = list((x_ll:y_ll) 
			    (x_ul:y_ul)
			)) 
		    (box_center = (sym_dbid->xy))
		    (rotation = (sym_dbid->rotation)) 
		    (mirror = (sym_dbid->isMirrored)) else 
		    printf("Warning no outline data found for component:%s\n" 
			(comp_dbid->name)
		    ) 
		    (box_corners = list((pm:pm) 
			    (pp:pp)
			))
		    (box_center = nil) 
		    (rotation = nil) 
		    (mirror = nil)
		)
	    )
	    (ret_list = list(box_center box_corners rotation mirror)) else 
	    (ret_list = nil)
	)
	ret_list
    )
)

/****************************************************/
/*函数名称 : AUTOTXT_Layer_Popup_Setup() 
/*函数功能 : TEXT相关层的信息获得
/****************************************************/
procedure( AUTOTXT_Layer_Popup_Setup() 
    let((base_name base_list layer_top layer_bot class_name
	    nice_name config_list pkg_nick_name popup_info nick_name
	    popup_list
	) 
	(nice_name = makeTable("nice_name_table" nil)) 
	(nice_name["ASSEMBLY"] = "Assembly") 
	(nice_name["PLACE_BOUND"] = "Place_Bound") 
	(nice_name["SILKSCREEN"] = "Silkscreen")
	(nice_name["DISPLAY"] = "Display") 
	(nice_name["DFA_BOUND"] = "DFA_Bound") 
	(pkg_nick_name = "package_geom") 
	(config_list = list(list("refdes" 
		    (axlMapClassName "REF DES")
		) 
		list("value" 
		    (axlMapClassName "COMPONENT VALUE")
		) 
		list("part_number" 
		    (axlMapClassName "USER PART NUMBER")
		) 
		list("device_type" 
		    (axlMapClassName "DEVICE TYPE")
		) 
		list("tolerance" 
		    (axlMapClassName "TOLERANCE")
		)
		list(pkg_nick_name 
		    (axlMapClassName "PACKAGE GEOMETRY")
		)
	    )) 
	(popup_info = makeTable("layer_info_table" nil))
	foreach(entry config_list 
	    (nick_name = car(entry)) 
	    (class_name = cadr(entry)) 
	    (base_list = list())
	    foreach(lyr 
		((axlGetParam 
			strcat("paramLayerGroup:" class_name)
		    )->groupMembers) 
		(base_name = upperCase(lyr)) 
		when((rexMatchp("_TOP" base_name) || 
			rexMatchp("_BOTTOM" base_name)) 
		    rexCompile("_TOP") 
		    (base_name = rexReplace(base_name "" 0)) 
		    rexCompile("_BOTTOM") 
		    (base_name = rexReplace(base_name "" 0))
		    unless(member(base_name base_list) 
			(base_list = cons(base_name base_list))
		    )
		)
	    ) 
	    (base_list = sort(base_list nil)) 
	    when((nick_name == pkg_nick_name) 
		(base_list = remove("SOLDERMASK" base_list)) 
		(base_list = remove("PASTEMASK" base_list))
	    ) 
	    foreach(name base_list 
		(layer_top = strcat(class_name "/" name "_TOP")) 
		(layer_bot = strcat(class_name "/" name "_BOTTOM")) 
		unless((axlIsLayer layer_top) 
		    (axlLayerCreateNonConductor layer_top)
		)
		unless((axlIsLayer layer_bot) 
		    (axlLayerCreateNonConductor layer_bot)
		)
	    ) 
	    (popup_list = list())
	    foreach(base base_list 
		if(nice_name[base] then 
		    (base_name = nice_name[base]) else 
		    (base_name = strcat(upperCase(substring(base 1 1)) 
			    lowerCase(substring(base 2))
			))
		) 
		(popup_list = cons(list(base_name 
			    strcat(class_name "/" base "_")
			) popup_list
		    ))
	    ) 
	    (popup_list = reverse(popup_list)) 
	    (popup_info[nick_name] = popup_list)
	) popup_info
    )
)
/****************************************************/
/*函数名称 : 
/*函数功能 : 
/****************************************************/
procedure( AUTOTXT_Limit_Layer_Visibility(form_handle) 
    let((text_layer_top text_layer_bottom board_outline_layer comp_outline_layer_top comp_outline_layer_bottom) 
	(text_layer_top = strcat((axlFormGetField form_handle "label_layer") "TOP")) 
	(text_layer_bottom = strcat((axlFormGetField form_handle "label_layer") "BOTTOM")) 
	(comp_outline_layer_top = strcat((axlFormGetField form_handle "outline_layer") "TOP")) 
	(comp_outline_layer_bottom = strcat((axlFormGetField form_handle "outline_layer") "BOTTOM"))
	(board_outline_layer = strcat((axlMapClassName "BOARD GEOMETRY") "/OUTLINE")) 
	(axlVisibleDesign nil) 
	(axlVisibleLayer board_outline_layer t) 
	(axlVisibleLayer comp_outline_layer_top t) 
	(axlVisibleLayer comp_outline_layer_bottom t)
	(axlVisibleLayer text_layer_top t) 
	(axlVisibleLayer text_layer_bottom t) 
	(axlVisibleUpdate t) t
    )
)

/****************************************************/
/*函数名称 : 
/*函数功能 : 
/****************************************************/
procedure( AUTOTXT_Modify_Text(c_list) 
    let((text_inst_dbid text_def_dbid text_xy text_block text_rotation_new
	    text_rotation_def text_justify text_mirror my_orient result
	    sym_box_center sym_inst_data sym_def_data text_value text_layer
	    ok_to_proceed proceed_tol proceed_ok text_first_xy user_view tol
	) 
	proceed_tol = 0
	proceed_ok = 0
	ok_to_proceed = nil
	when(AUTOTXT_data->mode == "debug" AUTOTXT_ClearDebugMark())
	when(axlFormGetField( (AUTOTXT_data->formid) "symedge_text") user_view = axlVisibleGet())
	tol = float(length(c_list))
	foreach(c c_list 
		proceed_tol++
		percent = float(proceed_tol) 
		axlFormSetField( (AUTOTXT_data->formid) "update_bar" round(((100 * percent) / tol))) 
	    (ok_to_proceed = nil) 
	    (sym_inst_data = nil) 
	    (sym_def_data = nil)
	    (text_inst_dbid = AUTOTXT_Get_Label(c "instance")) 
	    (text_def_dbid = AUTOTXT_Get_Label(c "definition")) 
	    when(text_inst_dbid 
		(sym_inst_data = AUTOTXT_Get_Outline(c "instance" text_inst_dbid))
	    ) 
	    when(text_def_dbid 
		(sym_def_data = AUTOTXT_Get_Outline(c "definition" text_def_dbid))
	    ) 
	    if((text_inst_dbid && sym_inst_data && sym_def_data) then 
			(text_value = (text_inst_dbid->text)) 
			(text_layer = (text_inst_dbid->layer)) 
			(text_xy = (text_inst_dbid->xy))
			(text_justify = (text_inst_dbid->justify)) 
			(text_block = (text_inst_dbid->textBlock)) 
			(text_mirror = (text_inst_dbid->isMirrored)) 
			(text_rotation_new = (text_inst_dbid->rotation)) 
			(text_rotation_def = (text_def_dbid->rotation))
			when(axlFormGetField((AUTOTXT_data->formid) "rotate_text") 
				(ok_to_proceed = t) 
				(text_rotation_new = AUTOTXT_Calculate_Text_Rotation(sym_inst_data sym_def_data text_inst_dbid text_def_dbid))
			) 	
			when(axlFormGetField((AUTOTXT_data->formid) "center_text") || axlFormGetField( (AUTOTXT_data->formid) "symedge_text")
				(ok_to_proceed = t) 
				(text_justify = "CENTER") 
				(sym_box_center = car(sym_inst_data)) 
				(text_xy = AUTOTXT_Offset_Correction(sym_box_center text_block text_rotation_new))
			) 
			when(axlFormGetField((AUTOTXT_data->formid) "fit_text") 
				(ok_to_proceed = t) 
				if((length((AUTOTXT_data->blockInfo)) > 0) then 
				(result = AUTOTXT_Calculate_Text_Block(sym_inst_data sym_def_data text_value text_rotation_new text_rotation_def)) 
				(text_xy = car(result)) 
				(text_block = cadr(result))
				else 
				(ok_to_proceed = nil) 
				(axlUIConfirm "Warning: No valid text blocks found for fitting operation. Adjust settings in Advanced - Text fit accordingly.")
				)
			) 
			when(axlFormGetField( (AUTOTXT_data->formid) "symedge_text")
				;高亮器件，并将位号移动到器件中心				
				axlHighlightObject(text_inst_dbid ->parent)				
				(axlTransformObject text_inst_dbid ?move axlMXYSub(text_xy text_inst_dbid->xy) )
				result = AUTOTXT_Move2SymEdge(sym_def_data text_inst_dbid text_xy text_block text_rotation_new)
				(text_xy = car(result)) 
				(text_rotation_new = cadr(result))				
				ok_to_proceed = nth(2 result)
				if(!ok_to_proceed then
					AUTOTXT_Report(sprintf(nil "Text move to edge failed,%L moves from %L to symbol center %L" text_inst_dbid->text text_inst_dbid->xy text_xy))
				else 
					proceed_ok++
				)
			) 
			
			when(ok_to_proceed == nil && axlFormGetField((AUTOTXT_data->formid) "symedge_text") == nil
				printf("Please select at least one item from \"Mode\" options\n")
			) 
			when(ok_to_proceed == t
				when(axlFormGetField((AUTOTXT_data->formid) "symedge_text") == nil proceed_ok++)
				(text_mirror = nil) 
				when(((axlFormGetField (AUTOTXT_data->formid) "mirror_bottom") && ((c->symbol)->isMirrored)) 
				(text_mirror = t)
				) 
				(my_orient = (make_axlTextOrientation ?textBlock text_block ?rotation text_rotation_new
					?mirrored text_mirror ?justify text_justify
				)) 
				(axlDeleteObject text_inst_dbid)
				(result = (axlDBCreateText text_value text_xy my_orient text_layer
					(c->symbol)
				)) 
				(axlDBRefreshId 
				(c->symbol)
				) 
				(axlDBRefreshId c) 
				unless(result 
				printf("Could not create Text for %s\n" 
					(c->name)
				)
				)
			)
		else 
			printf("Data not valid for component %s, check text label and/or outline data corresponding to selected options\n" 
				(c->name)
			)
	    )
	)
	when(axlFormGetField( (AUTOTXT_data->formid) "symedge_text") 
	axlVisibleSet(user_view)
	AUTOTXT_data->cklayerview = nil
	)
	AUTOTXT_Report(sprintf(nil "\nText [ %d ] / Modify [ %d ] = %0.2f%s" proceed_tol proceed_ok ((float(proceed_ok) / float(proceed_tol)) * 100) "%"))
	axlUIWPrint(AUTOTXT_data->formid sprintf(nil "Text [ %d ] / Modify [ %d ] = %0.2f%s" proceed_tol proceed_ok ((float(proceed_ok) / float(proceed_tol)) * 100) "%%"))
   )
)

/****************************************************/
/*函数功能 :  从brd上删除测试时用的临时标记
/****************************************************/
procedure( AUTOTXT_ClearDebugMark()
let((saveVisx)
	axlClearSelSet()
	saveVisx = axlVisibleGet()
	axlVisibleDesign(nil)
	axlVisibleLayer(AUTOTXT_data->tmplayer t)

	axlSetFindFilter(?enabled '(noall shapes) ?onButtons '(noall shapes))
	axlAddSelectAll()
	axlDeleteObject(axlGetSelSet())

	axlVisibleSet(saveVisx)
	axlSetFindFilter( ?enabled list("noall" "components") ?onButtons list("all")) 
)
)

/****************************************************/
/*函数名称 : 
/*函数功能 : 
/****************************************************/
procedure( AUTOTXT_Offset_Correction(text_xy text_block text_rotation) 
    let((correction_factor text_height text_offset delta_x delta_y
	    angle text_x text_y PI text_param
	    user_dx user_dy
	) 
	(text_param = (axlGetParam 
		strcat("paramTextBlock:" text_block)
	    )) 
	(PI = 3.141593) 
	(correction_factor = (axlFormGetField 
		(AUTOTXT_data->formid) "offset_correction"
	    )) 
	(user_dx = (axlFormGetField 
		(AUTOTXT_data->formid) "offset_x"
	    ))
	(user_dy = (axlFormGetField 
		(AUTOTXT_data->formid) "offset_y"
	    )) 
	(text_height = (text_param->height)) 
	(text_offset = ((text_height / 2.0) - (text_height * correction_factor))) 
	cond((((text_rotation >= 0.0) && (text_rotation <= 90.0)) 
		(angle = ((text_rotation / 180.0) * PI)) 
		(delta_x = abs((cos(((PI / 2) - angle)) * text_offset))) 
		(delta_y = (- abs((sin(((PI / 2) - angle)) * text_offset))))
	    ) 
	    (((text_rotation > 90.0) && (text_rotation <= 180.0)) 
		(angle = (((180.0 - text_rotation) / 180.0) * PI)) 
		(delta_x = abs((cos(((PI / 2) - angle)) * text_offset))) 
		(delta_y = abs((sin(((PI / 2) - angle)) * text_offset)))
	    ) 
	    (((text_rotation > 180.0) && (text_rotation <= 270.0)) 
		(angle = (((text_rotation - 180.0) / 180.0) * PI)) 
		(delta_x = (- abs((cos(((PI / 2) - angle)) * text_offset)))) 
		(delta_y = abs((sin(((PI / 2) - angle)) * text_offset)))
	    ) 
	    (((text_rotation > 270.0) && (text_rotation <= 360.0)) 
		(angle = (((360.0 - text_rotation) / 180.0) * PI)) 
		(delta_x = (- abs((cos(((PI / 2) - angle)) * text_offset)))) 
		(delta_y = (- abs((sin(((PI / 2) - angle)) * text_offset))))
	    )
	) 
	(text_x = (car(text_xy) + delta_x))
	(text_y = (cadr(text_xy) + delta_y)) 
	(text_x = (text_x + user_dx)) 
	(text_y = (text_y + user_dy)) 
	list(text_x text_y)
    )
)

/****************************************************/
/*函数功能 : 通过偏移量和角度计算偏移坐标
/****************************************************/
procedure( AUTOTXT_Calculate_Offset_xy(text_xy Offset_def_xy Offset_rotation) 
    let((   delta_x1 delta_y1 delta_x2 delta_y2 
	    angle Offset_x Offset_y PI text_param
	    user_dx user_dy Offset_def_x Offset_def_y
	) 
	user_dx = 0
	user_dy = 0
	delta_x1 = 0
	delta_y1 = 0
	delta_x2 = 0
	delta_y2 = 0
	(PI = 3.141593)
	
	Offset_def_x = car(Offset_def_xy)
	Offset_def_y = cadr(Offset_def_xy)
	when( Offset_def_x != 0
		cond(
			((Offset_rotation >= 0.0) && (Offset_rotation <= 90.0)
			angle = ((Offset_rotation / 180.0) * PI) 
			delta_x1 = -(cos(angle) * Offset_def_x) 
			delta_y1 = -(sin(angle) * Offset_def_x)
			) 
			((Offset_rotation > 90.0) && (Offset_rotation <= 180.0) 
			angle = (((180.0 - Offset_rotation) / 180.0) * PI) 
			delta_x1 = -(cos(angle) * Offset_def_x) 
			delta_y1 = -(sin(angle) * Offset_def_x)
			) 
			((Offset_rotation > 180.0) && (Offset_rotation <= 270.0) 
			angle = (((Offset_rotation - 180.0) / 180.0) * PI) 
			delta_x1 =  (cos(angle) * Offset_def_x) 
			delta_y1 = -(sin(angle) * Offset_def_x)
			) 
			((Offset_rotation > 270.0) && (Offset_rotation <= 360.0) 
			angle = (((360.0 - Offset_rotation) / 180.0) * PI) 
			delta_x1 =  -(cos(angle) * Offset_def_x) 
			delta_y1 =  (sin(angle) * Offset_def_x)
			)
		)


	)

	when( Offset_def_y != 0	
	cond(
			((Offset_rotation >= 0.0) && (Offset_rotation <= 90.0) 
			angle = ((Offset_rotation / 180.0) * PI) 
			delta_x2 = -(cos(((PI / 2) - angle)) * Offset_def_y) 
			delta_y2 =  (sin(((PI / 2) - angle)) * Offset_def_y)
			) 
			((Offset_rotation > 90.0) && (Offset_rotation <= 180.0) 
			angle = (((180.0 - Offset_rotation) / 180.0) * PI) 
			delta_x2 = -(cos(((PI / 2) - angle)) * Offset_def_y) 
			delta_y2 = -(sin(((PI / 2) - angle)) * Offset_def_y)
			) 
			((Offset_rotation > 180.0) && (Offset_rotation <= 270.0) 
			angle = (((Offset_rotation - 180.0) / 180.0) * PI) 
			delta_x2 =  (cos(((PI / 2) - angle)) * Offset_def_y) 
			delta_y2 = -(sin(((PI / 2) - angle)) * Offset_def_y)
			) 
			((Offset_rotation > 270.0) && (Offset_rotation <= 360.0) 
			angle = (((360.0 - Offset_rotation) / 180.0) * PI)
			delta_x2 =  (cos(((PI / 2) - angle)) * Offset_def_y) 
			delta_y2 =  (sin(((PI / 2) - angle)) * Offset_def_y)
			)
		)
	)	
	
	Offset_x = car(text_xy) + delta_x1  + delta_x2 
	Offset_y = cadr(text_xy) + delta_y1 + delta_y2
	Offset_x = (Offset_x + user_dx) 
	Offset_y = (Offset_y + user_dy)
	list(Offset_x Offset_y)
    )
)


/****************************************************/
/*函数名称 : 
/*函数功能 : 
/****************************************************/
procedure( AUTOTXT_Move2SymEdge(sym_def_data text_dbid text_xy text_block text_rotation) 
prog((res sym_height sym_corners text_width text_height text_offset sym_width Offset_rotation 
	  text_box text_target_xy moveok outline_clearance offset_list)
	
	sym_corners = cadr(sym_def_data)
	sym_width  = abs((car((upperRight sym_corners))  - car((lowerLeft sym_corners)))) 
	sym_height = abs((cadr((upperRight sym_corners)) - cadr((lowerLeft sym_corners))))
	res = AUTOTXT_GetTextBlock(text_dbid->text text_block)	

	
	
	when(rexMatchp("TOP$" text_dbid->layer) 	AUTOTXT_data->cklayer = "TOP")
	when(rexMatchp("BOTTOM$" text_dbid->layer)  AUTOTXT_data->cklayer = "BOTTOM")
	
	Offset_rotation = text_rotation
	outline_clearance = axlFormGetField( (AUTOTXT_data->formid) "outline_clearance") 
	
	text_width  = nth(0 res)		
	text_height = nth(1 res)
	text_xy_offset = nth(2 res)
	
	offset_list = nil
	offset_list = append1(offset_list list(0 (((sym_height + text_height) / 2.0) + outline_clearance)) 	);器件上边
	offset_list = append1(offset_list list(0 -(((sym_height + text_height) / 2.0) + outline_clearance)) );器件下边	
	offset_list = append1(offset_list list(((sym_width+ text_width) / 2.0 + outline_clearance) 0) 		);器件左边	
	offset_list = append1(offset_list list(-(((sym_width+ text_width) / 2.0) +outline_clearance) 0) 	);器件右边
		
	moveok = nil
	foreach(offset offset_list 
		when(moveok == nil	 
			text_target_xy = AUTOTXT_Calculate_Offset_xy(text_xy offset Offset_rotation)	
			text_box = AUTOTXT_GetTextBox(text_target_xy text_width text_height text_xy_offset text_dbid->justify Offset_rotation)	
			check_obj = AUTOTXT_CheckSelObj(text_box)
			
			if((check_obj == nil)
			then 
				text_xy = text_target_xy
				moveok = t
			else
				when(AUTOTXT_data->mode == "debug" 
					if(length(text_box) == 2 	
					then
						axlDBCreateRectangle(text_box nil AUTOTXT_data->tmplayer)
					else
						path = axlPathStart(text_box 0.0)
						path = axlPathLine(path, 0.0, car(text_box))   
						shp = axlDBCreateOpenShape(path t AUTOTXT_data->tmplayer) 
					)
				)
			)
		)
	)

	if((moveok == t) then 
		axlDehighlightObject(text_dbid ->parent)
	)	
	return(list(text_xy Offset_rotation moveok))
	
)
)
/****************************************************/
/*函数功能 : 
/****************************************************/
procedure( AUTOTXT_GetTextShape(point_list)
	prog(()
		path = axlPathStart(point_list 0.0)
        path = axlPathLine(path, 0.0, car(point_list))   
        ; shp = axlDBCreateOpenShape(path)            
        ; shap = axlDBCreateCloseShape(shp)   
        o_shp = axlPolyFromDB(path)
        return(o_shp)
	)
)
/****************************************************/
/*函数功能 : 
/****************************************************/
procedure( AUTOTXT_TextSelBox(four_P)
prog((minx miny maxx maxy xy_list px py)
	
	xy_list = mapcar('list nth(0 four_P) nth(1 four_P) nth(2 four_P) nth(3 four_P) )
	px = xCoord(xy_list)
	py = yCoord(xy_list)
	minx = min(nth(0 px) nth(1 px) nth(2 px) nth(3 px) ) 
	maxx = max(nth(0 px) nth(1 px) nth(2 px) nth(3 px) )
	miny = min(nth(0 py) nth(1 py) nth(2 py) nth(3 py) )
	maxy = max(nth(0 py) nth(1 py) nth(2 py) nth(3 py) ) 
	return(list(minx:miny maxx:maxy))
)
)
/****************************************************/
/*函数功能 : 
/****************************************************/
procedure( AUTOTXT_Lines2ShapesOr(lines)
	prog((flattened and_polys polys)
		flattened = foreach( mapcan x lines x)
		foreach(path flattened
			polys = axlPolyFromDB(path ?endCapType 'ROUND ?line2poly t)
	    	(if and_polys then
			    and_polys = axlPolyOperation( and_polys polys 'or)
			else
				and_polys = polys
				)
			)
	return(and_polys)
	)
)

/****************************************************/
/*函数功能 :检查指定区域是否有干涉物 
/****************************************************/
procedure( AUTOTXT_CheckSelObj(text_box)
prog((obj_shape text_shape sel_box and_shape find_obj en_list on_list)
		
		obj_shape = nil
		find_obj = nil
		if(axlFormGetField( (AUTOTXT_data->formid) "avoid_via") 
		then
		en_list = list("NOALL" "text" "lines" "pins" "shapes" "VIAS")
		on_list = list("text" "lines" "pins" "shapes" "VIAS")
		else
		en_list = list("NOALL" "text" "lines" "pins" "shapes")
		on_list = list("text" "lines" "pins" "shapes")
		)
		axlSetFindFilter( ?enabled en_list ?onButtons on_list)
		
		when(AUTOTXT_data->cklayer != AUTOTXT_data->cklayerview
			when(AUTOTXT_data->cklayer == "TOP"
				(axlVisibleDesign nil) 
				(axlVisibleLayer "BOARD GEOMETRY/OUTLINE" t) 
				(axlVisibleLayer "PIN/TOP" t)
				(axlVisibleLayer "PIN/SOLDERMASK_TOP" t) 
				(axlVisibleLayer "REF DES/SILKSCREEN_TOP" t) 
				(axlVisibleLayer "PACKAGE GEOMETRY/SILKSCREEN_TOP" t) 
				(axlVisibleLayer "PACKAGE GEOMETRY/Pin_Number" nil)
				(axlVisibleLayer "BOARD GEOMETRY/SILKSCREEN_TOP" t) 
				(axlVisibleLayer "BOARD GEOMETRY/SOLDERMASK_TOP" t)
				(axlVisibleLayer "PACKAGE GEOMETRY/SOLDERMASK_TOP" t) 				
				(axlVisibleLayer "BOARD GEOMETRY/SOLDERMASK_TOP" t)
				(axlVisibleLayer "PACKAGE GEOMETRY/SOLDERMASK_TOP" t) 
				when(axlFormGetField( (AUTOTXT_data->formid) "avoid_via")
					(axlVisibleLayer "VIA CLASS/TOP"  t)
					(axlVisibleLayer "VIA CLASS/SOLDERMASK_TOP"  t)	
				)
				AUTOTXT_data->cklayerview = "TOP"
			)
			when(AUTOTXT_data->cklayer == "BOTTOM"
				(axlVisibleDesign nil) 
				(axlVisibleLayer "BOARD GEOMETRY/OUTLINE" t) 
				(axlVisibleLayer "PIN/BOTTOM" t)
				(axlVisibleLayer "PIN/SOLDERMASK_BOTTOM" t) 				
				(axlVisibleLayer "REF DES/SILKSCREEN_BOTTOM" t) 
				(axlVisibleLayer "PACKAGE GEOMETRY/SILKSCREEN_BOTTOM" t) 
				(axlVisibleLayer "PACKAGE GEOMETRY/Pin_Number" nil)
				(axlVisibleLayer "BOARD GEOMETRY/SILKSCREEN_BOTTOM" t) 				
				(axlVisibleLayer "BOARD GEOMETRY/SOLDERMASK_BOTTOM" t)
				(axlVisibleLayer "PACKAGE GEOMETRY/SOLDERMASK_BOTTOM" t) 
				when(axlFormGetField( (AUTOTXT_data->formid) "avoid_via")
					(axlVisibleLayer "VIA CLASS/BOTTOM"  t)
					(axlVisibleLayer "VIA CLASS/SOLDERMASK_BOTTOM"  t)	
				)
				AUTOTXT_data->cklayerview = "BOTTOM"
			)			
		)
		axlClearSelSet()
		if(length(text_box) == 2 		
		then			
			when(axlSingleSelectBox(text_box) != nil
				find_obj = t
			)			
		else

			text_shape = AUTOTXT_GetTextShape(text_box)
			sel_box = AUTOTXT_TextSelBox(text_box)
			axlSingleSelectBox(sel_box)
			selobj = axlGetSelSet()
			(foreach item selobj
				(case item->objType
					("pin"
						obj_shape = axlPolyFromDB(item ?layer car(item->startEnd) ?padType 'REGULAR)
					)
					("line"
						obj_shape = axlDB2Path(item)
					)
					("path"
						obj_shape = axlPolyFromDB(item)
					)
					("text"
						lines = axlText2Lines(item)
						obj_shape = AUTOTXT_Lines2ShapesOr(lines)
					)
				)
				when(obj_shape
					and_shape = axlPolyOperation(text_shape obj_shape 'AND)
					(foreach item and_shape
						when(item
							find_obj = t 
							)
						)
				)
			)			
		)
		axlClearSelSet() 
		axlSetFindFilter( ?enabled list("noall" "components") ?onButtons list("all")) 		
		return(find_obj)
)
)

/****************************************************/
/*函数功能 : 计算text的实际长宽
/****************************************************/
procedure( AUTOTXT_GetTextBlock(t_value t_block)
let((text_block_dbid  text_height text_width text_xy_offset)
	
	text_block_dbid = axlGetParam(strcat("paramTextBlock:" t_block)) 	
	text_xy_offset = (text_block_dbid->photoWidth) / 2
	text_height = text_block_dbid->height + text_block_dbid->photoWidth
	text_width = (strlen(t_value) * (text_block_dbid->width)) + ((strlen(t_value) - 1) * (text_block_dbid->charSpace)) 
	
	list(text_width text_height text_xy_offset)
)
)

/****************************************************/
/*函数功能 : 计算text的实际box
/****************************************************/
procedure( AUTOTXT_GetTextBox(text_xy text_width text_height text_xy_offset text_justify text_rotation)
prog((box_ll box_ur text_offset_ll text_offset_ul text_offset_ur text_offset_lr)

	(case text_justify
		("LEFT"	
			text_offset_ll = list( 0 -text_xy_offset )
			text_offset_ur = list( text_width  (text_height - text_xy_offset) )
			)
		("CENTER"	
			text_offset_ll = list(-(text_width / 2)  -text_xy_offset )
			text_offset_ur = list( (text_width / 2)  (text_height - text_xy_offset) )
		)
		("RIGHT"	
			text_offset_ll = list(-text_widt)  -text_xy_offset )
			text_offset_ur = list( 0  (text_height - text_xy_offset) )
		)		

	box_ll = AUTOTXT_Calculate_Offset_xy(text_xy text_offset_ll text_rotation)
	box_ur = AUTOTXT_Calculate_Offset_xy(text_xy text_offset_ur text_rotation)
	if(Offset_rotation == 0.0 || Offset_rotation == 90.0 || Offset_rotation == 180.0 || 
	   Offset_rotation == 270.0 || Offset_rotation == 360.0
		then
		return(list(box_ll box_ur))	
	else	
		(case text_justify
			("LEFT"	
				text_offset_ul = list( 0 (text_height - text_xy_offset) )
				text_offset_lr = list( text_width  0)
				)
			("CENTER"	
				text_offset_ul = list(-(text_width / 2) (text_height - text_xy_offset) )
				text_offset_lr = list( (text_width / 2)  -text_xy_offset)
			)
			("RIGHT"	
				text_offset_ul = list( 0 (text_height - text_xy_offset) )
				text_offset_lr = list( 0 -text_xy_offset )
			)
		)		
		box_ul = AUTOTXT_Calculate_Offset_xy(text_xy text_offset_ul text_rotation)
		box_lr = AUTOTXT_Calculate_Offset_xy(text_xy text_offset_lr text_rotation)	
		return(list(box_ll box_lr box_ur box_ul))	

	)
)
)

/****************************************************/
/*函数名称 : 
/*函数功能 : 
/****************************************************/
procedure( AUTOTXT_Popup(event) 
    let((popup dummy) 
	(dummy = event) 
	(dummy = dummy) 
	(popup = (axlUIPopupDefine nil 
		list(list("Done" 
			'AUTOTXT_Popup_Done
		    ) 
		    list("Oops" 
			'AUTOTXT_Popup_Oops
		    ) 
		    list("Cancel" 
			'AUTOTXT_Popup_Cancel
		    )
		)
	    )) 
	(axlUIPopupSet popup)
    )
)
/****************************************************/
/*函数名称 : 
/*函数功能 : 
/****************************************************/
procedure( AUTOTXT_Popup_Cancel() 
    (axlCancelEnterFun)
)
/****************************************************/
/*函数名称 : 
/*函数功能 : 
/****************************************************/
procedure( AUTOTXT_Popup_Done() 
    (axlFinishEnterFun)
)
/****************************************************/
/*函数名称 : 
/*函数功能 : 
/****************************************************/
procedure( AUTOTXT_Popup_Oops() 
    (axlDBTransactionOops 
	(AUTOTXT_data->mark)
    )
)

/****************************************************/
/*函数名称 : 
/*函数功能 : 
/****************************************************/
procedure( AUTOTXT_UTIL_Get_Short_Units( \@optional arg) 
    let((design_units short_units) 
	if(arg then 
	    (design_units = arg) else 
	    (design_units = lowerCase(car((axlDBGetDesignUnits))))
	) 
	case(design_units 
	    ("microns" 
		(short_units = "UM")
	    ) 
	    ("millimeters" 
		(short_units = "MM")
	    ) 
	    ("centimeters" 
		(short_units = "CM")
	    ) 
	    ("mils" 
		(short_units = "MILS")
	    )
	    ("inches" 
		(short_units = "IN")
	    ) 
	    (t 
		(short_units = design_units)
	    )
	) short_units
    )
)

/****************************************************/
/*函数名称 : ALTIUM2PCB_FormCreate ()
/*函数功能 : 窗口创建
/****************************************************/
defun( AUTOTXT_FormCreate ()
prog( (MainFormFile FormPort ix iy)
	MainFormFile = axlTempFile()
	FormPort = outfile(MainFormFile "w")	
	;窗口本体
	fprintf(FormPort "FILE_TYPE=FORM_DEFN VERSION=2\n")
	fprintf(FormPort "FORM\n")
	fprintf(FormPort "FIXED\n")
	fprintf(FormPort "PORT %d %d\n" 					39 45);定义form的大小
	fprintf(FormPort "HEADER \"%s\"\n" 				"AUTOTXT");标题栏
    fprintf(FormPort "TILE\n\n")

	fprintf(FormPort "POPUP <outline_layer_popup> \"1\" \"1\",\"2\" \"2\".\n")
	fprintf(FormPort "POPUP <label_name_popup> \"Refdes\" \"refdes\",\"Value\" \"value\",\"Part Number\" \"part_number\",\"Device Type\" \"device_type\",\"Tolerance\" \"tolerance\". \n")	
	fprintf(FormPort "POPUP <label_layer_popup> \"1\" \"1\",\"2\" \"2\".\n")
	fprintf(FormPort "POPUP <deg_absolute_popup> \"0\" \"0\",\"90\" \"90\",\"180\" \"180\",\"270\" \"270\".\n")
	fprintf(FormPort "POPUP <deg_horizontal_popup> \"0\" \"0\",\"180\" \"180\".\n")
	fprintf(FormPort "POPUP <deg_vertical_popup> \"90\" \"90\",\"270\" \"270\".\n")

	;标签页tab
	fprintf(FormPort "TABSET \"%s\"\n" 					"tab")
	fprintf(FormPort "OPTIONS tabsetDispatch\n")
	fprintf(FormPort "FLOC %d %d\n"  					1 1);坐标x：y
	fprintf(FormPort "FSIZE %d %d\n"  					38 40);标签页大小

	fprintf(FormPort "TAB \"%s\"\n" 					"\326\367\263\314\320\362");主程序
	
	;GROUP
	fprintf(FormPort "GROUP \"%s\"\n" 					"\262\343\311\350\266\250");层设定
	fprintf(FormPort "FLOC %d %d\n"  					1 0);坐标x：y
	fprintf(FormPort "FSIZE %d %d\n"  					35 11);标签页大小
	fprintf(FormPort "ENDGROUP\n\n")		

	;文本
	fprintf(FormPort "TEXT \"%s\"\n" 					"\316\304\327\326\303\373\263\306");文字名称
	fprintf(FormPort "TLOC %d %d\n"  					3 2)
	fprintf(FormPort "ENDTEXT\n\n")

    ;下拉框
 	fprintf(FormPort "FIELD %s\n" 						"label_name")
	fprintf(FormPort "FLOC %d %d\n"  					16 2);坐标x：y
	fprintf(FormPort "ENUMSET %d\n"  					15);大小
	fprintf(FormPort "POP \"%s\" \n" 					"label_name_popup");大小
	fprintf(FormPort "ENDFIELD\n\n")	

	;文本
	fprintf(FormPort "TEXT \"%s\"\n" 					"\316\304\327\326\300\340\320\315");文字类型
	fprintf(FormPort "TLOC %d %d\n"  					3 5)
	fprintf(FormPort "ENDTEXT\n\n")

    ;下拉框
 	fprintf(FormPort "FIELD %s\n" 						"label_layer")
	fprintf(FormPort "FLOC %d %d\n"  					16 5);坐标x：y
	fprintf(FormPort "ENUMSET %d\n"  					15);大小
	fprintf(FormPort "POP \"%s\" \n" 					"label_layer_popup");大小
	fprintf(FormPort "ENDFIELD\n\n")

	;文本
	fprintf(FormPort "TEXT \"%s\"\n" 					"\306\367\274\376\315\342\277\362");器件外框
	fprintf(FormPort "TLOC %d %d\n"  					3 8)
	fprintf(FormPort "ENDTEXT\n\n")

    ;下拉框
 	fprintf(FormPort "FIELD %s\n" 						"outline_layer")
	fprintf(FormPort "FLOC %d %d\n"  					16 8);坐标x：y
	fprintf(FormPort "ENUMSET %d\n"  					15);大小
	fprintf(FormPort "POP \"%s\" \n" 					"outline_layer_popup");大小
	fprintf(FormPort "ENDFIELD\n\n")

	;GROUP
	fprintf(FormPort "GROUP \"%s\"\n" 					"\317\324\312\276\277\330\326\306");显示控制
	fprintf(FormPort "FLOC %d %d\n"  					1 11);坐标x：y
	fprintf(FormPort "FSIZE %d %d\n"  					35 13);标签页大小
	fprintf(FormPort "ENDGROUP\n\n")	

    ;按键
 	fprintf(FormPort "FIELD %s\n" 						"limit_layers")
	fprintf(FormPort "FLOC %d %d\n"  					2 14);坐标x：y
	fprintf(FormPort "MENUBUTTON \"%s\" %d %d\n" 		"\323\320\320\247\262\343" 12 4);有效层
	fprintf(FormPort "ENDFIELD\n\n")		

    ;勾选框
 	fprintf(FormPort "FIELD %s\n" 						"toggle_top")
	fprintf(FormPort "FLOC %d %d\n"  					29 14);坐标x：y
	fprintf(FormPort "CHECKLIST \"%s\" \n" 				"\266\245\262\343" );大小
	fprintf(FormPort "ENDFIELD\n\n")

    ;勾选框
 	fprintf(FormPort "FIELD %s\n" 						"toggle_bottom")
	fprintf(FormPort "FLOC %d %d\n"  					29 16);坐标x：y
	fprintf(FormPort "CHECKLIST \"%s\" \n" 				"\265\327\262\343")
	fprintf(FormPort "ENDFIELD\n\n")

	ix = 9 iy = 10 

	;文本
	fprintf(FormPort "TEXT \"%s\"\n" 					"pin");
	fprintf(FormPort "TLOC %d %d\n"  					ix + 7 iy + 2)
	fprintf(FormPort "OPTIONS UNDERLINE\n")
	fprintf(FormPort "ENDTEXT\n\n")

    ;COLOR
 	fprintf(FormPort "FIELD %s\n" 						"PIN_TOP")
	fprintf(FormPort "FLOC %d %d\n"  					ix + 7 iy + 4);
	fprintf(FormPort "COLOR %d %d\n"  					2 1)
	fprintf(FormPort "ENDFIELD\n\n")

    ;COLOR
 	fprintf(FormPort "FIELD %s\n" 						"PIN_BOTTOM")
	fprintf(FormPort "FLOC %d %d\n"  					ix + 7 iy + 6);
	fprintf(FormPort "COLOR %d %d\n"  					2 1)
	fprintf(FormPort "ENDFIELD\n\n")
	
	;文本
	fprintf(FormPort "TEXT \"%s\"\n" 					"via");
	fprintf(FormPort "TLOC %d %d\n"  					ix + 10 iy + 2)
	fprintf(FormPort "OPTIONS UNDERLINE\n")
	fprintf(FormPort "ENDTEXT\n\n")

    ;COLOR
 	fprintf(FormPort "FIELD %s\n" 						"VIA_TOP")
	fprintf(FormPort "FLOC %d %d\n"  					ix + 10 iy + 4);
	fprintf(FormPort "COLOR %d %d\n"  					2 1)
	fprintf(FormPort "ENDFIELD\n\n")	

    ;COLOR
 	fprintf(FormPort "FIELD %s\n" 						"VIA_BOTTOM")
	fprintf(FormPort "FLOC %d %d\n"  					ix + 10 iy + 6)
	fprintf(FormPort "COLOR %d %d\n"  					2 1)
	fprintf(FormPort "ENDFIELD\n\n")	

	;文本
	fprintf(FormPort "TEXT \"%s\"\n" 					"silk");
	fprintf(FormPort "TLOC %d %d\n"  					ix + 13 iy + 2)
	fprintf(FormPort "OPTIONS UNDERLINE\n")
	fprintf(FormPort "ENDTEXT\n\n")

    ;COLOR
 	fprintf(FormPort "FIELD %s\n" 						"SILKSCREEN_TOP")
	fprintf(FormPort "FLOC %d %d\n"  					ix + 13 iy + 4);
	fprintf(FormPort "COLOR %d %d\n"  					2 1)
	fprintf(FormPort "ENDFIELD\n\n")	

    ;COLOR
 	fprintf(FormPort "FIELD %s\n" 						"SILKSCREEN_BOTTOM")
	fprintf(FormPort "FLOC %d %d\n"  					ix + 13 iy + 6)
	fprintf(FormPort "COLOR %d %d\n"  					2 1)
	fprintf(FormPort "ENDFIELD\n\n")	

	;文本
	fprintf(FormPort "TEXT \"%s\"\n" 					"asm");
	fprintf(FormPort "TLOC %d %d\n"  					ix + 16 iy + 2)
	fprintf(FormPort "OPTIONS UNDERLINE\n")
	fprintf(FormPort "ENDTEXT\n\n")

    ;COLOR
 	fprintf(FormPort "FIELD %s\n" 						"ASSEMBLY_TOP")
	fprintf(FormPort "FLOC %d %d\n"  					ix + 16 iy + 4);
	fprintf(FormPort "COLOR %d %d\n"  					2 1)
	fprintf(FormPort "ENDFIELD\n\n")	

    ;COLOR
 	fprintf(FormPort "FIELD %s\n" 						"ASSEMBLY_BOTTOM")
	fprintf(FormPort "FLOC %d %d\n"  					ix + 16 iy + 6)
	fprintf(FormPort "COLOR %d %d\n"  					2 1)
	fprintf(FormPort "ENDFIELD\n\n")
	
	;GROUP
	fprintf(FormPort "GROUP \"%s\"\n" 					"\262\331\327\367\304\332\310\335");操作内容
	fprintf(FormPort "FLOC %d %d\n"  					1 24);坐标x：y
	fprintf(FormPort "FSIZE %d %d\n"  					35 13);标签页大小
	fprintf(FormPort "ENDGROUP\n\n")	

    ;勾选框
 	fprintf(FormPort "FIELD %s\n" 						"rotate_text")
	fprintf(FormPort "FLOC %d %d\n"  					2 26);坐标x：y
	fprintf(FormPort "CHECKLIST \"%s\"\n" 				"\320\375\327\252\316\304\327\326");旋转文字
	fprintf(FormPort "ENDFIELD\n\n")	
	
   ;勾选框
 	fprintf(FormPort "FIELD %s\n" 						"center_text")
	fprintf(FormPort "FLOC %d %d\n"  					2 29);坐标x：y
	fprintf(FormPort "CHECKLIST \"%s\"\n" 				"\322\306\266\257\316\304\327\326\265\275\326\320\320\304");移动文字到中心
	fprintf(FormPort "ENDFIELD\n\n")	
	
	;文本
	fprintf(FormPort "TEXT \"%s\"\n" 					"X:");X轴
	fprintf(FormPort "TLOC %d %d\n"  					17 29)
	fprintf(FormPort "ENDTEXT\n\n")

    ;数字输入框
 	fprintf(FormPort "FIELD %s\n" 						"offset_x")
	fprintf(FormPort "FLOC %d %d\n"  					19 29 );坐标x：y
	fprintf(FormPort "REALFILLIN %d %d\n"  				5 10);显示数量，可输入数量
	fprintf(FormPort "DECIMAL %d \n"  					2);精度
	fprintf(FormPort "ENDFIELD\n\n")

	;文本
	fprintf(FormPort "TEXT \"%s\"\n" 					"Y:");Y轴
	fprintf(FormPort "TLOC %d %d\n"  					26 29)
	fprintf(FormPort "ENDTEXT\n\n")

    ;数字输入框
 	fprintf(FormPort "FIELD %s\n" 						"offset_y")
	fprintf(FormPort "FLOC %d %d\n"  					28 29 );坐标x：y
	fprintf(FormPort "REALFILLIN %d %d\n"  				5 10);显示数量，可输入数量
	fprintf(FormPort "DECIMAL %d \n"  					2);精度
	fprintf(FormPort "ENDFIELD\n\n")

   ;勾选框
 	fprintf(FormPort "FIELD %s\n" 						"symedge_text")
	fprintf(FormPort "FLOC %d %d\n"  					2 32);坐标x：y
	fprintf(FormPort "CHECKLIST \"%s\"\n" 				"\322\306\266\257\316\304\327\326\265\275\306\367\274\376\261\337\324\265");移动文字到器件边缘
	fprintf(FormPort "ENDFIELD\n\n")	

	;按键
 	fprintf(FormPort "FIELD %s\n" 						"symedge_info")
	fprintf(FormPort "FLOC %d %d\n"  					21 32);坐标x：y
	fprintf(FormPort "MENUBUTTON \"%s\" %d %d\n" 		"?" 1 3)
	fprintf(FormPort "ENDFIELD\n\n")	
	
   ;勾选框
 	fprintf(FormPort "FIELD %s\n" 						"fit_text")
	fprintf(FormPort "FLOC %d %d\n"  					2 35);坐标x：y
	fprintf(FormPort "CHECKLIST \"%s\"\n" 				"\265\367\325\373\316\304\327\326\264\363\320\241");调整文字大小
	fprintf(FormPort "ENDFIELD\n\n")
	
	;标签-结束
	fprintf(FormPort "ENDTAB\n\n")
	
	;标签-开始
	fprintf(FormPort "TAB \"%s\"\n" 					"\275\370\275\327\311\350\266\250")	;进阶设定

	;GROUP
	fprintf(FormPort "GROUP \"%s\"\n" 					"\316\304\327\326\275\307\266\310");文字角度
	fprintf(FormPort "FLOC %d %d\n"  					1 0);坐标x：y
	fprintf(FormPort "FSIZE %d %d\n"  					36 14);标签页大小
	fprintf(FormPort "ENDGROUP\n\n")
	
   ;勾选框
 	fprintf(FormPort "FIELD %s\n" 						"spin_long_side")
	fprintf(FormPort "FLOC %d %d\n"  					2 2);坐标x：y
	fprintf(FormPort "CHECKLIST \"%s\" \"%s\" \n" 		"\272\341\312\372\305\305\262\274" "rot");横竖排布
	fprintf(FormPort "ENDFIELD\n\n")	

	;文本
	fprintf(FormPort "TEXT \"%s\"\n" 					"\266\245\262\343\313\256\306\275");顶层水平
	fprintf(FormPort "TLOC %d %d\n"  					2 4)
	fprintf(FormPort "ENDTEXT\n\n")	

    ;下拉框
 	fprintf(FormPort "FIELD %s\n" 						"deg_top_horizontal")
	fprintf(FormPort "FLOC %d %d\n"  					9 4);坐标x：y
	fprintf(FormPort "ENUMSET %d\n"  					4);大小
	fprintf(FormPort "POP \"%s\" \n" 					"deg_horizontal_popup");大小
	fprintf(FormPort "ENDFIELD\n\n")	

	;文本
	fprintf(FormPort "TEXT \"%s\"\n" 					"\266\310");度
	fprintf(FormPort "TLOC %d %d\n"  					16 4)
	fprintf(FormPort "ENDTEXT\n\n")

	;文本
	fprintf(FormPort "TEXT \"%s\"\n" 					"\266\245\262\343\264\271\326\261");顶层垂直
	fprintf(FormPort "TLOC %d %d\n"  					20 4)
	fprintf(FormPort "ENDTEXT\n\n")	

    ;下拉框
 	fprintf(FormPort "FIELD %s\n" 						"deg_top_vertical")
	fprintf(FormPort "FLOC %d %d\n"  					27 4);坐标x：y
	fprintf(FormPort "ENUMSET %d\n"  					4);大小
	fprintf(FormPort "POP \"%s\" \n" 					"deg_vertical_popup");大小
	fprintf(FormPort "ENDFIELD\n\n")	

	;文本
	fprintf(FormPort "TEXT \"%s\"\n" 					"\266\310");度
	fprintf(FormPort "TLOC %d %d\n"  					34 4)
	fprintf(FormPort "ENDTEXT\n\n")

	;文本
	fprintf(FormPort "TEXT \"%s\"\n" 					"\265\327\262\343\313\256\306\275");底层水平
	fprintf(FormPort "TLOC %d %d\n"  					2 6)
	fprintf(FormPort "ENDTEXT\n\n")	

    ;下拉框
 	fprintf(FormPort "FIELD %s\n" 						"deg_bottom_horizontal")
	fprintf(FormPort "FLOC %d %d\n"  					9 6);坐标x：y
	fprintf(FormPort "ENUMSET %d\n"  					4);大小
	fprintf(FormPort "POP \"%s\" \n" 					"deg_horizontal_popup");大小
	fprintf(FormPort "ENDFIELD\n\n")	

	;文本
	fprintf(FormPort "TEXT \"%s\"\n" 					"\266\310");度
	fprintf(FormPort "TLOC %d %d\n"  					16 6)
	fprintf(FormPort "ENDTEXT\n\n")

	;文本
	fprintf(FormPort "TEXT \"%s\"\n" 					"\265\327\262\343\264\271\326\261");底层垂直
	fprintf(FormPort "TLOC %d %d\n"  					20 6)
	fprintf(FormPort "ENDTEXT\n\n")	

    ;下拉框
 	fprintf(FormPort "FIELD %s\n" 						"deg_bottom_vertical")
	fprintf(FormPort "FLOC %d %d\n"  					27 6);坐标x：y
	fprintf(FormPort "ENUMSET %d\n"  					4);大小
	fprintf(FormPort "POP \"%s\" \n" 					"deg_vertical_popup");大小
	fprintf(FormPort "ENDFIELD\n\n")	
	
	;文本
	fprintf(FormPort "TEXT \"%s\"\n" 					"\266\310");度
	fprintf(FormPort "TLOC %d %d\n"  					34 6)
	fprintf(FormPort "ENDTEXT\n\n")

   ;勾选框
 	fprintf(FormPort "FIELD %s\n" 						"spin_absolute")
	fprintf(FormPort "FLOC %d %d\n"  					2 9);坐标x：y
	fprintf(FormPort "CHECKLIST \"%s\" \"%s\" \n" 		"\315\263\322\273\275\307\266\310" "rot");统一角度
	fprintf(FormPort "ENDFIELD\n\n")	
	
    ;下拉框
 	fprintf(FormPort "FIELD %s\n" 						"deg_absolute")
	fprintf(FormPort "FLOC %d %d\n"  					12 9);坐标x：y
	fprintf(FormPort "ENUMSET %d\n"  					4);大小
	fprintf(FormPort "POP \"%s\" \n" 					"deg_absolute_popup");大小
	fprintf(FormPort "ENDFIELD\n\n")	
	
	;文本
	fprintf(FormPort "TEXT \"%s\"\n" 					"\266\310");度
	fprintf(FormPort "TLOC %d %d\n"  					19 9)
	fprintf(FormPort "ENDTEXT\n\n")

   ;勾选框
 	fprintf(FormPort "FIELD %s\n" 						"spin_relative")
	fprintf(FormPort "FLOC %d %d\n"  					2 12);坐标x：y
	fprintf(FormPort "CHECKLIST \"%s\" \"%s\" \n" 		"\262\316\325\325\306\367\274\376\275\307\266\310" "rot");参照器件角度
	fprintf(FormPort "ENDFIELD\n\n")	

    ;勾选框
 	fprintf(FormPort "FIELD %s\n" 						"mirror_bottom")
	fprintf(FormPort "FLOC %d %d\n"  					20 12);坐标x：y
	fprintf(FormPort "CHECKLIST \"%s\"\n" 				"\265\327\262\343\316\304\327\326\276\265\317\361");底层文字镜像
	fprintf(FormPort "ENDFIELD\n\n")	
	
	
	;GROUP
	fprintf(FormPort "GROUP \"%s\"\n" 					"\316\304\327\326\316\273\326\303");文字位置
	fprintf(FormPort "FLOC %d %d\n"  					1 14);坐标x：y
	fprintf(FormPort "FSIZE %d %d\n"  					36 8);标签页大小
	fprintf(FormPort "ENDGROUP\n\n")


	
	;文本
	fprintf(FormPort "TEXT \"%s\"\n" 					"\320\243\325\375\306\253\322\306");校正偏移
	fprintf(FormPort "TLOC %d %d\n"  					2 16);坐标x：y
	fprintf(FormPort "ENDTEXT\n\n")

    ;数字输入框
 	fprintf(FormPort "FIELD %s\n" 						"offset_correction")
	fprintf(FormPort "FLOC %d %d\n"  					10 16 );坐标x：y
	fprintf(FormPort "REALFILLIN %d %d\n"  				5 10);显示数量，可输入数量
	fprintf(FormPort "DECIMAL %d \n"  					2);精度
	fprintf(FormPort "MIN %f \n"  						-0.5);最小值
	fprintf(FormPort "MAX %f \n"  						0.5);最大值
	fprintf(FormPort "ENDFIELD\n\n")

	;按键
 	fprintf(FormPort "FIELD %s\n" 						"offset_info")
	fprintf(FormPort "FLOC %d %d\n"  					18 16);坐标x：y
	fprintf(FormPort "MENUBUTTON \"%s\" %d %d\n" 		"?" 1 3)
	fprintf(FormPort "ENDFIELD\n\n")

	;文本
	fprintf(FormPort "TEXT \"%s\"\n" 					"\316\304\327\326\261\337\276\340");文字边距
	fprintf(FormPort "TLOC %d %d\n"  					2 19);坐标x：y
	fprintf(FormPort "ENDTEXT\n\n")		

    ;数字输入框
 	fprintf(FormPort "FIELD %s\n" 						"outline_clearance")
	fprintf(FormPort "FLOC %d %d\n"  					10 19);坐标x：y
	fprintf(FormPort "REALFILLIN %d %d\n"  				5 10);显示数量，可输入数量
	fprintf(FormPort "DECIMAL %d \n"  					3);精度
	fprintf(FormPort "ENDFIELD\n\n")

	;按键
 	fprintf(FormPort "FIELD %s\n" 						"outline_clearance_info")
	fprintf(FormPort "FLOC %d %d\n"  					18 19);坐标x：y
	fprintf(FormPort "MENUBUTTON \"%s\" %d %d\n" 		"?" 1 3)
	fprintf(FormPort "ENDFIELD\n\n")

    ;勾选框
 	fprintf(FormPort "FIELD %s\n" 						"avoid_via")
	fprintf(FormPort "FLOC %d %d\n"  					24 19);坐标x：y
	fprintf(FormPort "CHECKLIST \"%s\"\n" 				"\261\334\310\303\271\375\277\327");避让过孔
	fprintf(FormPort "ENDFIELD\n\n")	
	
	
	
	
	;GROUP
	fprintf(FormPort "GROUP \"%s\"\n" 					"\316\304\327\326\264\363\320\241");文字大小
	fprintf(FormPort "FLOC %d %d\n"  					1 22);坐标x：y
	fprintf(FormPort "FSIZE %d %d\n"  					36 15);标签页大小
	fprintf(FormPort "ENDGROUP\n\n")

   ;勾选框
 	fprintf(FormPort "FIELD %s\n" 						"text_match_minmax_height")
	fprintf(FormPort "FLOC %d %d\n"  					3 24);坐标x：y
	fprintf(FormPort "CHECKLIST \"%s\" \"%s\" \n" 		"\262\316\325\325\306\367\274\376\270\337\266\310\265\367\325\373" "txt_match");参照器件高度调整
	fprintf(FormPort "ENDFIELD\n\n")

	;文本
	fprintf(FormPort "TEXT \"%s\"\n" 					"\327\356\320\241");最小
	fprintf(FormPort "TLOC %d %d\n"  					5 26);坐标x：y
	fprintf(FormPort "ENDTEXT\n\n")

    ;数字输入框
 	fprintf(FormPort "FIELD %s\n" 						"min_height")
	fprintf(FormPort "FLOC %d %d\n"  					10 26 );坐标x：y
	fprintf(FormPort "REALFILLIN %d %d\n"  				5 10);显示数量，可输入数量
	fprintf(FormPort "DECIMAL %d \n"  					2);精度
	fprintf(FormPort "MIN %f \n"  						0.0);最小值
	fprintf(FormPort "ENDFIELD\n\n")

	;文本
	fprintf(FormPort "TEXT \"%s\"\n" 					"\327\356\264\363");最大
	fprintf(FormPort "TLOC %d %d\n"  					20 26);坐标x：y
	fprintf(FormPort "ENDTEXT\n\n")

    ;数字输入框
 	fprintf(FormPort "FIELD %s\n" 						"max_height")
	fprintf(FormPort "FLOC %d %d\n"  					25 26 );坐标x：y
	fprintf(FormPort "REALFILLIN %d %d\n"  				5 10);显示数量，可输入数量
	fprintf(FormPort "DECIMAL %d \n"  					2);精度
	fprintf(FormPort "MIN %f \n"  						0.0);最小值
	fprintf(FormPort "ENDFIELD\n\n")

   ;勾选框
 	fprintf(FormPort "FIELD %s\n" 						"text_match_block_range");指定字号
	fprintf(FormPort "FLOC %d %d\n"  					3 29);坐标x：y
	fprintf(FormPort "CHECKLIST \"%s\" \"%s\" \n" 		"\262\316\325\325\327\326\272\305\265\367\325\373" "txt_match");参照字号调整
	fprintf(FormPort "ENDFIELD\n\n")
	
	;文本
	fprintf(FormPort "TEXT \"%s\"\n" 					"\327\326\272\305")
	fprintf(FormPort "TLOC %d %d\n"  					5 31);坐标x：y
	fprintf(FormPort "ENDTEXT\n\n")	

    ;文本输入框
 	fprintf(FormPort "FIELD %s\n" 						"block_range");字号
	fprintf(FormPort "TLOC %d %d\n"  					10 31);坐标x：y
	fprintf(FormPort "STRFILLIN %d %d\n"  				19 255);显示数量，可输入数量
	fprintf(FormPort "ENDFIELD\n\n")
	
	;按键
 	fprintf(FormPort "FIELD %s\n" 						"user_info")
	fprintf(FormPort "FLOC %d %d\n"  					32 31);坐标x：y
	fprintf(FormPort "MENUBUTTON \"%s\" %d %d\n" 		"?" 1 3)
	fprintf(FormPort "ENDFIELD\n\n")	

	;文本
	fprintf(FormPort "TEXT \"%s\"\n" 					"\315\342\277\362\323\353\316\304\327\326\261\337\324\265\276\340\300\353");外框与文字边缘距离
	fprintf(FormPort "TLOC %d %d\n"  					3 34);坐标x：y
	fprintf(FormPort "ENDTEXT\n\n")	

    ;数字输入框
 	fprintf(FormPort "FIELD %s\n" 						"boundary_clearance")
	fprintf(FormPort "FLOC %d %d\n"  					22 34);坐标x：y
	fprintf(FormPort "REALFILLIN %d %d\n"  				7 10);显示数量，可输入数量
	fprintf(FormPort "DECIMAL %d \n"  					3);精度
	fprintf(FormPort "ENDFIELD\n\n")	

	
	
	;标签-结束
	fprintf(FormPort "ENDTAB\n\n")

	;标签-结束
	fprintf(FormPort "ENDTABSET\n\n")	

	;进度条
 	fprintf(FormPort "FIELD %s\n" 						"update_bar")
	fprintf(FormPort "FLOC %d %d\n"  					1 41)
	fprintf(FormPort "PROGRESS %d %d\n"  				38 1)
    fprintf(FormPort "ENDFIELD\n")  

	;按键
 	fprintf(FormPort "FIELD %s\n" 						"myhelp")
	fprintf(FormPort "FLOC %d %d\n"  					1 42);坐标x：y
	fprintf(FormPort "MENUBUTTON \"%s\" %d %d\n" 		"\260\357\326\372" 8 3);帮助
	fprintf(FormPort "ENDFIELD\n\n")	
	
     ;按键
 	fprintf(FormPort "FIELD %s\n" 						"report")
	fprintf(FormPort "FLOC %d %d\n"  					11 42);坐标x：y
	fprintf(FormPort "MENUBUTTON \"%s\" %d %d\n" 		"\261\250\270\346" 8 3);报告
	fprintf(FormPort "ENDFIELD\n\n")

    ;按键
 	fprintf(FormPort "FIELD %s\n" 						"cancel")
	fprintf(FormPort "FLOC %d %d\n"  					21 42);坐标x：y
	fprintf(FormPort "MENUBUTTON \"%s\" %d %d\n" 		"\263\267\317\372" 8 3);撤销
	fprintf(FormPort "ENDFIELD\n\n")		
	
	;按键
 	fprintf(FormPort "FIELD %s\n" 						"done")
	fprintf(FormPort "FLOC %d %d\n"  					31 42);坐标x：y
	fprintf(FormPort "MENUBUTTON \"%s\" %d %d\n" 		"\315\313\263\366" 8 3);退出
	fprintf(FormPort "ENDFIELD\n\n")	






	
	fprintf(FormPort "ENDTILE\n")
	fprintf(FormPort "ENDFORM\n")
	close(FormPort)
	
	return(MainFormFile)
)	
);end defun


/****************************************************/
/*函数功能 : 显示执行报告
/****************************************************/
procedure( AUTOTXT_Report( \@optional arg) 
let((out_f time report_file)

	report_file	= "auto_txt.log"	
	if(arg 
	then
	
		AUTOTXT_data->report = cons(arg AUTOTXT_data->report)
	else
		(out_f = outfile(report_file)) 
		(time = getCurrentTime()) 
		fprintf(out_f "Text Modify Report:\n")
		fprintf(out_f "\n") 
		fprintf(out_f "%s\n\n" time) 
		foreach(i reverse(AUTOTXT_data->report) 
			fprintf(out_f "%s\n" i) 
		) 

		close(out_f)
	
	    if(isFile(report_file) then 
		(axlUIViewFileCreate report_file "Report" t)

	    )
	)
)
)

/****************************************************/
/*函数功能 :  显示帮助信息,帮助的具体内容看skill的开头
/****************************************************/	
defun( AUTOTXT_Help ()
let((txt_Port)	
	txt_Port = outfile("help.txt")
	fprintf( txt_Port "%s\n" "/****************************************************/")
	fprintf( txt_Port "%s\n" "/*\263\314\320\362\303\373\263\306 :  AUTOTXT")
	fprintf( txt_Port "%s\n" "/*\265\367\323\303\303\374\301\356 :  ")
	fprintf( txt_Port "%s\n" "/*\327\367    \325\337 :  ")
	fprintf( txt_Port "%s\n" "/*\271\246\304\334\313\265\303\367 : \327\324\266\257\265\367\325\373PCB\326\320\265\304TEXT")
	fprintf( txt_Port "%s\n" "/*\270\374\320\302\313\265\303\367 :")
	fprintf( txt_Port "%s\n" "R1.0-20180927")
	fprintf( txt_Port "%s\n" "1\241\242\262\316\277\274Allegro Productivity Toolbox\326\320\265\304 Label Tune\261\340\320\264")
	fprintf( txt_Port "%s\n" "2\241\242\262\316\277\274XYX365\265\304tt_V1.60\261\340\320\264")
	fprintf( txt_Port "%s\n" "3\241\242\275\253from\270\304\316\252\326\320\316\304")
	fprintf( txt_Port "%s\n" "R1.1-20181018")
	fprintf( txt_Port "%s\n" "1\241\242\320\336\325\375\306\344\313\373skill\326\264\320\320\326\320\265\367\323\303\261\276skill\273\341\277\250\313\300\265\304bug")
	fprintf( txt_Port "%s\n" "/****************************************************/")
	fprintf( txt_Port "%s\n" "; \312\271\323\303\267\275\267\250\243\272")
	fprintf( txt_Port "%s\n" "; 1\241\242\315\250\271\375\317\324\312\276\277\330\326\306\262\277\267\326\265\304\262\331\327\367\243\254\307\320\273\273\265\275\261\310\275\317\272\317\312\312\265\304\317\324\312\276\327\264\314\254")
	fprintf( txt_Port "%s\n" "; 2\241\242\270\371\276\335\327\324\274\272\265\304\320\350\322\252\311\350\326\303\272\303\262\331\327\367\304\332\310\335")
	fprintf( txt_Port "%s\n" "; 3\241\242\324\332\275\370\275\327\311\350\266\250\326\320\275\370\322\273\262\275\311\350\326\303\272\303\262\331\327\367\304\332\310\335\265\304\317\340\271\330\262\316\312\375")
	fprintf( txt_Port "%s\n" "; 4\241\242\324\332pcb\311\317\277\362\321\241\273\362\265\343\321\241text\327\326\314\345\300\264\326\264\320\320\327\326\314\345\265\367\325\373\262\331\327\367")
	close( txt_Port )
	axlUIViewFileCreate("help.txt" "\260\357\326\372" t ) 

)
)