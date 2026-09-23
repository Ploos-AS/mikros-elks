# Emulator qualification

MikrOS ELKS uses emulator-first qualification.

## Tier 1 — EMU86

EMU86 is the preferred strict minimum-system qualification candidate because it can run ELKS in a minimal PC/XT/AT configuration and provides pseudo-terminal I/O suitable for automation.

Primary purpose:

- 8086/8088-oriented minimum-system testing
- serial/console automation
- deterministic smoke tests
- low-level debugging

## Tier 1 — QEMU

QEMU is the broadly available CI/reference emulator.

Primary purpose:

- build smoke testing
- boot/image regression
- CI availability
- networking tests where appropriate

QEMU does not by itself prove cycle-accurate or strict original-PC compatibility.

## Later compatibility qualification

DOSBox-X, Bochs, PCem/MartyPC and real hardware may be used as additional compatibility targets. They are not required to close M0.

## M0 pass

An image passes emulator qualification when an automated run reaches a MikrOS shell, executes the smoke-test command sequence, records the result and terminates without an unexpected kernel failure.
