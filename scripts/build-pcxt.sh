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
    ./build.sh auto
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
