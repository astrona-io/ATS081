---
draft: true
exam_objectives:
  - API-Driven Service Catalogs
---
# Summary

A catalog descriptor is a YAML file that states facts about one entity. Every entity has the fields apiVersion, kind, metadata and spec. The identity of an entity is its kind, namespace and name, and it does not depend on where the software runs.

The spec fields depend on the kind. A Component has a type, a lifecycle, an owner and usually a system, and it can name the APIs it provides and consumes and the components it depends on. An API carries a definition. A Resource describes infrastructure, a System groups components, and a Domain groups systems. Groups and Users describe the people and teams, and are usually imported from an identity provider.

Entities refer to each other with the form kind:namespace/name, and each field has a default kind that allows a short form. The catalog derives relations from these fields and creates the reverse relation itself, so descriptors never contain relations. A reference to a missing entity is a dangling reference and is a catalog health problem.

A catalog finds descriptors through configured locations, Location entities or automatic discovery. Annotations connect an entity to a repository, documentation or workloads. A validation step in the pipeline catches a missing owner, a wrong lifecycle value and a dangling reference before the descriptor reaches the catalog.

- Write facts, not relations. The catalog derives the relations.
- Use the agreed lifecycle values so that reports and filters work.
- Validate descriptors in the pull request, not after they are registered.

<!-- astrona:playground:destroy -->
