variable "do_selfdestruct" {
	description = "DigitalOcean droplet selfdestruct timer (in minutes)"
	default = "360"
}

variable "do_token" {
	description = "DigitalOcean API token"
}

variable "do_region" {
	description = "DigitalOcean region"
	default = "nyc3"
}

variable "do_ssh_private_key_file" {
	description = "ssh private key file"
	default = "ssh/sniproxy"
}

variable "do_ssh_public_key_file" {
	description = "ssh public key file"
	default = "ssh/sniproxy.pub"
}
