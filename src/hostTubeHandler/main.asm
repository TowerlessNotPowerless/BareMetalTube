.p02

.include "../common/coreDefs.asm"

.zeropage
.org	HOST_TUBE_ZP_ADDRESS_START

.assert (* <= $20), error, "Host Tube handler ZP shouldn't need to be as big as it is"

.code
.org	HOST_TUBE_START_ADDRESS

	nop

HOST_TUBE_HANDLER_NEXT_FREE_BYTE
.export HOST_TUBE_HANDLER_NEXT_FREE_BYTE

.assert (* <= $800), error, "Host Tube handler overruns language memory"
