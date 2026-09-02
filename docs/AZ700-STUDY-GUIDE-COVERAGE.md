# AZ-700 Study-Guide Coverage Matrix

**Official source:** https://learn.microsoft.com/en-us/credentials/certifications/resources/study-guides/az-700  
**Skills baseline:** effective July 27, 2026  
**BlueHarbor verification date:** September 2, 2026  
**Status:** COMPLETE — every listed objective has an intentional programme home

## How to read this file

Microsoft Learn module/unit order remains authoritative. This matrix prevents objectives that sit outside the visible Learn exercises from being silently omitted.

Coverage modes:

```text
BUILD                 persistent cumulative Terraform/Azure implementation
CONFIGURE / VALIDATE  real configuration or diagnostic work on existing resources
CONTROLLED EXPERIMENT hands-on exercise with an intentional/reconciled temporary delta
DESIGN / TROUBLESHOOT deep design/configuration/failure work where persistence would distort BlueHarbor
CONDITIONAL EXTERNAL  practical only when external/provider/ownership prerequisites exist
```

A row marked DESIGN / TROUBLESHOOT is still mandatory learning. It is not permission to skip the objective.

---

# 1. Design and implement core networking infrastructure

## IP addressing for Azure resources

| Study-guide capability | Primary programme home | Mode | BlueHarbor treatment |
|---|---|---|---|
| Network segmentation and address-space planning | M1 U02, U04 | BUILD | Freeze and deploy the canonical non-overlapping Core/Mfg/Research address plan; later modules extend reserved ranges deliberately. |
| Create virtual networks | M1 U04 | BUILD | Build the three foundation VNets in the single Terraform state. |
| Subnet services correctly: gateways, PEs, service endpoints, firewalls, App Gateway, integrated PaaS, Bastion | M1 U02 plus M2/M5/M6/M7 | BUILD + DESIGN | Teach subnet-purpose rules early; implement each dedicated/service subnet only when its story requirement arrives. |
| Configure subnet delegation | M7 U06 | BUILD | Delegate `snet-appsvc-integration` to the current App Service integration service. |
| Choose shared versus dedicated subnets | M1 U02; reinforced M5–M7 | DESIGN / VALIDATE | Explain which workloads may share and why Gateway/AppGW/DNS Resolver/App Service integration/PLS subnets are dedicated. |
| Create a Public IP Prefix | M1 U03 extension; revisit M4 | CONTROLLED EXPERIMENT | Learn/create against a real public-service scenario only if it adds value; do not invent a throwaway production dependency. |
| Decide when Public IP Prefix is appropriate | M1 U03 extension | DESIGN / TROUBLESHOOT | Compare allow-listing, contiguous allocation and scale needs with individual Standard public IPs. |
| Plan/implement Custom IP Prefix (BYOIP) | M1 U03 extension | CONDITIONAL EXTERNAL | Requires an owned/validated public prefix; otherwise perform lifecycle/RIR/validation/design analysis without fake ownership. |
| Create a public IP | M2 U03, M4 U04, M5 U04 | BUILD | Real gateway, Load Balancer and Application Gateway public IPs appear when required by the story. |
| Associate public IPs to resources | M2 U03, M4 U04, M5 U04 | BUILD / VALIDATE | Associate and independently inspect the real service frontends. |

## Name resolution

| Study-guide capability | Primary programme home | Mode | BlueHarbor treatment |
|---|---|---|---|
| Design VNet-internal name resolution | M1 U05 | BUILD / DESIGN | Establish `blueharbor.internal` and the Azure/private-DNS mental model. |
| Configure VNet DNS settings | M1 U06; M2 U04 | BUILD | Configure the intended DNS path; later extend it with Core DNS Private Resolver for hybrid resolution. |
| Design public DNS zones | M1 U05 extension; M5 | DESIGN / TROUBLESHOOT | Use the Partner Hub public-name requirement; do not pretend `.example` is a delegated real domain. |
| Design private DNS zones | M1 U05/U06 | BUILD | Use `blueharbor.internal`; add Microsoft service-owned Private Link zones in M7. |
| Configure public and private DNS zones | M1 U06; M7 U04 | BUILD + CONDITIONAL EXTERNAL | Private zones are real; public-zone delegation is hands-on only when a real learner-controlled domain exists. |
| Link a private DNS zone to a VNet | M1 U06; M7 U04 | BUILD | Link required VNets and extend links as the estate grows. |
| Design and implement Azure DNS Private Resolver | M1 U05 concept; M2 U04 implementation | BUILD | Deploy inbound/outbound resolver endpoints in Core when Brisbane hybrid DNS becomes a real requirement. |

