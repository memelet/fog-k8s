#!/bin/zsh

function ensure_env {
  if [[ ! -v "${1}" ]]; then
    echo "ERROR: Environment variable $1 must be defined"
    exit 1
  fi
}

function start_gogs () {
  docker run -d \
    --name gogs \
    --restart=always \
    -p 5100:3000 \
    -p 5122:22 \
    -v ${ROOT_DIR}/bin:/data \
    gogs/gogs
}

function stop_gogs () {
  docker stop gogs
  docker rm gogs
}

case "$1" in
  "start")
    start_gogs
    ;;
  "stop")
    stop_gogs
    ;;
  *)
    echo "Usage: gogs.sh start|stop"
    exit 1
    ;;
esac
