# Unit 02 — Explain virtual network service endpoints

**BlueHarbor chapter:** Restrict Manufacturing archive access to Azure Storage  
**Status:** NOT STARTED

Use:

```text
bhi-vnet-mfg-aue
  snet-mfg-data 10.20.2.0/24
        |
Microsoft.Storage service endpoint
        |
Manufacturing archive Storage
```

A service endpoint does not create a private service NIC/IP. It extends the subnet identity to the supported Azure service so service-side network rules can trust the approved subnet.

Add a Storage service endpoint policy where the current Azure service/API supports the intended restriction to BlueHarbor-approved Storage resources.

## Secured-hub routing exception

By Module 7, private workload Internet egress is normally controlled through the secured Virtual WAN/Azure Firewall architecture.

Storage service-endpoint traffic from `snet-mfg-data` is an **intentional exception**:

```text
snet-mfg-data
 -> service endpoint route
 -> Azure Storage
```

Do not claim that this flow traverses Azure Firewall.

Security controls for this path are:

```text
service endpoint
service endpoint policy
Storage network/VNet rule
```

Decision rule:

```text
approved subnet identity + service-side restriction -> Service Endpoint
private IP representing target service              -> Private Endpoint
```
