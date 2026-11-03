---
estimated_duration: 40m
---

# Lab: Catalog Health Capstone

Graded lab. **Status: UNTESTED.** It was built and checked statically only (`astrona validate`, `bash -n`, YAML parsing). Nobody has run it or its reference solution yet. The task is in `question.md`; the walkthrough is in `solution.md`.

Repair a catalog with a stale entry, a placeholder owner and a missing dependency, register the remaining entities and publish a health report.

## Run it

```sh
astrona run --git ssh://git@github.com/astrona-io/ATS081.git -c sections/section-020/capstone/labs/lab-01
astrona submit --git ssh://git@github.com/astrona-io/ATS081.git -c sections/section-020/capstone/labs/lab-01
astrona destroy ats-081-capstone-020
```

Authors run the local copy with `astrona run -c <lab>` and prove the reference solution with `astrona test -c <lab>`.

## Checks

| Script | What it proves |
| --- | --- |
| `validate-freshness.sh` | Entity scout was reviewed on 2026-11-01 or later and no entity has a review date before 2026-08-01 or none |
| `validate-owners.sh` | No entity has the placeholder owner group:unassigned and probe is owned by group:starfleet-team |
| `validate-new-entities.sh` | Entity telemetry-db is a production Resource owned by group:starfleet-team and entity drifter is an experimental Component owned by group:outpost-team |
| `validate-no-dangling.sh` | Every dependency of every entity points at an entity that exists, and shuttle still depends on resource:telemetry-db |
| `validate-labels.sh` | The Deployments scout, probe, shuttle and drifter carry the label catalog.starfleet.example/entity with their own name |
| `validate-report.sh` | ConfigMap catalog-report in the namespace catalog has total, owners and dangling that match the live catalog |
