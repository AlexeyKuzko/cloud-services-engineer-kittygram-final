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
  name        = "kittygram-sg"
  network_id  = yandex_vpc_network.kittygram_network.id

  # Разрешаем входящий SSH
  ingress {
    protocol       = "TCP"
    port           = 22
    v4_cidr_blocks = ["0.0.0.0/0"]
  }

  # Разрешаем входящий HTTP
  ingress {
    protocol       = "TCP"
    port           = 9000  # порт gateway
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
    nat               = true
    security_group_ids = [yandex_vpc_security_group.kittygram_sg.id]
  }

  metadata = {
    ssh-keys = "${var.ssh_username}:${file("~/.ssh/id_rsa.pub")}"
    user-data = <<-EOF
              #!/bin/bash
              apt-get update
              apt-get install -y docker.io docker-compose
              systemctl start docker
              systemctl enable docker
              EOF
  }
} 