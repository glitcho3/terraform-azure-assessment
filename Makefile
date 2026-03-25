TFVARS ?= environments/dev/terraform.tfvars

.PHONY: init fmt validate plan apply destroy test clean

init:
	terraform init

fmt:
	terraform fmt -recursive -check

validate: init
	terraform validate

plan: validate
	terraform plan -var-file=$(TFVARS) -out=tfplan

apply:
	terraform apply tfplan

destroy:
	terraform destroy -var-file=$(TFVARS)

test:
	@bash tests/validate.sh

clean:
	rm -f tfplan
	rm -rf .terraform
