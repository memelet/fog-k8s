#!/bin/bash

kubectl run -it --rm ubuntu --image=ubuntu:focal "--namespace=${1:-default}" --restart=Never -- sh
