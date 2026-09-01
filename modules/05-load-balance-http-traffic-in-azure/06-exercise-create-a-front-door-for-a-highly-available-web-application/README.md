# Unit 06 — Exercise: Create a Front Door for a highly available web application

**BlueHarbor chapter:** Add global HTTP(S) delivery over the two real Partner Hub origins  
**Status:** NOT STARTED

## Existing origins

```text
Australia East
appgw-partner-aue Standard_v2

Southeast Asia
appgw-partner-sea Standard_v2
```

Do not create hypothetical or disposable origins for this exercise.

## Terraform delta

Add Azure Front Door Standard to the same state:

```text
Front Door Standard
  |
origin group
  +-- AUE Application Gateway public origin
  +-- SEA Application Gateway public origin
  |
routes / health probes
```

## Required practical behaviour

- validate origins/origin group/routes;
- test normal HTTP(S) delivery;
- fail one regional origin;
- observe origin health and Front Door routing behaviour;
- compare this directly with Module 4 Traffic Manager DNS failover;
- troubleshoot one route/origin/host configuration error.

## Deliberate security boundary

Application Gateway origins are public in Module 5 so the delivery architecture is visible and testable. Gate 5/Module 6 must decide how to prevent or control direct origin bypass and where WAF enforcement belongs.

No teardown follows; Front Door and both regional Partner Hub stacks remain deployed.
