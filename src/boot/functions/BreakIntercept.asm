.proc BreakIntercept

	RESET_NULA
	FORCE_COLD_START
	
	;	request another press of Break, this time
	;	with no interception

	;	A will not be $4c here
	sta	OS_BREAK_INTERCEPT

	jmp	(RESETV)

.endproc
