provider "tls" {
  # Configuration options
}

module "example_dynamic" {
    source = "../../tf-modules/dynamic-instance" // Default: VM created with Terraform
    vm_name_description = "TLS Example"
    vm_count = var.vm_count
    username_admin = var.username_admin
    public_key_admin = var.public_key_admin
    username_ansible = var.username_ansible
    public_key_ansible = var.public_key_ansible
    vm_name_prefix = "tls-example-"
    xen_pool_name = var.xen_pool_name
    xen_template_name = var.xen_template_name
    xen_storage_name = var.xen_storage_name
    xen_network_name = var.xen_network_name
    vm_disk_size_gb = var.vm_disk_size_gb
    vm_memory_size_gb = var.vm_memory_size_gb
    vm_cpu_count = var.vm_cpu_count
}

resource "tls_private_key" "example" {
    count = var.vm_count
    algorithm   = "RSA"
}

resource "tls_cert_request" "example" {
    count = var.vm_count
    key_algorithm   = "RSA"
    private_key_pem = tls_private_key.example[count.index].private_key_pem

    subject {
        common_name  = module.example_dynamic.instance_hostnames[count.index] 
        organization = "DylanLab"
    }

    dns_names = [ 
        module.example_dynamic.instance_hostnames[count.index] 
    ]
}

output "dynamic_hostnames" {
    value = module.example_dynamic.instance_hostnames
}

output "dynamic_ipv4" {
    value = module.example_dynamic.instance_ipv4_addresses
}

output "cert_request_pem" {
    value = tls_cert_request.example[*].cert_request_pem
}