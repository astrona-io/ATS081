---
estimated_duration: 40m
---

# Lab: Simplified Access Capstone

Graded lab. **Status: UNTESTED.** It was built and checked statically only (`astrona validate`, `bash -n`, YAML parsing). Nobody has run it or its reference solution yet. The task is in `question.md`; the walkthrough is in `solution.md`.

Give team-alpha a complete self-service path: quota, default limits, an owner-label policy, scoped permissions and a request with Ready status.

## Run it

```sh
astrona run --git ssh://git@github.com/astrona-io/ATS081.git -c sections/section-010/capstone/labs/lab-01
astrona submit --git ssh://git@github.com/astrona-io/ATS081.git -c sections/section-010/capstone/labs/lab-01
astrona destroy ats-081-capstone-010
```

Authors run the local copy with `astrona run -c <lab>` and prove the reference solution with `astrona test -c <lab>`.

## Checks

| Script | What it proves |
| --- | --- |
| `validate-quota.sh` | ResourceQuota team-quota in team-alpha allows 6 pods and 2 CPU of requests |
| `validate-limits.sh` | LimitRange team-limits sets container memory default 128Mi, default request 64Mi and maximum 512Mi |
| `validate-owner-policy.sh` | Deployments without an owner label are denied in team-alpha with a message about owner, and allowed in outpost |
| `validate-team-rbac.sh` | Group team-alpha-developers can create requests only in team-alpha and cannot write status or create Deployments |
| `validate-request-ready.sh` | The EnvironmentRequest starter in team-alpha has owner alpha-team, phase Ready and a Ready condition with status True |
