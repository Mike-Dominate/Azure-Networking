# Lab 02 Handoff — Azure Traffic Manager

Use this file to resume Lab 02 precisely from a new session.

## Status

- **Lab:** 02 — Azure Traffic Manager
- **State:** IN PROGRESS
- **Previous lab:** Lab 01 — Azure Load Balancer — COMPLETE
- **Current phase:** Manual build/validation/failure-recovery/Portal inspection complete; manual environment deleted; clean-state verification is next, then Terraform rebuild.
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

## Manual implementation completed

Resource group used:

```text
rg-az700-tm-global
```

### Real subscription constraint and architecture substitution

The source scenario used Linux App Service F1 plans. East US App Service plan creation failed because the subscription had zero regional App Service VM quota:

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

### Regional ACI endpoints used

```text
East US
Container: ci-az700-tm-eus
FQDN: az700-tm-eus-87004.eastus.azurecontainer.io
Initial public IP observed: 20.242.191.210
HTTP direct validation: VERIFIED

West Europe
Container: ci-az700-tm-weu
FQDN: az700-tm-weu-87004.westeurope.azurecontainer.io
Initial public IP observed: 20.8.44.51
HTTP direct validation: VERIFIED

Southeast Asia
Container: ci-az700-tm-sea
FQDN: az700-tm-sea-87004.southeastasia.azurecontainer.io
Initial public IP observed: 40.119.253.24
Public IP after stop/start recovery: 20.197.126.249
HTTP direct validation: VERIFIED
```

The Southeast Asia public IP changing after stop/start reinforced why the stable endpoint FQDN, not a transient ACI IP, should be the Traffic Manager target.

## Traffic Manager profile implemented

```text
Resource name: tm-az700-global
FQDN: az700-tm-md-87004.trafficmanager.net
Profile status: Enabled
Routing method: Geographic
Configured DNS TTL: 30 seconds
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

All three endpoints reached `Online` and `Enabled`.

## Geographic routing lessons proven

Initial mappings omitted Australia/Pacific. A workstation DNS lookup returned the Traffic Manager name but no eligible endpoint. This demonstrated that Geographic routing does not automatically choose the nearest endpoint for an unmapped geography.

`ep-sea` was then updated to include both:

```text
GEO-AS
GEO-AP
```

A subsequent lookup returned:

```text
Name:    az700-tm-sea-87004.southeastasia.azurecontainer.io
Address: 40.119.253.24
Aliases: az700-tm-md-87004.trafficmanager.net
```

HTTP through the Traffic Manager FQDN returned the ACI application successfully. Together, DNS + HTTP proved:

```text
client -> recursive resolver -> Traffic Manager DNS decision
       -> Southeast Asia endpoint returned
       -> client connects directly to ACI
```

Traffic Manager is not inline after DNS resolution.

## Failure and recovery exercise completed

The Southeast Asia container was deliberately stopped.

Azure confirmed:

```text
ci-az700-tm-sea  Stopped
```

Traffic Manager then showed:

```text
ep-eus  Online    Enabled
ep-weu  Online    Enabled
ep-sea  Degraded  Enabled
```

This demonstrated:

```text
EndpointStatus        = administrative participation
EndpointMonitorStatus = Traffic Manager's health observation
```

A fresh Google DNS query while `ep-sea` was degraded still returned the Southeast Asia endpoint. Geographic routing preserved the configured Australia/Pacific boundary instead of silently sending the client to Europe or North America.

HTTP through the Traffic Manager name then failed with:

```text
curl: (28) Connection timed out after 10014 milliseconds
```

This proved that a successful DNS answer does not guarantee application reachability and that Geographic routing should not be assumed to provide cross-geography failover.

The container was started again. HTTP immediately worked again and Traffic Manager subsequently returned all three endpoints to `Online`.

## DNS TTL investigation completed

Azure profile configuration showed:

```text
Configured TTL: 30 seconds
```

Direct query to an authoritative `trafficmanager.net` name server returned:

```text
Traffic Manager CNAME TTL: 30
```

The workstation's AdGuard recursive resolver returned:

```text
Traffic Manager CNAME TTL: 60
ACI endpoint A-record TTL: 300
```

Directly querying AdGuard reproduced the 60-second CNAME TTL, proving that the discrepancy was introduced in the recursive-resolution path rather than by the Traffic Manager configuration.

Engineering lesson:

```text
Traffic Manager configured TTL
        != necessarily
TTL ultimately presented by every recursive resolver
```

Also, a DNS chain can contain multiple records with independent TTLs.

## Portal inspection completed

Portal Overview confirmed:

```text
Profile: tm-az700-global
Location: global
Status: Enabled
Routing method: Geographic
Monitor status: Online
Endpoints: 3
```

Configuration confirmed:

```text
Routing method: Geographic
DNS TTL: 30 seconds
Monitor protocol: HTTP
Port: 80
Path: /
Probe interval: 30 seconds
Tolerated failures: 3
Probe timeout: 10 seconds
Expected status: default 200
```

Portal endpoint view confirmed all three External endpoints were `Enabled` and `Online`; `ep-sea` visibly contained both Asia and Australia/Pacific geographic mappings.

Important distinction reinforced:

```text
DNS TTL       = caching lifetime for DNS answers
Probe interval = cadence of Traffic Manager health checks
```

## Manual teardown completed

The manual environment was removed with:

```powershell
az group delete `
  --name rg-az700-tm-global `
  --yes `
  --no-wait
```

The command returned no output as expected with `--no-wait`. The learner verified in the Azure Portal that the resource group and manual resources were deleted.

## Immediate next action

Independently verify the resource group is absent before creating Terraform-managed resources:

```powershell
az group exists --name rg-az700-tm-global
```

Expected:

```text
false
```

After that:

```text
1. Sync local Git repository with GitHub checkpoint updates
2. Enter/create Lab 02 Terraform workspace
3. Teach the Terraform resource model before writing HCL
4. Build the ACI + Traffic Manager design in Terraform
5. terraform fmt
6. terraform validate
7. terraform plan
8. terraform apply
9. Independent Azure/DNS/HTTP validation
10. Repeat meaningful failure/recovery test
11. Confirm final no-change plan
12. Git/GitHub checkpoint
13. Create mandatory PNG/JPEG learning visuals reflecting actual ACI implementation
14. Create complete Lab 02 rebuild/practice PDF
15. Terraform destroy and independent Azure/state verification
16. Final learner explain-back
17. Mark Lab 02 COMPLETE
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
