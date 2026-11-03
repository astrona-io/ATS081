---
draft: true
exam_objectives:
  - Developer Portals for Platform Adoption
---
# Summary

A developer portal is an interface to the platform and not the platform itself. It offers discovery, documentation and tasks, and it reads its data from other systems. The platform APIs and rules must work without the portal, so that a script, an engineer during an outage and a click in the portal all meet the same checks.

A portal holds a copy of data, and every copy can go out of date. The service list in the playground portal came from a ConfigMap that nobody refreshed, so it listed two of the running services. A ConfigMap update reaches the running Pod after a delay, so a reader has to wait before judging a change.

A golden path is the supported way to start a service, and a software template is its first step. The template carries the owner, the catalog label, a readiness probe and resource limits, so every service that starts from it can be found, contacted and counted. A template should be rendered and tested with a server-side dry run, and it creates a service once: later changes of the template do not update existing services.

Adoption and freshness are numbers. Golden-path adoption is the share of Deployments with the golden-path label. Portal coverage is the share of running services that the portal lists. Freshness is the age of the `updated` date. Low coverage needs automatic feeding from the catalog, and low adoption needs a conversation and support for teams that move.

- A rule that exists only in the portal is not a guardrail.
- A portal that shows a stale list loses the trust of its users for every page.
- A template that omits the catalog label produces services that nobody can find.
- Support the move to the golden path; do not only mandate it.

<!-- astrona:playground:destroy -->
