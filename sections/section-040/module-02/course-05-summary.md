---
draft: true
exam_objectives:
  - AI/ML in Platform Automation
---
# Summary

The machine learning lifecycle has five stages: data preparation, training, tracking and registry, serving, and monitoring. Monitoring can start the loop again. Kubernetes provides the building blocks, such as volumes, Jobs, Deployments, Services and autoscalers, and tools such as Kubeflow, MLflow and KServe add custom resources on top of them.

An accelerator is an extended resource. A device plugin on the node advertises a name such as nvidia.com/gpu, a container asks for whole devices in its limits, and the scheduler places the Pod only on a node with a free device. A ResourceQuota with the requests. prefix limits the number of devices a namespace may hold. Taints, tolerations and node labels keep ordinary workloads off expensive nodes, and Dynamic Resource Allocation lets a Pod claim a device by its properties.

Training runs as a Job. The retry limit, the clean-up time and the suspend field control the lifecycle. A PriorityClass orders Pods when capacity is short, and the preemption policy decides whether a class may evict others. A queueing system admits suspended Jobs when the resources they need are free.

A model server is a Deployment or a custom resource behind a Service. It needs resource limits, readiness and startup probes, a scaling metric that matches the real bottleneck, and a rollout pattern such as a canary or a shadow deployment. The normal platform guardrails apply, with labels for owner, model name and version.

- Count scarce hardware with a quota and give batch work a low priority.
- Set a clean-up time on every Job.
- Roll out a new model to a small share of requests first.

<!-- astrona:playground:destroy -->
