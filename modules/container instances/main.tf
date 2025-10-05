locals {
  env = var.env
  region = var.region != null ? var.region : "polandcentral"
  create_rg = var.create_rg == true ? 1 : 0
  rg_name = coalesce(var.rg_name, "${local.env}-rg")
  is_linux = var.kind == "Linux"
}

resource "azurerm_resource_group" "this" {
  count = local.create_rg
  name =  local.rg_name
  location = local.region
  tags = merge(
    var.tags_rg,
    { env = local.env }
  )
}

resource "azurerm_container_group" "this" {
  count = local.is_linux ? 1 : 0
  name                = "${var.container_group_name}-${local.env}"
  location            = local.region
  resource_group_name = local.rg_name
  ip_address_type     = var.public_type ? "Public" : "Private"
  os_type             = var.kind
  restart_policy = "OnFailure"
  dns_name_label = coalesce(var.dns_label,"container1-${local.env}")
  container {
    name   = var.container_name
    cpu    = coalesce(var.cpu , 1)
    memory = coalesce(var.memory, 1.5)
    image  = var.image
    ports {
      port     = coalesce(var.port, 80)
      protocol = "TCP"
    }
    environment_variables = var.env_variables
    dynamic volume {
      for_each = var.volume != null ? var.volume : []
      content {
        name = volume.value.name
        mount_path = volume.value.mount_path
        read_only = volume.value.read_only
        empty_dir = volume.value.empty_dir
        storage_account_name = volume.value.storage_account_name
        share_name = volume.value.share_name
        secret = volume.value.secret
      }
    }
  }
    dynamic "container" {
    for_each = var.sidecar ? [1] : []
    content {
      name   = "sidecar"
      image  = "zwindler/slow-sidecar"
      cpu    = "0.5"
      memory = "1.5"
    }
  }
  tags = var.tags_rg
  depends_on = [ azurerm_resource_group.this ]
}
