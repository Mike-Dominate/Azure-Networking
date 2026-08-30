# Lab 02 Handoff — Azure Traffic Manager

Use this file to resume Lab 02 precisely from a new session.

## Status

- **Lab:** 02 — Azure Traffic Manager
- **State:** IN PROGRESS
- **Previous lab:** Lab 01 — Azure Load Balancer — COMPLETE
- **Current phase:** Manual Azure CLI build — endpoint failure/recovery testing
- **Last updated:** 2026-08-30 (Australia/Brisbane)

## Mental model already taught and understood

```text
Azure Load Balancer
= regional Layer-4 flow distribution
= sits in the application/network data path

Azure Traffic Manager
= global DNS-based traffic steering
= does not proxy the application connection
= after DNS resolution the client connects directly to the selected endpoint
```

Important distinction:

```text
Geographic routing != closest endpoint
Performance routing  = latency-oriented selection
Geographic routing   = explicit geography-to-endpoint mapping
```

The learner correctly explained that Traffic Manager participates in DNS steering but not the subsequent HTTP data path.

## Manual environment currently deployed

Resource group:

```text
rg-az700-tm-global
```

### Real subscription constraint and architecture substitution

The source scenario used Linux App Service F1 plans. The East US plan creation failed with:

```text
Operation cannot be completed without additional quota.
Current Limit (Total VMs): 0
Amount required: 1
```

No partial App Service plan remained; this was independently verified.

To preserve the Traffic Manager learning objective, the lab deliberately substituted:

```text
Azure Container Instances
+ public FQDNs
+ Traffic Manager External endpoints
```

### Regional ACI endpoints

```text
East US
Container: ci-az700-tm-eus
FQDN: az700-tm-eus-87004.eastus.azurecontainer.io
Public IP observed: 20.242.191.210
HTTP direct validation: VERIFIED

West Europe
Container: ci-az700-tm-weu
FQDN: az700-tm-weu-87004.westeurope.azurecontainer.io
Public IP observed: 20.8.44.51
HTTP direct validation: VERIFIED

Southeast Asia
Container: ci-az700-tm-sea
FQDN: az700-tm-sea-87004.southeastasia.azurecontainer.io
Public IP observed: 40.119.253.24
HTTP direct validation: VERIFIED before failure test
CURRENT STATE: STOPPED deliberately for failure test
```

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

Before failure testing all three endpoint monitors were `Online` and `Enabled`.

## Geographic-routing mapping lesson

The first DNS lookup used:

```text
dns.adguard-dns.com
94.140.14.14
```

Initially only GEO-NA, GEO-EU and GEO-AS were configured. Australia/Pacific was unmapped, so:

```powershell
nslookup az700-tm-md-87004.trafficmanager.net
```

returned the Traffic Manager name but no endpoint address.

The Southeast Asia endpoint was corrected to include both:

```text
GEO-AS
GEO-AP
```

After recovery to `Online`, DNS returned:

```text
Name:    az700-tm-sea-87004.southeastasia.azurecontainer.io
Address: 40.119.253.24
Aliases: az700-tm-md-87004.trafficmanager.net
```

Application access through the Traffic Manager FQDN was then successfully validated with `curl.exe`, proving end-to-end DNS steering plus direct client-to-endpoint HTTP connectivity.

## Failure test completed so far

The Southeast Asia container was deliberately stopped:

```powershell
az container stop --resource-group rg-az700-tm-global --name ci-az700-tm-sea
```

Azure state verification showed:

```text
ci-az700-tm-sea  Stopped
```

Traffic Manager endpoint state then showed:

```text
ep-eus  Online    Enabled
ep-weu  Online    Enabled
ep-sea  Degraded  Enabled
```

This demonstrates the difference between:

```text
EndpointStatus = administrative participation (Enabled/Disabled)
EndpointMonitorStatus = Traffic Manager health observation (Online/Degraded/etc.)
```

A fresh query through Google DNS while `ep-sea` was degraded still returned the Southeast Asia endpoint:

```powershell
nslookup az700-tm-md-87004.trafficmanager.net 8.8.8.8
```

Observed:

```text
Name:    az700-tm-sea-87004.southeastasia.azurecontainer.io
Address: 40.119.253.24
Aliases: az700-tm-md-87004.trafficmanager.net
```

This is a critical Geographic-routing lesson: the configured geographic boundary is preserved; Traffic Manager did not silently send the Australia/Pacific query to Europe or North America just because the mapped endpoint was unhealthy.

The application consequence was then proven with:

```powershell
curl.exe --max-time 10 http://az700-tm-md-87004.trafficmanager.net
```

Observed:

```text
curl: (28) Connection timed out after 10014 milliseconds
```

Therefore:

```text
DNS steering can still succeed
        +
Traffic Manager can know the mapped endpoint is degraded
        +
The final application connection can still fail
```

This reinforces that Traffic Manager is not an inline HTTP proxy and Geographic routing should not be assumed to provide cross-geography health failover.

## Immediate next action

Recover the deliberately stopped Southeast Asia container:

```powershell
az container start `
  --resource-group rg-az700-tm-global `
  --name ci-az700-tm-sea
```

Then, one meaningful action at a time:

```text
1. Verify the container is Running
2. Observe ep-sea health return from Degraded to Online
3. Re-test HTTP through the Traffic Manager FQDN
4. Inspect DNS TTL/caching behavior
5. Portal inspection
6. Record evidence and lessons
7. Manual teardown before Terraform rebuild where appropriate
8. Terraform implementation
9. fmt / validate / plan / apply
10. Independent Azure/DNS/HTTP validation
11. Failure/recovery test against Terraform build
12. final no-change plan
13. Git/GitHub checkpoint
14. complete rebuild/practice PDF
15. Terraform destroy and verification
16. final learner explain-back
17. mark Lab 02 COMPLETE
```

## Working rules that must not drift

- Azure only.
- Maximum one lab per day.
- VS Code is the primary engineering workspace.
- Prefer Azure CLI for manual deployment, inspection and validation.
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

The final architecture visual must reflect the actual ACI External-endpoint implementation used because of the App Service quota restriction, not the abandoned App Service design.
