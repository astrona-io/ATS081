# Solution

Solve this lab on `terminal`. This lab has not been run yet; the commands are checked statically only.

```sh
astrona run --git ssh://git@github.com/astrona-io/ATS081.git -c sections/section-010/module-01/labs/lab-01
```

## Step 1: Read the current schema

```sh
kubectl get crd environmentrequests.platform.starfleet.example -o yaml
```

The fields `class`, `ttlHours` and `owner` are plain types with no rules, and the version has no `subresources`.

## Step 2: Add the rules

Save this as `environmentrequest-crd.yaml`. It is the full CustomResourceDefinition with the enum, the defaults, the bounds, the validation rule and the status subresource:

```yaml
apiVersion: apiextensions.k8s.io/v1
    kind: CustomResourceDefinition
    metadata:
      name: environmentrequests.platform.starfleet.example
    spec:
      group: platform.starfleet.example
      scope: Namespaced
      names:
        kind: EnvironmentRequest
        singular: environmentrequest
        plural: environmentrequests
        shortNames:
          - envreq
      versions:
        - name: v1alpha1
          served: true
          storage: true
          subresources:
            status: {}
          additionalPrinterColumns:
            - name: Class
              type: string
              jsonPath: .spec.class
            - name: Phase
              type: string
              jsonPath: .status.phase
          schema:
            openAPIV3Schema:
              type: object
              properties:
                spec:
                  type: object
                  required:
                    - owner
                  properties:
                    owner:
                      type: string
                      description: Team that owns the environment. Must end with -team.
                    class:
                      type: string
                      description: Size class. Supported values are small and medium.
                      enum:
                        - small
                        - medium
                      default: small
                    ttlHours:
                      type: integer
                      description: Hours until the environment is removed, from 1 to 72.
                      minimum: 1
                      maximum: 72
                      default: 24
                  x-kubernetes-validations:
                    - rule: "self.owner.endsWith('-team')"
                      message: "owner must end with -team"
                status:
                  type: object
                  properties:
                    phase:
                      type: string
                      enum:
                        - Pending
                        - Ready
                        - Failed
                    conditions:
                      type: array
                      items:
                        type: object
                        required:
                          - type
                          - status
                        properties:
                          type:
                            type: string
                          status:
                            type: string
                            enum:
                              - "True"
                              - "False"
                              - Unknown
                          reason:
                            type: string
                          message:
                            type: string
```

Apply it and wait until the API server serves it:

```sh
kubectl apply -f environmentrequest-crd.yaml
kubectl wait --for=condition=Established crd/environmentrequests.platform.starfleet.example --timeout=60s
```

## Step 3: Test the rules

Send requests through admission without storing them. Save this as `envreq-test.yaml`:

```yaml
apiVersion: platform.starfleet.example/v1alpha1
kind: EnvironmentRequest
metadata:
  name: test
  namespace: team-alpha
spec:
  owner: jason
  class: huge
```

```sh
kubectl create --dry-run=server -f envreq-test.yaml
```

The command fails and names the unsupported class and the owner. Change `owner` to `alpha-team` and `class` to `medium` and run it again: the request is accepted. Then submit:

```sh
astrona submit --keep --git ssh://git@github.com/astrona-io/ATS081.git -c sections/section-010/module-01/labs/lab-01
```

Destroy the lab when you are done:

```sh
astrona destroy ats-081-lab-010-01
```
