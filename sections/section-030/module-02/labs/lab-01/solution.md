# Solution

Solve this lab on `terminal`. This lab has not been run yet; the commands are checked statically only.

```sh
astrona run --git ssh://git@github.com/astrona-io/ATS081.git -c sections/section-030/module-02/labs/lab-01
```

## Step 1: Read the template

```sh
kubectl get configmap scaffolder-templates -n portal -o jsonpath='{.data.template\.yaml}'
```

The form has no `required` list and no pattern, and there is one step only.

## Step 2: Replace the ConfigMap

Save this as `scaffolder-templates.yaml`:

```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: scaffolder-templates
  namespace: portal
data:
  template.yaml: |
    apiVersion: scaffolder.backstage.io/v1beta3
    kind: Template
    metadata:
      name: starfleet-service
      title: Starfleet Service
      description: Creates a service with the platform rules
    spec:
      owner: group:default/platform-team
      type: service
      parameters:
        - title: Service details
          required:
            - name
            - owner
          properties:
            name:
              title: Name
              type: string
              pattern: '^[a-z][a-z0-9-]{2,30}$'
            owner:
              title: Owner
              type: string
      steps:
        - id: fetch
          name: Fetch skeleton
          action: fetch:template
          input:
            url: ./skeleton
            values:
              name: ${{ parameters.name }}
              owner: ${{ parameters.owner }}
        - id: publish
          name: Publish repository
          action: publish:github
          input:
            repoUrl: github.com?owner=starfleet&repo=${{ parameters.name }}
        - id: register
          name: Register in the catalog
          action: catalog:register
          input:
            repoContentsUrl: ${{ steps['publish'].output.repoContentsUrl }}
            catalogInfoPath: /catalog-info.yaml
      output:
        links:
          - title: Open in catalog
            icon: catalog
            entityRef: ${{ steps['register'].output.entityRef }}
```

Apply it:

```sh
kubectl apply -f scaffolder-templates.yaml
```

## Step 3: Check the result

```sh
kubectl get configmap scaffolder-templates -n portal -o jsonpath='{.data.template\.yaml}' | grep -n -E 'required|pattern|action:|entityRef'
```

The output lists the required parameters, the pattern, the three actions in order and the output link.

Submit and destroy:

```sh
astrona submit --keep --git ssh://git@github.com/astrona-io/ATS081.git -c sections/section-030/module-02/labs/lab-01
astrona destroy ats-081-lab-030-02-01
```
