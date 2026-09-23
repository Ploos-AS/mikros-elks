# MikrOS ELKS

**MikrOS ELKS** is an ELKS-based distribution for extremely resource-constrained 16-bit x86 systems.

Its goal is to make IBM PC/XT/AT-class machines useful rather than merely demonstrate that they can boot.

## Goals

- Treat 8086/8088-class systems as first-class targets.
- Keep RAM and storage requirements extremely small.
- Provide a useful shell, filesystems, serial communications and networking where supported.
- Prefer tiny ELKS-native solutions over compatibility layers.
- Support reproducible cross-builds on modern hosts.
- Qualify releases in emulators before requiring vintage hardware.

## Initial platform family

8086/8088 is the primary minimum reference, with 80186/80188, 80286 and 80386+ compatibility targets. Exact RAM/storage requirements will be measured.

## Relationship to MikrOS Linux

MikrOS ELKS and MikrOS Linux are separate distributions. They share philosophy and may share host-side tooling, but do not require identical userspaces, package managers or binaries. ELKS must never become heavier merely to resemble MikrOS Linux.

## M0

M0 establishes the distribution architecture, reference machine, reproducible build and qualification contract. See `ROADMAP.md` and `docs/targets.md`.

## License

Software authored specifically for MikrOS is intended to use the MIT License unless an imported component requires its upstream license. Third-party components retain their respective licenses.
