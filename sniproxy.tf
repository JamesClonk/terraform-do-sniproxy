# Create DigitalOcean provider
provider "digitalocean" {
    token = "${var.do_token}"
}

# Create ssh key
resource "digitalocean_ssh_key" "sniproxy" {
    name = "docker sniproxy"
    public_key = "${file("${var.do_ssh_public_key_file}")}"
}

# Create docker droplet
resource "digitalocean_droplet" "sniproxy" {
    image = "docker"
    name = "docker-sniproxy"
    region = "${var.do_region}"
    size = "512mb"
    private_networking = false
    ipv6 = false
    ssh_keys = [
        "${digitalocean_ssh_key.sniproxy.id}",
    ]

    connection {
        type = "ssh"
        user = "root"
        key_file = "${var.do_ssh_private_key_file}"
    }

    provisioner "remote-exec" {
        inline = [
            "sleep 15",
            "sudo apt-get update",
            "sudo apt-get -y install git",
            "cd /opt && git clone https://github.com/JamesClonk/netflix-proxy.git && cd netflix-proxy && ./build.sh -b 1 -c '${var.client_ip}'",
        ]
    }
}
