module "network" {
  source = "./modules/network"
  zone   = var.zone
}

module "compute" {
  source = "./modules/compute"

  vm_name           = var.vm_name
  subnet_id         = module.network.subnet_id
  security_group_id = module.network.security_group_id
  ssh_username      = var.ssh_username
  ssh_key_content   = var.ssh_key_content
  user_data         = <<-EOF
    #!/bin/bash
    apt-get update
    apt-get upgrade -y

    apt-get install -y \
      apt-transport-https \
      ca-certificates \
      curl \
      gnupg \
      lsb-release

    echo "${var.ssh_username}:${var.user_password}" | chpasswd

    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

    echo \
      "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
      $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null

    apt-get update
    apt-get install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin

    systemctl start docker
    systemctl enable docker

    usermod -aG docker ${var.ssh_username}

    mkdir -p /home/${var.ssh_username}/kittygram
    chown -R ${var.ssh_username}:${var.ssh_username} /home/${var.ssh_username}/kittygram
  EOF
}

# S3 bucket for application data
resource "yandex_storage_bucket" "kittygram_bucket" {
  bucket        = "kittygram-bucket-${var.vm_name}"
  access_key    = var.access_key
  secret_key    = var.secret_key
  force_destroy = true  # Allow terraform to destroy the bucket even if it contains objects

  lifecycle {
    prevent_destroy = false  # Allow the bucket to be destroyed
    ignore_changes  = [
      access_key,
      secret_key
    ]
  }
}