#!/usr/bin/env python3
import os
import select
import subprocess
import sys
import time

image = sys.argv[1] if len(sys.argv) > 1 else "out/pcxt/image/fd1440.img"
logpath = sys.argv[2] if len(sys.argv) > 2 else "out/pcxt/qemu-smoke.log"

qemu = "qemu-system-i386"
version = subprocess.check_output([qemu, "-version"], text=True)
accel = ["-singlestep"]
if "version 9" in version or "version 10" in version:
    accel = ["-accel", "tcg,one-insn-per-tb=on"]

cmd = [qemu, *accel, "-nodefaults", "-name", "MikrOS ELKS M0",
       "-machine", "isapc", "-cpu", "486,tsc", "-m", "8M",
       "-display", "none", "-serial", "stdio", "-monitor", "none",
       "-drive", f"file={image},format=raw,if=floppy", "-boot", "a"]

p = subprocess.Popen(cmd, stdin=subprocess.PIPE, stdout=subprocess.PIPE,
                     stderr=subprocess.STDOUT, bufsize=0)
deadline = time.monotonic() + 120
buf = bytearray()
sent_login = False
sent_test = False

tests = (
    "echo MIKROS_M0_SHELL\n"
    "cat /etc/passwd >/dev/null && echo MIKROS_M0_CAT\n"
    "ls / >/dev/null && echo MIKROS_M0_LS\n"
    "mkdir /tmp/m0test && echo MIKROS_M0_MKDIR\n"
    "echo x >/tmp/m0test/file\n"
    "rm /tmp/m0test/file && echo MIKROS_M0_RM\n"
    "ps >/dev/null && echo MIKROS_M0_PS\n"
    "meminfo >/dev/null && echo MIKROS_M0_MEMINFO\n"
    "/bin/echo MIKROS_M0_FORKEXEC\n"
    "echo MIKROS_M0_USEFUL_PASS\n"
)

try:
    while time.monotonic() < deadline:
        ready, _, _ = select.select([p.stdout], [], [], 0.5)
        if ready:
            chunk = os.read(p.stdout.fileno(), 4096)
            if not chunk:
                break
            buf.extend(chunk)
            text = buf.decode("latin-1", errors="replace")
            if not sent_login and "login:" in text:
                p.stdin.write(b"root\n")
                p.stdin.flush()
                sent_login = True
            if sent_login and not sent_test and ("# " in text or "$ " in text):
                p.stdin.write(tests.encode("ascii"))
                p.stdin.flush()
                sent_test = True
            if "MIKROS_M0_USEFUL_PASS" in text:
                break
        if p.poll() is not None:
            break
finally:
    try:
        p.terminate()
        p.wait(timeout=5)
    except Exception:
        p.kill()
    os.makedirs(os.path.dirname(logpath) or ".", exist_ok=True)
    with open(logpath, "wb") as f:
        f.write(buf)

text = buf.decode("latin-1", errors="replace")
required = [
    "MIKROS_M0_SHELL", "MIKROS_M0_CAT", "MIKROS_M0_LS",
    "MIKROS_M0_MKDIR", "MIKROS_M0_RM", "MIKROS_M0_PS",
    "MIKROS_M0_MEMINFO", "MIKROS_M0_FORKEXEC", "MIKROS_M0_USEFUL_PASS"
]
missing = [m for m in required if m not in text]
if missing:
    print(text)
    print("FAIL: missing guest markers: " + ", ".join(missing), file=sys.stderr)
    sys.exit(1)

print("PASS: ELKS M0 guest shell/userspace contract")
