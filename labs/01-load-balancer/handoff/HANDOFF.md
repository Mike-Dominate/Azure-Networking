# Lab 01 Handoff — Azure Load Balancer

Use this file to resume Lab 01 precisely.

## Status

- **Lab:** 01 — Azure Load Balancer
- **State:** IN PROGRESS
- **Current phase:** Manual Azure CLI deployment completed, validated, failure-tested, recovery-tested, outbound-tested, and destroyed. Ready to begin Terraform rebuild after synchronizing the repository.
- **Last completed action:** Verified teardown with `az group exists --name rg-az700-lb-aue` returning `false`.
- **Next action:** Synchronize local Git with remote changes, add/commit `cloud-init.yaml`, push the local commit, then inspect the Terraform folder before starting the IaC rebuild.
- **Last updated:** 2026-08-25 (Australia/Brisbane)

## Current architecture

The manual environment has been destroyed. The architecture that was successfully built and validated was:

```text
Internet client
      |
      | HTTP TCP/80
      v
Standard Public IP
pip-az700-lb-aue
      |
      v
Standard Azure Load Balancer
lb-az700-aue
      |
      +-- Frontend IP: fe-public
      +-- HTTP health probe: probe-http (port 80, path /)
      +-- Inbound rule: rule-http (TCP 80 -> 80)
      +-- Outbound rule: outbound-web
      |
      v
Backend pool: be-web
      |
      +------------------+------------------+
      |                  |                  |
      v                  v                  v
nic-web-az1          nic-web-az2          nic-web-az3
10.200.1.4           10.200.1.5           10.200.1.6
      |                  |                  |
      v                  v                  v
vm-web-az1           vm-web-az2           vm-web-az3
Zone 1               Zone 2               Zone 3
Apache :80           Apache :80           Apache :80
```

All backend NICs were in:

```text
VNet:   vnet-az700-lb-aue 10.200.0.0/16
Subnet: snet-web          10.200.1.0/24
NSG:    nsg-az700-web-aue
```

Backend VMs had no individual public IPs.

## Completed checklist

- [x] Lab workspace created
- [x] Learning objectives recorded
- [x] Visual-learning worksheet created
- [x] Direct-deployment worksheet created
- [x] Terraform learning workspace created
- [x] Validation worksheet created
- [x] Troubleshooting journal created
- [x] First-pass mental model lesson completed
- [x] Workstation/tool verification completed
  - [x] Git verified: 2.54.0.windows.1
  - [x] Azure CLI verified: 2.88.0
  - [x] Terraform installed and verified: 1.15.8
  - [x] VS Code workspace opened and trusted
  - [x] Local GitHub repository verified
  - [x] Azure subscription context verified
- [x] Direct deployment completed
- [x] Direct deployment validated
- [x] Failure exercise completed
- [x] Recovery exercise completed
- [x] Explicit outbound SNAT validated
- [x] Manual Azure resources destroyed
- [ ] Manual artifacts committed/pushed
- [ ] Terraform implementation started
- [ ] Terraform implementation completed
- [ ] Terraform deployment validated
- [ ] Terraform failure exercise completed
- [ ] Lab reflection completed
- [ ] Lab marked COMPLETE

## Mental-model checkpoints

- [x] Clients connect to the Load Balancer frontend rather than directly to backend VMs.
- [x] Backend pool contains candidate backend endpoints.
- [x] Health probes run continuously and determine eligibility for new flows.
- [x] Unhealthy application service can remove a VM from new flows even while the VM remains powered on.
- [x] Healthy backend automatically re-enters service after probe recovery.
- [x] Load-balancing rule maps frontend TCP/80 to backend TCP/80 and associates health state.
- [x] Azure Load Balancer is Layer 4 and does not route by URL path or HTTP host headers.
- [x] Distribution is flow-hash based, not guaranteed request-by-request round-robin.
- [x] NSG evaluation is a separate security layer that can block an otherwise-correct LB configuration.
- [x] Lower NSG priority numbers are evaluated first.
- [x] Availability Zones reduce zone-level failure impact.
- [x] Standard Load Balancer outbound rule can provide explicit SNAT for private backend VMs.

## Decisions specific to Lab 01

