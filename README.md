# dev-platform-crossplane

This repository provides a skaffold configuration to deploy crossplane and the Helm and Kubernetes providers.

## Requirements

* helm
* kubectl
* skaffold

## Start

```
helm repo add crossplane-stable https://charts.crossplane.io/stable
```

```
helm repo update
````

```
skaffold dev
```
