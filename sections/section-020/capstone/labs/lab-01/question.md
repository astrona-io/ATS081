# Question

Solve this question on: `terminal`

The catalog of the `starfleet` fleet lives in the namespace `catalog`, as objects of the kind `CatalogEntity` in the group `catalog.starfleet.example`. It holds the components `scout`, `probe` and `shuttle`. The Deployments `scout`, `probe` and `shuttle` run in `starfleet`, and `drifter` runs in `outpost`. Before the quarterly review, the catalog must be healthy. `kubectl` points at the cluster as the cluster administrator.

Make the catalog healthy:

1. `scout` was reviewed in March 2025. Set its annotation `catalog.starfleet.example/last-reviewed` to a date in November 2026. No entity may have a review date before `2026-08-01`, and every entity needs the annotation.
2. `probe` has the placeholder owner `group:unassigned`. Give it the owner `group:starfleet-team`.
3. `shuttle` depends on `resource:telemetry-db`, which is not registered. Register it as a `Resource` with lifecycle `production` and owner `group:starfleet-team`. Keep the dependency.
4. Register `drifter` as a `Component` with lifecycle `experimental` and owner `group:outpost-team`.
5. Label the four Deployments with `catalog.starfleet.example/entity=<name>`, where `<name>` is the name of the Deployment.
6. Create the ConfigMap `catalog-report` in `catalog` with the keys `total` (number of entities), `owners` (number of distinct owners) and `dangling` (number of dangling references). The values must match the catalog after your changes.
