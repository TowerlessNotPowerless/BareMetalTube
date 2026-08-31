.proc BrkHandler

	lda	#VDU_CHANGE_MODE
	jsr	OSWRCH
	lda	#7
	jsr	OSWRCH

	tsx
	sec
	lda	$102, x
	sbc	#2
	tay
	lda	$103, x
	sbc	#0
	jsr	PrintHexNoSaveA
	tya
	jsr	PrintHexNoSaveA

	FREEZE
	
.endproc
