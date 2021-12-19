module "example-dynamic" {
    source = "../../tf-modules/dynamic-instance" // Default: VM created with Terraform
    vm_name_description = "Example Dynamic Instance"
    vm_count = 1 
    #vm_name_prefix = ""
    #xen_pool_name = ""
    #xen_template_name = ""
    #xen_storage_name = ""
    #xen_network_name = ""
    #vm_disk_size_gb = ""
    #vm_memory_size_gb = ""
    #vm_cpu_count = ""
    #username_admin = ""
    #public_key_admin = ""
    #username_ansible = ""
    #public_key_ansible = ""
}

module "example-static" {
    source = "../../tf-modules/static-instance"
    vm_name_description = "Example Static Instance"

    realm = "dylanlab.xyz"
    vm_names = ["test1"]
    vm_ipv4_addresses = ["10.0.20.25"]
    vm_ipv4_addresses_cidr = 24
    
    #default_gateway = ""
    #dns_server_primary = ""
    #dns_server_secondary = ""
    #dns_key_name = ""
    #dns_key_algorithm = ""
    #dns_key_secret = ""
    #xen_pool_name = ""
    #xen_template_name = ""
    #xen_storage_name = ""
    #xen_network_name = ""
    #vm_disk_size_gb = ""
    #vm_memory_size_gb = ""
    #vm_cpu_count = ""
    #username_admin = ""
    #public_key_admin = ""
    #username_ansible = ""
    #public_key_ansible = ""
    
}

output "dynamic_hostnames" {
    value = module.example-dynamic.instance_hostnames
}

output "dynamic_ipv4" {
    value = module.example-dynamic.instance_ipv4_addresses
}

output "vm_hostnames" {
    value = module.example-static.instance_hostnames
}

output "static_ipv4" {
    value = module.example-static.instance_ipv4_addresses
}