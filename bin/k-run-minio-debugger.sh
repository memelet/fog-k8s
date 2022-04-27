#!/bin/bash

kubectl run -it --rm minio-debugger --image miniodev/debugger "--namespace=${1:-default}" --restart=Never -- bash
