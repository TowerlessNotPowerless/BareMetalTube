.proc SetUpIntroScreen

	;	switch to MODE 1
	lda	#VDU_CHANGE_MODE
	jsr	OSWRCH
	lda	#INTRO_SCREEN_MODE
	jsr	OSWRCH

	;	set up NuLA
	RESET_NULA

	ldx	#NulaList_end - NulaList - 1
_loopNula
	lda	NulaList, x
	sta	VIDEO_NULA_PALETTE_REGISTER
	dex
	bpl	_loopNula

	;	set up Beeb's version of the palette
	;	(must be done after NuLA)
	ldx	#PaletteList_end - PaletteList - 1
_loopPalette
	lda	PaletteList, x
	sta	VIDEO_ULA_PALETTE_REGISTER
	dex
	bpl	_loopPalette

	lda	#OSBYTE_WAIT_FOR_VERTICAL_SYNC
	jsr	OSBYTE

	;	set up CRTC the way we want it
	ldx	#CrtcList_end - CrtcList - 2
_loopCrtc
	ldy	CrtcList, x
	lda	CrtcList + 1, x
	jsr	WriteCrtcRegister
	dex
	dex
	bpl	_loopCrtc

	rts

.endproc
