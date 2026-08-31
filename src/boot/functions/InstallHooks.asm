.proc InstallHooks

	ldx	#HooksSource_end - HooksSource - 1
_loopHooks
	lda	HooksSource, x
	sta	BREAK_INTERCEPT_START_ADDRESS, x
	dex
	bpl	_loopHooks

	ldx	#3 - 1
_loopBreakInterceptHook
	lda	_breakInterceptHook, x
	sta	OS_BREAK_INTERCEPT, x
	dex
	bpl	_loopBreakInterceptHook

	lda	#BrkHandler & $ff
	sta	BRKV
	lda	#BrkHandler >> 8
	sta	BRKV + 1

	rts

_breakInterceptHook
	jmp	BREAK_INTERCEPT_START_ADDRESS

.endproc
