; nasm -f elf64 helloworld_Linux_x86_64.asm -o helloworld_Linux_x86_64.o
; ld -s -o helloworld_Linux_x86_64 helloworld_Linux_x86_64.o

global _start

section .data
    message: db "Hello, World!", 10     ; 10 is the ASCII code for newline ('\n')
    message_len equ $ - message         ; this calculates current [memory address($)] - [memory address of message]

section .text
_start:
    ; write "Hello, World!\n"
    mov rax, 1
    mov rdi, 1
    mov rsi, message
    mov rdx, message_len
    syscall

    ; Exit program
    mov rax, 60
    mov rdi, 0
    syscall
