# Unit 06 — Connect remote resources by using Azure Virtual WANs

**BlueHarbor chapter:** Scale beyond individually managed hybrid relationships  
**Status:** NOT STARTED

BlueHarbor now has classic VPN connectivity knowledge plus growing branch/remote-user requirements.

Virtual WAN is introduced as an evolution of the same enterprise architecture.

## Important dependency guardrail

Do not assume a workload VNet that currently uses a remote VPN Gateway through peering can also be attached to a Virtual WAN hub with no change to gateway ownership/peering settings.

Before implementation, the architecture audit must decide whether Virtual WAN:

- initially serves new branches/spokes alongside the classic VPN design;
- becomes an intentional migration target for selected existing workload VNets; or
- uses another staged coexistence pattern supported by current Azure constraints.

Any required peering/gateway change must be represented as an understood Terraform delta, not hidden by building a disconnected demo environment.
