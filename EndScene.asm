; INCLUDE Irvine32.inc

; main EQU start@0

End_printChoices PROTO, End_score:WORD, outPutHandle:DWORD
action PROTO, outPutHandle:DWORD
dec2str PROTO, scoreDec:WORD
.data
endMsg_1	BYTE "  ____    _    __  __ _____    _____     _______ ____  "	;結束訊息
			BYTE " / ___|  / \  |  \/  | ____|  / _ \ \   / / ____|  _ \ "
			BYTE "| |  _  / _ \ | |\/| |  _|   | | | \ \ / /|  _| | |_) |"
			BYTE "| |_| |/ ___ \| |  | | |___  | |_| |\ V / | |___|  _ < "
			BYTE " \____/_/   \_\_|  |_|_____|  \___/  \_/  |_____|_| \_\"
		
endMsg_2	BYTE "                                                       "
			BYTE "                                                       "
			BYTE "                                                       "
			BYTE "                                                       "
			BYTE "                                                       "

restartMsg BYTE "> Press Enter to restart."		;重新開始選項

exitMsg BYTE "> Press Enter to exit."			;離開選項

; consoleHandle DWORD ?
cellswritten DWORD ?		
xyInit COORD <13, 5> 							;初始位置
xyPosition COORD <13, 5> 						;目前位置
res_xyPosition COORD <?, ?> 					;重新開始選項位置
exit_xyPosition COORD <?, ?> 					;離開選項位置
score_xyPosition COORD <?, ?>					;分數位置
cursor_Pos COORD <?, ?>							;cursor位置
windowBound SMALL_RECT <0,0,80,25>				;視窗大小
time DWORD 0									;經過時間
changeEndMsg DWORD 0							;判斷印哪個結束訊息
scoreMsg BYTE "SCORE: "							;分數訊息
; score_Dec WORD 2559								;分數test(最高分2559分數再高要用DWORD存了，但應該不到那就掛了啦:))
score_Str BYTE 4 DUP(?)
printScoreLen DWORD 5

.code
; main PROC
; 	INVOKE GetstdHandle, STD_OUTPUT_HANDLE		;拿 STD_OUTPUT_HANDLE 存在 consoleHandle
; 	mov consoleHandle, eax

; 	INVOKE SetConsoleWindowInfo,				;設定視窗大小
;     	consoleHandle,
;     	TRUE,
;     	ADDR windowBound

; 	INVOKE End_printChoices, score_Dec 			;印重新開始和離開選項
; 	call WaitMsg
; 	exit
; main ENDP


End_printChoices PROC,
	End_score:WORD,
	outPutHandle:DWORD

	INVOKE dec2str, End_score						;數字轉字串

	add xyPosition.Y, 7								;設定分數要印的位置
	mov ebx, xyPosition
	mov score_xyPosition, ebx
	add score_xyPosition.X, 22

	INVOKE WriteConsoleOutputCharacter, 			;印分數訊息
		outPutHandle,
		ADDR scoreMsg,
		LENGTHOF scoreMsg,
		score_xyPosition,
		ADDR cellswritten

	add score_xyPosition.X, LENGTHOF scoreMsg

	mov ecx, 4
	mov esi, 0
printScore_1:
	push ecx
	.IF [score_Str + esi] == '0'
		inc esi
		dec printScoreLen
	.ENDIF
	.IF [score_Str + esi] != '0'
		jmp printScore_2
	.ENDIF
	pop ecx
	loop printScore_1
