---
draft: true
exam_objectives:
  - Simplified Access to Platform Capabilities
---
# Onboarding A Tenant As One Bundle

A tenant is useful to the platform only when it can be created the same way every time. This part collects the objects of the previous parts into a bundle, shows how to test a finished namespace and explains where the bundle can come from.

## The bundle

A **tenant bundle** is the set of objects that every tenant namespace gets. For this module the bundle has five objects. The numbers in the quota and the Pod Security level are policy choices that the platform team makes once.

| Object | Name | What it controls |
| --- | --- | --- |
| Namespace | `<tenant>` | The scope, with the label `platform.starfleet.example/tenant` and the Pod Security labels |
| ResourceQuota | `tenant-quota` | Total requests, limits and Pod count |
| LimitRange | `tenant-defaults` | Container defaults and a maximum |
| NetworkPolicy | `default-deny-ingress` | Denies ingress by default |
| RoleBinding | `tenant-developers` | Gives the team group a Role in the namespace |

A real platform also adds the RoleBinding so that the team can work in its namespace. Roles and bindings are covered where permissions are taught.

## Where the bundle comes from

The platform team can create the bundle in three ways. The first is a script or a template that applies the manifests with `kubectl apply`. The second is a GitOps repository where every tenant is a folder, and a tool such as Argo CD or Flux applies the folder. The third is a controller that watches a request object, for example a `TenantRequest`, and creates the bundle from it. All three produce the same objects. The best choice is the one that your team can review and repeat.

## Testing a tenant

You can test a tenant without installing anything. Read each object back and compare it with the policy:

<!-- astrona:playground:renew -->
```sh
kubectl get namespace team-gamma --show-labels
kubectl get resourcequota,limitrange,networkpolicy -n team-gamma
```

Then test the behaviour. A privileged Pod must fail and a plain Pod must pass. The flag `--dry-run=server` runs the full admission chain, including the Pod Security labels and the quota check, but stores nothing:

```sh
kubectl apply --dry-run=server -f pod-privileged.yaml
kubectl run plain-test -n team-gamma --image=ghcr.io/stefanprodan/podinfo:6.15.0 --dry-run=server
```

The first command is rejected and the second is accepted. A test like this belongs in the onboarding process, so that each new tenant is checked before the team gets access.

## Changing a bundle later

A tenant bundle changes over time. When the platform team raises the default memory limit, the new value applies to new Pods only. When it tightens the Pod Security level, existing Pods keep running and the `warn` label tells the owners what to fix. Plan changes like a release: announce them, use `warn` before `enforce`, and watch the quota usage.

## Common pitfalls

> [!WARNING]
> - A bundle applied by hand drifts. Keep the manifests in a repository and apply them from there.
> - A test that only reads objects does not prove behaviour. Include a dry run that must fail and one that must pass.
> - Deleting a namespace deletes everything in it. Protect tenant namespaces from accidental deletion with permissions.
