# DNS Servers

Launches defined number of BIND9 servers on Ubuntu 20.04 VMs on XCP-NG. All zones and records are maintained by Ansible.

## Terraform

### Setup

1. Make a Terraform variable definition file. [Terraform Docs](https://www.terraform.io/docs/language/values/variables.html#variable-definition-precedence)
    ```sh
    #Navigate to the terraform dir
    cd terraform
    touch terraform.tfvars
    ```

2. Set the Terraform variables in `terraform.tfvars`
    ```sh
    vm_names = ["ns1.example.com", "ns2.example.com"]
    vm_ipv4_addresses = ["10.0.1.5/24", "10.0.1.6/24"]
    default_gateway = "10.0.1.1"
    dns_search_domain = "example.com"

    # The following variables might already be set with environment variables
    # If not, uncomment and include them here
    #XOA_URL = ""
    #XOA_USER = ""
    #XOA_PASSWORD = ""
    #public_key_ansible = ""
    #public_key_admin = ""
    #username_ansible = ""
    #username_admin = ""
   ```


### Usage

1. Terraform Init
    ```sh
    terraform init
    ```

2. Terraform Plan
    ```sh
    terraform plan
    ```

3. If everything looks good, Apply
    ```sh
    terraform apply
    ```
4. The virtual machines should be deployed and you will get an output with the hostnames and IP addresses.

## Ansible

### Setup

Majority of the configuration you will have to do is inside the `var/` folder. If you need more customization you 
can edit the bind9 configuration templates in `templates/`.

You may have to consult [BIND9 documentation](https://bind.isc.org/doc/arm/9.11/Bv9ARM.ch06.html).

1. Configure `vars.yaml` file
    
    | Variable | Type | Comment |
    |---|---|---|
    | domain | string | your base domain name |
    | nameservers | list | Contains 3 variables: `hostname`, `ipv4`, `rdns_ipv4` |
    | forwarders | list | List of forward lookup DNS servers. |
    | ttl | number | Default ttl for zone files |
    | soa_serial | number | SOA Serial for zone files |
    | soa_retry | number | SOA Retry for zone files |
    | soa_expire | number | SOA Expire for zone files |
    | soa_minimum | number | SOA Minimum for zone files |
    | admin_email | string | SOA admin email. Fine to leave as admin. |

2. Configure `zones.yaml` file
    
    The `zones.yaml` file contains a single list called `zones`. Each zone should be defined with the following variables.

    | Variable | Type | Comment |
    |---|---|---|
    | domain | string | Base domain name |
    | bind9allowupdate | list | List of BIND9 allow-update parameters |
    | bind9allowtransfer | list | List of BIND9 allow-transfer parameters |

3. Configure `keys.yaml` file
    
    The `keys.yaml` file contains a single list called `keys`. Each zone should be defined with the following variables.

    | Variable | Type | Comment |
    |---|---|---|
    | name | string | Key name |
    | algorithm | string | Algorithm used for key |
    | secret | string | Key secret |

4. Create records files for each zone you added to `zones.yaml`
    
    ```sh
    cp records.example.yaml records.EXAMPLE.COM.yaml
    ```
    Repeat for each of your zones.

5. Modify each zone record file you created
    
    The `records.EXAMPLE.COM.yaml` file contains a single list called `records`. Create a list entry for each of your zone records.

    Set the `# BASE DOMAIN: example.com` comment for your records. Not evaluated.

    | Variable | Type | Comment |
    |---|---|---|
    | host | string | Hostname in your zone. Do not include NS records. Do not use FQDN. |
    | type | string | Record type for your entry |
    | value | string | Value of your record |
    | record_state | [state](https://docs.ansible.com/ansible/latest/user_guide/playbooks_intro.html#desired-state-and-idempotency) | Default: `present`. To remove a record, set to `absent`. |

6. Advanced Configuration

    If you need additional configuration not managed by my Ansible variables, files in `templates/` can be modified.



### Usage

```sh
ansible-playbook main.yaml -i YOUR_HOSTS_FILE.yaml 
```