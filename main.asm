INCLUDE Irvine32.inc
INCLUDE inLevel.asm

.data
	titleStr BYTE "Crossy Road",0
	consoleHandle    DWORD ?
	windowBound SMALL_RECT <0,0,80,25>				;視窗大小

main EQU start@0
.code
main PROC
	INVOKE GetstdHandle, STD_OUTPUT_HANDLE
	mov consoleHandle, eax
	
	INVOKE SetConsoleTitle, ADDR titleStr

	INVOKE SetConsoleWindowInfo,				;設定視窗大小
     	consoleHandle,
     	TRUE,
     	ADDR windowBound

	INVOKE init, consoleHandle

	play:
		INVOKE controlSheep, consoleHandle
		INVOKE carsRun, consoleHandle
		jmp play

    call WaitMsg
main ENDP

END main
