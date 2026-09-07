# Capstone

By now you've broken, detected, and fixed dozens of targets. The capstone turns
scattered labs into one system and proves you can operate end-to-end.

## 1. Your home lab (you already have it)

This repo *is* a home lab — every target runs with one command, no VM sprawl. To
extend it toward a realistic environment:

- Run a persistent **SIEM** (ELK or a free Splunk instance) and pipe every lab's
  logs into it (Track 5).
- Keep targets running and practice **hunting** across combined logs.
- Add your own vulnerable service and write the detection for it — the ultimate
  test of the attack→detect→fix loop.

Prefer full VMs? The classic path still works: VirtualBox/VMware + a vulnerable
box (e.g. Metasploitable, a Windows AD lab) + a monitoring VM. Our labs teach the
same skills with far less setup.

## 2. Apply it on public CTFs

These skills transfer directly. Map what you learned here to:

| Platform | Best for | Maps to |
|---|---|---|
| TryHackMe | Guided beginner rooms | Foundations, Tracks 1–3 |
| Hack The Box | Realistic pentest machines | Tracks 2–4 |
| VulnHub | Offline vulnerable VMs | Tracks 2–3 |
| Blue Team Labs / CyberDefenders | Defensive / DFIR | Tracks 5–6 |

Do a box, then write it up in your own words — that writeup is portfolio gold.

## 3. Integration project

Chain multiple tracks into one scenario and document the whole story:

1. **Recon** a target network (Track 1)
2. **Get a foothold** via a web vuln (Track 3)
3. **Escalate** on the host (Track 2)
4. **Move laterally** through AD (Track 4)
5. **Detect** the entire chain in your SIEM (Track 5)
6. **Respond**: build the timeline and incident report (Track 6)

Write it up as a single "attack & defense" case study. This one document shows a
recruiter you understand both sides — which almost no entry-level candidate can
demonstrate.

Next: package it in [`../career/`](../career/).
