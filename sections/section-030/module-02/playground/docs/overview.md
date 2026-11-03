# Overview: Software Templates In Depth (Playground)

This is a playground, not a lab. It starts a cluster with the example workloads and waits. There is no task, no `astrona submit` and no pass or fail. Experiment, run `astrona destroy` and start again.

## What is in the box

- A single-node `kind` cluster running Kubernetes 1.35, with `kubectl` pointed at it as the cluster administrator.
- The namespaces `starfleet` and `outpost` with the workloads `scout`, `probe`, `shuttle` and `drifter`.
- The namespace `portal` with the ConfigMap `scaffolder-templates`. The key `template.yaml` holds the template `starfleet-service` as text. It has a form without rules and one step.

## Practice tasks

- Print the template with `kubectl get configmap scaffolder-templates -n portal -o jsonpath='{.data.template\.yaml}'`.
- List the actions with `grep -n 'action:'` and name the step that is missing for a catalog entry.
- Add a `required` list and a `pattern` for the name, apply the ConfigMap and check them with `grep`.
- Add the steps `publish` and `register` and an `output` link.
- Count Deployments with `kubectl get deployments -A -L platform.starfleet.example/golden-path`.
