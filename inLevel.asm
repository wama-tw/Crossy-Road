.data
	xyBound COORD <80,25> ; 一個頁面最大的邊界
	roadPosition COORD <20,0>
	roadOneCarPosition COORD <?,?>
	roadTwoCarPosition COORD <?,?>
	roadThreeCarPosition COORD <?,?>
	sheepPosition COORD <5,12>
	roadSide   BYTE 0B3h, 11 DUP(' '), 0B3h
	sheep   BYTE 's'
	car   BYTE 0DAh, 0BFh,
			   0B3h, 0B3h,
			   0C0h, 0D9h
	blank   BYTE 6 DUP(' ')
	road   BYTE 0B3h
	startTimeOne DWORD ?
	startTimeTwo DWORD ?
	startTimeThree DWORD ?
	cellsWritten DWORD 0
	speedOne DWORD ?
	speedTwo DWORD ?
	speedThree DWORD ?
	lifeStr  BYTE 4 DUP(?)
	lifeDisplayPosition COORD <0,0>
	life WORD 50

	controlSheep PROTO,
        outputHandle: DWORD
	checkIfSheepIsByRoad PROTO,
		roadSideX: WORD,
        outputHandle: DWORD
	init PROTO,
        outputHandle: DWORD
	newRoad PROTO,
		thisRoadPosition: COORD,
		roadNum: BYTE,
        outputHandle: DWORD
	carRun PROTO,
		carPosition: COORD,
		roadNum: BYTE,
        outputHandle: DWORD
	carsRun PROTO,
        outputHandle: DWORD
	moveCarOnScreen PROTO,
		startTime: DWORD,
		carPosition: COORD,
		roadNum: BYTE,
		direction: BYTE,
        outputHandle: DWORD
	moveCarPosition PROTO,
		roadNum: BYTE,
		direction: BYTE
	copyCars PROTO,
		carPosition: COORD,
		carNum: WORD,
        outputHandle: DWORD
	clearCars PROTO,
		carPosition: COORD,
		carNum: WORD,
        outputHandle: DWORD
	getRandomNumber PROTO,
		rangeLowerbound: DWORD,
		rangeUpperbound: DWORD
	checkIfSheepIsHitByCar PROTO,
		carPosition: COORD
	changeDisplayLife PROTO,
		outputHandle: DWORD
	decToStr PROTO,
		decNum: WORD

.code

init PROC,
    outputHandle: DWORD
    
	INVOKE newRoad, roadPosition, 1, outputHandle
	INVOKE getRandomNumber, 14, 25
	add roadPosition.x, ax
	INVOKE newRoad, roadPosition, 2, outputHandle
	INVOKE getRandomNumber, 14, 22
	add roadPosition.x, ax
	INVOKE newRoad, roadPosition, 3, outputHandle

	INVOKE getRandomNumber, 50, 300
	mov speedOne, eax
	INVOKE getRandomNumber, 50, 300
	mov speedTwo, eax
	INVOKE getRandomNumber, 50, 300
	mov speedThree, eax

	INVOKE GetTickCount
	mov startTimeOne, eax
	mov eax, speedOne
	add startTimeOne, eax
	
	INVOKE GetTickCount
	mov startTimeTwo, eax
	mov eax, speedTwo
	add startTimeTwo, eax
	
	INVOKE GetTickCount
	mov startTimeThree, eax
	mov eax, speedThree
	add startTimeThree, eax
	
	INVOKE WriteConsoleOutputCharacter,
		outputHandle,   ; console output handle
		ADDR sheep,   ; pointer to the top box line
		1,   ; size of box line
		sheepPosition,   ; coordinates of first char
		ADDR cellsWritten     ; output count

	INVOKE changeDisplayLife, outputHandle

	ret
init ENDP

