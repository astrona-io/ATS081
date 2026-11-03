# API-Driven Service Catalogs - Playground

- **ID:** PLAYGROUND
- **Slug:** ats-081-playground-020-01
- **Author:** Paris Nakita Kejser
- **Type:** Astrona playground - clean environment, no task, no grading
- **Status:** UNTESTED. Built and checked with static checks only (`astrona validate`, `bash -n`, YAML parsing). It has not been started.

A single-node kind cluster (Kubernetes 1.35, `kindest/node:v1.35.8`).
The namespaces `starfleet`, `outpost` and `catalog` exist. The Starfleet workloads `scout`, `probe`, `shuttle` and `drifter` run. No catalog kind or entity is installed: the reading parts install them.
Nothing to submit.

## Run it

```sh
astrona run -c .
astrona destroy ats-081-playground-020-01
```

`astrona destroy` takes the environment name (`metadata.name`), not the config
path. `astrona submit` and `astrona test` do not apply: there is no grading.

## Layout

| Path | Purpose |
| --- | --- |
| `config.yaml` | Environment definition (runtime, preloaded images, starting manifests) |
| `manifests/starfleet.yaml` | Starting objects |
| `docs/overview.md` | What the environment contains and ideas to try |
