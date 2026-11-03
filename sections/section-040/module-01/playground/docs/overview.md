# Overview: AI/ML in Platform Automation (Playground)

This is a playground, not a lab. It starts a cluster with the example workloads and waits. There is no task, no `astrona submit` and no pass or fail. Experiment, run `astrona destroy` and start again.

## What is in the box

- A single-node `kind` cluster running Kubernetes 1.35, with `kubectl` pointed at it as the cluster administrator.
- The namespaces `starfleet` and `outpost` with the workloads `scout`, `probe`, `shuttle` and `drifter`.
- The namespace `assistant` with the ServiceAccount `ops-assistant`. It has no permissions yet.

## Practice tasks

- Bind the `edit` ClusterRole to `ops-assistant` in `starfleet` and list what it can do with `kubectl auth can-i --as=system:serviceaccount:assistant:ops-assistant`.
- Replace the binding with a read-only Role and a Role that only creates ConfigMaps in `assistant`.
- Create the admission policy and send a proposal with the status `approved` through a server-side dry run.
- Act as `platform-reviewer` with `--as` and change the status of a proposal.
- Seed reviewed proposals and compute the acceptance rate with `jq`.
- Change the mix of accepted and rejected proposals and decide whether the mode stays `suggest-only`.
