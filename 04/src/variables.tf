variable "token" {
  type        = string
  sensitive   = true
  description = "Временный IAM-токен Yandex Cloud; передаётся через TF_VAR_token"
}

variable "cloud_id" {
  type        = string
  description = "Идентификатор облака Yandex Cloud"
}

variable "folder_id" {
  type        = string
  description = "Идентификатор каталога Yandex Cloud"
}

variable "default_zone" {
  type        = string
  default     = "ru-central1-a"
  description = "Зона подсети и обеих ВМ"
}

variable "default_cidr" {
  type        = list(string)
  default     = ["10.0.1.0/24"]
  description = "IPv4-диапазоны учебной подсети"
}

variable "vpc_name" {
  type        = string
  default     = "terraform-04-develop"
  description = "Имя сети и подсети задания 04"
}

variable "ssh_public_key_path" {
  type        = string
  default     = "~/.ssh/id_ed25519.pub"
  description = "Путь к публичному SSH-ключу на машине, где запущен Terraform"
}

variable "projects" {
  type = object({
    marketing = string
    analytics = string
  })
  default = {
    marketing = "marketing"
    analytics = "analytics"
  }
  description = "Значения метки project и основы имён ВМ"
}

variable "vm" {
  type = object({
    image_family  = string
    platform      = string
    cores         = number
    memory        = number
    core_fraction = number
    disk_size     = number
    disk_type     = string
  })
  default = {
    image_family  = "ubuntu-2204-lts"
    platform      = "standard-v3"
    cores         = 2
    memory        = 2
    core_fraction = 20
    disk_size     = 10
    disk_type     = "network-hdd"
  }
  description = "Общий профиль учебных ВМ"
}
