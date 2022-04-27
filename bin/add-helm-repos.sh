#!/bin/zsh

# These are not needed to provision the cluster in this repo. But is useful to
# have them defined for performing `helm search`

helm repo add stable https://charts.helm.sh/stable
helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo add jetstack https://charts.jetstack.io
helm repo add rancher-charts https://charts.rancher.io
helm repo add rancher-stable https://releases.rancher.com/server-charts/stable
helm repo add rancher-latest https://releases.rancher.com/server-charts/latest
helm repo add traefik https://helm.traefik.io/traefik
helm repo add minio https://operator.min.io/
helm repo add cortex-helm https://cortexproject.github.io/cortex-helm-chart
helm repo add hashicorp https://helm.releases.hashicorp.com
helm repo add timescale https://charts.timescale.com/
helm repo add grafana https://grafana.github.io/helm-charts

helm repo update
