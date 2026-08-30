# Programme Roadmap

## Purpose

Build real Azure networking engineering capability while maintaining full coverage of the current Microsoft AZ-700 skills measured outline.

This programme is **not certification-cramming**. The exam blueprint defines the coverage boundary; our labs go deeper through manual Azure CLI implementation, visual mental models, Terraform, troubleshooting, failure testing, Git/GitHub, rebuild documentation and safe teardown.

## Coverage authority

- **Primary coverage authority:** Microsoft AZ-700 study guide / skills measured, effective July 27, 2026.
- **Learning reference:** `rithinskaria/kodekloud-az700`.
- **Secondary comparison/reference:** other current AZ-700 lab collections may be reviewed for omissions, but are not copied blindly.

If Microsoft changes the AZ-700 skills outline, this roadmap must be reviewed and rebaselined before continuing blindly.

## Rebaselined lab sequence

| Lab | Topic | Primary focus | Status |
|---:|---|---|---|
| 01 | Azure Load Balancer | L4 load balancing, probes, backend pools, availability zones, explicit outbound SNAT | COMPLETE |
| 02 | Azure Traffic Manager | Global DNS traffic steering, Geographic routing, endpoint health, DNS TTL | IN PROGRESS |
| 03 | IP Addressing, VNets, Subnets & Public IP Architecture | Address planning, subnet design, delegation, public IPs/prefixes, BYOIP concepts | NOT STARTED |
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

Do **not** restart the programme because of this rebaseline.

Lab 01 remains complete. Lab 02 is now in progress. The expanded coverage begins after Lab 02.

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

Design-heavy labs such as ExpressRoute may substitute architecture simulations, route tables, BGP reasoning exercises and failure scenarios where provisioning the real service would be impractical or unnecessarily expensive.

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

## Learning depth

Every lab should develop five levels of understanding:

1. **Conceptual** — what problem does the service solve?
2. **Architectural** — where does it sit in the traffic path and what are the trade-offs?
3. **Implementation** — how is it configured directly and, where appropriate, through Terraform?
4. **Operational** — how is it validated, monitored and troubleshot?
5. **Selection** — when should it be chosen over the nearest alternative?

## Progression of independence

Early labs may be mentor-led and explicit. Over time the learner should increasingly:

- design address spaces and dependencies before seeing a solution
- predict the Azure resources required
- write Terraform before seeing complete examples
- select appropriate Azure CLI inspection commands
- reason from effective routes, DNS results, flow logs and symptoms
- diagnose deliberately broken architectures
- explain service-selection trade-offs
- improve repository documentation independently

Labs 21 and 22 should be substantially learner-driven.

## Cost and practicality rule

Full deployment is not mandatory when an Azure service is prohibitively expensive, requires provider involvement, or cannot be realistically provisioned in a personal lab subscription.

In those cases the lab must still teach:

- architecture
- configuration objects
- routing/control-plane behaviour
- validation approach
- failure modes
- troubleshooting
- exam/service-selection trade-offs

ExpressRoute is the main example.

## End-state

At the end of Lab 22, the repository should function as:

- a current AZ-700 coverage map
- an Azure networking learning journal
- a rebuild/reference library
- a Terraform implementation portfolio
- an operational troubleshooting reference
- evidence of Azure CLI, VS Code, Git and GitHub progression
- an enterprise Azure networking architecture portfolio
- a foundation for advanced Azure architecture and cloud network engineering work