controlSheep PROC uses eax ebx edx,
    outputHandle: DWORD

	INVOKE Sleep, 10
	call ReadKey
	.IF al == 0
		push sheepPosition.x
		push sheepPosition.y
		
		.IF ah == 48h ;UP
			sub sheepPosition.y, 1
		.ENDIF
		.IF ah == 50h ;DOWN
			add sheepPosition.y, 1
		.ENDIF
		.IF ah == 4Bh ;LEFT
			sub sheepPosition.x, 1
		.ENDIF
		.IF ah == 4Dh ;RIGHT
			add sheepPosition.x, 1
		.ENDIF
		
		; 檢查作完上下左右後有沒有超過限制邊界
		.IF sheepPosition.x == 0h ; x lowerbound
			add sheepPosition.x, 1 ; 超過邊界停留在原位
		.ENDIF
		mov ax,xyBound.x ; 註：比較不能用雙定址，故將其中一個轉成 register
		.IF sheepPosition.x == ax ; x upperbound
			sub sheepPosition.x, 1 ; 超過邊界停留在原位
		.ENDIF
		.IF sheepPosition.y == 0h ; y lowerbound
			add sheepPosition.y, 1 ; 超過邊界停留在原位
		.ENDIF
		mov ax,xyBound.y
		.IF sheepPosition.y == ax ; y upperbound
			sub sheepPosition.y, 1 ; 超過邊界停留在原位
		.ENDIF

		pop bx
		pop dx
		push sheepPosition
		mov sheepPosition.x, dx
		mov sheepPosition.y, bx
		INVOKE WriteConsoleOutputCharacter,
			outputHandle,   ; console output handle
			ADDR blank,   ; pointer to the top box line
			1,   ; size of box line
			sheepPosition,   ; coordinates of first char
			ADDR cellsWritten     ; output count
		INVOKE checkIfSheepIsByRoad, roadOneCarPosition.x, outputHandle
		INVOKE checkIfSheepIsByRoad, roadTwoCarPosition.x, outputHandle
		INVOKE checkIfSheepIsByRoad, roadThreeCarPosition.x, outputHandle

		pop sheepPosition
		INVOKE WriteConsoleOutputCharacter,
			outputHandle,   ; console output handle
			ADDR sheep,   ; pointer to the top box line
			1,   ; size of box line
			sheepPosition,   ; coordinates of first char
			ADDR cellsWritten     ; output count
	.ENDIF

	ret
controlSheep ENDP

checkIfSheepIsByRoad PROC,
	roadSideX: WORD,
    outputHandle: DWORD
	
	mov ax, roadSideX
	sub ax, 6
	.IF sheepPosition.x == ax
		INVOKE WriteConsoleOutputCharacter,
			outputHandle,   ; console output handle
			ADDR road,   ; pointer to the top box line
			1,   ; size of box line
			sheepPosition,   ; coordinates of first char
			ADDR cellsWritten     ; output count
	.ENDIF
	add ax, 12
	.IF sheepPosition.x == ax
		INVOKE WriteConsoleOutputCharacter,
			outputHandle,   ; console output handle
			ADDR road,   ; pointer to the top box line
			1,   ; size of box line
			sheepPosition,   ; coordinates of first char
			ADDR cellsWritten     ; output count
	.ENDIF

	ret
checkIfSheepIsByRoad ENDP

carRun PROC,
	carPosition: COORD,
	roadNum: BYTE,
    outputHandle: DWORD

	.IF roadNum == 1
		INVOKE moveCarOnScreen,
			startTimeOne,
			roadOneCarPosition,
			1, ; road number
			1, ; direction
            outputHandle
	.ENDIF
	.IF roadNum == 2
		INVOKE moveCarOnScreen,
			startTimeTwo,
			roadTwoCarPosition,
			2, ; road number
			2, ; direction
            outputHandle
	.ENDIF
	.IF roadNum == 3
		INVOKE moveCarOnScreen,
			startTimeThree,
			roadThreeCarPosition,
			3, ; road number
			1, ; direction
            outputHandle
	.ENDIF

	ret
carRun ENDP

