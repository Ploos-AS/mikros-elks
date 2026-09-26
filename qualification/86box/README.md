# 86Box minimum-CPU qualification

This directory defines the authoritative MikrOS ELKS M0 gate for an actual
8088/8086-class CPU.

The gate is intentionally separate from GitHub Actions/QEMU. 86Box machine
firmware is external input and must not be committed to MikrOS.

## Contract

The operator must provide:

- 86Box (version recorded in the qualification report);
- a legally obtained ROM set for the selected PC/XT-class machine;
- a machine configuration selecting an actual 8088 or 8086;
- the MikrOS ELKS floppy image produced by the normal M0 build.

Run `./qualification/86box/qualify.sh <image> <vm-directory>`.

The wrapper performs preflight checks, records immutable input hashes and starts
86Box with the supplied VM directory. Until automated guest-console capture is
qualified for the selected 86Box machine, the result is recorded as
`MANUAL-BOOT-REQUIRED`, never PASS.

No ROM paths, ROM bytes or firmware hashes are committed here.
