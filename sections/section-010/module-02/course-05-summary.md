---
draft: true
exam_objectives:
  - Simplified Access to Platform Capabilities
---
# Summary

A namespace is a scope for names and for policy. It does not isolate workloads by itself: Pods of different namespaces share nodes and can reach each other over the network unless a control stops them. A tenant is a namespace that carries a label for its identity and a set of enforced controls.

A ResourceQuota limits the total resources and the object count of a namespace, and the API server enforces it at admission. A quota on compute resources makes requests mandatory, so a LimitRange adds defaults for containers that state no values and can set a maximum. Defaults are added before the quota is checked.

A NetworkPolicy selects Pods and allows traffic. An empty pod selector with the type Ingress and no rules denies all ingress traffic. The network plugin enforces the policy, so a plugin without support leaves the object without effect. Pod Security Admission checks Pods against the privileged, baseline or restricted standard through namespace labels, and the labels enforce, warn and audit choose between rejecting, warning and recording.

A tenant bundle collects these objects so that every tenant is created the same way, from a script, a GitOps repository or a controller. Server-side dry runs test the bundle by showing that a violating Pod is rejected and a plain Pod is accepted.

- A namespace is a policy boundary only after quota, limits, network rules and Pod Security are in place.
- Defaults from a LimitRange make a compute quota usable.
- NetworkPolicy needs a network plugin that enforces it.
- Use warn before enforce when you tighten a level.

<!-- astrona:playground:destroy -->
