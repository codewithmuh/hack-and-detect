# web-02 · Command Injection

**Track:** Web Exploitation · **Difficulty:** Easy · **Time:** ~15 min

## The idea (2 min)

Lots of apps shell out to a system command — a "ping this host" tool, a PDF
converter, an image resizer. If the app builds that command by **pasting your
input into a shell string**, you can append your own command with a shell
metacharacter like `;`, `|`, or `$(...)`. The server then runs *your* command
too. That's **OS command injection** — often a direct path to full server
takeover ([OWASP](https://owasp.org/www-community/attacks/Command_Injection),
MITRE [T1059](https://attack.mitre.org/techniques/T1059/)).

This app runs `ping -c 1 <host>` in a shell. Send
`host = 127.0.0.1; cat /flag` and it runs:

```sh
ping -c 1 127.0.0.1 ; cat /flag
```

— ping, then print the flag file back to you.

## The target

`make up` starts a "network tools" API on `http://127.0.0.1:8080` (localhost
only). Goal: read the file `/flag` off the server.

```bash
make up
```

## Attack (hack)

```bash
make attack
```

It shows the intended use (plain ping), then injects `; cat /flag` to read the
flag, and demos `; whoami` to prove arbitrary command execution. Read
[`attack/exploit.sh`](attack/exploit.sh) — every step is commented.

## Detect (blue)

```bash
make detect
```

The detection ([`detect/sigma-cmdi.yml`](detect/sigma-cmdi.yml)) keys on shell
metacharacters (`;`, `|`, `&&`, `$(`, backticks) and common command names
(`cat`, `whoami`, `/etc/passwd`) in the request parameter. `detect.sh` runs that
logic with `grep` so you see the alert fire on your own request. In production
this rule lives in your SIEM or WAF.

## Fix

See [`fix/README.md`](fix/README.md): drop the shell (`subprocess.run([...])`
with an argument list) and validate the host against a strict allowlist. Apply
it, rebuild, and re-run `make attack` — the injection returns `400`.

## Verify

```bash
make verify   # PASS only if you got command execution AND the detection caught it
```

## Going deeper

- OWASP: https://owasp.org/www-community/attacks/Command_Injection
- PayloadsAllTheThings (command injection): https://github.com/swisskyrepo/PayloadsAllTheThings