printScore_2:	
	INVOKE WriteConsoleOutputCharacter, 			;印分數
		outPutHandle,
		ADDR [score_Str + esi],
		printScoreLen,
		score_xyPosition,
		ADDR cellswritten

	add xyPosition.Y, 2								;設定重新開始選項要印的位置

	mov ebx, xyPosition
	mov res_xyPosition, ebx							;將設定的位置存到重新開始選項位置

	INVOKE WriteConsoleOutputCharacter, 			;印重新開始選項
		outPutHandle,
		ADDR restartMsg,
		LENGTHOF restartMsg,
		res_xyPosition,
		ADDR cellswritten

	mov ebx, res_xyPosition							;將重新開始選項的第一個字存為 cursor 位置
	mov cursor_Pos, ebx

	inc xyPosition.Y								;下一行印離開選項

	mov ebx, xyPosition								;將設定的位置存到離開選項位置
	mov exit_xyPosition, ebx

	INVOKE WriteConsoleOutputCharacter, 			;印離開選項
		outPutHandle,
		ADDR exitMsg,
		LENGTHOF exitMsg,
		exit_xyPosition,
		ADDR cellswritten

	INVOKE action, outPutHandle							;要執行的動作
	ret
End_printChoices ENDP


action PROC USES eax ebx,
	outPutHandle:DWORD
    call GetTickCount								;目前執行時間存到 time 並加 0.45 秒
    mov time, eax
    add time, 450
START:
    call GetTickCount								;目前執行時間(在eax中)
    mov ecx, 5										;要印的行數
    mov esi, 0
    mov edx, xyInit									;要印的位置
    mov xyPosition, edx

    .IF time < eax									;若經超過0.45秒則存新的並加0.45秒
        mov time, eax
        add time, 450
        inc changeEndMsg							;增加 changeEndMsg 來換 EndMsg
        and changeEndMsg, 00000001h
    .ENDIF

    .IF changeEndMsg == 0							;判斷要印哪個 EndMsg
printline_1:
	push ecx

	INVOKE WriteConsoleOutputCharacter, 
		outPutHandle,
		ADDR [endMsg_1 + esi],
		55,
		xyPosition,
		ADDR cellswritten

	add esi, 55
	inc xyPosition.Y
	pop ecx
	loop printline_1
    .ENDIF

    .IF changeEndMsg == 1
printline_2:
	push ecx

	INVOKE WriteConsoleOutputCharacter, 
		outPutHandle,
		ADDR [endMsg_2 + esi],
		55,
		xyPosition,
		ADDR cellswritten

	add esi, 55
	inc xyPosition.Y
	pop ecx
	loop printline_2
    .ENDIF
    
	INVOKE SetConsoleCursorPosition, outPutHandle, cursor_Pos		;設定cursor位置

	mov eax, 100
	call Delay
	call ReadKey									;讀鍵盤輸入
	.IF ax == 4800h 								;UP
		sub cursor_Pos.Y, 1
	.ENDIF
	.IF ax == 5000h 								;DOWN
		add cursor_Pos.Y, 1
	.ENDIF

	mov bx, exit_xyPosition.Y						;超出可選的選項範圍不動
	inc bx
	.IF cursor_Pos.Y == bx
		sub cursor_Pos.Y, 1
	.ENDIF
	mov dx, res_xyPosition.Y
	dec dx
	.IF cursor_Pos.Y == dx
		add cursor_Pos.Y, 1
	.ENDIF
	
	.If ax == 1C0Dh 								;Enter 確認選擇
		mov bx, res_xyPosition.Y
		.If cursor_Pos.Y == bx
			call ClrScr
			jmp Exit_PROC
		.ENDIF
		mov bx, exit_xyPosition.Y
		.If cursor_Pos.Y == bx
			jmp Exit_PROC
		.ENDIF
	.ENDIF

	jmp START
Exit_PROC:
	ret
action ENDP

dec2str PROC,
	scoreDec:WORD
	mov ecx, 4					;WORD型態最高4位數
	mov dl, 10					;除數
	mov ax, scoreDec			;被除數
change:
	push ecx
	div dl
	add ah, '0'					;餘數轉成字存到score_Str
	dec ecx
	mov [score_Str + ecx], ah
	movzx ax, al				;商繼續除
	pop ecx
	loop change
	ret
dec2str ENDP

; END main