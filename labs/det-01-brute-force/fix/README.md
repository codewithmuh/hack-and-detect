# Fix — account lockout / rate limiting

## What to change

Swap in [`app_fixed.py`](app_fixed.py), which locks an account after repeated
failures:

```bash
cp fix/app_fixed.py app/app.py
make down && make up
make attack        # the account locks (HTTP 429) before the wordlist reaches the password
```

## Why it works

The brute force only wins because it can make unlimited guesses. After 5 failed
attempts for an account within the window, the fix refuses further attempts with
`429` for a lockout period — **even the correct password is rejected while
locked** — so a wordlist can't walk to the answer. The weak password
(`sunshine`) sits past the lockout threshold, so the attack now fails.

## Detection + prevention, together

- **Lockout / rate limiting** — stops the attack (this fix).
- **The detection you built** — tells you it was attempted and whether it
  succeeded, so you can respond even for accounts that were already weak.
- **MFA** — a stolen/guessed password isn't enough on its own.
- **Strong-password policy** — makes guessing infeasible in the first place.

Don't rely on any single control. Lockout without alerting means silent attacks;
alerting without lockout means you watch the breach happen. Do both.

> Note: lockout-by-account can be abused for denial of service (lock everyone
> out). Real systems often lock/slow **by source IP + account** and add CAPTCHA,
> which is why the detection also keys on `src`.
