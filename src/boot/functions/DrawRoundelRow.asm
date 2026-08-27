.proc DrawRoundelRow

	lda	ZP_SCREEN_DRAW_PIXEL_ROW
	bpl	_topHalf

	eor	#$ff

_topHalf
	sec
	sbc	#16
	asl	a
	tax

	lda	RoundelRowList, x
	sta	ZP_SCREEN_DRAW_INPUT_POINTER
	lda	RoundelRowList + 1, x
	sta	ZP_SCREEN_DRAW_INPUT_POINTER + 1

	lda	#INTRO_SCREEN_BYTE_COLUMNS
	sta	ZP_SCREEN_DRAW_COUNT_REMAINING

	jsr	_checkBlueBar

	ldy	#0
_loopColumnValue
	lda	(ZP_SCREEN_DRAW_INPUT_POINTER), y
	sta	ZP_SCREEN_DRAW_RLE_COUNT_REMAINING

	inc	ZP_SCREEN_DRAW_INPUT_POINTER
	bne	_noWrapInputPointer1
	inc	ZP_SCREEN_DRAW_INPUT_POINTER + 1

_noWrapInputPointer1

_loopColumns
	lda	ZP_SCREEN_DRAW_RLE_BYTE
	sta	(ZP_SCREEN_DRAW_OUTPUT_POINTER), y
	jsr	_checkRedBar

	clc
	lda	ZP_SCREEN_DRAW_OUTPUT_POINTER
	adc	#8
	sta	ZP_SCREEN_DRAW_OUTPUT_POINTER
	lda	ZP_SCREEN_DRAW_OUTPUT_POINTER + 1
	adc	#0
	sta	ZP_SCREEN_DRAW_OUTPUT_POINTER + 1

	dec	ZP_SCREEN_DRAW_COUNT_REMAINING
	beq	_rowDone

	dec	ZP_SCREEN_DRAW_RLE_COUNT_REMAINING
	bne	_loopColumns

	lda	(ZP_SCREEN_DRAW_INPUT_POINTER), y
	sta	ZP_SCREEN_DRAW_RLE_BYTE
	
	jsr	_checkBlueBar

	inc	ZP_SCREEN_DRAW_INPUT_POINTER
	bne	_noWrapInputPointer2
	inc	ZP_SCREEN_DRAW_INPUT_POINTER + 1

_noWrapInputPointer2

	lda	ZP_SCREEN_DRAW_COUNT_REMAINING
	bne	_loopColumnValue

_rowDone
	rts

_checkBlueBar
	bit	ZP_INTRO_SCREEN_DRAW_TYPE
	bmi	_notBlueBar

	lda	ZP_SCREEN_DRAW_PIXEL_ROW
	cmp	#$70
	bcc	_notBlueBar
	cmp	#$90
	bcs	_notBlueBar

	lda	#$0f
	sta	ZP_SCREEN_DRAW_RLE_BYTE

_notBlueBar
	rts

_checkRedBar
	bit	ZP_INTRO_SCREEN_DRAW_TYPE
	bpl	_notRedBar

	lda	ZP_SCREEN_DRAW_PIXEL_ROW
	cmp	#$3c
	bcc	_notRedBar
	cmp	#$c3
	bcs	_notRedBar

	ldx	ZP_SCREEN_DRAW_COUNT_REMAINING
	dex
	txa
	eor	#$3f
	cmp	ZP_RED_BAR_X_START
	bcc	_notRedBar
	beq	_redBarLeft
	cmp	ZP_RED_BAR_X_END
	beq	_redBarRight
	bcs	_notRedBar

	lda	#$ff
	bne	_gotRedBarExtra

_redBarLeft
	ldx	ZP_RED_BAR_X_START_INDEX
	lda	RedBarOverlayLeft, x
	jmp	_gotRedBarExtra

_redBarRight
	ldx	ZP_RED_BAR_X_END_INDEX
	lda	RedBarOverlayRight, x

_gotRedBarExtra
	ora	ZP_SCREEN_DRAW_RLE_BYTE
	sta	(ZP_SCREEN_DRAW_OUTPUT_POINTER), y

_notRedBar	
	rts

.endproc
