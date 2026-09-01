# Unit 11 — Summary and resources

**BlueHarbor chapter:** Layered security architecture review  
**Status:** NOT STARTED

## Final mental model

```text
Defender for Cloud
-> posture / recommendations

DDoS Protection
-> public network availability

NSG / ASG
-> distributed segmentation

Azure Firewall
-> central routed enforcement

Firewall Manager
-> central firewall governance

WAF
-> HTTP(S) request protection
```

## Explain-back incidents

### Manufacturing cannot reach an approved external API

Investigate the correct chain:

```text
DNS -> NSG -> effective route -> Azure Firewall -> matching rule -> destination/return path
```

### Partner Hub returns WAF 403

Investigate:

```text
Front Door / Application Gateway
 -> WAF policy
 -> matching rule
 -> Detection / Prevention mode
 -> origin/backend
```

### Public service receives a volumetric network attack

Identify the attack layer before selecting a control; do not automatically treat every Internet attack as a WAF problem.

## Module exit condition

The learner can explain why each BlueHarbor security control exists, where it sits in the path, what it protects and how to troubleshoot it.

The next security question is why PaaS services that only need private application access should remain exposed through public endpoints. That leads into Module 7 — Design and implement private access to Azure Services.
