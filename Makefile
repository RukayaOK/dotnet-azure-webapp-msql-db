# Coloured Text 
red:=$(shell tput setaf 1)
yellow:=$(shell tput setaf 3)
reset:=$(shell tput sgr0)

# Ensure the RUNTIME_ENVIRONMENT variable is set. This is used to: \
Determine whether to run commands locally, in container or in pipeline
RUNTIME_ENVITONMENT_OPTIONS := local container
ifneq ($(filter $(RUNTIME_ENVIRONMENT),$(RUNTIME_ENVITONMENT_OPTIONS)),)
    $(info $(yellow)Runtime Environment: $(RUNTIME_ENVIRONMENT)$(reset))
else
    $(error $(red)Variable RUNTIME_ENVIRONMENT is not set to one of the following: $(RUNTIME_ENVITONMENT_OPTIONS)$(reset))
endif

TERRAFORM_VARS := ARM_CLIENT_ID ARM_CLIENT_SECRET ARM_TENANT_ID ARM_SUBSCRIPTION_ID TF_VAR_administrator_login TF_VAR_administrator_login_password 

# Set the Terraform path
TERRAFORM_PATH=terraform

.PHONY: help
help:					## Displays the help
	@printf "\nUsage : make <command> \n\nThe following commands are available: \n\n"
	@egrep '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'
	@printf "\n"

terra-env:				## Set Terraform Environment Variables
ifeq ($(strip $(filter $(NOGOAL), $(MAKECMDGOALS))),)
	$(foreach v,$(TERRAFORM_VARS),$(if $($v),$(info Variable $v defined),$(error Error: $v undefined)))
endif

.PHONY: terra-docker-build
terra-docker-build:					## Builds the docker image
	docker-compose -f terraform/docker/docker-compose.yml build test-app-terraform

.PHONY: terra-docker-start
terra-docker-start: 					## Runs the docker container
	docker-compose -f terraform/docker/docker-compose.yml up -d test-app-terraform

.PHONY: terra-docker-stop
terra-docker-stop:					## Stops and Remove the docker container
	@docker ps -q --filter "name=test-app-terraform" | grep -q .;\
	if [ $$? -eq 0 ]; \
    then \
        docker-compose -f terraform/docker/docker-compose.yml stop test-app-terraform; \
        docker rm test-app-terraform; \
    fi

.PHONY: terra-docker-restart
terra-docker-restart: terra-docker-stop terra-docker-start			## Restart the docker container

.PHONY: terra-docker-exec
terra-docker-exec: terra-docker-start				## Runs the docker container
	docker exec -it test-app-terraform bash

.PHONY: terra-init
terra-init: terra-env			## Initialises Terraform
ifeq ($(strip $(RUNTIME_ENVIRONMENT)),local)
	terraform -chdir=$(TERRAFORM_PATH) init
	terraform -chdir=$(TERRAFORM_PATH) fmt --recursive
else ifeq ($(strip $(RUNTIME_ENVIRONMENT)),container)
	make terra-docker-restart
	docker exec -it test-app-terraform terraform -chdir=$(TERRAFORM_PATH) init
endif

.PHONY: terra-plan
terra-plan: terra-init			## Plans Terraform
ifeq ($(strip $(RUNTIME_ENVIRONMENT)),local)
	terraform -chdir=$(TERRAFORM_PATH) validate
	terraform -chdir=$(TERRAFORM_PATH) plan -out=plan/tfplan.binary -var-file vars.tfvars
else ifeq ($(strip $(RUNTIME_ENVIRONMENT)),container)
	docker exec -it test-app-terraform terraform -chdir=$(TERRAFORM_PATH) validate
	docker exec -it test-app-terraform terraform -chdir=$(TERRAFORM_PATH) plan -out=plan/tfplan.binary -var-file vars.tfvars
endif

.PHONY: terra-sec
terra-sec: terra-plan			## Security Check Terraform
ifeq ($(strip $(RUNTIME_ENVIRONMENT)),local)
	terraform -chdir=$(TERRAFORM_PATH) show -json plan/tfplan.binary > $(TERRAFORM_PATH)/plan/tfplan.json
	checkov -f $(TERRAFORM_PATH)/plan/tfplan.json --framework terraform_plan
