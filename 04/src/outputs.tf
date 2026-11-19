output "vm_public_ips" {
  description = "Внешние IPv4-адреса ВМ для подключения по SSH"
  value = {
    marketing = one(module.marketing_vm.external_ip_address)
    analytics = one(module.analytics_vm.external_ip_address)
  }
}
