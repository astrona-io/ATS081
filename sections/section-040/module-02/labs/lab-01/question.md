# Question

Solve this question on: `terminal`

The ML team of the `starfleet` fleet works in the namespace `ml-team`. The cluster offers GPUs through the resource name `nvidia.com/gpu`, and nothing limits the team yet. The training Job `retrain` exists and is suspended. `kubectl` points at the cluster as the cluster administrator.

Prepare the namespace so that:

1. A ResourceQuota named `ml-quota` in `ml-team` allows at most 2 GPUs (`requests.nvidia.com/gpu`) and 10 Pods.
2. A PriorityClass named `training-low` has the value 1000 and the preemption policy `Never`.
3. The Job `retrain` removes itself 3600 seconds after it finishes (`ttlSecondsAfterFinished`).

The Job must stay suspended.
