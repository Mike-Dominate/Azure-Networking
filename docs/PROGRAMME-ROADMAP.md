# Programme Roadmap

## Purpose

Build real Azure networking engineering capability while maintaining full coverage of the current Microsoft AZ-700 skills measured outline.

This programme is **not certification-cramming**. The exam blueprint defines the coverage boundary; our labs go deeper through manual Azure CLI implementation, visual mental models, Terraform, troubleshooting, failure testing, Git/GitHub, rebuild documentation and safe teardown.

## Coverage authority

- **Primary coverage authority:** Microsoft AZ-700 study guide / skills measured, effective July 27, 2026.
- **Learning reference:** `rithinskaria/kodekloud-az700`.
- **Secondary comparison/reference:** other current AZ-700 lab collections may be reviewed for omissions, but are not copied blindly.

## Rebaselined lab sequence

| Lab | Topic | Primary focus | Status |
|---:|---|---|---|
| 01 | Azure Load Balancer | L4 load balancing, probes, backend pools, availability zones, explicit outbound SNAT | COMPLETE |
| 02 | Azure Traffic Manager | Global DNS traffic steering, Geographic routing, endpoint health, DNS TTL | COMPLETE |
| 03 | IP Addressing, VNets, Subnets & Public IP Architecture | Address planning, subnet design, delegation, public IPs/prefixes, BYOIP concepts | COMPLETE |
| 04 | Azure DNS, Private DNS & DNS Private Resolver | Public/private DNS, VNet links, hybrid name resolution | NOT STARTED |
| 05 | VNet Peering, Gateway Transit & Virtual Network Manager | Peering, topology, gateway transit, network groups/connectivity management | NOT STARTED |
| 06 | UDRs, Forced Tunnelling, NAT Gateway & NVA | Static routing, egress, service chaining, custom next hops | NOT STARTED |
| 07 | Azure Route Server & Dynamic Routing | BGP-based route exchange, NVA integration, dynamic routing mental model | NOT STARTED |
| 08 | Network Watcher, Azure Monitor, Flow Logs, DDoS & Defender | Diagnostics, IP flow verify, next hop, connection troubleshoot, flow visibility, protection signals | NOT STARTED |
| 09 | Site-to-Site VPN | VPN Gateway, local network gateway, IPsec/IKE, routing, HA, troubleshooting | NOT STARTED |
| 10 | Point-to-Site VPN | Remote user connectivity, tunnel types, certificates/RADIUS/Entra ID, client routing | NOT STARTED |
| 11 | ExpressRoute Architecture & BGP | Circuits, peering, redundancy, Global Reach, FastPath, Direct, routing | NOT STARTED |
| 12 | Azure Virtual WAN | Virtual hubs, routing intent, branch/transitive connectivity, NVA integration | NOT STARTED |
| 13 | Application Gateway | Layer 7 routing, probes, listeners, TLS, rewrites, backend health | NOT STARTED |
| 14 | Azure Front Door | Global edge routing, origins, routes, caching, rules, Private Link origins | NOT STARTED |
| 15 | Gateway Load Balancer & NVA Service Insertion | Transparent NVA insertion and service chaining | NOT STARTED |
| 16 | Private Endpoint, Private Link & Private DNS | Private PaaS access, DNS integration, on-premises access patterns | NOT STARTED |
| 17 | Service Endpoints & Service Endpoint Policies | Service endpoints, policy control, design trade-offs vs Private Link | NOT STARTED |
| 18 | NSG, ASG & Azure Bastion | Rule evaluation, application security groups, secure administration | NOT STARTED |
| 19 | Azure Firewall & Firewall Manager | Firewall policy, SKUs, central inspection, secure hub, policy at scale | NOT STARTED |
| 20 | Web Application Firewall | WAF policy, detection/prevention, OWASP protections, App Gateway/Front Door placement | NOT STARTED |
| 21 | Network Troubleshooting Incident Lab | DNS, NSG, route, NAT, firewall, load-balancing and application-path diagnosis | NOT STARTED |
| 22 | AZ-700 Enterprise Capstone | Multi-region hub/spoke, hybrid connectivity, private PaaS, delivery, security, monitoring, trade-offs | NOT STARTED |

## Important sequencing rule

Labs 01, 02 and 03 are complete. Lab 04 is next and remains NOT STARTED until formally begun.

## Per-lab deliverables

Each practical lab should contain, where applicable:

```text
README.md
visual-learning/
manual-deployment/
terraform/
validation/
troubleshooting/
evidence/
handoff/
```

## Required engineering learning loop

```text
Problem/use case
  -> Teach mental model
  -> Visual architecture / traffic flow
  -> Understanding check
  -> Manual Azure deployment with Azure CLI
  -> Independent validation
  -> Failure injection / troubleshooting
  -> Portal inspection where useful
  -> Terraform rebuild
  -> fmt / validate / plan / apply
  -> Independent post-IaC validation
  -> Git/GitHub checkpoint
  -> Rebuild/practice documentation
  -> Safe teardown
  -> Learner explain-back
```
