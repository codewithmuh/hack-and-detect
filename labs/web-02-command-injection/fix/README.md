# Fix — no shell + validate input

## What to change

Swap in the patched app in [`app_fixed.py`](app_fixed.py):

```python
# before (vulnerable): input goes into a shell string
cmd = f"ping -c 1 {host}"
subprocess.run(cmd, shell=True, ...)

# after (safe): no shell, host is one argument, and it's validated first
if not re.match(r"^[A-Za-z0-9.-]{1,253}$", host):
    return jsonify(error="invalid host"), 400
subprocess.run(["ping", "-c", "1", host], ...)   # shell=False (default)
```

Try it:

```bash
cp fix/app_fixed.py app/app.py
make down && make up
make attack        # the injection now returns 400 / no flag
```

## Why it works

**The root cause is the shell.** With `shell=True`, the string `ping -c 1
127.0.0.1; cat /flag` is handed to `/bin/sh`, which happily treats `;` as "run a
second command." Passing an **argument list** with `shell=False` means the OS
executes `ping` directly and gives it `127.0.0.1; cat /flag` as one literal
argument — there is no shell to interpret the `;`, so ping just fails to resolve
that "hostname." The injected command never runs.

**Input validation** is the second layer: a strict allowlist regex rejects
anything that isn't a plausible hostname/IP before it reaches the command, so
even a future refactor that reintroduces a shell has less to work with.

## The general rule

Never build a shell command by string-formatting untrusted input. Prefer APIs
that take argument arrays (`subprocess.run([...])`, `execve`), avoid `shell=True`,
and validate/allowlist input. Same lesson as SQL injection in
[web-01](../../web-01-sql-injection/): keep **data** and **code** separate.
