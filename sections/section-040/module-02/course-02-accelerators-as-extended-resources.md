---
draft: true
exam_objectives:
  - AI/ML in Platform Automation
---
# Accelerators As Extended Resources

Training on a GPU is fast and expensive. A cluster usually has few GPUs, and one team can hold them all by accident. The platform must count them like any other resource and make a team ask for what it needs. This part shows how Kubernetes names an accelerator and how a quota limits it.

## Extended resources

Kubernetes schedules CPU and memory without help. For other hardware it uses **extended resources**: resource names with a domain prefix that a node advertises. A **device plugin** is a program on the node that finds the hardware, tells the kubelet how many devices exist and prepares a device for a container. The plugin for NVIDIA GPUs advertises the name `nvidia.com/gpu`.

A container asks for a GPU in its `resources.limits`. The value is a whole number, because a device cannot be split by default. You can set the limit alone, and if you also set a request, it must equal the limit. The scheduler places the Pod only on a node that has enough free devices.

Save this as `pod-gpu.yaml`:

<!-- astrona:playground:renew -->
```yaml
apiVersion: v1
kind: Pod
metadata:
  name: gpu-test
  namespace: ml-team
spec:
  containers:
    - name: train
      image: ghcr.io/stefanprodan/podinfo:6.15.0
      resources:
        limits:
          nvidia.com/gpu: 1
```

On a cluster with GPU nodes, this Pod runs on a node with a free GPU. On the playground, no node advertises `nvidia.com/gpu`. You can still send the Pod through admission with a server-side dry run:

```sh
kubectl apply --dry-run=server -f pod-gpu.yaml
```

The API server accepts the object, because the resource name is valid. If you stored it, the Pod would stay in the `Pending` state, and `kubectl describe pod gpu-test -n ml-team` would show a `FailedScheduling` event that names the missing resource.

## Quotas count accelerators

A ResourceQuota can limit an extended resource. Only the `requests.` prefix is allowed for extended resources, so the key is `requests.nvidia.com/gpu`. The quota counts the sum over all Pods in the namespace.

Save this as `resourcequota-gpu.yaml`:

```yaml
apiVersion: v1
kind: ResourceQuota
metadata:
  name: ml-quota
  namespace: ml-team
spec:
  hard:
    requests.nvidia.com/gpu: "2"
    pods: "10"
```

Apply it and read it back:

```sh
kubectl apply -f resourcequota-gpu.yaml
kubectl get resourcequota ml-quota -n ml-team -o jsonpath='{.spec.hard}'
```

The quota allows two GPUs and ten Pods in the namespace. The API server rejects the Pod that would exceed the limit, and the error names the quota.

## Placing work on the right nodes

GPU nodes are expensive, and ordinary Pods should not occupy them. The usual pattern combines a **taint** on the GPU nodes and a **toleration** in the Pods that need them. A taint repels Pods that do not tolerate it, so a normal web service never lands on a GPU node. A node label such as `accelerator=nvidia-a100` lets a Pod choose a type of GPU with `nodeSelector`.

Newer clusters can also use **Dynamic Resource Allocation** (DRA), a Kubernetes API in which a Pod claims a device by its properties and a driver allocates it. DRA covers cases that a plain count cannot, such as a request for a GPU with a minimum amount of memory. The quota and placement ideas stay the same.

## Common pitfalls

> [!WARNING]
> - Setting a GPU request on a cluster with no device plugin leaves the Pod pending for ever. Check that the nodes advertise the resource.
> - Extended resources cannot be overcommitted. The request and the limit must be equal.
> - A quota counts only the Pods that exist. A forgotten idle Pod holds a GPU, so combine quotas with a clean-up time for Jobs.
