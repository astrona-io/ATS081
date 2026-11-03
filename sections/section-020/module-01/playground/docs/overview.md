# Overview: API-Driven Service Catalogs (Playground)

This is a playground, not a lab. It starts a cluster with the example workloads and waits. There is no task, no `astrona submit` and no pass or fail. Experiment, run `astrona destroy` and start again.

## What is in the box

- A single-node `kind` cluster running Kubernetes 1.35, with `kubectl` pointed at it as the cluster administrator.
- The namespaces `starfleet` and `outpost` with the workloads `scout`, `probe`, `shuttle` and `drifter`.
- The empty namespace `catalog`, with no catalog kind and no entities.

## Practice tasks

- Apply the CustomResourceDefinition for `CatalogEntity` and run `kubectl explain catalogentity.spec`.
- Register entities for the four workloads and read them with `kubectl get ent -n catalog`.
- Try to create an entity with owner `jason` or lifecycle `Prod` and read the error.
- Write the jq queries for stale entries, placeholder owners and dangling references.
- Label a Deployment with `catalog.starfleet.example/entity` and list the Deployments that have no label.
- Delete an entity that others depend on and find the dangling references it leaves.
