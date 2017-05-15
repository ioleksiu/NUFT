data segment
	string 		db "Lorem ipsum dolor sit amet, consectetur adipiscing elit.Cras id felis sed neque ultricies malesuada sit amet ac ipsum. Nulla odio massa, "
				db "dapibus nec blandit et, porta nec leo. Donec egestas tincidunt consequat. Proin eget imperdiet ex, ac viverra erat. Aenean rhoncus dictum "
				db "eros, in maximus risus dictum non. Vivamus ipsum diam, mollis in eros tempus, interdum sagittis lectus. Pellentesque vitae turpis hendrerit,"
				db " placerat diam non, condimentum purus. Nulla facilisi. Praesent nisl ligula, bibendum eu justo eu, sollicitudin mollis ante. Maecenas nec quam"
				db " cursus, ultricies ante eget, sodales tortor. Suspendisse tempor quam ut lacus fringilla aliquam.Duis et maximus erat. Sed ultrices tortor nec"
				db " enim consequat consectetur. Aenean quis pretium magna. Praesent tristique diam ac arcu mattis tempus. Ut quis aliquet mi. Mauris lectus quam, "
				db "suscipit eu ullamcorper ac, imperdiet et mi. Suspendisse potenti. Proin dapibus varius tellus, et molestie ante fringilla eget. Mauris ut pulvinar"
				db " nunc. Morbi nec bibendum nulla.Nunc feugiat risus dui, sed dignissim neque interdum a. Suspendisse potenti. Proin a leo eget lectus ornare"
				db " ultrices. Fusce est neque, sollicitudin lacinia nisl eu, volutpat aliquam elit. In risus lacus, ullamcorper eget interdum sed, sagittis vel urna."
				db " Morbi sed enim mauris. In blandit lectus lectus, posuere mollis turpis faucibus et. Proin maximus suscipit finibus. Donec faucibus id nisl a "
				db "bibendum. Sed in nulla sollicitudin, accumsan enim nec, feugiat nisi.Donec cursus tortor ut purus porttitor, vel pellentesque ligula commodo. "
				db "Nullam venenatis massa quis rutrum mollis. Morbi id suscipit arcu. Morbi suscipit, massa eget consequat ultricies, nulla turpis fermentum massa,"
				db " eget tristique ante metus sit amet felis. Donec feugiat egestas leo, imperdiet iaculis nibh elementum quis. Cras tempus tincidunt elit, et semper"
				db " tortor venenatis id. Fusce non dui vulputate, placerat libero vel, consectetur quam. Curabitur felis lacus, dictum at lectus et, hendrerit auctor amet."
	odd_bg		db 00001111b
	even_bg 	db 00001111b
	cont 		db 1
data ends
stack segment
	dw 8 dup(?)
stack ends

code segment
assume cs:code, ds:data, ss:stack
begin:
	
	mov ax, data
	mov ds, ax

	mov ax, 3
	int 10h

	mov ax, 0500h
	int 10h

	mov ax, 0
	int 33h

	mov ax, 1
	int 33h

	mov ax, 0ah
	mov bx, 0
	mov cx, 0101010111111111b
	mov dx, 1111111000000000b
	int 33h

	call fillConsole

	mov ah, 01h
	int 21h

	mov ax, 000ch
	mov cx, 0000h
	int 33h

	mov ax, 3
	int 10h

	mov ax, 4c00h
	int 21h

	mouse_click proc far
		cmp ax, 0000000000000100b
		jz l_click
		mov ah, odd_bg
		call changeColor
		mov odd_bg, ah
		jmp end_click
		l_click:
		mov ah, even_bg
		call changeColor
		mov even_bg, ah
		end_click:
		call fillConsole
		retf
	mouse_click endp

	getAddress proc
		mov ah, 0
		mov al, bl
		mov dx, 80
		mul dx
		mov dx, 2
		mul dx
		push ax
		mov ah, 0
		mov al, bh
		mov dx, 2
		mul dx
		mov dx, ax 
		pop ax
		add ax, dx
		mov si, ax 	;адрес видеопамяти для записи
		ret
	getAddress endp

	changeColor proc
		cmp ah, 01111111b
		jnz changeColor_exit_continue
		mov ah, 00001111b
		changeColor_exit_continue:
		mov al, ah
		and al, 01110000b
		mov cl, 4
		shr al, cl
		inc al
		shl al, cl
		or al, 00001111b
		mov ah, al
		changeColor_exit:
		and ah, 01111111b
		ret
	changeColor endp

	fillConsole proc
		push es
		mov ax, 0ch
	    mov bx, seg mouse_click
	    mov es, bx
	    lea dx, mouse_click
	    mov cx, 0000000000010100b
	    int 33h
	    pop es

		mov ax, 0b800h
		mov es, ax
		mov bl, 0	;ряд
		mov bh, 0	;позиция

		mov cx, 25
		mov bl, 0

		cycle1:
			push cx
			mov cx, 80
			mov bh, 0
			cycle2:
				call getAddress
				mov dl, 1
				and dl, bl
				cmp dl, 1 ; if (dl == 1) odd = true
				jz odd_mark
				mov ah, even_bg
				jmp end_loop
				odd_mark:
				mov ah, odd_bg
				end_loop:
				mov al, 0
				mov es:[si], ax
				inc bh
			loop cycle2
			inc bl
			pop cx
		loop cycle1
		ret
	fillConsole endp

code ends
end begin