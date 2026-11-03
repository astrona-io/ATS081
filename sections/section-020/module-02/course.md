---
draft: true
exam_objectives:
  - API-Driven Service Catalogs
---
# The Catalog Descriptor Format

A service catalog is only as good as the files that feed it. In Backstage, the best-known open source developer portal, each entity is described by a small YAML file, usually named `catalog-info.yaml`, that lives next to the code. This module teaches the format of that file, so that you can read, write and review descriptors and know which field creates which relation.

Keep one sentence in mind: **a descriptor states facts about one entity, and the catalog derives its relations from those facts.** You will read the anatomy of a descriptor, the fields of the main entity kinds, the way entities refer to each other, and the ways a catalog finds descriptor files.

The module has four parts. **The Anatomy Of A Descriptor** covers the envelope: `apiVersion`, `kind`, `metadata` and `spec`. **Spec Fields Of The Main Entity Kinds** covers Component, API, Resource, System, Domain, Group and User. **Entity References And Relations** explains the reference syntax and the relations the catalog builds. **Locations, Annotations And Validation** shows how a catalog finds descriptors and how to check them before they reach it.

## Learning Goals

- Write a valid descriptor for a Component with an owner, a lifecycle and a system.
- Name the spec fields that create ownership, dependency and API relations.
- Write an entity reference in the form `kind:namespace/name`.
- Explain what a Location entity and an annotation do.
- Check a descriptor for missing or wrong fields with `kubectl` and `grep`.

## Before You Start

You need YAML basics and the idea of a service catalog: a list of the software of an organization with its owners. The playground has no Backstage installation. It stores the descriptors as text in a ConfigMap, which is enough to practise the format and to check fields with shell tools.

Your playground is a single-node `kind` cluster running Kubernetes 1.35. The namespace `catalog-files` holds the ConfigMap `entity-files` with two descriptors. Launch your playground now:

<!-- astrona:playground -->
