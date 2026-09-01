# Lab 01 — Terraform Rebuild

## Purpose

Rebuild the understood Azure Load Balancer architecture as Infrastructure as Code.

## Learning rule

Terraform is introduced incrementally. Do not paste a finished configuration before the Azure relationships are understood.

## Planned file structure

```text
terraform/
├── README.md
├── versions.tf
├── providers.tf
├── variables.tf
├── main.tf
├── outputs.tf
└── terraform.tfvars.example
```

## Expected Terraform progression

1. Terraform/provider requirements
2. Azure provider configuration
3. Resource group
4. Virtual network
5. Subnet
6. NSG and security rules
7. NICs
8. Linux backend VMs and bootstrap/web content
9. Standard public IP
10. Standard Load Balancer frontend
11. Backend pool
12. Backend associations
13. Health probe
14. Load-balancing rule
15. Outputs

## Standard commands

```bash
terraform fmt -recursive
terraform init
terraform validate
terraform plan
terraform apply
```

When finished:

```bash
terraform destroy
```

## Validation principle

A successful `terraform apply` is not sufficient. Query Azure independently with Azure CLI and perform real HTTP traffic tests.
