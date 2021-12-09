terraform {
    required_providers {
        xenorchestra = {
            source = "terra-farm/xenorchestra"
            version = "0.22.0"
        }
    }
}

data "xenorchestra_pool" "pool" {
    name_label = "xcp-ng-01"
}

data "xenorchestra_template" "ubuntu_focal_2004_cloudimg_20211202" {
    name_label = "ubuntu-focal-20.04-cloudimg-20211202"
}

data "xenorchestra_sr" "local_storage" {
    name_label = "Local storage"
    pool_id = data.xenorchestra_pool.pool.id
}

data "xenorchestra_network" "shopnet" {
    name_label = "50-shopnet"
    pool_id = data.xenorchestra_pool.pool.id
}

data "xenorchestra_network" "cloudnet" {
    name_label = "52-cloudnet"
    pool_id = data.xenorchestra_pool.pool.id
}

data "xenorchestra_network" "kubernetes" {
    name_label = "60-kubernetes"
    pool_id = data.xenorchestra_pool.pool.id
}

data "xenorchestra_network" "management" {
    name_label = "100-managementnet"
    pool_id = data.xenorchestra_pool.pool.id
}
