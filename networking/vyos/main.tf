

data "xenorchestra_pool" "pool" {
  name_label = "xcp-ng-01"
}

data "xenorchestra_template" "vm_template" {
  name_label = "vyos-1.3-equelleus"
}

data "xenorchestra_sr" "sr" {
  name_label = "Local storage"
  pool_id = data.xenorchestra_pool.pool.id
}

data "xenorchestra_network" "shopnet" {
  name_label = "50-shopnet"
  pool_id = data.xenorchestra_pool.pool.id
}

resource "xenorchestra_cloud_config" "cloud_config" {
    count = var.vm_count
    name = "DNS Cloud Config"
    template = <<EOF
#cloud-config
vyos_config_commands:
  - set system host-name '${var.vm_hostname_prefix}-${count.index + 1}'
  - set system ntp server 1.pool.ntp.org
  - set system ntp server 2.pool.ntp.org
  #- delete interfaces ethernet eth0 address 'dhcp'
  #- set interfaces ethernet eth0 address '10.0.20.21/24'
  #- set protocols static route 10.0.20.0/24 next-hop '10.0.20.1'

EOF
}

resource "xenorchestra_vm" "server" {
    count = var.vm_count

    memory_max = var.vm_memory_size_gb * 1024 * 1024 * 1024 # GB to B
    cpus = var.vm_cpu_count
    name_label = "${var.vm_hostname_prefix}-${count.index + 1}"
    template = data.xenorchestra_template.vm_template.id
    cloud_config = xenorchestra_cloud_config.cloud_config[count.index].template
    

    network {
        network_id = data.xenorchestra_network.shopnet.id
    }

    disk {
        sr_id = data.xenorchestra_sr.sr.id
        name_label = "${var.vm_hostname_prefix}-${count.index + 1}"
        size = var.vm_disk_size_gb * 1024 * 1024 * 1024 # GB to B
    }
}

output "instance_hostnames" {
    value = xenorchestra_vm.server[*].name_label
}

output "instance_ipv4_addresses" {
    value = xenorchestra_vm.server[*].ipv4_addresses
}