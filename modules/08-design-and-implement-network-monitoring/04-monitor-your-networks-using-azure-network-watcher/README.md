# Unit 04 — Monitor your networks using Azure Network Watcher

**BlueHarbor chapter:** Diagnose the complete enterprise network with evidence  
**Status:** NOT STARTED

## Business event

Azure Monitor can tell Operations that something is degraded. The engineer now needs tools that answer **where** the network path is failing.

This unit deliberately uses architecture created throughout Modules 1–7.

## Diagnostic scenarios

### Security decision

Manufacturing cannot reach Shared Services on an approved port.

Use security-flow/effective-rule diagnostics such as IP Flow Verify where applicable to determine whether the expected traffic is allowed or denied and which rule explains the decision.

### Routing decision

Manufacturing cannot reach an approved external service expected to traverse Azure Firewall.

```text
Manufacturing
  |
UDR
  |
Azure Firewall
  |
destination
```

Inspect the actual/effective next hop and route state instead of assuming the UDR behaves as intended.

### Critical connection monitoring

Monitor important existing paths such as application-to-private-service connectivity where supported by the chosen endpoint architecture. Use recurring connection evidence rather than relying solely on one-time manual tests.

### VNet flow logs

For the new BlueHarbor implementation use **VNet flow logs**, not a design that depends on creating new NSG flow logs.

Flow evidence answers questions such as:

```text
who communicated with whom?
which port/protocol?
what traffic patterns exist?
```

### Traffic Analytics

Use analytics to move from individual flow records toward operational patterns such as top talkers, unexpected conversations and traffic trends.

### Packet capture

Use packet capture as a deeper diagnostic when health, DNS, route, security and flow evidence do not sufficiently isolate the issue.

## Troubleshooting ladder

```text
1. health
2. metrics / alerts
3. DNS
4. connectivity test
5. NSG / firewall decision
6. route / next hop
7. VNet flow evidence / analytics
8. packet capture when justified
```

The learner should choose the next tool based on the unanswered question, not randomly click through diagnostics.

## Terraform role

Provision persistent monitoring configuration through the same Terraform root. Diagnostic queries and investigations may use Azure CLI/Portal/Network Watcher tools against that Terraform-managed estate.
