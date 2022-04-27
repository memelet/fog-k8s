#!/bin/zsh

function ensure_env {
  if [[ ! -v "${1}" ]]; then
    echo "ERROR: Environment variable $1 must be defined"
    exit 1
  fi
}

function start_gitea () {
  docker run -d \
    --name gitea \
    --restart=always \
    -p 5100:3000 \
    -p 5122:22 \
    -v ${ROOT_DIR}/bases:/data/git/repositories \
    -v ${ROOT_DIR}/.data/gitea:/data/gitea \
    -v /etc/timezone:/etc/timezone:ro \
    -v /etc/localtime:/etc/localtime:ro \
    -e USER_UID=1000 \
    -e USER_GID=1000 \
    gitea/gitea:latest
}

function stop_gitea () {
  docker stop gitea
  docker rm gitea
}

case "$1" in
  "start")
    start_gitea
    ;;
  "stop")
    stop_gitea
    ;;
  *)
    echo "Usage: gitea.sh start|stop"
    exit 1
    ;;
esac
