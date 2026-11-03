---
draft: true
exam_objectives:
  - AI/ML in Platform Automation
---
# AI-Assisted Automation, Bounded Authority And Evaluation

An AI assistant can read logs, summarize an incident, classify a ticket and draft a change for a platform team. It can also be wrong in a convincing way, and it can be steered by the text it reads. For this reason the question that matters for platform work is not how clever the assistant is. The question is what the assistant is allowed to do, who checks what it proposes, and how the team learns whether the proposals are good.

Keep one sentence in mind for this module: **an assistant gets exactly the authority that its credentials give it, so limit the credentials, route every change through a reviewer, and measure the proposals.** You will give an assistant a Kubernetes identity, reduce its permissions to reading and proposing, enforce its proposal status with an admission policy, and compute an acceptance rate from reviewed proposals.

The module has three parts. **Where AI Fits In Platform Automation** explains the tasks and the risks and shows an over-privileged assistant. **Bounded Authority** builds read-only and propose-only permissions with a policy that cannot be skipped. **Evaluation And Feedback** reviews proposals, computes the acceptance rate and decides how much authority the assistant keeps.

## Learning Goals

- Explain which platform tasks suit an assistant and which need deterministic automation.
- Limit an assistant with RBAC and an admission policy so that it can only read and propose.
- Route every proposal through a human reviewer with a recorded outcome.
- Compute an acceptance rate and use it to decide whether the assistant's authority changes.

## Before You Start

You need Kubernetes basics: namespaces, ServiceAccounts, ConfigMaps, Roles and RoleBindings. A little `jq` helps for the queries; each filter is explained where it appears. This module does not call a real AI service. The assistant is a Kubernetes identity, and the proposals are ConfigMaps, so that the focus stays on authority and evaluation.

Your playground is a single-node `kind` cluster running Kubernetes 1.35:

| Namespace | What is in it |
| --- | --- |
| `starfleet` | The `scout` and `probe` backends and the `shuttle` client |
| `outpost` | The `drifter` client |
| `assistant` | The namespace of the assistant, with the ServiceAccount `ops-assistant` |

`kubectl` already points at the playground cluster, as the cluster administrator. Launch your playground now, and keep it running next to you while you read the parts:

<!-- astrona:playground -->

## Reading Order

1. Where AI Fits In Platform Automation
2. Bounded Authority
3. Evaluation And Feedback
4. Summary
