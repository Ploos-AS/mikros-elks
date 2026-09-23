# ELKS upstream baseline

## M0 baseline

MikrOS ELKS initially tracks **ELKS v0.9.1** as the reproducible M0 baseline.

Upstream release: https://github.com/ghaerr/elks/releases/tag/v0.9.1

The baseline is pinned for qualification rather than permanently frozen. MikrOS may move to a newer ELKS release after the existing qualification suite passes against it.

## Why v0.9.1

- Current ELKS release when MikrOS M0 was established (2026-09).
- Upstream provides prebuilt floppy and hard-disk images.
- ELKS supports PC/XT/AT-class systems and modern-host cross-build workflows.
- Upstream documents GCC-IA16 as a kernel/application toolchain.

## M0 reference emulator policy

MikrOS ELKS should qualify at least one strict PC/XT-class emulator plus one broadly available CI-friendly emulator. Emulator selection is part of M0 and must be documented before declaring the target qualified.

## Update policy

1. Pin the exact upstream tag/commit used for a release.
2. Build from source on a clean modern host.
3. Run the MikrOS boot/smoke qualification.
4. Record image size and memory measurements.
5. Only then advance the baseline.
