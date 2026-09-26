#!/bin/sh
set -eu

IMAGE=${1:-}
VMDIR=${2:-}
REPORT=${REPORT:-out/qualification/86box/report.txt}
EMU=${EMU:-86Box}

[ -n "$IMAGE" ] && [ -f "$IMAGE" ] || {
    echo "usage: $0 <mikros-elks.img> <86box-vm-directory>" >&2
    exit 2
}
[ -n "$VMDIR" ] && [ -d "$VMDIR" ] || {
    echo "86Box VM directory not found: $VMDIR" >&2
    exit 2
}
command -v "$EMU" >/dev/null 2>&1 || {
    echo "86Box executable not found (set EMU=... if needed)" >&2
    exit 2
}

mkdir -p "$(dirname "$REPORT")"
{
    echo "MikrOS ELKS 86Box qualification"
    echo "status=MANUAL-BOOT-REQUIRED"
    echo "image=$IMAGE"
    echo "image_sha256=$(sha256sum "$IMAGE" | awk '{print $1}')"
    echo "vm_directory=$VMDIR"
    printf "emulator="
    "$EMU" --help 2>&1 | head -n 1 || true
    echo "firmware_policy=external-not-recorded"
} > "$REPORT"

cat "$REPORT"
echo
echo "Preflight complete."
echo "Verify the VM selects an actual 8088/8086 and attaches: $IMAGE"
echo "Starting 86Box; this invocation does not itself constitute PASS."

exec "$EMU" --vmpath "$VMDIR"
