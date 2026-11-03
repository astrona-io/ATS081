# Overview: Developer Portals for Platform Adoption (Playground)

This is a playground, not a lab. It starts a cluster with the example workloads and waits. There is no task, no `astrona submit` and no pass or fail. Experiment, run `astrona destroy` and start again.

## What is in the box

- A single-node `kind` cluster running Kubernetes 1.35, with `kubectl` pointed at it as the cluster administrator.
- The namespaces `starfleet` and `outpost` with the workloads `scout`, `probe`, `shuttle` and `drifter`.
- The empty namespace `portal`, with no portal and no template.

## Practice tasks

- Apply the portal manifest and fetch `services.json` from the `drifter` Pod with `curl`.
- Change the ConfigMap `portal-catalog` and measure how long the served file takes to change.
- Store a golden-path template in a ConfigMap, render a service named `beacon` and apply it.
- Remove the readiness probe from the template and compare the rendered manifests.
- Count the Deployments with the golden-path label and compare them with the portal list.
- Write a freshness check that compares the `updated` date with a cutoff.
