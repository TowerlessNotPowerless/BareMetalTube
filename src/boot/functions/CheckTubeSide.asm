.proc CheckTubeSide

	;	if the value at this address changes,
	;	we're running on the host
	lda	SYSTEM_VIA_T1C_L
	cmp	SYSTEM_VIA_T1C_L
	beq	_wrongSideOfTube

	rts

_wrongSideOfTube
	brk
	db	ERROR_TUBE_SIDE
	.asciiz	"Wrong side of Tube"

.endproc
