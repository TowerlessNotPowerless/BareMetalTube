.assert (* = TUBE_ENTRY_POINT_GENERAL_PURPOSE), error, "Host Tube handler entry point is not at $406"

.proc Handle406Entry

	;	save the pointer and determine what we've been
	;	asked to do
	stx	ZP_TUBE_CONTROL_BLOCK_POINTER
	sty	ZP_TUBE_CONTROL_BLOCK_POINTER + 1

	;	is it a reason code?
	ora	#0
	bpl	_processReasonCode

	;	no - claim or release then
	bit	ZP_TUBE_CLAIM_ID
	bpl	_canClaim

	cmp	ZP_TUBE_CLAIM_ID
	bne	_alreadyClaimed

_canClaim
	sta	ZP_TUBE_CLAIM_ID
	and	#$40
	bne	_notReleaseTube

	;	to follow exactly what Acorn does here we'll
	;	explicitly send reason code 5 (Reserved) which
	;	actually means "Release" and is sent from host
	;	to parasite
	lda	#TUBE_ACTION_RELEASE_TUBE
	jsr	_processReasonCode

	lda	#0
	sta	ZP_TUBE_CLAIM_ID

_notReleaseTube
	;	set carry to signal claim/release was successful
	sec
	rts

_alreadyClaimed
	clc
	rts

_processReasonCode
	;	send action code
	jsr	TubeHostWriteR4
	tax

	;	send claim ID
	lda	ZP_TUBE_CLAIM_ID
	jsr	TubeHostWriteR4

	cpx	#TUBE_ACTION_RELEASE_TUBE
	beq	_noSendAddress

	;	send the address pointer provided to us
	ldy	#3
_loopCopyControlBlock
	lda	(ZP_TUBE_CONTROL_BLOCK_POINTER), y
	jsr	TubeHostWriteR4
	dey
	bpl	_loopCopyControlBlock

	;	reset control flags
	lda	#TUBE_LATCH_RESET | TUBE_STATUS_REGISTER_1_FLAG_2_BYTE_R3 | TUBE_STATUS_REGISTER_1_FLAG_PARASITE_NMI_R3
	sta	TUBE_STATUS_REGISTER_1_HOST

	;	set control flags
	lda	ReasonCodeControlFlags, x
	sta	TUBE_STATUS_REGISTER_1_HOST

	cpx	#TUBE_ACTION_EXECUTE_IN_PARASITE
	beq	_noEmptyR3
	
	;	depending on the transfer direction
	;	may need to empty R3 first
	txa
	lsr	a
	bcs	_noEmptyR3

	;	read R3 twice to empty it and add a delay
	bit	TUBE_DATA_REGISTER_3_HOST
	bit	TUBE_DATA_REGISTER_3_HOST

_noEmptyR3
	;	sync byte (can be anything)
	jsr	TubeHostWriteR4

	;	need to wait until the parasite has read the sync byte
_loopWaitR4Empty
	bit	TUBE_STATUS_REGISTER_4_HOST
	bvc	_loopWaitR4Empty

_noSendAddress
_noSendSyncByte
	cpx	#TUBE_ACTION_EXECUTE_IN_PARASITE
	bne	_noSendStartByte

	;	send start byte
	lda	#$80

	;	what would happen here in the Acorn implementation is after
	;	the byte is sent we would enter a tight loop listening for
	;	commands for things like OSWRCH, OSWORD and OSBYTE. We're
	;	not doing that deliberately because this allows the host
	;	to continue running the program that called this handler,
	;	so we'll send the byte and simply return.
	;	This will leave both host and parasite running meaningful
	;	programs that we are in full control of.

	jmp	TubeHostWriteR2

_noSendStartByte
	rts

.endproc
