variable "vm_name" {
  type    = string
  default = "kittygram"
}

variable "subnet_id" {
  type = string
}

variable "security_group_id" {
  type = string
}

variable "ssh_username" {
  type = string
}

variable "ssh_key_content" {
  type = string
}

variable "user_data" {
  type = string
} 