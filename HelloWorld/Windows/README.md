# Windows (via WSL)

The simplest and recommended environment for Assembly programming on Windows is **Windows Subsystem for Linux (WSL)**.

## 1. Install WSL

If you haven't installed WSL already, open PowerShell or Windows Terminal as Administrator and run:

```powershell
wsl --install
```

Restart your computer if prompted.

## 2. Open your WSL distribution

Launch your WSL distribution (e.g. Ubuntu from the Start Menu or via Windows Terminal).

## 3. Configure VS Code (optional)

If you use VS Code, install the **WSL** extension and open your repository using the WSL profile.

## 4. Clone the repository inside WSL

```bash
git clone <repo-url>
cd PLP-PeerExercise
```

## 5. Build and Run

Inside your WSL environment, your assembly code runs as a native Linux binary. Follow the instructions and system call references for your processor architecture:

- **Intel / AMD (`x86_64`)**: [Linux x86_64 Setup & Syscall Reference](../Linux/x86_64/README.md)
- **ARM (`arm64` / `aarch64`)**: [Linux ARM64 Setup & Syscall Reference](../Linux/arm64/README.md)
