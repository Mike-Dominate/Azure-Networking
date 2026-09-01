# Unit 03 — Configure Azure Application Gateway

**BlueHarbor chapter:** Route Partner Hub requests intelligently  
**Status:** NOT STARTED

## Routing contract

```text
/engineering/* -> Engineering backend/pool
/orders/*      -> Orders backend/pool
/support/*     -> Support backend/pool
```

Use the Australia East landing zone already designed in Unit 02.

## Concepts to master

- listeners;
- path-based request-routing rules;
- multi-site/hostname routing where practical;
- backend pools/settings;
- custom health probes;
- host-header behaviour;
- TLS termination versus end-to-end TLS.

A backend can have valid IP connectivity and still fail because of HTTP host, TLS, backend-setting or health-path configuration.

## Hostname/TLS guardrail

`portal.blueharbor.example` is the narrative name, not a real domain we claim to control. The live practical uses Azure-generated endpoint names and suitable lab TLS material unless a real public domain is deliberately supplied later.
