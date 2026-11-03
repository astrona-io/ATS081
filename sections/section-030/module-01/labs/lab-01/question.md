# Question

Solve this question on: `terminal`

The developer portal of the `starfleet` fleet runs in the namespace `portal`. The Deployment `portal` serves the file `services.json` from the ConfigMap `portal-catalog`. The portal lists only two services, one has the placeholder owner `unassigned`, and the `updated` date is old. The cluster runs the services `scout`, `probe` and `shuttle` in `starfleet`, and `drifter` in `outpost`. `kubectl` points at the cluster as the cluster administrator.

Refresh the portal list by changing the ConfigMap `portal-catalog`:

1. The list contains the four services `scout`, `probe`, `shuttle` and `drifter`, and nothing else.
2. `scout`, `probe` and `shuttle` are owned by `starfleet-team` and have the lifecycle `production`. `drifter` is owned by `outpost-team` and has the lifecycle `experimental`. Every entry has a `docs` value.
3. The `updated` field is a date from 2026-11-01 or later.

The change reaches the running portal after a short delay. The portal can be read from the `drifter` Pod at `http://portal.portal.svc.cluster.local/services.json`.
