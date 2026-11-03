# Overview: The Catalog Descriptor Format (Playground)

This is a playground, not a lab. It starts a cluster with the example workloads and waits. There is no task, no `astrona submit` and no pass or fail. Experiment, run `astrona destroy` and start again.

## What is in the box

- A single-node `kind` cluster running Kubernetes 1.35, with `kubectl` pointed at it as the cluster administrator.
- The namespaces `starfleet` and `outpost` with the workloads `scout`, `probe`, `shuttle` and `drifter`.
- The namespace `catalog-files` with the ConfigMap `entity-files`. It holds two descriptors as text: `scout.yaml` and `probe.yaml`. The `probe` descriptor has errors.

## Practice tasks

- List the keys of the ConfigMap with `kubectl get configmap entity-files -n catalog-files -o jsonpath='{.data}' | jq 'keys'`.
- Print each descriptor and write down the fields that an agreed standard would require.
- Replace the ConfigMap with a corrected `probe.yaml` and check the lifecycle line with `grep`.
- Add an API descriptor as a third key and add `providesApis` to the `probe` descriptor.
- Write a Location descriptor that lists the two descriptors as targets.
