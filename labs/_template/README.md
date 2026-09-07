# <Lab title>

**Track:** <track name> · **Difficulty:** <easy|medium|hard> · **Time:** ~<n> min

## The idea (2 min)

One or two paragraphs. What is the vulnerability, in plain language? When does it
happen in the real world? No filler, no history lesson.

## The target

What `make up` starts, and what you're trying to achieve (the goal / flag).

```bash
make up
```

## Attack (hack)

```bash
make attack
```

Explain each step of `attack/exploit.sh` briefly. The learner should understand
*why* it works, not just paste it.

## Detect

```bash
make detect
```

Show the detection firing on the attack you just ran. Explain the signal it keys
on (which log field, which pattern) and why an attacker can't trivially avoid it.

## Fix

See [`fix/`](fix/). Apply it, then re-run `make attack` and confirm it fails.

Explain *why* the fix works — not just what to change.

## Verify

```bash
make verify
```

## Going deeper

- <link to a primary source / spec / write-up>
