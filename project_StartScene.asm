;INCLUDE Irvine32.inc

;main EQU start@0

Print_Start PROTO, consoleHandle:DWORD

.data

	titleStr    BYTE "   ____                           ____                 _ "
                BYTE "  / ___|_ __ ___  ___ ___ _   _  |  _ \ ___   __ _  __| |"
                BYTE " | |   | '__/ _ \/ __/ __| | | | | |_) / _ \ / _` |/ _` |"
                BYTE " | |___| | | (_) \__ \__ \ |_| | |  _ < (_) | (_| | (_| |"
                BYTE "  \____|_|  \___/|___/___/\__, | |_| \_\___/ \__,_|\__,_|"
                BYTE "                          |___/                          "

    GameInstr   BYTE "**************************************************************"
                BYTE "*               Press right arrow key to move.               *"
                BYTE "*                    Press Esc to pause.                     *"
                BYTE "* Be careful not to hit the cars while crossing the streets! *"
                BYTE "*            Press 'Space key' when you are ready!           *"
                BYTE "**************************************************************"

	xyPos COORD <11,7>

	NewGame BYTE "press '->' to start game", 0
	LeaveMsg BYTE "press '<-' to exit", 0
	cells_Written DWORD ?

.code
;main PROC

Print_Start PROC USES ecx esi,
	consoleHandle:DWORD

	LOCAL cursorInfo:CONSOLE_CURSOR_INFO
	mov cursorInfo.dwSize, 100
	mov cursorInfo.bVisible, 0
	INVOKE SetConsoleCursorInfo,
    	consoleHandle,
        ADDR cursorInfo

	call Clrscr

	mov ecx, 6
	mov esi, 0

PRINT_T:
	push ecx
	INVOKE WriteConsoleOutputCharacter,
		consoleHandle,
		ADDR [titleStr + esi],
		57,
		xyPos,
		ADDR cells_Written

	add esi, 57
	inc xyPos.y
	pop ecx
	loop PRINT_T


Print_Option:
    add xyPos.y, 2
    add xyPos.x, 20

    INVOKE WriteConsoleOutputCharacter,
        consoleHandle,
        ADDR NewGame,
        SIZEOF NewGame,
        xyPos,
        ADDR cells_Written

    add xyPos.y, 2

    INVOKE WriteConsoleOutputCharacter,
        consoleHandle,
        ADDR LeaveMsg,
        SIZEOF LeaveMsg,
        xyPos,
        ADDR cells_Written

CHOOSE_OPT:
    call ReadChar

	.IF ax == 4d00h     ;right arrow to start game
        jmp INSTRUCTIONS
    .ENDIF
    .IF ax == 4b00h     ;left arrow to exit
		mov eax, 3
        ret
    .ENDIF

INSTRUCTIONS:
    call Clrscr

	mov ecx, 6
	mov esi, 0
	mov xyPos.x, 9
	mov xyPos.y, 10
PRINT_I:
	push ecx
	INVOKE WriteConsoleOutputCharacter,
		consoleHandle,
		ADDR [GameInstr + esi],
		62,
		xyPos,
		ADDR cells_Written

	add esi, 62
	inc xyPos.y
	pop ecx
	loop PRINT_I
READY:
	call ReadChar
	.IF ax == 3920h
        ret
    .ENDIF
    loop READY

Print_Start ENDP
;END main
