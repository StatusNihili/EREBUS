# Chapter 8 — Installing Basic System Software

Base: Linux From Scratch 13.1-systemd

## Status

Chapter 8 is complete.

Final checkpoint:

- Completed through E2fsprogs 1.47.4
- All Chapter 8 package builds completed
- Final Chapter 8 cleanup completed
- Optional stripping deliberately skipped
- Next stage: LFS Chapter 9 — System Configuration

## Completed packages

1. Man-pages 6.18
2. Iana-Etc 20260805
3. Glibc 2.44
4. Zlib 1.3.2
5. Bzip2 1.0.8
6. Xz 5.8.3
7. Lz4 1.10.0
8. Zstd 1.5.7
9. File 5.48
10. Readline 8.3
11. PCRE2 10.47
12. M4 1.4.21
13. Bc 7.0.3
14. Flex 2.6.4
15. Tcl 8.6.18
16. Expect 5.45.4
17. DejaGNU 1.6.3
18. Ninja 1.13.2
19. Pkgconf 3.0.5
20. Binutils 2.47

## Build settings

Build parallelism is deliberately limited on CLOTHO (Acer Nitro 5 AN515-52):

- MAKEFLAGS=-j4
- TESTSUITEFLAGS=-j4
- NINJAJOBS=4

## Test notes

### Glibc 2.44

Results: 6777 PASS, 581 UNSUPPORTED, 16 XFAIL, 1 FAIL.

The only failure was io/tst-lchmod, which is a documented expected failure in the LFS chroot environment.

### Tcl 8.6.18

47159 total tests: 43704 passed, 3455 skipped, 0 failed.

### Expect 5.45.4

29 passed, 0 failed.

### DejaGNU 1.6.3

300 expected passes.

### Pkgconf 3.0.5

32 passed, 0 failed.

### Binutils 2.47

The critical Binutils test suite was run with make -k check.

The only failure reported was:

FAIL: tmpdir/gp-gmon

This is the documented known gprofng failure for this LFS build and was accepted.

Installed ld, as and objdump report GNU Binutils 2.47.20260726.

Static Binutils libraries were removed according to the LFS instructions.

## Chapter 8 completion

Chapter 8 — Installing Basic System Software — completed successfully on 2026-10-02.

All Chapter 8 packages were built, tested where applicable, installed, and verified.

### EREBUS-specific decisions

- Build parallelism remained limited to `MAKEFLAGS=-j4` to control sustained thermal load on CLOTHO.
- Libffi 3.8.0 was built with `--with-gcc-arch=haswell`, targeting ATROPOS (MacBookAir6,2) rather than the CLOTHO host CPU.
- GRUB 2.14 was built for `x86_64-efi` only, matching the ATROPOS target. No bootloader was installed to a physical disk during Chapter 8.
- The optional Chapter 8 stripping stage was deliberately skipped. Debugging symbols are being retained while EREBUS remains under active development and hardware bring-up.

### Notable expected test results

- Findutils 4.11.0: `test-regex-el` was the sole known test failure.
- Groff 1.24.1: `neqn-smoke-test.sh` was the sole known test failure.
- Tar 1.35: test 233, `capabilities: binary store/restore`, was the sole known failure.
- Vim 9.2.1025: test suite completed with `FAILED: 0`.
- Systemd 261.2: 1829 tests passed, 32 skipped, with only the documented chroot failure `systemd:test-namespace`.
- Procps-ng 4.0.7: 8 tests passed, 0 failed.
- Util-linux 2.42.2: all 367 tests passed.
- E2fsprogs 1.47.4: 393 tests passed; `m_assume_storage_prezeroed` was the sole documented expected failure.

### Final cleanup

The Chapter 8 cleanup was completed:

- `/tmp` contents removed
- obsolete libtool `.la` files removed
- temporary LFS cross-toolchain remnants removed
- temporary `tester` account removed

Verification confirmed no matching temporary toolchain files or `.la` files remained.

## Next step

LFS Chapter 9 — System Configuration.

Before beginning Chapter 9, create and verify an offline Chapter 8 recovery snapshot.

## Recovery snapshot

A complete offline recovery snapshot was created after Chapter 8:

    backups/erebOS-ch8-basic-system.img

Filesystem integrity was checked offline with:

    e2fsck -fn

Result:

    PASS

Snapshot storage:

- logical size: 64 GB
- actual disk usage: approximately 22 GB

This snapshot represents the known-good EREBUS system after completion of LFS Chapter 8 and before beginning Chapter 9.

## Post-build target-hardware validation: GMP portability repair

During later validation on ATROPOS (MacBookAir6,2), GCC 16.2.0 failed while compiling OpenSSH 10.5p1 with:

    cc1: internal compiler error: Illegal instruction

The failure reproduced with a minimal floating-point compilation test on ATROPOS, while the same compiler worked on CLOTHO.

Investigation showed that the installed GMP 6.3.0 header contained host-specific compiler tuning:

    __GMP_CFLAGS = "-mtune=skylake -march=broadwell"

This made the Chapter 8 GMP build unsuitable for the older Haswell-class ATROPOS target.

### Repair

GMP 6.3.0 was rebuilt portably with:

    --host=none-linux-gnu

The rebuilt GMP reported:

    __GMP_CC = "gcc"
    __GMP_CFLAGS = "-O2 -pedantic"

Its test suite completed with:

    199 PASS

Because MPFR and MPC depend on GMP, both were rebuilt against the repaired library:

- MPFR 4.2.2: 198/198 tests passed
- MPC 1.4.1: 75/75 tests passed

The repaired GMP, MPFR and MPC libraries, headers and pkg-config metadata were transferred to ATROPOS and the dynamic linker cache refreshed.

### Target verification

On ATROPOS:

- GCC successfully compiled and executed the minimal floating-point test that had previously caused the illegal-instruction failure.
- GCC's `cc1` was verified to load GMP, MPFR and MPC from `/usr/lib`.
- OpenSSH 10.5p1 `misc.o`, which had previously triggered the compiler failure, compiled successfully.
- The complete OpenSSH build completed successfully.
- The OpenSSH regression suite completed successfully.

Conclusion:

The failure was caused by CPU-specific optimisation leaking from the build host into GMP. Packages that form part of the compiler runtime dependency chain must remain portable across the CLOTHO build host and the ATROPOS production target unless target-specific optimisation is explicitly intentional and verified.
