---
draft: true
exam_objectives:
  - Simplified Access to Platform Capabilities
---
# Authorization And Useful Request Status

A valid request type and good guardrails are not enough. The platform must also decide who may make a request, and it must tell the user what happened afterwards. If a developer can create requests in any namespace, the platform has no tenant boundary. If a developer creates a request and sees nothing for ten minutes, the developer opens a ticket anyway and self-service has failed. This part covers both: permissions with RBAC, and status that a user can read.

The commands below need the `EnvironmentRequest` kind from the request CRD and the namespace `team-alpha` in the cluster.

## Authorization with RBAC

**RBAC** (role-based access control) is the Kubernetes authorization mechanism. A **Role** lists permitted verbs on resources inside one namespace. A **RoleBinding** gives that Role to users, groups or service accounts. The API server checks RBAC after it knows who the caller is and before it runs admission. A request that RBAC refuses never reaches the guardrails.

The platform team gives the developers of `team-alpha` the right to make and read requests in their own namespace, and nothing more. The Role below allows the verbs `create`, `get`, `list`, `watch` and `delete` on `environmentrequests`, and read access to Deployments. It does not allow `update` or `patch` on the status subresource, so a developer cannot declare a request `Ready`. It also allows nothing in other namespaces, because a Role is valid in one namespace only.

The subject is a group, `team-alpha-developers`. Binding a group instead of single users means that the platform team does not change the binding when a person joins or leaves the team. The identity provider of the organization puts the person into the group.

<!-- astrona:playground:renew -->
Save this as `rbac-team-alpha.yaml`:

```yaml
apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
  name: envreq-requester
  namespace: team-alpha
rules:
  - apiGroups: ["platform.starfleet.example"]
    resources: ["environmentrequests"]
    verbs: ["create", "get", "list", "watch", "delete"]
  - apiGroups: ["apps"]
    resources: ["deployments"]
    verbs: ["get", "list", "watch"]
---
apiVersion: rbac.authorization.k8s.io/v1
kind: RoleBinding
metadata:
  name: team-alpha-developers-requester
  namespace: team-alpha
subjects:
  - kind: Group
    name: team-alpha-developers
    apiGroup: rbac.authorization.k8s.io
roleRef:
  kind: Role
  name: envreq-requester
  apiGroup: rbac.authorization.k8s.io
```

Apply it:

```sh
kubectl apply -f rbac-team-alpha.yaml
```

Then test the permissions without logging in as anyone. The flag `--as` makes `kubectl` send the request as another user, and `--as-group` adds a group. You can do this because you are the cluster administrator, who has the `impersonate` permission:

```sh
kubectl auth can-i create environmentrequests.platform.starfleet.example -n team-alpha --as=dev-jason --as-group=team-alpha-developers
kubectl auth can-i create environmentrequests.platform.starfleet.example -n outpost --as=dev-jason --as-group=team-alpha-developers
kubectl auth can-i patch environmentrequests.platform.starfleet.example --subresource=status -n team-alpha --as=dev-jason --as-group=team-alpha-developers
```

The first command prints `yes`. The second prints `no`, because the Role exists only in `team-alpha`. The third prints `no`, because the status subresource is a separate resource that the Role does not list. The command `kubectl auth can-i` asks the API server's authorization check, so the answer is the same one a real request would get.

A common mistake is to bind the built-in `edit` ClusterRole to the team. It works, but it grants far more than requests, including Secrets and deletion of most objects. Self-service stays safe when the permission matches the supported capability.

## Status the user can read

A request is asynchronous. The API call returns when the object is stored, and the work happens later. Without status, the user cannot tell the difference between "still working", "waiting for someone" and "failed". Kubernetes objects solve this with a `status` section that a controller writes. The `phase` field gives one word, and the `conditions` list gives detail. Each condition has a `type`, a `status` of `True`, `False` or `Unknown`, a machine-readable `reason` and a human-readable `message`.

Four phases are enough for most requests. `Pending` means the request is accepted and waiting. `Ready` means the capability can be used. `Failed` means the platform could not complete it and the message says why. A request that needs a reviewer stays `Pending` with a condition whose reason is `AwaitingReview`, so the user knows that a person decides and that no automation is stuck.

In production a controller writes the status. The playground has no controller, so you write it yourself, as the controller would, through the status subresource. Save this as `status-ready.yaml`:

```yaml
status:
  phase: Ready
  conditions:
    - type: Accepted
      status: "True"
      reason: SchemaValid
      message: Request passed validation
    - type: Ready
      status: "True"
      reason: NamespaceProvisioned
      message: Environment is available in team-alpha
```

Apply it to the request `scout-dev`, which exists if you created it from the request CRD. If it does not exist, create any valid `EnvironmentRequest` in `team-alpha` and use its name:

```sh
kubectl -n team-alpha patch environmentrequest scout-dev --subresource=status --type=merge --patch-file status-ready.yaml
kubectl -n team-alpha get envreq
```

The list shows the `Class` and `Phase` columns that the CRD defined with `additionalPrinterColumns`. A user who runs `kubectl get envreq` sees the phase without reading YAML.

## Lifecycle and exceptions

A request type is complete only when it covers the whole life of the environment. The `ttlHours` field is the supported way to end it. A controller reads the value and removes the environment when the time has passed, so nobody needs a manual cleanup. A change of class is an update of the same object, and a removal is `kubectl delete`. If a user needs a hidden administrator shortcut to undo a request, the capability is not really self-service.

Some needs do not fit the supported classes, such as a large environment for a load test. That is a reviewed exception. The platform should model it openly: a separate request type or a field that moves the object to `Pending` with the reason `AwaitingReview`, and a named reviewer who has permission to change the status. The user sees who must decide and why the request waits. A form that looks automatic but silently creates a ticket hides this, and users cannot tell how long to wait.

## Measuring whether self-service works

The number of requests says little. A better view comes from the objects themselves. The time between `metadata.creationTimestamp` and the moment the `Ready` condition became true shows the real wait. The count of requests that end in `Failed`, grouped by `reason`, shows which guardrail confuses users. Requests that a user deletes and creates again with a changed value show that a message was unclear. These measures point at the part of the platform to improve.

## Common pitfalls

> [!WARNING]
> RBAC and admission answer different questions: RBAC decides who may call an operation, and admission decides whether the content is acceptable. A Role cannot restrict field values, and a policy cannot grant permission. Never give users a broad ClusterRole to make a form work. Never let the user write `status`: the status must come from the component that did the work, or it proves nothing.
