# exec_fetch.sh

This Bash script connects to a remote Linux host via SSH, executes a command, compresses the output using `gzip`, downloads the result using `rsync`, and prints the output to `stdout`. All logs and diagnostic messages are written to `stderr`.

---

## 📦 Features

- ✅ Remote command execution over SSH
- ✅ Compressed result transfer using `gzip` + `rsync`
- ✅ Clear separation of logs (`stderr`) and output (`stdout`)
- ✅ Unique file naming with `uuidgen`
- ✅ Automatic cleanup of remote and local temp files
- ✅ Compatible with most Unix/Linux systems

---

## 🔧 Requirements

- Bash (v4+ recommended)
- SSH access to remote host
- `gzip` and `rsync` installed on **both local and remote** systems
- `uuidgen` utility (usually part of `util-linux` or `uuid-runtime`)

### 📦 Install dependencies (if needed)

On **Debian/Ubuntu**:

```bash
sudo apt update
sudo apt install rsync uuid-runtime gzip openssh-client