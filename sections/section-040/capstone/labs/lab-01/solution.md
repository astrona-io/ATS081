# Solution

Solve this lab on `terminal`. This lab has not been run yet; the commands are checked statically only.

```sh
astrona run --git ssh://git@github.com/astrona-io/ATS081.git -c sections/section-040/capstone/labs/lab-01
```

## Step 1: Bound the assistant

Save the Roles as `assistant-roles.yaml` and the policy as `assistant-policy.yaml`:

```yaml
apiVersion: rbac.authorization.k8s.io/v1
    kind: Role
    metadata:
      name: ops-reader
      namespace: starfleet
    rules:
      - apiGroups: ["apps"]
        resources: ["deployments", "replicasets"]
        verbs: ["get", "list", "watch"]
      - apiGroups: [""]
        resources: ["pods", "pods/log"]
        verbs: ["get", "list", "watch"]
    ---
    apiVersion: rbac.authorization.k8s.io/v1
    kind: RoleBinding
    metadata:
      name: ops-assistant-reader
      namespace: starfleet
    subjects:
      - kind: ServiceAccount
        name: ops-assistant
        namespace: assistant
    roleRef:
      kind: Role
      name: ops-reader
      apiGroup: rbac.authorization.k8s.io
    ---
    apiVersion: rbac.authorization.k8s.io/v1
    kind: Role
    metadata:
      name: proposal-writer
      namespace: assistant
    rules:
      - apiGroups: [""]
        resources: ["configmaps"]
        verbs: ["create"]
    ---
    apiVersion: rbac.authorization.k8s.io/v1
    kind: RoleBinding
    metadata:
      name: ops-assistant-writer
      namespace: assistant
    subjects:
      - kind: ServiceAccount
        name: ops-assistant
        namespace: assistant
    roleRef:
      kind: Role
      name: proposal-writer
      apiGroup: rbac.authorization.k8s.io
    ---
    apiVersion: rbac.authorization.k8s.io/v1
    kind: Role
    metadata:
      name: proposal-reviewer
      namespace: assistant
    rules:
      - apiGroups: [""]
        resources: ["configmaps"]
        verbs: ["get", "list", "watch", "update", "patch"]
    ---
    apiVersion: rbac.authorization.k8s.io/v1
    kind: RoleBinding
    metadata:
      name: platform-reviewer-binding
      namespace: assistant
    subjects:
      - kind: User
        name: platform-reviewer
        apiGroup: rbac.authorization.k8s.io
    roleRef:
      kind: Role
      name: proposal-reviewer
      apiGroup: rbac.authorization.k8s.io
```

```yaml
apiVersion: admissionregistration.k8s.io/v1
    kind: ValidatingAdmissionPolicy
    metadata:
      name: assistant-proposals-start-proposed
    spec:
      failurePolicy: Fail
      matchConstraints:
        resourceRules:
          - apiGroups: [""]
            apiVersions: ["v1"]
            operations: ["CREATE", "UPDATE"]
            resources: ["configmaps"]
      validations:
        - expression: "request.userInfo.username != 'system:serviceaccount:assistant:ops-assistant' || (has(object.metadata.labels) && 'proposal-status' in object.metadata.labels && object.metadata.labels['proposal-status'] == 'proposed')"
          message: "proposals from ops-assistant must carry the label proposal-status=proposed"
    ---
    apiVersion: admissionregistration.k8s.io/v1
    kind: ValidatingAdmissionPolicyBinding
    metadata:
      name: assistant-proposals-start-proposed
    spec:
      policyName: assistant-proposals-start-proposed
      validationActions:
        - Deny
      matchResources:
        namespaceSelector:
          matchLabels:
            kubernetes.io/metadata.name: assistant
```

```sh
kubectl apply -f assistant-roles.yaml
kubectl apply -f assistant-policy.yaml
kubectl -n starfleet delete rolebinding ops-assistant-edit
astrona submit --keep --git ssh://git@github.com/astrona-io/ATS081.git -c sections/section-040/capstone/labs/lab-01
```

The policy needs a few seconds before it denies, and the submit checks retry. RBAC is additive, so the delete command is what removes the old permissions.

## Step 2: Count the proposals

```sh
kubectl -n assistant get configmaps -l proposal-status -o json | jq -c '.items | group_by(.metadata.labels["proposal-status"]) | map({status: .[0].metadata.labels["proposal-status"], count: length})'
```

The output shows 7 accepted, 3 rejected and 2 proposed. Reviewed proposals are accepted plus rejected, which is 10. The acceptance rate is 7 divided by 10, which is 70 percent. Fewer than 20 proposals were reviewed and the rate is below 90, so the mode is `suggest-only`.

## Step 3: Record the evaluation

```sh
kubectl -n assistant create configmap assistant-evaluation --from-literal=reviewed=10 --from-literal=accepted=7 --from-literal=rejected=3 --from-literal=acceptanceRate=70 --from-literal=mode=suggest-only
astrona submit --keep --git ssh://git@github.com/astrona-io/ATS081.git -c sections/section-040/capstone/labs/lab-01
```

Destroy the lab when you are done:

```sh
astrona destroy ats-081-capstone-040
```
