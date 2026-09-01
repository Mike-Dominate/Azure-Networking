# Unit 02 — Design Azure Application Gateway

**BlueHarbor chapter:** Build the regional web entrance  
**Status:** NOT STARTED

## Business event

BlueHarbor needs one controlled HTTP(S) entry point in Australia East for multiple Partner Hub services.

## Architecture

```text
Internet
   |
HTTPS
   |
Application Gateway
   |
+-- Engineering pool
+-- Orders pool
+-- Support pool
```

## Concepts to master

- frontend IP
- listener
- routing rule
- backend pool
- backend setting
- health probe
- TLS concepts
- public versus private frontend
- Application Gateway subnet placement

The design starts from application requirements: who connects, what host/path they request, where TLS terminates and which backend should process the request.
