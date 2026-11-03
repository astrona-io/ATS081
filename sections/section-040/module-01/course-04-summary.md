---
draft: true
exam_objectives:
  - AI/ML in Platform Automation
---
# Summary

An AI assistant suits tasks where the input is messy and a person can check the result quickly: summarizing, classifying, explaining and drafting. Tasks whose failure is costly or hard to undo belong to tested, deterministic automation or to a change that a person approves. The assistant decides what to propose, and tested automation and people decide what to do.

An assistant is not deterministic, it can be wrong with confidence, and the text it reads can steer it. Because of the last point, its authority must not depend on what it reads. In Kubernetes the authority of the assistant is the permission set of its ServiceAccount. A broad role such as `edit` lets a mistake delete Deployments and read Secrets, and `kubectl auth can-i --as=...` shows this before it happens.

Bounded authority has two mechanisms. RBAC limits the verbs: the assistant gets read access to the workloads and `create` on proposals, and it cannot update or delete anything. RBAC is additive, so the broad binding must be deleted. A ValidatingAdmissionPolicy limits the content: it reads the caller in `request.userInfo` and forces the label `proposal-status: proposed` on proposals from the assistant, so it cannot approve its own work. Only the reviewer changes the status.

Evaluation measures whether the proposals are good. The acceptance rate is accepted divided by accepted plus rejected, and proposals that still wait are left out. Rejection reasons show whether the assistant misread the situation or proposed an action that should be impossible. A minimum number of reviewed proposals and a sample re-review keep the number honest. The mode stays `suggest-only` until the evidence supports more authority, and it returns to `suggest-only` when the rate falls.

- The credentials of the assistant are its authority; keep them small.
- Use an admission policy for what the assistant writes, and RBAC for what it calls.
- A proposal needs a recorded outcome and a reason when it is rejected.
- Decide the assistant's mode from reviewed proposals, not from impressions.

<!-- astrona:playground:destroy -->