carsRun PROC,
    outputHandle: DWORD

	INVOKE carRun, roadOneCarPosition, 1, outputHandle
	INVOKE carRun, roadTwoCarPosition, 2, outputHandle
	INVOKE carRun, roadThreeCarPosition, 3, outputHandle

	ret
carsRun ENDP

moveCarOnScreen PROC,
	startTime: DWORD,
	carPosition: COORD,
	roadNum: BYTE,
	direction: BYTE,
    outputHandle: DWORD
	
	INVOKE GetTickCount
	.IF eax > startTime

		push carPosition
		INVOKE clearCars, carPosition, 4, outputHandle
		pop carPosition

		.IF direction == 1 ; going down
			add carPosition.y, 1
		.ENDIF
		.IF direction == 2 ; going up
			.IF carPosition.y == 0
				add carPosition.y, 25
			.ENDIF
			sub carPosition.y, 1
		.ENDIF

		.IF carPosition.y >= 25
			sub carPosition.y, 25
		.ENDIF

		push carPosition
		INVOKE copyCars, carPosition, 4, outputHandle
		pop carPosition
		INVOKE moveCarPosition, roadNum, direction
	.ENDIF

	ret
moveCarOnScreen ENDP

moveCarPosition PROC,
	roadNum: BYTE,
	direction: BYTE

	.IF roadNum == 1
		mov eax, speedOne
		add startTimeOne, eax
		.IF direction == 1 ; going down
			add roadOneCarPosition.y, 1
		.ENDIF
		.IF direction == 2 ; going up
			.IF roadOneCarPosition.y == 0
				add roadOneCarPosition.y, 25
			.ENDIF
			sub roadOneCarPosition.y, 1
		.ENDIF
		
		.IF roadOneCarPosition.y >= 25
			sub roadOneCarPosition.y, 25
		.ENDIF
	.ENDIF
	.IF roadNum == 2
		mov eax, speedTwo
		add startTimeTwo, eax
		.IF direction == 1 ; going down
			add roadTwoCarPosition.y, 1
		.ENDIF
		.IF direction == 2 ; going up
			.IF roadTwoCarPosition.y == 0
				add roadTwoCarPosition.y, 25
			.ENDIF
			sub roadTwoCarPosition.y, 1
		.ENDIF

		.IF roadTwoCarPosition.y >= 25
			sub roadTwoCarPosition.y, 25
		.ENDIF
	.ENDIF
	.IF roadNum == 3
		mov eax, speedThree
		add startTimeThree, eax
		.IF direction == 1 ; going down
			add roadThreeCarPosition.y, 1
		.ENDIF
		.IF direction == 2 ; going up
			.IF roadThreeCarPosition.y == 0
				add roadThreeCarPosition.y, 25
			.ENDIF
			sub roadThreeCarPosition.y, 1
		.ENDIF
		
		.IF roadThreeCarPosition.y >= 25
			sub roadThreeCarPosition.y, 25
		.ENDIF
	.ENDIF

	ret
moveCarPosition ENDP

copyCars PROC,
	carPosition: COORD,
	carNum: WORD,
    outputHandle: DWORD

	movzx ecx, carNum
	copy:
		push ecx
		add carPosition.y, 3
		mov ecx, 3
		mov esi, 0
		printWholeCar:
			push ecx
			.IF carPosition.y >= 25
				sub carPosition.y, 25
			.ENDIF
			INVOKE WriteConsoleOutputCharacter,
				outputHandle,   ; console output handle
				ADDR [car + esi],
				2,
				carPosition,   ; coordinates of first char
				ADDR cellsWritten     ; output count
			INVOKE checkIfSheepIsHitByCar, carPosition
			.IF eax == 1
				sub life, 1
				INVOKE changeDisplayLife, outputHandle
			.ENDIF
			inc carPosition.y
			add esi, 2
			pop ecx
		loop printWholeCar
		pop ecx
	loop copy

	ret
copyCars ENDP

