---
estimated_duration: 25m
---

# Lab: Fix The probe Descriptor Lab

Graded lab. **Status: UNTESTED.** It was built and checked statically only. The task is in `question.md`; the walkthrough is in `solution.md`.

Correct a catalog descriptor that is stored as text in a ConfigMap: lifecycle value, system, annotation and dependency.

## Run it

```sh
astrona run --git ssh://git@github.com/astrona-io/ATS081.git -c sections/section-020/module-02/labs/lab-01
astrona submit --git ssh://git@github.com/astrona-io/ATS081.git -c sections/section-020/module-02/labs/lab-01
astrona destroy ats-081-lab-020-02-01
```

## Checks

| Script | What it proves |
| --- | --- |
| `validate-lifecycle.sh` | The probe descriptor has the lifecycle production |
| `validate-system.sh` | The probe descriptor belongs to the system navigation |
| `validate-annotation.sh` | The probe descriptor has the annotation backstage.io/kubernetes-id with the value probe |
| `validate-depends-on.sh` | The probe descriptor depends on component:default/scout |
| `validate-owner-kept.sh` | The probe owner is still group:default/probe-team and scout.yaml still exists |
