---
estimated_duration: 25m
---

# Lab: Complete The Starfleet Catalog

Graded lab. **Status: UNTESTED.** It was built and checked statically only (`astrona validate`, `bash -n`, YAML parsing). Nobody has run it or its reference solution yet. The task is in `question.md`; the walkthrough is in `solution.md`.

Register a missing component, remove a dangling reference and link the running Deployments to their catalog entities.

## Run it

```sh
astrona run --git ssh://git@github.com/astrona-io/ATS081.git -c sections/section-020/module-01/labs/lab-01
astrona submit --git ssh://git@github.com/astrona-io/ATS081.git -c sections/section-020/module-01/labs/lab-01
astrona destroy ats-081-lab-020-01
```

Authors run the local copy with `astrona run -c <lab>` and prove the reference solution with `astrona test -c <lab>`.

## Checks

| Script | What it proves |
| --- | --- |
| `validate-drifter-entity.sh` | Entity drifter is a Component with lifecycle experimental, owner group:outpost-team and a dependency on component:scout |
| `validate-no-dangling.sh` | No entity depends on an entity that does not exist, and scout, probe and shuttle are still registered |
| `validate-labels.sh` | The Deployments scout, probe, shuttle and drifter carry the label catalog.starfleet.example/entity with their own name |
