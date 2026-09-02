# Unit 03 — Configure public IP services

**BlueHarbor chapter:** Understand exposure before creating a public endpoint  
**Status:** NOT STARTED

Operations needs the network engineer to understand how Azure public addressing works before BlueHarbor exposes any production service.

Cover:

- public versus private addressing;
- static versus dynamic allocation where applicable;
- SKU/availability implications;
- resource association/lifecycle;
- inbound exposure versus outbound connectivity;
- why a public IP is not itself a complete security policy.

## Lifecycle decision

Do **not** create a throwaway persistent public endpoint in this concept unit.

The first persistent Terraform checkpoint remains Unit 04. Public IP resources will be created later when the cumulative story genuinely requires them for VPN gateways, public Load Balancers and Application Gateways.
