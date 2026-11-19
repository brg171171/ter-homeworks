# Модуль VPC

Создаёт одну сеть и одну подсеть Yandex Cloud. Подсеть получает то же имя, что и сеть; через выход `subnet` корневой модуль получает ID сети, ID подсети, зону и CIDR.

```hcl
module "vpc_dev" {
  source = "./vpc"

  network_name   = "develop"
  zone           = "ru-central1-a"
  v4_cidr_blocks = ["10.0.1.0/24"]
}
```

<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
| ---- | ------- |
| <a name="provider_yandex"></a> [yandex](#provider\_yandex) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
| ---- | ---- |
| [yandex_vpc_network.this](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/vpc_network) | resource |
| [yandex_vpc_subnet.this](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/vpc_subnet) | resource |

## Inputs

| Name | Description | Type | Default | Required |
| ---- | ----------- | ---- | ------- | :------: |
| <a name="input_network_name"></a> [network\_name](#input\_network\_name) | Имя сети и подсети | `string` | n/a | yes |
| <a name="input_v4_cidr_blocks"></a> [v4\_cidr\_blocks](#input\_v4\_cidr\_blocks) | Список IPv4 CIDR-блоков подсети | `list(string)` | n/a | yes |
| <a name="input_zone"></a> [zone](#input\_zone) | Зона доступности подсети | `string` | n/a | yes |

## Outputs

| Name | Description |
| ---- | ----------- |
| <a name="output_subnet"></a> [subnet](#output\_subnet) | Сведения о созданной подсети |
<!-- END_TF_DOCS -->
