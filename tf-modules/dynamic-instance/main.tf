#
# Creates [vm_count] number of local instances with dynamic names and IP addresses
#

provider "xenorchestra" {
    insecure = true
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

packages:
  - xe-guest-utilities

runcmd:
  - reboot  

EOF
}

resource "xenorchestra_vm" "server" {
    count = var.vm_count

    memory_max = var.vm_memory_size_gb * 1024 * 1024 * 1024 # GB to B
    cpus = var.vm_cpu_count
    name_label = "${var.vm_name_prefix}${random_id.vm_id[count.index].hex}"
    name_description = "${var.vm_name_description}"
    template = data.xenorchestra_template.vm_template.id
    cloud_config = xenorchestra_cloud_config.cloud_config[count.index].template
    #wait_for_ip = true

    network {
        network_id = data.xenorchestra_network.network.id
    }

    disk {
        sr_id = data.xenorchestra_sr.sr.id
        name_label = "${var.vm_name_prefix}${random_id.vm_id[count.index].hex}"
        size = var.vm_disk_size_gb * 1024 * 1024 * 1024 # GB to B
    }
}

output "instance_hostnames" {
    value = xenorchestra_vm.server[*].name_label
}

output "instance_ipv4_addresses" {
    value = xenorchestra_vm.server[*].ipv4_addresses
}