# Unit 04 — Exercise: Deploy Azure Application Gateway

**BlueHarbor chapter:** Build and break the regional Partner Hub path  
**Status:** NOT STARTED

## Story-first practical

Build this unit fresh when reached in sequence. The practical must fit the BlueHarbor architecture created by earlier modules.

## Target behaviour

```text
Client -> Application Gateway -> healthy regional backend
```

## Required validation/failure work

- validate listener/rule/pool/probe relationships;
- generate real HTTP(S) requests;
- stop one backend and prove healthy backends continue serving traffic;
- break the configured health path and inspect backend health;
- introduce one HTTP-layer configuration error such as host-header/backend-setting mismatch;
- diagnose the failure without blaming the network blindly;
- reproduce with Azure CLI and Terraform where appropriate;
- capture evidence and tear down safely.
