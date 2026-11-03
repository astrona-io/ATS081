# Overview: Self-Service Requests, Guardrails And Useful Status (Playground)

This is a playground, not a lab. It starts a cluster with the example workloads and waits. There is no task, no `astrona submit` and no pass or fail. Experiment, run `astrona destroy` and start again.

## What is in the box

- A single-node `kind` cluster running Kubernetes 1.35, with `kubectl` pointed at it as the cluster administrator.
- The namespaces `starfleet` and `outpost` with the workloads `scout`, `probe`, `shuttle` and `drifter`.
- The empty namespace `team-alpha`, with no quota, no LimitRange, no policy and no request kind.

## Practice tasks

- Apply a CustomResourceDefinition for `EnvironmentRequest` and run `kubectl explain environmentrequest.spec`.
- Create requests that break each rule (class, ttlHours, owner) and read each error message.
- Change the schema (for example add `large` to the class values), apply it again and retry a request.
- Add a ResourceQuota and a LimitRange to `team-alpha`, then create a Pod without a memory limit and read the limit that was set.
- Create a ValidatingAdmissionPolicy and a binding, switch `validationActions` from `Deny` to `Warn`, and compare the result.
- Create a Role and RoleBinding for the group `team-alpha-developers` and test it with `kubectl auth can-i --as=dev-jason --as-group=team-alpha-developers`.
- Patch the status subresource of a request and watch the `Phase` column of `kubectl get envreq`.
