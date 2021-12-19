# Set these variables in environment or terraform.tfvars

variable "realm" {
    description = "Realm - Domain (Default dylanlab.xyz)"
    type = string
    default = "dylanlab.xyz"
}

variable "vm_names" {
    description = "List of hostnames"
    type = list(string)
}

variable "vm_ipv4_addresses" {
    description = "List of IPv4 Addresses for DNS Servers"
    type = list(string)
}

variable "vm_ipv4_addresses_cidr" {
    description = "CIDR of ipv4_addresses Above - No Slash"
    type = number
    default = 24
}

variable "default_gateway" {
    description = "Default Gateway IPv4"
    type = string
    default = "10.0.20.1"
}

variable "dns_server_primary" {
    description = "DNS Server (Default 10.0.20.5)"
    type = string
    default = "10.0.20.5"
}

variable "dns_server_secondary" {
    description = "DNS Server (Default 10.0.20.6)"
    type = string
    default = "10.0.20.6"
}

variable "vm_name_description" {
    description = "VM Description"
    type = string
    default = "VM created with Terraform"
}

variable "xen_pool_name" {
    description = "XenOrchestra Pool (Default xcp-ng-01)"
    type = string
    default = "xcp-ng-01"
}

variable "xen_template_name" {
    description = "XenOrchestra Template (Default Ubuntu Focal)"
    type = string
    default = "ubuntu-focal-20.04-cloudimg-20211202-iscsi"
}

variable "xen_storage_name" {
    description = "XenOrchestra Storage (Default iscsi-vm-store)"
    type = string
    default = "iscsi-vm-store"
}

variable "xen_network_name" {
    description = "XenOrchestra Network (Default 50-shopnet)"
    type = string
    default = "50-shopnet-10g"
}

variable "vm_disk_size_gb" {
    description = "Disk size in Gb (Default 30)"
    default = 30
    type    = number
}

variable "vm_memory_size_gb" {
    description = "Memory in Gb (Default 4)"
    default = 4
    type    = number
}

variable "vm_cpu_count" {
    description = "CPU Count (Default 2)"
    default = 2
    type    = number
}

variable "username_ansible" {
    description = "Ansible account username"
    type = string
    default = "ansible"
}

variable "public_key_ansible" {
    type = string
    description = "Ansible account authorized key"
    default = ""
}

variable "username_admin" {
    description = "Administrator account username"
    type = string
    default = "admin"
}

variable "public_key_admin" {
    type = string
    description = "Administrator account authorized key"
    default = ""
}