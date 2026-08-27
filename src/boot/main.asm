.include "../common/coreDefs.asm"

.zeropage
	;	play nice with the OS for now
.org	BOOT_ZP_ADDRESS_START
.include "zpDefs.asm"
.assert (* <= BOOT_ZP_ADDRESS_END), error, "Boot ZP overruns allowed space"

.code
.org	BOOT_START_ADDRESS

	;	it's easy to forget the FFFF part of the load and
	;	exec addresses so we'll check which side of the Tube
	;	we're actually running on
	jsr	CheckTubeSide

	;	to ensure we have enough memory and a usable screen size,
	;	prevent ourselves from running on some machine types
	jsr	CheckMachineType

	;	then, of course, we need to check whether we have a
	;	copro attached. We'll check its type later on
	jsr	CheckTubePresence

	;	once those checks have passed, we're ok to continue

	;	turn the screen off and set up the new dimensions
	jsr	SetUpIntroScreen

	;	draw the roundel with a blue horizontal bar
	lda	#INTRO_SCREEN_DRAW_TYPE_BLUE_LINE
	sta	ZP_INTRO_SCREEN_DRAW_TYPE
	jsr	DrawRoundel

	jsr	DrawPresents

	;	draw message on the blue bar
	lda	#$78	;	row
	ldx	#strLogo1 & $ff
	ldy	#strLogo1 >> 8
	jsr	DrawString

	;	turn the screen back on
	lda	#OSBYTE_WAIT_FOR_VERTICAL_SYNC
	jsr	OSBYTE

	ldy	#CRTC_REGISTER_INTERLACE_DELAY_DISABLE
	lda	#CRTC_INTERLACE_DELAY_DISABLE_DISPLAY_ON | CRTC_INTERLACE_DELAY_DISABLE_CURSOR_OFF
	jsr	WriteCrtcRegister

	rts

.include "functions/CheckTubeSide.asm"
.include "functions/CheckMachineType.asm"
.include "functions/CheckTubePresence.asm"
.include "functions/ReadWriteOsbyte.asm"
.include "functions/SetUpIntroScreen.asm"
.include "functions/DrawRoundel.asm"
.include "functions/DrawRoundelRow.asm"
.include "functions/DrawPresents.asm"
.include "functions/DrawString.asm"

.include "../common/functions/WriteCrtcRegister.asm"

.include "data/introScreen/LogoCharacterDefinitions.asm"
.include "data/introScreen/LogoCharacterWidths.asm"
.include "data/introScreen/LogoCharacterPointers.asm"
.include "data/introScreen/LogoStringList.asm"
.include "data/introScreen/CrtcList.asm"
.include "data/introScreen/NulaList.asm"
.include "data/introScreen/PaletteList.asm"
.include "data/introScreen/Roundel.asm"
.include "data/introScreen/RedBarOverlayLeft.asm"
.include "data/introScreen/RedBarOverlayRight.asm"
.include "data/introScreen/TextWindowVdu.asm"
.include "data/introScreen/DrawTextPixelAnd.asm"
.include "data/introScreen/DrawTextPixelOr.asm"

	;	this will be used to check that the next file
	;	in the boot sequence is from the same build
Timestamp
.incbin "../../asm-temp/timestamp.dat"
