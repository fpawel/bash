#!/bin/bash

# Check arguments
if [ "$#" -lt 2 ]; then
  echo "Usage: $0 user@remote_host command_to_execute" >&2
  echo "Example: $0 user@192.168.1.100 ls -l /var/log" >&2
  exit 1
fi

SSH_TARGET="$1"
shift
REMOTE_CMD="$*"

# Generate a unique identifier
UUID=$(uuidgen)
REMOTE_HOST=$(echo "$SSH_TARGET" | cut -d'@' -f2)

# Define file and directory names
REMOTE_TMP_DIR="/tmp/ssh_exec_${UUID}"
REMOTE_OUTPUT="output.txt"
REMOTE_GZ="output.txt.gz"
LOCAL_GZ="/tmp/output_${REMOTE_HOST}_${UUID}.gz"
LOCAL_DIR="/tmp/output_local_${REMOTE_HOST}_${UUID}"

# Log: start
echo "[*] Executing command on remote host ${SSH_TARGET}:" >&2
echo "    $REMOTE_CMD" >&2

# 1. Run command remotely and compress output
ssh "$SSH_TARGET" "
  mkdir -p ${REMOTE_TMP_DIR} &&
  bash -c '$REMOTE_CMD' > ${REMOTE_TMP_DIR}/${REMOTE_OUTPUT} 2>&1 &&
  gzip -f ${REMOTE_TMP_DIR}/${REMOTE_OUTPUT}
" >/dev/null

if [ $? -ne 0 ]; then
  echo "[!] Failed to execute command or compress output on remote host" >&2
  exit 2
fi

# 2. Download the compressed output using rsync
echo "[*] Downloading compressed output..." >&2
rsync -az -e ssh "${SSH_TARGET}:${REMOTE_TMP_DIR}/${REMOTE_GZ}" "${LOCAL_GZ}" >/dev/null

if [ $? -ne 0 ]; then
  echo "[!] Failed to download the compressed file" >&2
  exit 3
fi

# 3. Clean up remote temporary files
echo "[*] Cleaning up temporary files on remote host..." >&2
ssh "$SSH_TARGET" "rm -rf ${REMOTE_TMP_DIR}" >/dev/null

# 4. Extract and print result
mkdir -p "${LOCAL_DIR}"
gunzip -c "${LOCAL_GZ}" > "${LOCAL_DIR}/${REMOTE_OUTPUT}"

# === Only stdout: output of remote command ===
cat "${LOCAL_DIR}/${REMOTE_OUTPUT}"

# 5. Clean up local temporary files
rm -f "${LOCAL_GZ}"
rm -rf "${LOCAL_DIR}"
