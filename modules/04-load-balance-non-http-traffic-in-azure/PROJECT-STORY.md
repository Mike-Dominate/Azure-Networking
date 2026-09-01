# BlueHarbor Industries — Module 4 Project Story

## Project — Build resilient Device Telemetry Ingest

**Microsoft Learn module:** Load balance non-HTTP(S) traffic in Azure  
**Status:** NOT STARTED  
**Terraform model:** extend the same cumulative `blueharbor/terraform/` state

## Starting point from Module 3

BlueHarbor already has a mature network and transport architecture:

```text
Module 1
VNets / DNS / peering / routing / NAT

Module 2
classic VPN learning -> Virtual WAN production transit
Brisbane / Perth / remote users

Module 3
ExpressRoute added to the existing Virtual WAN hub
VPN retained as an alternate path
```

Module 4 does not redesign any of that transport.

## New business workload

Manufacturing introduces:

```text
BlueHarbor Device Telemetry Ingest
Protocol: TCP
Service port: 9000
```

BlueHarbor equipment at factories, customer sites and field locations sends telemetry to the service over the Internet.

The first pilot has one backend. When that backend fails, the network remains reachable but telemetry ingestion stops.

This establishes the Module 4 problem:

> Reachability is healthy. Application availability is not.

---

## Chapter 01 — The network is up, but telemetry is down

**Unit 01 — Introduction**

Separate transport health from service health.

```text
client can reach Azure
        !=
application has a healthy backend
```

The telemetry workload is introduced **here**. It does not pretend to have been built in Module 3.

---

## Chapter 02 — Multiple backends need one service identity

**Unit 02 — Explore load balancing**

The pilot evolves from one backend to multiple telemetry receivers.

Mental model:

```text
client
  |
  | TCP/9000
  v
service frontend
  |
  +-- healthy backend
  +-- healthy backend
```

Introduce:

- frontend IP;
- backend pool;
- health probe;
- load-balancing rule;
- five-tuple / Layer 4 flow reasoning;
- why Load Balancer is not an HTTP-aware proxy.

---

## Chapter 03 — Design the Australia East production service

**Unit 03 — Design and implement Azure Load Balancer**

Reuse the existing Manufacturing application subnet:

```text
bhi-vnet-mfg-aue
  |
  +-- snet-mfg-app   10.20.1.0/24
         |
         +-- vm-telemetry-aue-01
         +-- vm-telemetry-aue-02
```

The service is intentionally Internet facing because field/customer equipment must reach it without being part of BlueHarbor's private WAN.

Approved frontend model:

```text
Internet
  |
  | TCP/9000
  v
pip-telemetry-aue
  |
lb-telemetry-aue   Standard / public
  |
  +-- vm-telemetry-aue-01
  +-- vm-telemetry-aue-02
```

Health is tested on TCP/9000 so the practical remains clearly non-HTTP(S).

### Existing NAT reuse

`snet-mfg-app` already has the explicit Module 1 NAT-managed outbound path. Module 4 backends inherit that architecture for backend-initiated outbound traffic rather than creating another Australia East outbound mechanism.

### Minimal NSG

Add only the security rules required to make the service function safely enough for this availability module:

- permit approved telemetry source scope to TCP/9000;
- permit Azure Load Balancer probe traffic as required;
- preserve normal deny behaviour.

Module 6 later turns this into the full segmentation/security story.

---

## Chapter 04 — Prove backend failure does not equal service failure

**Unit 04 — Exercise: Create and configure an Azure Load Balancer**

Persistent BlueHarbor infrastructure is implemented through the same Terraform root.

Expected Module 4 AUE delta:

```text
existing snet-mfg-app
        +
telemetry backend compute/NICs
        +
minimal NSG
        +
Standard public IP
        +
Standard public Load Balancer
        +
TCP/9000 backend pool/rule/probe
```

Failure experiment:

```text
BEFORE
telemetry-aue-01  HEALTHY
telemetry-aue-02  HEALTHY

BREAK ONE BACKEND
telemetry-aue-01  UNHEALTHY
telemetry-aue-02  HEALTHY

EXPECTED
service remains reachable through healthy backend
```