## VNet connectivity and routing

| Study-guide capability | Primary programme home | Mode | BlueHarbor treatment |
|---|---|---|---|
| Service chaining and gateway transit | M1 U07/U09; M2 U03 | BUILD / VALIDATE | Learn non-transitivity; configure classic gateway transit before Virtual WAN becomes production transit. |
| Implement VNet peering | M1 U07/U08 | BUILD | Core↔Mfg and Core↔Research peering stages are real; M6 later retires them when they bypass inspection. |
| Manage VNet connectivity with Azure Virtual Network Manager | M1 U09 extension; M6 U05 extension | CONTROLLED EXPERIMENT | Exercise AVNM network groups/connectivity concepts against existing VNets without leaving connectivity that conflicts with later Virtual WAN secured transit. |
| Design/implement UDRs | M1 U09 | BUILD | Create deliberate route-table logic on normal workload subnets only. |
| Associate route tables with subnets | M1 U09 | BUILD / VALIDATE | Attach only where architecturally appropriate; special-purpose subnets are excluded from blanket loops. |
| Configure forced tunneling | M1 U09 concept; M6 U09 production | CONFIGURE / VALIDATE | Learn default-route behaviour early; secured-hub routing intent/firewall egress becomes the production security implementation later. |
| Diagnose routing problems | M1 U09; M3 U10; M8 U04 | CONFIGURE / VALIDATE | Effective routes, next hop, BGP and path evidence are mandatory troubleshooting tools. |
| Design and implement Azure Route Server | M1 U09 study-guide extension | DESIGN / TROUBLESHOOT | Learn BGP/NVA use cases deeply. Do not deploy Route Server inside a VNet that will be/has been connected to Virtual WAN; current Azure does not support that combination. |
| Choose NAT Gateway use cases | M1 U10 | DESIGN / BUILD | Distinguish outbound SNAT from unsolicited inbound access and from firewall egress. |
| Implement NAT Gateway | M1 U10; M4/M5 reuse | BUILD | `nat-mfg-aue`, later SEA telemetry/Partner NAT stages, then intentional Partner NAT retirement in M6. |

## Monitor networks

| Study-guide capability | Primary programme home | Mode | BlueHarbor treatment |
|---|---|---|---|
| Configure Network Watcher diagnostics/logging | M8 U02/U04 | BUILD / CONFIGURE | Reconcile auto-created regional Network Watchers, then configure real diagnostics. |
| Monitor/troubleshoot with Network Watcher | M8 U04 | CONFIGURE / VALIDATE | Connection Monitor, IP Flow Verify/effective rules, next hop, flow logs and packet capture escalation. |
| Monitor/troubleshoot with Azure Monitor for Networks / Network Insights | M8 U02/U04 | CONFIGURE / VALIDATE | Use topology/health over the complete BlueHarbor estate. |
| Activate and monitor DDoS protection | M6 U03/U04; M8 | BUILD / VALIDATE | Protect eligible VNet public-IP resources, then monitor relevant attack/mitigation signals. |
| Review Defender for Cloud Secure Score network recommendations | M6 U02 | CONFIGURE / VALIDATE | Use real posture recommendations before enforcement changes. |
| Review Defender attack-path analysis | M6 U02 | CONFIGURE / VALIDATE | Identify relevant attack paths against the cumulative estate. |
| Use Cloud Security Explorer for network-resource investigation | M6 U02 | CONFIGURE / VALIDATE | Query real BlueHarbor resources/security context where available. |

