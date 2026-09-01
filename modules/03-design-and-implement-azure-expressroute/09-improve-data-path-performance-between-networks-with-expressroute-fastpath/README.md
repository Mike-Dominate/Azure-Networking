# Unit 09 — Improve data path performance between networks with ExpressRoute FastPath

**BlueHarbor chapter:** Evaluate and use FastPath only if the cumulative ExpressRoute design is eligible  
**Status:** NOT STARTED

## Dependency

Unit 03 must already have recorded the chosen ExpressRoute connectivity model and gateway design.

Do not create another ExpressRoute architecture simply to demonstrate FastPath.

## Mental model

```text
control/routing architecture
still includes the ExpressRoute gateway

supported FastPath data traffic
can use a more direct supported path to the Azure workload
```

## Engineering rule

First verify whether BlueHarbor's actual provider/ExpressRoute Direct and Virtual WAN gateway combination supports the required FastPath behaviour.

If it does, implement/validate it in the same architecture. If it does not, explain the supported reference design and the exact eligibility gap instead of falsely claiming activation.

'FastPath is faster' is not a sufficient explanation; describe the control-plane and data-plane difference.
