#!/bin/bash

kubectl run -it --rm flask1 --restart=Never --image=jcdemo/flaskapp "--namespace=${1:-default}"
