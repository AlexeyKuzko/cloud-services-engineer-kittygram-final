output "subnet_id" {
  value = yandex_vpc_subnet.kittygram_subnet.id
}

output "security_group_id" {
  value = yandex_vpc_security_group.kittygram_sg.id
} 