module "container_instances" {
  source = "../../modules/container instances"

  env = "dev"
  region = "polandcentral"
  create_rg = true

  rg_name = "rg1"
  container_group_name = "container-group"
  public_type = true
  image = "nginx:stable-perl"
  sidecar = true
  env_variables = {
    test = "value1"
    test2 = "value2"
  }
  volume = [{
    name = "test-mount"
    mount_path = "/newFolder"
    read_only = true
    secret = {
      "test.txt" = base64encode("testowy plik")
    }}
  ]
}

output "ip_address" {
  value = module.container_instances.container_ip
}