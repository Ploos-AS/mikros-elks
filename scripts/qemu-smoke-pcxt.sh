#!/bin/sh
set -eu

OUT=${1:-out/pcxt}
IMAGE="$OUT/image/fd1440.img"
LOG="$OUT/qemu-smoke.log"

[ -f "$IMAGE" ] || { echo "missing $IMAGE" >&2; exit 1; }
command -v qemu-system-i386 >/dev/null 2>&1 || { echo "qemu-system-i386 not found" >&2; exit 1; }
command -v python3 >/dev/null 2>&1 || { echo "python3 not found" >&2; exit 1; }

python3 ./scripts/qemu-m0-driver.py "$IMAGE" "$LOG"

for marker in \
    MIKROS_M0_SHELL \
    MIKROS_M0_CAT \
    MIKROS_M0_LS \
    MIKROS_M0_MKDIR \
    MIKROS_M0_RM \
    MIKROS_M0_PS \
    MIKROS_M0_MEMINFO \
    MIKROS_M0_FORKEXEC \
    MIKROS_M0_USEFUL_PASS
do
    grep -q "$marker" "$LOG" || { echo "missing guest marker: $marker" >&2; exit 1; }
    echo "$marker: PASS"
done

echo "MikR OS ELKS M0 QEMU qualification: PASS"
