; Build & run on macOS x86_64 (Intel Mac):
;   nasm -f macho64 helloworld_macOS_x86_64.asm -o helloworld.o
;   clang helloworld.o -o helloworld
;   ./helloworld
;
; Alternatively using ld:
;   ld -o helloworld helloworld.o -lSystem -syslibroot `xcrun -sdk macosx --show-sdk-path` -e _main -arch x86_64
;   ./helloworld

global _main

section .data
    message: db "Hello, World!", 10     ; 10 is ASCII code for newline ('\n')
    len: equ $ - message                ; this calculates current [memory address($)] - [memory address of message]

section .text
_main:
    ; sys_write(stdout, message, len)
    mov rax, 0x2000004          ; macOS sys_write (syscall 4 with 0x2000000 class offset)
    mov rdi, 1                  ; file descriptor 1 = stdout
    lea rsi, [rel message]      ; RIP-relative address of message
    mov rdx, len                ; number of bytes
    syscall                     ; invoke kernel

    ; sys_exit(0)
    mov rax, 0x2000001          ; macOS sys_exit (syscall 1 with 0x2000000 class offset)
    xor rdi, rdi                ; exit status 0
    syscall                     ; invoke kernel
