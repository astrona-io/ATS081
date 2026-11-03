---
draft: true
exam_objectives:
  - Simplified Access to Platform Capabilities
---
# Section 010: Simplified Access to Platform Capabilities

This section teaches you to offer a platform capability as a Kubernetes API that developers use without a ticket. You define a request type with a CustomResourceDefinition, add guardrails with a ResourceQuota, a LimitRange and an admission policy, and give a team only the permissions it needs.

**Exam objective covered:** Simplified Access to Platform Capabilities

---

## What You Will Master

- Define a request kind with a schema, defaults, a validation rule and a status subresource.
- Explain why a guardrail must live on the server side and not in a form.
- Add a ResourceQuota, a LimitRange and a ValidatingAdmissionPolicy to a team namespace.
- Grant a group only the verbs it needs with a Role and a RoleBinding, and test it with `kubectl auth can-i --as`.
- Write request status that tells the developer what happened and what to do next.

---

## The Learning Path

### 1. Self-Service Requests, Guardrails And Useful Status
*   **Module Reader:** **[Module 1: Self-Service Requests, Guardrails And Useful Status](./module-01/course.md)**
*   **Hands-on Playground:** `sections/section-010/module-01/playground` - kind cluster. The namespaces `team-alpha` and `outpost` exist and nothing protects `team-alpha`.
    ```bash
    astrona run --git ssh://git@github.com/astrona-io/ATS081.git -c sections/section-010/module-01/playground
    ```
*   **Lab:** Harden The EnvironmentRequest API - `sections/section-010/module-01/labs/lab-01` (UNTESTED)
    ```bash
    astrona run --git ssh://git@github.com/astrona-io/ATS081.git -c sections/section-010/module-01/labs/lab-01
    astrona submit -c .
    ```

### Section Capstone Challenge
*   **Comprehensive Challenge:** Simplified Access Capstone - `sections/section-010/capstone/labs/lab-01` (UNTESTED)
    ```bash
    astrona run --git ssh://git@github.com/astrona-io/ATS081.git -c sections/section-010/capstone/labs/lab-01
    astrona submit -c .
    ```
*   **Hands-on Objective:** Prepare the namespace `team-alpha` for self-service: a quota, default limits, a policy that denies Deployments without an `owner` label, permissions for the group `team-alpha-developers` and a request with a `Ready` status. The grader checks live cluster state and that `outpost` stays unaffected.

### Knowledge Check
*   **Quiz:** 11 questions in `sections/section-010/quiz.yaml`. The pass score is 70 percent.
