.proc	PrintHexNoSaveA

	pha
	
	lsr	a
	lsr	a
	lsr	a
	lsr	a
	jsr	PrintHexDigit

	pla
	and	#$f
	;	fall through to PrintHexDigit
.endproc
