# Final Curriculum / Architecture QA

**Date:** September 2, 2026  
**Scope:** final pre-implementation review after Gates 1–7 and whole-programme architecture closeout  
**Status:** PASS after corrections in this commit

## Why this pass existed

The transition gates proved that each module handed cleanly into the next. The whole-programme closeout proved addressing, naming, DNS, state, subnet and ownership consistency.

This final pass looked for a different class of defect:

- stale pre-BlueHarbor workflow instructions;
- current AZ-700 objectives that do not appear as visible Microsoft Learn exercises;
- Azure features that are individually valid but would bypass the final security topology;
- external prerequisites that could be accidentally presented as completed live configuration;
- current service limitations that could make a later practical dishonest.

## Findings and corrections

### 1. Stale CLI-first / rebuild / teardown workflow — FIXED

`SOURCE-REFERENCE.md` previously described an old pattern that included manual CLI implementation, a Terraform rebuild and safe teardown.

Authoritative rule is now identical to `WORKING-METHOD.md`:

```text
understand
 -> extend same Terraform root/state
 -> plan/apply
 -> independently validate with CLI/Portal/protocol tools
 -> troubleshoot
 -> reconcile permanent fix into Terraform
 -> Git checkpoint
 -> carry exact environment forward
```

No routine teardown.

### 2. July 27, 2026 AZ-700 skills coverage — FIXED

Created:

[`AZ700-STUDY-GUIDE-COVERAGE.md`](AZ700-STUDY-GUIDE-COVERAGE.md)

Every current study-guide capability now has:

- a Microsoft Learn/BlueHarbor home;
- a coverage mode;
- an explicit implementation/design/conditional treatment.

This prevents objectives such as Public IP Prefix, BYOIP, Azure Route Server, Azure Virtual Network Manager, Azure Extended Network, RADIUS, Gateway Load Balancer, inbound NAT/outbound LB rules, rewrite rules, Front Door caching/rules, Bastion and other extensions from being silently forgotten.

### 3. Azure Route Server / Virtual WAN conflict — GUARDED

Current Azure does not allow Route Server in a spoke VNet connected to a Virtual WAN hub.

Therefore Route Server is mandatory AZ-700 learning coverage, but BlueHarbor does not insert it into Core/Mfg/Research/Partner and break the cumulative vWAN design.

### 4. ExpressRoute Global Reach lifecycle — FIXED

Module 3 now makes the dependency explicit:

```text
Brisbane ExpressRoute circuit/path A
+
Perth ExpressRoute circuit/path B
        |
Global Reach
```

Global Reach is a valid Module 3 learning stage.

Module 6 later introduces a stricter requirement: centrally inspected private transit through the secured Virtual WAN hubs. Because Global Reach sends circuit-to-circuit traffic directly rather than through the hub security appliance, Module 6 intentionally disables Global Reach after the inspected path is proven.

If ER-to-ER transit through the secured hub requires Microsoft support enablement under the current service model, the lab records that dependency rather than pretending it is self-service.

### 5. Virtual WAN ExpressRoute FastPath — FIXED

The programme no longer says only “check eligibility.” It records the current specific rule:

```text
vWAN FastPath
 -> ExpressRoute Direct
 -> Virtual WAN ER Gateway >= 5 scale units
 -> enabled automatically for supported traffic
```

If BlueHarbor chooses a provider circuit, the learner explains why vWAN FastPath is not active rather than creating a disconnected second architecture just to tick the objective.

### 6. Front Door Private Link -> Application Gateway TLS — FIXED

Private-Link-enabled Application Gateway origins require Front Door certificate subject validation.

The narrative `.example` domain is not treated as a real trusted certificate identity.

The baseline private-origin lab proves Private Link with a supported origin protocol. True Front Door -> App Gateway HTTPS/end-to-end TLS is performed only when a real learner-controlled domain and matching trusted certificate chain are available.

No fake green TLS test.

## Final result

```text
STORY DESIGN                         COMPLETE
TRANSITION AUDIT GATES 1-7           PASS
WHOLE-PROGRAMME ARCHITECTURE         PASS
JULY-2026 STUDY-GUIDE COVERAGE       COMPLETE
FINAL CURRICULUM / ARCHITECTURE QA   PASS
IMPLEMENTATION READY                 YES
FORMAL EXECUTION POSITION            M1 U01 — Introduction
```

No further planning gate remains before Module 1 Unit 01.
