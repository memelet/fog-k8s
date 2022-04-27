include ${PWD}/../rules.mk

deploy:
	$(call DEPLOY_KUSTOMIZE,monitor,".")

#--- Testing targets -- use exclusive with deploy as the "kapp -a" may conflict

test: \
	cert-manager \
	traefik \
	prometheus \
	loki \
	tempo \
	grafana

cert-manager:
	$(call DEPLOY_KUSTOMIZE,cert-manager,${ROOT_DIR}/bases/cert-manager)

traefik:
	$(call DEPLOY_KUSTOMIZE,traefik,${ROOT_DIR}/bases/traefik)

prometheus:
	$(call DEPLOY_KUSTOMIZE,prometheus,${ROOT_DIR}/bases/prometheus)

loki:
	$(call DEPLOY_KUSTOMIZE,loki,${ROOT_DIR}/bases/loki)

tempo:
	$(call DEPLOY_KUSTOMIZE,tempo,${ROOT_DIR}/bases/tempo)

grafana:
	$(call DEPLOY_KUSTOMIZE,grafana,${ROOT_DIR}/bases/grafana)

whoami:
	$(call DEPLOY_KUSTOMIZE,whoami,${ROOT_DIR}/bases/whoami)

tns:
	$(call DEPLOY_KUSTOMIZE,tns,${ROOT_DIR}/bases/tns)
