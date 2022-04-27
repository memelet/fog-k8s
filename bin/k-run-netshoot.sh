#!/bin/bash
# https://github.com/nicolaka/netshoot

namespace_arg="--namespace=${1:-default}"
kubectl run -it --rm netshoot --image=nicolaka/netshoot $namespace_arg --restart=Never -- /bin/bash
kubectl delete pods netshoot $namespace_arg
