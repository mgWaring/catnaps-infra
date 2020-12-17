resource "digitalocean_domain" "default" {
   name = var.domain_name
   ip_address = digitalocean_droplet.server.ipv4_address
}

resource "digitalocean_record" "CNAME-server" {
  domain = digitalocean_domain.default.name
  type = "CNAME"
  name = "@"
  value = "@"
}

resource "digitalocean_record" "www" {
  domain = digitalocean_domain.default.name
  type   = "A"
  name   = "@"
  value  = "192.168.0.11"
}