resource "yandex_compute_instance" "kittygram_vm" {
  name        = var.vm_name
  platform_id = "standard-v3"

  resources {
    cores  = 2
    memory = 2
  }

  boot_disk {
    initialize_params {
      image_id = "fd8emvfmfoaordspe1jr"
      size     = 15
    }
  }

  network_interface {
    subnet_id          = var.subnet_id
    nat                = true
    security_group_ids = [var.security_group_id]
  }

  metadata = {
    ssh-keys  = "${var.ssh_username}:${var.ssh_key_content}"
    user-data = var.user_data
  }
} 