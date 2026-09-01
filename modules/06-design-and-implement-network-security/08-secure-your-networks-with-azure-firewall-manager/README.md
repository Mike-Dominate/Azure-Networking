# Unit 08 — Secure your networks with Azure Firewall Manager

**BlueHarbor chapter:** Centralise the policy before securing the second region  
**Status:** NOT STARTED

AUE now has a real Azure Firewall enforcement point. SEA still needs the same security architecture without becoming an independent snowflake.

Mental model:

```text
Azure Firewall
= packet-processing enforcement

Firewall Manager / Firewall Policy
= management-plane governance and central policy
```

Approved policy model:

```text
fwpol-bhi-global
        |
        +-- azfw-bhi-aue
        +-- azfw-bhi-sea when Unit 09 adds SEA enforcement
```

Learn policy hierarchy/inheritance and secured-hub management concepts while preserving one cumulative security architecture.
