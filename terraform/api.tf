resource "digitalocean_droplet" "server" {
  image  = "strapi-18-04"
  name   = "catnapsbeds.com"
  region = var.region
  size   = "s-1vcpu-2gb"
  ssh_keys = [
    data.digitalocean_ssh_key.Default.id
  ]
  connection {
    host        = self.ipv4_address
    user        = "root"
    type        = "ssh"
    private_key = file(var.pvt_key)
    timeout     = "2m"
  }
  provisioner "remote-exec" {
    inline = [
      "export WEBHOOK_SECRET=${var.webhook_secret}",
      "cd var",
      "git clone ${var.webhook_repo}",
      "cd webhooks",
      "mv api-webhook.service /etc/systemd/system/webhook.service",
      "systemctl enable api-webhook.service && nsystemctl start api-webhook",
      "add-apt-repository ppa:certbot/certbot",
      "apt install python-certbot-nginx",
      "certbot --nginx",
    ]
  }
}

resource "digitalocean_floating_ip" "server-ip" {
  droplet_id = digitalocean_droplet.server.id
  region     = var.region
}

output "server_api" {
  value = digitalocean_droplet.server.ipv4_address
}