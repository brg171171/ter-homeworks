output "subnet" {
  description = "Сведения о созданной подсети"
  value = {
    id             = yandex_vpc_subnet.this.id
    name           = yandex_vpc_subnet.this.name
    network_id     = yandex_vpc_subnet.this.network_id
    zone           = yandex_vpc_subnet.this.zone
    v4_cidr_blocks = yandex_vpc_subnet.this.v4_cidr_blocks
  }
}
