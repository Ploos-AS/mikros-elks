#!/bin/sh
set -eu

MATRIX=${1:-qualification/storage-matrix.tsv}

[ -f "$MATRIX" ] || { echo "missing $MATRIX" >&2; exit 2; }

awk -F '\t' '
NR == 1 {
    if ($1 != "media" || $2 != "capacity_kib" || $3 != "build" || $4 != "boot" || $5 != "useful") {
        print "invalid storage matrix header" > "/dev/stderr"; exit 2
    }
    next
}
{
    expected[$1]=$2
    if ($1 !~ /^(fd360|fd720|fd1200|fd1440)$/) {
        print "unexpected media: " $1 > "/dev/stderr"; exit 2
    }
    for (i = 3; i <= 5; i++) {
        if ($i !~ /^(UNTESTED|PASS|FAIL)$/) {
            print "invalid result for " $1 > "/dev/stderr"; exit 2
        }
    }
    if ($5 == "PASS" && ($3 != "PASS" || $4 != "PASS")) {
        print "USEFUL requires BUILD and BOOT PASS for " $1 > "/dev/stderr"; exit 2
    }
    if ($4 == "PASS" && $3 != "PASS") {
        print "BOOT requires BUILD PASS for " $1 > "/dev/stderr"; exit 2
    }
    seen[$1]++
}
END {
    split("fd360:360 fd720:720 fd1200:1200 fd1440:1440", r, " ")
    for (i = 1; i <= 4; i++) {
        split(r[i], p, ":")
        if (seen[p[1]] != 1 || expected[p[1]] != p[2]) {
            print "missing/invalid storage row: " p[1] > "/dev/stderr"; exit 2
        }
    }
}
' "$MATRIX"

echo "Storage qualification matrix structure: PASS"
