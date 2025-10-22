# charts

## Overview

This repo contains a reusable, generic `app` chart. The `helm create` command generates boilerplate for a basic chart. This `app` chart just extends that basic chart. You can see the differences between this `app` chart and the default Helm chart like this (note that the pipe character "|" in the middle indicates a difference, while "<" and ">" indicate new or deleted lines):

```
cd /tmp
helm create app
cd -
diff -r -y -w -W 240 --color=always /tmp/app devopscoop/app/ | less -R
```

## Features

- Adds [`command` and `args`](https://kubernetes.io/docs/tasks/inject-data-application/define-command-argument-container/).
- Adds [`initContainers`](https://kubernetes.io/docs/concepts/workloads/pods/init-containers/).
- Adds [`startupProbe`](https://kubernetes.io/docs/tasks/configure-pod-container/configure-liveness-readiness-startup-probes/).
- Adds the ability to put environment variables in a [ConfigMap](https://kubernetes.io/docs/tasks/configure-pod-container/configure-pod-configmap/) or [Secret](https://kubernetes.io/docs/tasks/inject-data-application/distribute-credentials-secure/#configure-all-key-value-pairs-in-a-secret-as-container-environment-variables).
- Ingress is compatible with older Kubernetes clusters.
- Service can be disabled if it's not needed.

See the `values.yaml` file for examples of how to use these features.

## How to use this chart

This chart is published to these repos:

- oci://registry.gitlab.com/devopscoop/charts/app
- oci://ghcr.io/devopscoop/charts/app

### FluxCD

```yaml
---
apiVersion: source.toolkit.fluxcd.io/v1
kind: HelmRepository
metadata:
  name: devopscoop
spec:
  interval: 60m
  url: oci://registry.gitlab.com/devopscoop/charts
  type: oci
---
apiVersion: helm.toolkit.fluxcd.io/v2
kind: HelmRelease
metadata:
  name: your-app-name
spec:
  chart:
    spec:
      chart: app
      version: 0.7.0
      sourceRef:
        kind: HelmRepository
        name: devopscoop
```

### Helmfile

```yaml
releases:
  - name: your-app-name
    chart: oci://registry.gitlab.com/devopscoop/charts/app
    version: 0.7.0
```

### Helm CLI

```sh
helm install your-app-name oci://registry.gitlab.com/devopscoop/charts/app --version 0.7.0
```
