.proc IncrementPointer16

	inc	0, x
	bne	_done
	inc	1, x

_done
	rts
.endproc
