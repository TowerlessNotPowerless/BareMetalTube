HostTubeHandlerTransferValues

	dw	HostTubeHandlerSource
	dw	HOST_TUBE_START_ADDRESS

	;	this provides a counter value that will reach 0 when the
	;	transfer is complete so no explicit ADC or SBC needed -
	;	we can just INC both halves as required and test for 0
	dw	$10000 - (HOST_TUBE_HANDLER_NEXT_FREE_BYTE - HOST_TUBE_START_ADDRESS)

HostTubeHandlerTransferValues_end
