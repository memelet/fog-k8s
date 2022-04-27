#!/bin/bash

kubectl run -it --rm netshoot --image=nicolaka/netshoot "--namespace=${1:-default}" --restart=Never -- /bin/bash
