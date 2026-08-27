.proc DrawString

	sei

	;	determine the start address of the row
	lsr	a
	lsr	a
	clc
	adc	#INTRO_SCREEN_START_ADDRESS >> 8
	sta	ZP_TEXT_DRAW_OUTPUT_ADDRESS + 1

	stx	ZP_TEXT_DRAW_STRING_ADDRESS
	sty	ZP_TEXT_DRAW_STRING_ADDRESS + 1

	;	measure the string
	lda	#0
	sta	ZP_TEXT_DRAW_LENGTH

	tay
_loopMeasure
	lda	(ZP_TEXT_DRAW_STRING_ADDRESS), y
	bmi	_doneMeasure
	cmp	#' '
	beq	_measureSpace
	tax
	lda	LogoCharacterWidths, x
	bne	_gotCharacterWidth

_measureSpace
	lda	#4 - 1

_gotCharacterWidth
	;	add one automatically
	sec
	adc	ZP_TEXT_DRAW_LENGTH
	sta	ZP_TEXT_DRAW_LENGTH

	iny
	bne	_loopMeasure
	
_doneMeasure
	dec	ZP_TEXT_DRAW_LENGTH

	;	calculate the start X position
	sec
	lda	#0
	sbc	ZP_TEXT_DRAW_LENGTH
	lsr	a
	sta	ZP_TEXT_DRAW_CURRENT_X

	;	add the start position to the screen address
	;	set the appropriate pixel index
	and	#3
	sta	ZP_TEXT_DRAW_PIXEL_INDEX

	;	then multiply it by 8 without the pixel index to get the column
	lda	ZP_TEXT_DRAW_CURRENT_X
	and	#%11111100
	asl	a
	sta	ZP_TEXT_DRAW_OUTPUT_ADDRESS

	;	now ready to draw the text
_loopDrawCharacters
	ldy	#0
	lda	(ZP_TEXT_DRAW_STRING_ADDRESS), y
	bmi	_doneDrawCharacters
	cmp	#' '
	beq	_drawSpace
	tax
	lda	LogoCharacterWidths, x

_gotDrawCharacterWidth
	sta	ZP_TEXT_DRAW_CHARACTER_COLUMNS_REMAINING

	;	get the character definition address
	txa
	asl	a
	tax
	lda	LogoCharacterPointers, x
	sta	ZP_TEXT_DRAW_INPUT_ADDRESS
	lda	LogoCharacterPointers + 1, x
	sta	ZP_TEXT_DRAW_INPUT_ADDRESS + 1

_loopCharacterColumns
	;	get the pixels for the column
	ldy	#0
	lda	(ZP_TEXT_DRAW_INPUT_ADDRESS), y
	sta	ZP_TEXT_DRAW_CURRENT_COLUMN_PIXELS
	iny
	lda	(ZP_TEXT_DRAW_INPUT_ADDRESS), y
	sta	ZP_TEXT_DRAW_CURRENT_COLUMN_PIXELS + 1

	;	draw the column
	jsr	_drawColumnOfPixels

	;	move on to the next character pixel row
	dec	ZP_TEXT_DRAW_CHARACTER_COLUMNS_REMAINING
	beq	_doneCharacter

	jsr	_moveToNextScreenPixel

	clc
	lda	ZP_TEXT_DRAW_INPUT_ADDRESS
	adc	#2
	sta	ZP_TEXT_DRAW_INPUT_ADDRESS
	lda	ZP_TEXT_DRAW_INPUT_ADDRESS + 1
	adc	#0
	sta	ZP_TEXT_DRAW_INPUT_ADDRESS + 1
	bne	_loopCharacterColumns

_doneCharacter
	jsr	_moveToNextScreenPixel
	jsr	_moveToNextScreenPixel

_doNextCharacter
	;	move on to the next character
	inc	ZP_TEXT_DRAW_STRING_ADDRESS
	bne	_loopDrawCharacters
	inc	ZP_TEXT_DRAW_STRING_ADDRESS + 1
	bne	_loopDrawCharacters

_drawSpace
	jsr	_moveToNextScreenColumn
	jmp	_doNextCharacter

_doneDrawCharacters
	cli
_notNextScreenColumn
	rts

_moveToNextScreenPixel
	inc	ZP_TEXT_DRAW_PIXEL_INDEX
	lda	ZP_TEXT_DRAW_PIXEL_INDEX
	and	#3
	sta	ZP_TEXT_DRAW_PIXEL_INDEX
	bne	_notNextScreenColumn

_moveToNextScreenColumn
	clc
	lda	ZP_TEXT_DRAW_OUTPUT_ADDRESS
	adc	#8
	sta	ZP_TEXT_DRAW_OUTPUT_ADDRESS
	lda	ZP_TEXT_DRAW_OUTPUT_ADDRESS + 1
	adc	#0
	sta	ZP_TEXT_DRAW_OUTPUT_ADDRESS + 1
	rts

_drawColumnOfPixels
	ldx	ZP_TEXT_DRAW_PIXEL_INDEX
	lda	DrawTextPixelOr, x
	sta	ZP_TEXT_DRAW_COLUMN_OR_VALUE
	lda	DrawTextPixelAnd, x
	sta	ZP_TEXT_DRAW_COLUMN_AND_VALUE

	lda	ZP_TEXT_DRAW_CURRENT_COLUMN_PIXELS
	jsr	_drawColumnHalf

	;	update the output address downwards
	inc	ZP_TEXT_DRAW_OUTPUT_ADDRESS + 1
	inc	ZP_TEXT_DRAW_OUTPUT_ADDRESS + 1

	lda	ZP_TEXT_DRAW_CURRENT_COLUMN_PIXELS + 1
	jsr	_drawColumnHalf

	;	update the output address upwards (not to the side)
	dec	ZP_TEXT_DRAW_OUTPUT_ADDRESS + 1
	dec	ZP_TEXT_DRAW_OUTPUT_ADDRESS + 1

	rts

_drawColumnHalf
	sta	ZP_TEXT_DRAW_CURRENT_COLUMN_PIXELS
	ldx	#8
	ldy	#0
_loopColumnHalf
	lsr	ZP_TEXT_DRAW_CURRENT_COLUMN_PIXELS
	bcc	_noDrawPixel

	;	draw the pixel
	lda	(ZP_TEXT_DRAW_OUTPUT_ADDRESS), y
	and	ZP_TEXT_DRAW_COLUMN_AND_VALUE
	eor	ZP_TEXT_DRAW_COLUMN_OR_VALUE
	sta	(ZP_TEXT_DRAW_OUTPUT_ADDRESS), y

_noDrawPixel
	iny
	dex
	bne	_loopColumnHalf

	rts

.endproc
