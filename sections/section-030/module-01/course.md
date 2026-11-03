---
draft: true
exam_objectives:
  - Developer Portals for Platform Adoption
---
# Developer Portals, Golden Paths And Supported Adoption

A developer portal is the front door of a platform. It lists what exists, shows who owns it, links to documentation and offers templates that start new work the supported way. It is not the platform. The platform is the set of APIs, controllers and policies that do the work, and the portal is one interface to them. A portal that shows data nobody maintains, or offers a template that nobody tested, teaches developers to ignore it.

Keep one sentence in mind for this module: **a portal helps adoption only while its data is current, its templates produce working and compliant services, and developers can still reach the platform without it.** You will run a small portal on Kubernetes, change what it shows, fix a golden-path template and measure how many services follow it.

The module has three parts. **The Portal And The Platform** separates the two and runs a portal that serves a service list. **Golden Paths And Software Templates** builds a template and shows what a golden path promises. **Adoption And Freshness** measures adoption and detects stale portal data.

## Learning Goals

- Distinguish a developer portal from the platform it fronts.
- Explain how a golden-path template carries platform rules into every new service.
- Measure adoption and the freshness of portal data with queries.
- Explain why alternative interfaces matter and why adoption must be supported and not forced.

## Before You Start

You need Kubernetes basics: namespaces, Deployments, ConfigMaps, Services, labels and `kubectl apply`. A little `jq` helps for the queries; each filter is explained where it appears.

Your playground is a single-node `kind` cluster running Kubernetes 1.35:

| Namespace | What is in it |
| --- | --- |
| `starfleet` | The `scout` and `probe` backends and the `shuttle` client |
| `outpost` | The `drifter` client |
| `portal` | An empty namespace that will hold the portal |

`kubectl` already points at the playground cluster, as the cluster administrator. Launch your playground now, and keep it running next to you while you read the parts:

<!-- astrona:playground -->

## Reading Order

1. The Portal And The Platform
2. Golden Paths And Software Templates
3. Adoption And Freshness
4. Summary
