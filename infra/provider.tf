terraform {
  required_providers {
    yandex = {
      source  = "yandex-cloud/yandex"
      version = ">= 0.13"
    }
  }
  required_version = ">= 0.13"

  backend "s3" {
    endpoint                    = "https://storage.yandexcloud.net"
    bucket                     = "s3-bucket-yndx-kuzkoalexey"
    region                     = "ru-central1"
    key                        = "tf-state.tfstate"
    skip_region_validation      = true
    skip_credentials_validation = true
    skip_requesting_account_id  = true
    skip_s3_checksum           = true
  }
}

provider "yandex" {
  cloud_id  = var.cloud_id
  folder_id = var.folder_id
  zone      = "ru-central1-b" // зона доступности по-умолчанию, где будут создаваться ресурсы
  service_account_key_file = var.service_account_key_file
}