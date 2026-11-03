---
estimated_duration: 40m
---

# Lab: Assistant Evaluation Capstone

Graded lab. **Status: UNTESTED.** It was built and checked statically only (`astrona validate`, `bash -n`, YAML parsing). Nobody has run it or its reference solution yet. The task is in `question.md`; the walkthrough is in `solution.md`.

Bound an over-privileged assistant, then evaluate its first batch of ten reviewed proposals, record the acceptance rate and keep the mode suggest-only.

## Run it

```sh
astrona run --git ssh://git@github.com/astrona-io/ATS081.git -c sections/section-040/capstone/labs/lab-01
astrona submit --git ssh://git@github.com/astrona-io/ATS081.git -c sections/section-040/capstone/labs/lab-01
astrona destroy ats-081-capstone-040
```

Authors run the local copy with `astrona run -c <lab>` and prove the reference solution with `astrona test -c <lab>`.

## Checks

| Script | What it proves |
| --- | --- |
| `validate-read-only.sh` | The assistant can read Deployments and Pods in starfleet and cannot change them or read Secrets |
| `validate-propose-only.sh` | The assistant can only create ConfigMaps in assistant and cannot update or delete them |
| `validate-policy.sh` | Proposals from the assistant are denied unless the label proposal-status is proposed, and other users are not affected |
| `validate-reviewer.sh` | The user platform-reviewer can read and update ConfigMaps in assistant only |
| `validate-evaluation.sh` | ConfigMap assistant-evaluation holds reviewed, accepted, rejected, acceptanceRate and mode that match the proposals |
