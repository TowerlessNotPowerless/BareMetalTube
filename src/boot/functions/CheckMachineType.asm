.proc CheckMachineType

	;	detect machine type
	lda	#OSBYTE_READ_KEY_WITH_TIME_LIMIT
	;	this routine coincidentally sets X to 0 and Y to $ff
	;	causing it to perform INKEY -256
	jsr	ReadWriteOsbyte

	cpx	#$ff	;	BBC OS 1.00 or OS 1.20
	beq	_maybe

	cpx	#$fe	;	BBC US A1.00 (USA)
	beq	_no	;	the screen is a different resolution

	;	with those two out of the way we can check for all three
	;	of these in one go:
	;	$fd - Master 128 OS 3.20 or 3.50 - physically tested ok
	;	$fc - BBC OS 1.20 (DEU) - physically tested ok
	;	$fb - BBC B+ OS 2.00
	cpx	#$fb
	bcs	_yes

	;	we could probably also allow the Master Compact, Master
	;	Econet Terminal and Electron - maybe later

	;	if it's anything else, refuse to run
_no
	brk
	db	ERROR_MACHINE_TYPE
	.asciiz	"Unable to run on this machine type"

_maybe
	;	check OS version
	lda	#OSBYTE_READ_OS_VERSION_NUMBER
	ldx	#1
	jsr	OSBYTE

	cpx	#1	;	OS 1.20 or OS A1.00
	bne	_no

	;	check memory size - Model A?
	lda	SYSTEM_VARIABLES + OSBYTE_READ_WRITE_AVAILABLE_RAM - OSBYTE_SYSTEM_VARIABLES_BASE
	cmp	#$40
	beq	_no

_yes
	rts

.endproc
