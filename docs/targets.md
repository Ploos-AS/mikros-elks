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

## Qualification requirements

A supported reference target must build reproducibly from a modern host, boot in an automatable emulator, reach a working console and shell, execute basic filesystem/process commands, support the documented image layout, record conventional-memory use and image size, and pass architecture-appropriate smoke tests.

M0 will measure actual minimum RAM rather than adopting an unverified memory target.

## Future profiles

Potential profiles are minimal, base, net, server and dev. These are goals, not M0 compatibility promises.
