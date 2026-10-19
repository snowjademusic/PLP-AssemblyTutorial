# Linux (ARM64 / aarch64)

Setup and instructions to build and run "Hello, World!" in ARM64 Assembly on Linux (e.g. Raspberry Pi, Asahi Linux, ARM VMs).

## Source File

[helloworld_Linux_arm64.s](helloworld_Linux_arm64.s)

## 1. Install GNU Assembler & Linker

- **Debian / Ubuntu**:
  ```bash
  sudo apt update
  sudo apt install binutils gcc
  ```
- **Arch-based systems**:
  ```bash
  sudo pacman -S binutils gcc
  ```

## 2. Assemble, Link & Run

From this directory:

```bash
as helloworld_Linux_arm64.s -o helloworld.o
ld -o helloworld helloworld.o
./helloworld
```

*(Alternatively, assemble and link directly with GCC: `gcc -nostdlib helloworld_Linux_arm64.s -o helloworld`)*

## 3. System Calls & Architecture Reference

On Linux ARM64, system calls are invoked using the `svc #0` instruction (Supervisor Call).

### Register Conventions

| Role | Register | Notes |
| :--- | :--- | :--- |
| **Syscall Number** | `x8` | Identifies which system call to execute |
| **Argument 1** | `x0` | First parameter |
| **Argument 2** | `x1` | Second parameter |
| **Argument 3** | `x2` | Third parameter |
| **Argument 4** | `x3` | Fourth parameter |
| **Argument 5** | `x4` | Fifth parameter |
| **Argument 6** | `x5` | Sixth parameter |
| **Return Value** | `x0` | Result or negative error code (`-errno`) |

### Key System Calls

| Syscall | `x8` | `x0` (arg 1) | `x1` (arg 2) | `x2` (arg 3) | `x3` (arg 4) | Description |
| :--- | :---: | :--- | :--- | :--- | :--- | :--- |
| `sys_openat` | `56` | `dirfd` (`-100` = `AT_FDCWD`) | `pathname` (pointer to string) | `flags` (`0` = `O_RDONLY`) | `mode` (`0`) | Open file (ARM64 Linux uses `openat`) |
| `sys_close` | `57` | `fd` (file descriptor) | — | — | — | Close an open file descriptor |
| `sys_read` | `63` | `fd` (file descriptor) | `buf` (pointer to buffer) | `count` (max bytes) | — | Read from file into buffer |
| `sys_write` | `64` | `fd` (`1` = stdout) | `buf` (pointer to data) | `count` (number of bytes) | — | Write data to file/stream |
| `sys_exit` | `93` | `status` (`0` = success) | — | — | — | Terminate process |

> [!NOTE]
> ARM64 Linux kernels do not implement the legacy `open` syscall; instead, use `sys_openat` (`56`) with `x0 = -100` (`AT_FDCWD`), which resolves relative paths relative to the current working directory.

### Accessing Command-Line Arguments (`argv[1]`)

At entry (`_start`), the initial stack pointer `sp` points to `argc`:

```nasm
[sp]         -> argc (8 bytes)
[sp, #8]     -> argv[0] (pointer to program name)
[sp, #16]    -> argv[1] (pointer to first CLI argument, e.g. "example.txt")
[sp, #24]    -> argv[2] (next argument, etc.)
```

Example in ARM64 GNU Assembler:

```nasm
.global _start
.text

_start:
    // Check if argc >= 2
    ldr     x1, [sp]            // x1 = argc
    cmp     x1, #2
    b.lt    missing_arg         // if argc < 2, handle error

    // Load pointer to argv[1]
    ldr     x1, [sp, #16]       // x1 = argv[1] (filename pointer)

    // sys_openat(AT_FDCWD=-100, pathname=argv[1], flags=O_RDONLY=0, mode=0)
    mov     x0, #-100           // AT_FDCWD
    // x1 already points to pathname
    mov     x2, #0              // O_RDONLY
    mov     x3, #0              // mode
    mov     x8, #56             // sys_openat
    svc     #0

    cmp     x0, #0
    b.lt    open_error          // negative value indicates error
    mov     x19, x0             // save file descriptor in callee-saved register x19
```
