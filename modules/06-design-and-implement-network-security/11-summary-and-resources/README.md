# Unit 11 — Summary and resources

**BlueHarbor chapter:** Layered security architecture review  
**Status:** NOT STARTED

## Final model

```text
Defender for Cloud
-> posture / recommendations / attack-path visibility

DDoS Network Protection
-> eligible public-IP resources through protected VNets

NSG / ASG
-> distributed workload segmentation

Azure Firewall in secured Virtual WAN hubs
-> central routed enforcement

Firewall Manager / Firewall Policy
-> central governance

Front Door Premium + WAF
-> global HTTP(S) protection

Application Gateway WAF_v2
-> regional HTTP(S) origin protection
```

## Route-aware explain-back

Be able to explain why:

- a firewall cannot inspect traffic that bypasses it;
- public Application Gateway and public Load Balancer paths require deliberate symmetric return paths;
- Partner app NAT egress is retired when firewall-controlled egress becomes authoritative;
- telemetry NAT remains because of its public Load Balancer service path;
- direct VNet peerings are retired when they would bypass centrally inspected private transit;
- WAF, DDoS Protection, NSGs and Azure Firewall solve different security problems;
- origin restrictions are needed even when Front Door has WAF.

## Handoff to Module 7

The network is now segmented, centrally inspected and web-hardened. Module 7 can introduce private PaaS access into this exact security/routing/DNS estate without creating a new VNet.
