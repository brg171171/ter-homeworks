### Образ ОС

variable "vm_web_image_family" {
  type        = string
  default     = "ubuntu-2004-lts"
  description = "Семейство образа ОС для веб-сервера"
}

### Основные параметры ВМ

variable "vm_web_platform_id" {
  type        = string
  default     = "standard-v1"
  description = "Аппаратная платформа виртуальной машины"
}

### Вычислительные ресурсы

/*variable "vm_web_cores" {
  type        = number
  default     = 2
  description = "Количество vCPU"
}

variable "vm_web_memory" {
  type        = number
  default     = 1
  description = "Объем оперативной памяти в ГБ"
}

variable "vm_web_core_fraction" {
  type        = number
  default     = 5
  description = "Гарантированная доля производительности каждого vCPU в процентах"
}
*/
### Планирование и сеть

variable "vm_web_preemptible" {
  type        = bool
  default     = true
  description = "Использование прерываемой виртуальной машины"
}

variable "vm_web_nat" {
  type        = bool
  default     = true
  description = "Назначение публичного IPv4-адреса"
}

### Метаданные

/*variable "vm_web_serial_port_enable" {
  type        = number
  default     = 1
  description = "Включение последовательной консоли: 1 — включена, 0 — выключена"
}

variable "vm_web_ssh_user" {
  type        = string
  default     = "ubuntu"
  description = "Имя пользователя для передачи публичного SSH-ключа"
}
*/
### Виртуальная машина базы данных

variable "vm_db_platform_id" {
  type        = string
  default     = "standard-v3"
  description = "Аппаратная платформа ВМ базы данных"
}

variable "vm_db_zone" {
  type        = string
  default     = "ru-central1-d"
  description = "Зона доступности ВМ базы данных"
}

/*variable "vm_db_cores" {
  type        = number
  default     = 2
  description = "Количество vCPU ВМ базы данных"
}

variable "vm_db_memory" {
  type        = number
  default     = 2
  description = "Объем оперативной памяти ВМ базы данных в ГБ"
}

variable "vm_db_core_fraction" {
  type        = number
  default     = 20
  description = "Гарантированная доля производительности vCPU в процентах"
}
*/
variable "vm_db_image_family" {
  type        = string
  default     = "ubuntu-2004-lts"
  description = "Семейство образа ОС для ВМ базы данных"
}

variable "vm_db_preemptible" {
  type        = bool
  default     = true
  description = "Использование прерываемой ВМ"
}

variable "vm_db_nat" {
  type        = bool
  default     = true
  description = "Назначение публичного IPv4-адреса"
}

/*variable "vm_db_serial_port_enable" {
  type        = number
  default     = 1
  description = "Включение последовательной консоли"
}

variable "vm_db_ssh_user" {
  type        = string
  default     = "ubuntu"
  description = "Пользователь для передачи публичного SSH-ключа"
}
*/
### Подсеть ВМ базы данных

variable "vm_db_subnet_name" {
  type        = string
  default     = "develop-db"
  description = "Имя подсети ВМ базы данных"
}

variable "vm_db_cidr" {
  type        = list(string)
  default     = ["10.0.2.0/24"]
  description = "IPv4-подсеть ВМ базы данных"
}

variable "vm_web_role" {
  type        = string
  default     = "web"
  description = "Роль веб-сервера"
}

variable "vm_db_role" {
  type        = string
  default     = "db"
  description = "Роль сервера базы данных"
}
variable "vms_resources" {
  description = "Вычислительные ресурсы виртуальных машин"

  type = map(object({
    cores         = number
    memory        = number
    core_fraction = number
  }))

  default = {
    web = {
      cores         = 2
      memory        = 1
      core_fraction = 5
    }

    db = {
      cores         = 2
      memory        = 2
      core_fraction = 20
    }
  }
}