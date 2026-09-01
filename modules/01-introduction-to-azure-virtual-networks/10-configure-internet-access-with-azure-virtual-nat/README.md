# Unit 10 — Configure internet access with Azure Virtual NAT

## BlueHarbor chapter: Private Manufacturing workloads need a controlled Internet exit

Manufacturing workloads need outbound Internet access for approved updates and services, but Security does not want individual public IP addresses on the VMs.

NAT Gateway becomes the managed subnet-level outbound solution.

## Canonical BlueHarbor implementation contract

The Module 1 Terraform environment must finish this unit with an explicit NAT Gateway association on the existing Manufacturing application subnet:

```text
bhi-vnet-mfg-aue
  |
  +-- snet-mfg-app   10.20.1.0/24
         |
         +-- nat-mfg-aue
                |
                +-- explicit public IP / public IP resource
```

The exact public-IP implementation is validated against the current AzureRM provider when the unit is built, but the architectural contract is fixed: `snet-mfg-app` has explicit NAT-managed outbound connectivity.

Do not attach NAT blindly to every subnet. Special-purpose subnets and subnets with different outbound requirements are handled deliberately.

## Key lesson

```text
outbound Internet access
!=
unsolicited inbound access
```

This NAT association remains deployed and is reused by later Manufacturing workloads, including the Module 4 Australia East telemetry backends.

**Status:** NOT STARTED.
