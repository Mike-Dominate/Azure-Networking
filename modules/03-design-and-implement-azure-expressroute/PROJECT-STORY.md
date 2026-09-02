# BlueHarbor Industries — Module 3 Project Story

## Project — Upgrade BlueHarbor to enterprise private connectivity

**Microsoft Learn module:** Design and implement Azure ExpressRoute  
**Status:** NOT STARTED  
**Terraform model:** extend the same cumulative `blueharbor/terraform/` state

## Starting point from Module 2

Virtual WAN is now the active BlueHarbor hybrid transit:

```text
Brisbane 172.16.0.0/16 ----\
                            \
Perth 172.17.0.0/16 --------> bhi-vhub-aue ---- Core
                             |                 Manufacturing
Remote users -------------->|                 Research
                             |
                         bhi-vwan
```

Canonical hub:

```text
bhi-vhub-aue   10.200.0.0/22
```

Reserved future hub:

```text
bhi-vhub-sea   10.200.4.0/22
```

The classic `bhi-vnet-connectivity-aue` VPN edge and its earlier Azure objects remain in Terraform as the first hybrid architecture stage.

The Module 3 question is:

> Which mission-critical paths should use private provider connectivity through ExpressRoute as the preferred path while VPN remains available as an alternate path?

---

## Chapter 01 — VPN works, so why change it?

Review critical ERP, engineering, manufacturing and shared-service requirements. Reinforce:

```text
private connectivity != automatic end-to-end encryption
```

ExpressRoute is private provider connectivity; encryption is a separate design property.

---

## Chapter 02 — Explore ExpressRoute: understand the ownership path

```text
BlueHarbor edge
  -> connectivity provider / ExpressRoute Direct boundary
  -> ExpressRoute peering location
  -> Microsoft network
  -> BlueHarbor Virtual WAN architecture
```

Explain circuit, provider, peering location and customer/Microsoft/provider responsibilities before provisioning anything.

---

## Chapter 03 — Design the ExpressRoute deployment

Design for the environment that already exists rather than inventing another hub.

Decide:

- provider/connectivity model;
- peering location;
- bandwidth;
- SKU/tier;
- `bhi-vhub-aue` ExpressRoute gateway sizing/design;
- private peering/BGP;
- redundancy/failure domains;
- VPN alternate-path strategy;
- whether ExpressRoute Direct is justified/available;
- whether the chosen model can support the FastPath objective in Unit 09.

Primary requirement:

```text
Brisbane / Perth critical traffic
        -> ExpressRoute
        -> bhi-vhub-aue
        -> existing Azure workload VNets
```

Southeast Asia remains an Azure region, not a newly invented physical office.

---

## Chapter 04 — Exercise: configure an ExpressRoute gateway

Microsoft's exercise teaches the classic model:

```text
ExpressRoute circuit
  -> VNet ExpressRoute Gateway
  -> VNet
```

BlueHarbor must understand and compare that model, but its persistent implementation extends the existing Virtual WAN architecture:

```text
ExpressRoute circuit
        |
Virtual WAN ExpressRoute Gateway
        |
bhi-vhub-aue
        |
Core / Manufacturing / Research
```

Do not create `CoreServicesVnet`, another `GatewaySubnet`, or a second transit VNet solely to mimic the exercise topology.

A successful deployment must be followed by inspection of gateway scale/SKU concepts, hub relationship and routing implications.

---

## Chapter 05 — Provision the Brisbane ExpressRoute circuit/path

Create the logical Azure circuit where practical and understand the service-key/provider handoff:

```text
Terraform creates Brisbane circuit/path A
 -> Azure service key / circuit identity
 -> provider provisioning boundary
 -> circuit provisioning state
```

Do not pretend the external carrier portion exists when it does not.

This first circuit/path is enough to establish Azure-to-site private connectivity. A second independent Perth circuit/provider path is introduced later for the Global Reach learning objective.

---

## Chapter 06 — Configure peering: routes make the private path useful

Private peering/BGP must ultimately make BlueHarbor prefixes reachable through the existing hub architecture.

On-premises examples:

```text
172.16.0.0/16  Brisbane
172.17.0.0/16  Perth
```

Azure workload prefixes include:

```text
10.10.0.0/16   Core
10.20.0.0/16   Manufacturing
10.30.0.0/16   Research
```

