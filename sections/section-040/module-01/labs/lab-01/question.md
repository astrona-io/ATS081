# Question

Solve this question on: `terminal`

The platform team runs an assistant that analyses the Starfleet workloads and proposes changes. The assistant uses the ServiceAccount `ops-assistant` in the namespace `assistant`. It was started with the built-in `edit` role in the namespace `starfleet`, which is far too much. A proposal is a ConfigMap in `assistant` with the label `proposal-status`. The ConfigMap `proposal-001` waits with the status `proposed`. `kubectl` points at the cluster as the cluster administrator.

Bound the assistant:

1. Remove the RoleBinding `ops-assistant-edit` in `starfleet`.
2. Let the assistant read Deployments and Pods in `starfleet` (`get`, `list`, `watch`), and nothing else there. It must not read Secrets.
3. Let the assistant only create ConfigMaps in `assistant`. It must not update, patch or delete them.
4. Add an admission policy so that a ConfigMap that the assistant creates in `assistant` is denied unless the label `proposal-status` has the value `proposed`. Requests from other users must not be affected.
5. Let the user `platform-reviewer` get, list, watch, update and patch ConfigMaps in `assistant`, and nothing else.

You can test as another identity with `kubectl auth can-i ... --as=system:serviceaccount:assistant:ops-assistant`.
