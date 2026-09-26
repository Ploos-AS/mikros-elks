#!/bin/sh
set -eu

. ./versions.conf

SRC=${SRC:-sources}
OUT=${OUT:-out/pcxt}
ELKS="$SRC/elks"

[ -d "$ELKS/.git" ] || { echo "run scripts/fetch-elks.sh first" >&2; exit 1; }
test "$(git -C "$ELKS" describe --tags --exact-match)" = "$ELKS_VERSION"

mkdir -p "$OUT"
(
    cd "$ELKS"

    # M0 CI needs an observable serial login. Upstream defaults to runlevel 1,
    # where ttyS0 is disabled; runlevel 3 enables tty1 + ttyS0.
    sed -i 's/^id:1:initdefault:/id:3:initdefault:/' elkscmd/rootfs_template/etc/inittab
    grep -q '^id:3:initdefault:

rm -rf "$OUT/target" "$OUT/image"
cp -a "$ELKS/target" "$OUT/target"
mkdir -p "$OUT/image"
find "$ELKS/image" -maxdepth 1 -type f \( -name '*.img' -o -name '*.bin' \) -exec cp -a {} "$OUT/image/" \;

count=$(find "$OUT/image" -maxdepth 1 -type f | wc -l)
[ "$count" -gt 0 ] || { echo "ELKS build produced no boot image" >&2; exit 1; }

(
    cd "$OUT"
    find image -maxdepth 1 -type f -print | LC_ALL=C sort | xargs sha256sum
) > "$OUT/SHA256SUMS"

echo "MikrOS ELKS PC/XT M0 build staged in $OUT"
 elkscmd/rootfs_template/etc/inittab

    # Build only the IBM PC baseline. Upstream ./build.sh auto continues with
    # 8018X/V25/PC-98 and leaves target/ representing the final variant.
    . ./env.sh
    cp ibmpc-1440-nc.config .config
    make clean
    make -j1 all
)

rm -rf "$OUT/target" "$OUT/image"
cp -a "$ELKS/target" "$OUT/target"
mkdir -p "$OUT/image"
find "$ELKS/image" -maxdepth 1 -type f \( -name '*.img' -o -name '*.bin' \) -exec cp -a {} "$OUT/image/" \;

count=$(find "$OUT/image" -maxdepth 1 -type f | wc -l)
[ "$count" -gt 0 ] || { echo "ELKS build produced no boot image" >&2; exit 1; }

(
    cd "$OUT"
    find image -maxdepth 1 -type f -print | LC_ALL=C sort | xargs sha256sum
) > "$OUT/SHA256SUMS"

echo "MikrOS ELKS PC/XT M0 build staged in $OUT"
