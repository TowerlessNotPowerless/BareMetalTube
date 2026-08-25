.include "../common/coreDefs.asm"

.zeropage
	;	play nice with the OS for now
.org	BOOT_ZP_ADDRESS_START
.include "zpDefs.asm"
.assert (* <= BOOT_ZP_ADDRESS_END), error, "Boot ZP overruns allowed space"

.code
.org	BOOT_START_ADDRESS

	rts

	;	this will be used to check that the next file
	;	in the boot sequence is from the same build
Timestamp
.incbin "../../asm-temp/timestamp.dat"
