# web-03 · Reflected XSS

**Track:** Web Exploitation · **Difficulty:** Easy · **Time:** ~15 min

## The idea (2 min)

**Cross-Site Scripting (XSS)** is when an app puts your input into a page without
encoding it, so the browser runs it as HTML/JavaScript. In *reflected* XSS the
payload rides in a URL: you send a victim a crafted link, and when they open it
your script runs **in their session** — you can steal their cookies, act as them,
or capture what they type ([OWASP](https://owasp.org/www-community/attacks/xss/),
MITRE [T1059.007](https://attack.mitre.org/techniques/T1059/007/)).

This app echoes your search term straight into the results HTML. Send
`<script>...</script>` and it comes back as real markup.

## The target

`make up` starts a product-search page on `http://127.0.0.1:8080` (localhost
only). Goal: get an injected `<script>` to reflect unescaped in the response.

```bash
make up
```

## Attack (hack)

```bash
make attack
```

It runs a normal search, then injects `<script>alert(document.domain)</script>`
and confirms it's reflected unescaped. It also prints the real weaponized payload
you'd send a victim to exfiltrate their cookie. Read
[`attack/exploit.sh`](attack/exploit.sh) — each step is commented.

> No browser needed here: reflecting the raw `<script>` *is* the vulnerability —
> a real victim's browser is what would execute it. To see the `alert()` pop for
> a video, just open the printed URL in a browser once the target is up.

## Detect (blue)

```bash
make detect
```

The detection ([`detect/sigma-xss.yml`](detect/sigma-xss.yml)) keys on injection
markers — `<script`, `<img`, `<svg`, `onerror=`, `onload=`, `javascript:` — in the
request parameter. `detect.sh` runs it with `grep` so you see the alert fire on
your own request. In production this lives in a WAF or your SIEM.

## Fix

See [`fix/README.md`](fix/README.md): HTML-encode output (`markupsafe.escape`) so
the payload renders as text, and add a `Content-Security-Policy` header as a
second layer. Apply it, rebuild, and re-run `make attack` — the payload comes
back escaped.

## Verify

```bash
make verify   # PASS only if the payload reflects unescaped AND the detection fires
```

## Going deeper

- OWASP XSS: https://owasp.org/www-community/attacks/xss/
- Content Security Policy: https://developer.mozilla.org/docs/Web/HTTP/CSP
