include ${PWD}/../rules.mk

deploy: \
	monitor-incluster \
	argocd

monitor-incluster:
	$(MAKE) -C ../monitor-incluster

argocd:
	$(call DEPLOY_KUSTOMIZE,argocd,${ROOT_DIR}/bases/argocd)
