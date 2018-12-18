
 ;RepTP() ²âÊÔµãµþ¼Ó
axlCmdRegister("LD_RepTP" 'LD_RepTP)
defun(LD_RepTP ()
	TPID_S = axlSelectByName("SYMTYPE" "TP*" t)
	TPXY = '()
	TPXY = cons(car(TPID_S)->xy TPXY)
	TPXY = cons(cadr(TPID_S)->xy TPXY)
	;TPDISmin = axlDistance(car(TPXY) cadr(TPXY))	
	TPDisMin_Set = 2.54
	TPDisMin_SetCon = axlMKSConvert(TPDisMin_Set "mm" car(axlDBGetDesignUnits()))
	
	foreach(n cddr(TPID_S)
		for(i 0 length(TPXY)-1
			TPDIS = axlDistance(nth(i TPXY) n->xy)
			if(TPDIS < TPDisMin_SetCon then
				TPDISmin = TPDIS
				TPMinID = nth(i TPID_S)->component->name				
				TPMinID1 = n->component->name
				printf("min distance is %f\n" TPDISmin)
				printf("Error at %s to %s\n" TPMinID TPMinID1)
				;println()		
			)
		)
		TPXY = append1(TPXY n->xy)
	)
	NPTH = axlSelectByName("SYMTYPE" "NPTH*" t)
	foreach(n NPTH
	print(n->xy)
	)
)


