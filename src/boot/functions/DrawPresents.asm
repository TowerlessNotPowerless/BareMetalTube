.proc DrawPresents

	ldx	#TextWindowVdu_end - TextWindowVdu - 1
_loopTextWindowVdu
	lda	TextWindowVdu, x
	jsr	OSWRCH
	dex
	bpl	_loopTextWindowVdu

	rts

.endproc
