.proc DrawPresentsText

	ldx	#PresentsText_end - PresentsText - 1
_loopPresentsText
	lda	PresentsText, x
	jsr	OSWRCH
	dex
	bpl	_loopPresentsText

	rts

.endproc
