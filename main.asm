INCLUDE Irvine32.inc
INCLUDE inLevel.asm
INCLUDE EndScene.asm
INCLUDE Score.asm
INCLUDE MapChange.asm
INCLUDE PausedScreen.asm
INCLUDE project_StartScene.asm
.data
	windowTitleStr BYTE "Crossy Road",0
	consoleHandle    DWORD ?
	windowBound SMALL_RECT <0,0,80,25>				;視窗大小
	score WORD 0
	changeScene BYTE 0
	levelNow BYTE 0

main EQU start@0
.code
main PROC

	INVOKE GetstdHandle, STD_OUTPUT_HANDLE
	mov consoleHandle, eax
	
	INVOKE SetConsoleTitle, ADDR windowTitleStr

	INVOKE SetConsoleWindowInfo,				;設定視窗大小
     	consoleHandle,
     	TRUE,
     	ADDR windowBound

	INVOKE Print_Start, consoleHandle
	.IF eax == 3
		jmp ExitProgram
	.ENDIF
	
restart:
	mov score, 0
	mov life, 5
	mov levelNow, 0
newLevelStart:
	inc levelNow
	INVOKE MapChange, consoleHandle, levelNow
	call Clrscr
	INVOKE init, consoleHandle
	jmp play
resumeFormPause:
	INVOKE resume, consoleHandle
play:
	INVOKE controlSheep, consoleHandle
	.IF eax == 2
		jmp pause
	.ENDIF
	INVOKE carsRun, consoleHandle
	.IF life == 0
		jmp EndScene
	.ENDIF
	.IF sheepPosition.x == 79
		jmp newLevelStart
	.ENDIF
	jmp play

pause:
	INVOKE PausedScreen, consoleHandle, score
	.IF eax == 1
		jmp resumeFormPause
	.ENDIF
	.IF eax == 3
		jmp EndScene
	.ENDIF

EndScene:
	INVOKE End_printChoices, score, consoleHandle
	.IF changeScene == 1
		mov changeScene, 0
		jmp restart
	.ENDIF
	.IF changeScene == 4
		mov changeScene, 0
		jmp ExitProgram
	.ENDIF
ExitProgram:
	exit
main ENDP

END main