---

# 2. Design, implement, and manage connectivity services

## Site-to-site VPN

| Study-guide capability | Primary programme home | Mode | BlueHarbor treatment |
|---|---|---|---|
| Design HA S2S VPN | M2 U02/U04 | DESIGN / BUILD | Compare active-active/zone-resilient options and build the approved first hybrid edge. |
| Select VPN gateway SKU for S2S | M2 U02 | DESIGN | Size against throughput, tunnel, zone and feature requirements. |
| Implement S2S VPN | M2 U04 | BUILD | Brisbane first; Perth becomes the scale trigger for Virtual WAN. |
| Policy-based versus route-based VPN | M2 U02/U04 | DESIGN / TROUBLESHOOT | Explain compatibility and choose route-based for the cumulative architecture. |
| Create/configure Local Network Gateway | M2 U04 | BUILD | Model Brisbane external prefixes/device boundary honestly. |
| Configure IPsec/IKE policy | M2 U04 | CONFIGURE / VALIDATE | Use explicit policy parameters where the scenario requires them and troubleshoot mismatches. |
| Create/configure Virtual Network Gateway | M2 U03 | BUILD | Classic gateway in `bhi-vnet-connectivity-aue` is the first hybrid stage. |
| Diagnose gateway connectivity issues | M2 U04; M8 | CONFIGURE / VALIDATE | Tunnel, IKE/IPsec, route and gateway-health troubleshooting. |
| Implement Azure Extended Network | M2 U04 study-guide extension | CONDITIONAL EXTERNAL | Teach subnet-extension use cases, constraints and failure model; hands-on only when required Windows/WAC prerequisites are practical. |

## Point-to-site VPN

| Study-guide capability | Primary programme home | Mode | BlueHarbor treatment |
|---|---|---|---|
| Select gateway SKU for P2S | M2 U05 | DESIGN | Match scale/protocol/authentication requirements. |
| Select/configure tunnel type | M2 U05 | CONFIGURE / VALIDATE | Compare OpenVPN/IKEv2/SSTP support and select the scenario-appropriate option. |
| Select authentication method | M2 U05 | DESIGN | Certificates, RADIUS and Microsoft Entra ID trade-offs. |
| Configure RADIUS authentication | M2 U05 extension | CONDITIONAL EXTERNAL | Hands-on only with a real RADIUS/NPS dependency; otherwise configuration and troubleshooting analysis. |
| Configure Microsoft Entra ID authentication | M2 U05 extension | CONFIGURE / VALIDATE | Use the real tenant where supported by chosen P2S model. |
| Generate/use VPN client configuration | M2 U05 | CONFIGURE / VALIDATE | Build/import the real client profile and inspect routes/DNS. |
| Troubleshoot client/authentication failures | M2 U05 | CONFIGURE / VALIDATE | Deliberate auth/route/DNS failures and evidence-led recovery. |
| Specify Always On VPN Azure requirements | M2 U05 extension | DESIGN / TROUBLESHOOT | Map Azure gateway/auth/client prerequisites without pretending device-management infrastructure exists. |
| Specify Azure Network Adapter requirements | M2 U05 extension | CONDITIONAL EXTERNAL | Cover Windows Admin Center/Azure requirements and use hands-on only when prerequisites are available. |

## ExpressRoute

