module "test-servers" {  
    source = "./test-deployments/terraform"
    vm_name_prefix = "test-"
    vm_disk_size_gb = 6
    vm_memory_size_gb = 2
}