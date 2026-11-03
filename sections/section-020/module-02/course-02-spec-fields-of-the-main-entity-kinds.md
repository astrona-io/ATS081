---
draft: true
exam_objectives:
  - API-Driven Service Catalogs
---
# Spec Fields Of The Main Entity Kinds

The envelope is the same for every entity, but the facts differ by kind. A service has an owner and a lifecycle, an API has a definition, and a group has members. This part lists the fields of the kinds that you meet most often, so that you can write a descriptor without a template.

## Component

A **Component** is a piece of software that a team owns, such as a service, a website or a library. Its `spec` has these fields.

- `type` names the kind of component, for example `service`, `website` or `library`. The values are free text, but a catalog should agree on a short list.
- `lifecycle` states the stage. The common values are `experimental`, `production` and `deprecated`.
- `owner` names the group or user that is responsible. It is required.
- `system` names the system that the component belongs to.
- `subcomponentOf`, `providesApis`, `consumesApis` and `dependsOn` name other entities.

## API, Resource, System and Domain

An **API** describes an interface that components provide or consume. Its `spec` has `type`, such as `openapi`, `asyncapi` or `grpc`, plus `lifecycle`, `owner`, `system` and a `definition` that holds or points to the interface description. A **Resource** is infrastructure that a component needs, such as a database or a queue, with `type`, `owner` and `system`.

A **System** is a group of components, APIs and resources that work together. A **Domain** is a group of systems that belong to one area of the business. The field `spec.domain` on a System names its Domain. These two kinds model the structure of the organization of software, and they are what lets a portal show a map.

## Group and User

A **Group** is a team or department. Its `spec` has `type`, `children` and optional `parent` and `members`. A **User** is a person, with a `memberOf` list of groups. Most organizations do not write these by hand. They import them from the identity provider.

A descriptor for the API of the `probe` looks like this:

```yaml
apiVersion: backstage.io/v1alpha1
kind: API
metadata:
  name: probe-api
  description: Status requests answered by the probe service
spec:
  type: openapi
  lifecycle: production
  owner: group:default/probe-team
  system: navigation
  definition: |
    openapi: 3.0.3
    info:
      title: probe
      version: "1.0"
    paths: {}
```

The API and the Component have the same `owner` and `system` fields. The Component names the API in its `providesApis` list. This is how the catalog knows who offers which interface.

## Checking a field with shell tools

You can check a field of a stored descriptor with `grep`. This is the same check that the lab of this module uses:

<!-- astrona:playground:renew -->
```sh
kubectl get configmap entity-files -n catalog-files -o jsonpath='{.data.probe\.yaml}' | grep -n 'lifecycle'
```

The command prints the line number and the value of `lifecycle` of the `probe` descriptor. Compare it with the allowed values above. The descriptor of the `probe` has an error that the task in this module asks you to fix.

## Common pitfalls

> [!WARNING]
> - The owner is required for a Component. An entity without an owner is a catalog quality problem.
> - `lifecycle: prod` is not a standard value. Use `production` so that filters and reports match.
> - The fields `providesApis` and `consumesApis` take entity references, not URLs.
