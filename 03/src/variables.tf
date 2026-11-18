###cloud vars
variable "token" {
  type        = string
  description = "OAuth-token; https://cloud.yandex.ru/docs/iam/concepts/authorization/oauth-token"
}

variable "cloud_id" {
  type        = string
  description = "https://cloud.yandex.ru/docs/resource-manager/operations/cloud/get-id"
}

variable "folder_id" {
  type        = string
  description = "https://cloud.yandex.ru/docs/resource-manager/operations/folder/get-id"
}

variable "default_zone" {
  type        = string
  default     = "ru-central1-a"
  description = "https://cloud.yandex.ru/docs/overview/concepts/geo-scope"
}
variable "default_cidr" {
  type        = list(string)
  default     = ["10.0.1.0/24"]
  description = "https://cloud.yandex.ru/docs/vpc/operations/subnet-create"
}

variable "vpc_name" {
  type        = string
  default     = "develop"
  description = "VPC network&subnet name"
}

variable "vm_settings" {
  description = "Общие параметры ВМ"

  type = object({
    platform_id    = string
    image_family   = string
    core_fraction  = number
    disk_type      = string
    preemptible    = bool
    nat            = bool
    ssh_user       = string
    ssh_public_key = string
    serial_port    = number
  })

  default = {
    platform_id    = "standard-v3"
    image_family   = "ubuntu-2204-lts"
    core_fraction  = 20
    disk_type      = "network-hdd"
    preemptible    = true
    nat            = true
    ssh_user       = "ubuntu"
    ssh_public_key = "~/.ssh/id_ed25519.pub"
    serial_port    = 1
  }
}

variable "web_vm" {
  description = "Количество и одинаковые параметры WEB-ВМ"

  type = object({
    count       = number
    name_prefix = string
    cpu         = number
    ram         = number
    disk_volume = number
  })

  default = {
    count       = 2
    name_prefix = "web"
    cpu         = 2
    ram         = 2
    disk_volume = 10
  }
}

variable "each_vm" {
  description = "Параметры ВМ для баз данных"

  type = list(object({
    vm_name     = string
    cpu         = number
    ram         = number
    disk_volume = number
  }))

  default = [
    {
      vm_name     = "main"
      cpu         = 4
      ram         = 4
      disk_volume = 20
    },
    {
      vm_name     = "replica"
      cpu         = 2
      ram         = 2
      disk_volume = 15
    }
  ]
}

variable "storage_vm" {
  description = "Параметры ВМ storage и её дополнительных дисков"

  type = object({
    name            = string
    cpu             = number
    ram             = number
    boot_disk_size  = number
    data_disk_count = number
    data_disk_size  = number
  })

  default = {
    name            = "storage"
    cpu             = 2
    ram             = 2
    boot_disk_size  = 10
    data_disk_count = 3
    data_disk_size  = 1
  }
}

