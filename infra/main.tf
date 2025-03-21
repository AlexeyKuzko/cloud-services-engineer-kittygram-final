# Создание VPC сети
resource "yandex_vpc_network" "kittygram_network" {
  name = "kittygram-network"
}

# Создание подсети
resource "yandex_vpc_subnet" "kittygram_subnet" {
  name           = "kittygram-subnet"
  zone           = var.zone
  network_id     = yandex_vpc_network.kittygram_network.id
  v4_cidr_blocks = ["192.168.10.0/24"]
}

# Группа безопасности
resource "yandex_vpc_security_group" "kittygram_sg" {
  name       = "kittygram-sg"
  network_id = yandex_vpc_network.kittygram_network.id

  # Разрешаем входящий SSH
  ingress {
    protocol       = "TCP"
    port           = 22
    v4_cidr_blocks = ["0.0.0.0/0"]
  }

  # Разрешаем входящий HTTP
  ingress {
    protocol       = "TCP"
    port           = 8000 # порт gateway
    v4_cidr_blocks = ["0.0.0.0/0"]
  }

  # Разрешаем весь исходящий трафик
  egress {
    protocol       = "ANY"
    v4_cidr_blocks = ["0.0.0.0/0"]
    from_port      = 0
    to_port        = 65535
  }
}

# Виртуальная машина
resource "yandex_compute_instance" "kittygram_vm" {
  name        = var.vm_name
  platform_id = "standard-v1"

  resources {
    cores  = 2
    memory = 2
  }

  boot_disk {
    initialize_params {
      image_id = "fd8emvfmfoaordspe1jr" # Ubuntu 20.04
      size     = 15
    }
  }

  network_interface {
    subnet_id          = yandex_vpc_subnet.kittygram_subnet.id
    nat                = true
    security_group_ids = [yandex_vpc_security_group.kittygram_sg.id]
  }

  metadata = {
    ssh-keys  = "${var.ssh_username}:${var.ssh_key_content}"
    user-data = <<-EOF
    #!/bin/bash
    # Update system
    apt-get update
    apt-get upgrade -y

    # Install required packages
    apt-get install -y \
      apt-transport-https \
      ca-certificates \
      curl \
      gnupg \
      lsb-release

    # Add Docker's official GPG key
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

    # Set up the Docker repository
    echo \
      "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
      $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null

    # Install Docker
    apt-get update
    apt-get install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin

    # Start and enable Docker
    systemctl start docker
    systemctl enable docker

    # Add user to docker group
    usermod -aG docker ${var.ssh_username}

    # Create application directory
    mkdir -p /home/${var.ssh_username}/kittygram
    chown -R ${var.ssh_username}:${var.ssh_username} /home/${var.ssh_username}/kittygram
    EOF
  }
}

# S3 bucket for application data
resource "yandex_storage_bucket" "kittygram_bucket" {
  bucket = "kittygram-bucket-${var.vm_name}"
  access_key = var.access_key
  secret_key = var.secret_key
}