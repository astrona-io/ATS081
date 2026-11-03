# Question

Solve this question on: `terminal`

The platform team of the `starfleet` fleet is onboarding the team `beta`. The namespace `team-beta` exists but has no controls. `kubectl` points at the cluster as the cluster administrator.

Prepare the namespace so that:

1. It has the label `platform.starfleet.example/tenant` with the value `beta`, and the label `pod-security.kubernetes.io/enforce` with the value `baseline`.
2. A ResourceQuota named `tenant-quota` limits the namespace to 10 Pods and `requests.cpu` of 2.
3. A LimitRange named `tenant-defaults` gives every container the default limit `memory: 256Mi` and the default request `memory: 128Mi`.
4. A NetworkPolicy named `default-deny-ingress` selects every Pod in the namespace, has the policy type `Ingress` and has no ingress rules.

A privileged Pod in the namespace must be rejected, and the other namespaces must not change.
