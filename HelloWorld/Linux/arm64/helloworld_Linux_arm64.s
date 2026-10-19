// Build & run on Linux arm64 (native or aarch64 cross-toolchain):
//   as helloworld_Linux_arm64.s -o helloworld_Linux_arm64.o
//   ld helloworld_Linux_arm64.o -o helloworld_Linux_arm64
//   ./helloworld_Linux_arm64

.global _start

.section .rodata
msg: .ascii "Hello, World!\n"
len = . - msg

.section .text
_start:
    mov x0, #1          // stdout
    adr x1, msg
    mov x2, #len
    mov x8, #64         // sys_write
    svc #0

    mov x0, #0
    mov x8, #93         // sys_exit
    svc #0