moved {
  from = yandex_vpc_network.develop
  to   = module.vpc_dev.yandex_vpc_network.this
}

moved {
  from = yandex_vpc_subnet.develop
  to   = module.vpc_dev.yandex_vpc_subnet.this
}
