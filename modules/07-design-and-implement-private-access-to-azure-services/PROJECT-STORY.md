# BlueHarbor Industries — Module 7 Project Story

## Project — Remove unnecessary public PaaS exposure

**Microsoft Learn module:** Design and implement private access to Azure Services  
**Company:** BlueHarbor Industries (BHI)  
**Terraform model:** extend the same cumulative `blueharbor/terraform/` stack  
**Status:** NOT STARTED

## Starting point from Module 6

BlueHarbor already has a progressively built enterprise network:

```text
Module 1 -> VNets, DNS, peering, routing, NAT
Module 2 -> hybrid VPN / remote connectivity / Virtual WAN concepts
Module 3 -> ExpressRoute enterprise-connectivity design
Module 4 -> regional L4 availability and global DNS steering
Module 5 -> Application Gateway and Front Door for HTTP(S)
Module 6 -> Defender posture, DDoS, NSGs/ASGs, Azure Firewall, secured hub and WAF
```

The network and application-delivery paths are now controlled, but application teams begin replacing self-managed infrastructure with Azure PaaS services.

Examples include:

```text
Azure Storage
Azure SQL / data services
App Service / managed application components
```

The next security review asks:

> If these services are consumed by BlueHarbor's private workloads, why should the network path depend on a publicly reachable service endpoint?

Module 7 therefore changes the **service-access boundary** while preserving the architecture already built.

---

## Chapter 01 — Introduction: Our network is private, our PaaS is not

BlueHarbor's Partner Hub and Manufacturing workloads begin using managed Azure services.

Conceptually:

```text
Partner Hub -> Azure SQL public service endpoint
Manufacturing -> Azure Storage public service endpoint
```

The resources are in Azure, but that does not automatically mean they are members of BlueHarbor's VNets.

### Core lesson

```text
resource hosted in Azure
!=
resource privately addressed inside my VNet
```

### Business requirement

Choose an appropriate private-access pattern based on the real requirement rather than using every private networking feature everywhere.

---

## Chapter 02 — Service endpoints: Manufacturing restricts Storage access

The existing Manufacturing application subnet must write production archives to Azure Storage.

Security requires:

> Only approved BlueHarbor subnets should be able to use this Storage account through the intended network path.

This introduces virtual network service endpoints.

```text
existing Manufacturing subnet
        |
  service endpoint
        |
        v
Azure Storage
```

### Critical mental model

A service endpoint does **not** place a private endpoint NIC or private IP for the service into the subnet.

Instead, it extends the subnet identity to supported Azure services so service-side network restrictions can trust the approved VNet/subnet path.

### Design question

```text
Do I need:
"Only this subnet should be permitted to use the service"

or

"This service should be represented by a private IP in my network"?
```

The first can point toward a service endpoint. The second points toward Private Endpoint/Private Link.

### Study-guide depth

Attach service endpoint policies here where required. The goal is to understand how BlueHarbor can constrain supported service-endpoint traffic more deliberately rather than treating every service endpoint as equivalent.

---

## Chapter 03 — Private Endpoint and Private Link: Partner Hub data becomes private-addressed

The Partner Hub now consumes a sensitive managed data service.

Security strengthens the requirement:

> The service should be reachable using a private IP from the BlueHarbor network and from approved hybrid clients through the connectivity already built.

This introduces a private endpoint.

```text
Partner Hub network
      |
      v
Private Endpoint
10.x.x.x
      |
Azure Private Link
      |
      v
Azure PaaS service
```

A private endpoint is represented by a network interface with a private IP from the selected VNet/subnet and connects privately to the supported service through Azure Private Link.

### Earlier modules now matter

The private endpoint does not create a new connectivity universe. Approved Brisbane/Perth/on-premises paths should use the hybrid network already designed in Modules 2 and 3.

```text
on-premises client
      |
VPN / ExpressRoute design
      |
existing Azure routing
      |
Private Endpoint
      |
Azure PaaS
```

The module must therefore test route and DNS dependencies rather than treating the private endpoint as an isolated object.

### Private Link Service extension

Where appropriate, BlueHarbor can also publish its **own** service privately.

The regional service created around Azure Load Balancer in Module 4 provides the story connection:

```text
existing BlueHarbor service
        |
Standard Load Balancer
        |
Private Link Service
        |
consumer Private Endpoint
```

This demonstrates that Private Link is not limited to Microsoft-managed PaaS services.

---

## Chapter 04 — DNS: A private IP is useless if clients resolve the wrong destination

Private access becomes operational only when name resolution returns the correct private destination.

```text
Partner Hub
    |
DNS query
    |
BlueHarbor DNS architecture
    |
Private DNS zone / appropriate DNS path
    |
private endpoint IP
    |
Private Endpoint
    |
Azure PaaS
```

### Module 1 returns directly

