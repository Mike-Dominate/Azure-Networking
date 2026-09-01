# Unit 07 — Exercise: Deploy and configure Azure Firewall using the Azure portal

**BlueHarbor chapter:** Secure the AUE hub first and prove enforcement  
**Status:** NOT STARTED

Preserve the Microsoft exercise objectives—rules, route path, allow, deny and troubleshooting—but apply them to the cumulative AUE transit architecture.

Add:

```text
bhi-vhub-aue
  +-- azfw-bhi-aue
  +-- fwpol-bhi-global initial policy
```

Use a selected private flow to prove:

```text
correct path + allow rule -> success
correct path + deny rule  -> blocked
wrong path                -> firewall never sees packet
```

Required evidence:

- effective route / hub path;
- firewall policy/rule match;
- successful allowed flow;
- failed denied flow;
- destination/return-path reasoning.

Do not route public Application Gateway or telemetry Load Balancer subnets through a default firewall path that would break their ingress symmetry.

No teardown follows; `azfw-bhi-aue` remains for Units 08–11.
