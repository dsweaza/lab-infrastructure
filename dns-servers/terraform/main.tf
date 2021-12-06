variable "vm_names" {
  type = list(string)
  default = ["ns1.dylanlab.xyz", "ns2.dylanlab.xyz"]
}

variable "vm_ipv4_addresses" {
  type = list(string)
  default = ["10.0.20.5/24", "10.0.20.6/24"]
}

variable "ANSIBLE_SSH_RSA" {
    type = string
    description = "Ansibles authorized key - from env"
}

variable "DYLAN_SSH_RSA" {
    type = string
    description = "Dylan authorized key - from env"
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
  name_label = "50 - ShopNet"
  pool_id = data.xenorchestra_pool.pool.id
}

resource "xenorchestra_cloud_config" "cloud_config" {
    count = length(var.vm_names)
    name = "DNS Cloud Config"
    template = <<EOF
#cloud-config
hostname: ${var.vm_names[count.index]}
users:
  - name: dylan
    gecos: dylan
    shell: /bin/bash
    sudo: ALL=(ALL) NOPASSWD:ALL
    ssh_authorized_keys:
      - ${var.DYLAN_SSH_RSA}
  - name: ansible
    gecos: ansible
    shell: /bin/bash
    sudo: ALL=(ALL) NOPASSWD:ALL
    ssh_authorized_keys:
      - ${var.ANSIBLE_SSH_RSA}

packages:
  - xe-guest-utilities
EOF
}

resource "xenorchestra_cloud_config" "cloud_network_config" {
    count = length(var.vm_names)
    name = "DNS Cloud Config"
    template = <<EOF
network:
  version: 1
  config:
    - type: physical
      name: eth0
      subnets:
        - type: static
          address: ${var.vm_ipv4_addresses[count.index]}
          gateway: 10.0.20.1
          dns_nameservers:
            - 10.0.20.1
            - 8.8.8.8
            - 8.8.4.4
          dns_search:
            - dylanlab.xyz

EOF
}

resource "xenorchestra_vm" "server" {
    count = length(var.vm_names)

    memory_max = 4294967296
    cpus = 2
    name_label = "${var.vm_names[count.index]}"
    template = data.xenorchestra_template.vm_template.id
    cloud_config = xenorchestra_cloud_config.cloud_config[count.index].template
    cloud_network_config = xenorchestra_cloud_config.cloud_network_config[count.index].template

    network {
        network_id = data.xenorchestra_network.network.id
    }

    disk {
        sr_id = data.xenorchestra_sr.sr.id
        name_label = "${var.vm_names[count.index]}"
        size = 50212254720
    }
}

output "instance_hostnames" {
    value = xenorchestra_vm.server[*].name_label
}

output "instance_ipv4_addresses" {
    value = xenorchestra_vm.server[*].ipv4_addresses
}