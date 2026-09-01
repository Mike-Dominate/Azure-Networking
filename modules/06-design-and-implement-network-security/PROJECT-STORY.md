# BlueHarbor Industries — Module 6 Project Story

## Project — Harden the BlueHarbor enterprise network

**Microsoft Learn module:** Design and implement network security  
**Company:** BlueHarbor Industries (BHI)  
**Status:** NOT STARTED

## Starting point from Module 5

BlueHarbor now has a mature Azure network and application-delivery platform:

```text
Global users
   |
Azure Front Door
   |
regional Application Gateway / applications

BlueHarbor sites and remote users
   |
VPN / ExpressRoute / Virtual WAN
   |
Azure VNets
   |
Core / Manufacturing / Research workloads
```

The architecture works. The new business problem is security governance.

The BlueHarbor security team asks:

> You have proved that everything can communicate. Now prove that only the right things can communicate, that public services can withstand network attacks, and that web applications are protected at the correct layer.

Module 6 therefore evolves the same environment from **connected** to **defensible**.

The Microsoft Learn unit order remains authoritative. Security features are introduced only when a visible BlueHarbor requirement makes them necessary.

---

## Chapter 01 — Introduction: Connectivity is not security

The security team performs an architecture review and identifies a mixture of required and excessive reachability.

```text
Partner Hub Internet access             required
Management access from everywhere       not required
Manufacturing to selected shared apps   required
Manufacturing to every internal target  not required
Outbound Internet for updates           required
Unrestricted outbound destinations      requires control
```

### Core mental model

```text
Networking question:
Can A reach B?

Security question:
Should A reach B?
If yes, by which protocol, port, path and policy?
```

The unit establishes that availability and connectivity are not proof of appropriate security.

---

## Chapter 02 — Get network security recommendations with Microsoft Defender for Cloud

Before changing controls, BlueHarbor wants evidence about current exposure and weaknesses.

### Business requirement

Use Microsoft Defender for Cloud as a posture and recommendation layer to identify where remediation should begin.

```text
Azure environment
      |
      v
Defender for Cloud
      |
      v
posture / recommendations / attack-path context
      |
      v
engineering remediation
```

### Concepts to master

- security posture
- recommendations
- Secure Score concepts
- attack-path analysis concepts
- Cloud Security Explorer concepts where required by the current AZ-700 study guide
- difference between assessment and traffic enforcement

### Mental model

Defender for Cloud is not the packet-processing firewall in this story. It helps BlueHarbor see and prioritise security weaknesses before enforcement changes are made.

---

## Chapter 03 — Deploy Azure DDoS Protection by using the Azure portal

The public BlueHarbor Partner Hub and other public IP services create an Internet attack surface. Security now considers denial-of-service resilience.

### Business requirement

Protect eligible public network services from network-layer DDoS attacks that attempt to exhaust service capacity or availability.

### Layer distinction

```text
DDoS Protection
-> network/infrastructure availability problem

WAF
-> HTTP(S) application-request problem
```

The learner must understand why these controls solve different security problems rather than treating them as interchangeable.

### Cost rule

DDoS Protection can be materially billable. Before any practical deployment, verify the current Azure pricing/service model and design a short-lived exercise. Do not leave expensive protection enabled merely to preserve lab state.

---

## Chapter 04 — Exercise: Configure DDoS Protection on a virtual network using the Azure portal

BlueHarbor applies the Microsoft exercise to the appropriate Internet-facing VNet design.

### Architecture

```text
Internet
   |
hostile / abnormal network traffic
   |
Azure public edge
   |
DDoS protection capability
   |
BlueHarbor VNet / public service
```

### Engineering validation

Do not stop at 'enabled'. Explain:

- which VNet or public exposure is being protected;
- which public IP-backed services create attack surface;
- what DDoS protection is intended to mitigate;
- which telemetry or monitoring evidence would help identify an attack;
- what is outside the scope of DDoS Protection.

### Practicality rule

