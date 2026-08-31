.proc CheckTubePresence

	;	is there a co-pro?
	lda	SYSTEM_VARIABLES + OSBYTE_READ_WRITE_TUBE_PRESENCE_FLAG - OSBYTE_SYSTEM_VARIABLES_BASE
	bpl	_noTube

	rts

_noTube
	brk
	db	ERROR_TUBE_NOT_PRESENT
	.asciiz	"No 2nd Processor attached"

.endproc
