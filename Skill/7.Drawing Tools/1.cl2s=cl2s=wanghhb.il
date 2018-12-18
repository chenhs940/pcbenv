;============================================================================
; Copyright Tait Electronics Ltd., 2005. All rights reserved.
;
; Program Name: cl2s.il
;
; Author:	Dave Elder, PCB Design Manager,
;		Tait Electronics, Christchurch, New Zealand
;		dave.elder@tait.co.nz
;
; Tested on:	Allegro 15.2
;
; Purpose:	Convert a cline to a shape.
;
; Usage:	To run the routine within Allegro type: "cl2s".
;
; History:
;
;  1.3	21-Mar-05 DE	Release to Allegro Forum
;
;============================================================================

axlCmdRegister("cl2s" 'CL2S_clineToShape ?cmdType "interactive")
defun( CL2S_clineToShape ()
 let((mark, popupAllActive, popupGrayOops, oldSetData, endType, pt, clines, cline, layer, netName, parent, polys, (oopsCount 0))
  mark = axlDBTransactionStart()
  popupAllActive = axlUIPopupDefine(nil '(
    ("Done" "axlDBTransactionCommit(mark), axlFinishEnterFun()")
    ("Oops" "axlDBTransactionOops(mark), when(zerop(--oopsCount), axlUIPopupSet(popupGrayOops))")
    ("Cancel" "axlDBTransactionRollback(mark), axlCancelEnterFun()")
    ("MENU_SEPARATOR", nil)
    ("Toggle End Cap Type"
      "endType = if(endType == 'ROUND, 'SQUARE, 'ROUND), printf(\"Select cline (End Cap Type will be %s)\\n\", endType)"
    )
  ))
  axlUICmdPopupSet(popupAllActive)
  popupGrayOops = axlUIPopupDefine(nil, '(
    ("Done" "axlDBTransactionCommit(mark), axlFinishEnterFun()")
    ("Cancel" "axlDBTransactionRollback(mark), axlCancelEnterFun()")
    ("Toggle End Cap Type"
      "endType = if(endType == 'ROUND, 'SQUARE, 'ROUND), printf(\"Select cline (End Cap Type will be %s)\\n\", endType)"
    )
  ))
  axlUIPopupSet(popupGrayOops)
  endType = 'ROUND
  oldSetData = list(axlGetSelSet(), axlGetFindFilter(nil), axlGetFindFilter(t))
  axlSetFindFilter(?enabled list("noall", "CLINES"), ?onButtons list("noall", "CLINES"))
  while(pt = axlEnterPoint(?prompts sprintf(nil, "Select cline (End Cap Type will be %s)", endType))
    axlClearSelSet()
    while(axlAddSelectPoint(pt), t); necessary to add all objects at point
    clines = axlGetSelSet()
    caseq(length(clines)
      (0, axlUIWPrint(nil, 'error, "No cline Here"))
      (1
	cline = car(clines), layer = cline ->layer, netName = cline ->net ->name, parent = cline ->parent
	polys = axlPolyFromDB(cline ?endCapType endType)
	if(polys then
	  axlDBTransactionMark(mark), axlUIPopupSet(popupAllActive), oopsCount++
	  axlClearSelSet(); Require for Allegro transaction bug that does not clear the find bit (Courtesy fxf).
	  axlDeleteObject(cline)
	  foreach(poly, polys, axlDBCreateShape(poly, t, layer, netName, and(parent ->objTye, parent)))
	 else axlUIWPrint(nil, 'error, "Sorry. Could not convert this cline.")
	)
      )
      (t, axlUIWPrint(nil, 'error, "Multiple clines Here. Pick again"))
    ); caseq
  ); while
  axlSetFindFilter(?enabled cons("noall", cadr(oldSetData)) ?onButtons cons("noall", caddr(oldSetData)))
  axlSingleSelectObject(car(oldSetData))
))