A successful `terraform apply` is not enough. Validate real TCP traffic and observed backend health.

---

## Chapter 05 — Regional resilience becomes the next requirement

**Unit 05 — Explore Azure Traffic Manager**

BlueHarbor now asks:

> What if the entire Australia East telemetry service is unavailable, not merely one backend?

Add a disaster-recovery service in Southeast Asia using the **existing** Research VNet:

```text
bhi-vnet-research-sea   10.30.0.0/16
  |
  +-- snet-telemetry-dr  10.30.3.0/24
         |
         +-- vm-telemetry-sea-01
         +-- vm-telemetry-sea-02
```

Add:

```text
pip-telemetry-sea
lb-telemetry-sea   Standard / public
TCP/9000 rule and probe
```

No second regional endpoint appears magically. It is built here because regional recovery has become a business requirement.

### Traffic Manager mental model

```text
client DNS query
        |
        v
Traffic Manager policy + endpoint health
        |
        v
selected regional endpoint answer

client TCP/9000 data traffic
        |
        v
selected regional public Load Balancer directly
```

Traffic Manager is not an application proxy and is not in the telemetry data path after DNS selection.

Teach all Microsoft routing methods, but BlueHarbor chooses **Priority** because the requirement is primary/recovery:

```text
Priority 1 -> Australia East
Priority 2 -> Southeast Asia
```

A healthy SEA endpoint can remain unselected while AUE is healthy. This makes health and policy eligibility visibly different concepts.

---

## Chapter 06 — Exercise: prove regional endpoint failover

**Unit 06 — Exercise: Create a Traffic Manager profile**

Add the Traffic Manager profile to the same Terraform state only after both regional services exist.

Approved BlueHarbor configuration:

```text
tm-telemetry-global
  |
  +-- Priority 1 -> AUE public telemetry endpoint
  +-- Priority 2 -> SEA public telemetry endpoint

monitor protocol: TCP
monitor port:     9000
```

Regional public IP resources receive valid globally unique DNS labels as required by the Traffic Manager endpoint design; the exact unique labels are generated/parameterized by Terraform.

### Two-level availability experiment

**Failure A — one AUE backend fails**

```text
Traffic Manager still sees AUE regional service healthy
AUE remains selected
AUE Load Balancer stops sending new flows to failed backend
```

**Failure B — the complete AUE regional service becomes unhealthy**

```text
Traffic Manager health changes for AUE
DNS selection moves to SEA according to Priority policy
client/resolver TTL and caching affect when the new answer is observed
```

This distinction is mandatory:

```text
Azure Load Balancer
-> instance/backend availability inside one region

Traffic Manager
-> DNS selection across regional service endpoints
```

---

## Chapter 07 — Architecture review

**Unit 07 — Summary**

Explain the complete Module 4 chain:

```text
GLOBAL
client DNS
  -> Traffic Manager Priority policy / health
  -> regional public endpoint answer

REGIONAL AUE
client TCP/9000
  -> lb-telemetry-aue
  -> healthy telemetry backend in snet-mfg-app

REGIONAL SEA DR
client TCP/9000
  -> lb-telemetry-sea
  -> healthy telemetry backend in snet-telemetry-dr
```

Also explain why:

- Traffic Manager is not in the application data path;
- Load Balancer is Layer 4 even though health probing exists;
- one backend failure is different from regional service failure;
- the AUE telemetry backend reuses the Module 1 Manufacturing VNet and NAT path;
- SEA DR reuses the existing Research VNet rather than creating a new regional network;
- Module 1–3 transport remains intact.

## Module 4 end state

New Terraform-managed application-delivery resources now exist on top of the existing enterprise network:

```text
AUE telemetry service
SEA telemetry DR service
Traffic Manager profile
```

Everything built in Modules 1–3 remains in the same state lineage.

## Handoff to Module 5

The telemetry service is deliberately non-HTTP(S). Module 5 introduces a **different business application** that requires HTTP(S)-aware delivery, TLS and path/host routing.

Gate 4 must decide exactly where that Partner Hub application tier lives and how Application Gateway/Front Door origins attach to the existing network without inventing unexplained VNets.
