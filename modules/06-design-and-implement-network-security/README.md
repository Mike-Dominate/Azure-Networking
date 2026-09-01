# Module 6 — Design and implement network security

**Microsoft Learn:** https://learn.microsoft.com/en-us/training/modules/design-implement-network-security-monitoring/

**BlueHarbor project:** Harden the exact enterprise network and applications built in Modules 1–5  
**Status:** NOT STARTED

Module 6 is a cumulative security evolution. It does not create a parallel security lab and it does not routinely tear down billable resources at unit boundaries.

## Starting security surface

BlueHarbor already has:

```text
public telemetry services
 -> AUE and SEA Standard public Load Balancers

public Partner Hub
 -> Front Door Standard
 -> AUE and SEA Application Gateway Standard_v2 origins

enterprise transit
 -> Standard Virtual WAN
 -> bhi-vhub-aue 10.200.0.0/22
 -> bhi-vhub-sea 10.200.4.0/22
 -> VPN / ExpressRoute / VNet connections

explicit outbound
 -> nat-mfg-aue
 -> nat-telemetry-sea
 -> nat-partner-aue
 -> nat-partner-sea
```

The security requirement is:

> Prove that only the right traffic can flow, that public network services have the correct availability protection, that private traffic can be centrally inspected without breaking public return paths, and that Partner Hub cannot bypass its intended HTTP(S) security boundaries.

## Progressive security architecture

```text
posture review
 -> DDoS protection for eligible public-IP VNets
 -> real NSG/ASG segmentation
 -> design Azure Firewall inside existing Virtual WAN
 -> secure AUE hub first and prove policy
 -> centralise policy with Firewall Manager
 -> secure both regional hubs + routing intent
 -> retire direct peerings that bypass inspected private transit
 -> replace Partner app NAT egress with firewall-controlled egress
 -> preserve explicit public-ingress return-path exceptions
 -> upgrade Front Door / Application Gateways for WAF
 -> restrict direct Front Door-origin bypass
```

## Target secured-hub model

```text
                    fwpol-bhi-global
                          |
               +----------+----------+
               |                     |
               v                     v
         azfw-bhi-aue           azfw-bhi-sea
               |                     |
         bhi-vhub-aue           bhi-vhub-sea
```

By the end of the module, approved Internet and private traffic use secured Virtual WAN routing where appropriate, while public Application Gateway and public Load Balancer paths retain deliberate symmetry exceptions.

## Public-path guardrail

Do **not** blindly force every subnet through `0.0.0.0/0 -> Azure Firewall`.

Explicit public-service subnets keep the direct return path required by their ingress model, including:

```text
AUE / SEA Application Gateway subnets
AUE / SEA telemetry public Load Balancer backend subnets
```

The exact supported route-table/service requirements are verified against current Azure documentation during implementation.

## Microsoft Learn units

1. Introduction
2. Get network security recommendations with Microsoft Defender for Cloud
3. Deploy Azure DDoS Protection by using the Azure portal
4. Exercise: Configure DDoS Protection on a virtual network using the Azure portal
5. Deploy Network Security Groups by using the Azure portal
6. Design and implement Azure Firewall
7. Exercise: Deploy and configure Azure Firewall using the Azure portal
8. Secure your networks with Azure Firewall Manager
9. Exercise: Secure your Virtual Hub using Azure Firewall Manager
10. Implement a Web Application Firewall
11. Summary and resources

Persistent infrastructure changes are Terraform-managed in the same `blueharbor/terraform/` root. CLI, Portal and diagnostic tools validate the resulting security behaviour.
