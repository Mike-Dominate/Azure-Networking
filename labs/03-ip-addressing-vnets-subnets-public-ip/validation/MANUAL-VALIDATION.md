# Lab 03 Manual Validation Checkpoint

Manual Azure build validation completed on 2026-08-31.

## Subnet inventory

```text
snet-web             10.30.10.0/26   Succeeded
snet-app             10.30.20.0/27   Succeeded
snet-db              10.30.30.0/27   Succeeded
snet-management      10.30.40.0/28   Succeeded
GatewaySubnet        10.30.100.0/27  Succeeded
AzureFirewallSubnet  10.30.101.0/26  Succeeded
AzureBastionSubnet   10.30.102.0/26  Succeeded
snet-postgres        10.30.50.0/27   Succeeded  Microsoft.DBforPostgreSQL/flexibleServers
```

## Top-level resource inventory

```text
vnet-az700-ip-aue
nic-lab03-web-dynamic
nic-lab03-app-static
pip-lab03-web-aue
pip-lab03-zr-aue
pipprefix-lab03-aue
pip-lab03-from-prefix-aue
```

## Private IP validation

```text
nic-lab03-web-dynamic  10.30.10.4   Dynamic
nic-lab03-app-static   10.30.20.10  Static
```

## Public IP validation

```text
pip-lab03-web-aue          4.196.200.103   Standard / Regional / Static / zones null
pip-lab03-zr-aue           20.227.26.52    Standard / Regional / Static / zones 1,2,3
pipprefix-lab03-aue        4.237.111.112/30 Standard / Regional / zones 1,2,3
pip-lab03-from-prefix-aue  4.237.111.112   allocated from pipprefix-lab03-aue / zones 1,2,3
```

## Portal validation

Portal inspection confirmed:

```text
snet-web         58 available IPs
snet-app         26 available IPs
snet-db          27 available IPs
snet-management  11 available IPs
```

The available-IP counts matched expected Azure-reserved address behavior plus actual NIC consumption.

## Manual-phase status

```text
Address plan                 COMPLETE
Manual Azure CLI build       COMPLETE
Independent CLI validation   COMPLETE
Failure testing              COMPLETE
Portal inspection            COMPLETE
Manual teardown              PENDING
Terraform rebuild            NOT STARTED
```