| Study-guide capability | Primary programme home | Mode | BlueHarbor treatment |
|---|---|---|---|
| Choose ExpressRoute connectivity model | M3 U02/U03 | DESIGN | Provider versus ExpressRoute Direct ownership and dependency model. |
| Select ExpressRoute SKU/tier | M3 U03 | DESIGN | Bandwidth, Local/Standard/Premium reach and feature implications. |
| Design ER for cross-region, redundancy and DR | M3 U03/U07 | DESIGN / TROUBLESHOOT | Use Brisbane/Perth and provider diversity/failure domains. |
| Global Reach / FastPath / ExpressRoute Direct options | M3 U03/U08/U09 | CONFIGURE + CONDITIONAL EXTERNAL | Global Reach uses two circuit paths; FastPath eligibility is exact; Direct-specific functions are conditional. |
| Choose private peering, Microsoft peering or both | M3 U06 | DESIGN | Select by destination/service requirements. |
| Configure private peering | M3 U06 | CONDITIONAL EXTERNAL | Perform real BGP/private peering where provider-side circuit state permits. |
| Configure Microsoft peering | M3 U06 extension | CONDITIONAL EXTERNAL | Requires validated public prefixes/appropriate routing prerequisites; do not fake them. |
| Create/configure ExpressRoute gateway | M3 U04 | BUILD | Persistent BlueHarbor implementation uses the existing AUE Virtual WAN ExpressRoute gateway. |
| Connect a VNet to an ExpressRoute circuit | M3 U04 | DESIGN / TROUBLESHOOT | Learn the classic VNet-gateway connection model; persistent BlueHarbor reaches VNets through Virtual WAN so it does not fork into a second transit design. |
| Recommend route advertisement | M3 U06/U07 | DESIGN / VALIDATE | BGP prefix advertisement, preference and failover analysis. |
| Configure encryption over ExpressRoute | M3 U07 extension | CONDITIONAL EXTERNAL | Cover IPsec-over-ER and Direct/MACsec scenarios according to actual connectivity model. |
| Implement BFD | M3 U07 extension | CONDITIONAL EXTERNAL | Configure/validate only when the provider/circuit model exposes the required peering dependency. |
| Diagnose ExpressRoute issues | M3 U10 | CONFIGURE / VALIDATE | Circuit/provider/peering/BGP/gateway/hub/route troubleshooting chain. |

## Azure Virtual WAN

| Study-guide capability | Primary programme home | Mode | BlueHarbor treatment |
|---|---|---|---|
| Select Virtual WAN SKU | M2 U06 | BUILD / DESIGN | Standard is required by the cumulative VPN/ER/security design. |
| Design Virtual WAN types/services | M2 U06 | DESIGN | Hub, S2S, User VPN, ER, routing and later secured-hub model. |
| Create virtual hub | M2 U07; M5 U05 SEA expansion | BUILD | AUE first, then SEA when multi-region Partner Hub requires it. |
| Choose gateway scale units | M2 U06/U07; M3 U04/U09 | DESIGN / BUILD | Size VPN/User VPN/ER gateways; FastPath-specific ER minimum is documented explicitly. |
| Deploy gateway into virtual hub | M2 U07; M3 U04 | BUILD | VPN/User VPN/ER gateway stages use the same vWAN. |
| Configure virtual-hub routing | M2 U07; M6 U09 | BUILD / VALIDATE | Production transit first, then secured-hub routing intent. |
| Integrate third-party NVA in virtual hub | M2 U08 | CONDITIONAL EXTERNAL | Real deployment only with supported/licensed NVA; otherwise full routing/control-plane/failure analysis in the same hub. |

---

# 3. Design and implement application delivery services

## Azure Load Balancer and Traffic Manager

| Study-guide capability | Primary programme home | Mode | BlueHarbor treatment |
|---|---|---|---|
| Map Load Balancer requirements to capabilities | M4 U02 | DESIGN | Layer 4, health, HA ports, frontend/backend concepts. |
| Choose Load Balancer use cases | M4 U02 | DESIGN | Distinguish from App Gateway, Front Door and Traffic Manager. |
| Select Load Balancer SKU/tier | M4 U02/U03 | DESIGN | Standard public LB is canonical; compare tier implications. |
| Public versus internal Load Balancer | M4 U02 | DESIGN / CONTROLLED EXPERIMENT | Public telemetry is built; internal-LB selection is exercised against private-use scenarios without creating a second production app. |
| Regional versus cross-region Load Balancer | M4 U02/U05 | DESIGN / TROUBLESHOOT | Regional LBs are real; compare cross-region LB with the chosen Traffic Manager global pattern. |
| Create/configure Load Balancer | M4 U04 | BUILD | AUE telemetry Standard public LB; SEA follows for DR. |
| Implement Traffic Manager | M4 U05/U06 | BUILD | Priority DNS failover AUE→SEA. |
| Implement Gateway Load Balancer | M4 U03 study-guide extension | CONDITIONAL EXTERNAL | Deep service-chaining/NVA design; hands-on only if a real supported NVA insertion scenario is justified. |
| Configure LB rule | M4 U04 | BUILD | TCP/9000 rule and probe. |
| Configure inbound NAT rules | M4 U03/U04 extension | CONTROLLED EXPERIMENT | Exercise a safe backend-specific NAT rule, then intentionally remove it if it is not part of the approved security model. |
| Configure explicit outbound rules/SNAT | M4 U03/U04 extension | CONTROLLED EXPERIMENT | Configure/compare Standard LB outbound rules with canonical NAT Gateway egress; final architecture retains NAT Gateway where approved. |

