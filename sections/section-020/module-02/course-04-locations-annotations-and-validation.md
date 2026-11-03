---
draft: true
exam_objectives:
  - API-Driven Service Catalogs
---
# Locations, Annotations And Validation

A descriptor in a repository does nothing until the catalog knows about it. This part shows how a catalog finds descriptors, which annotations connect an entity to other systems, and how to validate files before they are merged.

## Locations

A **Location** tells the catalog where to read descriptors. In Backstage there are three ways. The first is a list in the application configuration, under `catalog.locations`, with a `type` such as `url` and a `target`, for example the address of one `catalog-info.yaml` in a repository. The second is a Location entity, itself a descriptor, with `spec.targets`. The third is automatic discovery: a provider scans an organization of a code host for files with a known name.

A Location entity looks like this:

```yaml
apiVersion: backstage.io/v1alpha1
kind: Location
metadata:
  name: starfleet-services
spec:
  type: url
  targets:
    - https://github.com/starfleet/scout/blob/main/catalog-info.yaml
    - https://github.com/starfleet/probe/blob/main/catalog-info.yaml
```

A Location is a convenient place to register many repositories at once, because a team adds a line to one file and does not change the application configuration.

## Annotations

An **annotation** is a key and a value in `metadata.annotations` that connects the entity to a system outside the catalog. Plugins read them. The ones that appear most often are these.

- `backstage.io/source-location` gives the repository folder that holds the code.
- `backstage.io/techdocs-ref` points at the documentation folder, for example `dir:.`.
- `backstage.io/kubernetes-id` links the entity to Kubernetes workloads that carry the same label value.
- `backstage.io/managed-by-location` is set by the catalog itself, and you do not write it.

## Validating a descriptor before it is merged

A wrong descriptor is cheap to fix in a pull request and expensive after it spreads. A validation step in the continuous integration pipeline checks that the YAML parses, that `apiVersion`, `kind` and `metadata.name` exist, that `spec.owner` and `spec.lifecycle` exist for a Component, and that the lifecycle is one of the agreed values. The same step can check that every reference points at a known entity.

In the playground you can run a simple version of this check with shell tools. This command prints one line for every `lifecycle` value in the stored descriptors:

<!-- astrona:playground:renew -->
```sh
kubectl get configmap entity-files -n catalog-files -o json | jq -r '.data | to_entries[] | .key as $file | .value | split("\n")[] | select(test("lifecycle")) | "\($file): \(.)"'
```

Every line should end in `experimental`, `production` or `deprecated`. A different value is a finding to fix.

## Common pitfalls

> [!WARNING]
> - A Location that points at a file that does not exist makes the catalog report an error, and the entities of that file are missing.
> - Annotations are plain text. A wrong key does not raise an error; the plugin that reads it just shows nothing.
> - Discovery registers every file with the matching name. Make sure that example and test descriptors in a repository are not picked up.
