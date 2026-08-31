.proc PrintHexDigit

	cmp	#10
	bcc	_numeric

	adc	#'A' - 1 - 10
	bne	_print

_numeric
	adc	#'0'

_print
	jmp	OSWRCH
.endproc
