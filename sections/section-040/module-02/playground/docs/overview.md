# Overview: Platform Capabilities For Machine Learning Workloads (Playground)

This is a playground, not a lab. It starts a cluster with the example workloads and waits. There is no task, no `astrona submit` and no pass or fail. Experiment, run `astrona destroy` and start again.

## What is in the box

- A single-node `kind` cluster running Kubernetes 1.35, with `kubectl` pointed at it as the cluster administrator.
- The namespaces `starfleet` and `outpost` with the workloads `scout`, `probe`, `shuttle` and `drifter`.
- The namespace `ml-team` with the suspended Job `retrain` (`backoffLimit: 2`, no clean-up time). No node advertises a GPU, no quota and no PriorityClass exist.

## Practice tasks

- Send a Pod that asks for `nvidia.com/gpu: 1` through `kubectl apply --dry-run=server` and read the result.
- Create a ResourceQuota with `requests.nvidia.com/gpu: "2"` and read it back.
- Create the PriorityClass `training-low` and list priority classes with `kubectl get priorityclass`.
- Patch the Job `retrain` with `ttlSecondsAfterFinished` and read the field.
- Resume the Job with `kubectl patch job retrain -n ml-team --type merge -p '{"spec":{"suspend":false}}'` and watch the Pod with `kubectl get pods -n ml-team -w`.
