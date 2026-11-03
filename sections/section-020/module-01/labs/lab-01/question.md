# Question

Solve this question on: `terminal`

The platform team of the `starfleet` fleet keeps a catalog of its services in the namespace `catalog`, as objects of the kind `CatalogEntity` in the group `catalog.starfleet.example`. The catalog contains the components `scout`, `probe` and `shuttle`. The Deployments `scout`, `probe` and `shuttle` run in `starfleet`, and `drifter` runs in `outpost`. `kubectl` points at the cluster as the cluster administrator.

Complete the catalog:

1. Register the component `drifter` as a `CatalogEntity` in `catalog`: kind `Component`, lifecycle `experimental`, owner `group:outpost-team`, and a dependency on `component:scout`. Add the annotation `catalog.starfleet.example/last-reviewed` with a recent date.
2. The entity `probe` depends on `component:sensor-gateway`, which is not registered. Remove that dependency and keep the dependency on `component:scout`. Do not delete any entity.
3. Label each of the four Deployments with `catalog.starfleet.example/entity=<name>`, where `<name>` is the name of the Deployment.
