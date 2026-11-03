# Solution

Solve this lab on `terminal`. This lab has not been run yet; the commands are checked statically only.

```sh
astrona run --git ssh://git@github.com/astrona-io/ATS081.git -c sections/section-010/module-02/labs/lab-01
```

## Step 1: Label the namespace

```sh
kubectl label namespace team-beta platform.starfleet.example/tenant=beta pod-security.kubernetes.io/enforce=baseline
```

## Step 2: Add the quota, the limits and the policy

Save this as `tenant-beta.yaml`:

```yaml
apiVersion: v1
kind: ResourceQuota
metadata:
  name: tenant-quota
  namespace: team-beta
spec:
  hard:
    pods: "10"
    requests.cpu: "2"
---
apiVersion: v1
kind: LimitRange
metadata:
  name: tenant-defaults
  namespace: team-beta
spec:
  limits:
    - type: Container
      defaultRequest:
        memory: 128Mi
      default:
        memory: 256Mi
---
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: default-deny-ingress
  namespace: team-beta
spec:
  podSelector: {}
  policyTypes:
    - Ingress
```

Apply it and check the objects:

```sh
kubectl apply -f tenant-beta.yaml
kubectl get resourcequota,limitrange,networkpolicy -n team-beta
```

## Step 3: Test the Pod Security level

Save this as `pod-privileged.yaml`:

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: privileged-test
  namespace: team-beta
spec:
  containers:
    - name: test
      image: ghcr.io/stefanprodan/podinfo:6.15.0
      securityContext:
        privileged: true
```

```sh
kubectl apply --dry-run=server -f pod-privileged.yaml
```

The API server rejects the Pod. If it accepts the Pod, check the label on the namespace.

Submit and destroy:

```sh
astrona submit --keep --git ssh://git@github.com/astrona-io/ATS081.git -c sections/section-010/module-02/labs/lab-01
astrona destroy ats-081-lab-010-02-01
```
