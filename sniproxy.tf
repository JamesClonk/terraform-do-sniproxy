# Create DigitalOcean provider
provider "digitalocean" {
    token = "${var.do_token}"
}

# Create DNSimple provider
provider "dnsimple" {
    token = "${var.dnsimple_token}"
    email = "${var.dnsimple_email}"
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

    provisioner "file" {
        source = "self-destruct.sh"
        destination = "/tmp/self-destruct.sh"
    }

    provisioner "remote-exec" {
        inline = [
            "sleep 15",
            "sudo apt-get update",
            "sudo apt-get -y install git",
            "cd /opt && git clone https://github.com/JamesClonk/netflix-proxy.git",
            "chmod +x /opt/netflix-proxy/build.sh",
            "cd /opt/netflix-proxy && ./build.sh -b 1",
            "chmod +x /tmp/self-destruct.sh",
            "nohup /tmp/self-destruct.sh ${var.do_token} ${digitalocean_droplet.sniproxy.id} ${var.do_selfdestruct} &",
            "sleep 5"
        ]
    }
}

# Add record to domain
resource "dnsimple_record" "sniproxy" {
    depends_on = ["digitalocean_droplet.sniproxy"]
    domain = "${var.dnsimple_domain}"
    name = "sniproxy"
    value = "${digitalocean_droplet.sniproxy.ipv4_address}"
    type = "A"
    ttl = 3600
}

