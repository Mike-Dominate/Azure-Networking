# BlueHarbor Industries — Module 5 Project Story

## Project — Launch the BlueHarbor Partner Hub globally

**Microsoft Learn module:** Load balance HTTP(S) traffic in Azure  
**Status:** NOT STARTED  
**Terraform model:** extend the same cumulative `blueharbor/terraform/` state

## Starting point from Module 4

Everything from Modules 1–3 remains deployed, and Module 4 has added a separate non-HTTP production service:

```text
Device Telemetry Ingest
TCP/9000

Australia East
 -> public Standard Load Balancer

Southeast Asia
 -> public Standard Load Balancer

Traffic Manager
 -> Priority DNS failover AUE -> SEA
```

Module 5 does not relabel or repurpose that telemetry architecture.

The new application is the **BlueHarbor Partner Hub**.

Narrative URLs:

```text
https://portal.blueharbor.example/
https://portal.blueharbor.example/engineering/
https://portal.blueharbor.example/orders/
https://portal.blueharbor.example/support/
```

The `.example` hostname is documentation-only. The live lab uses Azure-generated reachable hostnames/endpoints until a real learner-controlled public domain is intentionally introduced.

The Module 5 business question is:

> How should BlueHarbor deliver HTTP(S) applications when routing decisions depend on hostnames, URL paths, TLS, backend health and global web performance?

---

## Chapter 01 — Introduction: Layer 4 is no longer enough

**Unit 01 — Introduction**

Partner Hub is introduced here as a new application. It is not assumed to exist at the end of Module 4.

Example request:

```text
GET /engineering/
Host: portal.blueharbor.example
```

The application team needs decisions based on:

- HTTP host;
- URL path;
- HTTP/HTTPS behaviour;
- application-specific health;
- TLS design.

Mental model:

```text
Layer 4
IP + port + protocol

Layer 7
HTTP host + path + application behaviour
```

This creates the reason for Application Gateway.

---

## Chapter 02 — Design Application Gateway and the Australia East landing zone

**Unit 02 — Design Azure Application Gateway**

Partner Hub deserves an explicit application landing zone rather than being inserted into Core, Manufacturing or the telemetry estate.

Add:

```text
bhi-vnet-partner-aue   10.40.0.0/16
  snet-appgw           10.40.1.0/24
  snet-partner-app     10.40.2.0/24
```

Then connect the new VNet to the existing production transit:

```text
bhi-vnet-partner-aue
        |
Virtual Hub VNet connection
        |
bhi-vhub-aue
```

The Application Gateway subnet is dedicated to the gateway service. The `/24` allocation deliberately gives Application Gateway v2 room for scale/maintenance rather than planning to the minimum.

The Partner application subnet receives explicit Terraform-managed outbound connectivity:

```text
snet-partner-app
  |
nat-partner-aue
  |
Internet for approved backend-initiated outbound traffic
```

### Regional delivery design

```text
Internet
   |
HTTP(S)
   |
appgw-partner-aue   Standard_v2
   |
   +-- Engineering backend
   +-- Orders backend
   +-- Support backend
   |
snet-partner-app
```

Application Gateway starts on Standard_v2. WAF is intentionally not pre-enabled; Module 6 must add security because of a real security requirement.

---

## Chapter 03 — Configure HTTP(S)-aware routing

**Unit 03 — Configure Azure Application Gateway**

Partner Hub routing contract:

```text
/engineering/* -> Engineering backend/pool
/orders/*      -> Orders backend/pool
/support/*     -> Support backend/pool
```

Hostname routing can also be taught against the same architecture where the practical hostname/DNS setup supports it.

The learner must reason through:

- listeners;
- request-routing rules;
- URL path maps;
- backend pools;
- backend settings;
- custom probes;
- host-header behaviour;
- TLS termination versus end-to-end TLS.

A backend may be fully IP-reachable yet fail because the HTTP health path, host header or backend TLS/application setting is wrong.

### Practical hostname/TLS guardrail

`portal.blueharbor.example` remains the narrative identifier. Do not pretend a reserved `.example` name has public DNS ownership or publicly trusted certificates.

Use Azure-generated hostnames and appropriate lab TLS material where required by the exercise. A real custom domain can be added later if the learner intentionally supplies one.

---

## Chapter 04 — Deploy and troubleshoot the Australia East Partner Hub

**Unit 04 — Exercise: Deploy Azure Application Gateway**

Preserve the Microsoft exercise objective, but implement persistent BlueHarbor resources through the same Terraform root.

Expected cumulative delta:

```text
existing Modules 1–4
        +
bhi-vnet-partner-aue 10.40.0.0/16
        +
snet-appgw 10.40.1.0/24
snet-partner-app 10.40.2.0/24
        +
Virtual WAN VNet connection to bhi-vhub-aue
        +
nat-partner-aue / explicit app-subnet egress
        +
Partner Hub backend compute/services
        +
appgw-partner-aue Standard_v2
```

Validation/failure work:

