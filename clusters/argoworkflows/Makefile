include ${PWD}/../rules.mk

deploy: \
	monitor-incluster \
	argo-workflows

monitor-incluster:
	$(MAKE) -C ../monitor-incluster

argo-workflows:
	$(call DEPLOY_KUSTOMIZE,argo-workflows,${ROOT_DIR}/bases/argoworkflows)

#---- Testing targets

test: \
	cert-manager \
	traefik \
	argo-workflows

cert-manager:
	$(call DEPLOY_KUSTOMIZE,cert-manager,${ROOT_DIR}/bases/cert-manager)

traefik:
	$(call DEPLOY_KUSTOMIZE,traefik,${ROOT_DIR}/bases/traefik)
