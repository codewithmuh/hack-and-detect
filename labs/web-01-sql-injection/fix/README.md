# Fix — parameterize the query

## What to change

Swap the string-concatenated query in [`app/app.py`](../app/app.py) for the
parameterized version in [`app_fixed.py`](app_fixed.py):

```python
# before (vulnerable)
query = f"SELECT secret FROM users WHERE username = '{username}' AND password = '{password}'"
row = conn.execute(query).fetchone()

# after (safe)
query = "SELECT secret FROM users WHERE username = ? AND password = ?"
row = conn.execute(query, (username, password)).fetchone()
```

## Why it works

With concatenation, your input *becomes part of the SQL text*, so `admin' --`
changes the query's structure and comments out the password check.

With a parameterized (prepared) query, the SQL structure is fixed **before** your
input is attached. The database receives `admin' --` as a data value to compare
against the `username` column — there is no row with that literal username, so
the login simply fails. The input can never be interpreted as code.

## Try it

```bash
# rebuild the target using the fixed app, then re-attack
cp fix/app_fixed.py app/app.py
make down && make up
make attack        # the injection should now FAIL
```

Parameterized queries are the fix for SQL injection everywhere — every language
and ORM has them (`?`, `%s`, named binds, `.where(x=y)`). Never build SQL by
string formatting with user input.
