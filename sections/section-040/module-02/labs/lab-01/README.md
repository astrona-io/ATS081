---
estimated_duration: 25m
---

# Lab: Limit GPUs And Clean Up Training Jobs Lab

Graded lab. **Status: UNTESTED.** It was built and checked statically only. The task is in `question.md`; the walkthrough is in `solution.md`.

Prepare the ML team namespace: a GPU quota, a non-preempting priority class and a clean-up time on the training Job.

## Run it

```sh
astrona run --git ssh://git@github.com/astrona-io/ATS081.git -c sections/section-040/module-02/labs/lab-01
astrona submit --git ssh://git@github.com/astrona-io/ATS081.git -c sections/section-040/module-02/labs/lab-01
astrona destroy ats-081-lab-040-02-01
```

## Checks

| Script | What it proves |
| --- | --- |
| `validate-gpu-quota.sh` | The ResourceQuota ml-quota allows 2 GPUs and 10 pods in ml-team |
| `validate-priority-class.sh` | The PriorityClass training-low has the value 1000 and the preemption policy Never |
| `validate-job-ttl.sh` | The Job retrain has ttlSecondsAfterFinished 3600 |
| `validate-job-suspended.sh` | The Job retrain is still suspended |
