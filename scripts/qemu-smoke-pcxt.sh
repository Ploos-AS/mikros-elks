#!/bin/sh
set -eu

OUT=${1:-out/pcxt}
LOG="$OUT/qemu-smoke.log"
IMAGE="$OUT/image/fd1440.img"

[ -f "$IMAGE" ] || { echo "missing $IMAGE" >&2; exit 1; }
command -v qemu-system-i386 >/dev/null 2>&1 || { echo "qemu-system-i386 not found" >&2; exit 1; }

rm -f "$LOG"

# ELKS upstream uses an ISA PC machine and requires one-insn-per-TB/singlestep
# for reliable execution. Serial stdio gives CI an observable boot transcript.
ACCEL="-singlestep"
if qemu-system-i386 -version | grep -Eq 'version (9|10)'; then
    ACCEL="-accel tcg,one-insn-per-tb=on"
fi

set +e
timeout 90s qemu-system-i386 $ACCEL \
    -nodefaults -name "MikrOS ELKS M0" -machine isapc -cpu 486,tsc -m 8M \
    -display none -serial stdio -monitor none \
    -drive file="$IMAGE",format=raw,if=floppy -boot a \
    >"$LOG" 2>&1
rc=$?
set -e

# A timeout is expected: a successfully booted guest remains running.
[ "$rc" -eq 0 ] || [ "$rc" -eq 124 ] || {
    cat "$LOG"
    exit "$rc"
}

# Require positive evidence from ELKS rather than treating a running QEMU as PASS.
if grep -Eiq 'ELKS|login:|shell|Welcome' "$LOG"; then
    echo "PASS: ELKS produced an observable boot transcript"
    exit 0
fi

cat "$LOG"
echo "FAIL: no ELKS boot marker observed" >&2
exit 1
