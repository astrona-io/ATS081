# Question

Solve this question on: `terminal`

The platform team of the `starfleet` fleet published the kind `EnvironmentRequest` in the API group `platform.starfleet.example`, version `v1alpha1`, with the CustomResourceDefinition `environmentrequests.platform.starfleet.example`. Developers of the namespace `team-alpha` use it, but the schema accepts any value. `kubectl` points at the cluster as the cluster administrator.

Change the CustomResourceDefinition so that:

1. `spec.class` accepts only `small` and `medium`, and has the default `small`.
2. `spec.ttlHours` accepts whole numbers from 1 to 72, and has the default 24.
3. A request whose `spec.owner` does not end with `-team` is rejected with the message `owner must end with -team`. Use a validation rule on `spec`.
4. The kind has a status subresource.

A request that only sets `spec.owner: alpha-team` must be accepted.