Use the Microsoft exercise as the baseline, capture evidence while the service is live, then remove billable resources safely unless the next approved chapter explicitly needs them.

---

## Chapter 05 — Deploy Network Security Groups by using the Azure portal

BlueHarbor now needs workload-level segmentation.

### Scenario

```text
Manufacturing application subnet   10.20.1.0/24
Manufacturing data subnet          10.20.2.0/24
```

Security requirements include:

- application servers may reach the required database service;
- management access may originate only from approved management systems;
- unnecessary lateral traffic must be denied;
- rule intent must be understandable without memorising individual VM addresses.

### Concepts to master

- NSG association and scope
- source and destination
- protocol
- source and destination ports
- priorities
- allow / deny
- default rules
- stateful behaviour
- subnet versus NIC association
- Application Security Groups (ASGs)

### Deliberate failure

Create or reason through conflicting intent:

```text
priority 200  Deny-Manufacturing-To-Data
priority 300  Allow-App-To-Database
```

The lower priority number is evaluated first. The learner must inspect effective rule ordering rather than guess.

### Study-guide depth

Attach relevant AZ-700 security depth here, including ASGs, IP flow verification, VNet flow-log concepts, Bastion-related NSG considerations and Virtual Network Manager security-control concepts where they match the current objective.

---

## Chapter 06 — Design and implement Azure Firewall

BlueHarbor's environment has grown beyond a collection of isolated subnet rules. Security now requires central inspection and controlled outbound access for selected traffic flows.

### Business requirement

Manufacturing and other private workloads need approved Internet and cross-network access, but not unrestricted reachability.

### Architecture

```text
Workload subnet
      |
      v
Route table / UDR
      |
      v
Azure Firewall
      |
security policy
      |
      v
approved destination
```

### Concepts to master

- Azure Firewall role
- firewall subnet / deployment architecture
- SKU/design considerations
- network rules
- application rules
- NAT rule concepts
- rule processing and policy intent
- DNS/FQDN dependencies where relevant
- routing dependency
- central egress inspection

### Core lesson

A firewall cannot inspect a packet that does not traverse the firewall. Routing and firewall policy are therefore separate but dependent parts of the security design.

---

## Chapter 07 — Exercise: Deploy and configure Azure Firewall using the Azure portal

BlueHarbor now proves the central-inspection design with real traffic behaviour.

### Expected flow

```text
Manufacturing workload
      |
UDR: selected traffic / default route
      |
      v
Azure Firewall
      |
      +-- allowed destination  -> success
      |
      +-- denied destination   -> blocked
```

### Required validation

- inspect the effective route;
- prove traffic reaches the intended firewall path;
- prove an allowed flow;
- prove a denied flow;
- identify which firewall rule or rule collection explains the result;
- validate independently rather than relying only on successful deployment state.

### Deliberate failure 1 — wrong route

Firewall policy is correct, but the route sends traffic elsewhere.

Result:

```text
traffic never reaches Azure Firewall
```

### Deliberate failure 2 — correct route, wrong rule

Traffic reaches the firewall but is denied by policy.

Troubleshooting sequence:

```text
route
 -> firewall path
 -> matching rule
 -> destination / return path
```

### Cost rule

Azure Firewall is a significant billable service. Plan the practical, capture evidence live and tear it down promptly unless a directly following unit requires the same deployment.

---

## Chapter 08 — Secure your networks with Azure Firewall Manager

BlueHarbor now has multiple regions, firewall policies and Virtual WAN connectivity. Managing each firewall as an independent configuration no longer scales.

### Business requirement

Centralise security policy and firewall governance.

### Mental model

```text
Azure Firewall
= enforcement / packet-processing service

Azure Firewall Manager
= central management and policy orchestration
```

### Architecture

```text
Firewall Manager / central policy
        |
   +----+---------+---------+
   |              |         |
regional FW    secured hub  other managed firewall scope
```

### Concepts to master

- Firewall Policy
- central rule governance
- inheritance / policy hierarchy concepts where applicable
- hub and VNet security-management models
- difference between management plane and packet-processing plane

