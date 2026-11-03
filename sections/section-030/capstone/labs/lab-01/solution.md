# Solution

Solve this lab on `terminal`. This lab has not been run yet; the commands are checked statically only.

```sh
astrona run --git ssh://git@github.com/astrona-io/ATS081.git -c sections/section-030/capstone/labs/lab-01
```

## Step 1: Fix the template

Read the current template and see what is missing:

```sh
kubectl -n portal get configmap golden-path-template -o jsonpath='{.data.deployment\.yaml}'
```

The template has no catalog label, no golden-path label, no readiness probe and no resources. Save the full corrected ConfigMap as `golden-path-template.yaml`:

```yaml
apiVersion: v1
    kind: ConfigMap
    metadata:
      name: golden-path-template
      namespace: portal
    data:
      deployment.yaml: |
        apiVersion: apps/v1
        kind: Deployment
        metadata:
          name: __NAME__
          namespace: starfleet
          labels:
            app: __NAME__
            owner: __OWNER__
            catalog.starfleet.example/entity: __NAME__
            platform.starfleet.example/golden-path: "true"
        spec:
          replicas: 1
          selector:
            matchLabels:
              app: __NAME__
          template:
            metadata:
              labels:
                app: __NAME__
            spec:
              containers:
                - name: app
                  image: ghcr.io/stefanprodan/podinfo:6.15.0
                  ports:
                    - containerPort: 9898
                  readinessProbe:
                    httpGet:
                      path: /healthz
                      port: 9898
                  resources:
                    requests:
                      cpu: 10m
                      memory: 32Mi
                    limits:
                      memory: 64Mi
```

```sh
kubectl apply -f golden-path-template.yaml
astrona submit --keep --git ssh://git@github.com/astrona-io/ATS081.git -c sections/section-030/capstone/labs/lab-01
```

## Step 2: Render and apply the service

```sh
kubectl -n portal get configmap golden-path-template -o jsonpath='{.data.deployment\.yaml}' | sed -e 's/__NAME__/beacon/g' -e 's/__OWNER__/outpost-team/g' > beacon.yaml
kubectl apply --dry-run=server -f beacon.yaml
kubectl apply -f beacon.yaml
kubectl -n starfleet rollout status deployment/beacon --timeout=180s
astrona submit --keep --git ssh://git@github.com/astrona-io/ATS081.git -c sections/section-030/capstone/labs/lab-01
```

## Step 3: Update the portal list

Save this as `portal-catalog.yaml`:

```yaml
apiVersion: v1
    kind: ConfigMap
    metadata:
      name: portal-catalog
      namespace: portal
    data:
      services.json: |
        {
          "updated": "2026-11-02",
          "services": [
          {"name": "scout", "owner": "starfleet-team", "lifecycle": "production", "docs": "docs/scout"},
          {"name": "probe", "owner": "starfleet-team", "lifecycle": "production", "docs": "docs/probe"},
          {"name": "shuttle", "owner": "starfleet-team", "lifecycle": "production", "docs": "docs/shuttle"},
          {"name": "drifter", "owner": "outpost-team", "lifecycle": "experimental", "docs": "docs/drifter"},
          {"name": "beacon", "owner": "outpost-team", "lifecycle": "experimental", "docs": "docs/beacon"}
          ]
        }
```

```sh
kubectl apply -f portal-catalog.yaml
```

The change reaches the running portal after up to about a minute. Read the served list until it shows five services:

```sh
kubectl -n outpost exec deploy/drifter -- curl -s http://portal.portal.svc.cluster.local/services.json | jq '[.services[].name]'
```

## Step 4: Compute and publish the report

Count the Deployments, count the labelled ones and compute the coverage from the portal list:

```sh
kubectl get deployments -A -o json | jq '[.items[] | select(.metadata.namespace == "starfleet" or .metadata.namespace == "outpost")] | {total: length, goldenPath: [.[] | select(.metadata.labels["platform.starfleet.example/golden-path"] == "true")] | length}'
```

The output shows `total` 5 and `goldenPath` 1. The portal lists 5 of 5 services, so the coverage is 100. Create the report:

```sh
kubectl -n portal create configmap adoption-report --from-literal=total=5 --from-literal=goldenPath=1 --from-literal=coverage=100
astrona submit --keep --git ssh://git@github.com/astrona-io/ATS081.git -c sections/section-030/capstone/labs/lab-01
```

Destroy the lab when you are done:

```sh
astrona destroy ats-081-capstone-030
```
