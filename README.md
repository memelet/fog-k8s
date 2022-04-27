# Introduction

This repo contains experiments with [Kubernetes](https://kubernetes.io/) cluster configurations. The provisoned clusters use the [K3s](https://k3s.io/) distribution, and run via [K3d](https://k3d.io).

[Kustomize](https://kustomize.io/) is used to template K8s resources. By default, [kapp](https://carvel.dev/kapp/) is used to deploy the resources.

# Setup

NOTE: This project assumes you use zsh as your shell. This should be relaxed, and in any case may not even be required.

## CLI Tools

```shell
brew install direnv
brew install jq
brew install yq
brew install xclip
brew install kubectl
brew install helm
brew install kustomize
brew install kapp
brew install k3d
```

Some clusters may require additional installations. Check the readme.md in the cluster directory. 

Setup direnv shell hook (https://github.com/direnv/direnv/blob/master/docs/hook.md).
```
printf 'eval "$(direnv hook zsh)"' >> ~/.zshrc
```

If you do not install direnv, you need to manually set environment variables defined in current directories ``.envrc``. This has not been tested; it's strongly recommended to use direnv for this project.

## Docker Registry Mirror

Creating and recreating clusters locally tends to use a _lot_ of network downloading container images. To help with this, the k3s cluster is by default configured to use registry mirrors. 

In `clusters/cluster.yaml`:
```yaml
...
registries:
  config: |
    mirrors:
      "docker.io":
        endpoint:
          - http://host.k3d.internal:5000
      "docker.elastic.co":
        endpoint:
          - http://host.k3d.internal:5001
```

Mirrors are run in docker and are started and stopped via `bin/registry-mirror.sh start` and `bin/registry-mirror.sh stop`.

This script requires a few environment variables:

| Name | Usage |
| ---- | ----- |
| REGISTRY_MIRROR_DATA_DIR | Defines the path on the location where the images are stored. A default is defined in .envrc as `.data/registry-mirror`. If the variable `DEFAULT_REGISTRY_MIRROR_DATA_DIR`, that will be used instead. This allow for defining the mirror storage in a location that is not dependent on this project. | 
| DOCKER_HUB_USERNAME, DOCKER_HUB_PASSWORD | Used when accessing hub.docker.com. These should be optional, but are not. |

# Creating Clusters

Each clusters is defined in directories under `clusters/`. 

## Configuration

Each cluster has an `.envrc` which defines configurfation variables. For example, `cluster/argoworkflows/.envrc`:
```shell
export CLUSTER_DIR=$PWD

export K3D_NAME=argowf
export K3D_SERVER_COUNT=1
export K3D_AGENT_COUNT=2
export K3D_PORT_START=7120

source_env ../.envrc.cluster-base

PATH_add $CLUSTER_DIR/../monitor-incluster/bin
```

Each cluster that will be up concurrently needs to have unique value for `K3D_PORT_START` with some spread between the clusters. For example, cluster-1 `K3D_PORT_START=7100`, cluster-2 `K3D_PORT_START=7200`.

`cluster/.envrc.cluster-base` defines common and derived variables. It will also add `$CLUSTER_DIR/bin` to the path. Cluster `.envrc` can add the `bin/` of other clusters, typically a cluster it is based off, such as with the `argoworkflows` example above.

## Cluster Makefile

Each cluster has a `Makefile` with targets specific to that cluster, eg `cluster/argoworkflows/Makefile`:
```shell
include ${PWD}/../rules.mk

deploy: \
	monitor-incluster \
	argo-workflows

monitor-incluster:
	$(MAKE) -C ../monitor-incluster

argo-workflows:
	$(call DEPLOY_KUSTOMIZE,argo-workflows,${ROOT_DIR}/bases/argoworkflows)

```

The `../rules.mk` define common varibales, targets, and macros. If you have a good shell environment, `make <<TAB>>` should autocomplete. 

A cluster Makefile should define the target `deploy`. This will be used by the `../rules.mk` target `reprovision` to create a new cluster and trigger the `deploy` target. 

The cluster `deploy` should depend on targets for each of the deployed components. In the example above, `argoworkflows` uses the macro `DEPLOY_KUSTOMIZE` to deploy `../../bases/argoworkflows`. It also defines the `monitor-incluster` target which invokes the `make deploy` in `../monitor-incluster`. In other words, the argoworkflows cluster extends monitor-incluster.  

## Cluster kustomization.yaml

Each cluster has a `kustomization.yaml` which includes resources specific to this cluster, eg `cluster/argoworkflows/kustomizaton.yaml`:
```shell
apiVersion: kustomize.config.k8s.io/v1beta1
kind: Kustomization

resources:
  - ../../bases/argoworkflows
```

Not that it does include any resources from monitor-incluster since this is handled by the Makefile. This split allows each cluster to define its own kapp application name. 

## Provisioning the cluster

Bringing up the cluster with all its components is requires only
```shell
make reprovision
```
Which is defined as:
```shell
reprovision: \
	k3d-delete \
	k3d-create \
	deploy
```

Once the cluster is up, `make deploy` (or `make <<target>>`) can be used to update the deployments. 


## Cluster specific UIs

The cluster `bin/` directly sometimes includes scripts `open-*` which will open pages in the browsers. For example `cluster/argoworkflows/bin/open-argowf`:
```shell
#!/bin/bash
xdg-open http://argowf.${K3D_HOST}:${K3D_PORT_TRAEFIK_WEB}
```

The `.envrc` will ensure that all relevant `bin/` directories are added to your path, so `open-<<TAB>>` should autocomplete.

# Resources

- https://kubernetes.io/docs/tasks/debug-application-cluster/
- https://carvel.dev/blog/casestudy-modernizing-the-us-army/

Makefiles
- https://www.gnu.org/software/make/manual/html_node/Conditionals.html

Kustomize patches
- https://kubectl.docs.kubernetes.io/references/kustomize/kustomization/patchesstrategicmerge/
- https://github.com/kubernetes/community/blob/master/contributors/devel/sig-api-machinery/strategic-merge-patch.md
- https://github.com/kubernetes-sigs/kustomize/blob/master/examples/jsonpatch.md
- https://github.com/kubernetes-sigs/kustomize/blob/master/examples/inlinePatch.md
- https://kubectl.docs.kubernetes.io/references/kustomize/kustomization/replacements/

Grafana
- https://grafana.com/docs/grafana/latest/datasources/loki/#derived-fields

yq
- https://mikefarah.gitbook.io/yq/
