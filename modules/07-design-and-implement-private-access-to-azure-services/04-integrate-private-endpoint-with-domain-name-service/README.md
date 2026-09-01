# Unit 04 — Integrate private endpoint with Domain Name Service

**BlueHarbor chapter:** Make existing DNS return the private service path  
**Status:** NOT STARTED

## Business event

A Private Endpoint can exist and still fail the intended architecture if clients resolve the service name to the wrong destination.

## Mental model

```text
client
  |
DNS query
  |
existing BlueHarbor DNS architecture
  |
Private DNS / appropriate resolution path
  |
private endpoint IP
  |
Private Endpoint
```

## Progressive dependency

This unit **extends Module 1 DNS**. Do not create an unrelated DNS environment solely for Private Endpoint testing.

Hybrid clients must also use the DNS path already designed for BlueHarbor's on-premises connectivity.

## Key failure

```text
Private Endpoint       healthy
routing                valid
private IP             present
DNS answer             wrong/public path
```

The correct troubleshooting target is name resolution, not random endpoint recreation.

## Explain-back

Be able to distinguish:

- endpoint provisioning;
- IP reachability;
- DNS resolution;
- service access policy.

A failure in any one can look like "Private Endpoint is broken" from the application perspective.
