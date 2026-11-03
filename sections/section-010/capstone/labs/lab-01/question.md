# Question

Solve this question on: `terminal`

The developers of `alpha-team` work in the namespace `team-alpha`. The `EnvironmentRequest` kind is installed. Nothing else protects the namespace: no quota, no limits, no admission policy and no permissions for the team. The namespace `outpost` exists and must stay unaffected. `kubectl` points at the cluster as the cluster administrator.

Prepare `team-alpha` for self-service:

1. Create the ResourceQuota `team-quota` in `team-alpha`: at most 6 Pods and 2 CPU cores of requests.
2. Create the LimitRange `team-limits` in `team-alpha`: for containers, a default memory limit of `128Mi`, a default memory request of `64Mi` and a maximum of `512Mi`.
3. Deny Deployments that have no `owner` label, in `team-alpha` only. The rejection message must mention `owner`. Name the policy `require-owner-label`.
4. Let the group `team-alpha-developers` create, read and delete `environmentrequests` in `team-alpha`, and read Deployments there. The group must not be able to create requests in other namespaces, write request status or create Deployments.
5. Create the request `starter` in `team-alpha` with the owner `alpha-team`, and set its status to phase `Ready` with a condition of type `Ready` and status `True`.
