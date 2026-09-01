# Unit 10 — Implement a Web Application Firewall

**BlueHarbor chapter:** Protect the Partner Hub at Layer 7  
**Status:** NOT STARTED

## Business event

Network-layer controls are in place, but the Partner Hub can still receive malicious HTTP(S) requests that are valid from an IP/port perspective.

## Layered model

```text
Internet
 -> DDoS / network controls
 -> HTTP(S)
 -> WAF
 -> web application
```

## Concepts to master

- WAF policy
- managed rule sets
- custom-rule concepts where applicable
- policy association
- Application Gateway WAF
- Front Door WAF
- Detection mode
- Prevention mode
- logging / rule-match reasoning

## Detection versus prevention

```text
Detection
rule match -> observe/log according to policy behaviour

Prevention
rule match -> enforce/block according to policy
```

## Design rule

Do not deploy WAF at every possible layer by habit. Decide whether Front Door, Application Gateway or a justified layered design is the correct application-security boundary.
