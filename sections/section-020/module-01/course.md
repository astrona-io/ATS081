---
draft: true
exam_objectives:
  - API-Driven Service Catalogs
---
# Software Entities, Ownership And Discoverable Relationships

A service catalog is a record of the software an organization runs: what each piece is, who owns it, what state it is in and what it depends on. An API-driven catalog stores this record behind an API, so that people, portals and automation read and update it with the same interface and the same rules. Without it, the answer to "who owns this service?" lives in chat history.

Keep one sentence in mind for this module: **a catalog entry is a claim about software, and it is only useful while the claim has an owner, resolves to real things and was reviewed recently.** You will model entities and relationships, store them as objects in the Kubernetes API with validation rules, query them with `kubectl` and `jq`, and find the entries that are stale, ownerless or point at nothing.

The module has three parts. **The Catalog Model: Entities, Owners And Relationships** explains the kinds of entity, the difference between an entity and its deployment, and how a descriptor file maps to the model. **The Catalog As An API In Kubernetes** defines a `CatalogEntity` kind with a schema and rules, registers entities and queries them. **Keeping The Catalog Useful** finds stale, ownerless and dangling entries and shows who repairs each kind of fault.

## Learning Goals

- Explain the catalog as a model of software and of organizational relationships.
- Distinguish an entity from the deployment that runs it.
- Register entities through an API with validation and query their relationships.
- Detect stale, ownerless and dangling entries and explain who fixes them.

## Before You Start

You need Kubernetes basics: namespaces, Deployments, labels, `kubectl get` and `kubectl apply`. A little `jq` helps for the queries; each filter is explained where it appears.

Your playground is a single-node `kind` cluster running Kubernetes 1.35:

| Namespace | What is in it |
| --- | --- |
| `starfleet` | The `scout` and `probe` backends and the `shuttle` client |
| `outpost` | The `drifter` client |
| `catalog` | An empty namespace that will hold the catalog entries |

`kubectl` already points at the playground cluster, as the cluster administrator. Launch your playground now, and keep it running next to you while you read the parts:

<!-- astrona:playground -->
