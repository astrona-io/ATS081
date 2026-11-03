---
draft: true
exam_objectives:
  - AI/ML in Platform Automation
---
# Platform Capabilities For Machine Learning Workloads

Machine learning (ML) teams are platform users with unusual needs. They train models on expensive accelerators such as graphics processing units (GPUs), run jobs that last hours, and serve models that must stay available. A platform that supports them offers these capabilities in the same self-service way as it offers a database or a namespace. This module shows how Kubernetes represents those needs and how a platform team puts guardrails around them.

Keep one sentence in mind: **an accelerator is a scarce resource, so the platform must count it, limit it and queue the work that wants it.** You will read the ML lifecycle, request accelerators as extended resources, run training as Jobs with priorities, and serve a model with the guardrails that every workload gets.

The module has four parts. **The ML Lifecycle And What The Platform Provides** lists the stages and the platform capability for each. **Accelerators As Extended Resources** explains the GPU resource name, device plugins and quotas. **Training Jobs, Queues And Priorities** covers Jobs, priority classes and queueing. **Serving Models And Platform Guardrails** covers serving, scaling, rollout and monitoring.

## Learning Goals

- Name the stages of the ML lifecycle and the platform capability each one needs.
- Request a GPU as an extended resource and limit it with a ResourceQuota.
- Run a training job as a Kubernetes Job with a retry limit, a clean-up time and a priority.
- Explain preemption and queueing for scarce resources.
- Describe the guardrails for a model server: probes, scaling, rollout and monitoring.

## Before You Start

You need Kubernetes basics: Pods, Jobs, Deployments and resource requests. You do not need to know machine learning. The playground cluster has no GPU, so the module teaches the GPU settings with quotas and objects that Kubernetes accepts without hardware.

Your playground is a single-node `kind` cluster running Kubernetes 1.35. The namespace `ml-team` holds a suspended Job named `retrain`. Launch your playground now:

<!-- astrona:playground -->
