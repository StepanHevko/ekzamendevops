resource "digitalocean_vpc" "main" {
  name     = "${var.surname}-vpc"
  region   = var.region
  ip_range = "10.10.10.0/24"
}

resource "digitalocean_firewall" "main" {
  name = "${var.surname}-firewall"
  droplet_ids = [digitalocean_droplet.node.id]

  inbound_rule {
    protocol         = "tcp"
    port_range       = "22"
    source_addresses = ["0.0.0.0/0", "::/0"]
  }
  inbound_rule {
    protocol         = "tcp"
    port_range       = "80"
    source_addresses = ["0.0.0.0/0", "::/0"]
  }
  inbound_rule {
    protocol         = "tcp"
    port_range       = "443"
    source_addresses = ["0.0.0.0/0", "::/0"]
  }
  inbound_rule {
    protocol         = "tcp"
    port_range       = "8000-8003"
    source_addresses = ["0.0.0.0/0", "::/0"]
  }

  outbound_rule {
    protocol              = "tcp"
    port_range            = "1-65535"
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }
  outbound_rule {
    protocol              = "udp"
    port_range            = "1-65535"
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }
}

resource "digitalocean_ssh_key" "default" {
  name       = "exam-ssh-key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC/0tkpBgNlS5KwUMmaLqQF5Fz5XRSWcz/aRkebNbaAMcG7HULKWZMIlFshE9phYfwBA3uDR60qlR14Rf3sXUpGU4sui5GNxEW/la6evbN2g6CxfXxuCpPR+WNPG3bJ/eNeMByy0rR8ut9j0miU1uUZY8vyFSOUgeg3ceh4c64fRqTSlhmxZPhHaO3XqkfishOL1xeKsQqlthcASUR0xzeDxLKz4Ij6OU4oWW6ZEVj2dOC8T9T2EiKpXUZKzidqlfpP0cO1OYvhQIMbFEtJBo6g7LG4IiDJ5K1IrvjJBUeo+tepOYK3xyEEQ95QhAA2yuQksuH4P1A8TRiKINz1L6/cNhyOcEUYcR8ieICf0CgmPbSnJ0qTfkGx12HPQbe+LYTsspNib+B5dnFchQjX6jiofCN1AXvsvYWqYHmQAWFLei81JUjexXwBlCGJEgoibi7e0GyBDagI+QUatQnqNmc4RzJfvPGjd4BqiwC1Eeo0Jf3bpMS07k7SRYvC5m5js24mM0LryljDGZfOLIJLpf2nA1sDGYuqH+x5OETKmQUedHHf6s7qo7vOV1WxH88xreS9xykDl5qEzEh7egS0VpwVGwSTPKscn99eU8fywm3751DmmVhl77/ZLH/RLsNwAHmsBMcN/RoDmdEnQL69MuvKTUmzQn5ylPreJLc3CWlLNQ== drago@Stepan"
}

resource "digitalocean_droplet" "node" {
  name     = "${var.surname}-node"
  size     = "s-2vcpu-4gb"
  image    = "ubuntu-24-04-x64"
  region   = var.region
  vpc_uuid = digitalocean_vpc.main.id
  ssh_keys = [digitalocean_ssh_key.default.fingerprint]
}

resource "digitalocean_spaces_bucket" "main" {
  name   = "${var.surname}-bucket"
  region = var.region
}