- Region: `australiaeast`.
- Addressing preserved from source objective: VNet `10.200.0.0/16`, subnet `10.200.1.0/24`.
- Use Standard Load Balancer.
- Use SSH-key authentication; no shared VM password.
- Do not assign public IPs to backend VMs.
- Use subnet-level NSG.
- Allow public HTTP on TCP/80; do not expose SSH/22 to the Internet.
- Because `defaultOutboundAccess` was reported as `false`, provide explicit outbound connectivity through the Standard Load Balancer outbound rule.
- Disable implicit outbound SNAT on the inbound rule and use a dedicated outbound rule.
- Use cloud-init to install Apache and create a page that displays the VM hostname.
- Original candidate `Standard_B1ms` supported zones but failed at deployment because of live capacity restriction.
- `Standard_B2s` was not available for this subscription.
- Final working size: `Standard_B2als_v2` (2 vCPU, 4 GB), with zones 1/2/3 available and no reported subscription restriction.

## Manual deployment commands and outcomes

### Tool verification

```powershell
git --version
az --version
terraform --version
```

Observed:

```text
Git:       2.54.0.windows.1
Azure CLI: 2.88.0
Terraform: 1.15.8
```

Terraform had first been installed with:

```powershell
winget install --id Hashicorp.Terraform -e
```

### Azure account correction

The first Azure context was wrong/disabled for deployment. Session was reset with:

```powershell
az logout
az login --use-device-code
az account show --query "{Subscription:name, State:state, IsDefault:isDefault}" -o table
```

Correct active subscription was selected and verified before continuing.

### Resource group

```powershell
az group create --name rg-az700-lb-aue --location australiaeast
```

Result: succeeded.

### VNet and subnet

```powershell
az network vnet create --resource-group rg-az700-lb-aue --name vnet-az700-lb-aue --address-prefix 10.200.0.0/16 --subnet-name snet-web --subnet-prefix 10.200.1.0/24
```

Result: VNet and subnet created. Subnet reported `defaultOutboundAccess: false`.

### Standard public IP

```powershell
az network public-ip create --resource-group rg-az700-lb-aue --name pip-az700-lb-aue --sku Standard --allocation-method Static --location australiaeast
```

Result: succeeded. Public IP during the manual deployment was `20.92.75.118`.

### Standard Load Balancer

```powershell
az network lb create --resource-group rg-az700-lb-aue --name lb-az700-aue --sku Standard --public-ip-address pip-az700-lb-aue --frontend-ip-name fe-public --backend-pool-name be-web
```

Result: Load Balancer, frontend configuration, and backend pool created.

### HTTP health probe

```powershell
az network lb probe create --resource-group rg-az700-lb-aue --lb-name lb-az700-aue --name probe-http --protocol Http --port 80 --path /
```

Result: HTTP probe on port 80 path `/` created.

### Inbound load-balancing rule

```powershell
az network lb rule create --resource-group rg-az700-lb-aue --lb-name lb-az700-aue --name rule-http --protocol Tcp --frontend-port 80 --backend-port 80 --frontend-ip-name fe-public --backend-pool-name be-web --probe-name probe-http
```

Result: TCP 80 frontend to TCP 80 backend rule created.

### Disable implicit outbound SNAT on inbound rule

```powershell
az network lb rule update --resource-group rg-az700-lb-aue --lb-name lb-az700-aue --name rule-http --disable-outbound-snat true
```

Result: succeeded.

### Explicit outbound rule

```powershell
az network lb outbound-rule create --resource-group rg-az700-lb-aue --lb-name lb-az700-aue --name outbound-web --protocol All --frontend-ip-configs fe-public --address-pool be-web --outbound-ports 10000
```

Result: explicit outbound SNAT configured using the Load Balancer frontend public IP.

### NSG

```powershell
az network nsg create --resource-group rg-az700-lb-aue --name nsg-az700-web-aue --location australiaeast
```

### Public HTTP NSG rule

```powershell
az network nsg rule create --resource-group rg-az700-lb-aue --nsg-name nsg-az700-web-aue --name Allow-HTTP-Inbound --priority 100 --direction Inbound --access Allow --protocol Tcp --source-address-prefixes Internet --source-port-ranges "*" --destination-address-prefixes "*" --destination-port-ranges 80
```

Result: TCP/80 allowed from Internet at priority 100.

### Associate NSG to subnet

