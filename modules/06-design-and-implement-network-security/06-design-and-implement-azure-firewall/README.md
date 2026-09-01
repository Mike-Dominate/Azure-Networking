# Unit 06 — Design and implement Azure Firewall

**BlueHarbor chapter:** Design central enforcement inside the existing Virtual WAN  
**Status:** NOT STARTED

Do not create a second hub/firewall architecture.

Existing hubs:

```text
bhi-vhub-aue   10.200.0.0/22
bhi-vhub-sea   10.200.4.0/22
```

Target:

```text
fwpol-bhi-global
  |
  +-- azfw-bhi-aue
  +-- azfw-bhi-sea
```

Learn Microsoft's classic Azure Firewall deployment model where required, but BlueHarbor's persistent implementation uses the existing Virtual WAN secured-hub architecture.

## Critical routing distinction

```text
private/internal backend traffic
 -> candidate for secured-hub/firewall enforcement

public Application Gateway subnet
 -> requires supported direct public return-path design

public telemetry Load Balancer backend subnet
 -> requires symmetric public/NAT return-path design
```

A blanket `0.0.0.0/0 -> Firewall` across every subnet is forbidden.

A firewall only enforces packets that traverse it; a correct rule on the wrong path provides no enforcement.
