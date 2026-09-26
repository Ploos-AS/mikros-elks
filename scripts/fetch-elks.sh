#!/bin/sh
set -eu

. ./versions.conf

SRC=${SRC:-sources}
DEST="$SRC/elks"

mkdir -p "$SRC"
if [ -d "$DEST/.git" ]; then
    git -C "$DEST" fetch --tags --force origin
else
    git clone --filter=blob:none "$ELKS_REPO" "$DEST"
fi

git -C "$DEST" checkout --detach "$ELKS_VERSION"
test "$(git -C "$DEST" describe --tags --exact-match)" = "$ELKS_VERSION"
echo "ELKS source pinned at $ELKS_VERSION"
