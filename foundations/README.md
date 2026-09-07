# Foundations

New to security? Start here. These are fast, plain-English primers — enough to
start doing labs, not a textbook. Each links out to the best free deep-dives so
we don't reinvent them. Written in our own words; do them in order.

> Rule of thumb: skim a foundation, then go break something in the matching
> track. You learn the theory faster once you've seen the attack.

---

## F1 · Networking

**Covers (Network+ scope):**
- OSI and TCP/IP models, encapsulation
- IPv4/IPv6, subnetting, CIDR, NAT
- TCP vs UDP, the 3-way handshake, common ports
- DNS, DHCP, ARP, ICMP
- HTTP/HTTPS, TLS basics
- Switching, routing, VLANs, firewalls
- Wi-Fi and wireless basics

**Then do:** Track 1 — Network & Traffic Analysis.
**Go deeper:** Professor Messer Network+ (free), Julia Evans networking zines.

---

## F2 · Security principles

**Covers (Security+ scope):**
- CIA triad (confidentiality, integrity, availability)
- Threats vs vulnerabilities vs risk vs exploit
- Risk management, controls (preventive/detective/corrective)
- Authentication, authorization, accounting (AAA); access-control models
- Cryptography basics: hashing, symmetric/asymmetric, TLS, PKI
- Common attack types and social engineering
- Compliance & frameworks: NIST CSF, ISO 27001, GDPR/PCI overview
- The Cyber Kill Chain and MITRE ATT&CK (we use ATT&CK across every track)

**Then do:** any track — you'll map attacks to ATT&CK techniques.
**Go deeper:** Professor Messer Security+ (free), MITRE ATT&CK site.

---

## F3 · Linux essentials

**Covers:**
- Shell navigation, files, pipes, redirection
- Users, groups, permissions (rwx, SUID/SGID, sudo)
- Processes, services, systemd, cron
- Logs (`/var/log`, journald) — the raw material for detection
- Package managers, networking commands
- Bash scripting: variables, loops, conditionals, functions

**Then do:** Track 2 — Linux & Windows Attack.
**Go deeper:** OverTheWire *Bandit* (free, hands-on), Linux Journey.

---

## F4 · Python for security

**Covers:**
- Syntax, data types, control flow, functions
- Lists/dicts/sets, string and file handling
- `requests` for HTTP, `socket` for raw network
- Parsing logs and structured data (JSON, CSV, regex)
- Writing small tools: a port scanner, a log parser, an HTTP fuzzer, a
  detection script

**Then do:** you'll write and read exploit + detection scripts in every track.
**Go deeper:** *Automate the Boring Stuff* (free), *Black Hat Python* (concepts).

---

## F5 · Git & workflow

**Covers:**
- clone, add, commit, push, pull
- branches, merges, pull requests
- `.gitignore`, resolving conflicts
- Using Git to version your **own** notes, detection rules, and lab writeups so
  your work is reviewable and portfolio-ready

**Then do:** fork this repo, track progress in [`PROGRESS.md`](../PROGRESS.md),
push your writeups.
**Go deeper:** GitHub's own *Git Handbook* (free).

---

Once foundations feel comfortable, the tracks in [`CURRICULUM.md`](../CURRICULUM.md)
are where the real learning happens.
