terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex" // глобальный адрес источника провайдера
    }
  }
  required_version = ">= 0.13"  // версия, совместимая с провайдером версия Terraform

  backend "s3" {
    endpoints = {
      s3 = "https://storage.yandexcloud.net"
    }
    bucket                     = "s3-bucket-yndx-kuzkoalexey"
    region                     = "ru-central1"
    key                        = "tf-state.tfstate"

    skip_region_validation     = true
    skip_credentials_validation = true
    skip_requesting_account_id = true
    skip_s3_checksum          = true
  }
}

provider "yandex" {
  cloud_id  = var.cloud_id
  folder_id = var.folder_id
  zone      = "ru-central1-d"  // зона доступности по-умолчанию, где будут создаваться ресурсы
}