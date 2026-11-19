module "vpc_dev" {
  source = "./vpc"

  network_name   = var.vpc_name
  zone           = var.default_zone
  v4_cidr_blocks = var.default_cidr
}

data "template_file" "cloudinit" {
  template = file("${path.module}/cloud-init.yml")

  vars = {
    ssh_public_key = jsonencode(trimspace(file(pathexpand(var.ssh_public_key_path))))
  }
}

locals {
  vm_metadata = {
    user-data = data.template_file.cloudinit.rendered
  }
}

module "marketing_vm" {
  source = "git::https://github.com/udjin10/yandex_compute_instance.git?ref=0f41ce711a18cd1a0cb037f21ab3c4acc9257c88"

  network_id   = module.vpc_dev.subnet.network_id
  subnet_ids   = [module.vpc_dev.subnet.id]
  subnet_zones = [module.vpc_dev.subnet.zone]

  instance_name          = var.projects.marketing
  instance_count         = 1
  image_family           = var.vm.image_family
  platform               = var.vm.platform
  instance_cores         = var.vm.cores
  instance_memory        = var.vm.memory
  instance_core_fraction = var.vm.core_fraction
  boot_disk_size         = var.vm.disk_size
  boot_disk_type         = var.vm.disk_type
  preemptible            = true
  public_ip              = true

  labels   = { project = var.projects.marketing }
  metadata = local.vm_metadata
}

module "analytics_vm" {
  source = "git::https://github.com/udjin10/yandex_compute_instance.git?ref=0f41ce711a18cd1a0cb037f21ab3c4acc9257c88"

  network_id   = module.vpc_dev.subnet.network_id
  subnet_ids   = [module.vpc_dev.subnet.id]
  subnet_zones = [module.vpc_dev.subnet.zone]

  instance_name          = var.projects.analytics
  instance_count         = 1
  image_family           = var.vm.image_family
  platform               = var.vm.platform
  instance_cores         = var.vm.cores
  instance_memory        = var.vm.memory
  instance_core_fraction = var.vm.core_fraction
  boot_disk_size         = var.vm.disk_size
  boot_disk_type         = var.vm.disk_type
  preemptible            = true
  public_ip              = true

  labels   = { project = var.projects.analytics }
  metadata = local.vm_metadata
}
