# Unit 02 — Design and implement Azure VPN Gateway

**BlueHarbor chapter:** Add a dedicated Azure hybrid-network edge  
**Status:** NOT STARTED

## Starting state

The Module 1 workload VNets, DNS, peerings, routes and selected NAT configuration already exist in the cumulative Terraform state.

## Business event

Management approves encrypted Internet-based connectivity between BlueHarbor sites and Azure.

## Architecture introduced

```text
bhi-vnet-connectivity-aue   10.100.0.0/16
  snet-dns-inbound          10.100.10.0/28
  snet-dns-outbound         10.100.10.16/28
  GatewaySubnet             10.100.255.0/26
```

The VPN Gateway will terminate in this dedicated connectivity VNet rather than a workload VNet.

## Concepts to master

- `GatewaySubnet`
- Azure VPN Gateway
- gateway SKU / public IP
- route-based versus policy-based concepts
- availability / active-active considerations
- throughput / resiliency
- non-overlapping address spaces
- dedicated connectivity VNet design

## Terraform rule

This unit adds to `blueharbor/terraform/`; it does not recreate `bhi-vnet-core-aue`, `bhi-vnet-mfg-aue` or `bhi-vnet-research-sea`.
