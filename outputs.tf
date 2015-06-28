output "sniproxy" {
	value = "${digitalocean_droplet.sniproxy.ipv4_address}"
}
