# Lab 02 Handoff — Azure Traffic Manager

Use this file to resume Lab 02 precisely from a new session.

## Status

- **Lab:** 02 — Azure Traffic Manager
- **State:** IN PROGRESS
- **Previous lab:** Lab 01 — Azure Load Balancer — COMPLETE
- **Current phase:** Manual Traffic Manager build and DNS validation
- **Last updated:** 2026-08-30 (Australia/Brisbane)

## Current live checkpoint

The Traffic Manager mental model has been taught and correctly explained back by the learner.

Key distinction understood:

```text
Azure Load Balancer
= regional Layer-4 flow distribution
= sits in the application/network data path

Azure Traffic Manager
= global DNS-based traffic steering
= does not proxy the application connection
= after DNS resolution the client connects directly to the selected endpoint
```

Important correction taught:

```text
Geographic routing != closest endpoint
Performance routing  = latency-oriented selection
Geographic routing   = explicit geography-to-endpoint mapping
```

## Manual environment currently deployed

Resource group:

```text
rg-az700-tm-global
```

The original source scenario used Linux App Service F1 plans in East US, West Europe and Southeast Asia.

A real subscription constraint was encountered:

```text
az appservice plan create ... --sku F1 --location eastus
-> Operation cannot be completed without additional quota
-> Current Limit (Total VMs): 0
-> Amount required: 1
```

The failed operation left no App Service plan behind; this was independently verified with:

```powershell
az appservice plan list --resource-group rg-az700-tm-global -o table
```

The lab therefore made a deliberate, documented architecture substitution that preserves the Traffic Manager learning objective:

```text
Azure Container Instances
+ public FQDNs
+ Traffic Manager External endpoints
```

### Regional endpoints

```text
East US
Container: ci-az700-tm-eus
FQDN: az700-tm-eus-87004.eastus.azurecontainer.io
Public IP observed: 20.242.191.210
HTTP: VERIFIED

West Europe
Container: ci-az700-tm-weu
FQDN: az700-tm-weu-87004.westeurope.azurecontainer.io
Public IP observed: 20.8.44.51
HTTP: VERIFIED

Southeast Asia
Container: ci-az700-tm-sea
FQDN: az700-tm-sea-87004.southeastasia.azurecontainer.io
Public IP observed: 40.119.253.24
HTTP: VERIFIED
```

Each endpoint was validated directly with `curl.exe` before Traffic Manager was introduced.

## Traffic Manager profile

```text
Resource name: tm-az700-global
FQDN: az700-tm-md-87004.trafficmanager.net
Profile status: Enabled
Routing method: Geographic
DNS TTL: 30 seconds
Monitor: HTTP / port 80 / path /
```

External endpoints:

```text
ep-eus -> East US container
  GEO-NA -> North America

ep-weu -> West Europe container
  GEO-EU -> Europe

ep-sea -> Southeast Asia container
  GEO-AS -> Asia
  GEO-AP -> Australia/Pacific
```

All three endpoint monitors reached:

```text
Health: Online
Status: Enabled
```

## Geographic-routing failure discovered and fixed

The first DNS lookup from the learner's workstation used this recursive resolver:

```text
dns.adguard-dns.com
94.140.14.14
```

Initial mappings were only:

```text
GEO-NA -> East US
GEO-EU -> West Europe
GEO-AS -> Southeast Asia
```

Australia/Pacific was not mapped.

Observed result:

```powershell
nslookup az700-tm-md-87004.trafficmanager.net
```

returned the Traffic Manager name but no endpoint address.

This demonstrated an important Geographic-routing behavior: an unmapped geography can receive no eligible endpoint rather than being sent automatically to the nearest region.

The Southeast Asia endpoint was corrected to include:

```text
GEO-AS
GEO-AP
```

After the endpoint returned to `Online`, the same lookup produced:

```text
Name:    az700-tm-sea-87004.southeastasia.azurecontainer.io
Address: 40.119.253.24
Aliases: az700-tm-md-87004.trafficmanager.net
```

This is the first successful end-to-end proof that the Traffic Manager profile is steering the learner's DNS query to the Southeast Asia endpoint via the Australia/Pacific geographic mapping.

## Immediate next action

Validate application access through the Traffic Manager FQDN itself:

```powershell
curl.exe http://az700-tm-md-87004.trafficmanager.net
```

Then continue with:

```text
1. Interpret direct endpoint vs Traffic Manager FQDN access
2. Capture/inspect DNS TTL behavior
3. Perform endpoint-health failure/recovery test
4. Observe Geographic-routing behavior during endpoint failure
5. Portal inspection
6. Record evidence and lessons
7. Tear down manual environment if appropriate
8. Terraform rebuild
9. Independent validation
10. no-change plan
11. Git/GitHub checkpoint
12. rebuild/practice PDF
13. Terraform destroy and final verification
14. final learner explain-back
15. mark Lab 02 COMPLETE
```

## Working rules that must not drift

- Azure only.
- Maximum one lab per day.
- VS Code is the primary engineering workspace.
- Azure CLI is preferred for manual deployment, inspection and validation.
- Terraform follows understanding; it does not replace learning Azure.
- Teach concepts before testing comprehension.
- Explain important command/HCL syntax before execution.
- Work one meaningful action at a time during interactive learning.
- Interpret actual output before continuing.
- Use Azure Portal for inspection/troubleshooting, not as the sole deployment mechanism.
- Create reusable PNG/JPEG visual learning assets.
- Validate real Azure state independently after Terraform apply.
- Include real failure/recovery exercises.
- Record unexpected Azure behavior rather than hiding it.
- Never commit credentials, Terraform state, tokens, private keys, certificates or sensitive local `.tfvars`.
- End practical labs with a detailed rebuild/practice PDF sufficient to repeat the lab without chat history.

## Mandatory Lab 02 visual assets

```text
labs/02-traffic-manager/visual-learning/Lab02-01-Traffic-Manager-DNS-Mental-Model.png
labs/02-traffic-manager/visual-learning/Lab02-02-Geographic-Routing-Flow.png
labs/02-traffic-manager/visual-learning/Lab02-03-Endpoint-Health-and-DNS-Behaviour.png
labs/02-traffic-manager/visual-learning/Lab02-04-Final-Lab-Architecture.png
```

## Core mental model

```text
Client
  ↓
Recursive DNS resolver
  ↓
Traffic Manager profile FQDN
  ↓
Traffic Manager evaluates routing method + endpoint health
  ↓
DNS answer points toward selected endpoint
  ↓
Client connects DIRECTLY to selected application endpoint
```

Traffic Manager is not inline on the final HTTP/HTTPS connection.
