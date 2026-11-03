---
estimated_duration: 25m
---

# Lab: Harden The EnvironmentRequest API

Graded lab. **Status: UNTESTED.** It was built and checked statically only (`astrona validate`, `bash -n`, YAML parsing). Nobody has run it or its reference solution yet. The task is in `question.md`; the walkthrough is in `solution.md`.

Fix a request CustomResourceDefinition that accepts anything: enum, defaults, bounds, a validation rule and a status subresource.

## Run it

```sh
astrona run --git ssh://git@github.com/astrona-io/ATS081.git -c sections/section-010/module-01/labs/lab-01
astrona submit --git ssh://git@github.com/astrona-io/ATS081.git -c sections/section-010/module-01/labs/lab-01
astrona destroy ats-081-lab-010-01
```

Authors run the local copy with `astrona run -c <lab>` and prove the reference solution with `astrona test -c <lab>`.

## Checks

| Script | What it proves |
| --- | --- |
| `validate-class-enum.sh` | Classes small and medium are accepted and any other class is rejected |
| `validate-defaults.sh` | A request with only an owner gets class small and ttlHours 24 |
| `validate-ttl-bounds.sh` | ttlHours accepts 1 to 72 and rejects 0 and 100 |
| `validate-owner-rule.sh` | An owner without the suffix -team is rejected with the message "owner must end with -team" |
| `validate-status-subresource.sh` | The CRD serves a status subresource |
