# BlueHarbor Whole-Programme Architecture Closeout

**Status:** PASS  
**Scope:** Modules 1–8 combined architecture  
**Result:** IMPLEMENTATION READY  
**Formal execution position:** Module 1 — Unit 01 — Introduction

This closeout is the final planning gate after the seven module-transition audits. It validates that the complete BlueHarbor design can be built progressively through one Terraform root and one state lineage without avoidable destructive redesign.

## 1. Canonical regions

```text
Primary Azure region    Australia East
Secondary Azure region  Southeast Asia
```

Region abbreviations in readable Azure resource names:

```text
aue  Australia East
sea  Southeast Asia
```

## 2. Canonical address contract

### Core — Australia East

```text
bhi-vnet-core-aue       10.10.0.0/16
  snet-management       10.10.1.0/24
  snet-shared-services  10.10.2.0/24
  snet-dns-inbound      10.10.10.0/28
  snet-dns-outbound     10.10.10.16/28
  snet-private-endpoints 10.10.20.0/24
```

### Manufacturing — Australia East

```text
bhi-vnet-mfg-aue        10.20.0.0/16
  snet-mfg-app          10.20.1.0/24
  snet-mfg-data         10.20.2.0/24
  snet-pls-nat          10.20.3.0/27
```

### Research — Southeast Asia

```text
bhi-vnet-research-sea   10.30.0.0/16
  snet-research-app     10.30.1.0/24
  snet-research-data    10.30.2.0/24
  snet-telemetry-dr     10.30.3.0/24
```

### Partner — Australia East

```text
bhi-vnet-partner-aue    10.40.0.0/16
  snet-appgw            10.40.1.0/24
  snet-partner-app      10.40.2.0/24
  snet-private-endpoints 10.40.3.0/24
  snet-appsvc-integration 10.40.4.0/26
  snet-appgw-pl         10.40.5.0/27
```

### Partner — Southeast Asia

```text
bhi-vnet-partner-sea    10.50.0.0/16
  snet-appgw            10.50.1.0/24
  snet-partner-app      10.50.2.0/24
  snet-appgw-pl         10.50.3.0/27
```

### Classic connectivity

```text
bhi-vnet-connectivity-aue 10.100.0.0/16
  GatewaySubnet            10.100.255.0/26
```

### Virtual WAN hubs

```text
bhi-vhub-aue  10.200.0.0/22
bhi-vhub-sea  10.200.4.0/22
```

### Physical sites and remote clients

```text
Brisbane HQ               172.16.0.0/16
Perth Manufacturing       172.17.0.0/16
Classic VPN P2S pool      172.31.240.0/24
Virtual WAN User VPN pool 172.31.241.0/24
```

**Closeout result:** no planned overlap exists among the canonical Azure networks, hubs, sites or client pools.

## 3. Private DNS contract

BlueHarbor-owned internal namespace:

```text
blueharbor.internal
```

Module 1 establishes this private namespace and links it to the required VNets. Later VNets link into the same namespace when they join the estate.

Example BlueHarbor-owned service record:

```text
telemetry.services.blueharbor.internal
```

This is a record beneath `blueharbor.internal`; do not create an unnecessary second `services.blueharbor.internal` zone merely for the name.

Microsoft-owned Private Link namespaces remain service-specific, for example:

```text
privatelink.database.windows.net
privatelink.azurewebsites.net
```

Hybrid DNS extends the same architecture through the Core DNS Private Resolver. On-premises conditional forwarding uses the appropriate namespace for the service path and is validated independently from IP routing.

## 4. Global-name strategy

Readable resources keep readable deterministic names such as:

```text
bhi-vnet-core-aue
lb-telemetry-aue
appgw-partner-aue
azfw-bhi-aue
```

Resources requiring global uniqueness use one persistent project suffix:

```text
global_suffix = six lowercase alphanumeric characters
```

The suffix is chosen once before the first practical deployment and must not change during the programme unless an intentional replacement is accepted.

Storage account examples contain only lowercase letters/numbers:

```text
stbhitfstate<suffix>
stbhimfgarchive<suffix>
stbhiflowaue<suffix>
stbhiflowsea<suffix>
```

Use the same suffix strategy for SQL server names, DNS labels, Traffic Manager names, Front Door endpoint names and other globally unique Azure resources where required.

## 5. Terraform backend / one-state contract

The first real practical establishes one state lineage and migrates it to Azure Blob remote state before the cumulative network build proceeds.

Canonical bootstrap resources:

```text
rg-bhi-tfstate-aue
stbhitfstate<suffix>
container: tfstate
key: blueharbor.tfstate
```

Authentication uses Microsoft Entra ID / Azure CLI-compatible identity rather than committed Storage keys/SAS/client secrets.

Bootstrap sequence:

```text
1. begin in blueharbor/terraform with temporary local state
2. create the state resource group/storage/container through Terraform
3. add the azurerm backend configuration
4. terraform init -migrate-state
5. verify the state is in Azure Blob
6. continue M1-M8 using that same remote state lineage
```

Protect the state Storage design from accidental destruction and enable appropriate Storage recovery/versioning controls when implemented.

Local backend configuration and real tfvars are ignored by Git. Safe example files may be committed.

## 6. Special-purpose subnet contract

