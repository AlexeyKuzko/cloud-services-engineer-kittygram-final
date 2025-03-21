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

variable "access_key" {
  description = "Yandex Cloud access key for S3"
  type        = string
  sensitive   = true
}

variable "secret_key" {
  description = "Yandex Cloud secret key for S3"
  type        = string
  sensitive   = true
}

variable "service_account_key_file" {
  description = "Path to the service account key file"
  type        = string
  sensitive   = true
}