## Azure Application Gateway

| Study-guide capability | Primary programme home | Mode | BlueHarbor treatment |
|---|---|---|---|
| Map App Gateway requirements to capabilities | M5 U02 | DESIGN | Regional L7, host/path/TLS/health decisions. |
| Choose App Gateway use cases | M5 U02 | DESIGN | Contrast with Load Balancer and Front Door. |
| Manual versus autoscale sizing | M5 U02 | DESIGN / BUILD | Compare both and choose the v2 scaling model appropriate to Partner Hub. |
| Create backend pools | M5 U03/U04 | BUILD | Engineering/Orders/Support backends. |
| Configure health probes | M5 U03/U04 | BUILD / TROUBLESHOOT | Custom health-path/host failures are deliberate exercises. |
| Configure listeners | M5 U03/U04 | BUILD | Real Partner Hub HTTP(S) listener model using reachable lab hostnames. |
| Configure routing rules | M5 U03/U04 | BUILD | Path-based `/engineering`, `/orders`, `/support`. |
| Configure HTTP settings | M5 U03/U04 | BUILD / VALIDATE | Host, protocol, port, probe and backend behaviour. |
| Configure TLS | M5 U03/U04; M7 U06 | CONFIGURE / CONDITIONAL EXTERNAL | Teach termination and end-to-end TLS honestly; trusted-domain origin TLS is conditional on a real domain/certificate. |
| Configure rewrite-rule sets | M5 U03/U04 extension | CONFIGURE / VALIDATE | Add at least one explainable request/response rewrite against Partner Hub. |

## Azure Front Door

| Study-guide capability | Primary programme home | Mode | BlueHarbor treatment |
|---|---|---|---|
| Map Front Door requirements to capabilities | M5 U05 | DESIGN | Global L7 edge/proxy versus DNS steering. |
| Choose Front Door use cases | M5 U05 | DESIGN | Partner Hub global delivery is the real use case. |
| Select Front Door tier | M5 U05; M6 U10 | BUILD / DESIGN | Standard first for delivery; Premium later for managed WAF/private-origin requirements. |
| Configure routes, origins and endpoints | M5 U06 | BUILD | AUE/SEA App Gateway origins and real route/health behaviour. |
| TLS termination and end-to-end TLS | M5 U05/U06; M7 U06 | CONFIGURE / CONDITIONAL EXTERNAL | Client→Front Door TLS is real; Front Door→AppGW HTTPS requires a trusted chain/name. Private-Link AppGW origin validation remains mandatory. |
| Configure caching | M5 U05/U06 extension | CONFIGURE / VALIDATE | Apply caching only to a safe Partner Hub path/content class and prove cache behaviour. |
| Configure traffic acceleration | M5 U05/U06 extension | CONFIGURE / VALIDATE | Explain/observe Front Door global edge and Microsoft backbone acceleration against the real application. |
| Rules, URL rewrite and redirect | M5 U05/U06 extension | CONFIGURE / VALIDATE | Configure at least one real rules-engine rewrite/redirect tied to Partner Hub behaviour. |
| Secure origin with Front Door Private Link | M7 U06 | BUILD / CONDITIONAL TLS | Migrate Premium to Private-Link-enabled AUE/SEA App Gateway origins; protocol/TLS guardrail is explicit. |

