# Module 6 — Design and implement network security

**Microsoft Learn:** https://learn.microsoft.com/en-us/training/modules/design-implement-network-security-monitoring/

**BlueHarbor project:** Harden the BlueHarbor enterprise network  
**Status:** NOT STARTED

Module 6 continues directly from the global application-delivery architecture built in Module 5. BlueHarbor can connect users, sites and applications successfully; the new requirement is to prove that access is appropriately restricted and that the public and private environment is defensible.

The module is taught as one progressive security-hardening project:

```text
working network and applications
        -> security posture review
        -> Defender for Cloud recommendations
        -> DDoS resilience for public services
        -> NSG / ASG segmentation
        -> central Azure Firewall inspection
        -> route traffic through firewall and prove policy
        -> centralise governance with Firewall Manager
        -> secure the existing Virtual WAN hub
        -> protect the Partner Hub with WAF
        -> layered security architecture review
```

Read [`PROJECT-STORY.md`](PROJECT-STORY.md) before starting the module.

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

## Story rule

Security controls are added only when a visible BlueHarbor requirement makes them necessary. The module does not reset the environment or create disconnected security labs.

## Cost rule

DDoS Protection, Azure Firewall and related enterprise security services can be materially billable. Before practical deployment, verify current Azure pricing/service behaviour, plan evidence capture, and tear down promptly when persistence is not required.
