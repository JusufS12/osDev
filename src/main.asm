org 0x7C00				; tell the assembler where we're going to be loaded
bits 16					; tell the assembler to generate 16-bit code

%define ENDL 0x0D, 0x0A	; define a macro for a newline


start:					; jump to main (start of program)

	jmp main


;
; Print a string to the screen
; Input: ds:si points to the string
;
puts:

	; save registers (push them on the stack)
	push si
	push ax

.loop:					;loop trough string

	lodsb				; load next char into al
	or al, al			; check if char is null (exit condition)
	jz .done			; chech for exit condition and exit if true

	mov ah, 0x0E			; print the char
	mov bh, 0x00			; page number (0)
	int 0x10			; interrupt 0x10 (video services)

	jmp .loop			; loop

.done:					; exit

	; restore registers (pop the stack)
	pop ax
	pop si
	ret



main:

	; set up data segments
	mov ax, 0			; can't mov 0 directly to ds
	mov ds, ax
	mov es, ax

	; set up stack
	mov ss, ax
	mov sp, 0x7C00			; stack grows down from 0x7C00

	; print message
	mov si, msg_hello
	call puts

	hlt

; halt loop
.halt:

	jmp.halt


msg_hello: db "Hello, World!", ENDL, 0


; pad out the file with zeros so it's 512 bytes
times 510-($-$$) db 0			; $ is current address, $$ is start address
dw 0AA55h				; the standard PC boot signature for BIOS
