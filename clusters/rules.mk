SHELL := /bin/zsh
KAPP_NAMESPACE ?= kapp

.PHONEY: deploy
.DEFAULT_GOAL := deploy

#---- cluster ----

define CREATE_KUBECONFIG
	echo "Creating kubeconfig file: $(K3D_KUBECONFIG_FILE)"
	mkdir -p $(KUBE_DIR)
	k3d kubeconfig get $(K3D_NAME) >| $(K3D_KUBECONFIG_FILE)
	chmod 0600 $(K3D_KUBECONFIG_FILE)
endef

k3d-create:
	@echo "Creating cluster: $(K3D_NAME)"
	mkdir -p $(DATA_DIR)/$(K3D_NAME)
	k3d cluster create $(K3D_NAME) --config $(ROOT_DIR)/clusters/cluster.yaml
	$(CREATE_KUBECONFIG)
	kubectl create ns $(KAPP_NAMESPACE)

k3d-config:
	$(CREATE_KUBECONFIG)

k3d-delete:
	k3d cluster delete $(K3D_NAME)

k3d-list:
	k3d cluster list

clean-charts:
	rm -rf */charts

deploy: # to be overriden in concrete Makefile

reprovision: \
	k3d-delete \
	k3d-create \
	deploy

#---- deployment ----

KAPP_ENABLED ?= true
KAPP_ASSUME_YES ?= -y

ifeq ("$(KAPP_ENABLED)","true")
define DEPLOY_KUSTOMIZE
	kapp $(KAPP_ASSUME_YES) deploy $(KAPP_DEPLOY_ARGS) -n $(KAPP_NAMESPACE) -a $(1) -f <(kustomize build --enable-helm $(2))
endef
else
define DEPLOY_KUSTOMIZE
	kustomize build --enable-helm $(2) | kubectl apply -f -
endef
endif
