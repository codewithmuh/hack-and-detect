# Hack & Detect

**Learn cybersecurity by breaking things — then detecting and fixing them.**

Every lab in this repo runs with one command, gives you a target to attack, a
detection to catch the attack you just ran, and a fix that kills it. You finish
with a portfolio of exploits, detection rules, and writeups — not a checklist.

```bash
cd labs/web-01-sql-injection
make up        # spin up the vulnerable target
make attack    # run the exploit
make detect    # see the detection fire on your own attack
make verify    # grade yourself — PASS/FAIL
make down      # tear it down
```

---

## Why this repo is different

Most free cybersecurity resources are link dumps you read and forget. Hack &
Detect is built on four rules:

1. **Runnable, not readable.** `make up` and the target exists. No multi-hour VM
   setup tax before you learn anything.
2. **Red *and* blue in every lab.** You exploit the target, then write/run the
   detection that catches exactly what you did. Attack and defense in one place.
3. **Self-grading.** `verify.sh` prints `PASS`/`FAIL`, so progress is objective.
4. **Portfolio output.** By the end you have ~40 detection rules, ~30 writeups,
   and a home lab — a GitHub profile that gets interviews.

---

## Requirements

- Docker + Docker Compose
- `make`, `curl`, `bash`
- That's it. Each lab pins the rest.

---

## Tracks

Labs are grouped by skill, not by day. Do them in order, or jump to the topic
you need. Want the challenge format? See [`PATHS/100-day-plan.md`](PATHS/100-day-plan.md).

| Track | Focus | Labs |
|-------|-------|------|
| 1 — Network & Traffic | Packet analysis, scanning, protocols | 12 |
| 2 — Linux & Windows Attack | Privilege escalation, persistence | 18 |
| 3 — Web Exploitation | OWASP Top 10, hands-on | 20 |
| 4 — Active Directory | Kerberos, lateral movement | 15 |
| 5 — Detection Engineering | Sigma, Splunk, log analysis | 20 |
| 6 — Incident Response & DFIR | Triage, forensics, timelines | 15 |

> Labs land here as they ship. Track your progress in your own fork's
> [`PROGRESS.md`](PROGRESS.md).

---

## How a lab is structured

```
labs/web-01-sql-injection/
├── README.md          # 5-minute theory, no filler
├── docker-compose.yml # the vulnerable environment
├── Makefile           # up / attack / detect / verify / down
├── app/               # the target
├── attack/            # runnable exploit steps
├── detect/            # the Sigma rule + detection script
├── fix/               # the hardening that kills the bug
├── verify.sh          # grades you: PASS/FAIL
└── FLAG               # proof of completion (hashed)
```

New labs follow [`labs/_template/`](labs/_template/). See
[`CONTRIBUTING.md`](CONTRIBUTING.md) to add one.

---

## Getting started

```bash
git clone https://github.com/codewithmuh/hack-and-detect
cd hack-and-detect/labs/web-01-sql-injection
make up && make attack
```

Then read the lab README, run the detection, apply the fix, and `make verify`.

---

## License

Code and lab content: [MIT](LICENSE). Built by
[@codewithmuh](https://youtube.com/@codewithmuh). Break responsibly — only
attack the targets in this repo or systems you own.
