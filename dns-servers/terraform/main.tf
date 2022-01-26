
data "xenorchestra_pool" "pool" {
    name_label = "xcp-ng-pool-01"
}

data "xenorchestra_template" "ubuntu_focal_2004_cloudimg" {
    name_label = "ubuntu-focal-20.04-cloudimg-20220124"
}

data "xenorchestra_sr" "iscsi_vm_store" {
    name_label = "iscsi-vm-store"
    pool_id = data.xenorchestra_pool.pool.id
}

data "xenorchestra_network" "shopnet" {
    name_label = "50-shopnet"
    pool_id = data.xenorchestra_pool.pool.id
}

resource "xenorchestra_cloud_config" "cloud_config" {
    count = length(var.ipv4_addresses)
    name = "DNS Cloud Config"
    template = <<EOF
#cloud-config
hostname: ${var.hostname_prefix}${(count.index + 1)}.${var.base_domain}
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

packages:
  - xe-guest-utilities
EOF
}

resource "xenorchestra_cloud_config" "cloud_network_config" {
    count = length(var.ipv4_addresses)
    name = "DNS Cloud Config"
    template = <<EOF
network:
  version: 1
  config:
    - type: physical
      name: eth0
      subnets:
        - type: static
          address: ${var.ipv4_addresses[count.index]}${var.ipv4_addresses_cidr}
          gateway: ${var.default_gateway}
          dns_nameservers:
            - ${var.default_gateway}
            - 8.8.8.8
            - 8.8.4.4
          dns_search:
            - ${var.base_domain}

EOF
}

resource "xenorchestra_vm" "server" {
    count = length(var.ipv4_addresses)

    memory_max = 4294967296
    cpus = 2
    name_label = "${var.hostname_prefix}${(count.index + 1)}.${var.base_domain}"
    template = data.xenorchestra_template.ubuntu_focal_2004_cloudimg.id
    cloud_config = xenorchestra_cloud_config.cloud_config[count.index].template
    cloud_network_config = xenorchestra_cloud_config.cloud_network_config[count.index].template

    network {
        network_id = data.xenorchestra_network.shopnet.id
    }

    disk {
        sr_id = data.xenorchestra_sr.iscsi_vm_store.id
        name_label = "${var.hostname_prefix}${(count.index + 1)}.${var.base_domain}"
        size = 50212254720
    }
}

output "instance_hostnames" {
    value = xenorchestra_vm.server[*].name_label
}

output "instance_ipv4_addresses" {
    value = xenorchestra_vm.server[*].ipv4_addresses
}