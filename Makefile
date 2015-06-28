all: sshkey vars plan apply

sshkey:
	rm -f ssh/sniproxy
	rm -f ssh/sniproxy.pub
	ssh-keygen -t rsa -N '' -f ssh/sniproxy

vars:
ifndef DO_TOKEN
$(error Missing $$DO_TOKEN !!!)
endif

plan:
	terraform plan -var "do_token=${DO_TOKEN}" -out terraform.tfplan

apply:
	terraform apply -var "do_token=${DO_TOKEN}" terraform.tfvars

destroy:
	terraform destroy -var "do_token=${DO_TOKEN}"

clean:
	rm -f terraform.tfvars
	rm -f terraform.tfplan
	rm -f terraform.tfstate
	rm -f terraform.tfstate.backup
	rm -f ssh/sniproxy
	rm -f ssh/sniproxy.pub