```powershell
az network vnet subnet update --resource-group rg-az700-lb-aue --vnet-name vnet-az700-lb-aue --name snet-web --network-security-group nsg-az700-web-aue
```

Result: `snet-web` associated with the NSG.

### Backend NICs

```powershell
az network nic create --resource-group rg-az700-lb-aue --name nic-web-az1 --vnet-name vnet-az700-lb-aue --subnet snet-web --lb-name lb-az700-aue --lb-address-pools be-web
az network nic create --resource-group rg-az700-lb-aue --name nic-web-az2 --vnet-name vnet-az700-lb-aue --subnet snet-web --lb-name lb-az700-aue --lb-address-pools be-web
az network nic create --resource-group rg-az700-lb-aue --name nic-web-az3 --vnet-name vnet-az700-lb-aue --subnet snet-web --lb-name lb-az700-aue --lb-address-pools be-web
```

Observed private IPs:

```text
nic-web-az1 -> 10.200.1.4
nic-web-az2 -> 10.200.1.5
nic-web-az3 -> 10.200.1.6
```

All three NIC IP configurations were registered in backend pool `be-web`.

### cloud-init

Local file created:

```text
labs/01-load-balancer/manual-deployment/cloud-init.yaml
```

It installs Apache, stages a web page in `/tmp`, replaces a placeholder with the VM hostname, copies the page into Apache's web root, enables Apache, and restarts it.

A duplicate `runcmd:` key was detected by reading the saved file with:

```powershell
Get-Content .\labs\01-load-balancer\manual-deployment\cloud-init.yaml
```

The duplicate key was removed before deployment.

### First VM attempt and capacity troubleshooting

First attempted VM size:

```text
Standard_B1ms
```

Deployment failed with `SkuNotAvailable` because of a live capacity restriction in Australia East.

The failed deployment did not leave a VM behind, verified with:

```powershell
az vm list --resource-group rg-az700-lb-aue --query "[].{Name:name,Size:hardwareProfile.vmSize,Zone:zones[0],State:provisioningState}" -o table
```

`Standard_B2s` was checked next but Azure reported `NotAvailableForSubscription`.

Available SKUs were then inspected, and `Standard_B2als_v2` was selected and verified for zones 1,2,3 with no restrictions.

### VM creation

```powershell
az vm create --resource-group rg-az700-lb-aue --name vm-web-az1 --nics nic-web-az1 --image Canonical:0001-com-ubuntu-server-jammy:22_04-lts-gen2:latest --size Standard_B2als_v2 --zone 1 --admin-username azureuser --generate-ssh-keys --custom-data .\labs\01-load-balancer\manual-deployment\cloud-init.yaml

az vm create --resource-group rg-az700-lb-aue --name vm-web-az2 --nics nic-web-az2 --image Canonical:0001-com-ubuntu-server-jammy:22_04-lts-gen2:latest --size Standard_B2als_v2 --zone 2 --admin-username azureuser --generate-ssh-keys --custom-data .\labs\01-load-balancer\manual-deployment\cloud-init.yaml

az vm create --resource-group rg-az700-lb-aue --name vm-web-az3 --nics nic-web-az3 --image Canonical:0001-com-ubuntu-server-jammy:22_04-lts-gen2:latest --size Standard_B2als_v2 --zone 3 --admin-username azureuser --generate-ssh-keys --custom-data .\labs\01-load-balancer\manual-deployment\cloud-init.yaml
```

Results:

```text
vm-web-az1 -> Zone 1 -> 10.200.1.4 -> no public IP
vm-web-az2 -> Zone 2 -> 10.200.1.5 -> no public IP
vm-web-az3 -> Zone 3 -> 10.200.1.6 -> no public IP
```

### VM/application validation

For each VM, Azure Run Command was used to prove cloud-init completion, Apache state, and page contents. Example for VM1:

```powershell
az vm run-command invoke --resource-group rg-az700-lb-aue --name vm-web-az1 --command-id RunShellScript --scripts "cloud-init status --wait; systemctl is-active apache2; cat /var/www/html/index.html" --query "value[0].message" -o tsv
```

Equivalent checks were run for VM2 and VM3.

Observed on all three:

```text
cloud-init status: done
Apache: active
Page displayed correct VM hostname
```

### Retrieve frontend public IP

```powershell
az network public-ip show --resource-group rg-az700-lb-aue --name pip-az700-lb-aue --query ipAddress -o tsv
```

