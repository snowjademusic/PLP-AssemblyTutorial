# Linux (x86_64: Intel / AMD)

Setup and instructions to build and run "Hello, World!" in x86_64 Assembly on Linux.

## Source File

- [helloworld_Linux_x86_64.asm](helloworld_Linux_x86_64.asm)

## 1. Install NASM & Binutils

- **Debian-based systems** (Ubuntu, Pop!_OS, Mint, Debian):
  ```bash
  sudo apt update
  sudo apt install nasm binutils
  ```
- **Arch-based systems**:
  ```bash
  sudo pacman -S nasm binutils
  ```
- **Fedora / Red Hat**:
  ```bash
  sudo dnf install nasm binutils
  ```

## 2. Assemble, Link & Run

From this directory:

```bash
nasm -f elf64 helloworld_Linux_x86_64.asm -o helloworld.o
ld -s -o helloworld helloworld.o
./helloworld
```

## 3. System Calls & Architecture Reference

On Linux x86_64, system calls are made using the `syscall` instruction.

### Register Conventions

| Role | Register | Notes |
| :--- | :--- | :--- |
| **Syscall Number** | `rax` | Identifies which kernel function to call |
| **Argument 1** | `rdi` | First parameter |
| **Argument 2** | `rsi` | Second parameter |
| **Argument 3** | `rdx` | Third parameter |
| **Argument 4** | `r10` | *(Note: `r10`, not `rcx`)* |
| **Argument 5** | `r8` | Fifth parameter |
| **Argument 6** | `r9` | Sixth parameter |
| **Return Value** | `rax` | Return code (negative values indicate `-errno` on failure) |
| *Clobbered* | `rcx`, `r11` | Automatically overwritten by the CPU during `syscall` |

### Key System Calls

| Syscall | `rax` | `rdi` (arg 1) | `rsi` (arg 2) | `rdx` (arg 3) | Description |
| :--- | :---: | :--- | :--- | :--- | :--- |
| `sys_read` | `0` | `fd` (file descriptor) | `buf` (pointer to buffer) | `count` (max bytes) | Read from file/stream |
| `sys_write` | `1` | `fd` (`1` = stdout) | `buf` (pointer to data) | `count` (number of bytes) | Write to file/stream |
| `sys_open` | `2` | `filename` (pointer to string) | `flags` (`0` = `O_RDONLY`) | `mode` (`0`) | Open a file |
| `sys_close` | `3` | `fd` (file descriptor) | — | — | Close an open file |
| `sys_exit` | `60` | `error_code` (`0` = success) | — | — | Terminate process |

### Accessing Command-Line Arguments (`argv[1]`)

When your program enters at `_start`, the Linux kernel sets up the initial stack as follows:

```nasm
[rsp]        -> argc (number of arguments, 8 bytes)
[rsp + 8]    -> argv[0] (pointer to program name string)
[rsp + 16]   -> argv[1] (pointer to first CLI argument, e.g. "example.txt")
[rsp + 24]   -> argv[2] (next argument, etc.)
```

Example in NASM to check `argc` and retrieve `argv[1]`:

```nasm
section .text
global _start

_start:
    ; Check if argc >= 2
    mov rcx, [rsp]              ; rcx = argc
    cmp rcx, 2
    jl .missing_arg             ; if argc < 2, jump to error handler

    ; Get argv[1] (pointer to filename string)
    mov rdi, [rsp + 16]         ; rdi = argv[1] (pointer to filename)

    ; sys_open(filename, O_RDONLY, 0)
    mov rax, 2                  ; syscall: sys_open
    xor rsi, rsi                ; rsi = 0 (O_RDONLY)
    xor rdx, rdx                ; rdx = 0 (mode)
    syscall

    cmp rax, 0
    jl .open_failed             ; rax < 0 indicates an error opening file
    mov rbx, rax                ; save file descriptor in rbx (or a variable)
```
