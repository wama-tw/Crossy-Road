initScore PROTO, outPutHandle:DWORD
countScore PROTO, sheepPos_X:WORD, roadPos_x:WORD, outPutHandle:DWORD
printScore PROTO, outPutHandle:DWORD
decStr PROTO, scoreDec:WORD
.data
	score_Text BYTE "SCORE: "
	score_initPos COORD <0, 1>
	score_Pos COORD <0, 1>
	printScoreLenth DWORD 4
	tokenswritten DWORD ?
	score_inLevel BYTE 4 DUP(?)
	count DWORD 0
.code

initScore PROC,
	outPutHandle:DWORD
	mov ebx, score_initPos
	mov score_Pos, ebx
	mov score, 0
	INVOKE WriteConsoleOutputCharacter, 
		outPutHandle,
		ADDR score_Text,
		LENGTHOF score_Text,
		score_Pos,
		ADDR tokenswritten
	add score_Pos.x, LENGTHOF score_Text
	ret
initScore ENDP
countScore PROC,
	sheepPos_X:WORD,
	roadPos_x:WORD,
	outPutHandle:DWORD

	mov bx, sheepPos_x
	.IF bx == roadPos_x
		inc score
	.ENDIF
	
	mov dx, score
	INVOKE decStr, dx
	INVOKE printScore, outPutHandle

	ret
countScore ENDP

printScore PROC,
	outPutHandle:DWORD

	INVOKE WriteConsoleOutputCharacter, 			;印分數
		outPutHandle,
		ADDR score_inLevel,
		4,
		score_Pos,
		ADDR tokenswritten
	ret
printScore ENDP

decStr PROC,
	scoreDec:WORD
	mov ecx, 4					;WORD型態最高4位數
	mov dl, 10					;除數
	mov ax, scoreDec			;被除數
change:
	push ecx
	div dl
	add ah, '0'					;餘數轉成字存到score_Str
	dec ecx
	mov [score_inLevel + ecx], ah
	movzx ax, al				;商繼續除
	pop ecx
	loop change
	ret
decStr ENDP