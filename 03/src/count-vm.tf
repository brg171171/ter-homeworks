resource "yandex_compute_instance" "web" {
  count = var.web_vm.count

  name        = "${var.web_vm.name_prefix}-${count.index + 1}"
  zone        = yandex_vpc_subnet.develop.zone
  platform_id = var.vm_settings.platform_id

  resources {
    cores         = var.web_vm.cpu
    memory        = var.web_vm.ram
    core_fraction = var.vm_settings.core_fraction
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.id
      type     = var.vm_settings.disk_type
      size     = var.web_vm.disk_volume
    }
  }

  scheduling_policy {
    preemptible = var.vm_settings.preemptible
  }

  network_interface {
    subnet_id          = yandex_vpc_subnet.develop.id
    nat                = var.vm_settings.nat
    security_group_ids = [yandex_vpc_security_group.example.id]
  }

  metadata = local.vm_metadata

  depends_on = [yandex_compute_instance.db]
}
