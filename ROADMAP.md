# MikrOS ELKS Roadmap

## M0 — Distribution baseline

- [x] Define MikrOS ELKS scope and design principles.
- [x] Select PC/XT-class 8088/8086 as the primary minimum-platform reference.
- [x] Pin and document the ELKS upstream baseline (v0.9.1).
- [ ] Establish a reproducible modern-host cross-build.
- [ ] Define the minimal base userspace.
- [ ] Establish emulator reference machines.
- [ ] Measure minimum and recommended RAM.
- [ ] Define floppy/disk image layouts.
- [ ] Define automated boot/qualification tests.
- [ ] Produce the first reproducible MikrOS ELKS base image.

### M0 exit criteria

A clean modern build host can reproducibly build a documented MikrOS ELKS image and an automated reference emulator can boot it to a usable shell on the PC/XT-class target.

## M1 — Useful base system

Console, shell, filesystem utilities, editor, system configuration and robust disk-image generation.

## M2 — Communications

Serial tooling and networking profiles using capabilities available in ELKS and target hardware.

## M3 — Distribution packaging

Implement the shared MikrOS package/repository model for ELKS resource constraints. MPK metadata, repository semantics and host-side tooling should be shared where practical; the on-target installer/runtime implementation may be ELKS-specific and must remain small.
