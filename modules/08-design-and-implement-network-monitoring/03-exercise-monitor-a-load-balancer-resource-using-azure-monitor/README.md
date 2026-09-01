# Unit 03 — Exercise: Monitor a load balancer resource using Azure Monitor

**BlueHarbor chapter:** Detect a real telemetry backend failure  
**Status:** NOT STARTED

## Exact Microsoft-exercise target

Use the existing Module 4 primary Load Balancer:

```text
lb-telemetry-aue
```

Do not create a replacement Load Balancer.

## Two different health questions

Correlate:

```text
Health Probe Status / DipAvailability
 -> are the backends responding to the configured probe?

Data Path Availability / VipAvailability
 -> is the Load Balancer data path itself available?
```

Do not treat these as interchangeable signals.

## Controlled incident

```text
START
telemetry-aue-01 HEALTHY
telemetry-aue-02 HEALTHY

FAULT
telemetry-aue-02 UNHEALTHY

EXPECTED
regional service can remain available through telemetry-aue-01
Health Probe Status degrades
Data Path Availability may remain healthy
alert/metric evidence identifies the backend condition
```

## Evidence chain

```text
failure
 -> metric/alert signal
 -> backend-health investigation
 -> root cause
 -> restoration
 -> metric recovery
```

Attach persistent monitoring/alerts to the existing cumulative resource. A Terraform apply alone is not evidence; create and observe the fault.
