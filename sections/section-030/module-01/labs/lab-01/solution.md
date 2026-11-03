# Solution

Solve this lab on `terminal`. This lab has not been run yet; the commands are checked statically only.

```sh
astrona run --git ssh://git@github.com/astrona-io/ATS081.git -c sections/section-030/module-01/labs/lab-01
```

## Step 1: Read what the portal serves

```sh
kubectl -n outpost exec deploy/drifter -- curl -s http://portal.portal.svc.cluster.local/services.json
```

The file lists scout and probe, the owner of probe is `unassigned` and the date is old.

## Step 2: Replace the list

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
          {"name": "drifter", "owner": "outpost-team", "lifecycle": "experimental", "docs": "docs/drifter"}
          ]
        }
```

```sh
kubectl apply -f portal-catalog.yaml
```

## Step 3: Wait for the Pod and check

The kubelet copies the new ConfigMap into the running Pod after a short delay, up to about a minute. Read the served file until the list changes:

```sh
kubectl -n outpost exec deploy/drifter -- curl -s http://portal.portal.svc.cluster.local/services.json | jq '.updated, [.services[].name]'
astrona submit --keep --git ssh://git@github.com/astrona-io/ATS081.git -c sections/section-030/module-01/labs/lab-01
```

The output shows the date `2026-11-02` and the four names. If the old list is still served, wait ten seconds and read again.

Destroy the lab when you are done:

```sh
astrona destroy ats-081-lab-030-01
```
