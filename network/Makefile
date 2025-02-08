#!/bin/bash
COLOR_RESET = \033[0m
COLOR_RED = \033[31m
COLOR_GREEN = \033[32m
COLOR_YELLOW = \033[33m
COLOR_BLUE = \033[34m
COLOR_ORANGE = \033[38;5;214m
COLOR_BOLD = \033[1m

VAR_FILES := $(wildcard configs/*.tfvars)
HCL_FILES := $(wildcard configs/*.hcl)

LOGS_DIR := logs
DATETIME := $(shell date +%Y%m%d_%H%M%S)

$(shell mkdir -p $(LOGS_DIR))
all: help

check:
	ROLE_CREDS=$$(aws sts assume-role --role-arn arn:aws:iam::818729859049:role/role-tfprimary --role-session-name jongin)
	export AWS_ACCESS_KEY_ID=$$(echo $$ROLE_CREDS | jq -r .Credentials.AccessKeyId)
	export AWS_SECRET_ACCESS_KEY=$$(echo $$ROLE_CREDS | jq -r .Credentials.SecretAccessKey)
	export AWS_SESSION_TOKEN=$$(echo $$ROLE_CREDS | jq -r .Credentials.SessionToken)

help: ## Display help
	@grep -E '^[a-zA-Z0-9_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

fmt: ## terraform fmt recurses into subdirectories
	@terraform fmt --recursive

init: ## Init terraform
	$(call select_file,$(HCL_FILES),init)

plan: ## Plan terraform
	$(call select_file,$(VAR_FILES),plan)

apply: ## Apply terraform
	$(call select_file,$(VAR_FILES),apply)

destroy: ## Destroy terraform
	$(call select_file,$(VAR_FILES),destroy)

clean: ## Remove terraform config and cache
	@echo "$(COLOR_RED)Remove terraform config and cache$(COLOR_RESET)"
	@rm -rf .terraform/
	@rm -rf logs/
	@rm -f .terraform.lock.hcl

define select_file
@if [ -z "$(1)" ]; then \
    echo "$(COLOR_RED)No .tfvars or .hcl files found in the current directory.$(COLOR_RESET)"; \
    exit 0; \
fi; \
echo "$(COLOR_ORANGE)$(2) terraform$(COLOR_RESET)"; \
echo "Available configs"; \
echo "-----------------------------------------------------------------"; \
i=1; \
for file in $(1); do \
    base_file=$$(basename $$file | sed 's/\.[^.]*$$//'); \
    echo "$$i) $$base_file"; \
    i=$$((i+1)); \
done; \
echo "-----------------------------------------------------------------"; \
echo "Enter the number of the config you want to use, or press 'c' to cancel:"; \
read choice; \
if [ "$$choice" = "c" ]; then \
    echo "$(COLOR_YELLOW)Operation canceled.$(COLOR_RESET)"; \
    exit 0; \
fi; \
ROLE_CREDS=$$(aws sts assume-role --role-arn arn:aws:iam::390402540209:role/halo-p-role-tfprimary --role-session-name ts); \
AWS_ACCESS_KEY_ID=$$(echo $$ROLE_CREDS | jq -r .Credentials.AccessKeyId); \
AWS_SECRET_ACCESS_KEY=$$(echo $$ROLE_CREDS | jq -r .Credentials.SecretAccessKey); \
AWS_SESSION_TOKEN=$$(echo $$ROLE_CREDS | jq -r .Credentials.SessionToken); \
selected_file=$$(echo "$(1)" | awk '{print $$'$$choice'}'); \
if [ -n "$$selected_file" ]; then \
    echo "$(COLOR_ORANGE)$(2) with $$selected_file$(COLOR_RESET)"; \
    LOG_FILE=$$(echo "$(LOGS_DIR)/$(2)_$(DATETIME).log"); \
	if [ "$(2)" = "init" ]; then \
        terraform init -migrate-state -upgrade -backend-config="$$selected_file" 2>&1 | tee $$LOG_FILE; \
    elif [ "$(2)" = "plan" ]; then \
        start_time=$$(date +%s); \
    	terraform $(2) -parallelism=10 -out=planfile -var-file="$$selected_file" 2>&1 | tee $$LOG_FILE; \
        end_time=$$(date +%s); \
        terraform show -json planfile | jq '{ \
  cellState: "CREATED",  \
  cellVersion: "0.1", \
  vpcId: .planned_values.outputs.vpc_id.value, \
  vpcCidr: .planned_values.outputs.vpc_cidr.value, \
  resources: { \
    lunaApiId: .planned_values.outputs.resources.value.lunaApiId, \
    lunaDeploymentId: .planned_values.outputs.resources.value.lunaDeploymentId, \
    polarhubApiId: .planned_values.outputs.resources.value.polarhubApiId, \
    polarhubDeploymentId: .planned_values.outputs.resources.value.polarhubDeploymentId, \
    cognitoUserPoolId: .planned_values.outputs.resources.value.cognitoUserPoolId, \
    eksClusterName: .planned_values.outputs.resources.value.eksClusterName, \
    auroraWriterEndpoint: .planned_values.outputs.resources.value.auroraWriterEndpoint, \
    auroraReaderEndpoint: .planned_values.outputs.resources.value.auroraReaderEndpoint, \
    documentdbClusterEndpoint: .planned_values.outputs.resources.value.documentdbClusterEndpoint, \
    documentdbReaderEndpoint: .planned_values.outputs.resources.value.documentdbReaderEndpoint \
  } \
}' > outputs.json; \
        execution_time=$$((end_time - start_time)); \
        echo "Execution time: $$execution_time seconds"; \
    else \
        start_time=$$(date +%s); \
    	terraform $(2) -auto-approve -parallelism=10 -var-file="$$selected_file" 2>&1 | tee $$LOG_FILE; \
        end_time=$$(date +%s); \
        execution_time=$$((end_time - start_time)); \
        echo "Execution time: $$execution_time seconds"; \
    fi; \
	sed -i '' 's/\x1B\[[0-9;]*[mG]//g'  $$LOG_FILE; \
else \
    echo "$(COLOR_RED)Invalid selection.$(COLOR_RESET)"; \
    exit 0; \
fi
endef