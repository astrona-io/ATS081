---
draft: true
exam_objectives:
  - Developer Portals for Platform Adoption
---
# Template Lifecycle: Versioning, Testing And Updates

A template does not end when the first service is created. The template changes, and the services that it created do not change with it. This part explains how to test a template before a release, how to version it and how to handle the services that were made from an older version.

## Treat a template as code

A template lives in a repository, and every change goes through a review. The skeleton and the template file are small, and a wrong placeholder breaks every new service. Two checks belong in the pipeline of the template repository. The first checks that the template file is valid YAML and has the required sections: an owner, parameters and steps. The second renders the skeleton with sample values and checks the output files, for example that the generated `catalog-info.yaml` has an owner and a lifecycle.

## Dry runs

Backstage can run a template in a dry-run mode in the template editor of the portal. The steps run without publishing a repository, and the editor shows the files that would be created. A dry run proves that the form, the placeholders and the output work together. Do a dry run before every release of the template, with a normal value and with a value at the edge of each pattern.

## Versions

The `apiVersion` of the Template kind is the version of the file format, not the version of your template. Track the version of your own template with a Git tag or a release of the repository, and write the changes in a changelog. When a change breaks the form, for example a renamed parameter, publish a new template next to the old one, and mark the old one as deprecated in its metadata and description.

## Services drift from the template

A template creates a service once. When the platform team later changes the skeleton, for example a new base image or a new pipeline step, existing services keep the old files. The platform then runs several generations of services. There are three ways to keep them close to the template.

- Publish a notice with the change and the steps to apply it by hand.
- Use a tool that opens pull requests in every repository that carries the golden-path label, for example a dependency update tool that supports a shared preset.
- Keep rules that must change often out of the skeleton and in a shared library or a central pipeline, so that a change applies everywhere at once.

The third way is the most reliable. A rule that lives in one central place cannot drift.

<!-- astrona:playground:renew -->
You can measure the drift in the playground by counting Deployments by the label of the golden path. A Deployment without the label did not start from the template:

```sh
kubectl get deployments -A -L platform.starfleet.example/golden-path
```

The last column shows the value of the label, and it is empty for the Deployments that do not carry it. A coverage report built from this output shows how many services use the supported path.

## Common pitfalls

> [!WARNING]
> - A template without tests breaks silently. The first user finds the error.
> - Changing a parameter name breaks automation that calls the template with the old name.
> - Do not promise that services update themselves. State how the platform helps teams apply a change.
