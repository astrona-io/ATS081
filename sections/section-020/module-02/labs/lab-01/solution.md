# Solution

Solve this lab on `terminal`. This lab has not been run yet; the commands are checked statically only.

```sh
astrona run --git ssh://git@github.com/astrona-io/ATS081.git -c sections/section-020/module-02/labs/lab-01
```

## Step 1: Read the descriptor

```sh
kubectl get configmap entity-files -n catalog-files -o jsonpath='{.data.probe\.yaml}'
```

The lifecycle is `prod`, and the system, the annotation and the dependency are missing.

## Step 2: Replace the ConfigMap

Save this as `entity-files.yaml`:

```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: entity-files
  namespace: catalog-files
data:
  scout.yaml: |
    apiVersion: backstage.io/v1alpha1
    kind: Component
    metadata:
      name: scout
      annotations:
        backstage.io/kubernetes-id: scout
    spec:
      type: service
      lifecycle: production
      owner: group:default/scout-team
      system: navigation
  probe.yaml: |
    apiVersion: backstage.io/v1alpha1
    kind: Component
    metadata:
      name: probe
      annotations:
        backstage.io/kubernetes-id: probe
    spec:
      type: service
      lifecycle: production
      owner: group:default/probe-team
      system: navigation
      dependsOn:
        - component:default/scout
```

Apply it:

```sh
kubectl apply -f entity-files.yaml
```

## Step 3: Check the result

```sh
kubectl get configmap entity-files -n catalog-files -o jsonpath='{.data.probe\.yaml}'
```

The output shows the four changes and the unchanged owner.

Submit and destroy:

```sh
astrona submit --keep --git ssh://git@github.com/astrona-io/ATS081.git -c sections/section-020/module-02/labs/lab-01
astrona destroy ats-081-lab-020-02-01
```
