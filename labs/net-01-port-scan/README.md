# net-01 · Port Scan Detection

**Track:** Network & Traffic · **Difficulty:** Easy · **Time:** ~15 min

## The idea (2 min)

Before attacking anything, an intruder maps what's listening. A **port scan**
connects to a range of ports to see which are open, then grabs each service's
**banner** to identify it. It's step one of almost every intrusion — MITRE
ATT&CK calls it *Network Service Discovery* ([T1046](https://attack.mitre.org/techniques/T1046/)).

Scanning is noisy: one source touching many ports in seconds is a pattern you can
detect. This lab has you run the scan, catch it, then blunt it.

## The target

`make up` starts a sensor listening on `127.0.0.1:9000-9020`. Most ports just
answer and close. **One** hidden "admin" port serves a banner containing the flag
`HND{...}` — but you don't know which. Find it by scanning.

```bash
make up
```

## Attack (hack)

```bash
make attack
```

It sweeps ports 9000–9020 with bash's built-in `/dev/tcp` (no nmap needed), lists
the open ports, grabs each banner, and prints the flag from the hidden service.
Read [`attack/exploit.sh`](attack/exploit.sh) — each step is commented.

> On a real network you'd do this with `nmap -sV 10.0.0.5`. Same idea, more speed
> and fingerprinting. We use `/dev/tcp` so the lab needs zero extra tools.

## Detect (blue)

```bash
make detect
```

The detection ([`detect/sigma-portscan.yml`](detect/sigma-portscan.yml)) is an
**aggregation** rule: any single source that connects to more than 10 *distinct*
ports in a short window is scanning. `detect.sh` runs that count with `awk`
against the sensor's connection log, so you see the alert fire on your own scan.
In production this rule lives in your SIEM (Splunk/ELK) or your IDS (Suricata).

## Fix

See [`fix/README.md`](fix/README.md): the hardened sensor rate-limits and blocks a
source once it trips the scan threshold, so the sweep is cut off before it finds
port 9007. Reduce attack surface + detect + add friction — there's no single
"patch" for scanning.

## Verify

```bash
make verify   # PASS only if you found the service by scanning AND detected the scan
```

## Going deeper

- MITRE T1046: https://attack.mitre.org/techniques/T1046/
- nmap basics: https://nmap.org/book/man-briefoptions.html
