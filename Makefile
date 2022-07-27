FUNC := lambda-janitor
MODE ?= plan
TF_VAR_region ?= eu-west-1
DO_TF_UPGRADE ?= false

# Set an output prefix, which is the local directory if not specified
PREFIX?=$(shell pwd)

all: clean build package

ACCOUNT := $(shell aws --output text sts get-caller-identity --query "Account")
VERSION := $(shell git rev-parse --short HEAD)
TF_BACKEND_CFG := -backend-config=bucket=terraform-state-$(ACCOUNT)-$(TF_VAR_region) \
	-backend-config=region=$(TF_VAR_region) \
	-backend-config=key="regional/lambda/$(FUNC)/terraform.tfstate"

export TF_VAR_region
tf ::
	rm -f terraform/.terraform/terraform.tfstate || true
	terraform -chdir=terraform init -upgrade=$(DO_TF_UPGRADE) $(TF_BACKEND_CFG)
	terraform -chdir=terraform $(MODE)

.PHONY: build
build ::
	npm install

.PHONY: package
package ::
	zip -rq9 lambda.zip functions/* node_modules -x node_modules/aws-sdk/\*

.PHONY: clean
clean ::
	$(RM) lambda.zip
