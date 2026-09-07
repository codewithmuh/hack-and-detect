# Fix — rate-limit and block scanners

## What to change

Swap the sensor for the hardened version in [`sensor_fixed.py`](sensor_fixed.py):

```bash
cp fix/sensor_fixed.py app/sensor.py
make down && make up
make attack        # the sweep now gets blocked before it finds port 9007
```

## Why it works

The vulnerable sensor answers every connection, so a scanner maps all 21 ports in
under a second and finds the hidden service. The fix tracks how many **distinct
ports** each source touches within a short window. Cross the threshold and the
source is flagged as a scanner and dropped — so the sweep trips the limiter before
it can enumerate the range, and the hidden admin banner on 9007 stays hidden.

This is the same idea real defenses use:

- **iptables** `recent` module / `hashlimit` to drop rapid new connections
- **fail2ban** watching connection logs and banning noisy IPs
- Cloud **security groups / NACLs** exposing only the ports that must be open
- An **IDS/IPS** (Suricata) with a port-scan rule that resets scanner sessions

## The real lesson

You can't fully "patch away" scanning — anyone can send packets. What you *can* do
is (1) **reduce attack surface** (expose only needed ports), (2) **detect** the
scan (the Sigma rule in this lab), and (3) **slow/deny** the scanner so discovery
becomes expensive and loud. Detection + friction, not a silver bullet.
