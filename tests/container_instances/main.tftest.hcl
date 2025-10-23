mock_provider "azurerm" {}

run "setup_infra" {
  module {
    source = "./"
  }
}
run "test_container_instances" {
  command = plan

    assert {
    condition     = module.container_instances.resource_group_count == 1
    error_message = "Resource Group nie została utworzona pomimo create_rg = true"
    }

    assert {
        condition     = module.container_instances.resource_group_name == "rg1"
        error_message = "Nazwa Resource Group powinna być 'rg1'"
    }

    assert {
        condition     = module.container_instances.resource_group_location == "polandcentral"
        error_message = "Resource Group powinna być w regionie 'polandcentral'"
    }

    assert {
    condition = module.container_instances.container_group_count == 1
    error_message = "Container Group nie został utworzony"
    }

    assert {
    condition = module.container_instances.container_group_name == "container-group-dev"
    error_message = "Nazwa Container Group powinna być 'container-group-dev'"
    }

    assert {
    condition = module.container_instances.container_group_network_type == "Public"
    error_message = "Container Group powinien mieć publiczny adres IP (public_type = true)"
    }


    assert {
    condition = module.container_instances.container_group_containers[0].environment_variables.test == "value1"
    error_message = "Zmienna środowiskowa 'test' nie ma wartości 'value1'"
    }

    assert {
    condition = module.container_instances.container_group_containers[0].environment_variables.test2 == "value2"
    error_message = "Zmienna środowiskowa 'test2' nie ma wartości 'value2'"
    }

    assert {
    condition = contains([for c in module.container_instances.container_group_containers[*].name : c], "sidecar")
    error_message = "Brakuje sidecar container pomimo sidecar = true"
    }

    assert {
    condition = module.container_instances.container_group_containers[0].volume[0].name == "test-mount"
    error_message = "Volume 'test-mount' nie został utworzony"
    }

}