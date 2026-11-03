# Question

Solve this question on: `terminal`

The platform team keeps the template `starfleet-service` as text in the key `template.yaml` of the ConfigMap `scaffolder-templates` in the namespace `portal`. The template creates files but no repository and no catalog entry, and its form accepts anything. `kubectl` points at the cluster as the cluster administrator.

Change the template so that:

1. The parameters `name` and `owner` are in a `required` list.
2. The parameter `name` has a `pattern`.
3. After the step `fetch` there is a step with the action `publish:github`, and after it a step with the action `catalog:register`.
4. The `output` section has a link with an `entityRef` that comes from the output of the register step.

Keep the step `fetch` and the owner of the template.
