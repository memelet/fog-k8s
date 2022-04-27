include ${PWD}/../rules.mk

RANCHER_DIR := ${BASES_DIR}/rancher

ifeq (${K3D_AGENT_COUNT},0)
	RANCHER_REPLICAS := 1
else
	RANCHER_REPLICAS := ${K3D_AGENT_COUNT}
endif

deploy: \
	monitor-incluster \
	rancher

monitor-incluster:
	$(MAKE) -C ../monitor-incluster

rancher:
	$(call DEPLOY_KUSTOMIZE,rancher,".")

#--- Testing targets -- use exclusive with deploy as the "kapp -a" may conflict

cert-manager:
	$(call DEPLOY_KUSTOMIZE,cert-manager,${ROOT_DIR}/bases/cert-manager)