---

# 4. Design and implement private access to Azure services

## Private Link Service and Private Endpoints

| Study-guide capability | Primary programme home | Mode | BlueHarbor treatment |
|---|---|---|---|
| Plan private endpoints | M7 U03/U04 | DESIGN / BUILD | Dedicated Core/Partner PE subnets, DNS and secured-vWAN route implications. |
| Create private endpoints | M7 U03/U06 | BUILD | Core consumer PE for telemetry PLS; Partner SQL/App Service PEs. |
| Configure access to private endpoints | M7 U04/U06 | BUILD / VALIDATE | DNS, NSG/network-policy/route and public-access retirement. |
| Create Private Link Service | M7 U03 | BUILD | Publish existing `lb-telemetry-aue` through `pls-telemetry-aue`. |
| Integrate Private Link/PE with DNS | M7 U04 | BUILD | Microsoft private zones plus `blueharbor.internal` consumer record. |
| Integrate Private Link Service with on-prem clients | M7 U03/U04/U06 | CONFIGURE / VALIDATE | Brisbane/Perth resolve and route to Core consumer PE through existing hybrid architecture. |

## Service endpoints

| Study-guide capability | Primary programme home | Mode | BlueHarbor treatment |
|---|---|---|---|
| Choose service endpoint use case | M7 U02 | DESIGN | Manufacturing Storage uses subnet identity rather than a private service IP. |
| Create service endpoints | M7 U05 | BUILD | `Microsoft.Storage` on `snet-mfg-data`. |
| Configure service endpoint policies | M7 U05 | BUILD / VALIDATE | Restrict to the approved Storage resource where current service/API supports it. |
| Configure access to service endpoints | M7 U05 | BUILD / VALIDATE | Storage network/VNet rules; prove approved versus unapproved source. |

---

# 5. Design and implement Azure network security services

## Network security groups / virtual-network security

| Study-guide capability | Primary programme home | Mode | BlueHarbor treatment |
|---|---|---|---|
| Create NSG | M4 U04; M6 U05 | BUILD | Minimal functional telemetry policy first, then deliberate security hardening. |
| Associate NSG with subnet or NIC | M4 U04; M6 U05 | BUILD / VALIDATE | Choose scope intentionally and inspect effective rules. |
| Create ASG | M6 U05 | BUILD | `asg-mfg-app` and `asg-mfg-data`. |
| Associate ASG to NIC | M6 U05 | BUILD | Real Manufacturing workload identities. |
| Configure NSG inbound/outbound rules | M6 U05 | BUILD / TROUBLESHOOT | Least-required rules plus a deliberate priority-conflict exercise. |
| Implement VNet flow logs | M8 U02/U04 | BUILD | Flow logs on all six BlueHarbor VNets; no new NSG flow logs. |
| Interpret VNet flow logs | M8 U04/U05 | CONFIGURE / VALIDATE | Traffic Analytics and incident investigation. |
| Verify IP flow | M6 U05; M8 U04 | CONFIGURE / VALIDATE | Use current Network Watcher/effective-rule tooling on real flows. |
| Secure remote administration including Azure Bastion | M6 U05 extension | DESIGN / CONTROLLED EXPERIMENT | Design NSG + Bastion administration pattern; deploy only if the chosen cumulative management path justifies the dedicated Bastion subnet/tier. |
| Manage network security with Azure Virtual Network Manager | M6 U05 extension | CONTROLLED EXPERIMENT | Exercise network groups/security-admin policy against existing VNets without creating rules that bypass/contradict Azure Firewall intent. |

## Azure Firewall and Firewall Manager

