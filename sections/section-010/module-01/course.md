---
draft: true
exam_objectives:
  - Simplified Access to Platform Capabilities
---
# Self-Service Requests, Guardrails And Useful Status

Self-service means that a developer can request and use a supported platform capability without waiting for a person to do manual work. In Kubernetes, the natural place for such a request is the Kubernetes API itself. The platform team defines a request type, the API server validates every request, and policies and permissions decide what is allowed.

Keep one sentence in mind for this module: **a form only helps the user, but the API server enforces the rule, so every guardrail must live on the server side.** You will define a request type, add guardrails that reject unsafe or unsupported requests with a clear message, give a team the right to make requests in one namespace, and read the status of a request.

The module has three parts. **A Request API With A CustomResourceDefinition** defines the kind `EnvironmentRequest` with a schema, defaults, a validation rule and a status subresource. **Guardrails With Quota, Limits And Admission Policy** adds a ResourceQuota, a LimitRange and a ValidatingAdmissionPolicy to the namespace of a team. **Authorization And Useful Request Status** uses RBAC to give a team the right to create requests, tests the permissions with impersonation, and writes status conditions that tell the user what is happening.

## Learning Goals

- Explain self-service as supported, independent use of a platform capability.
- Define a request type with a schema, defaults and validation rules.
- Distinguish guardrails that live on the server from checks in a form.
- Grant a team the right to make requests in one namespace and test the permission.
- Write request status that distinguishes accepted, pending, ready and failed.

## Before You Start

You need Kubernetes basics: namespaces, Deployments, `kubectl get`, `kubectl apply` and YAML. You do not need to know CustomResourceDefinitions, ResourceQuota or ValidatingAdmissionPolicy; each one is explained where it is used.

Your playground is a single-node `kind` cluster running Kubernetes 1.35:

| Namespace | What is in it |
| --- | --- |
| `starfleet` | The `scout` and `probe` backends and the `shuttle` client |
| `outpost` | The `drifter` client |
| `team-alpha` | An empty namespace for the example team `alpha-team` |

`kubectl` already points at the playground cluster, as the cluster administrator. Launch your playground now, and keep it running next to you while you read the parts:

<!-- astrona:playground -->
