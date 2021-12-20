variable "vm_count" {
    description = "Number of idential VMs required (Default 1)"
    type = number
    default = 1
}

variable "vm_name_prefix" {
    description = "VM hostname prefix (Default '')"
    type = string 
    default = ""
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
    default = "50-shopnet"
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