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

resource "xenorchestra_cloud_config" "cloud_config" {
    count = length(var.vm_names)
    name = "DNS Cloud Config"
    template = <<EOF
#cloud-config
hostname: ${var.vm_names[count.index]}
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
          gateway: ${var.default_gateway}
          dns_nameservers:
            - 10.0.20.5
            - 10.0.20.6
          dns_search:
            - ${var.dns_search_domain}
EOF
}

resource "xenorchestra_vm" "server" {
    count = length(var.vm_names)

    memory_max = var.vm_memory_size_gb * 1024 * 1024 * 1024 # GB to B
    cpus = var.vm_cpu_count
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
        size = var.vm_disk_size_gb * 1024 * 1024 * 1024 # GB to B
    }
}

output "instance_hostnames" {
    value = xenorchestra_vm.server[*].name_label
}

output "instance_ipv4_addresses" {
    value = xenorchestra_vm.server[*].ipv4_addresses
}