# Reproducible M0 build

MikrOS ELKS M0 is based on upstream ELKS v0.9.1.

## Host baseline

The canonical build runs in a clean Linux environment. Upstream ELKS supports Linux, macOS and Windows/WSL, but MikrOS uses Linux as the reproducibility reference.

## Toolchain

Use the ELKS-supported ia16-elf-gcc cross toolchain. The upstream `build.sh` workflow builds the cross toolchain, configuration, kernel, userspace and target image.

MikrOS does not require native compilation on the 8086 target.

## Build contract

1. Fetch the exact pinned ELKS tag/commit.
2. Build the ia16 cross toolchain from the documented inputs.
3. Apply the MikrOS configuration.
4. Build kernel and userspace.
5. Generate the selected disk image.
6. Record SHA-256, image size and build metadata.
7. Boot the image in the M0 reference emulator and run smoke tests.

No generated ELKS binaries or upstream source snapshots need to be committed to this repository.

## Initial image

The first M0 artifact should be a PC/XT-compatible boot image sized for automated qualification. Floppy and HDD profiles will be defined separately after the base build is reproducible.
