module "jumpbox" {
    source = "../tf-modules/dynamic-instance" // Default: VM created with Terraform
    vm_name_description = "jumpbox"
    vm_count = 1 
    username_admin = var.username_admin
    public_key_admin = var.public_key_admin
    username_ansible = var.username_ansible
    public_key_ansible = var.public_key_ansible
    vm_name_prefix = "jumpbox-"
    xen_pool_name = "xcp-ng-pool-01"
    xen_template_name = "ubuntu-focal-20.04-cloudimg-20220124"
    #xen_storage_name = ""
    xen_network_name = "50-shopnet"
    #vm_disk_size_gb = ""
    #vm_memory_size_gb = ""
    #vm_cpu_count = ""
}

output "dynamic_hostnames" {
    value = module.jumpbox.instance_hostnames
}

output "dynamic_ipv4" {
    value = module.jumpbox.instance_ipv4_addresses
}