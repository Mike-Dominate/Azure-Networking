# Unit 01 — Introduction

**BlueHarbor chapter:** Partner Hub creates the first HTTP(S)-aware delivery problem  
**Status:** NOT STARTED

## Starting estate

Everything from Modules 1–4 remains deployed, including the TCP/9000 telemetry architecture. Partner Hub is a **new and separate** web application.

Narrative request:

```text
GET /engineering/
Host: portal.blueharbor.example
```

The new decision depends on application-layer information rather than only IP, protocol and port.

```text
Layer 4
IP + protocol + port

Layer 7
HTTP host + URL path + application/TLS behaviour
```

This creates the reason for Azure Application Gateway.

`portal.blueharbor.example` is documentation-only; live lab access initially uses Azure-generated reachable endpoints unless a real learner-controlled domain is intentionally supplied.
