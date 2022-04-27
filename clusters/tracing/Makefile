include ${PWD}/../rules.mk

deploy: \
	monitor-incluster \
	tns

monitor-incluster:
	$(MAKE) -C ../monitor-incluster

tns:
	$(call DEPLOY_KUSTOMIZE,tns,${ROOT_DIR}/bases/tns)