| Study-guide capability | Primary programme home | Mode | BlueHarbor treatment |
|---|---|---|---|
| Map requirements to Azure Firewall capabilities | M6 U06 | DESIGN | L3–L7 central routed enforcement versus NSG/WAF/DDoS. |
| Select Firewall SKU | M6 U06 | DESIGN | Choose against TLS inspection/threat intelligence/performance requirements at execution time. |
| Design Firewall deployment | M6 U06 | DESIGN | Existing Virtual WAN secured hubs, not a parallel hub VNet. |
| Create/implement Firewall | M6 U07/U09 | BUILD | AUE first, SEA second in the existing hubs. |
| Configure Firewall rules | M6 U07/U09 | BUILD / TROUBLESHOOT | Prove allow, deny and wrong-path behaviour. |
| Create/manage Firewall Manager policy | M6 U08/U09 | BUILD | `fwpol-bhi-global` governs both regional firewalls. |
| Create secured Virtual WAN hub with Firewall | M6 U09 | BUILD | Both existing `/22` hubs evolve into the approved secured-hub model. |

## Web Application Firewall

| Study-guide capability | Primary programme home | Mode | BlueHarbor treatment |
|---|---|---|---|
| Map requirements to WAF capabilities | M6 U10 | DESIGN | HTTP(S) request protection distinct from DDoS/Firewall/NSG. |
| Design WAF deployment | M6 U10 | DESIGN | Edge Front Door WAF plus regional App Gateway WAF boundaries. |
| Detection versus prevention mode | M6 U10 | CONFIGURE / VALIDATE | Start/tune in Detection where useful, then prove Prevention intent. |
| Front Door WAF rule sets | M6 U10 | BUILD / VALIDATE | Premium managed rules on Partner Hub edge. |
| Application Gateway WAF rule sets | M6 U10 | BUILD / VALIDATE | Regional WAF_v2 policies. |
| Implement WAF policy | M6 U10 | BUILD | Terraform-managed edge/regional policies. |
| Associate WAF policy | M6 U10 | BUILD / VALIDATE | Attach to actual Front Door/App Gateway resources and prove enforcement. |

---

# Cross-objective guardrails discovered during final QA

## Azure Route Server versus Virtual WAN

Current Azure does not support an Azure Route Server inside a spoke VNet that is connected to a Virtual WAN hub. Therefore the Route Server objective is mandatory design/troubleshooting coverage but is not allowed to silently appear inside Core/Manufacturing/Research/Partner once those VNets join Virtual WAN.

## ExpressRoute Global Reach versus secured-hub inspection

Module 3 uses Global Reach to teach direct circuit-to-circuit connectivity between Brisbane and Perth. Module 6 later requires centrally inspected private transit. Global Reach must then be disabled because it sends ER-to-ER traffic directly rather than through the Virtual WAN security appliance. If BlueHarbor requires ER-to-ER transit through the secured hub, use the current supported routing-intent/security-solution process, including any Microsoft support prerequisite that exists at implementation time.

## FastPath in Virtual WAN

The current BlueHarbor rule is exact:

```text
Virtual WAN FastPath
 -> ExpressRoute Direct circuit
 -> Virtual WAN ExpressRoute Gateway >= 5 scale units
 -> automatically enabled for supported traffic
```

Provider circuits can support FastPath in classic VNet-gateway scenarios, but **not FastPath in Virtual WAN** under the current support matrix.

## Front Door Private Link to Application Gateway and TLS

For a Private-Link-enabled Application Gateway origin, Front Door certificate subject-name validation is mandatory. `portal.blueharbor.example` is narrative-only and cannot be treated as a real trusted public certificate identity.

Baseline lab:

```text
client -> HTTPS -> Front Door
Front Door -> App Gateway private origin using the supported lab origin protocol
```

If no real trusted domain/certificate is supplied, do not claim end-to-end TLS. When the learner supplies a real domain and trusted certificate chain whose subject matches the configured origin hostname, enable and validate Front Door -> Application Gateway HTTPS as the end-to-end TLS practical.

---

# Coverage verdict

```text
Microsoft Learn ordering                 PRESERVED
July 27 2026 study-guide objectives      MAPPED
Persistent architecture                  NOT BLOATED FOR TICK-BOX COVERAGE
External prerequisites                   EXPLICIT
Unsupported combinations                 GUARDED
CURRENT COVERAGE STATUS                  COMPLETE
```
