# Solution

Solve this lab on `terminal`. This lab has not been run yet; the commands are checked statically only.

```sh
astrona run --git ssh://git@github.com/astrona-io/ATS081.git -c sections/section-020/module-01/labs/lab-01
```

## Step 1: Read the catalog

```sh
kubectl -n catalog get ent
kubectl -n catalog get ent -o json | jq -r '.items[] | .metadata.name as $n | .spec.dependsOn[]? | $n + " -> " + .'
```

The list shows scout, probe and shuttle. The second command shows that probe depends on `component:sensor-gateway`, and no entity with that name exists.

## Step 2: Register drifter and fix probe

Save this as `catalog-fix.yaml`:

```yaml
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
```

```sh
kubectl apply -f catalog-fix.yaml
astrona submit --keep --git ssh://git@github.com/astrona-io/ATS081.git -c sections/section-020/module-01/labs/lab-01
```

## Step 3: Label the Deployments

```sh
kubectl -n starfleet label deployment scout catalog.starfleet.example/entity=scout
kubectl -n starfleet label deployment probe catalog.starfleet.example/entity=probe
kubectl -n starfleet label deployment shuttle catalog.starfleet.example/entity=shuttle
kubectl -n outpost label deployment drifter catalog.starfleet.example/entity=drifter
```

Each Deployment needs its own value, so the label is set once per Deployment.

```sh
kubectl get deployments -A -L catalog.starfleet.example/entity
astrona submit --keep --git ssh://git@github.com/astrona-io/ATS081.git -c sections/section-020/module-01/labs/lab-01
```

Destroy the lab when you are done:

```sh
astrona destroy ats-081-lab-020-01
```