```text
GatewaySubnet
 -> gateway only
 -> no generic workload NSG/NAT/UDR automation

snet-dns-inbound / snet-dns-outbound
 -> DNS Private Resolver dedicated/delegated subnets
 -> no generic workload treatment

snet-appgw AUE/SEA
 -> Application Gateway only
 -> preserve the supported public return-path exception while public ingress exists

snet-private-endpoints
 -> Private Endpoint policy/NSG/route behaviour configured deliberately
 -> never shared with App Service VNet Integration

snet-appsvc-integration
 -> dedicated App Service integration subnet
 -> required Microsoft.Web/serverFarms delegation

snet-pls-nat
 -> Private Link Service provider NAT only
 -> Private Link Service network-policy requirement

snet-appgw-pl AUE/SEA
 -> Application Gateway Private Link provider-side function only
```

Generic Terraform loops must not attach the same NSG, route table or NAT Gateway automatically to every subnet.

## 7. Intentional architecture evolutions

The project is cumulative but not frozen. Approved later business requirements intentionally retire or replace earlier paths:

```text
classic workload gateway-transit dependency
 -> Virtual WAN production transit

Research VNet connection to AUE hub
 -> SEA hub when SEA hub is deployed

Module 1 direct Core<->Mfg / Core<->Research peerings
 -> retired after secured Virtual WAN private transit is proven

Partner app NAT egress
 -> retired after secured-hub Azure Firewall egress is proven

Front Door public Application Gateway origin group
 -> replaced by validated Private-Link-enabled origin group
```

These are architecture migrations, not end-of-lab cleanup.

Classic VPN Gateway resources remain deployed for learning/history after the Virtual WAN migration, but the classic branch path becomes non-production/inactive unless a later explicit failback design says otherwise.

## 8. Public-ingress and routing exceptions

Do not blindly force every subnet through Azure Firewall.

Public service paths retain supported symmetric return-path designs where required:

```text
AUE/SEA Application Gateway public-ingress subnet path
AUE telemetry public LB backend path + nat-mfg-aue
SEA telemetry public LB backend path + nat-telemetry-sea
```

The exact service-specific UDR rules are verified against current Azure documentation at implementation time.

## 9. Service Endpoint / firewall exception

Module 7 intentionally uses a Storage service endpoint from:

```text
snet-mfg-data
 -> Microsoft.Storage service endpoint
 -> restricted Manufacturing archive Storage
```

The Azure service route created by the service endpoint is intentionally allowed to bypass the central Azure Firewall egress path for that Storage traffic.

Controls for this exception are:

```text
Storage service endpoint
Storage service endpoint policy where supported
Storage network/VNet rules
```

Do not claim this traffic is inspected by Azure Firewall. If inspection later becomes a requirement, revisit the access pattern rather than misrepresenting the route.

## 10. Terraform ownership boundaries

Terraform owns persistent BlueHarbor infrastructure/configuration.

Operational tools may inspect and test but must not become a second unmanaged provisioning path.

Specific ownership exceptions:

```text
Network Watcher regional instances
 -> discover/reconcile/import/reference if Azure auto-created them
 -> do not blindly duplicate

Traffic Analytics NWTA* DCR/DCE internals
 -> Azure service-managed
 -> do not manage directly

external ExpressRoute/carrier dependencies
 -> model/document honestly when provider-side resources cannot be provisioned by the lab
```

Unexpected destroy/replace in `terraform plan` means stop and investigate.

## 11. Monitoring dependencies

Module 8 adds no replacement network.

Canonical operations layer:

```text
rg-bhi-monitoring-aue
law-bhi-netops-aue
ag-bhi-netops

stbhiflowaue<suffix>
stbhiflowsea<suffix>

VNet flow logs on all six BlueHarbor VNets
Traffic Analytics -> law-bhi-netops-aue
vm-netops-aue -> snet-management
Connection Monitor / diagnostics / alerts
```

Do not create new NSG flow logs.

## 12. Unit 03 public-IP lifecycle

Module 1 Unit 03 teaches public/private IP design and Azure public-IP behaviour but does **not** create a throwaway persistent public endpoint.

The first real BlueHarbor infrastructure checkpoint remains Unit 04. Public IP resources later appear naturally when VPN gateways, Load Balancers and Application Gateways require them.

## Closeout verdict

```text
Story continuity                 PASS
Address spaces / overlap         PASS
Regions / names                  PASS
Special subnet design            PASS
Global uniqueness strategy       PASS
Private DNS namespace            PASS
Hybrid DNS continuity            PASS
Terraform root/state model       PASS
Remote backend contract          PASS
Migration/retirement sequence    PASS
Secured-WAN routing              PASS
Public return-path exceptions    PASS
Service Endpoint exception       PASS
Terraform ownership boundaries   PASS
Monitoring dependencies          PASS
Sensitive/local file handling    PASS
```

# FINAL RESULT

```text
STORY DESIGN                 COMPLETE
TRANSITION AUDIT GATES 1-7   PASS
WHOLE-PROGRAMME CLOSEOUT     PASS
IMPLEMENTATION READY         YES
TERRAFORM BUILD              NOT STARTED
AZURE DEPLOYMENT             NOT STARTED
FORMAL POSITION              M1 U01 — Introduction
```
