.proc CheckTubePresence

	;	is there a co-pro?
	lda	#OSBYTE_READ_WRITE_TUBE_PRESENCE_FLAG
	jsr	ReadWriteOsbyte

	txa
	bpl	_noTube

	rts

_noTube
	brk
	db	ERROR_TUBE_NOT_PRESENT
	.asciiz	"No 2nd Processor attached"

.endproc
