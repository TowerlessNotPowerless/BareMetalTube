	;	these get moved into place together in page 1 but 
	;	not at $100 to allow space for the filing system
	;	to write error messages there if they occur
HooksSource
ORG_WAS	.set	*
.org	BREAK_INTERCEPT_START_ADDRESS

.include "functions/BreakIntercept.asm"
.include "functions/BrkHandler.asm"
.include "../common/functions/PrintHexNoSaveA.asm"
	;	falls through to PrintHexDigit
.include "../common/functions/PrintHexDigit.asm"

	;	we'll export this so we can use more of page 1 later on
PAGE_01_NEXT_FREE_BYTE
.export PAGE_01_NEXT_FREE_BYTE

.org	ORG_WAS + * - BreakIntercept
HooksSource_end
