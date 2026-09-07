# det-01 · Brute-Force Detection

**Track:** Detection Engineering & SIEM · **Difficulty:** Easy · **Time:** ~20 min

## The idea (2 min)

This is a **blue-team** lab. The service isn't buggy — it just logs logins. Your
job is the detection engineer's craft: generate an attack, then write a rule that
catches it with **few false positives**.

Password **brute force** ([MITRE T1110](https://attack.mitre.org/techniques/T1110/))
is loud — lots of failed logins. But "many failures" alone is a noisy alert
(users fat-finger passwords). The high-signal event is **many failures for an
account followed by a success from the same source** — that's a likely
*compromise*, not just noise. Good detection engineering is about picking that
signal.

## The target

`make up` starts a login service on `http://127.0.0.1:8080` (localhost only) with
a weak admin password. It logs every attempt to `/var/log/app/auth.log` as
`result=success|failure src=<ip> user=<name>`.

```bash
make up
```

## Attack (generate the telemetry)

```bash
make attack
```

It brute-forces `admin` with a small wordlist until it succeeds and grabs the
flag — producing a burst of `failure` lines then a `success`, all from one source.

## Detect (the main event)

```bash
make detect
```

The rule ([`detect/sigma-bruteforce.yml`](detect/sigma-bruteforce.yml)) is
**stateful**: it correlates ≥5 failures for a `src`+`user` *followed by* a success
for the same pair, and reports the compromised account and attacker IP.
`detect.sh` implements that correlation with `awk`; in a SIEM it's an
event-sequence search (Splunk `transaction`/`stats`, Elastic EQL sequence).

**Tuning matters** — read the `falsepositives` notes in the rule. A few failures
then success is normal; five-plus then success from one IP is not. This trade-off
*is* detection engineering.

## Fix

See [`fix/README.md`](fix/README.md): add **account lockout / rate limiting** so
the brute force can't reach the right password. Detection tells you it happened;
lockout stops it. You want both.

## Verify

```bash
make verify   # PASS only if the brute force worked AND your detection caught it
```

## Going deeper

- MITRE T1110: https://attack.mitre.org/techniques/T1110/
- Sigma project: https://github.com/SigmaHQ/sigma
