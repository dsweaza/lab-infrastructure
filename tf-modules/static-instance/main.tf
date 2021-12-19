provider "xenorchestra" {
    insecure = true
}

provider "dns" {
  update {
    server        = "10.0.20.5"
    key_name      = "dylanlab.xyz."
    key_algorithm = "hmac-sha256"
    key_secret    = "QZnULB75ySdwR1CNHx3Bjx6CXJKQBa/jcjTfPceoBXU="
  }
}

data "xenorchestra_pool" "pool" {
    name_label = var.xen_pool_name
}

data "xenorchestra_template" "vm_template" {
    name_label = var.xen_template_name
}

data "xenorchestra_sr" "sr" {
    name_label = var.xen_storage_name
    pool_id = data.xenorchestra_pool.pool.id
}

data "xenorchestra_network" "network" {
    name_label = var.xen_network_name
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

#runcmd: # No reload since no DHCP
#  - reboot  

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
          address: ${var.vm_ipv4_addresses[count.index]}/${var.vm_ipv4_addresses_cidr}
          gateway: ${var.default_gateway}
          dns_nameservers:
            - ${var.dns_server_primary}
            - ${var.dns_server_secondary}
          dns_search:
            - ${var.realm}
EOF
}

resource "xenorchestra_vm" "server" {
    count = length(var.vm_names)

    memory_max = var.vm_memory_size_gb * 1024 * 1024 * 1024 # GB to B
    cpus = var.vm_cpu_count
    name_label = "${var.vm_names[count.index]}"
    name_description = "${var.vm_name_description}"
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

resource "dns_a_record_set" "vm_dns" {
  count = length(var.vm_names)

  zone = "${var.realm}."
  name = "${var.vm_names[count.index]}"
  addresses = [
    "${var.vm_ipv4_addresses[count.index]}",
  ]
}

output "instance_hostnames" {
    value = xenorchestra_vm.server[*].name_label
}

output "instance_ipv4_addresses" {
    value = xenorchestra_vm.server[*].ipv4_addresses
}