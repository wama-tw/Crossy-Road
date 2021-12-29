;INCLUDE Irvine32.inc

;main EQU start@0

Print_Title PROTO
Print_Option PROTO
CHOOSE PROTO

.data
	consoleHandle DWORD ?
	titleStr    BYTE "   ____                           ____                 _ "
                BYTE "  / ___|_ __ ___  ___ ___ _   _  |  _ \ ___   __ _  __| |"
                BYTE " | |   | '__/ _ \/ __/ __| | | | | |_) / _ \ / _` |/ _` |"
                BYTE " | |___| | | (_) \__ \__ \ |_| | |  _ < (_) | (_| | (_| |"
                BYTE "  \____|_|  \___/|___/___/\__, | |_| \_\___/ \__,_|\__,_|"
                BYTE "                          |___/                          "

	xyPos COORD <20,9>

	newgame BYTE "press '->' to start game", 0
	exitmsg BYTE "press '<-' to exit", 0
	cellsWritten DWORD ?

.code
;main PROC

Print_Title PROC USES eax ecx esi

	call ClrScr

	push ecx

	mov eax, 6
	mov esi, 0

PRINT_T:
	INVOKE WriteConsoleOutputCharacter,
		consoleHandle,
		ADDR [titleStr + esi],
		57,
		xyPos,
		ADDR cellswritten

	add esi, 57
	inc xyPos.Y
	pop ecx
	loop PRINT_T

    add xyPos.y, 2
    add xyPos.x, 20
    ret

Print_Title ENDP

Print_Option PROC

    INVOKE WriteConsoleOutputCharacter,
        consoleHandle,
        ADDR newgame,
        SIZEOF newgame,
        xyPos,
        ADDR cellsWritten

    add xyPos.y, 2

    INVOKE WriteConsoleOutputCharacter,
        consoleHandle,
        ADDR exitmsg,
        SIZEOF exitmsg,
        xyPos,
        ADDR cellsWritten
    ret

Print_Option ENDP

;main ENDP

CHOOSE PROC USES eax

    call ReadChar

	.IF ax == 4d00h     ;start game
        ret
    .ENDIF
    .IF ax == 4b00h     ;exit
        exit
    .ENDIF
    ret

CHOOSE ENDP
;END main
