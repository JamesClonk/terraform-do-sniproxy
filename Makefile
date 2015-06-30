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
	terraform plan -var "do_token=${DO_TOKEN}" -var "client_ip=$$(echo $${SSH_CONNECTION} | awk '{print $$1}')" -out terraform.tfplan

apply:
	terraform apply -var "do_token=${DO_TOKEN}" -var "client_ip=$$(echo $${SSH_CONNECTION} | awk '{print $$1}')"

destroy:
	terraform destroy -var "do_token=${DO_TOKEN}" -var "client_ip=$$(echo $${SSH_CONNECTION} | awk '{print $$1}')" -force

clean:
	rm -f terraform.tfvars
	rm -f terraform.tfplan
	rm -f terraform.tfstate
	rm -f terraform.tfstate.backup
	rm -f ssh/sniproxy
	rm -f ssh/sniproxy.pub

countdown_6h:
	./countdown.pl 21600

countdown_d:
	./countdown.pl 285000

timer: countdown_6h destroy clean

today: all countdown_6h destroy clean

week: all countdown_d destroy clean
