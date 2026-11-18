resource "yandex_compute_instance" "db" {
  for_each = {
    for vm in var.each_vm : vm.vm_name => vm
  }

  name        = each.key
  zone        = yandex_vpc_subnet.develop.zone
  platform_id = var.vm_settings.platform_id

  resources {
    cores         = each.value.cpu
    memory        = each.value.ram
    core_fraction = var.vm_settings.core_fraction
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.id
      type     = var.vm_settings.disk_type
      size     = each.value.disk_volume
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
