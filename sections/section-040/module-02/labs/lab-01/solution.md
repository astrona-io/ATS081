# Solution

Solve this lab on `terminal`. This lab has not been run yet; the commands are checked statically only.

```sh
astrona run --git ssh://git@github.com/astrona-io/ATS081.git -c sections/section-040/module-02/labs/lab-01
```

## Step 1: Create the quota and the priority class

Save this as `ml-team.yaml`:

```yaml
apiVersion: v1
kind: ResourceQuota
metadata:
  name: ml-quota
  namespace: ml-team
spec:
  hard:
    requests.nvidia.com/gpu: "2"
    pods: "10"
---
apiVersion: scheduling.k8s.io/v1
kind: PriorityClass
metadata:
  name: training-low
value: 1000
preemptionPolicy: Never
description: Batch training that waits for free capacity and never evicts others
```

Apply it:

```sh
kubectl apply -f ml-team.yaml
```

## Step 2: Add the clean-up time

The field `ttlSecondsAfterFinished` can be changed on an existing Job:

```sh
kubectl patch job retrain -n ml-team --type merge -p '{"spec":{"ttlSecondsAfterFinished":3600}}'
```

## Step 3: Check the result

```sh
kubectl get resourcequota ml-quota -n ml-team -o jsonpath='{.spec.hard}'
kubectl get priorityclass training-low -o jsonpath='{.value} {.preemptionPolicy}'
kubectl get job retrain -n ml-team -o jsonpath='{.spec.suspend} {.spec.ttlSecondsAfterFinished}'
```

The quota shows two GPUs and ten Pods, the class shows 1000 and Never, and the Job shows true and 3600.

Submit and destroy:

```sh
astrona submit --keep --git ssh://git@github.com/astrona-io/ATS081.git -c sections/section-040/module-02/labs/lab-01
astrona destroy ats-081-lab-040-02-01
```
