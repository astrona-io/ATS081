---
draft: true
exam_objectives:
  - API-Driven Service Catalogs
---
# The Catalog As An API In Kubernetes

A catalog in a wiki page or a spreadsheet can say anything, and nobody checks it. A catalog behind an API can refuse bad data, answer queries and be read by a portal, a script and an on-call tool in the same way. This part builds a small API-driven catalog with the tool that every Kubernetes cluster already has: a CustomResourceDefinition. You define the kind `CatalogEntity` with rules, register entities and ask relationship questions with `kubectl` and `jq`.

## Defining the entity kind

A **CustomResourceDefinition** (CRD) adds a new kind to the Kubernetes API. The API server stores the objects in etcd and validates every create and update against the OpenAPI schema in the CRD. The catalog needs three kinds of rule, and all three live in the schema so that every client, including a script, must follow them.

First, enumerations. The fields `kind` and `lifecycle` accept only a fixed list of values, so the catalog does not fill up with `Prod`, `prod` and `production`. Second, required fields. The fields `kind`, `lifecycle` and `owner` are required, so an entity cannot exist without an owner. Third, a validation rule written in the Common Expression Language (CEL): the owner must start with `group:`, so that a person's name is rejected. Each reference in `dependsOn` must also match the pattern `kind:name`, such as `component:probe`.

The object name is the entity name, so the API itself guarantees that a name is unique inside the catalog namespace. The reference `component:probe` is the entity kind in lower case, a colon and that name.

<!-- astrona:playground:renew -->
Save this as `catalogentity-crd.yaml`:

```yaml
apiVersion: apiextensions.k8s.io/v1
kind: CustomResourceDefinition
metadata:
  name: catalogentities.catalog.starfleet.example
spec:
  group: catalog.starfleet.example
  scope: Namespaced
  names:
    kind: CatalogEntity
    singular: catalogentity
    plural: catalogentities
    shortNames:
      - ent
  versions:
    - name: v1alpha1
      served: true
      storage: true
      additionalPrinterColumns:
        - name: Kind
          type: string
          jsonPath: .spec.kind
        - name: Lifecycle
          type: string
          jsonPath: .spec.lifecycle
        - name: Owner
          type: string
          jsonPath: .spec.owner
      schema:
        openAPIV3Schema:
          type: object
          properties:
            spec:
              type: object
              required:
                - kind
                - lifecycle
                - owner
              properties:
                kind:
                  type: string
                  enum:
                    - Component
                    - System
                    - API
                    - Resource
                lifecycle:
                  type: string
                  enum:
                    - experimental
                    - production
                    - deprecated
                owner:
                  type: string
                  description: Owning group, written as group:name.
                system:
                  type: string
                description:
                  type: string
                dependsOn:
                  type: array
                  items:
                    type: string
                    pattern: '^(component|api|resource|system):[a-z0-9-]+$'
              x-kubernetes-validations:
                - rule: "self.owner.startsWith('group:')"
                  message: "owner must be a group such as group:starfleet-team"
```

Apply it and check that the kind exists:

```sh
kubectl apply -f catalogentity-crd.yaml
kubectl api-resources --api-group=catalog.starfleet.example
```

The second command lists `catalogentities` with the short name `ent`. From this moment, `kubectl get ent -n catalog` works like any built-in kind.

## Registering entities

Each entity is an object in the namespace `catalog`. The last-reviewed date is an annotation, because it is metadata about the entry and not part of the entity itself. Save this as `entities-starfleet.yaml`:

```yaml
apiVersion: catalog.starfleet.example/v1alpha1
kind: CatalogEntity
metadata:
  name: scout
  namespace: catalog
  annotations:
    catalog.starfleet.example/last-reviewed: "2026-10-20"
spec:
  kind: Component
  lifecycle: production
  owner: group:starfleet-team
  system: starfleet-system
  description: Backend service that answers fleet queries
---
apiVersion: catalog.starfleet.example/v1alpha1
kind: CatalogEntity
metadata:
  name: probe
  namespace: catalog
  annotations:
    catalog.starfleet.example/last-reviewed: "2026-10-20"
spec:
  kind: Component
  lifecycle: production
  owner: group:starfleet-team
  system: starfleet-system
  description: Test target that echoes requests
---
apiVersion: catalog.starfleet.example/v1alpha1
kind: CatalogEntity
metadata:
  name: shuttle
  namespace: catalog
  annotations:
    catalog.starfleet.example/last-reviewed: "2026-10-20"
spec:
  kind: Component
  lifecycle: production
  owner: group:starfleet-team
  system: starfleet-system
  description: Client that calls scout and probe
  dependsOn:
    - component:scout
    - component:probe
```

Apply it and list the entities:

```sh
kubectl apply -f entities-starfleet.yaml
kubectl -n catalog get ent
```

The list shows the printer columns from the CRD: kind, lifecycle and owner. Now test a rule. Change `owner: group:starfleet-team` to `owner: jason` in a copy of one entity and apply it. The API server rejects the object with the message from the CEL rule. The same happens for `lifecycle: prod`, which is not in the enumeration. The catalog protects its own data.

## Asking relationship questions

The data is useful because a query can follow the links. `kubectl get -o json` returns every entity, and `jq` filters the result. The filter `.items[]` goes through each entity in the list.

Who owns `probe`?

```sh
kubectl -n catalog get ent probe -o jsonpath='{.spec.owner}{"\n"}'
```

Which entities depend on `probe`? This is the question an on-call engineer asks when `probe` fails. The filter keeps the entities whose `dependsOn` list contains the reference, and prints their names:

```sh
kubectl -n catalog get ent -o json | jq -r '.items[] | select(.spec.dependsOn[]? == "component:probe") | .metadata.name'
```

The `?` after `dependsOn[]` makes the filter skip entities that have no dependencies instead of failing. The command prints `shuttle`. Reversing the question gives the forward view: the dependencies of `shuttle` are in `.spec.dependsOn`.

Which entities does each owner own? Group the list by owner:

```sh
kubectl -n catalog get ent -o json | jq -r '.items | group_by(.spec.owner)[] | .[0].spec.owner + ": " + (map(.metadata.name) | join(", "))'
```

Every one of these queries uses the same API that a portal would use. A portal does not need a special integration: it calls the same list endpoint and shows the result.

## Linking entities to running workloads

An entity is a stable identity, and the Deployments are its instances. The link is a label. Add the label to the `scout` Deployment, then select by it:

```sh
kubectl -n starfleet label deployment scout catalog.starfleet.example/entity=scout
kubectl get deployments -A -l catalog.starfleet.example/entity=scout
```

Any tool that knows the entity name can now find every Deployment that runs it, in any namespace. The reverse also works: from a Deployment, the label gives the entity, and the entity gives the owner. During an incident, that chain turns "this pod is failing" into "this team must be called".

Labels are not checked against the catalog. A label with a typo, such as `entity=scot`, links to nothing, and Kubernetes does not complain. A check that compares the labels with the entity names has to exist somewhere, and the next part builds those checks.

## Who writes to the catalog

Two controls decide the quality of the data. RBAC decides who can create and change entities: owners may change their own entries, and the platform team owns the schema. The CRD rules decide what is acceptable content. Together they let many teams write to one catalog without making it inconsistent.

## Common pitfalls

> [!WARNING]
> A schema cannot check that a reference points at an existing entity, because a CRD rule sees only the object that it validates. A `dependsOn` entry for a missing entity is accepted, so a separate check must find dangling references. Also, a label on a Deployment is not validated: a mistyped entity label silently breaks the link between a running workload and its entry.
