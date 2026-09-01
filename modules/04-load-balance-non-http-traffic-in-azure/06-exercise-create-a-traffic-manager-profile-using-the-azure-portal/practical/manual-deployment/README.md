# Lab 02 — Manual Deployment

This folder records the complete **manual Azure CLI phase** of Lab 02 — Azure Traffic Manager.

The detailed walkthrough is:

```text
DEPLOYMENT-WALKTHROUGH.md
```

It records the actual path taken in the lab, including the commands that succeeded, the commands that failed, the Azure subscription constraint that forced an architecture change, DNS validation, endpoint-health testing, DNS TTL investigation, Portal inspection, and teardown.

## Actual architecture used

The source exercise originally used Azure App Service endpoints. During this lab the subscription had zero App Service VM quota in East US, so the App Service plan could not be created.

Rather than hide that real Azure constraint, the lab preserved the Traffic Manager learning objective by using:

```text
Azure Container Instances in three regions
        +
public regional ACI FQDNs
        +
Azure Traffic Manager External endpoints
        +
Geographic routing
```

Final geographic mapping:

```text
North America      -> ep-eus -> East US ACI
Europe             -> ep-weu -> West Europe ACI
Asia               -> ep-sea -> Southeast Asia ACI
Australia/Pacific  -> ep-sea -> Southeast Asia ACI
```

## Manual phase status

```text
Concept teaching                    COMPLETE
Manual Azure CLI deployment         COMPLETE
Direct endpoint validation          COMPLETE
Traffic Manager DNS validation      COMPLETE
Geographic mapping failure/fix      COMPLETE
Endpoint failure/recovery test      COMPLETE
DNS TTL investigation               COMPLETE
Azure Portal inspection             COMPLETE
Manual teardown                     COMPLETE
Independent clean-state validation  COMPLETE
```

The manual resource group was deleted before the Terraform phase and independently verified absent with:

```powershell
az group exists --name rg-az700-tm-global
```

Result:

```text
false
```

## Learning rule

Do not use this file as a substitute for the walkthrough. The walkthrough explains **why** each command and test exists, not only what to type.
