.proc TubeHostWriteR4

_loopWaitUntilNotFull
	bit	TUBE_STATUS_REGISTER_4_HOST
	bvc	_loopWaitUntilNotFull
	sta	TUBE_DATA_REGISTER_4_HOST

	rts
	
.endproc
