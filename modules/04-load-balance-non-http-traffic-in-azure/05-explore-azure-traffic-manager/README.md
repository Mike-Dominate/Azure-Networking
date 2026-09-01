# Unit 05 — Explore Azure Traffic Manager

**BlueHarbor chapter:** The application becomes global  
**Status:** REVIEW PENDING

## Business event

BlueHarbor now has service endpoints in multiple regions and must decide which regional endpoint a client should use.

## Critical mental model

Traffic Manager is DNS-based endpoint selection and is not in the application data path.

```text
DNS decision
client -> resolver -> Traffic Manager -> endpoint answer

Application traffic
client ---------------------> selected endpoint
```

## Concepts to master

- Traffic Manager profile
- endpoint
- endpoint health
- DNS TTL and caching
- endpoint eligibility
- Priority, Weighted, Performance, Geographic, Subnet and Multivalue routing methods

Each routing method should be understood as a different business traffic-steering question rather than a name to memorise.
