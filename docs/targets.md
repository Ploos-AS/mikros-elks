# Target qualification

## Primary M0 reference

The primary M0 platform is an IBM PC/XT-class 8088/8086 system. MikrOS ELKS is designed for the smallest useful target rather than developed on a fast machine and reduced later.

## Initial matrix

| CPU/platform | Role | Status |
| --- | --- | --- |
| 8088/8086 PC/XT class | Minimum reference | M0 target |
| 80186/80188 | Compatibility target | Planned |
| 80286 PC/AT class | Compatibility target | Planned |
| 80386+ | Compatibility/performance target | Planned |

## Qualification layers

M0 deliberately separates fast public CI from minimum-CPU qualification.

### QEMU CI gate

QEMU with the ISA PC machine is the mandatory build/boot smoke gate. It verifies that the pinned ELKS source builds, produces the expected floppy image, boots through the PC-compatible ISA path and emits an observable ELKS console transcript.

QEMU is **not** evidence that the minimum 8088/8086 CPU baseline has passed: the ELKS QEMU reference path uses a later x86 CPU model.

### 86Box minimum-CPU gate

86Box is the authoritative emulator gate for the M0 8088/8086 baseline because it provides low-level emulation of period-correct PC/XT-class machines and CPUs.

This gate is ROM-dependent. MikrOS does not distribute, vendor, download or commit copyrighted machine firmware. The 86Box qualification therefore runs only in an environment where the operator has independently supplied the required legal ROM set.

A minimum-CPU PASS requires:

1. a documented 86Box version and machine configuration;
2. an actual 8088 or 8086 CPU selection;
3. the same MikrOS ELKS image that passed the QEMU CI gate;
4. successful boot to an interactive console/shell;
5. basic filesystem/process command smoke tests;
6. captured qualification metadata and logs;
7. measured guest RAM and image size.

Until this gate passes, the target status remains **PC/XT boot-qualified / 8088-8086 CPU unqualified**.


## RAM qualification

RAM qualification is measured on the authoritative 8088/8086 gate, not inferred
from upstream documentation. Test, in descending order, 640, 512, 384 and 256
KiB of conventional RAM.

Each size has three independent outcomes:

- **BOOT** — kernel reaches an observable console;
- **SHELL** — an interactive shell starts successfully;
- **USEFUL** — the shell can execute the M0 command set, including at least
  filesystem inspection, process inspection and a fork/exec command.

The MikrOS minimum RAM claim is the lowest size that passes the criterion being
claimed. The default/recommended M0 baseline is the lowest size that passes
**USEFUL**, not merely **BOOT**. No value is promoted to supported status until
the result has been captured on the 8088/8086 qualification gate.

## General qualification requirements

A supported reference target must build reproducibly from a modern host, boot in an automatable emulator, reach a working console and shell, execute basic filesystem/process commands, support the documented image layout, record conventional-memory use and image size, and pass architecture-appropriate smoke tests.

M0 will measure actual minimum RAM rather than adopting an unverified memory target.

## Firmware policy

No proprietary PC BIOS, option ROM or other copyrighted firmware is stored in this repository or downloaded by its CI. Qualification scripts must fail clearly when required external firmware is absent.

## Future profiles

Potential profiles are minimal, base, net, server and dev. These are goals, not M0 compatibility promises.
