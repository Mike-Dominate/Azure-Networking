# Unit 06 — Exercise: Create a Traffic Manager profile using the Azure portal

**BlueHarbor chapter:** Test global endpoint selection and regional failure  
**Status:** PRACTICAL COMPLETE — Microsoft Learn review pending

## Existing evidence

The completed Traffic Manager engineering practical is preserved in `practical/` and includes multiple regional endpoints, geographic routing, health monitoring, DNS behaviour, CLI validation, Terraform, failure testing, visuals and rebuild/teardown evidence.

## Critical lessons already evidenced

```text
endpoint health != endpoint eligibility
```

A healthy endpoint is not automatically eligible for a DNS request if the configured routing policy does not map that request to it.

Likewise, endpoint degradation does not cause Traffic Manager to ignore the routing method and choose an arbitrary healthy endpoint.

## DNS timing mental model

```text
endpoint failure
 -> monitoring detects change
 -> future DNS decisions change according to policy
 -> cached answers may persist until TTL/cache expiry
 -> client queries again
 -> newly eligible endpoint can be returned
```

When Module 4 is reached formally, review this evidence against the current Microsoft exercise and fill only genuine gaps.
