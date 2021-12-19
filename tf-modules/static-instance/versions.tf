terraform {
    required_providers {
        xenorchestra = {
            source = "terra-farm/xenorchestra"
            version = "0.22.0"
        }

        dns = {
            source = "hashicorp/dns"
            version = "3.2.1"
        }
    }
}