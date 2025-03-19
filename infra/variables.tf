variable "cloud_id" {
  type = string
}

variable "folder_id" {
  type = string
}

variable "zone" {
  type    = string
  default = "ru-central1-a"
}

variable "vm_name" {
  type    = string
  default = "kittygram-server"
}

variable "ssh_username" {
  type    = string
  default = "ubuntu"
} 