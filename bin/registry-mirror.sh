#!/bin/zsh

function ensure_env {
  if [[ ! -v "${1}" ]]; then
    echo "ERROR: Environment variable $1 must be defined"
    exit 1
  fi
}

function start_mirror () {
  ensure_env "REGISTRY_MIRROR_DATA_DIR"
  ensure_env "DOCKER_HUB_USERNAME"
  ensure_env "DOCKER_HUB_PASSWORD"

  registry_data_dir=$(readlink --canonicalize $REGISTRY_MIRROR_DATA_DIR)

  echo "Using registy data dir: ${registry_data_dir}"

  docker run -d \
    --name docker-registry-mirror \
    --restart=always \
    -p 5000:5000 \
    -v ${registry_data_dir}/docker:/var/lib/registry:rw \
    -e REGISTRY_PROXY_REMOTEURL="https://registry-1.docker.io" \
    -e REGISTRY_PROXY_USERNAME="$DOCKER_HUB_USERNAME" \
    -e REGISTRY_PROXY_PASSWORD="$DOCKER_HUB_PASSWORD" \
    registry:2

  docker run -d \
    -p 5001:5000 \
    --restart=always \
    --name elastic-registry-mirror \
    -v ${registry_data_dir}/elastic:/var/lib/registry:rw \
    -e REGISTRY_PROXY_REMOTEURL="https://docker.elastic.co" \
    registry:2
}

function stop_mirror () {
  docker stop docker-registry-mirror
  docker rm docker-registry-mirror

  docker stop elastic-registry-mirror
  docker rm elastic-registry-mirror
}

case "$1" in
  "start")
    start_mirror
    ;;
  "stop")
    stop_mirror
    ;;
  *)
    echo "Usage: registry-mirror.sh start|stop"
    exit 1
    ;;
esac
