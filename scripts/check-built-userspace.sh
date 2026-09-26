#!/bin/sh
set -eu

ROOT=${1:-out/pcxt/target}
CONTRACT=${2:-qualification/m0-userspace.tsv}

[ -d "$ROOT" ] || { echo "missing target root: $ROOT" >&2; exit 2; }
[ -f "$CONTRACT" ] || { echo "missing contract: $CONTRACT" >&2; exit 2; }

failed=0
while IFS="$(printf '\t')" read -r capability command required notes; do
    [ "$capability" = "capability" ] && continue
    [ "$required" = "YES" ] || continue
    path="$ROOT$command"
    if [ ! -e "$path" ]; then
        echo "MISSING: $capability -> $command" >&2
        failed=1
    else
        echo "FOUND: $capability -> $command"
    fi
done < "$CONTRACT"

[ "$failed" -eq 0 ] || exit 1
echo "Built M0 userspace contract: PASS"
