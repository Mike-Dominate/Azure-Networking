# Module 4 — Load balance non-HTTP(S) traffic in Azure

**Microsoft Learn:** https://learn.microsoft.com/en-us/training/modules/load-balancing-non-https-traffic-azure/

**BlueHarbor project:** Build resilient service delivery for BlueHarbor applications  
**Status:** PRIOR PRACTICALS COMPLETE — formal Microsoft Learn Unit 01–07 review pending

Module 4 continues from the connectivity work in Modules 1–3. BlueHarbor can reach Azure reliably, but a healthy network path does not protect an application from backend or regional service failure.

The module is taught as one progressive project:

```text
network path works but one backend fails
        -> distinguish reachability from availability
        -> explore load balancing
        -> design a regional Azure Load Balancer service
        -> reuse/review completed Load Balancer practical evidence
        -> expand the service to multiple regions
        -> introduce DNS-based Traffic Manager
        -> reuse/review completed Traffic Manager practical evidence
        -> explain regional versus global availability
```

Read [`PROJECT-STORY.md`](PROJECT-STORY.md) before starting the module.

## Microsoft Learn units

1. Introduction
2. Explore load balancing
3. Design and implement Azure load balancer using the Azure portal
4. Exercise: Create and configure an Azure load balancer
5. Explore Azure Traffic Manager
6. Exercise: Create a Traffic Manager profile using the Azure portal
7. Summary

## Existing engineering evidence

Completed Azure Load Balancer work is preserved under Unit 04:

`04-exercise-create-and-configure-an-azure-load-balancer/practical/`

Completed Azure Traffic Manager work is preserved under Unit 06:

`06-exercise-create-a-traffic-manager-profile-using-the-azure-portal/practical/`

These practicals are not automatically repeated. When Module 4 is reached in Microsoft Learn order, review them against the current unit objectives and fill only genuine gaps.
