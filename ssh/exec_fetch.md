# exec_fetch.sh

This Bash script connects to a remote Linux host via SSH, executes a command, compresses the output using `gzip`, downloads the result using `rsync`, and prints the output to `stdout`. All logs and diagnostic messages are written to `stderr`.

---

## Usage

```bash
./exec_fetch.sh user@remote_host "your command here"
```

Example: need to grep error messages in a large and thick log file `/srv/logs/ucs_mt/viper/viper.log`

```bash
sh ssh/exec_fetch.sh develope@ucs-infra.mt grep "error" /srv/logs/ucs_mt/viper/viper.log 1>log.log
```

You’ll see something like:

```bash
[*] Executing command on remote host develope@ucs-infra.mt:
    grep error /srv/logs/ucs_mt/viper/viper.log
[*] Downloading compressed output...
[*] Cleaning up temporary files on remote host...

du -dh log.log 
427008  log.log
```

While the log messages (e.g. connection info, cleanup steps) go to `stderr`.

## 🗂️ What happens under the hood?
- Creates a unique temporary folder on the remote host
- Runs your command and saves output to a file
- Compresses the file using gzip
- Transfers the .gz file via rsync over SSH
- Extracts and prints the result locally
- Cleans up both local and remote temporary files

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
```

On **RedHat/CentOS/Fedora**:

```bash
sudo dnf install rsync util-linux gzip openssh-clients
```

##  ⚠️ Notes
The remote host must allow SSH access and have gzip, rsync, and bash.

The script overwrites temp files in /tmp, so avoid running multiple instances with the exact same UUID or host.

## 🧹 Future Features (Planned)
- --keep: preserve local and/or remote temp files
- --debug: enable verbose SSH/rsync output
- --no-clean: for debugging/troubleshooting
- Compatibility with Windows (via WSL)