clearCars PROC,
	carPosition: COORD,
	carNum: WORD,
    outputHandle: DWORD

	movzx ecx, carNum
	clear:
		push ecx
		add carPosition.y, 3
		mov ecx, 3
		mov esi, 0
		printWholeCar:
			push ecx
			.IF carPosition.y >= 25
				sub carPosition.y, 25
			.ENDIF
			INVOKE WriteConsoleOutputCharacter,
				outputHandle,   ; console output handle
				ADDR [blank + esi],
				2,
				carPosition,   ; coordinates of first char
				ADDR cellsWritten     ; output count
			inc carPosition.y
			add esi, 2
			pop ecx
		loop printWholeCar
		pop ecx
	loop clear

	ret
clearCars ENDP

newRoad PROC,
	thisRoadPosition: COORD,
	roadNum: BYTE,
    outputHandle: DWORD

	.IF roadNum == 1
		mov ax, thisRoadPosition.x
		add ax, 6
		mov roadOneCarPosition.x, ax
		mov roadOneCarPosition.y, 0
	.ENDIF
	.IF roadNum == 2
		mov ax, thisRoadPosition.x
		add ax, 6
		mov roadTwoCarPosition.x, ax
		mov roadTwoCarPosition.y, 0
	.ENDIF
	.IF roadNum == 3
		mov ax, thisRoadPosition.x
		add ax, 6
		mov roadThreeCarPosition.x, ax
		mov roadThreeCarPosition.y, 0
	.ENDIF

	push thisRoadPosition
	mov ecx, 25
	drawRoad: 
	push ecx
	INVOKE WriteConsoleOutputCharacter,
        outputHandle,   ; console output handle
        ADDR roadSide,   ; pointer to the top box line
        13,   ; size of box line
        thisRoadPosition,   ; coordinates of first char
        ADDR cellsWritten     ; output count
	inc thisRoadPosition.y
	pop ecx
	loop drawRoad
	pop thisRoadPosition

	ret
newRoad ENDP

getRandomNumber PROC uses ebx,	; return in eax
	rangeLowerbound: DWORD,
	rangeUpperbound: DWORD

	INVOKE Sleep, 1
	call Randomize ;re-seed generator
	mov	ebx, rangeUpperbound
	sub ebx, rangeLowerbound
	inc ebx
	mov eax, ebx				;get random 0 to 99
	call RandomRange
	add eax, rangeLowerbound	;make range 1 to 100
	
	ret
getRandomNumber ENDP

checkIfSheepIsHitByCar PROC uses ebx ecx,
	carPosition: COORD

	mov bx, carPosition.x
	.IF sheepPosition.x == bx
		mov bx, carPosition.y
		.IF sheepPosition.y == bx
			mov eax, 1
			ret
		.ENDIF
	.ENDIF
	mov bx, carPosition.x
	inc bx
	.IF sheepPosition.x == bx
		mov bx, carPosition.y
		.IF sheepPosition.y == bx
			mov eax, 1
			ret
		.ENDIF
	.ENDIF

	mov eax, 0
    ret
checkIfSheepIsHitByCar ENDP

changeDisplayLife PROC,
	outputHandle: DWORD

	INVOKE decToStr, life

	INVOKE WriteConsoleOutputCharacter,
		outputHandle,   ; console output handle
		ADDR lifeStr,
		4,
		lifeDisplayPosition,   ; coordinates of first char
		ADDR cellsWritten     ; output count

	ret
changeDisplayLife ENDP

decToStr PROC,
	decNum: WORD

	mov ecx, 4			; WORD型態最高4位數
	mov dl, 10			; 除數
	mov ax, decNum			; 被除數
	change:
		push ecx
		div dl
		add ah, '0'					; 餘數轉成字存到 lifeStr
		dec ecx
		mov [lifeStr + ecx], ah
		movzx ax, al				; 商繼續除
		pop ecx
		loop change
	ret
decToStr ENDP