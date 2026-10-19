// Build & run on macOS arm64 (Apple Silicon: M1, M2, M3, M4, etc.):
//   clang helloworld_macOS_arm64.s -o helloworld
//   ./helloworld
//
// Alternatively using as & ld:
//   as helloworld_macOS_arm64.s -o helloworld.o
//   ld -o helloworld helloworld.o -lSystem -syslibroot `xcrun -sdk macosx --show-sdk-path` -e _main -arch arm64
//   ./helloworld

.global _main
.align 2

.text
_main:
    // sys_write(fd=1, buf=msg, count=len)
    mov     x0, #1                  // 1 = stdout
    adrp    x1, msg@PAGE            // load 4KB page address of message
    add     x1, x1, msg@PAGEOFF     // add byte offset within page
    mov     x2, #len                // message length
    mov     x16, #4                 // macOS sys_write (syscall 4)
    svc     #0                      // invoke system call

    // sys_exit(code=0)
    mov     x0, #0                  // exit status 0
    mov     x16, #1                 // macOS sys_exit (syscall 1)
    svc     #0                      // invoke system call

.data
msg:
    .ascii  "Hello, World!\n"
len = . - msg
