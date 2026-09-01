# Unit 09 — Improve data path performance between networks with ExpressRoute FastPath

**BlueHarbor chapter:** Shorten selected data paths  
**Status:** NOT STARTED

## Business event

A latency-sensitive manufacturing or engineering workload requires a more direct supported ExpressRoute data path.

## Normal model

```text
On-premises
 -> ExpressRoute
 -> ExpressRoute Gateway
 -> Azure workload
```

## FastPath model

```text
Gateway remains important to the control/routing architecture

Supported data traffic
On-premises
 -> ExpressRoute
 -> Azure workload
```

## Concepts to master

- FastPath purpose
- control plane versus data plane
- supported traffic/path behaviour
- gateway role after FastPath is enabled

'FastPath is faster' is not a sufficient explanation. The learner must explain what changes in the data path.
