.proc TubeHostWriteR2

_loopWaitUntilNotFull
	bit	TUBE_STATUS_REGISTER_2_HOST
	bvc	_loopWaitUntilNotFull
	sta	TUBE_DATA_REGISTER_2_HOST

	rts
	
.endproc