---

## Chapter 09 — Exercise: Secure your Virtual Hub using Azure Firewall Manager

The Virtual WAN architecture from Module 2 returns to the story.

Originally, the Virtual Hub solved a connectivity problem. It now becomes a security enforcement point because BlueHarbor wants central control over branch, remote-user and Azure traffic.

### Architecture evolution

```text
Brisbane / Perth / branches / remote users
                |
                v
         Virtual WAN Hub
                |
         secured hub model
                |
         Azure Firewall
                |
         central policy
                |
      +---------+---------+
      |         |         |
     Core   Manufacturing Research
```

### Concepts to master

- secured virtual hub
- Azure Firewall in Virtual WAN
- Firewall Manager policy
- routing intent / traffic-path reasoning at the level required by the exercise and current service behaviour
- central inspection versus distributed NSG segmentation

### Critical lesson

Security enforcement is only effective if the route topology actually sends the intended traffic through the secured hub/firewall path.

---

## Chapter 10 — Implement a Web Application Firewall

Network controls are now strong, but the public Partner Hub from Module 5 can still receive malicious HTTP(S) requests that are valid from an IP/port perspective.

### Business requirement

Protect web applications at Layer 7.

### Layered model

```text
Internet
   |
DDoS / network controls
   |
HTTP(S)
   |
WAF
   |
web application
```

### Concepts to master

- WAF policy
- managed rule sets
- custom-rule concepts where applicable
- policy association
- Application Gateway WAF
- Front Door WAF
- Detection mode
- Prevention mode
- logging / rule-match reasoning

### Detection versus prevention

```text
Detection mode
rule match -> log / observe -> request generally continues according to policy behaviour

Prevention mode
rule match -> enforce block according to policy
```

### BlueHarbor design question

Do not place WAFs everywhere by habit. Decide whether the appropriate application-security boundary is at Front Door, Application Gateway, or a layered design justified by actual requirements.

### Progressive-story link

Module 5 created Front Door and Application Gateway for application delivery. Module 6 adds WAF because the business now needs application-layer protection.

---

## Chapter 11 — Summary and resources: BlueHarbor security architecture review

By the end of Module 6, BlueHarbor should have a layered security mental model rather than the belief that one firewall makes an environment secure.

```text
Defender for Cloud
-> posture / recommendations / risk visibility

DDoS Protection
-> public network availability protection

NSG / ASG
-> distributed workload/subnet segmentation

Azure Firewall
-> central routed network/application enforcement

Firewall Manager
-> central firewall policy/governance

WAF
-> HTTP(S) request protection
```

### Architecture-board challenges

The learner must be able to troubleshoot different incidents using the correct layer.

#### Incident A — Manufacturing cannot reach an approved external API

Investigate:

```text
DNS
 -> NSG
 -> effective route / UDR
 -> Azure Firewall path
 -> matching firewall rule
 -> destination / return path
```

#### Incident B — Partner Hub is reachable but returns WAF 403 responses

Investigate:

```text
Front Door / Application Gateway
 -> WAF policy association
 -> matching WAF rule
 -> Detection vs Prevention
 -> origin/backend behaviour
```

#### Incident C — Public service receives a volumetric network attack

Do not automatically answer 'WAF'. Identify the attack layer and choose the control that addresses network-layer availability.

## Definition of done for Module 6

The learner can explain why each control exists, where it sits in the packet/application path, and which failure or attack class it addresses.

The learner can also explain how:

```text
route
+ segmentation
+ central firewall policy
+ DDoS resilience
+ application-layer WAF
+ posture visibility
```

combine into defence in depth without assuming that any one feature is sufficient.

## Carry-forward into Module 7

BlueHarbor's application teams now consume more Azure PaaS services. Security asks the next question:

> If an application only needs private access to a managed Azure service, why should that service remain exposed through a public endpoint at all?

That leads directly into Module 7 — Design and implement private access to Azure Services.
