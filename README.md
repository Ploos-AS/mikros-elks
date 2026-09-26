# MikrOS ELKS

**MikrOS ELKS** is the ELKS kernel/backend target of MikrOS for extremely resource-constrained 16-bit x86 systems.

MikrOS is one operating-system/distribution architecture across supported kernels. Linux and ELKS are backend targets, not separate products. The ELKS target keeps the common MikrOS model where practical while remaining small enough for machines in the IBM PC/XT/AT class.

## Goals

- Treat 8086/8088-class systems as first-class targets.
- Keep RAM and storage requirements extremely small.
- Provide a useful shell, filesystems, serial communications and networking where supported.
- Share MikrOS package metadata, repository concepts, build conventions, configuration model and administration UX where practical.
- Prefer tiny ELKS-native implementations when Linux-oriented components are not viable.
- Support reproducible cross-builds on modern hosts.
- Qualify releases in emulators before requiring vintage hardware.

## Initial platform family

8086/8088 is the primary minimum reference, with 80186/80188, 80286 and 80386+ compatibility targets. Exact RAM/storage requirements will be measured during qualification.

## Relationship to MikrOS Linux

MikrOS ELKS and MikrOS Linux are two kernel/backend targets of the same MikrOS architecture.

They should share, where practical:

- package recipe and repository concepts,
- package naming and metadata,
- host-side build tooling,
- system configuration conventions,
- service-management concepts,
- release/version policy,
- user-facing administration conventions.

They do **not** require identical binaries, libc, init implementations or command implementations. ELKS-specific replacements are expected whenever Linux-oriented components would make the target unnecessarily heavy or impossible to support.

## M0

M0 establishes the ELKS backend architecture, reference machine, reproducible build and qualification contract. See `ROADMAP.md` and `docs/targets.md`.

## License

Software authored specifically for MikrOS is intended to use the MIT License unless an imported component requires its upstream license. Third-party components retain their respective licenses.
