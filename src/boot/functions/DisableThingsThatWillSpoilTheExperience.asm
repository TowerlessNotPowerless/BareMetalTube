.proc DisableThingsThatWillSpoilTheExperience

	lda	#1	;	disable Escape, do not clear mem on Break
	;	occasionally ca65 gets confused about the intended size of
	;	operands so we'll specify it explicitly here
	sta	SYSTEM_VARIABLES + OSBYTE_READ_WRITE_BREAK_ESCAPE_EFFECT - OSBYTE_SYSTEM_VARIABLES_BASE

	;	disable cursor editing
	sta	SYSTEM_VARIABLES + OSBYTE_READ_WRITE_CURSOR_EDITING_STATUS - OSBYTE_SYSTEM_VARIABLES_BASE
	
	rts

.endproc
