---
draft: true
exam_objectives:
  - Developer Portals for Platform Adoption
---
# Software Templates In Depth

A software template turns a request for a new service into a repository, a first commit and a catalog entry, without a ticket. In Backstage the feature is called the Scaffolder, and a template is a YAML file of the kind `Template`. This module shows how such a file is built, what each part does and how a platform team keeps templates and the services they create healthy.

Keep one sentence in mind: **a template is a small program in YAML, with inputs, steps and outputs, so it needs the same review, tests and versioning as code.** You will read the anatomy of a template, write the input form, chain the steps with their actions, and manage templates over time.

The module has four parts. **The Anatomy Of A Template** covers the kind, the metadata and the three main sections. **Parameters, Validation And Form Fields** covers the input form and its rules. **Steps, Actions And Outputs** covers the actions that fetch files, publish a repository and register the entity. **Template Lifecycle: Versioning, Testing And Updates** covers dry runs, versions and the problem of services that were created from an old template.

## Learning Goals

- Describe the sections of a Scaffolder template: parameters, steps and output.
- Validate user input with a JSON Schema type, `required`, `pattern` and `enum`.
- Chain steps with `fetch:template`, a publish action and `catalog:register`.
- Pass the output of one step to a later step.
- Explain how templates are tested, versioned and kept up to date.

## Before You Start

You need YAML basics and the idea of a golden path: a supported way to start a service. The playground has no Backstage installation. It stores a template as text in a ConfigMap, which is enough to practise the structure and to check it with shell tools.

Your playground is a single-node `kind` cluster running Kubernetes 1.35. The namespace `portal` holds the ConfigMap `scaffolder-templates` with the template `starfleet-service`. Launch your playground now:

<!-- astrona:playground -->
