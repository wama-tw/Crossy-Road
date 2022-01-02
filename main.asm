INCLUDE Irvine32.inc
INCLUDE inLevel.asm
INCLUDE EndScene.asm
INCLUDE Score.asm
.data
	titleStr BYTE "Crossy Road",0
	consoleHandle    DWORD ?
	windowBound SMALL_RECT <0,0,80,25>				;視窗大小
	score WORD 0
	changeScene BYTE 0

main EQU start@0
.code
main PROC
	call Clrscr

	INVOKE GetstdHandle, STD_OUTPUT_HANDLE
	mov consoleHandle, eax
	
	INVOKE SetConsoleTitle, ADDR titleStr

	INVOKE SetConsoleWindowInfo,				;設定視窗大小
     	consoleHandle,
     	TRUE,
     	ADDR windowBound

restart:
	INVOKE init, consoleHandle

play:
	INVOKE controlSheep, consoleHandle
	INVOKE carsRun, consoleHandle
	.IF life == 0
		jmp EndScene
	.ENDIF
	jmp play

    ; call WaitMsg
EndScene:
	INVOKE End_printChoices, score, consoleHandle
	.IF changeScene == 1
		jmp restart
	.ENDIF
	.IF changeScene == 4
		jmp ExitProgram
	.ENDIF
ExitProgram:
	exit
main ENDP

END main

