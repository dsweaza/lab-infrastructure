# Set these variables in environment or terraform.tfvars

variable "base_domain" {
    description = "Base domain name"
    type = string
    default = "dylanlab.xyz"
}

variable "ipv4_addresses" {
    description = "List of IPv4 Addresses for DNS Servers"
    type = list(string)
}

variable "ipv4_addresses_cidr" {
    description = "CIDR of ipv4_addresses Above"
    type = string
    default = "/24"
}

variable "hostname_prefix" {
    description = "Server hostname prefix"
    type = string
    default = "ns" # Terraform creates predicable naming: ns1, ns2, ...
}

variable "default_gateway" {
    description = "Default Gateway IPv4"
    type = string
    default = "10.0.20.1"
}

variable "username_ansible" {
    description = "Ansible account username"
    type = string
    default = "ansible"
}

variable "public_key_ansible" {
    type = string
    description = "Ansible account authorized key"
}

variable "username_admin" {
    description = "Administrator account username"
    type = string
    default = "admin"
}

variable "public_key_admin" {
    type = string
    description = "Administrator account authorized key"
}