else ifeq ($(strip $(RUNTIME_ENVIRONMENT)),container)
	docker exec -it test-app-terraform terraform -chdir=$(TERRAFORM_PATH) show -json plan/tfplan.binary > $(TERRAFORM_PATH)/plan/tfplan.json
	docker exec -it test-app-terraform checkov -f $(TERRAFORM_PATH)/plan/tfplan.json --framework terraform_plan
endif

.PHONY: terra-lint
terra-lint: 				## Lint Terraform
ifeq ($(strip $(RUNTIME_ENVIRONMENT)),local)
	tflint $(TERRAFORM_PATH)/ --init --config=$(TERRAFORM_PATH)/.tflint.hcl --var-file=$(TERRAFORM_PATH)/vars.tfvars
	tflint $(TERRAFORM_PATH)/ --config=$(TERRAFORM_PATH)/.tflint.hcl --var-file=$(TERRAFORM_PATH)/vars.tfvars
else ifeq ($(strip $(RUNTIME_ENVIRONMENT)),container)
	make terra-init 
	docker exec -it test-app-terraform tflint $(TERRAFORM_PATH)/ --init --config=$(TERRAFORM_PATH)/.tflint.hcl --var-file=$(TERRAFORM_PATH)/vars.tfvars
	docker exec -it test-app-terraform tflint $(TERRAFORM_PATH)/ --config=$(TERRAFORM_PATH)/.tflint.hcl --var-file=$(TERRAFORM_PATH)/vars.tfvars
endif

.PHONY: terra-apply
terra-apply: terra-plan			## Apply Terraform
ifeq ($(strip $(RUNTIME_ENVIRONMENT)),local)
	terraform -chdir=$(TERRAFORM_PATH) apply plan/tfplan.binary
else ifeq ($(strip $(RUNTIME_ENVIRONMENT)),container)
	docker exec -it test-app-terraform terraform -chdir=$(TERRAFORM_PATH) apply plan/tfplan.binary
endif

.PHONY: terra-output
terra-output: terra-init		## Output Terraform
ifeq ($(strip $(RUNTIME_ENVIRONMENT)),local)
	terraform -chdir=$(TERRAFORM_PATH) output
else ifeq ($(strip $(RUNTIME_ENVIRONMENT)),container)
	docker exec -it test-app-terraform terraform -chdir=$(TERRAFORM_PATH) output
endif

.PHONY: terra-destroy
terra-destroy: terra-init		## Destroy Terraform
ifeq ($(strip $(RUNTIME_ENVIRONMENT)),local)
	terraform -chdir=$(TERRAFORM_PATH) destroy -var-file vars.tfvars -auto-approve
else ifeq ($(strip $(RUNTIME_ENVIRONMENT)),container)
	docker exec -it test-app-terraform terraform -chdir=$(TERRAFORM_PATH) destroy -var-file vars.tfvars -auto-approve
endif

.PHONY: app-docker-build
app-docker-build:					## Builds the docker image
	docker-compose -f src/SQLServerTestApp/docker-compose.yml build sqlservertestapp

.PHONY: app-docker-start
app-docker-start: 					## Runs the docker container
	docker-compose -f src/SQLServerTestApp/docker-compose.yml up -d sqlservertestapp

.PHONY: app-docker-stop
app-docker-stop:					## Stops and Remove the docker container
	@docker ps -q --filter "name=sqlservertestapp" | grep -q .;\
	if [ $$? -eq 0 ]; \
    then \
        docker-compose -f src/SQLServerTestApp/docker-compose.yml stop sqlservertestapp; \
        docker rm sqlservertestapp; \
    fi

.PHONY: app-docker-restart
app-docker-restart: app-docker-stop app-docker-start			## Restart the docker container

.PHONY: app-docker-exec
app-docker-exec: app-docker-start				## Runs the docker container
	docker exec -it sqlservertestapp bash
