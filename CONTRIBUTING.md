# Contributing a lab

Every lab is self-contained and follows the same shape so learners never have to
relearn the workflow. Start by copying the template:

```bash
cp -r labs/_template labs/<track>-<nn>-<slug>
```

Example: `labs/web-02-command-injection`.

## The contract

A lab **must** support these five make targets:

| Target | What it does |
|--------|--------------|
| `make up` | Start the vulnerable target (docker compose up) |
| `make attack` | Run the exploit against the running target |
| `make detect` | Run the detection and show it firing on the attack |
| `make verify` | Grade the learner: print `PASS` or `FAIL` and exit non-zero on FAIL |
| `make down` | Tear everything down |

## Required files

- `README.md` — max ~5 minutes of theory. Link out for depth; don't reproduce it.
- `docker-compose.yml` — the target. Bind only to `127.0.0.1`.
- `attack/` — runnable steps, commented so a beginner can follow.
- `detect/` — a Sigma rule (`*.yml`) **and** a script that demonstrates it firing.
- `fix/` — the patched code/config plus a short note on *why* it works.
- `verify.sh` — objective grading. No manual judgement.
- `FLAG` — a short token; store only its `sha256` in `verify.sh`, never plaintext.

## Rules

- **Localhost only.** Targets bind to `127.0.0.1`. Never ship anything that scans
  or attacks external hosts.
- **Original wording.** Write theory in your own words. Cite sources; don't copy.
- **Idempotent.** `make up && make up` must not break. `make down` cleans up fully.
- **No secrets.** No real credentials, keys, or tokens in the repo.

Open a PR with the lab folder and a one-line addition to the track table in the
root `README.md`.
