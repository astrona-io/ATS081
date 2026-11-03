---
draft: true
exam_objectives:
  - Simplified Access to Platform Capabilities
---
# Summary

Self-service means that developers use a supported capability without waiting for manual work. In Kubernetes the request can be an object of a custom kind. A CustomResourceDefinition gives that kind a schema with allowed values, defaults and CEL validation rules. The API server checks every request against the schema before it stores the object, so the rules apply to every client, including scripts that never use a form.

Guardrails keep a valid request inside safe limits. A ResourceQuota limits totals in a namespace. A LimitRange sets defaults and maximums for containers. A ValidatingAdmissionPolicy with a binding expresses rules such as a required label, and its `validationActions` choose between rejecting, warning and auditing. A good rejection names the rule and the fix, and that is what separates a guardrail from a hidden approval.

Authorization is a separate decision. RBAC decides who may create or read requests, and a Role is valid in one namespace, so it gives a team a boundary. Binding a group keeps the binding stable when people change teams. The permission to write status is separate from the permission to write the request, so a user cannot mark a request as done.

Status makes asynchronous work visible. The phase and conditions tell the user whether a request is pending, ready, failed or waiting for a reviewer, and a reason explains each state. Lifecycle fields such as a time to live remove the environment without manual cleanup. Measures taken from the objects, such as time to ready and failures by reason, show whether the platform removes coordination.

- A control that exists only in a form is not a guardrail; the API server must enforce it.
- Quota, limits and admission policy check different things and work together.
- RBAC answers who may call; admission answers whether the content is acceptable.
- Status written by the component that did the work is the only status worth trusting.

<!-- astrona:playground:destroy -->
