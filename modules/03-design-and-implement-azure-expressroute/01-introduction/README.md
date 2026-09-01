# Unit 01 — Introduction

**Microsoft Learn Module 3:** Design and implement Azure ExpressRoute  
**BlueHarbor chapter:** VPN works, so why change it?  
**Status:** NOT STARTED

## Business event

BlueHarbor already has working Site-to-Site and Point-to-Site connectivity from Module 2. Engineering, manufacturing and ERP workloads have now become important enough to trigger an enterprise-connectivity review.

## Problem to solve

Decide whether selected workloads should continue to rely on Internet-based VPN as the primary path or use private enterprise connectivity through ExpressRoute.

## Mental model

```text
VPN
= encrypted tunnel across the public Internet

ExpressRoute
= private provider connectivity into Microsoft's network
```

Private connectivity and encryption are separate design properties. This unit establishes the decision criteria before ExpressRoute is treated as a solution.
