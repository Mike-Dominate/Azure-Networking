# BlueHarbor Industries — Module 4 Project Story

## Project — Build resilient Device Telemetry Ingest

**Microsoft Learn module:** Load balance non-HTTP(S) traffic in Azure  
**Status:** NOT STARTED  
**Terraform model:** extend the same cumulative `blueharbor/terraform/` state

## Starting point from Module 3

BlueHarbor already has a mature network and transport architecture. Module 4 does not redesign VPN, Virtual WAN or ExpressRoute.

## New business workload

```text
BlueHarbor Device Telemetry Ingest
Protocol: TCP
Service port: 9000
```

Field/customer equipment sends telemetry to BlueHarbor over the Internet.

---

## Chapter 01 — The network is up, but telemetry is down

Separate transport health from service health:

```text
client can reach Azure
        !=
application has a healthy backend
```

---

## Chapter 02 — Multiple backends need one service identity

Introduce frontend IP, backend pool, health probe and Layer 4 rule selection.

```text
client
  |
TCP/9000
  |
service frontend
  |
  +-- healthy backend
  +-- healthy backend
```

---

## Chapter 03 — Design the Australia East production service

Reuse:

```text
bhi-vnet-mfg-aue
  +-- snet-mfg-app   10.20.1.0/24
```

Add:

```text
vm-telemetry-aue-01
vm-telemetry-aue-02
pip-telemetry-aue
lb-telemetry-aue   Standard / public
TCP/9000 rule and health probe
minimal functional NSG
```

`snet-mfg-app` already has `nat-mfg-aue` from Module 1 for explicit backend-initiated outbound access.

---

## Chapter 04 — Prove backend failure does not equal service failure

Persistent resources are added to the same Terraform root.

```text
telemetry-aue-01  UNHEALTHY
telemetry-aue-02  HEALTHY
        -> regional service remains available
```

Validate with real TCP traffic and backend-health evidence.

---

## Chapter 05 — Regional resilience becomes the next requirement

If the entire AUE telemetry service is unavailable, BlueHarbor needs a second real regional endpoint.

Reuse:

```text
bhi-vnet-research-sea   10.30.0.0/16
```

Add:

```text
snet-telemetry-dr       10.30.3.0/24
vm-telemetry-sea-01
vm-telemetry-sea-02
pip-telemetry-sea
lb-telemetry-sea   Standard / public
TCP/9000 rule and health probe
nat-telemetry-sea
```

`nat-telemetry-sea` gives the public Load Balancer backends a deliberate outbound/return-path design rather than relying on implicit outbound connectivity.

Traffic Manager is then introduced as DNS-based global selection, not an application proxy.

---

## Chapter 06 — Prove regional endpoint failover

```text
tm-telemetry-global
  +-- Priority 1 -> AUE
  +-- Priority 2 -> SEA
monitor -> TCP/9000
```

Two distinct failures are tested:

```text
one backend fails
 -> Load Balancer handles the instance failure

whole regional service fails
 -> Traffic Manager changes DNS selection
```

DNS TTL and resolver/client caching affect observed cutover.

---

## Chapter 07 — Architecture review

Explain:

```text
GLOBAL
client DNS -> Traffic Manager -> selected regional endpoint

REGIONAL
client TCP/9000 -> Standard Public Load Balancer -> healthy backend
```

Module 4 reuses the existing BlueHarbor networks and adds application availability without replacing the transport architecture.

## Carry-forward into Module 5

The telemetry service remains non-HTTP(S). Module 5 introduces a separate Partner Hub application requiring regional and global Layer 7 delivery.
