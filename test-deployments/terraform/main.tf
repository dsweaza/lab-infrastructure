variable "vm_count" {
    type = number
    default = 3
}

variable "vm_name_prefix" {
    type = string 
    default = "us20-test-"
}

variable "dns_suffix" {
    type = string
    default = ".dylanlab.xyz"
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

# Instruct terraform to download the provider on `terraform init`
terraform {
    required_providers {
        xenorchestra = {
            source = "terra-farm/xenorchestra"
            version = "~> 0.20.0"
        }
    }
}

# vm.tf
data "xenorchestra_pool" "pool" {
    name_label = "xcp-ng-01"
}

data "xenorchestra_template" "vm_template" {
    name_label = "ubuntu-focal-20.04-cloudimg-20211202"
}

data "xenorchestra_sr" "sr" {
    name_label = "Local storage"
    pool_id = data.xenorchestra_pool.pool.id
}

data "xenorchestra_network" "network" {
    name_label = "50-shopnet"
    pool_id = data.xenorchestra_pool.pool.id
}

resource "random_id" "vm_id" {
    count = var.vm_count
    byte_length = 8
}

resource "xenorchestra_cloud_config" "cloud_config" {
    count = var.vm_count
    name = "DNS Cloud Config"
    template = <<EOF
#cloud-config
hostname: ${var.vm_name_prefix}${random_id.vm_id[count.index].hex}
users:
  - name: ${var.username_admin}
    gecos: ${var.username_admin}
    shell: /bin/bash
    sudo: ALL=(ALL) NOPASSWD:ALL
    ssh_authorized_keys:
      - ${var.public_key_admin}
  - name: ${var.username_ansible}
    gecos: ${var.username_ansible}
    shell: /bin/bash
    sudo: ALL=(ALL) NOPASSWD:ALL
    ssh_authorized_keys:
      - ${var.public_key_ansible}

runcmd: 
  - dhclient -r
  - dhclient

packages:
  - xe-guest-utilities

EOF
}


resource "xenorchestra_vm" "server" {
    count = var.vm_count

    memory_max = 4294967296
    cpus = 2
    name_label = "${var.vm_name_prefix}${random_id.vm_id[count.index].hex}"
    template = data.xenorchestra_template.vm_template.id
    cloud_config = xenorchestra_cloud_config.cloud_config[count.index].template

    network {
        network_id = data.xenorchestra_network.network.id
    }

    disk {
        sr_id = data.xenorchestra_sr.sr.id
        name_label = "${var.vm_name_prefix}${random_id.vm_id[count.index].hex}${var.dns_suffix}"
        size = 50212254720
    }
}

output "instance_hostnames" {
    value = xenorchestra_vm.server[*].name_label
}

output "instance_ipv4_addresses" {
    value = xenorchestra_vm.server[*].ipv4_addresses
}