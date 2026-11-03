---
draft: true
exam_objectives:
  - AI/ML in Platform Automation
---
# Serving Models And Platform Guardrails

A trained model has no value until applications can call it. Serving a model is closer to running a web service than to running a Job, and it brings the usual guardrails. This part shows how a model server is run, scaled and changed safely, and how the platform watches it.

## A model server is a Deployment

The simplest model server is a container that loads a model file and answers requests over HTTP. It runs as a Deployment behind a Service. The container must declare resource requests and limits, because a model that loads into memory can use more than expected. A readiness probe is more important here than for most services, because loading a large model can take minutes. A Pod that is not ready must not receive requests.

A **startup probe** gives the container extra time to load the model before the liveness probe starts to judge it. Without it, a slow load can lead to a restart loop.

## Tools that serve models

KServe is a Kubernetes add-on that defines a custom resource, `InferenceService`. The user states the model format and the location of the model files, and the controller creates the Deployment, the Service, the autoscaling and the routing. This follows the same pattern as the self-service requests in this course: the user states what they need, and a controller builds the objects. The platform team chooses whether to offer KServe or a plain Deployment template.

## Scaling

A **HorizontalPodAutoscaler** (HPA) changes the number of replicas from a metric. For a model server the best metric is often requests per second or latency, not CPU. A GPU server can be idle on the CPU and busy on the GPU. Some serving tools scale to zero when no requests arrive, which saves money, and the first request after idle waits for a start and a model load.

## Changing a model safely

A new model version should not replace the old one for all users at once. Two patterns reduce the risk. A **canary** sends a small share of requests to the new version and compares the results. A **shadow** deployment sends a copy of real requests to the new version and drops its answers, so users never see them. In both cases the model version is a label or a field on the object, and the registry records which version is in production.

## Guardrails every model server gets

The platform applies its normal guardrails, and a few more matter for ML.

- A ResourceQuota and a LimitRange on the namespace, as for every tenant.
- NetworkPolicies so that only the intended callers reach the model.
- RBAC so that the team reads the model files and the data it needs and nothing else.
- Labels for owner, model name and model version, so that cost and ownership reports work.
- Monitoring of request latency, error rate and a quality metric, such as the share of predictions that users accept.

Check which Deployments in the playground carry an owner label. This is the report that a cost review starts with:

<!-- astrona:playground:renew -->
```sh
kubectl get deployments -A -L app
```

A model server that has no owner label cannot be charged to a team, and nobody knows whom to ask when it fails.

## Common pitfalls

> [!WARNING]
> - A missing readiness probe sends requests to a server that is still loading the model.
> - Scale to zero hides the cold start from the metrics. Measure the first request.
> - Replacing a model for all users at once makes a bad model a full outage.
