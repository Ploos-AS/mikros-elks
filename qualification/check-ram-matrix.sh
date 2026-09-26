#!/bin/sh
set -eu

MATRIX=${1:-qualification/ram-matrix.tsv}

[ -f "$MATRIX" ] || { echo "missing $MATRIX" >&2; exit 2; }

awk -F '\t' '
NR == 1 {
    if ($1 != "ram_kib" || $2 != "boot" || $3 != "shell" || $4 != "useful") {
        print "invalid RAM matrix header" > "/dev/stderr"; exit 2
    }
    next
}
{
    if ($1 !~ /^(640|512|384|256)$/) {
        print "unexpected RAM size: " $1 > "/dev/stderr"; exit 2
    }
    for (i = 2; i <= 4; i++) {
        if ($i !~ /^(UNTESTED|PASS|FAIL)$/) {
            print "invalid result at " $1 " KiB" > "/dev/stderr"; exit 2
        }
    }
    if ($4 == "PASS" && ($2 != "PASS" || $3 != "PASS")) {
        print "USEFUL requires BOOT and SHELL PASS at " $1 " KiB" > "/dev/stderr"; exit 2
    }
    if ($3 == "PASS" && $2 != "PASS") {
        print "SHELL requires BOOT PASS at " $1 " KiB" > "/dev/stderr"; exit 2
    }
    seen[$1]++
}
END {
    for (i = 1; i <= 4; i++) {
        split("640 512 384 256", r, " ")
        if (seen[r[i]] != 1) {
            print "missing/duplicate RAM row: " r[i] > "/dev/stderr"; exit 2
        }
    }
}
' "$MATRIX"

echo "RAM qualification matrix structure: PASS"
