;TITLE Example of ASM              (helloword.ASM)

; This program locates the cursor and displays the
; system time. It uses two Win32 API structures.
; Last update: 6/30/2005

;INCLUDE Irvine32.inc

; Redefine external symbols for convenience
; Redifinition is necessary for using stdcall in .model directive
; using "start" is because for linking to WinDbg.  added by Huang

MapChange PROTO,
	consoleHandle:DWORD,
	level:BYTE

Print_Number PROTO,
    consoleHandle:DWORD,
    level:BYTE

;main          EQU start@0

;Comment @
;Definitions copied from SmallWin.inc:

.data
	testValue DWORD 12345
	outputHandle DWORD 0
	levelT  BYTE " _     _______     _______ _     "
            BYTE "| |   | ____\ \   / / ____| |    "
            BYTE "| |   |  _|  \ \ / /|  _| | |    "
            BYTE "| |___| |___  \ V / | |___| |___ "
            BYTE "|_____|_____|  \_/  |_____|_____|"
    num1T   BYTE "   _    "
            BYTE "  / |   "
            BYTE "  | |   "
            BYTE "  | |   "
            BYTE "  |_|   "
    num2T   BYTE "  ____  "
            BYTE " |___ \ "
            BYTE "   __) |"
            BYTE "  / __/ "
            BYTE " |_____|"
    num3T   BYTE "  _____ "
            BYTE " |___ / "
            BYTE "   |_ \ "
            BYTE "  ___) |"
            BYTE " |____/ "
    num4T   BYTE " _  _   "
            BYTE "| || |  "
            BYTE "| || |_ "
            BYTE "|__   _|"
            BYTE "   |_|  "
    num5T   BYTE "  ____  "
            BYTE " | ___| "
            BYTE " |___ \ "
            BYTE "  ___) |"
            BYTE " |____/ "
    num6T   BYTE "   __   "
            BYTE "  / /_  "
            BYTE " | '_ \ "
            BYTE " | (_) |"
            BYTE "  \___/ "
    num7T   BYTE "  _____ "
            BYTE " |___  |"
            BYTE "    / / "
            BYTE "   / /  "
            BYTE "  /_/   "
    num8T   BYTE "   ___  "
            BYTE "  ( _ ) "
            BYTE "  / _ \ "
            BYTE " | (_) |"
            BYTE "  \___/ "
    num9T   BYTE "   ___  "
            BYTE "  / _ \ "
            BYTE " | (_) |"
            BYTE "  \__, |"
            BYTE "    /_/ "



.code
;main PROC
;	call Clrscr
;
;	INVOKE GetStdHandle, STD_OUTPUT_HANDLE
;	mov outputHandle, eax
;
;	INVOKE MapChange, outputHandle, 1
;
;	call Clrscr
;
;	call WaitMsg
;
;	exit
;main ENDP


MapChange PROC,
	consoleHandle:DWORD,
	levelNum:BYTE

	LOCAL levelText:PTR BYTE
	LOCAL levelLength:DWORD
	LOCAL count:DWORD
	LOCAL levelTPos:COORD
	LOCAL cursorInfo:CONSOLE_CURSOR_INFO

	pushad
	call Clrscr

	mov levelText, OFFSET levelT
	mov levelTPos.x, 18
	mov levelTPos.y, 9
	mov cursorInfo.dwSize, 100
	mov cursorInfo.bVisible, 0

	INVOKE SetConsoleCursorInfo,
        consoleHandle,
        ADDR cursorInfo

	mov ecx, 5
Print_level:
    push ecx
    INVOKE WriteConsoleOutputCharacter,
        consoleHandle,
        levelText,
        33,
        levelTPos,
        ADDR count

    mov ebx, 33
    add levelText, ebx
    add levelTPos.y, 1

    pop ecx

    LOOP Print_level


    INVOKE Print_Number,
        consoleHandle,
        levelNum

	INVOKE Sleep, 2000

	popad

	ret
MapChange ENDP

Print_Number PROC,
    consoleHandle:DWORD,
    level:BYTE

    LOCAL print_count:DWORD
    LOCAL print_num:PTR BYTE
    LOCAL printPos:COORD

    pushad

    mov printPos.x, 53
    mov printPos.y, 9

    .IF level == 1
        mov print_num, OFFSET num1T
    .ENDIF
    .IF level == 2
        mov print_num, OFFSET num2T
    .ENDIF
    .IF level == 3
        mov print_num, OFFSET num3T
    .ENDIF
    .IF level == 4
        mov print_num, OFFSET num4T
    .ENDIF
    .IF level == 5
        mov print_num, OFFSET num5T
    .ENDIF
    .IF level ==6
        mov print_num, OFFSET num6T
    .ENDIF
    .IF level == 7
        mov print_num, OFFSET num7T
    .ENDIF
    .IF level == 8
        mov print_num, OFFSET num8T
    .ENDIF
    .IF level == 9
        mov print_num, OFFSET num9T
    .ENDIF

    mov ecx, 5
START:
    push ecx
    INVOKE WriteConsoleOutputCharacter,
        consoleHandle,
        print_num,
        8,
        printPos,
        ADDR print_count

    mov ebx, 8
    add print_num, ebx
    add printPos.y, 1

    pop ecx

    LOOP START

    ret
Print_Number ENDP

;END main
