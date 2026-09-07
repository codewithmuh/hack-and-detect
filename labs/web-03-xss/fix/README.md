# Fix — encode output + Content-Security-Policy

## What to change

Escape user input for the HTML context, and add a CSP header. See
[`app_fixed.py`](app_fixed.py):

```python
from markupsafe import escape   # bundled with Flask

safe_q = escape(q)              # <script> -> &lt;script&gt;
resp = Response(PAGE.format(q=safe_q), mimetype="text/html")
resp.headers["Content-Security-Policy"] = "default-src 'self'; script-src 'self'"
```

Try it:

```bash
cp fix/app_fixed.py app/app.py
make down && make up
make attack        # the payload now comes back as escaped text, not markup
```

## Why it works

XSS happens when input meant as **data** (a search term) is interpreted as
**code** (HTML/JS) by the browser. Output encoding converts the dangerous
characters — `<`, `>`, `"`, `&` — into HTML entities, so `<script>` displays as
the literal text `<script>` and the browser never treats it as a tag.

**CSP** is the second layer: `script-src 'self'` tells the browser to run script
only from your own origin and to refuse inline `<script>`, so even a missed
encoding doesn't execute.

## The general rule

- **Encode on output, for the right context** (HTML body, attribute, JS, URL each
  differ). Most template engines (Jinja2, React) auto-escape — don't defeat them
  with "raw"/`|safe`/`dangerouslySetInnerHTML` on untrusted data.
- **Validate on input** as a bonus, not the primary defense.
- **Add CSP** as defense in depth.

Same core lesson as [web-01](../../web-01-sql-injection/) and
[web-02](../../web-02-command-injection/): keep **data** and **code** separate.
