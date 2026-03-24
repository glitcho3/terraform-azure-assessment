TFVARS ?= environments/dev/terraform.tfvars


.PHONY: init fmt validate plan apply destroy test clean verify local-test local-clean

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

# Runs after apply: SSH into the VM and verify bootstrap.json contains expected events.
# Usage: make verify SSH_HOST=<vm_ip>
# TODO: The verify target currently assumes you have a VM IP and SSH. You could make
# it retrieve the IP from Terraform output, but that requires the state to
# exist.

verify:
	@ssh -o StrictHostKeyChecking=no azureuser@$(SSH_HOST) \
	  "grep -c 'hello-world' /var/log/bootstrap.json && echo 'verify: PASS' || echo 'verify: FAIL'"

clean:
	rm -f tfplan
	rm -rf .terraform
	
# Local test: no Azure credentials needed.
local-test:
	mkdir -p local-test/logs
	cd local-test && docker compose up --abort-on-container-exit --exit-code-from vm
	cd local-test && bash verify.sh

local-clean:
	cd local-test && docker compose down -v
	rm -f local-test/logs/bootstrap.json