Observed:

```text
20.92.75.118
```

### First end-to-end HTTP request

```powershell
curl.exe -s http://20.92.75.118
```

First observed backend:

```text
Served by: vm-web-az3
```

### Distribution test

```powershell
1..12 | ForEach-Object { (curl.exe -s -H "Connection: close" http://20.92.75.118 | Select-String "Served by").Line }
```

Observed all three backends receiving new connections. The neat sequence observed during the run is not evidence of guaranteed round-robin behavior; Azure Load Balancer remains flow-hash based.

### Failure test

Apache was stopped only on VM2:

```powershell
az vm run-command invoke --resource-group rg-az700-lb-aue --name vm-web-az2 --command-id RunShellScript --scripts "sudo systemctl stop apache2; systemctl is-active apache2" --query "value[0].message" -o tsv
```

Result:

```text
inactive
```

After waiting for probe detection, repeated requests were sent:

```powershell
Start-Sleep -Seconds 40; 1..12 | ForEach-Object { (curl.exe -s --max-time 5 -H "Connection: close" http://20.92.75.118 | Select-String "Served by").Line }
```

Observed only VM1 and VM3. VM2 received no new test flows.

### Recovery test

Apache was restarted on VM2:

```powershell
az vm run-command invoke --resource-group rg-az700-lb-aue --name vm-web-az2 --command-id RunShellScript --scripts "sudo systemctl start apache2; systemctl is-active apache2" --query "value[0].message" -o tsv
```

Result:

```text
active
```

After another probe interval, the same repeated HTTP test showed VM1, VM2, and VM3 again. This proved automatic backend recovery.

### Explicit outbound SNAT validation

From inside VM1:

```powershell
az vm run-command invoke --resource-group rg-az700-lb-aue --name vm-web-az1 --command-id RunShellScript --scripts "curl -s https://api.ipify.org; echo" --query "value[0].message" -o tsv
```

Observed external source IP:

```text
20.92.75.118
```

This matched the Load Balancer frontend public IP and proved the outbound rule was supplying egress SNAT.

### Local Git status before teardown

```powershell
git status --short
```

Observed:

```text
?? labs/01-load-balancer/manual-deployment/cloud-init.yaml
```

`??` means the file is new and untracked locally.

### Teardown

```powershell
az group delete --name rg-az700-lb-aue --yes
```

Deletion was allowed to complete before proceeding.

Verification:

```powershell
az group exists --name rg-az700-lb-aue
```

Observed:

```text
false
```

The manual Azure environment is therefore gone.

## Documentation created

A detailed learning walkthrough containing command syntax, purpose, observed outcomes, troubleshooting notes, and testing logic is now stored at:

```text
labs/01-load-balancer/manual-deployment/DEPLOYMENT-WALKTHROUGH.md
```

## Current local Git state known at checkpoint

Before the remote documentation updates in this handoff, local Git showed:

```text
?? labs/01-load-balancer/manual-deployment/cloud-init.yaml
```

Because documentation was updated directly on GitHub after that local status check, the local branch must **pull/rebase the remote changes before pushing its local cloud-init commit**.

Recommended sequence from `C:\Users\W_Admin\Azure-Networking`:

```powershell
git pull --rebase origin main
git status --short
git add labs/01-load-balancer/manual-deployment/cloud-init.yaml
git commit -m "Add Lab 01 cloud-init configuration"
git push origin main
```

Then verify:

```powershell
git status
git log --oneline -5
```

Expected end state:

```text
working tree clean
branch main synchronized with origin/main
```

## Blockers

None at this checkpoint.

## Resume instruction

Do **not** redeploy the manual environment.

Resume from a clean Azure environment with this sequence:

```text
1. Pull/rebase the latest remote documentation changes.
2. Commit and push local cloud-init.yaml.
3. Verify Git working tree is clean and main is synchronized with origin/main.
4. Inspect labs/01-load-balancer/terraform.
5. Teach the Terraform file/resource syntax before applying anything.
6. Rebuild the same logical architecture with Terraform.
7. Validate the Terraform-built environment independently with Azure CLI.
8. Repeat failure/recovery testing where useful.
9. Capture evidence, commit Terraform implementation, then safely destroy the lab.
```

The immediate next command in the next session should be:

```powershell
git pull --rebase origin main
```
