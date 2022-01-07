mapChange PROTO,
	consoleHandle:DWORD,
	level:BYTE

printNumber PROTO,
    consoleHandle:DWORD,
    level:BYTE

.data
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
    num0T   BYTE "   ___  "
            BYTE "  / _ \ "
            BYTE " | | | |"
            BYTE " | |_| |"
            BYTE "  \___/ "




.code


mapChange PROC,
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
	mov levelTPos.x, 16
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


    INVOKE printNumber,
        consoleHandle,
        levelNum

	INVOKE Sleep, 2000

	popad

	ret
mapChange ENDP

printNumber PROC,
    consoleHandle:DWORD,
    level:BYTE

    LOCAL print_count:DWORD
    LOCAL print_num:PTR BYTE
    LOCAL print_num_2:PTR BYTE
    LOCAL printPos:COORD
    LOCAL printPos_2:COORD

    pushad

    mov printPos.x, 53
    mov printPos.y, 9
    mov printPos_2.x, 61
    mov printPos_2.y, 9

    .IF level >=10
        jmp L
    .ENDIF

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

    jmp L_final

L:
    movzx ax, level
    mov bl, 10
    div bl

    .IF al == 1
        mov print_num, OFFSET num1T
    .ENDIF
    .IF al == 2
        mov print_num, OFFSET num2T
    .ENDIF
    .IF al == 3
        mov print_num, OFFSET num3T
    .ENDIF
    .IF al == 4
        mov print_num, OFFSET num4T
    .ENDIF
    .IF al == 5
        mov print_num, OFFSET num5T
    .ENDIF
    .IF al ==6
        mov print_num, OFFSET num6T
    .ENDIF
    .IF al == 7
        mov print_num, OFFSET num7T
    .ENDIF
    .IF al == 8
        mov print_num, OFFSET num8T
    .ENDIF
    .IF al == 9
        mov print_num, OFFSET num9T
    .ENDIF

    .IF ah == 1
        mov print_num_2, OFFSET num1T
    .ENDIF
    .IF ah == 2
        mov print_num_2, OFFSET num2T
    .ENDIF
    .IF ah == 3
        mov print_num_2, OFFSET num3T
    .ENDIF
    .IF ah == 4
        mov print_num_2, OFFSET num4T
    .ENDIF
    .IF ah == 5
        mov print_num_2, OFFSET num5T
    .ENDIF
    .IF ah ==6
        mov print_num_2, OFFSET num6T
    .ENDIF
    .IF ah == 7
        mov print_num_2, OFFSET num7T
    .ENDIF
    .IF ah == 8
        mov print_num_2, OFFSET num8T
    .ENDIF
    .IF ah == 9
        mov print_num_2, OFFSET num9T
    .ENDIF
    .IF ah == 0
        mov print_num_2, OFFSET num0T
    .ENDIF

    mov ecx, 5
L1:
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

    LOOP L1

    mov ecx, 5
L2:
    push ecx
    INVOKE WriteConsoleOutputCharacter,
        consoleHandle,
        print_num_2,
        8,
        printPos_2,
        ADDR print_count

    mov ebx, 8
    add print_num_2, ebx
    add printPos_2.y, 1

    pop ecx

    LOOP L2

L_final:
    popad

    ret
printNumber ENDP