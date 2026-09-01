# Unit 03 — Exercise: Monitor a load balancer resource using Azure Monitor

**BlueHarbor chapter:** Monitor the existing production telemetry service  
**Status:** NOT STARTED

## Microsoft objective, BlueHarbor implementation

Use the Load Balancer created earlier in Module 4. Do **not** create a replacement demonstration Load Balancer solely for this exercise.

```text
clients
  |
existing BlueHarbor Load Balancer
  |
+---------+
|         |
backend01 backend02
```

## Progressive learning

Module 4 proved that the service can survive an unhealthy backend.

Module 8 proves that Operations can **detect and investigate** that unhealthy backend.

## Failure experiment

```text
initial
backend01 healthy
backend02 healthy

controlled incident
backend01 unhealthy
backend02 healthy
```

Trace:

```text
failure
-> monitoring signal
-> alert/evidence
-> investigation
-> root cause
-> restoration
```

## Terraform rule

Attach monitoring configuration to the existing Load Balancer in the cumulative Terraform state. Previous Module 4 infrastructure must remain intact unless an intentional change is required.

## Validation

A successful Terraform apply is not proof. Generate/observe the actual failure condition and demonstrate that the expected monitoring evidence appears.
