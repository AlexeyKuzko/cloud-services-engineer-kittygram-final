output "external_ip" {
  value = yandex_compute_instance.kittygram_vm.network_interface[0].nat_ip_address
} 