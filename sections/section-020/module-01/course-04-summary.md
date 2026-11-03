---
draft: true
exam_objectives:
  - API-Driven Service Catalogs
---
# Summary

A service catalog is a set of entities with owners, a lifecycle and relationships. The common entity kinds are Component, API, Resource and System. The owner field answers who is responsible, the lifecycle field answers whether the entity should be used, and the `dependsOn` relationships make impact questions answerable: who is affected if this entity changes.

An API-driven catalog stores entities behind an API that validates them. In Kubernetes a CustomResourceDefinition adds the kind `CatalogEntity` with enumerations for kind and lifecycle, a required owner, a CEL rule that the owner is a group, and a pattern for each reference. The API server enforces these rules for every client. The catalog can then be queried with `kubectl` and `jq`, and a portal or a script reads the same data. Linking running workloads to entities by a label connects the catalog to the cluster.

A catalog decays unless someone keeps it useful. Three faults destroy trust: stale entries that nobody has reviewed, ownerless entries whose owner is missing or a placeholder, and dangling references that point at an entity that does not exist. Each fault has a query. Drift between the catalog and the cluster has two queries as well: Deployments that no entity claims, and labels that name no entity. The platform team owns the schema, the queries and the report, and the owning teams own the content and repair it after they read it.

- A catalog without owners cannot answer who to call.
- Validation in the schema keeps bad data out; queries find the faults that a schema cannot see.
- A review date only helps when the review really happens.
- A fault that stays open is feedback about the process, not only about one entry.

<!-- astrona:playground:destroy -->
