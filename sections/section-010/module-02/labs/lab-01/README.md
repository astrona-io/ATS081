---
estimated_duration: 25m
---

# Lab: Prepare The team-beta Tenant Lab

Graded lab. **Status: UNTESTED.** It was built and checked statically only. The task is in `question.md`; the walkthrough is in `solution.md`.

Turn an empty namespace into a tenant: label, Pod Security level, quota, default limits and a default-deny network policy.

## Run it

```sh
astrona run --git ssh://git@github.com/astrona-io/ATS081.git -c sections/section-010/module-02/labs/lab-01
astrona submit --git ssh://git@github.com/astrona-io/ATS081.git -c sections/section-010/module-02/labs/lab-01
astrona destroy ats-081-lab-010-02-01
```

## Checks

| Script | What it proves |
| --- | --- |
| `validate-tenant-labels.sh` | The namespace team-beta has the tenant label beta and the baseline enforce label |
| `validate-quota.sh` | The ResourceQuota tenant-quota limits team-beta to 10 pods and requests.cpu 2 |
| `validate-limitrange.sh` | The LimitRange tenant-defaults sets the container memory default limit 256Mi and request 128Mi |
| `validate-default-deny.sh` | The NetworkPolicy default-deny-ingress selects all pods, has type Ingress and no ingress rules |
| `validate-privileged-rejected.sh` | A privileged pod in team-beta is rejected and the namespace outpost has no tenant label |
