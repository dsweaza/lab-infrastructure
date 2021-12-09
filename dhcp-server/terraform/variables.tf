variable "vm_names" {
    description = "List of DHCP server FQDNs"
    type = list(string)
    default = ["dhcp.example.com"]
}

variable "vm_ipv4_addresses" {
    description = "List of CIDR IPv4 Addresses for DNS Servers"
    type = list(string)
    default = ["10.0.20.4/24"]
}

variable "vm_disk_size_gb" {
    default = 30
    type    = number
}

variable "vm_memory_size_gb" {
    default = 4
    type    = number
}

variable "vm_cpu_count" {
    default = 2
    type    = number
}

variable "default_gateway" {
    description = "Default Gateway IPv4"
    type = string
    default = "10.0.20.1"
}

variable "dns_search_domain" {
    description = "DNS Search Domain"
    type = string
    default = "dylanlab.xyz"
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