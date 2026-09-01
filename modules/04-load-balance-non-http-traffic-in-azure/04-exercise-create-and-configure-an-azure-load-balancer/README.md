# Unit 04 — Exercise: Create and configure an Azure load balancer

**BlueHarbor chapter:** Prove the service survives a backend failure  
**Status:** PRACTICAL COMPLETE — Microsoft Learn review pending

## Existing evidence

The completed Azure Load Balancer engineering practical is preserved in `practical/` and includes deployment, CLI validation, Terraform, health testing, NSG/outbound behaviour, visual material and rebuild/teardown evidence.

## Review workflow

When Module 4 is reached formally:

1. complete Units 01–03 in Microsoft Learn order;
2. compare the current Microsoft Unit 04 objective with the existing practical;
3. reuse valid evidence;
4. fill only genuine gaps.

## Failure mental model

```text
VM01 healthy
VM02 unhealthy
VM03 healthy
```

Explain why the Load Balancer stops selecting the unhealthy backend for new eligible flows, and why breaking the health-probe path can make a running application appear unavailable to the Load Balancer.
