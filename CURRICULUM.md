# Curriculum

Hack & Detect covers the full path from networking fundamentals to a job-ready
portfolio. Everything a 90-day-style study plan gives you is here — **plus** the
thing those plans skip: for every attack you learn, you also learn to *detect*
and *fix* it, and you finish with runnable proof instead of a checklist.

Work top to bottom, or jump to any track. Want a day-by-day schedule? See
[`PATHS/100-day-plan.md`](PATHS/100-day-plan.md).

---

## How this maps to (and beats) a day-based study plan

| Standard study-plan topic | Where it lives here | Our added angle |
|---|---|---|
| Network fundamentals (Network+) | [Foundations F1](foundations/) | Applied immediately in Track 1 labs |
| Security principles (Security+) | [Foundations F2](foundations/) | Mapped to real detections, not just theory |
| Linux OS & shell | [Foundations F3](foundations/) | Used as the attack/defense platform throughout |
| Python for security | [Foundations F4](foundations/) | You *write* the exploit and detection tooling |
| Git & workflow | [Foundations F5](foundations/) | You version your own lab writeups & rules |
| Traffic analysis (Wireshark/tcpdump/Suricata) | Track 1 | Capture → detect → tune a rule |
| SIEM / ELK Stack | Track 5 | Ship your own Sigma rules into a SIEM |
| Cloud security (AWS/GCP/Azure) | Track 7 | Misconfig → exploit → detect → harden |
| Ethical hacking / pentest (HTB/Vulnhub style) | Tracks 2–4 | Self-hosted, one-command, self-grading |
| Home lab setup | [Capstone](capstone/) | The repo *is* the home lab |
| Resume / career / interview prep | [Career](career/) | Portfolio auto-built from your finished labs |

---

## Foundations — start here if you're new

Concise, in-our-own-words primers. Read fast, then start doing labs.

- **F1 · Networking** — OSI/TCP-IP model, IP/subnetting, TCP/UDP, DNS, HTTP(S),
  routing, switching, ports & protocols. (Network+ scope.)
- **F2 · Security principles** — CIA triad, risk management, threats vs
  vulnerabilities vs exploits, access control, cryptography basics, compliance
  (Security+ scope), MITRE ATT&CK, the kill chain.
- **F3 · Linux essentials** — shell, filesystem, permissions, users/groups,
  processes, systemd, logging, package managers, bash scripting.
- **F4 · Python for security** — syntax, data structures, files, `requests`,
  sockets, parsing logs, writing small offensive and defensive tools.
- **F5 · Git & workflow** — clone/branch/commit/PR, versioning your notes,
  detections, and lab writeups so your work is reviewable.

See [`foundations/`](foundations/).

---

## Hands-on tracks — attack → detect → fix

Each lab: spin up a target, exploit it, detect your own attack, harden it,
self-grade. Grouped by skill, not by day.

### Track 1 — Network & Traffic Analysis (12 labs)
Scanning & enumeration ✅, packet capture and reading (Wireshark, tcpdump),
protocol abuse (ARP spoofing, DNS, DHCP), IDS/IPS with Suricata & Zeek, writing
and tuning network detection rules.

### Track 2 — Linux & Windows Attack (18 labs)
Enumeration, credential attacks, privilege escalation (SUID, sudo, cron,
kernel), Windows privesc, persistence, log evasion — and the audit/EDR
detections that catch each.

### Track 3 — Web Exploitation (20 labs)
OWASP Top 10 hands-on: SQL injection ✅, XSS, CSRF, SSRF, auth bypass, IDOR,
command injection, file upload, deserialization, SSTI — each with a WAF/log
detection and the code fix.

### Track 4 — Active Directory (15 labs)
Kerberoasting, AS-REP roasting, pass-the-hash, lateral movement, delegation
abuse, DCSync, Golden/Silver tickets — plus the Windows event & Sigma detections.

### Track 5 — Detection Engineering & SIEM (20 labs)
Log pipelines, the ELK Stack (Elasticsearch, Logstash, Kibana), Splunk queries,
writing Sigma rules, mapping to MITRE ATT&CK, reducing false positives, building
dashboards and alerts.

### Track 6 — Incident Response & DFIR (15 labs)
Triage, memory & disk forensics, log timeline building, malware behavior
analysis, containment & eradication, writing the incident report.

### Track 7 — Cloud Security (12 labs)
AWS / GCP / Azure: IAM misconfigurations, exposed storage, over-permissioned
roles, metadata-service abuse (SSRF → creds), CloudTrail/audit-log detection,
and infrastructure hardening.

---

## Capstone

- **Home lab** — you already have it: this repo. Guide to extending it with your
  own vulnerable VMs and a small SOC (SIEM + detections) in
  [`capstone/`](capstone/).
- **CTF practice** — how to apply these skills on TryHackMe / Hack The Box /
  VulnHub, and how each maps back to a track here.
- **Integration project** — chain networking + Linux + web + detection into one
  end-to-end attack-and-defense scenario.

See [`capstone/`](capstone/).

---

## Career

- **Portfolio** — your finished labs, detection rules, and writeups *are* your
  portfolio. How to package them on GitHub so recruiters see proof.
- **Resume** — cybersecurity resume template + how to turn labs into bullet points.
- **Job search & interview** — entry-role paths (SOC analyst, pentester, blue
  team), CyberSeek/LinkedIn strategy, and STAR interview prep.

See [`career/`](career/).

---

✅ = shipped · everything else lands lab-by-lab. Track your own progress in
[`PROGRESS.md`](PROGRESS.md).
