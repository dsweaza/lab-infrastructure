<div id="top"></div>

[![Issues][issues-shield]][issues-url]
[![MIT License][license-shield]][license-url]
[![LinkedIn][linkedin-shield]][linkedin-url]

# Dylan's Lab Infrastructure
I started this project with the goal of learning infrastructure as code and configuration as code using Terraform and Ansible. 
What originally started as a few small projects quickly turned into me fully automating my entire infrastructure. My goal is
to have every system running in my lab and production environment fully automated.


<!-- SUB-SECTIONS -->
### Infrastructure

* [DNS Servers](https://github.com/dsweaza/lab-infrastructure/tree/master/dns-servers)
* [DHCP Server](https://github.com/dsweaza/lab-infrastructure/tree/master/dhcp-servers)
* [Kubernetes Cluster](https://github.com/dsweaza/kubernetes)



## Prerequisites

It is assumed you have the following already in place:
* XCP-NG cluster with Xen Orchestra
* Ubuntu Focal Fossa Cloud Image template ([Cloud Images](https://cloud-images.ubuntu.com/))
* Terraform and Ansible
* Rancher (if deploying the Kubernetes Cluster)


## Setup

1. Clone the repo
    ```sh
    git clone https://github.com/dsweaza/lab-infrastructure.git
    ```
2. Set the environment variables
    ```sh
    export XOA_URL=ws://YOUR.XOA.IP
    export XOA_USER=YOUR_XOA_USER
    export XOA_PASSWORD=YOUR_XOA_PASSWORD
    export TF_VAR_ANSIBLE_SSH_RSA="YOUR_ANSIBLE_PUBLIC_KEY"
    export TF_VAR_DYLAN_SSH_RSA="YOUR_PERSONAL_PUBLIC_KEY"
   ```
3. Clone the repo
    ```sh
    git clone https://github.com/dsweaza/lab-infrastructure.git
    ```


<!-- USAGE EXAMPLES -->
## Usage

_Pending_


<!-- MARKDOWN LINKS & IMAGES -->
<!-- https://www.markdownguide.org/basic-syntax/#reference-style-links -->
[issues-shield]: https://img.shields.io/github/issues/dsweaza/lab-infrastructure?style=for-the-badge
[issues-url]: https://github.com/dsweaza/lab-infrastructure/issues
[license-shield]: https://img.shields.io/github/license/dsweaza/lab-infrastructure?style=for-the-badge
[license-url]: https://github.com/dsweaza/lab-infrastructure/blob/master/LICENSE.txt
[linkedin-shield]: https://img.shields.io/badge/-LinkedIn-black.svg?style=for-the-badge&logo=linkedin&colorB=555
[linkedin-url]: https://linkedin.com/in/dylansweaza