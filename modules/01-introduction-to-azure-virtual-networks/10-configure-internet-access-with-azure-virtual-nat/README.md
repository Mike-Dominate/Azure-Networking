# Unit 10 — Configure internet access with Azure Virtual NAT

## BlueHarbor chapter: Selected private workloads need a controlled Internet exit

**Status:** NOT STARTED

Selected Manufacturing workload subnet(s) need outbound Internet access for approved updates/services, but Security does not want individual public IP addresses on those workloads.

NAT Gateway becomes the managed subnet-level outbound solution.

```text
outbound Internet access != unsolicited inbound access
```

## Terraform guardrail

Associate NAT Gateway only with explicitly selected workload subnets.

Do **not** implement a generic rule such as "attach NAT to every subnet in every VNet". Later modules add special-purpose subnets such as `GatewaySubnet`, DNS resolver endpoint subnets and application/security subnets that require their own design.

The selected NAT configuration remains part of the cumulative state entering Module 2.
