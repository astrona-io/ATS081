---
draft: true
exam_objectives:
  - Developer Portals for Platform Adoption
---
# Parameters, Validation And Form Fields

The form is the first thing a developer sees. A good form asks only for what the platform cannot decide itself, and it rejects wrong values before any step runs. This part shows how to describe the form and its rules.

## Parameters are JSON Schema

The `parameters` field is a list of pages, and each page is a JSON Schema object. A page has a `title`, a `required` list and a `properties` map. Each property has a `type`, such as `string`, `integer` or `boolean`, and a `title` for the label. This is the same schema language that Kubernetes uses in a CustomResourceDefinition.

Rules go on the property.

- `pattern` is a regular expression that the value must match.
- `enum` lists the allowed values, and the form shows a drop-down.
- `default` fills the field in advance.
- `maxLength` and `minLength` limit text.

A complete form definition looks like this:

```yaml
parameters:
  - title: Service details
    required:
      - name
      - owner
    properties:
      name:
        title: Name
        type: string
        description: Lowercase letters, digits and hyphens
        pattern: '^[a-z][a-z0-9-]{2,30}$'
      owner:
        title: Owner
        type: string
        ui:field: OwnerPicker
        ui:options:
          catalogFilter:
            kind: Group
      tier:
        title: Tier
        type: string
        enum:
          - standard
          - critical
        default: standard
```

The form has three fields. The name must match the pattern, the owner is picked from the groups in the catalog, and the tier is a drop-down with a default.

## Form fields from the portal

Keys that start with `ui:` are not part of JSON Schema. They tell the portal how to draw a field. The key `ui:field` selects a custom field. The built-in `OwnerPicker` shows a list of owners from the catalog, and `EntityPicker` lets the user select any entity. The key `ui:options` passes settings such as `catalogFilter`. The key `ui:widget` selects a widget for a simple type, for example a text area.

The picker is more than convenience. It makes a typo in the owner impossible, because the user selects an existing group and cannot invent one. A catalog that depends on owners should never accept a free-text owner.

## Rules belong in more than one place

A pattern in the form helps users, and it does not enforce anything by itself. A client other than the portal can call the Scaffolder API with any value. A step that creates a repository should therefore check the name again, or the receiving system must reject names it cannot use. This is the same lesson as a self-service request API: the form guides, and the server enforces.

## Several pages

A template can have more than one entry in the list. The portal then shows a wizard with a step for each page, and a final page that summarises the answers. Use pages to split a long form, for example service details, then infrastructure choices, then repository settings. A short form that needs only the name and the owner is better than a long form that asks for everything.

<!-- astrona:playground:renew -->
You can check which parameters the stored template requires:

```sh
kubectl get configmap scaffolder-templates -n portal -o jsonpath='{.data.template\.yaml}' | grep -n -A3 'required'
```

If the command prints nothing, the template does not mark any parameter as required, and the form accepts an empty submission.

## Common pitfalls

> [!WARNING]
> - A field that is not in `required` can be empty, and the steps then receive an empty value.
> - A regular expression without `^` and `$` matches a part of the value. Anchor the pattern.
> - Do not ask the user for values that the platform already knows, such as the organization name.
