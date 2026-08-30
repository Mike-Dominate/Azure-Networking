# Lab 02 Handoff — Azure Traffic Manager

Use this file to resume Lab 02 precisely from a new session.

## Status

- **Lab:** 02 — Azure Traffic Manager
- **State:** IN PROGRESS
- **Previous lab:** Lab 01 — Azure Load Balancer — COMPLETE
- **Current phase:** Manual Azure phase COMPLETE and fully documented; Azure environment is clean; Terraform rebuild is NEXT.
- **Last updated:** 2026-08-30 (Australia/Brisbane)

## Resume point — do not repeat the manual build

The complete manual Traffic Manager phase has already been performed, validated, troubleshot, documented, and torn down.

Do **not** rebuild the manual environment during normal programme progression.

The next phase is:

```text
Terraform rebuild of the validated ACI + Traffic Manager architecture
```

Before starting Terraform on the learner workstation, sync the repository:

```powershell
git pull --rebase
```

Then enter the Lab 02 Terraform workspace and teach the Terraform resource model before writing HCL.

---

## Core mental model already taught and understood

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

---

## Manual architecture that was validated

The source exercise intended to use Linux App Service F1 endpoints in East US, West Europe and Southeast Asia.

During deployment, East US App Service plan creation failed because this subscription had zero App Service VM quota:

```text
Operation cannot be completed without additional quota.
Current Limit (Total VMs): 0
Amount required: 1
```

No partial App Service plan remained after the failed operation.

The lab therefore deliberately preserved the Traffic Manager learning objective by substituting:

```text
Azure Container Instances
+ public regional ACI FQDNs
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

The Southeast Asia public IP changing after stop/start reinforced why the stable FQDN, rather than an observed ACI public IP, was used as the Traffic Manager target.

---

## Traffic Manager profile validated

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

All three endpoint monitors reached `Online` while healthy.

---

## Geographic-routing failure and correction

The first geographic design mapped only:

```text
GEO-NA -> East US
GEO-EU -> West Europe
GEO-AS -> Southeast Asia
```

An Australian lookup through the learner's recursive resolver returned the Traffic Manager name but no eligible endpoint.

This proved that Geographic routing is not a nearest-region algorithm and that an unmapped geography is not automatically sent elsewhere.

The Southeast Asia endpoint was corrected to include:

```text
GEO-AS
GEO-AP
```

A subsequent Australian lookup returned:

```text
Name:    az700-tm-sea-87004.southeastasia.azurecontainer.io
Address: 40.119.253.24
Aliases: az700-tm-md-87004.trafficmanager.net
```

HTTP through the Traffic Manager FQDN then succeeded.

Together the DNS and HTTP tests proved:

```text
client
  -> recursive DNS resolver
  -> Traffic Manager geographic DNS decision
  -> DNS answer points to Southeast Asia endpoint
  -> client connects DIRECTLY to the ACI endpoint
```

---

## Endpoint failure and recovery exercise completed

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

This demonstrated the difference between:

```text
EndpointStatus        = administrative participation
EndpointMonitorStatus = Traffic Manager's health observation
```

A fresh query through Google DNS while `ep-sea` was degraded still returned the Southeast Asia endpoint for the Australia/Pacific mapping.

Traffic Manager did **not** silently send the query to Europe or North America.

HTTP through the Traffic Manager name then failed with:

```text
curl: (28) Connection timed out after 10014 milliseconds
```

This is a critical Lab 02 lesson:

```text
Geographic mapping can continue to identify the mapped endpoint
+
Traffic Manager can know that endpoint is degraded
+
The final application connection can still fail
```

Geographic routing must not be assumed to provide cross-geography health failover.

The container was started again; HTTP recovered and all three endpoints returned to `Online`.

---

## DNS TTL investigation completed

Azure configuration showed:

```text
Traffic Manager configured TTL: 30 seconds
```

A direct query to an authoritative `trafficmanager.net` server returned:

```text
Traffic Manager CNAME TTL: 30
```

The workstation's AdGuard recursive resolver returned:

```text
Traffic Manager CNAME TTL: 60
ACI endpoint A-record TTL: 300
```

Directly querying AdGuard reproduced the 60-second CNAME value, proving that the discrepancy appeared in the recursive-resolution layer rather than in the Traffic Manager profile itself.

Engineering lesson:

```text
Configured authoritative TTL
        != necessarily
