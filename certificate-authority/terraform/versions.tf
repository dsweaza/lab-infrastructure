terraform {
    required_providers {
        xenorchestra = {
            source = "terra-farm/xenorchestra"
            version = "0.22.0"
        }
    }

    cloud {
        organization = "dylanlab"
        workspaces {
            name = "lab-infrastructure"
        }
    }
    
}
