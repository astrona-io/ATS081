# Question

Solve this question on: `terminal`

The platform team stores the catalog descriptors of the `starfleet` services as text in the ConfigMap `entity-files` in the namespace `catalog-files`. The key `probe.yaml` fails the catalog quality check. `kubectl` points at the cluster as the cluster administrator.

Change the key `probe.yaml` so that the descriptor:

1. Has the lifecycle `production`.
2. Belongs to the system `navigation` (`spec.system: navigation`).
3. Has the annotation `backstage.io/kubernetes-id` with the value `probe`.
4. Depends on the scout with the full reference `component:default/scout` in `spec.dependsOn`.

Keep the key `scout.yaml` as it is, and keep the owner `group:default/probe-team`.
