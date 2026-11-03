# Platform Capabilities For Machine Learning Workloads - Playground

- **ID:** PLAYGROUND
- **Slug:** ats-081-playground-040-02
- **Author:** Paris Nakita Kejser
- **Type:** Astrona playground - clean environment, no task, no grading
- **Status:** UNTESTED. Built and checked with static checks only (`astrona validate`, `bash -n`, YAML parsing). It has not been started.

A single-node kind cluster (Kubernetes 1.35, `kindest/node:v1.35.8`).

## Run it

```sh
astrona run -c .
astrona destroy ats-081-playground-040-02
```

`astrona destroy` takes the environment name (`metadata.name`), not the config path.

## Layout

| Path | Purpose |
| --- | --- |
| `config.yaml` | Environment definition |
| `manifests/starfleet.yaml` | Starting objects |
| `docs/overview.md` | What the environment contains and ideas to try |
