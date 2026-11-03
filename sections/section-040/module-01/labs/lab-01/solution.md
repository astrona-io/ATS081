# Solution

Solve this lab on `terminal`. This lab has not been run yet; the commands are checked statically only.

```sh
astrona run --git ssh://git@github.com/astrona-io/ATS081.git -c sections/section-040/module-01/labs/lab-01
```

## Step 1: See the current authority

```sh
kubectl auth can-i delete deployments -n starfleet --as=system:serviceaccount:assistant:ops-assistant
kubectl auth can-i get secrets -n starfleet --as=system:serviceaccount:assistant:ops-assistant
```

Both commands print `yes`. The `edit` role is the cause.

## Step 2: Roles for reading, proposing and reviewing

Save this as `assistant-roles.yaml`:

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

```sh
kubectl apply -f assistant-roles.yaml
kubectl -n starfleet delete rolebinding ops-assistant-edit
astrona submit --keep --git ssh://git@github.com/astrona-io/ATS081.git -c sections/section-040/module-01/labs/lab-01
```

RBAC is additive, so the new Roles do not remove the old permissions. The delete command does.

## Step 3: The admission policy

Save this as `assistant-policy.yaml`:

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
kubectl apply -f assistant-policy.yaml
astrona submit --keep --git ssh://git@github.com/astrona-io/ATS081.git -c sections/section-040/module-01/labs/lab-01
```

The policy needs a few seconds before it denies. The check retries for about a minute.

## Step 4: Test as the assistant

```sh
kubectl auth can-i delete deployments -n starfleet --as=system:serviceaccount:assistant:ops-assistant
kubectl auth can-i create configmaps -n assistant --as=system:serviceaccount:assistant:ops-assistant
kubectl auth can-i update configmaps -n assistant --as=system:serviceaccount:assistant:ops-assistant
```

The first and third commands print `no`, and the second prints `yes`. Destroy the lab when you are done:

```sh
astrona destroy ats-081-lab-040-01
```
