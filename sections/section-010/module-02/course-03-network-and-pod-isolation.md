---
draft: true
exam_objectives:
  - Simplified Access to Platform Capabilities
---
# Network And Pod Isolation

Limits control how much a tenant uses. They do not control what its Pods can reach or what they are allowed to do. This part adds a default network rule and a Pod security level to the tenant namespace.

## NetworkPolicy restricts traffic

A **NetworkPolicy** selects Pods in one namespace and states which traffic is allowed to or from them. A Pod that no NetworkPolicy selects accepts all traffic. When at least one policy with the type `Ingress` selects a Pod, that Pod accepts only the ingress traffic that some policy allows.

A policy with an empty `podSelector` selects every Pod in the namespace. A policy of the type `Ingress` with no `ingress` rules then allows nothing. This is the standard **default deny** policy. Save it as `networkpolicy-default-deny.yaml`:

<!-- astrona:playground:renew -->
```yaml
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: default-deny-ingress
  namespace: team-gamma
spec:
  podSelector: {}
  policyTypes:
    - Ingress
```

Apply it and list the policies:

```sh
kubectl apply -f networkpolicy-default-deny.yaml
kubectl get networkpolicy -n team-gamma
```

The Kubernetes API stores the policy. The component that enforces it is the network plugin of the cluster (the CNI plugin), not the API server. If the plugin does not implement NetworkPolicy, the object exists and traffic is not blocked. Always check that your plugin enforces policies before you promise isolation to a tenant.

A tenant normally needs a second policy that allows traffic inside its own namespace. The `from` field then uses `podSelector: {}` to allow every Pod of the same namespace. Save this as `networkpolicy-allow-same-namespace.yaml`:

```yaml
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: allow-same-namespace
  namespace: team-gamma
spec:
  podSelector: {}
  policyTypes:
    - Ingress
  ingress:
    - from:
        - podSelector: {}
```

Apply it:

```sh
kubectl apply -f networkpolicy-allow-same-namespace.yaml
```

Policies add up. Traffic is allowed when any policy allows it, so the two policies together allow ingress only from the same namespace.

## Pod Security Admission restricts Pods

**Pod Security Admission** is a built-in admission controller that checks every Pod against one of three Pod Security Standards. The level `privileged` allows everything. The level `baseline` blocks known escalations, such as privileged containers and host namespaces. The level `restricted` follows current hardening practice and also requires, for example, `runAsNonRoot` and dropped capabilities.

You choose the level with labels on the namespace. The label `pod-security.kubernetes.io/enforce` rejects Pods that violate the level. The labels `warn` and `audit` do not reject: `warn` sends a warning to the user and `audit` writes an audit annotation. Label the namespace:

```sh
kubectl label namespace team-gamma pod-security.kubernetes.io/enforce=baseline pod-security.kubernetes.io/warn=restricted
```

Now test a privileged Pod without storing it. Save this as `pod-privileged.yaml`:

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: privileged-test
  namespace: team-gamma
spec:
  containers:
    - name: test
      image: ghcr.io/stefanprodan/podinfo:6.15.0
      securityContext:
        privileged: true
```

Send it through admission with a server-side dry run:

```sh
kubectl apply --dry-run=server -f pod-privileged.yaml
```

The API server rejects the Pod and names the violated rule, because the level `baseline` forbids privileged containers.

## Why use two levels

Using `enforce=baseline` with `warn=restricted` is a common way to move tenants forward. Teams keep running, and every Pod that would fail the stricter level shows a warning. When the warnings stop, the platform team changes the enforce level to `restricted`.

## Common pitfalls

> [!WARNING]
> - A NetworkPolicy has no effect when the network plugin does not enforce it. The API server accepts the object anyway.
> - A default-deny ingress policy does not block egress. Add the type `Egress` to control outgoing traffic.
> - The Pod Security labels apply to new Pods only. Existing Pods keep running; the `warn` label shows what would fail.
