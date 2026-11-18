data "yandex_compute_image" "ubuntu" {
  family = var.vm_settings.image_family
}

locals {
  ssh_public_key = trimspace(file(pathexpand(var.vm_settings.ssh_public_key)))

  vm_metadata = {
    serial-port-enable = tostring(var.vm_settings.serial_port)
    ssh-keys           = "${var.vm_settings.ssh_user}:${local.ssh_public_key}"
  }
}
