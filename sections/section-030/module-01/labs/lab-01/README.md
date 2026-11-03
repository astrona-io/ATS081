---
estimated_duration: 25m
---

# Lab: Refresh The Portal Service List

Graded lab. **Status: UNTESTED.** It was built and checked statically only (`astrona validate`, `bash -n`, YAML parsing). Nobody has run it or its reference solution yet. The task is in `question.md`; the walkthrough is in `solution.md`.

Bring a stale portal service list up to date: all four services, real owners and a current updated date.

## Run it

```sh
astrona run --git ssh://git@github.com/astrona-io/ATS081.git -c sections/section-030/module-01/labs/lab-01
astrona submit --git ssh://git@github.com/astrona-io/ATS081.git -c sections/section-030/module-01/labs/lab-01
astrona destroy ats-081-lab-030-01
```

Authors run the local copy with `astrona run -c <lab>` and prove the reference solution with `astrona test -c <lab>`.

## Checks

| Script | What it proves |
| --- | --- |
| `validate-served-services.sh` | The portal serves a list with the services scout, probe, shuttle and drifter |
| `validate-owners.sh` | Every served entry has a real owner, probe is owned by starfleet-team and drifter by outpost-team |
| `validate-fresh.sh` | The served updated date is 2026-11-01 or later |
