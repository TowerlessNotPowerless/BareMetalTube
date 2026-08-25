.proc WriteCrtcRegister

	sty	CRTC_ADDRESS_REGISTER
	sta	CRTC_VALUE_REGISTER
	rts

.endproc
