#!/bin/sh
set -eu

CONTRACT=${1:-qualification/m0-userspace.tsv}

[ -f "$CONTRACT" ] || { echo "missing $CONTRACT" >&2; exit 2; }

awk -F '\t' '
NR == 1 {
    if ($1 != "capability" || $2 != "command" || $3 != "required") {
        print "invalid M0 userspace header" > "/dev/stderr"; exit 2
    }
    next
}
{
    if ($1 == "" || $2 !~ /^\/bin\// || $3 != "YES") {
        print "invalid M0 userspace row at line " NR > "/dev/stderr"; exit 2
    }
    seen[$1]++
}
END {
    split("shell read list create-dir remove process-list memory-info fork-exec", r, " ")
    for (i = 1; i <= 8; i++) {
        if (seen[r[i]] != 1) {
            print "missing/duplicate M0 capability: " r[i] > "/dev/stderr"; exit 2
        }
    }
}
' "$CONTRACT"

echo "M0 userspace contract structure: PASS"
