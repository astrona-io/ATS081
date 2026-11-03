---
draft: true
exam_objectives:
  - Developer Portals for Platform Adoption
---
# Summary

A Scaffolder template is a YAML file of the kind Template. It has an owner, a type, a list of parameters that describe the input form, a list of steps that do the work and an output section that gives the user links. The portal draws the form, and the Scaffolder backend runs the steps.

The parameters are JSON Schema. Types, required lists, patterns, enums and defaults check the input, and keys that start with ui: choose how a field looks. Pickers such as the owner picker stop typos by letting the user select an existing entity. A form guides the user and enforces nothing for other clients, so the receiving systems must check values too.

Steps call actions. The action fetch:template copies the skeleton and replaces placeholders, a publish action creates the repository, and catalog:register adds the new descriptor to the catalog. A step can read the output of earlier steps, so the order of the steps matters. A template that publishes a repository but does not register it creates services that nobody can find.

A template needs code practices. It is reviewed, validated in a pipeline, rendered with sample values and run in dry-run mode. Versions are tracked with tags, and breaking changes ship as a new template. Services do not update when the template changes, so the platform keeps the rules that change often in a central place and measures how many services still carry the golden-path label.

- Required fields and patterns protect the steps from empty or wrong values.
- Every template that creates a repository must also register the entity.
- Rules in a shared place cannot drift; rules in a skeleton can.

<!-- astrona:playground:destroy -->
