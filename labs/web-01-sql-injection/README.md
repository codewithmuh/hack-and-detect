# web-01 · SQL Injection Login Bypass

**Track:** Web Exploitation · **Difficulty:** Easy · **Time:** ~15 min

## The idea (2 min)

A login form takes your username and password and looks you up in a database.
If the app builds its SQL query by **pasting your input straight into a string**,
your input can change what the query *means* — not just what it searches for.

This app runs:

```sql
SELECT secret FROM users WHERE username = '<you>' AND password = '<you>'
```

Send the username `admin' -- ` and the query becomes:

```sql
SELECT secret FROM users WHERE username = 'admin' -- ' AND password = '...'
```

`--` starts a SQL comment, so the password check is erased. You log in as admin
without a password, and the app returns admin's secret.

## The target

`make up` starts a Flask login API on `http://127.0.0.1:8080` (localhost only).
Your goal: retrieve the secret flag `HND{...}` without knowing the password.

```bash
make up
```

## Attack (hack)

```bash
make attack
```

It first tries an honest wrong-password login (fails, `HTTP 401`), then sends the
injection `admin' -- ` and prints the exfiltrated secret. Read
[`attack/exploit.sh`](attack/exploit.sh) — every step is commented.

## Detect (blue)

```bash
make detect
```

The detection ([`detect/sigma-sqli.yml`](detect/sigma-sqli.yml)) keys on SQLi
tokens — comment sequences (`--`, `/*`), tautologies (`or 1=1`), and stray quotes
in the username field — appearing in the login logs. `detect.sh` runs that same
logic with `grep` so you see the alert fire on the request you just sent. In a
real SOC this rule lives in your SIEM (Splunk/Elastic) instead of grep.

## Fix

See [`fix/README.md`](fix/README.md): parameterize the query so input is treated
as data, never as SQL. Apply it, rebuild, and re-run `make attack` — the
injection now returns `401`.

## Verify

```bash
make verify   # PASS only if you exploited it AND the detection caught it
```

## Going deeper

- OWASP: https://owasp.org/www-community/attacks/SQL_Injection
- PortSwigger SQLi labs: https://portswigger.net/web-security/sql-injection
