# Career

The point of all this is a job. Here's how to convert finished labs into
interviews — the part most study plans hand-wave.

## 1. Your portfolio is already built

Unlike a checklist repo, you've produced real artifacts. Package them:

- A **public GitHub repo** of your lab writeups (attack + detection + fix for each).
- Your **detection rules** (Sigma/Splunk) in one folder — recruiters love these.
- One **integration case study** from the [capstone](../capstone/).
- A short **demo GIF or video** of you exploiting and detecting one lab.

This is proof of skill. A checkbox list is not.

## 2. Resume

Turn labs into bullet points that show outcomes, not tasks:

- ❌ "Learned SQL injection."
- ✅ "Built and exploited a vulnerable web app, then authored a Sigma detection
  that flagged the injection in application logs and remediated it with
  parameterized queries."

Include: a skills section (tools + techniques you actually ran), a projects
section (link the portfolio), certs in progress (Network+/Security+), and any
CTF profiles. Keep it one page, ATS-friendly (plain formatting, real keywords).

A fill-in **`resume-template.md`** lives beside this file — start there.

## 3. Roles & pathways

| Entry role | What they want | Your matching tracks |
|---|---|---|
| SOC Analyst (Tier 1) | Log analysis, SIEM, alert triage | 5, 6, 1 |
| Junior Pentester | Web/host/AD exploitation | 2, 3, 4 |
| Blue Team / Detection Eng | Writing & tuning detections | 5, 1, 4 |
| DFIR Analyst | Forensics, IR process | 6, 2 |

Detection Engineering and SOC roles have strong hiring demand and less applicant
competition than "pentester" — lean there if you want the fastest way in.

## 4. Job search & interview

- **Where:** LinkedIn, Indeed, CyberSeek (role/salary map), company career pages.
- **How:** apply to roles matching your strongest 2 tracks; tailor the resume's
  keywords to each posting (ATS).
- **Interview prep:** be ready to *walk through* one lab end-to-end — attack,
  detection, fix. Use **STAR** (Situation, Task, Action, Result) and cite your
  actual labs as the stories. Doing beats memorizing trivia.

---

You don't need to finish all 100 labs to start applying. A dozen solid writeups
plus one integration case study is already more than most entry candidates show.
