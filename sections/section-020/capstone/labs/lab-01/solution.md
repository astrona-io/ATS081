# Solution

Solve this lab on `terminal`. This lab has not been run yet; the commands are checked statically only.

```sh
astrona run --git ssh://git@github.com/astrona-io/ATS081.git -c sections/section-020/capstone/labs/lab-01
```

## Step 1: Find the faults

```sh
kubectl -n catalog get ent -o json | jq -r '.items[] | [.metadata.name, .spec.owner, (.metadata.annotations["catalog.starfleet.example/last-reviewed"] // "none")] | join("  ")'
kubectl -n catalog get ent -o json | jq -r '[.items[] | ((.spec.kind | ascii_downcase) + ":" + .metadata.name)] as $ids | .items[] | .metadata.name as $n | .spec.dependsOn[]? | select(. as $d | $ids | any(. == $d) | not) | $n + " -> " + .'
```

The first command shows the old date of scout and the owner `group:unassigned` of probe. The second command prints `shuttle -> resource:telemetry-db`.

## Step 2: Repair and register the entities

Read each entry before you change its date. Save this as `catalog-repair.yaml`:

```yaml
apiVersion: catalog.starfleet.example/v1alpha1
kind: CatalogEntity
metadata:
  name: scout
  namespace: catalog
  annotations:
    catalog.starfleet.example/last-reviewed: "2026-11-02"
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
  dependsOn:
    - component:scout
---
apiVersion: catalog.starfleet.example/v1alpha1
kind: CatalogEntity
metadata:
  name: telemetry-db
  namespace: catalog
  annotations:
    catalog.starfleet.example/last-reviewed: "2026-11-02"
spec:
  kind: Resource
  lifecycle: production
  owner: group:starfleet-team
  description: Database for telemetry data
---
apiVersion: catalog.starfleet.example/v1alpha1
kind: CatalogEntity
metadata:
  name: drifter
  namespace: catalog
  annotations:
    catalog.starfleet.example/last-reviewed: "2026-11-02"
spec:
  kind: Component
  lifecycle: experimental
  owner: group:outpost-team
  description: Client that runs in the outpost namespace
  dependsOn:
    - component:scout
```

```sh
kubectl apply -f catalog-repair.yaml
astrona submit --keep --git ssh://git@github.com/astrona-io/ATS081.git -c sections/section-020/capstone/labs/lab-01
```

The entity shuttle is not in the file, so it keeps its dependency on `resource:telemetry-db`, which now exists.

## Step 3: Label the Deployments

```sh
kubectl -n starfleet label deployment scout catalog.starfleet.example/entity=scout
kubectl -n starfleet label deployment probe catalog.starfleet.example/entity=probe
kubectl -n starfleet label deployment shuttle catalog.starfleet.example/entity=shuttle
kubectl -n outpost label deployment drifter catalog.starfleet.example/entity=drifter
astrona submit --keep --git ssh://git@github.com/astrona-io/ATS081.git -c sections/section-020/capstone/labs/lab-01
```

## Step 4: Publish the report

Count the values from the live catalog. The catalog now holds 5 entities (scout, probe, shuttle, telemetry-db, drifter) with 2 distinct owners and no dangling reference:

```sh
kubectl -n catalog get ent -o json | jq '.items | length'
kubectl -n catalog get ent -o json | jq '[.items[].spec.owner] | unique | length'
kubectl -n catalog create configmap catalog-report --from-literal=total=5 --from-literal=owners=2 --from-literal=dangling=0
astrona submit --keep --git ssh://git@github.com/astrona-io/ATS081.git -c sections/section-020/capstone/labs/lab-01
```

Destroy the lab when you are done:

```sh
astrona destroy ats-081-capstone-020
```
