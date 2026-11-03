# Solution

Solve this lab on `terminal`. This lab has not been run yet; the commands are checked statically only.

```sh
astrona run --git ssh://git@github.com/astrona-io/ATS081.git -c sections/section-010/capstone/labs/lab-01
```

## Step 1: Quota and limits

Save this as `team-alpha-limits.yaml`:

```yaml
apiVersion: v1
kind: ResourceQuota
metadata:
  name: team-quota
  namespace: team-alpha
spec:
  hard:
    pods: "6"
    requests.cpu: "2"
---
apiVersion: v1
kind: LimitRange
metadata:
  name: team-limits
  namespace: team-alpha
spec:
  limits:
    - type: Container
      defaultRequest:
        memory: 64Mi
      default:
        memory: 128Mi
      max:
        memory: 512Mi
```

```sh
kubectl apply -f team-alpha-limits.yaml
astrona submit --keep --git ssh://git@github.com/astrona-io/ATS081.git -c sections/section-010/capstone/labs/lab-01
```

## Step 2: The owner label policy

Save this as `vap-require-owner.yaml`:

```yaml
apiVersion: admissionregistration.k8s.io/v1
kind: ValidatingAdmissionPolicy
metadata:
  name: require-owner-label
spec:
  failurePolicy: Fail
  matchConstraints:
    resourceRules:
      - apiGroups: ["apps"]
        apiVersions: ["v1"]
        operations: ["CREATE", "UPDATE"]
        resources: ["deployments"]
  validations:
    - expression: "has(object.metadata.labels) && 'owner' in object.metadata.labels"
      messageExpression: "'Deployment ' + object.metadata.name + ' needs the label owner'"
---
apiVersion: admissionregistration.k8s.io/v1
kind: ValidatingAdmissionPolicyBinding
metadata:
  name: require-owner-label-team-alpha
spec:
  policyName: require-owner-label
  validationActions:
    - Deny
  matchResources:
    namespaceSelector:
      matchLabels:
        kubernetes.io/metadata.name: team-alpha
```

```sh
kubectl apply -f vap-require-owner.yaml
kubectl -n team-alpha create deployment no-owner --image=ghcr.io/stefanprodan/podinfo:6.15.0 --dry-run=server
```

The dry run fails after a few seconds, when the policy is active, and the message mentions `owner`. The binding selects only `team-alpha`, so `outpost` is not affected.

## Step 3: Permissions for the team

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

```sh
kubectl apply -f rbac-team-alpha.yaml
kubectl auth can-i create environmentrequests.platform.starfleet.example -n outpost --as=dev-jason --as-group=team-alpha-developers
```

The second command prints `no`. Then submit again with `astrona submit --keep --git ssh://git@github.com/astrona-io/ATS081.git -c sections/section-010/capstone/labs/lab-01`.

## Step 4: The request and its status

Save this as `envreq-starter.yaml`:

```yaml
apiVersion: platform.starfleet.example/v1alpha1
kind: EnvironmentRequest
metadata:
  name: starter
  namespace: team-alpha
spec:
  owner: alpha-team
```

Save this as `status-ready.yaml`:

```yaml
status:
  phase: Ready
  conditions:
    - type: Ready
      status: "True"
      reason: NamespaceProvisioned
      message: Environment is available in team-alpha
```

```sh
kubectl apply -f envreq-starter.yaml
kubectl -n team-alpha patch environmentrequest starter --subresource=status --type=merge --patch-file status-ready.yaml
astrona submit --keep --git ssh://git@github.com/astrona-io/ATS081.git -c sections/section-010/capstone/labs/lab-01
```

Destroy the lab when you are done:

```sh
astrona destroy ats-081-capstone-010
```
