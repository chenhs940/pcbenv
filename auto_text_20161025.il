axlCmdRegister("auto_text" 'text_auto_from)
procedure(textprocess() 
    prog(nil 
	(reflist = nil) 
	(symtol = nil) 
	(num_ok = 0) 
	(axlSetFindFilter ?enabled `("NOALL" "text") ?onButtons `("text")	)
	(texts = (axlGetSelSet 
		(axlAddSelectAll)
	    )) 
	(axlClearSelSet) 
	foreach(text texts 
	    if((((text->layer) == "PACKAGE GEOMETRY/SILKSCREEN_TOP") || ((text->layer) == "PACKAGE GEOMETRY/SILKSCREEN_BOTTOM")) then 
		(txt_layer = (text->layer)) 
		(txt_rot = (text->rotation)) 
		(txt_mirr = (text->isMirrored))
		(txt_justify = (text->justify)) 
		(txtname = (text->text)) 
		(txtxy = (text->xy)) 
		(txt_parent = (text->parent)) 
		(txtdb = (make_axlTextOrientation ?textBlock silksize ?rotation txt_rot
			?mirrored txt_mirr ?justify txt_justify
		    ))
		(txt_db = (axlDBCreateText txtname txtxy txtdb txt_layer
			txt_parent
		    )) 
		(axlDeleteObject text)
	    ) 
	    if(((text->layer) == "REF DES/SILKSCREEN_TOP") then 
		(text_layer = (text->layer)) 
		(textname = (text->text)) 
		(sym_rot = ((text->parent)->rotation))
		(sym_xy = ((text->parent)->xy)) 
		(sym_x = (xCoord sym_xy)) 
		(sym_y = (yCoord sym_xy)) 
		(parent_dbid = (text->parent)) 
		(ref = ((text->parent)->refdes))
		if((ref != nil) then 
		    (uref = rexMatchp("^U[0-9]+$" ref)) 
		    (jref = rexMatchp("^J[0-9]+$" ref))
		) 
		(axlDeleteObject text) 
		if(((uref == t) || (jref == t)) then 
		    (rot = 0) 
		    (textxy = (sym_x:(sym_y - tt))) else
		    if((sym_rot == 0) then 
			(rot = 0) 
			(textxy = (sym_x:(sym_y - tt)))
		    ) 
		    if((sym_rot == 90) then 
			(rot = 90) 
			(textxy = ((sym_x + tt):sym_y))
		    ) 
		    if((sym_rot == 180) then 
			(rot = 0) 
			(textxy = (sym_x:(sym_y - tt)))
		    ) 
		    if((sym_rot == 270) then 
			(rot = 90) 
			(textxy = ((sym_x + tt):sym_y))
		    ) 
		    if((sym_rot == 45) then 
			(rot = 45) 
			(textxy = ((sym_x + tta):(sym_y - tta)))
		    )
		    if((sym_rot == 225) then 
			(rot = 45) 
			(textxy = ((sym_x + tta):(sym_y - tta)))
		    ) 
		    if((sym_rot == 135) then 
			(rot = 315) 
			(textxy = ((sym_x - tta):(sym_y - tta)))
		    ) 
		    if((sym_rot == 315) then 
			(rot = 315) 
			(textxy = ((sym_x - tta):(sym_y - tta)))
		    )
		) 
		(textdb = (make_axlTextOrientation ?textBlock silksize ?rotation rot
			?mirrored nil ?justify "center"
		    )) 
		(text_db = (axlDBCreateText textname textxy textdb text_layer
			parent_dbid
		    ))
		(text_dbid = car(car(text_db))) 
		(reflist = cons(text_dbid reflist)) 
		(symtol = cons(parent_dbid symtol))
	    ) 
	    if(((text->layer) == "REF DES/SILKSCREEN_BOTTOM") then 
		(text_layer = (text->layer)) 
		(textname = (text->text)) 
		(sym_rot = ((text->parent)->rotation))
		(sym_xy = ((text->parent)->xy)) 
		(sym_x = (xCoord sym_xy)) 
		(sym_y = (yCoord sym_xy)) 
		(parent_dbid = (text->parent)) 
		(ref = ((text->parent)->refdes))
		if((ref != nil) then 
		    (uref = rexMatchp("^U[0-9]+$" ref)) 
		    (jref = rexMatchp("^J[0-9]+$" ref))
		) 
		(axlDeleteObject text) 
		if(((uref == t) || (jref == t)) then 
		    (rot = 0) 
		    (textxy = (sym_x:(sym_y - tt))) else
		    if((sym_rot == 0) then 
			(rot = 0) 
			(textxy = (sym_x:(sym_y - tt)))
		    ) 
		    if((sym_rot == 90) then 
			(rot = 270) 
			(textxy = ((sym_x - tt):sym_y))
		    ) 
		    if((sym_rot == 180) then 
			(rot = 0) 
			(textxy = (sym_x:(sym_y - tt)))
		    ) 
		    if((sym_rot == 270) then 
			(rot = 270) 
			(textxy = ((sym_x - tt):sym_y))
		    ) 
		    if((sym_rot == 45) then 
			(rot = 45) 
			(textxy = ((sym_x + tta):(sym_y - tta)))
		    )
		    if((sym_rot == 225) then 
			(rot = 45) 
			(textxy = ((sym_x + tta):(sym_y - tta)))
		    ) 
		    if((sym_rot == 135) then 
			(rot = 315) 
			(textxy = ((sym_x - tta):(sym_y - tta)))
		    ) 
		    if((sym_rot == 315) then 
			(rot = 315) 
			(textxy = ((sym_x - tta):(sym_y - tta)))
		    )
		) 
		(textdb = (make_axlTextOrientation ?textBlock silksize ?rotation rot
			?mirrored t ?justify "center"
		    )) 
		(text_db = (axlDBCreateText textname textxy textdb text_layer
			parent_dbid
		    ))
		(text_dbid = car(car(text_db))) 
		(reflist = cons(text_dbid reflist)) 
		(symtol = cons(parent_dbid symtol))
	    )
	) 
	(lix_times = 0) 
	foreach(text reflist 
	    (text_name = (text->text)) 
	    (parent_dbid = (text->parent)) 
	    (sym_xy = ((text->parent)->xy))
	    (sym_x = (xCoord sym_xy)) 
	    (sym_y = (yCoord sym_xy)) 
	    (text_rot = (text->rotation)) 
	    lix_times++ 
	    (tol = float(length(symtol)))
	    (percent = float(lix_times)) 
	    (lix_temp = round(((100 * percent) / tol))) 
	    (axlFormSetField form "update_bar" lix_temp) 
	    if(((text->layer) == "REF DES/SILKSCREEN_TOP") then 
		(axlHighlightObject parent_dbid) 
		(text_bBox = (text->bBox)) 
		(text_b_x = ((xCoord 
			    (yCoord text_bBox)
			) - (xCoord 
			    (xCoord text_bBox)
			)))
		(text_b_y = ((yCoord 
			    (yCoord text_bBox)
			) - (yCoord 
			    (xCoord text_bBox)
			))) 
		foreach(children_db 
		    (parent_dbid->children) 
		    (isShape = (children_db->objType)) 
		    (shape_layer = (children_db->layer)) 
		    if((isShape == "shape") then 
			if((shape_layer == "PACKAGE GEOMETRY/PLACE_BOUND_TOP") then 
			    (sym_bBox = (children_db->bBox)) 
			    if(((xCoord 
					(yCoord text_bBox)
				    ) <= (xCoord 
					(yCoord sym_bBox)
				    )) then 
				(s_r_box = list((((xCoord 
						    (yCoord sym_bBox)
						) + v10):((sym_y - (text_b_y / 2)) + (tt / 2))) 
					(((xCoord 
						    (yCoord sym_bBox)
						) + text_b_x):((sym_y + (text_b_y / 2)) - (tt / 2)))
				    )) else 
				(s_r_box = list((((xCoord 
						    (yCoord text_bBox)
						) + v10):((sym_y - (text_b_y / 2)) + (tt / 2))) 
					(((xCoord 
						    (yCoord sym_bBox)
						) + text_b_x):((sym_y + (text_b_y / 2)) - (tt / 2)))
				    ))
			    ) 
			    if(((xCoord 
					(xCoord text_bBox)
				    ) >= (xCoord 
					(xCoord sym_bBox)
				    )) then 
				(s_l_box = list((((xCoord 
						    (xCoord sym_bBox)
						) - v10):((sym_y - (text_b_y / 2)) + (tt / 2))) 
					(((xCoord 
						    (xCoord sym_bBox)
						) - text_b_x - v5):((sym_y + (text_b_y / 2)) - (tt / 2)))
				    )) else 
				(s_l_box = list((((xCoord 
						    (xCoord text_bBox)
						) - v10):((sym_y - (text_b_y / 2)) + (tt / 2))) 
					(((xCoord 
						    (xCoord sym_bBox)
						) - text_b_x - v5):((sym_y + (text_b_y / 2)) - (tt / 2)))
				    ))
			    )
			    if(((yCoord 
					(yCoord text_bBox)
				    ) <= (yCoord 
					(yCoord sym_bBox)
				    )) then 
				(s_u_box = list((((sym_x - (text_b_x / 2)) + (tt / 2)):((yCoord 
						    (yCoord sym_bBox)
						) + v10)) 
					(((sym_x + (text_b_x / 2)) - (tt / 2)):((yCoord 
						    (yCoord sym_bBox)
						) + text_b_y))
				    )) else 
				(s_u_box = list((((sym_x - (text_b_x / 2)) + (tt / 2)):((yCoord 
						    (yCoord text_bBox)
						) + v10)) 
					(((sym_x + (text_b_x / 2)) - (tt / 2)):((yCoord 
						    (yCoord sym_bBox)
						) + text_b_y))
				    ))
			    ) 
			    if(((yCoord 
					(xCoord text_bBox)
				    ) >= (yCoord 
					(xCoord sym_bBox)
				    )) then 
				(s_d_box = list((((sym_x - (text_b_x / 2)) + (tt / 2)):((yCoord 
						    (xCoord sym_bBox)
						) - v10)) 
					(((sym_x + (text_b_x / 2)) - (tt / 2)):((yCoord 
						    (xCoord sym_bBox)
						) - text_b_y))
				    )) else 
				(s_d_box = list((((sym_x - (text_b_x / 2)) + (tt / 2)):((yCoord 
						    (xCoord text_bBox)
						) - v10)) 
					(((sym_x + (text_b_x / 2)) - (tt / 2)):((yCoord 
						    (xCoord sym_bBox)
						) - text_b_y))
				    ))
			    ) 
			    (axlSetFindFilter ?enabled 
				`("NOALL" "text" "lines" "pins" "shapes") ?onButtons 
				`("text" "lines" "pins" "shapes")
			    ) 
			    (moveok = nil) 
			    if(((text_rot == 0) || (text_rot == 180)) then 
				if(((axlSingleSelectBox s_r_box) == nil) then 
				    (move_x = (((xCoord 
						    (yCoord sym_bBox)
						) - (xCoord 
						    (xCoord text_bBox)
						)) + v7)) 
				    (move_y = (sym_y - ((yCoord 
						    (xCoord text_bBox)
						) + (text_b_y / 2)) - (tt / 4))) 
				    (axlTransformObject text ?move 
					(move_x:move_y)
				    )
				    (moveok = t) 
				    num_ok++ else 
				    if(((axlSingleSelectBox s_l_box) == nil) then 
					(move_x = ((xCoord 
						    (xCoord sym_bBox)
						) - (xCoord 
						    (yCoord text_bBox)
						) - v7)) 
					(move_y = (sym_y - ((yCoord 
							(xCoord text_bBox)
						    ) + (text_b_y / 2)) - (tt / 4))) 
					(axlTransformObject text ?move 
					    (move_x:move_y)
					)
					(moveok = t) 
					num_ok++ else 
					if(((axlSingleSelectBox s_u_box) == nil) then 
					    (move_x = ((sym_x - ((xCoord 
								(xCoord text_bBox)
							    ) + (text_b_x / 2))) + (tt / 4))) 
					    (move_y = ((yCoord 
							(yCoord sym_bBox)
						    ) - (yCoord 
							(xCoord text_bBox)
						    ))) 
					    (axlTransformObject text ?move 
						(move_x:move_y)
					    )
					    (moveok = t) 
					    num_ok++ else 
					    if(((axlSingleSelectBox s_d_box) == nil) then 
						(move_x = ((sym_x - ((xCoord 
								    (xCoord text_bBox)
								) + (text_b_x / 2))) + (tt / 4))) 
						(move_y = ((yCoord 
							    (xCoord sym_bBox)
							) - (yCoord 
							    (yCoord text_bBox)
							) - v12)) 
						(axlTransformObject text ?move 
						    (move_x:move_y)
						)
						(moveok = t) 
						num_ok++
					    )
					)
				    )
				)
			    )
			    if(((text_rot == 90) || (text_rot == 270)) then 
				if(((axlSingleSelectBox s_u_box) == nil) then 
				    (move_x = ((sym_x - ((xCoord 
							(xCoord text_bBox)
						    ) + (text_b_x / 2))) + (tt / 4))) 
				    (move_y = (((yCoord 
						    (yCoord sym_bBox)
						) - (yCoord 
						    (xCoord text_bBox)
						)) + v7)) 
				    (axlTransformObject text ?move 
					(move_x:move_y)
				    )
				    (moveok = t) 
				    num_ok++ else 
				    if(((axlSingleSelectBox s_d_box) == nil) then 
					(move_x = ((sym_x - ((xCoord 
							    (xCoord text_bBox)
							) + (text_b_x / 2))) + (tt / 4))) 
					(move_y = ((yCoord 
						    (xCoord sym_bBox)
						) - (yCoord 
						    (yCoord text_bBox)
						) - v7)) 
					(axlTransformObject text ?move 
					    (move_x:move_y)
					)
					(moveok = t) 
					num_ok++ else 
					if(((axlSingleSelectBox s_r_box) == nil) then 
					    (move_x = (((xCoord 
							    (yCoord sym_bBox)
							) - (xCoord 
							    (xCoord text_bBox)
							)) + v7)) 
					    (move_y = (sym_y - ((yCoord 
							    (xCoord text_bBox)
							) + (text_b_y / 2)) - (tt / 4))) 
					    (axlTransformObject text ?move 
						(move_x:move_y)
					    )
					    (moveok = t) 
					    num_ok++ else 
					    if(((axlSingleSelectBox s_l_box) == nil) then 
						(move_x = ((xCoord 
							    (xCoord sym_bBox)
							) - (xCoord 
							    (yCoord text_bBox)
							) - v7)) 
						(move_y = (sym_y - ((yCoord 
								(xCoord text_bBox)
							    ) + (text_b_y / 2)) - (tt / 4))) 
						(axlTransformObject text ?move 
						    (move_x:move_y)
						)
						(moveok = t) 
						num_ok++
					    )
					)
				    )
				)
			    ) 
			    (axlClearSelSet) 
			    if((moveok == t) then 
				(axlDehighlightObject parent_dbid)
			    )
			)
		    )
		)
	    ) 
	    if(((text->layer) == "REF DES/SILKSCREEN_BOTTOM") then 
		(axlHighlightObject parent_dbid) 
		(text_bBox = (text->bBox)) 
		(text_b_x = ((xCoord 
			    (yCoord text_bBox)
			) - (xCoord 
			    (xCoord text_bBox)
			)))
		(text_b_y = ((yCoord 
			    (yCoord text_bBox)
			) - (yCoord 
			    (xCoord text_bBox)
			))) 
		foreach(children_db 
		    (parent_dbid->children) 
		    (isShape = (children_db->objType)) 
		    (shape_layer = (children_db->layer)) 
		    if((isShape == "shape") then 
			if((shape_layer == "PACKAGE GEOMETRY/PLACE_BOUND_BOTTOM") then 
			    (sym_bBox = (children_db->bBox)) 
			    if(((xCoord 
					(yCoord text_bBox)
				    ) <= (xCoord 
					(yCoord sym_bBox)
				    )) then 
				(s_r_box = list((((xCoord 
						    (yCoord sym_bBox)
						) + v10):((sym_y - (text_b_y / 2)) + (tt / 2))) 
					(((xCoord 
						    (yCoord sym_bBox)
						) + text_b_x):((sym_y + (text_b_y / 2)) - (tt / 2)))
				    )) else 
				(s_r_box = list((((xCoord 
						    (yCoord text_bBox)
						) + v10):((sym_y - (text_b_y / 2)) + (tt / 2))) 
					(((xCoord 
						    (yCoord sym_bBox)
						) + text_b_x):((sym_y + (text_b_y / 2)) - (tt / 2)))
				    ))
			    ) 
			    if(((xCoord 
					(xCoord text_bBox)
				    ) >= (xCoord 
					(xCoord sym_bBox)
				    )) then 
				(s_l_box = list((((xCoord 
						    (xCoord sym_bBox)
						) - v10):((sym_y - (text_b_y / 2)) + (tt / 2))) 
					(((xCoord 
						    (xCoord sym_bBox)
						) - text_b_x):((sym_y + (text_b_y / 2)) - (tt / 2)))
				    )) else 
				(s_l_box = list((((xCoord 
						    (xCoord text_bBox)
						) - v10):((sym_y - (text_b_y / 2)) + (tt / 2))) 
					(((xCoord 
						    (xCoord sym_bBox)
						) - text_b_x):((sym_y + (text_b_y / 2)) - (tt / 2)))
				    ))
			    )
			    if(((yCoord 
					(yCoord text_bBox)
				    ) <= (yCoord 
					(yCoord sym_bBox)
				    )) then 
				(s_u_box = list((((sym_x - (text_b_x / 2)) + (tt / 2)):((yCoord 
						    (yCoord sym_bBox)
						) + v10)) 
					(((sym_x + (text_b_x / 2)) - (tt / 2)):((yCoord 
						    (yCoord sym_bBox)
						) + text_b_y))
				    )) else 
				(s_u_box = list((((sym_x - (text_b_x / 2)) + (tt / 2)):((yCoord 
						    (yCoord text_bBox)
						) + v10)) 
					(((sym_x + (text_b_x / 2)) - (tt / 2)):((yCoord 
						    (yCoord sym_bBox)
						) + text_b_y))
				    ))
			    ) 
			    if(((yCoord 
					(xCoord text_bBox)
				    ) >= (yCoord 
					(xCoord sym_bBox)
				    )) then 
				(s_d_box = list((((sym_x - (text_b_x / 2)) + (tt / 2)):((yCoord 
						    (xCoord sym_bBox)
						) - v10)) 
					(((sym_x + (text_b_x / 2)) - (tt / 2)):((yCoord 
						    (xCoord sym_bBox)
						) - text_b_y))
				    )) else 
				(s_d_box = list((((sym_x - (text_b_x / 2)) + (tt / 2)):((yCoord 
						    (xCoord text_bBox)
						) - v10)) 
					(((sym_x + (text_b_x / 2)) - (tt / 2)):((yCoord 
						    (xCoord sym_bBox)
						) - text_b_y))
				    ))
			    ) 
			    (axlSetFindFilter ?enabled 
				`("NOALL" "text" "lines" "pins" "shapes") ?onButtons 
				`("text" "lines" "pins" "shapes")
			    ) 
			    (moveok = nil) 
			    if(((text_rot == 0) || (text_rot == 180)) then 
				if(((axlSingleSelectBox s_r_box) == nil) then 
				    (move_x = (((xCoord 
						    (yCoord sym_bBox)
						) - (xCoord 
						    (xCoord text_bBox)
						)) + v2)) 
				    (move_y = (sym_y - ((yCoord 
						    (xCoord text_bBox)
						) + (text_b_y / 2)) - (tt / 4))) 
				    (axlTransformObject text ?move 
					(move_x:move_y)
				    )
				    (moveok = t) 
				    num_ok++ else 
				    if(((axlSingleSelectBox s_l_box) == nil) then 
					(move_x = ((xCoord 
						    (xCoord sym_bBox)
						) - (xCoord 
						    (yCoord text_bBox)
						) - v12)) 
					(move_y = (sym_y - ((yCoord 
							(xCoord text_bBox)
						    ) + (text_b_y / 2)) - (tt / 4))) 
					(axlTransformObject text ?move 
					    (move_x:move_y)
					)
					(moveok = t) 
					num_ok++ else 
					if(((axlSingleSelectBox s_u_box) == nil) then 
					    (move_x = (sym_x - ((xCoord 
							    (xCoord text_bBox)
							) + (text_b_x / 2)))) 
					    (move_y = ((yCoord 
							(yCoord sym_bBox)
						    ) - (yCoord 
							(xCoord text_bBox)
						    ))) 
					    (axlTransformObject text ?move 
						(move_x:move_y)
					    )
					    (moveok = t) 
					    num_ok++ else 
					    if(((axlSingleSelectBox s_d_box) == nil) then 
						(move_x = (sym_x - ((xCoord 
								(xCoord text_bBox)
							    ) + (text_b_x / 2)))) 
						(move_y = ((yCoord 
							    (xCoord sym_bBox)
							) - (yCoord 
							    (yCoord text_bBox)
							) - v7)) 
						(axlTransformObject text ?move 
						    (move_x:move_y)
						)
						(moveok = t) 
						num_ok++
					    )
					)
				    )
				)
			    )
			    if(((text_rot == 90) || (text_rot == 270)) then 
				if(((axlSingleSelectBox s_u_box) == nil) then 
				    (move_x = (sym_x - ((xCoord 
						    (xCoord text_bBox)
						) + (text_b_x / 2)) - (tt / 4))) 
				    (move_y = (((yCoord 
						    (yCoord sym_bBox)
						) - (yCoord 
						    (xCoord text_bBox)
						)) + v7)) 
				    (axlTransformObject text ?move 
					(move_x:move_y)
				    )
				    (moveok = t) 
				    num_ok++ else 
				    if(((axlSingleSelectBox s_d_box) == nil) then 
					(move_x = (sym_x - ((xCoord 
							(xCoord text_bBox)
						    ) + (text_b_x / 2)) - (tt / 4))) 
					(move_y = ((yCoord 
						    (xCoord sym_bBox)
						) - (yCoord 
						    (yCoord text_bBox)
						) - v7)) 
					(axlTransformObject text ?move 
					    (move_x:move_y)
					)
					(moveok = t) 
					num_ok++ else 
					if(((axlSingleSelectBox s_r_box) == nil) then 
					    (move_x = ((xCoord 
							(yCoord sym_bBox)
						    ) - (xCoord 
							(xCoord text_bBox)
						    ))) 
					    (move_y = (sym_y - ((yCoord 
							    (xCoord text_bBox)
							) + (text_b_y / 2)) - (tt / 4))) 
					    (axlTransformObject text ?move 
						(move_x:move_y)
					    )
					    (moveok = t) 
					    num_ok++ else 
					    if(((axlSingleSelectBox s_l_box) == nil) then 
						(move_x = ((xCoord 
							    (xCoord sym_bBox)
							) - (xCoord 
							    (yCoord text_bBox)
							) - v12)) 
						(move_y = (sym_y - ((yCoord 
								(xCoord text_bBox)
							    ) + (text_b_y / 2)) - (tt / 4))) 
						(axlTransformObject text ?move 
						    (move_x:move_y)
						)
						(moveok = t) 
						num_ok++
					    )
					)
				    )
				)
			    ) 
			    (axlClearSelSet) 
			    if((moveok == t) then 
				(axlDehighlightObject parent_dbid)
			    )
			)
		    )
		)
	    )
	)
	(tol = length(symtol)) 
	sprintf(silkinfo "%s\262\343\313\277\323\241\327\334\271\262:%d  \263\311\271\246\315\352\263\311\301\313:%d  \316\264\315\352\263\311:%d" silk_layer tol num_ok
	    (tol - num_ok)
	) 
	sprintf(sin_fo "\327\324\266\257\265\367\325\373\302\312\316\252:%0.2f%%" 
	    ((float(num_ok) / float(tol)) * 100)
	) 
	(axlFormSetField form "silk_info" silkinfo) 
	(axlFormSetField form "sinfo" sin_fo)
    )
)
procedure(text_auto_Callback(form) 
    case((form->curField) 
	("silk_size" 
	    (silk_size = (form->curValue)) 
	    sprintf(silksize "%d" silk_size) 
	    (t_block = strcat("paramTextBlock:" silksize)) 
	    (g_Txt_height = ((axlGetParam t_block)->height))
	    (tt = (g_Txt_height / 2)) 
	    (tta = (tt - v5)) t
	) 
	("silk_layer" 
	    (silk_layer = (form->curValue)) 
	    if((silk_layer == "TOP") then 
		(axlVisibleDesign nil) 
		(axlVisibleLayer "BOARD GEOMETRY/OUTLINE" t) 
		(axlVisibleLayer "PIN/TOP" t)
		(axlVisibleLayer "REF DES/SILKSCREEN_TOP" t) 
		(axlVisibleLayer "PACKAGE GEOMETRY/SILKSCREEN_TOP" t) 
		(axlVisibleLayer "BOARD GEOMETRY/SILKSCREEN_TOP" t) 
		(axlVisibleLayer "PIN/SOLDERMASK_TOP" t) 
		(axlVisibleLayer "BOARD GEOMETRY/SOLDERMASK_TOP" t)
		(axlVisibleLayer "PACKAGE GEOMETRY/SOLDERMASK_TOP" t) 
		(axlFlushDisplay) 
		(axlVisibleUpdate t) 
		(axlFormSetField form "silk_info" nil) 
		(axlFormSetField form "sinfo" nil)
	    ) 
	    if((silk_layer == "BOTTOM") then 
		(axlVisibleDesign nil) 
		(axlVisibleLayer "BOARD GEOMETRY/OUTLINE" t) 
		(axlVisibleLayer "PIN/BOTTOM" t)
		(axlVisibleLayer "REF DES/SILKSCREEN_BOTTOM" t) 
		(axlVisibleLayer "PACKAGE GEOMETRY/SILKSCREEN_BOTTOM" t) 
		(axlVisibleLayer "BOARD GEOMETRY/SILKSCREEN_BOTTOM" t) 
		(axlVisibleLayer "PIN/SOLDERMASK_BOTTOM" t) 
		(axlVisibleLayer "BOARD GEOMETRY/SOLDERMASK_BOTTOM" t)
		(axlVisibleLayer "PACKAGE GEOMETRY/SOLDERMASK_BOTTOM" t) 
		(axlFlushDisplay) 
		(axlVisibleUpdate t) 
		(axlFormSetField form "silk_info" nil) 
		(axlFormSetField form "sinfo" nil)
	    ) t
	) 
	("silk_auto_ok" 
	    if((axlUIYesNo "\326\264\320\320\263\314\320\362\272\363\275\253\273\341\312\271PCB\304\332\313\371\323\320\313\277\323\241\316\273\326\303\267\242\311\372\270\304\261\344,\310\267\310\317\312\307\267\361\322\321\276\255\327\366\272\303\261\270\267\335!\n") then 
		(axlFormSetField form "update_bar" nil) 
		(axlFormSetField form "silk_info" nil) 
		(axlFormSetField form "sinfo" nil)
		(axlFormSetFieldVisible form "update_bar" 1) 
		textprocess() 
		(axlFormSetFieldVisible form "update_bar" 0)
	    ) t
	) 
	("aquit" 
	    (axlFormClose form) 
	    (axlCancelEnterFun) 
	    axlShell("done")
	)
    )
)
procedure(text_auto_from() 
    (unit = nthelem(1 
	    (axlDBGetDesignUnits)
	)) 
    if((unit == "mils") then 
	(v5 = 5) 
	(v10 = 10) 
	(v7 = 7)
	(v12 = 12) 
	(v2 = 2)
    ) 
    if((unit == "millimeters") then 
	(v5 = 0.127) 
	(v10 = 0.254) 
	(v7 = 0.1778)
	(v12 = 0.3048) 
	(v2 = 0.0508)
    ) 
    (FORMFILE = outfile("./text_auto.form"))
    fprintf(FORMFILE "FILE_TYPE=FORM_DEFN VERSION=2\n") 
    fprintf(FORMFILE "FORM\n") 
    fprintf(FORMFILE "FIXED\n") 
    fprintf(FORMFILE "PORT 45 30\n") 
    fprintf(FORMFILE "HEADER \"\327\324\266\257\265\367\313\277\323\241  V1.0 \"\n")
    fprintf(FORMFILE "\n") 
    fprintf(FORMFILE "POPUP <silk_layer>") 
    fprintf(FORMFILE "\t\t \t\t\"TOP\" \"TOP\",\t\t \t\t\"BOTTOM\" \"BOTTOM\"\t \t\t.\n") 
    fprintf(FORMFILE "\n") 
    fprintf(FORMFILE "TILE\n")
    fprintf(FORMFILE "GROUP \"\321\241\324\361\313\277\323\241\265\304\262\343\303\346:\"\n") 
    fprintf(FORMFILE "GLOC 5 1\n") 
    fprintf(FORMFILE "GSIZE 22 5\n") 
    fprintf(FORMFILE "ENDGROUP\n") 
    fprintf(FORMFILE "FIELD silk_layer\n")
    fprintf(FORMFILE "FLOC 7 3\n") 
    fprintf(FORMFILE "ENUMSET 16\n") 
    fprintf(FORMFILE "POP \"silk_layer\"\n") 
    fprintf(FORMFILE "ENDFIELD\n") 
    fprintf(FORMFILE "GROUP \"\321\241\324\361\327\326\314\345:\"\n")
    fprintf(FORMFILE "GLOC 30 1\n") 
    fprintf(FORMFILE "GSIZE 8 5\n") 
    fprintf(FORMFILE "ENDGROUP\n") 
    fprintf(FORMFILE "FIELD silk_size\n") 
    fprintf(FORMFILE "FLOC 32 3\n")
    fprintf(FORMFILE "INTSLIDEBAR 2 2\n") 
    fprintf(FORMFILE "MIN 1\n") 
    fprintf(FORMFILE "MAX 50\n") 
    fprintf(FORMFILE "ENDFIELD\n") 
    fprintf(FORMFILE "GROUP \"\320\305\317\242:\"\n")
    fprintf(FORMFILE "GLOC 1 6\n") 
    fprintf(FORMFILE "GSIZE 42 6\n") 
    fprintf(FORMFILE "ENDGROUP\n") 
    fprintf(FORMFILE "TEXT\n") 
    fprintf(FORMFILE "TLOC 3 8\n")
    fprintf(FORMFILE "INFO silk_info 60\n") 
    fprintf(FORMFILE "ENDTEXT\n") 
    fprintf(FORMFILE "TEXT\n") 
    fprintf(FORMFILE "TLOC 15 10\n") 
    fprintf(FORMFILE "INFO sinfo 60\n")
    fprintf(FORMFILE "OPTIONS underline BOLD\n") 
    fprintf(FORMFILE "ENDTEXT\n") 
    fprintf(FORMFILE "FIELD silk_auto_ok\n") 
    fprintf(FORMFILE "FLOC 10 13\n") 
    fprintf(FORMFILE "MENUBUTTON \"\277\252\312\274 \" 10 4\n")
    fprintf(FORMFILE "ENDFIELD\n") 
    fprintf(FORMFILE "FIELD aquit\n") 
    fprintf(FORMFILE "FLOC 30 13\n") 
    fprintf(FORMFILE "MENUBUTTON \"Exit\" 10 4\n") 
    fprintf(FORMFILE "ENDFIELD\n")
    fprintf(FORMFILE "FIELD update_bar\n") 
    fprintf(FORMFILE "FLOC 3 16\n") 
    fprintf(FORMFILE "PROGRESS 40 3\n") 
    fprintf(FORMFILE "ENDFIELD\n") 
    fprintf(FORMFILE "\n")
    fprintf(FORMFILE "ENDTILE\n") 
    fprintf(FORMFILE "\n") 
    fprintf(FORMFILE "ENDFORM\n") 
    close(FORMFILE) 
    (form = (axlFormCreate 
	    gensym() "text_auto.form" 
	    `("E" "OUTER") 
	    `text_auto_Callback
	    t
	))
    axlFormDisplay(form) 
    (silksize = "3") 
    (axlFormSetField form "silk_size" silksize) 
    (axlFormColorize form "sinfo" 
	'text 
	'blue
    ) 
    (axlFormSetFieldVisible form "update_bar" 0)
    (silk_layer = "TOP") 
    (axlFormSetField form "silk_layer" silk_layer) 
    (axlVisibleDesign nil) 
    (axlVisibleLayer "BOARD GEOMETRY/OUTLINE" t) 
    (axlVisibleLayer "PIN/TOP" t)
    (axlVisibleLayer "REF DES/SILKSCREEN_TOP" t) 
    (axlVisibleLayer "PACKAGE GEOMETRY/SILKSCREEN_TOP" t) 
    (axlVisibleLayer "BOARD GEOMETRY/SILKSCREEN_TOP" t) 
    (axlVisibleLayer "PIN/SOLDERMASK_TOP" t) 
    (axlVisibleLayer "BOARD GEOMETRY/SOLDERMASK_TOP" t)
    (axlVisibleLayer "PACKAGE GEOMETRY/SOLDERMASK_TOP" t) 
    (axlFlushDisplay) 
    (axlVisibleUpdate t) 
    (t_block = strcat("paramTextBlock:" silksize)) 
    (g_Txt_height = ((axlGetParam t_block)->height))
    (tt = (g_Txt_height / 2)) 
    (tta = (tt - v5)) 
    printf("In The End\n");
    ;deleteFile("text_auto.form")
)