TTL ultimately presented by every recursive resolver
```

A DNS resolution chain can also contain multiple records with independent TTLs.

---

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

The Endpoints view confirmed all three were External endpoints and `ep-sea` contained both Asia and Australia/Pacific mappings.

Important timer distinction:

```text
DNS TTL        = DNS answer caching lifetime
Probe interval = Traffic Manager endpoint-health check cadence
```

---

## Manual teardown and clean-state proof completed

The manual resource group was deleted with:

```powershell
az group delete `
  --name rg-az700-tm-global `
  --yes `
  --no-wait
```

Portal inspection confirmed deletion.

Independent Azure CLI verification then returned:

```powershell
az group exists --name rg-az700-tm-global
```

```text
false
```

Therefore the Terraform phase starts from a clean Azure environment rather than colliding with manually created resources.

---

## Manual documentation is now at Lab 01 standard

Detailed command-by-command documentation is committed under:

```text
labs/02-traffic-manager/manual-deployment/README.md
labs/02-traffic-manager/manual-deployment/DEPLOYMENT-WALKTHROUGH.md
```

The walkthrough records the actual commands and observed behavior, including:

- Azure context/provider checks
- resource-group creation
- failed App Service F1 attempt and quota diagnosis
- verification that no partial App Service plan remained
- ACI fallback decision
- three ACI endpoint deployments and direct HTTP tests
- Traffic Manager profile creation
- all External endpoint commands
- Geographic mappings including the GEO-AP correction
- DNS and HTTP validation
- stop/degrade/timeout failure test
- recovery test
- DNS TTL authoritative-versus-recursive investigation
- Portal inspection findings
- manual teardown
- final `az group exists` clean-state proof

---

## Required visual-learning assets are committed

```text
labs/02-traffic-manager/visual-learning/Lab02-01-Traffic-Manager-DNS-Mental-Model.png
labs/02-traffic-manager/visual-learning/Lab02-02-Geographic-Routing-Flow.png
labs/02-traffic-manager/visual-learning/Lab02-03-Endpoint-Health-and-DNS-Behaviour.png
labs/02-traffic-manager/visual-learning/Lab02-04-Final-Lab-Architecture.png
```

The visuals deliberately reflect the **actual ACI External-endpoint implementation**, not the abandoned App Service design.

Visual 03 explicitly records the observed Geographic-routing failure behavior and does **not** invent cross-geography failover.

---

## Immediate next action

Do not repeat manual deployment.

On the learner workstation:

```powershell
git pull --rebase
```

Then begin the Terraform phase using this teaching sequence:

```text
1. Inspect/create labs/02-traffic-manager/terraform/
2. Teach which Terraform resources represent the Azure objects already understood manually
3. Teach references and dependency relationships before writing HCL
4. Build the three regional ACI endpoints
5. Build the Geographic Traffic Manager profile and External endpoints
6. terraform fmt
7. terraform validate
8. terraform plan
9. inspect the plan before apply
10. terraform apply
11. independently validate Azure state, DNS and HTTP behavior
12. repeat a meaningful endpoint failure/recovery exercise
13. verify a final no-change plan
14. Git/GitHub checkpoint
15. create the complete Lab 02 rebuild/practice PDF
16. terraform destroy and independently verify Azure + Terraform state are empty
17. final learner explain-back
18. mark Lab 02 COMPLETE
```

---

## Working rules that must not drift

- Azure only.
- Maximum one lab per day.
- VS Code is the primary engineering workspace.
- Azure CLI is preferred for manual deployment, inspection and validation.
- Terraform follows understanding; it does not replace learning Azure.
- Teach concepts before testing comprehension.
- Explain important command and HCL syntax before execution.
- Work one meaningful action at a time during interactive learning.
- Interpret actual output before continuing.
- Use Azure Portal for inspection/troubleshooting, not as the sole deployment mechanism.
- Create reusable PNG/JPEG visual learning assets.
- Validate actual Azure state independently after Terraform apply.
- Include real failure/recovery exercises.
- Record unexpected Azure behavior rather than hiding it.
- Never commit credentials, Terraform state, tokens, private keys, certificates or sensitive local `.tfvars`.
- End practical labs with a detailed rebuild/practice PDF sufficient to repeat the lab without chat history.
