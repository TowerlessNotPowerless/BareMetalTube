.p02

.include "../common/coreDefs.asm"

.zeropage
.org	HOST_TUBE_ZP_ADDRESS_START

.include "zpDefs.asm"

.assert (* <= $20), error, "Host Tube handler ZP shouldn't need to be as big as it is"

.code
.org	HOST_TUBE_START_ADDRESS

	;	Acorn implementations use $400 for:
	;	Copy language across the Tube
	;	we're definitely not interested in that
	rts
	dw	0

	;	Acorn implementations use $403 for:
	;	Copy Escape state across the Tube
	;	we're also not interested in that - we've disabled the
	;	Escape key already by the time this code is in place
	rts
	dw	0

.include "functions/Handle406Entry.asm"

	;	while we're impersonating the Acorn Tube protocol we'll
	;	take no chances on sending the control bytes too fast -
	;	these both wait until their register isn't full before
	;	sending the byte
.include "../common/functions/TubeHostWriteR2.asm"
.include "../common/functions/TubeHostWriteR4.asm"

.include "data/ReasonCodeControlFlags.asm"

HOST_TUBE_HANDLER_NEXT_FREE_BYTE
.export HOST_TUBE_HANDLER_NEXT_FREE_BYTE

.assert (* <= $800), error, "Host Tube handler overruns language memory"
