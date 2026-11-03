---
draft: true
exam_objectives:
  - Simplified Access to Platform Capabilities
---
# Namespace-As-A-Service And Tenant Isolation

A platform team that offers self-service must give each team a safe place to work. In Kubernetes the usual unit for that place is the namespace. This module shows how to turn an empty namespace into a tenant: a namespace with a quota, default limits, a network rule and a Pod Security level, all created as one repeatable bundle.

Keep one sentence in mind: **a tenant boundary is only real when the cluster enforces it, so every part of the bundle must be an object that the API server or the network plugin checks.** You will label a namespace, limit what it can consume, isolate its traffic, restrict what its pods may do, and check the result with commands that need no special tools.

The module has four parts. **The Namespace As A Tenant Boundary** explains what a namespace scopes and what it does not. **Quota And Default Limits Per Tenant** adds a ResourceQuota and a LimitRange. **Network And Pod Isolation** adds a NetworkPolicy and Pod Security Admission labels. **Onboarding A Tenant As One Bundle** lists the objects together and shows how to test the finished namespace.

## Learning Goals

- Explain what a namespace isolates and what it leaves shared.
- Limit a tenant with a ResourceQuota and give containers defaults with a LimitRange.
- Deny ingress traffic by default with a NetworkPolicy and state the condition for it to work.
- Enforce a Pod Security Standard on a namespace with labels.
- Describe a tenant bundle and test it with server-side dry runs.

## Before You Start

You need Kubernetes basics: namespaces, Pods, `kubectl get` and `kubectl apply`. Each object used here is explained where it first appears.

Your playground is a single-node `kind` cluster running Kubernetes 1.35. The namespaces `starfleet` and `outpost` hold the example workloads, and the empty namespace `team-beta` is the tenant you prepare. `kubectl` points at the cluster as the cluster administrator. Launch your playground now:

<!-- astrona:playground -->
