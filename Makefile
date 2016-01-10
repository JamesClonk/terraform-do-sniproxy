all: sshkey vars plan apply

sshkey:
	rm -f ssh/sniproxy
	rm -f ssh/sniproxy.pub
	ssh-keygen -t rsa -N '' -f ssh/sniproxy

vars:
ifndef DO_TOKEN
$(error Missing $$DO_TOKEN !!!)
endif
ifndef DNSIMPLE_TOKEN
$(error Missing $$DNSIMPLE_TOKEN !!!)
endif
ifndef DNSIMPLE_EMAIL
$(error Missing $$DNSIMPLE_EMAIL !!!)
endif

plan:
	terraform plan -var "do_token=${DO_TOKEN}" -var "dnsimple_token=${DNSIMPLE_TOKEN}" -var "dnsimple_email=${DNSIMPLE_EMAIL}" -out terraform.tfplan

apply:
	terraform apply -var "do_token=${DO_TOKEN}" -var "dnsimple_token=${DNSIMPLE_TOKEN}" -var "dnsimple_email=${DNSIMPLE_EMAIL}"

destroy:
	terraform destroy -var "do_token=${DO_TOKEN}" -var "dnsimple_token=${DNSIMPLE_TOKEN}" -var "dnsimple_email=${DNSIMPLE_EMAIL}" -force

clean:
	rm -f terraform.tfvars
	rm -f terraform.tfplan
	rm -f terraform.tfstate
	rm -f terraform.tfstate.backup
	rm -f ssh/sniproxy
	rm -f ssh/sniproxy.pub
