# Unit 03 — Configure Azure Application Gateway

**BlueHarbor chapter:** Route Partner Hub requests intelligently  
**Status:** NOT STARTED

## Business requirements

```text
/engineering/* -> Engineering backend
/orders/*      -> Orders backend
/support/*     -> Support backend
```

BlueHarbor may also use hostname-based routing such as:

```text
engineering.blueharbor.example
orders.blueharbor.example
support.blueharbor.example
```

## Concepts to master

- path-based routing
- multi-site / hostname routing
- listeners
- rules
- backend pools/settings
- custom health probes
- TLS termination versus end-to-end TLS
- host-header/backend-setting behaviour

A backend can have perfect IP connectivity and still fail because the HTTP configuration or health check is wrong.
