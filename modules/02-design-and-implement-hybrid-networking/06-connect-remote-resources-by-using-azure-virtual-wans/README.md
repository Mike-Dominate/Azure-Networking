# Unit 06 — Connect remote resources by using Azure Virtual WANs

**BlueHarbor chapter:** Scale beyond individually managed hybrid relationships  
**Status:** NOT STARTED

## Starting state

BlueHarbor already understands and has Terraform-managed classic VPN connectivity through `bhi-vnet-connectivity-aue`.

## Business event

Perth Manufacturing (`172.17.0.0/16`) now needs connectivity, remote-user demand is growing and future branches are expected. This is the first point where branch scale makes the classic relationship model operationally awkward.

## Architecture introduced

```text
bhi-vwan
  |
  +-- bhi-vhub-aue   10.200.0.0/22
```

Reserve for future use:

```text
bhi-vhub-sea   10.200.4.0/22
```

## Critical progression

Perth becomes a real branch in the story here; it must not appear magically in Module 3.

Virtual WAN is an evolution of the same estate, not a disconnected exercise.

## Migration guardrail

A workload VNet that currently uses the classic remote VPN gateway through peering must not simply be assumed to use the Virtual WAN hub simultaneously with no configuration change.

Unit 07 will intentionally migrate gateway ownership by changing the appropriate classic remote-gateway peering settings and adding Virtual Hub VNet connections.

The existing classic VPN resources remain in Terraform as the earlier stage.