DNS is not recreated in Module 7. We extend the name-resolution architecture built earlier.

A classic failure is:

```text
Private Endpoint exists
Private IP exists
routing is valid

BUT

client DNS returns the public path
```

The private-network design then fails its intended objective even though the endpoint resource itself looks healthy.

### Hybrid DNS test

An Azure workload may resolve the private endpoint correctly while an on-premises client does not.

That should drive troubleshooting toward the hybrid DNS forwarding/resolution path instead of random changes to the private endpoint.

---

## Chapter 05 — Exercise: Restrict PaaS with service endpoints

Microsoft's service-endpoint exercise becomes a BlueHarbor Manufacturing change to the **existing** Terraform environment.

Expected Terraform delta:

```text
existing Manufacturing subnet
        +
Azure Storage
        +
service endpoint configuration
        +
service-side network restriction
        +
service endpoint policy where justified
```

The plan should preserve all earlier infrastructure.

### Validation

Prove both sides:

```text
approved Manufacturing source -> Storage   ALLOWED
unapproved source              -> Storage   DENIED
```

Do not accept `terraform apply` as proof that the network restriction behaves correctly.

### Deliberate failure

Permit the wrong subnet or omit the expected service-side network rule and determine why access behaviour does not match policy.

Permanent corrections must end in Terraform.

---

## Chapter 06 — Exercise: Create a private endpoint

Microsoft's PowerShell exercise objective is preserved, but BlueHarbor implements the persistent infrastructure through the cumulative Terraform root.

The existing Partner Hub/data architecture gains:

```text
existing application network
        +
managed PaaS resource
        +
Private Endpoint
        +
private DNS integration
        +
appropriate public-network restriction
```

Public access behaviour is service-specific. A private endpoint alone must not be assumed to disable every possible public path; configure the target service according to its own network-access model and the BlueHarbor requirement.

### App Service VNet Integration

Where the Microsoft module/study guide requires App Service VNet integration, use the existing Partner Hub story:

```text
App Service / managed app
        |
VNet Integration
        |
existing BlueHarbor VNet
        |
Private Endpoint
        |
Azure SQL / PaaS
```

Keep the distinction clear:

```text
VNet Integration
-> how supported app compute sends traffic through/into the VNet path

Private Endpoint
-> how a supported service is privately reachable through a private IP
```

### Failure tests

Useful failures include:

1. private endpoint healthy but DNS resolves the public path;
2. Azure workload resolves privately but on-premises client does not;
3. private endpoint works but unintended public network access remains available;
4. incorrect subnet/DNS link prevents the expected application path.

Each test should isolate whether the fault is DNS, route/connectivity, service policy or endpoint configuration.

---

## Chapter 07 — Summary: BlueHarbor private-access architecture review

By the end of Module 7, BlueHarbor should understand several distinct patterns rather than using "private access" as one vague feature.

```text
Service Endpoint
-> approved VNet/subnet identity can access a supported Azure service

Private Endpoint
-> specific supported service is represented by a private IP in a VNet

Private Link
-> private connectivity technology used by private endpoints

Private Link Service
-> publish BlueHarbor's own supported service privately

App Service VNet Integration
-> supported App Service outbound connectivity into a VNet path
```

## Cumulative end state

Conceptually:

```text
GLOBAL / WEB
Internet
  |
Front Door + WAF
  |
Application Gateway
  |
Partner Hub
  |
App Service / workloads
  |
VNet Integration / existing network
  |
Private DNS
  |
Private Endpoint
  |
Azure Private Link
  |
Azure PaaS data service

MANUFACTURING
existing Manufacturing subnet
  |
Service Endpoint
  |
restricted Azure Storage

BLUEHARBOR PRIVATE SERVICE
existing Module 4 Load Balancer
  |
Private Link Service
  |
consumer Private Endpoint

HYBRID
Brisbane / Perth / approved clients
  |
existing VPN / ExpressRoute / routing / DNS
  |
Private Endpoint
```

All of this remains part of the same Terraform codebase/state lineage created earlier.

## Architecture-board questions

The learner must be able to explain:

- why an Azure PaaS resource is not automatically inside a VNet;
- service endpoint versus private endpoint;
- Private Link versus Private Link Service;
- why DNS is fundamental to private endpoint designs;
- how on-premises clients reach/resolve private endpoints through existing hybrid architecture;
- why a private endpoint does not automatically imply that every public access path is disabled;
- App Service VNet Integration versus Private Endpoint;
- how the Module 4 Load Balancer can participate in a Private Link Service design;
- how to determine whether a failure is DNS, routing, service policy or private endpoint configuration.

## Handoff to Module 8

The environment is now highly capable and highly interconnected. Operations raises the final programme problem:

> Configuration tells us what the network should do. How do we prove what this complete environment is actually doing in production?

That leads directly into Module 8 — Design and implement network monitoring.
