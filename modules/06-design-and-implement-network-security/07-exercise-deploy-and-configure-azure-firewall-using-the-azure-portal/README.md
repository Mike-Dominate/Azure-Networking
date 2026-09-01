# Unit 07 — Exercise: Deploy and configure Azure Firewall using the Azure portal

**BlueHarbor chapter:** Force real traffic through the firewall and prove policy  
**Status:** NOT STARTED

## Expected flow

```text
Manufacturing workload
 -> UDR / effective route
 -> Azure Firewall
 -> matching rule
 -> allowed or denied destination
```

## Required proof

- inspect the effective route;
- prove the intended traffic traverses the firewall;
- prove at least one allowed flow;
- prove at least one denied flow;
- identify the rule/policy that explains each result.

## Deliberate failures

### Wrong route

Firewall policy is correct but the packet never reaches Azure Firewall.

### Wrong rule

Routing is correct but Azure Firewall denies the traffic.

Troubleshoot in order:

```text
route -> firewall path -> matching rule -> destination / return path
```

## Cost rule

Azure Firewall is materially billable. Plan the practical first, capture evidence live and tear it down promptly unless a following unit explicitly requires the same deployment.