1. prove path-based request routing;
2. stop/break one backend and inspect health/routing behaviour;
3. break the configured health path;
4. introduce a host-header/backend-setting mismatch;
5. distinguish HTTP-layer failure from basic IP reachability failure.

No safe-teardown step follows. All correct resources remain for Units 05–07 and later modules.

---

## Chapter 05 — The Partner Hub becomes multi-region

**Unit 05 — Design and configure Azure Front Door**

Users now need a global HTTP(S) service with more than one real application origin.

This is the business event that finally activates the Southeast Asia Virtual WAN capacity reserved during Gate 2:

```text
bhi-vhub-sea   10.200.4.0/22
```

Standard Virtual WAN now has regional hubs:

```text
bhi-vwan
  |
  +-- bhi-vhub-aue   10.200.0.0/22
  |
  +-- bhi-vhub-sea   10.200.4.0/22
```

### Move Research to its regional hub

`bhi-vnet-research-sea` is already connected to `bhi-vhub-aue` from Module 2 because AUE was the only deployed hub at the time.

It cannot simply have two active Virtual WAN hub connections as if that created no ownership conflict.

Perform the intentional Terraform migration:

```text
old
bhi-vnet-research-sea -> bhi-vhub-aue

new
bhi-vnet-research-sea -> bhi-vhub-sea
```

The Research VNet and its Module 4 telemetry DR subnet/resources remain intact. Only the Virtual Hub connection ownership changes.

The original Module 1 Core <-> Research global VNet peering remains unless a later security/routing requirement deliberately changes it.

### Add the Southeast Asia Partner landing zone

```text
bhi-vnet-partner-sea   10.50.0.0/16
  snet-appgw           10.50.1.0/24
  snet-partner-app     10.50.2.0/24
```

Connect it to `bhi-vhub-sea` and provide explicit application-subnet egress through `nat-partner-sea`.

Add the regional HTTP(S) delivery stack:

```text
appgw-partner-sea   Standard_v2
  |
Partner Hub SEA backends
```

No Europe region is introduced. Southeast Asia is the canonical secondary Azure region for BlueHarbor.

### Front Door mental model

```text
Global users
     |
Azure Front Door
     |
     +-- Australia East origin
     +-- Southeast Asia origin
```

Contrast:

```text
Traffic Manager
 -> DNS answer changes
 -> not in application data path

Azure Front Door
 -> global HTTP(S) proxy/service
 -> remains in application data path
```

---

## Chapter 06 — Create Front Door with real regional origins

**Unit 06 — Exercise: Create a Front Door for a highly available web application**

Do not point Front Door at hypothetical regional services.

Both origins already exist:

```text
appgw-partner-aue
appgw-partner-sea
```

Add:

```text
Azure Front Door Standard
  |
origin group
  +-- AUE Application Gateway public origin
  +-- SEA Application Gateway public origin
  |
routes / health probes
```

The public origin model is intentional in Module 5 because application delivery is being learned before application-origin hardening.

Validation/failure work:

- prove normal global HTTP(S) request flow;
- inspect origin health;
- make one regional origin unhealthy and observe Front Door routing behaviour;
- compare this with Module 4 Traffic Manager failover;
- introduce one route/origin/host-header error and diagnose it.

### Security handoff deliberately left open

Module 6 must ask whether someone can bypass Front Door and reach an Application Gateway origin directly, and whether WAF belongs at Front Door, Application Gateway or both.

Do not pre-solve that security decision here.

---

## Chapter 07 — Application-delivery architecture review

**Unit 07 — Summary**

By the end of Module 5, the learner must distinguish:

```text
Azure Load Balancer
-> regional Layer 4 TCP/UDP

Traffic Manager
-> global DNS-based endpoint selection

Application Gateway
-> regional Layer 7 HTTP(S)

Azure Front Door
-> global Layer 7 HTTP(S) edge/proxy
```

### Canonical Partner Hub end state

```text
                    Global users
                         |
                         v
                Azure Front Door Standard
                         |
              +----------+----------+
              |                     |
              v                     v
        Australia East         Southeast Asia
              |                     |
 appgw-partner-aue        appgw-partner-sea
 Standard_v2              Standard_v2
              |                     |
              v                     v
bhi-vnet-partner-aue     bhi-vnet-partner-sea
10.40.0.0/16             10.50.0.0/16
              |                     |
              v                     v
        bhi-vhub-aue          bhi-vhub-sea
```

The Module 4 TCP telemetry architecture remains deployed and unchanged.

## Carry-forward into Module 6

BlueHarbor now has real Internet-facing network and web-delivery resources that Security can harden rather than hypothetical targets.

Module 6 must determine:

- DDoS scope for actual public IP-backed resources;
- NSG/ASG segmentation around actual workloads;
- central Azure Firewall routing through the existing Virtual WAN architecture;
- how securing Virtual WAN affects existing routes/connections;
- WAF tier/policy placement for the actual Application Gateways and Front Door;
- how to reduce or control direct origin bypass.
