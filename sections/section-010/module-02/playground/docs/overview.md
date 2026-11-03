# Overview: Namespace-As-A-Service And Tenant Isolation (Playground)

This is a playground, not a lab. It starts a cluster with the example workloads and waits. There is no task, no `astrona submit` and no pass or fail. Experiment, run `astrona destroy` and start again.

## What is in the box

- A single-node `kind` cluster running Kubernetes 1.35, with `kubectl` pointed at it as the cluster administrator.
- The namespaces `starfleet` and `outpost` with the workloads `scout`, `probe`, `shuttle` and `drifter`.
- The empty namespace `team-beta` with no label, quota, LimitRange, NetworkPolicy or Pod Security label.

## Practice tasks

- Create the namespace `team-gamma` with a tenant label and list tenants with `kubectl get namespaces -l platform.starfleet.example/tenant`.
- Add a ResourceQuota for pods and requests.cpu, then create a Pod without resources and read the Forbidden error.
- Add a LimitRange with defaults and create the same Pod again.
- Apply a default-deny ingress NetworkPolicy and run `kubectl get networkpolicy -n team-gamma`.
- Label a namespace with `pod-security.kubernetes.io/enforce=baseline` and test a privileged Pod with `kubectl apply --dry-run=server`.
- Change the label to `warn` and compare the result.
