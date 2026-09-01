# Unit 07 — Enable cross-virtual network connectivity with peering

**BlueHarbor chapter:** Manufacturing needs Shared Services  
**Status:** NOT STARTED

Manufacturing needs an internal service hosted in Core/Shared Services.

Create the regional peering relationship between the existing canonical VNets:

```text
bhi-vnet-mfg-aue <-> bhi-vnet-core-aue
```

DNS can identify the destination, but separate VNets do not become connected merely because a name resolves.

```text
DNS resolution success != network connectivity success
```

The peering becomes part of the cumulative Terraform state and remains in place when Module 2 adds hybrid connectivity.