Mental model:

```text
transport path = road
BGP advertisements = maps describing reachable destinations
```

Trace learned routes through the Virtual WAN ExpressRoute gateway and hub router rather than through a fictional Core VNet gateway.

The current study guide also requires Microsoft peering selection/configuration knowledge. Treat Microsoft peering as an explicit conditional-external extension because it requires appropriate validated public-prefix/routing prerequisites; do not fake them.

---

## Chapter 07 — Resiliency: ExpressRoute preferred, VPN retained

BlueHarbor does not discard the VPN architecture simply because ExpressRoute exists.

Target production intent:

```text
ExpressRoute = preferred path for approved critical routes
VPN          = alternate / recovery path
```

The exact routing preference and failover configuration must be verified against current Azure Virtual WAN/ExpressRoute behaviour during implementation; do not rely on an unstated default.

Teach dual paths/BGP sessions, circuit/provider/location diversity, BFD concepts, disaster recovery and encryption-over-ExpressRoute decisions.

BFD, provider-side BGP and encryption mechanisms whose prerequisites do not exist in the lab are handled as explicit conditional-external configuration/failure work, not as claimed live state.

---

## Chapter 08 — Global Reach: add the second circuit/path and connect Brisbane to Perth

Do not invent a Singapore office.

Global Reach requires two ExpressRoute circuit/provider paths. Make that dependency explicit:

```text
Brisbane
  |
ExpressRoute circuit/provider path A
  |
Microsoft backbone / Global Reach
  |
ExpressRoute circuit/provider path B
  |
Perth Manufacturing
```

Where actual carrier circuits are unavailable, treat the provider-dependent portion as architecture/configuration/failure analysis while preserving the same BlueHarbor sites.

### Forward security dependency

Global Reach sends circuit-to-circuit traffic directly rather than through the Virtual WAN hub security appliance. Therefore this Global Reach stage is **intentionally retired in Module 6** when BlueHarbor's policy becomes centrally inspected private transit.

The learner must understand both architectures and why the security requirement changes the preferred path.

---

## Chapter 09 — FastPath: exact Virtual WAN eligibility

Do not claim FastPath merely because the unit exists.

For BlueHarbor's **Virtual WAN** architecture, the current rule is:

```text
ExpressRoute Direct circuit
+
Virtual WAN ExpressRoute Gateway >= 5 scale units
        -> FastPath automatically enabled for supported traffic
```

A normal provider ExpressRoute circuit is not treated as FastPath-enabled inside Virtual WAN under the current support model.

Mental distinction:

```text
control-plane architecture still requires the ExpressRoute gateway
supported FastPath traffic can use a more direct data path
```

If BlueHarbor's cumulative lab chooses the provider-circuit model, Unit 09 teaches the supported Direct design and explains precisely why the current lab path cannot activate vWAN FastPath rather than creating a disconnected environment.

---

## Chapter 10 — Troubleshoot the complete enterprise path

Troubleshooting chain:

```text
application / destination
 -> VNet route
 -> Virtual Hub VNet connection / hub routing
 -> Virtual WAN ExpressRoute Gateway
 -> learned BGP route
 -> private peering
 -> circuit state
 -> provider path
 -> BlueHarbor edge
```

Also compare the VPN alternate path when diagnosing preference/failover or asymmetric-routing issues.

---

## Chapter 11 — Architecture Review Board

Explain without relying on the Portal:

- why ExpressRoute was added to Virtual WAN rather than creating a second hub;
- circuit versus gateway;
- classic VNet ExpressRoute gateway versus Virtual WAN ExpressRoute gateway;
- BGP/private peering and Microsoft peering prerequisites;
- why VPN remains useful;
- route preference/failover;
- why Global Reach uses two circuits/provider paths;
- why Global Reach must later retire if private transit must be inspected by the secured hub;
- exact vWAN FastPath eligibility;
- privacy versus encryption;
- the end-to-end troubleshooting sequence.

## Carry-forward into Module 4

At the end of Module 3, BlueHarbor has mature transport to the existing Azure estate. The next problem is service availability:

> The network path can be healthy while an application backend is unhealthy. How should traffic be distributed across healthy service endpoints?

That starts Module 4 without resetting any connectivity built so far.
