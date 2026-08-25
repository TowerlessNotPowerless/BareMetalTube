PaletteList

	;	this list is read backwards

	;	colour 0 - black
	db	$00 | ($0 ^ 7)
	db	$10 | ($0 ^ 7)
	db	$40 | ($0 ^ 7)
	db	$50 | ($0 ^ 7)
	
	;	colour 1 - blue
	db	$20 | ($4 ^ 7)
	db	$30 | ($4 ^ 7)
	db	$60 | ($4 ^ 7)
	db	$70 | ($4 ^ 7)

	;	colour 2 - white
	db	$80 | ($7 ^ 7)
	db	$90 | ($7 ^ 7)
	db	$c0 | ($7 ^ 7)
	db	$d0 | ($7 ^ 7)

	;	colour 3 - red
	db	$a0 | ($1 ^ 7)
	db	$b0 | ($1 ^ 7)
	db	$e0 | ($1 ^ 7)
	db	$f0 | ($1 ^ 7)

PaletteList_end
