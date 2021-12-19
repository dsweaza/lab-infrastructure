module "ca" {
    source = "../../tf-modules/static-instance"
    vm_name_description = "Certificate Authority"

    realm = "dylanlab.xyz"
    vm_names = ["ca"]
    vm_ipv4_addresses = ["10.0.20.8"]
    vm_ipv4_addresses_cidr = 24
    
    username_admin = var.username_admin
    public_key_admin = var.public_key_admin
    username_ansible = var.username_ansible
    public_key_ansible = var.public_key_ansible
}


output "static_hostnames" {
    value = module.ca.instance_hostnames
}

output "static_ipv4" {
    value = module.ca.instance_ipv4_addresses
}