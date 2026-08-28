.macro FREEZE
.ifpc02
	bra	*
.else
	jmp	*
.endif
.endmacro

.macro RESET_NULA

	lda	#$40
	sta	VIDEO_NULA_CONTROL_REGISTER

.endmacro

.macro SET_SCREEN_MODE_CONSTANTS mode
modeEx	.set	mode & 7
.if (modeEx = 0)
SCREEN_PIXELS_PER_BYTE	.set	8
SCREEN_COLUMNS_PER_ROW	.set	640
.endif
.if (modeEx = 1)
SCREEN_PIXELS_PER_BYTE	.set	4
SCREEN_COLUMNS_PER_ROW	.set	320
.endif
.if (modeEx = 2)
SCREEN_PIXELS_PER_BYTE	.set	2
SCREEN_COLUMNS_PER_ROW	.set	160
.endif
.if (modeEx = 3)
	;	nope - not solid screen layout
.endif
.if (modeEx = 4)
SCREEN_PIXELS_PER_BYTE	.set	4
SCREEN_COLUMNS_PER_ROW	.set	320
.endif
.if (modeEx = 5)
SCREEN_PIXELS_PER_BYTE	.set	2
SCREEN_COLUMNS_PER_ROW	.set	640
.endif
.if (modeEx = 6)
	;	nope - not solid screen layout
.endif
.if (modeEx = 7)
	;	nope - teletext
.endif
.endmacro
