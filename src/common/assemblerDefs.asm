	;	this file is for making the assembler accept the syntax
	;	we want to use

.feature	labels_without_colons
.feature	org_per_seg

.case +

.define	equ	=
.define	db	.byte
.define	dw	.word
.define	dt	.faraddr
.define	dd	.dword

.zeropage
.org 0

.bss
.org 0

.code
.org 0
