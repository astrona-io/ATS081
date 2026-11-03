---
estimated_duration: 40m
---

# Lab: Golden Path And Portal Capstone

Graded lab. **Status: UNTESTED.** It was built and checked statically only (`astrona validate`, `bash -n`, YAML parsing). Nobody has run it or its reference solution yet. The task is in `question.md`; the walkthrough is in `solution.md`.

Fix a golden-path template, start a service from it, list it in the portal and publish an adoption report that matches the cluster.

## Run it

```sh
astrona run --git ssh://git@github.com/astrona-io/ATS081.git -c sections/section-030/capstone/labs/lab-01
astrona submit --git ssh://git@github.com/astrona-io/ATS081.git -c sections/section-030/capstone/labs/lab-01
astrona destroy ats-081-capstone-030
```

Authors run the local copy with `astrona run -c <lab>` and prove the reference solution with `astrona test -c <lab>`.

## Checks

| Script | What it proves |
| --- | --- |
| `validate-template.sh` | The template renders to a Deployment that passes a server dry run and carries the catalog label, the golden-path label, a readiness probe and a memory limit |
| `validate-beacon.sh` | The Deployment beacon in starfleet was rendered from the fixed template: owner outpost-team, entity beacon, golden-path true, probe, memory limit and one available replica |
| `validate-portal.sh` | The portal serves all five services including beacon, with real owners and an updated date of 2026-11-01 or later |
| `validate-report.sh` | ConfigMap adoption-report in portal has total, goldenPath and coverage that match the live cluster and the served list |
