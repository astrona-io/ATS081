# Question

Solve this question on: `terminal`

The platform team of the `starfleet` fleet runs a developer portal in the namespace `portal`. The Deployment `portal` serves `services.json` from the ConfigMap `portal-catalog`, which lists the services `scout`, `probe`, `shuttle` and `drifter`. The golden-path template is the key `deployment.yaml` of the ConfigMap `golden-path-template` in the same namespace. It uses the placeholders `__NAME__` and `__OWNER__`, and it has known gaps. `kubectl` points at the cluster as the cluster administrator.

Finish the adoption work:

1. Fix the template so that a rendered service has: the label `owner`, the label `catalog.starfleet.example/entity` set to the service name, the label `platform.starfleet.example/golden-path` with the value `true`, a readiness probe, and a memory limit.
2. Render the template for the service `beacon` with the owner `outpost-team` and apply the result. `beacon` must become available in `starfleet`.
3. Update the portal list: it must contain `scout`, `probe`, `shuttle`, `drifter` and `beacon`, every entry with a real owner, and the `updated` date must be 2026-11-01 or later.
4. Create the ConfigMap `adoption-report` in `portal` with the keys `total` (Deployments in `starfleet` and `outpost`), `goldenPath` (those with the golden-path label) and `coverage` (the whole percent of those Deployments that the portal lists). The values must match the cluster.
