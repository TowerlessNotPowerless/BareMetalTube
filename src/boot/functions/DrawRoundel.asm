.proc DrawRoundel

	bit	ZP_INTRO_SCREEN_DRAW_TYPE
	bpl	_notRedBarReset

	;	set the initial values to use for the red bar
	lda	#$36
	sta	ZP_RED_BAR_X_START
	lda	#$41
	sta	ZP_RED_BAR_X_END
	lda	#3
	sta	ZP_RED_BAR_X_START_INDEX
	lda	#1
	sta	ZP_RED_BAR_X_END_INDEX

_notRedBarReset

	lda	#OSBYTE_WAIT_FOR_VERTICAL_SYNC
	jsr	OSBYTE

	lda	#INTRO_SCREEN_DRAW_ADDRESS & $ff
	sta	ZP_SCREEN_DRAW_OUTPUT_POINTER
	lda	#INTRO_SCREEN_DRAW_ADDRESS >> 8
	sta	ZP_SCREEN_DRAW_OUTPUT_POINTER + 1

	;	don't draw the top two character rows
	lda	#16
	sta	ZP_SCREEN_DRAW_PIXEL_ROW

	lda	#0
	sta	ZP_SCREEN_DRAW_RLE_BYTE

_loopDrawPixelRow
	jsr	DrawRoundelRow

	;	if output pointer is the 7th row, subtract one value
	lda	ZP_SCREEN_DRAW_OUTPUT_POINTER
	and	#7
	cmp	#7
	beq	_seventhRow

	sec
	lda	ZP_SCREEN_DRAW_OUTPUT_POINTER
	sbc	#(INTRO_SCREEN_BYTES_PER_ROW - 1) & $ff
	sta	ZP_SCREEN_DRAW_OUTPUT_POINTER
	lda	ZP_SCREEN_DRAW_OUTPUT_POINTER + 1
	sbc	#(INTRO_SCREEN_BYTES_PER_ROW - 1) >> 8
	sta	ZP_SCREEN_DRAW_OUTPUT_POINTER + 1

	bne	_updatedOutputPointer

_seventhRow
	;	otherwise subtract a different one

	sec
	lda	ZP_SCREEN_DRAW_OUTPUT_POINTER
	sbc	#7
	sta	ZP_SCREEN_DRAW_OUTPUT_POINTER
	lda	ZP_SCREEN_DRAW_OUTPUT_POINTER + 1
	sbc	#0
	sta	ZP_SCREEN_DRAW_OUTPUT_POINTER + 1

_updatedOutputPointer

	ldx	ZP_RED_BAR_X_START_INDEX
	inx
	txa
	and	#3
	sta	ZP_RED_BAR_X_START_INDEX
	bne	_noWrapRedBarLeft

	dec	ZP_RED_BAR_X_START

_noWrapRedBarLeft

	ldx	ZP_RED_BAR_X_END_INDEX
	inx
	txa
	and	#3
	sta	ZP_RED_BAR_X_END_INDEX
	bne	_noWrapRedBarRight

	dec	ZP_RED_BAR_X_END

_noWrapRedBarRight

	inc	ZP_SCREEN_DRAW_PIXEL_ROW
	lda	ZP_SCREEN_DRAW_PIXEL_ROW
	cmp	#($100 - 16)
	bne	_loopDrawPixelRow

	rts

.endproc
