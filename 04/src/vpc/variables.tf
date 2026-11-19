variable "network_name" {
  type        = string
  description = "Имя сети и подсети"
}

variable "zone" {
  type        = string
  description = "Зона доступности подсети"
}

variable "v4_cidr_blocks" {
  type        = list(string)
  description = "Список IPv4 CIDR-блоков подсети"
}
