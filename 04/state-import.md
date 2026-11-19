# Terraform 04: задание 3. Удаление записей из состояния и обратный импорт

Инструкция для `04/src` после применения задания 2. В конфигурации три вызова модулей: `vpc_dev`, `marketing_vm` и `analytics_vm`. В упражнении нужно удалить только привязки из состояния, не трогая сеть, подсеть и ВМ в Yandex Cloud. Именно так работает [`terraform state rm`](https://developer.hashicorp.com/terraform/cli/commands/state/rm).

## Исходное состояние

Открой Bash в WSL и работай из того же корневого модуля, с теми же параметрами авторизации, backend и рабочим пространством, которые использовались при применении задания 2. Не меняй облако, каталог, зону и профиль провайдера во время упражнения. Если IAM-токен истёк, обнови его привычным для проекта способом.

```bash
cd ~/ter-homeworks/ter-homeworks/04/src
terraform workspace show
terraform state list
terraform plan -input=false
```

В списке должны быть следующие управляемые ресурсы. Записи `data.*` могут присутствовать дополнительно.

```text
module.vpc_dev.yandex_vpc_network.this
module.vpc_dev.yandex_vpc_subnet.this
module.marketing_vm.yandex_compute_instance.vm[0]
module.analytics_vm.yandex_compute_instance.vm[0]
```

Если сеть и подсеть ещё видны как `yandex_vpc_network.develop` и `yandex_vpc_subnet.develop` без префикса `module.vpc_dev`, сначала заверши перенос из задания 2. Если первоначальный план уже показывает изменение или пересоздание ресурсов, разберись с ним до удаления записей. Сделай первый скриншот: рабочее пространство и `terraform state list`.

## Резервная копия и ID

Сохрани снимок текущего состояния за пределами репозитория. [`terraform state pull`](https://developer.hashicorp.com/terraform/cli/commands/state/pull) читает состояние из настроенного backend; вывод команды перенаправляем в файл, а не на экран. Для извлечения ID из JSON нужен `jq`.

```bash
backup_dir="$(mktemp -d "$HOME/tf-04-state.XXXXXXXX")" &&
backup_file="$backup_dir/before.tfstate" &&
terraform state pull > "$backup_file" &&
test -s "$backup_file" &&
printf 'Резервная копия: %s\n' "$backup_file"
```

```bash
state_id() {
  terraform show -json "$backup_file" |
    jq -er --arg addr "$1" '
      .values.root_module.child_modules[]?.resources[]?
      | select(.mode == "managed" and .address == $addr)
      | .values.id
      | select(type == "string" and length > 0)
    '
}

NETWORK_ID="$(state_id 'module.vpc_dev.yandex_vpc_network.this')" &&
SUBNET_ID="$(state_id 'module.vpc_dev.yandex_vpc_subnet.this')" &&
MARKETING_ID="$(state_id 'module.marketing_vm.yandex_compute_instance.vm[0]')" &&
ANALYTICS_ID="$(state_id 'module.analytics_vm.yandex_compute_instance.vm[0]')" &&
printf 'NETWORK_ID=%s\nSUBNET_ID=%s\nMARKETING_ID=%s\nANALYTICS_ID=%s\n' \
  "$NETWORK_ID" "$SUBNET_ID" "$MARKETING_ID" "$ANALYTICS_ID"
```

Продолжай только если напечатаны четыре непустых ID и они соответствуют нужным ресурсам. При желании сверь ID ВМ с `yc compute instance list`. Не прикладывай весь state к отчёту и не коммить его. Если терминал закроется, в новом сеансе задай `backup_file` по выведенному пути, повторно объяви функцию `state_id` и снова извлеки ID из копии.

## Удаление модулей только из состояния

Сначала посмотри, какие адреса попадут под удаление. Флаг `-dry-run` не изменяет состояние, а адрес модуля выбирает все его записи ([справка HashiCorp](https://developer.hashicorp.com/terraform/cli/commands/state/rm)).

```bash
terraform state rm -dry-run \
  'module.vpc_dev' 'module.marketing_vm' 'module.analytics_vm'
```

Если затрагиваются только три нужных модуля, выполни следующий блок. Между удалением записей и полным импортом **не запускай `terraform apply` или `terraform destroy`**.

```bash
test -s "${backup_file:-/dev/null}" &&
test -n "${NETWORK_ID:-}" &&
test -n "${SUBNET_ID:-}" &&
test -n "${MARKETING_ID:-}" &&
test -n "${ANALYTICS_ID:-}" &&
terraform state rm 'module.vpc_dev' &&
terraform state rm 'module.marketing_vm' 'module.analytics_vm' &&
terraform state list
```

Сделай второй скриншот: сообщения `Removed` и результат `terraform state list`. Записи трёх модулей должны исчезнуть. Корневой `data.template_file.cloudinit` может остаться, и удалять его не нужно.

## Обратный импорт

Восстанови привязки по порядку: сеть → подсеть → две ВМ. Провайдер импортирует существующие [сети](https://raw.githubusercontent.com/yandex-cloud/terraform-provider-yandex/master/docs/resources/vpc_network.md), [подсети](https://raw.githubusercontent.com/yandex-cloud/terraform-provider-yandex/master/docs/resources/vpc_subnet.md) и [ВМ](https://raw.githubusercontent.com/yandex-cloud/terraform-provider-yandex/master/docs/resources/compute_instance.md) по их ID. Кавычки вокруг адресов ВМ защищают `[0]` от интерпретации оболочкой ([справка `terraform import`](https://developer.hashicorp.com/terraform/cli/commands/import)).

```bash
terraform import -input=false 'module.vpc_dev.yandex_vpc_network.this' "$NETWORK_ID" &&
terraform import -input=false 'module.vpc_dev.yandex_vpc_subnet.this' "$SUBNET_ID" &&
terraform import -input=false 'module.marketing_vm.yandex_compute_instance.vm[0]' "$MARKETING_ID" &&
terraform import -input=false 'module.analytics_vm.yandex_compute_instance.vm[0]' "$ANALYTICS_ID"
```

Если одна из команд завершится ошибкой, цепочка остановится. Посмотри `terraform state list`, исправь причину и продолжи с первого отсутствующего адреса. Успешно импортированные записи повторно импортировать не нужно. Сделай третий скриншот: `Import successful!` и восстановленные адреса после `terraform state list`.

## Проверка и материалы для отчёта

```bash
terraform state list
terraform plan -input=false
```

Идеальный результат: `No changes. Your infrastructure matches the configuration.` Если план показывает только `Changes to Outputs`, проверь, что действий над инфраструктурой действительно нет. Если он предлагает создание, удаление, замену или изменение ресурса, не применяй его ради чистого отчёта: сохрани конкретный diff и выясни причину.

Сделай четвёртый скриншот итогового плана. В отчёт приложи фактически выполненные команды и четыре снимка: состояние до удаления, удаление записей, импорт с восстановленными адресами, итоговый план. Не прикладывай токены, приватные ключи, файлы состояния или бинарный план.
