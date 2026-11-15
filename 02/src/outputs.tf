output "vms_info" {
  description = "Имена, внешние IP-адреса и FQDN виртуальных машин"

  value = [
    for vm in [
      yandex_compute_instance.platform,
      yandex_compute_instance.platform_db
      ] : {
      instance_name = vm.name
      external_ip   = vm.network_interface[0].nat_ip_address
      fqdn          = vm.fqdn
    }
  ]
}

