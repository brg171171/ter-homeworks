resource "yandex_compute_disk" "storage" {
  count = var.storage_vm.data_disk_count

  name = "${var.storage_vm.name}-disk-${count.index + 1}"
  zone = yandex_vpc_subnet.develop.zone
  type = var.vm_settings.disk_type
  size = var.storage_vm.data_disk_size
}

resource "yandex_compute_instance" "storage" {
  name        = var.storage_vm.name
  zone        = yandex_vpc_subnet.develop.zone
  platform_id = var.vm_settings.platform_id

  resources {
    cores         = var.storage_vm.cpu
    memory        = var.storage_vm.ram
    core_fraction = var.vm_settings.core_fraction
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.id
      type     = var.vm_settings.disk_type
      size     = var.storage_vm.boot_disk_size
    }
  }

  dynamic "secondary_disk" {
    for_each = yandex_compute_disk.storage
    iterator = disk

    content {
      disk_id = disk.value.id
    }
  }

  scheduling_policy {
    preemptible = var.vm_settings.preemptible
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.develop.id
    nat       = var.vm_settings.nat
  }

  metadata = local.vm_metadata
}

