;TITLE Example of ASM              (helloword.ASM)

; This program locates the cursor and displays the
; system time. It uses two Win32 API structures.
; Last update: 6/30/2005

;INCLUDE Irvine32.inc
;INCLUDE EndScene.asm

; Redefine external symbols for convenience
; Redifinition is necessary for using stdcall in .model directive
; using "start" is because for linking to WinDbg.  added by Huang

PausedScreen PROTO,
	consoleH:DWORD,
	score:WORD

End_printChoices PROTO,
    End_score:WORD,
    handle1:DWORD

action PROTO,
    handle2:DWORD

dec2str PROTO,
    scoreDec:WORD

;main          EQU start@0

;Comment @
;Definitions copied from SmallWin.inc:

.data
	continueT BYTE "> Press ENTER to continue", 0
	exitT BYTE "> Press ENTER to exit", 0
	testValue DWORD 123456
	outputHandle DWORD 0
	PauseT 	BYTE " ____   _   _   _ ____  _____ "
            BYTE "|  _ \ / \ | | | / ___|| ____|"
            BYTE "| |_) / _ \| | | \___ \|  _|  "
            BYTE "|  __/ ___ \ |_| |___) | |___ "
            BYTE "|_| /_/   \_\___/|____/|_____|"


.code
;main PROC
;	mov eax, testValue
;	call WriteDec
;	INVOKE Sleep, 1000
;
;	INVOKE GetStdHandle, STD_OUTPUT_HANDLE
;	mov outputHandle, eax
;
;	call ReadChar
;	.IF ax == 011Bh
;		INVOKE PausedScreen, outputHandle
;	.ENDIF
;
;	mov eax, testValue
;	add eax, 10
;	call WriteDec
;	INVOKE Sleep, 2000
;
;	call WaitMsg
;
;	exit
;main ENDP

PausedScreen PROC,
	consoleH:DWORD,
	score:WORD

	LOCAL continueText:PTR BYTE
	LOCAL exitText:PTR BYTE
	LOCAL PauseText:PTR BYTE

	LOCAL count:DWORD
	LOCAL continuePos:COORD
	LOCAL exitPos:COORD
	LOCAL continueLength:DWORD
	LOCAL exitLength:DWORD
	LOCAL PausePos:COORD
	LOCAL cursorPos:COORD

	pushad
	call Clrscr

	mov continueText, OFFSET continueT
	mov exitText, OFFSET exitT
	mov PauseText, OFFSET PauseT

	mov PausePos.x, 24
	mov PausePos.y, 5
	mov continuePos.x, 24
	mov continuePos.y, 12
	mov exitPos.x, 24
	mov exitPos.y, 13
	mov cursorPos.x, 24
	mov cursorPos.y, 12

	mov ecx, 5
Print:
	push ecx
	INVOKE WriteConsoleOutputCharacter, ; 印出 Pause 字樣
		consoleH,
		PauseText,
		30,
		PausePos,
		ADDR count

	mov ebx, 30
	add PauseText, ebx
	add PausePos.y, 1

	pop ecx

	LOOP Print

	INVOKE Str_length, continueText		; 獲取 continue 長度
	mov continueLength, eax

	INVOKE WriteConsoleOutputCharacter,	; 印出 “CONTINUE”
		consoleH,
		continueText,
		continueLength,
		continuePos,
		ADDR count

	INVOKE Str_length, exitText		; 獲取 exitText 長度
	mov exitLength, eax

	INVOKE WriteConsoleOutputCharacter,	; 印出 “EXIT”
		consoleH,
		exitText,
		exitLength,
		exitPos,
		ADDR count

START:
    INVOKE SetConsoleCursorPosition,
		consoleH,
        cursorPos

    call ReadChar
    .IF ax == 4800h         ; up
        sub cursorPos.y, 1
    .ENDIF
    .IF ax == 5000h         ; down
        add cursorPos.y, 1
    .ENDIF

    mov bx, continuePos.y      ; lowerbound
    dec bx
    .IF cursorPos.y == bx
        add cursorPos.y, 1
    .ENDIF
    mov dx, exitPos.y           ; upperbound
    inc dx
    .IF cursorPos.y == dx
        sub cursorPos.y, 1
    .ENDIF

    mov bx, continuePos.y
    mov dx, exitPos.y
    .IF (ax == 1C0Dh) && (cursorPos.y == bx)
        call Clrscr
        popad
        ret
    .ENDIF
    .IF (ax == 1C0Dh) && (cursorPos.y == dx)
        call Clrscr
        INVOKE End_printChoices, score, consoleH
        ret
    .ENDIF

    jmp START


PausedScreen ENDP


;END main
