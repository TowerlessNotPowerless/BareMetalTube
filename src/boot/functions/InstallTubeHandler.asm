.proc InstallTubeHandler

	;	this condition is likely to be true later on when
	;	we extend the host Tube handler code
.if (::HOST_TUBE_HANDLER_NEXT_FREE_BYTE - ::HOST_TUBE_START_ADDRESS) > $100

	ldx	#HostTubeHandlerTransferValues_end - HostTubeHandlerTransferValues - 1
_loopCopyTransferValues
	lda	HostTubeHandlerTransferValues, x
	sta	ZP_TRANSFER_HOST_TUBE_HANDLER_POINTER_SRC, x
	dex
	bpl	_loopCopyTransferValues

	ldy	#0
_loopCopyTubeHandler
	lda	(ZP_TRANSFER_HOST_TUBE_HANDLER_POINTER_SRC), y
	sta	(ZP_TRANSFER_HOST_TUBE_HANDLER_POINTER_DEST), y

	ldx	#ZP_TRANSFER_HOST_TUBE_HANDLER_POINTER_SRC
	jsr	IncrementPointer16
	ldx	#ZP_TRANSFER_HOST_TUBE_HANDLER_POINTER_DEST
	jsr	IncrementPointer16
	ldx	#ZP_TRANSFER_HOST_TUBE_HANDLER_COUNTER
	jsr	IncrementPointer16
	bne	_loopCopyTubeHandler

.else

	ldx	#HOST_TUBE_HANDLER_NEXT_FREE_BYTE - HOST_TUBE_START_ADDRESS - 1
_loopCopyTubeHandler
	lda	HostTubeHandlerSource, x
	sta	HOST_TUBE_START_ADDRESS, x
	dex
	cpx	#$ff
	bne	_loopCopyTubeHandler

.endif

	lda	#0
	sta	ZP_TUBE_CLAIM_ID
	
	rts

.endproc
