variable "cloud_id" {
  type = string
}

variable "folder_id" {
  type = string
}

variable "zone" {
  type    = string
  default = "ru-central1-d"
}

variable "vm_name" {
  type    = string
  default = "kittygram-server"
}

variable "ssh_username" {
  type    = string
  default = "ubuntu"
} 

variable "ssh_key_content" {
  type = string
}