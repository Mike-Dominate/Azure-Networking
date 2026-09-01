# Unit 02 — Monitor your networks using Azure Monitor

**BlueHarbor chapter:** Establish the central telemetry and alerting layer  
**Status:** NOT STARTED

## Business event

Operations cannot depend on engineers opening individual Azure resources one at a time to discover failures.

BlueHarbor introduces a central monitoring model across the environment already built.

## Mental model

```text
existing Azure resources
        |
telemetry
        |
Azure Monitor
   /          \
metrics       logs
                 |
           Log Analytics
        |
alerts / queries / investigation
```

## Evidence distinction

```text
metric -> numerical behavior over time
log    -> event/detail record
flow   -> observed network communication pattern
health -> component/service availability signal
```

Use the evidence type that matches the troubleshooting question.

## Terraform delta

Extend the existing stack with only the monitoring resources/configuration justified by the final design, for example:

```text
Log Analytics workspace
diagnostic settings
metric/log alerts
action groups
supporting monitoring configuration
```

The architecture audit determines exact dependencies before implementation.

## Alert mental model

```text
signal
  -> condition
  -> alert rule
  -> action group / response
```

Module 8 should turn earlier infrastructure failures into observable events rather than simply adding monitoring resources for completion credit.
