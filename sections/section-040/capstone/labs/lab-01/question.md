# Question

The platform team ran the assistant `ops-assistant` for a first period. A proposal is a ConfigMap in the namespace `assistant` with the label `proposal-status` (`accepted`, `rejected` or `proposed`). Twelve proposals exist: some were reviewed, and some still wait. The assistant still runs with the built-in `edit` role in `starfleet`. `kubectl` points at the cluster as the cluster administrator.

Solve this question on: `terminal`

Finish the work:

1. Remove the RoleBinding `ops-assistant-edit` in `starfleet`. Let the assistant read Deployments and Pods in `starfleet` (`get`, `list`, `watch`) and nothing else there; it must not read Secrets.
2. Let the assistant only create ConfigMaps in `assistant`; it must not update, patch or delete them.
3. Deny ConfigMaps that the assistant creates in `assistant` unless the label `proposal-status` is `proposed`. Requests from other users must not be affected.
4. Let the user `platform-reviewer` get, list, watch, update and patch ConfigMaps in `assistant`, and nothing else.
5. Create the ConfigMap `assistant-evaluation` in `assistant` with the keys `reviewed`, `accepted`, `rejected`, `acceptanceRate` (whole percent) and `mode`. Compute them from the proposals: proposals with the status `proposed` are not reviewed. The mode is `suggest-only` unless at least 20 proposals were reviewed and the acceptance rate is 90 or higher.
