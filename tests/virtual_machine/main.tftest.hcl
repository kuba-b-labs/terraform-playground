run "setup_infra" {
  module {
    source = "./"
  }
}
run "test_virtual_machine" {
  command = plan

    assert {
    condition     = module.virtual_machine.resource_group_count == 1
    error_message = "Resource Group not created even with create_rg = true"
    }

    assert {
        condition     = module.virtual_machine.resource_group_name == "rg1"
        error_message = "Name of the Resource Group should be 'rg1'"
    }

    assert {
        condition     = module.virtual_machine.resource_group_location == "polandcentral"
        error_message = "Resource Group should be in 'polandcentral'"
    }

    assert {
    condition = module.virtual_machine.virtual_network_count == 1
    error_message = "Virtual Network not created"
    }

    assert {
    condition = module.virtual_machine.subnet_count == 1
    error_message = "Subnet not created"
    }

    assert {
    condition = module.virtual_machine.network_interface == 1
    error_message = "Network interface for a virtual machine not created"
    }

    assert {
      condition = module.virtual_machine.security_group == 1
      error_message = "Basic NSG not created"
    }
   
  assert {
    condition = module.virtual_machine.linux_vm_created == 1 || module.virtual_machine.windows_vm_created == 1
    error_message = "virtual machine not created"
  }

}