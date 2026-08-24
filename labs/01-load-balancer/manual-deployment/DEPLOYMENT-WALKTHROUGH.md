# Lab 01 — Manual Azure CLI Deployment Walkthrough

This document records the complete manual Azure CLI build, validation, failure test, recovery test, outbound test, and teardown performed for **Lab 01 — Azure Load Balancer**.

It is intentionally written as a learning document rather than only a runbook. Each command is followed by:

- **What the command does**
- **How the syntax works**
- **What happened in this lab**
- **Why the step matters to the architecture**

The goal is to make it possible to revisit the lab later and understand not only *what to type*, but *why each part of the command exists*.

---

## 1. Final manual architecture that was built

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
      +-- Frontend: fe-public
      +-- Health probe: probe-http (HTTP / on port 80)
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

All NICs are in:
VNet:   vnet-az700-lb-aue 10.200.0.0/16
Subnet: snet-web          10.200.1.0/24
NSG:    nsg-az700-web-aue
```

The backend VMs deliberately had **no individual public IP addresses**. Public inbound traffic entered through the Load Balancer frontend. Outbound Internet access was explicitly provided by the Standard Load Balancer outbound rule.

---

# Part A — Command syntax foundations

## 2. How Azure CLI commands are structured

Most Azure CLI commands follow this shape:

```text
az <command-group> <subgroup-if-needed> <operation> --parameter value
```

Example:

```powershell
az network public-ip create --resource-group rg-az700-lb-aue --name pip-az700-lb-aue --sku Standard --allocation-method Static --location australiaeast
```

Breakdown:

```text
az
└── Azure CLI executable

network
└── command group: networking resources

public-ip
└── networking resource type

create
└── operation to perform

--resource-group rg-az700-lb-aue
└── resource group in which the resource is created

--name pip-az700-lb-aue
└── resource name

--sku Standard
└── use the Standard public IP SKU

--allocation-method Static
└── retain the assigned public IP while the resource exists

--location australiaeast
└── Azure region
```

A useful mental model is:

```text
az + WHAT RESOURCE + WHAT ACTION + PARAMETERS
```

Examples:

```text
az group create
az network vnet create
az network lb create
az network nic create
az vm create
```

---

## 3. Common Azure CLI parameters used throughout the lab

| Syntax | Meaning |
|---|---|
| `--resource-group` | Resource group containing or receiving the resource |
| `--name` | Name of the resource being created, queried, or changed |
| `--location` | Azure region, in this lab `australiaeast` |
| `--query` | JMESPath expression used to select fields from JSON returned by Azure |
| `-o table` | Display selected output as a table |
| `-o json` | Display output as JSON |
| `-o tsv` | Display only values without JSON labels/quotes; useful for scripts |
| `--yes` | Confirm an operation without an interactive prompt |

### JMESPath versus PowerShell

This command:

```powershell
az network public-ip show --resource-group rg-az700-lb-aue --name pip-az700-lb-aue --query ipAddress -o tsv
```

uses Azure CLI's `--query` to select only the `ipAddress` property from the returned Azure object.

By contrast:

```powershell
1..12 | ForEach-Object { ... }
```

is **PowerShell syntax**, not Azure CLI syntax.

Keeping these layers separate is important:

```text
PowerShell shell
    |
    +-- launches az commands
    +-- launches curl.exe
    +-- loops, filters, sleeps, pipes text

Azure CLI
    |
    +-- talks to Azure Resource Manager
    +-- creates/reads/updates/deletes Azure resources
```

---

# Part B — Workstation and Azure context

## 4. Verify Git

```powershell
git --version
```

### Syntax

- `git` — Git executable.
- `--version` — print the installed version and exit.

### Result

Git was available as:

```text
git version 2.54.0.windows.1
```

### Why this mattered

The lab is being treated as an engineering project, so configuration and documentation need to be version-controlled rather than existing only in terminal history.

---

## 5. Verify Azure CLI

```powershell
az --version
```

### Result

Azure CLI 2.88.0 was available.

### Why this mattered

Azure CLI was the primary direct-deployment and validation tool for the manual phase.

---

## 6. Install and verify Terraform

Terraform was initially not available. It was installed with Windows Package Manager:

```powershell
winget install --id Hashicorp.Terraform -e
```

Then verified in a new terminal:

```powershell
terraform --version
```

### Syntax

- `winget install` — install a package.
- `--id Hashicorp.Terraform` — use the exact package identifier.
- `-e` — exact-match the package ID.

### Result

Terraform v1.15.8 was installed successfully.

### Why this mattered

Terraform was installed before the manual build, but deliberately **not used yet**. The learning method is to understand the Azure objects directly first and then rebuild the same architecture as Infrastructure as Code.

---

## 7. Verify Azure account context

An initial resource deployment attempt exposed that the wrong/disabled subscription context was active. The session was reset:

```powershell
az logout
az login --use-device-code
```

The correct subscription was selected during login and then verified using:

```powershell
az account show --query "{Subscription:name, State:state, IsDefault:isDefault}" -o table
```

### Syntax

- `az logout` — clear the current Azure CLI authenticated session.
- `az login` — authenticate again.
- `--use-device-code` — authenticate using the device-code flow.
- `az account show` — show the currently active subscription context.
- `--query "{...}"` — construct a smaller result containing only the selected properties.
- `-o table` — render the result as a readable table.

### Lesson

Always verify **which subscription is active before creating infrastructure**. A syntactically correct command can still fail or create resources in the wrong place if the account context is wrong.

---

# Part C — Region and VM-size checks

## 8. Check initial VM SKU and Availability Zone support

The original small size considered was `Standard_B1ms`:

```powershell
az vm list-skus --location australiaeast --resource-type virtualMachines --size Standard_B1ms --all --query "[?name=='Standard_B1ms'].{Size:name,Zones:locationInfo[0].zones}" -o json
```

### Syntax

- `az vm list-skus` — list VM SKU information.
- `--location australiaeast` — inspect the Australia East region.
- `--resource-type virtualMachines` — restrict output to VM SKUs.
- `--size Standard_B1ms` — focus on that size.
- `--all` — include SKUs even where restrictions may exist.
- `--query` — extract the size and supported zones.

### Result

`Standard_B1ms` showed support for Availability Zones 1, 2, and 3.

### Important lesson

**SKU zone support is not the same as live capacity.** Later, the actual VM deployment failed because Azure reported a capacity restriction for `Standard_B1ms`.

---

# Part D — Manual network and Load Balancer build

## 9. Create the resource group

```powershell
az group create --name rg-az700-lb-aue --location australiaeast
```

### Syntax

- `az group create` — create a Resource Group.
- `--name` — Resource Group name.
- `--location` — location used for Resource Group metadata and regional resources created later.

### Result

`rg-az700-lb-aue` was created successfully in Australia East.

### Architectural contribution

The Resource Group acted as the lifecycle boundary for the entire lab. That later made teardown simple because deleting the Resource Group deleted the lab resources together.

---

## 10. Create the VNet and subnet

```powershell
az network vnet create --resource-group rg-az700-lb-aue --name vnet-az700-lb-aue --address-prefix 10.200.0.0/16 --subnet-name snet-web --subnet-prefix 10.200.1.0/24
```

### Syntax

- `az network vnet create` — create a Virtual Network.
- `--address-prefix 10.200.0.0/16` — VNet CIDR address space.
- `--subnet-name snet-web` — create an initial subnet during VNet creation.
- `--subnet-prefix 10.200.1.0/24` — subnet CIDR.

### Result

Created:

```text
VNet:   vnet-az700-lb-aue 10.200.0.0/16
Subnet: snet-web          10.200.1.0/24
```

Azure also reported:

```text
defaultOutboundAccess: false
```

### Architectural contribution

The VNet provides private Azure network space. `snet-web` is the network segment containing all three backend web VMs.

### Important lesson

Because default outbound access was disabled, the backend VMs needed an explicit egress method. For this lab, that was provided through the **Standard Load Balancer outbound rule**.

---

## 11. Create the Standard public IP

```powershell
az network public-ip create --resource-group rg-az700-lb-aue --name pip-az700-lb-aue --sku Standard --allocation-method Static --location australiaeast
```

### Result

The public IP was created successfully. During the manual run it was assigned:

```text
20.92.75.118
```

This address was later released when the lab Resource Group was deleted.

### Architectural contribution

This is the public client entry point for the Load Balancer and also the public source IP used by the explicit outbound SNAT rule.

---

## 12. Create the Standard Load Balancer

```powershell
az network lb create --resource-group rg-az700-lb-aue --name lb-az700-aue --sku Standard --public-ip-address pip-az700-lb-aue --frontend-ip-name fe-public --backend-pool-name be-web
```

### Syntax

- `az network lb create` — create an Azure Load Balancer.
- `--sku Standard` — use Standard Load Balancer.
- `--public-ip-address pip-az700-lb-aue` — associate the public IP.
- `--frontend-ip-name fe-public` — name the frontend IP configuration.
- `--backend-pool-name be-web` — create the backend address pool.

### Result

Created:

```text
Load Balancer: lb-az700-aue
Frontend:      fe-public
Backend pool:  be-web
```

### Architectural contribution

The Load Balancer became the Layer 4 traffic distributor between the public frontend and healthy backend VM NICs.

---

## 13. Create the HTTP health probe

```powershell
az network lb probe create --resource-group rg-az700-lb-aue --lb-name lb-az700-aue --name probe-http --protocol Http --port 80 --path /
```

### Syntax

- `az network lb probe create` — create a health probe on an existing Load Balancer.
- `--lb-name` — identify which Load Balancer owns the probe.
- `--protocol Http` — perform an HTTP probe.
- `--port 80` — probe TCP port 80.
- `--path /` — issue the HTTP health request against `/`.

### Architectural contribution

The probe continuously determines whether each backend web service is eligible to receive **new flows**.

The Load Balancer does not wait for a user request and then test a backend. Health probing happens independently and continuously.

---

## 14. Create the inbound load-balancing rule

```powershell
az network lb rule create --resource-group rg-az700-lb-aue --lb-name lb-az700-aue --name rule-http --protocol Tcp --frontend-port 80 --backend-port 80 --frontend-ip-name fe-public --backend-pool-name be-web --probe-name probe-http
```

### Syntax

- `--protocol Tcp` — match TCP flows.
- `--frontend-port 80` — listen on TCP/80 at the frontend.
- `--backend-port 80` — forward to TCP/80 on selected backends.
- `--frontend-ip-name fe-public` — use the named frontend configuration.
- `--backend-pool-name be-web` — select from that backend pool.
- `--probe-name probe-http` — use the HTTP probe to determine backend eligibility.

### Architectural contribution

This rule maps:

```text
Frontend TCP/80
       |
       v
Healthy member of be-web
       |
       v
Backend TCP/80
```

The rule defines **how** matching frontend flows are translated to the backend pool.

---

## 15. Disable implicit outbound SNAT on the inbound rule

```powershell
az network lb rule update --resource-group rg-az700-lb-aue --lb-name lb-az700-aue --name rule-http --disable-outbound-snat true
```

### Why this was done

The lab intentionally uses a dedicated **outbound rule** for egress rather than relying on implicit outbound SNAT associated with the inbound rule.

This makes inbound and outbound behavior explicit and independently understandable.

---

## 16. Create the explicit outbound rule

```powershell
az network lb outbound-rule create --resource-group rg-az700-lb-aue --lb-name lb-az700-aue --name outbound-web --protocol All --frontend-ip-configs fe-public --address-pool be-web --outbound-ports 10000
```

### Syntax

- `az network lb outbound-rule create` — create a Standard Load Balancer outbound rule.
- `--protocol All` — provide outbound SNAT for supported protocols rather than only one selected protocol.
- `--frontend-ip-configs fe-public` — use the Load Balancer frontend public IP for SNAT.
- `--address-pool be-web` — apply the outbound rule to members of the backend pool.
- `--outbound-ports 10000` — allocate outbound SNAT ports for backend instances.

### Architectural contribution

The backend VMs had no public IPs and the subnet's default outbound access was disabled. This rule provided explicit Internet egress:

```text
Private backend VM
      |
      v
Load Balancer outbound rule
      |
      v
SNAT to Load Balancer public IP
      |
      v
Internet
```

---

# Part E — Network Security Group

## 17. Create the NSG

```powershell
az network nsg create --resource-group rg-az700-lb-aue --name nsg-az700-web-aue --location australiaeast
```

### Architectural contribution

The NSG provides stateful Layer 3/Layer 4 filtering for the web subnet. A correctly configured Load Balancer can still fail if the NSG denies the traffic.

---

## 18. Add the explicit HTTP inbound rule

```powershell
az network nsg rule create --resource-group rg-az700-lb-aue --nsg-name nsg-az700-web-aue --name Allow-HTTP-Inbound --priority 100 --direction Inbound --access Allow --protocol Tcp --source-address-prefixes Internet --source-port-ranges "*" --destination-address-prefixes "*" --destination-port-ranges 80
```

### Syntax

- `--nsg-name` — identify the target NSG.
- `--priority 100` — rule evaluation priority. Lower numbers are evaluated first.
- `--direction Inbound` — inbound traffic only.
- `--access Allow` — permit matching traffic.
- `--protocol Tcp` — TCP traffic.
- `--source-address-prefixes Internet` — source service tag.
- `--source-port-ranges "*"` — any client source port.
- `--destination-address-prefixes "*"` — any destination address in the scope where the NSG applies.
- `--destination-port-ranges 80` — destination TCP port 80.

### Architectural contribution

Public client source addresses are preserved by the public Load Balancer data path, so the web subnet needed to allow the public HTTP client flow in addition to the platform health-probe behavior.

### NSG lesson

Priority `100` is evaluated before the default rules in the `65000+` range because **lower numeric priority wins earlier evaluation**.

---

## 19. Associate the NSG with the subnet

```powershell
az network vnet subnet update --resource-group rg-az700-lb-aue --vnet-name vnet-az700-lb-aue --name snet-web --network-security-group nsg-az700-web-aue
```

### Syntax

- `az network vnet subnet update` — modify an existing subnet.
- `--vnet-name` — parent VNet.
- `--name snet-web` — subnet being changed.
- `--network-security-group` — associate the NSG.

### Result

`snet-web` was protected by `nsg-az700-web-aue`.

---

# Part F — Backend NICs

## 20. Create NIC for Zone 1 backend

```powershell
az network nic create --resource-group rg-az700-lb-aue --name nic-web-az1 --vnet-name vnet-az700-lb-aue --subnet snet-web --lb-name lb-az700-aue --lb-address-pools be-web
```

### Syntax

- `az network nic create` — create a Network Interface.
- `--vnet-name` — place it in this VNet.
- `--subnet snet-web` — attach its IP configuration to this subnet.
- `--lb-name lb-az700-aue` — identify the Load Balancer.
- `--lb-address-pools be-web` — register the NIC IP configuration in the backend pool.

### Result

```text
nic-web-az1 -> 10.200.1.4 -> be-web
```

---

## 21. Create NIC for Zone 2 backend

```powershell
az network nic create --resource-group rg-az700-lb-aue --name nic-web-az2 --vnet-name vnet-az700-lb-aue --subnet snet-web --lb-name lb-az700-aue --lb-address-pools be-web
```

### Result

```text
nic-web-az2 -> 10.200.1.5 -> be-web
```

---

## 22. Create NIC for Zone 3 backend

```powershell
az network nic create --resource-group rg-az700-lb-aue --name nic-web-az3 --vnet-name vnet-az700-lb-aue --subnet snet-web --lb-name lb-az700-aue --lb-address-pools be-web
```

### Result

```text
nic-web-az3 -> 10.200.1.6 -> be-web
```

### Architectural contribution

The backend pool ultimately targets the VM network interfaces. The VM itself is not the Layer 4 network endpoint; the NIC/IP configuration is the component participating in the backend pool.

---

# Part G — cloud-init and Linux bootstrap

## 23. Create `cloud-init.yaml`

The file was created locally at:

```text
labs/01-load-balancer/manual-deployment/cloud-init.yaml
```

Final content:

```yaml
#cloud-config

packages:
  - apache2

write_files:
  - path: /tmp/index.html
    permissions: '0644'
    content: |
      <!DOCTYPE html>
      <html>
      <head>
        <title>AZ-700 Load Balancer Lab</title>
      </head>
      <body>
        <h1>Azure Load Balancer Lab</h1>
        <h2>Served by: HOSTNAME</h2>
        <p>This request was successfully processed by one of the backend VMs.</p>
      </body>
      </html>

runcmd:
  - sed -i "s/HOSTNAME/$(hostname)/g" /tmp/index.html
  - cp /tmp/index.html /var/www/html/index.html
  - systemctl enable apache2
  - systemctl restart apache2
```

### YAML syntax lessons

- YAML indentation is significant.
- `packages:` starts a cloud-init package list.
- `- apache2` is one list item.
- `write_files:` tells cloud-init to create files.
- `content: |` means the following indented block is literal multi-line content.
- `runcmd:` is a list of commands executed later in the first-boot cloud-init process.

### Why `/tmp/index.html` was used first

The page was staged in `/tmp` and copied into `/var/www/html` after package installation. This avoids depending on Apache's web directory existing before Apache has been installed.

### Why replace `HOSTNAME`

Each VM serves the same template but changes `HOSTNAME` to its actual host name. This lets the client see which backend processed a given connection.

---

## 24. Verify the cloud-init file from PowerShell

```powershell
Get-Content .\labs\01-load-balancer\manual-deployment\cloud-init.yaml
```

### Syntax

`Get-Content` is a PowerShell cmdlet that reads a text file and writes its contents to the terminal.

### Result and troubleshooting lesson

The first verification exposed a duplicate `runcmd:` key. It was corrected and the file was read again before VM creation.

This is an important engineering habit:

```text
write configuration -> inspect what is actually saved -> deploy
```

---

# Part H — VM SKU troubleshooting

## 25. First Zone 1 VM attempt with `Standard_B1ms`

```powershell
az vm create --resource-group rg-az700-lb-aue --name vm-web-az1 --nics nic-web-az1 --image Canonical:0001-com-ubuntu-server-jammy:22_04-lts-gen2:latest --size Standard_B1ms --zone 1 --admin-username azureuser --generate-ssh-keys --custom-data .\labs\01-load-balancer\manual-deployment\cloud-init.yaml
```

### Syntax

- `az vm create` — create a VM.
- `--nics nic-web-az1` — attach the existing NIC instead of creating a new one.
- `--image ...` — Ubuntu 22.04 LTS Gen2 image URN.
- `--size Standard_B1ms` — requested VM SKU.
- `--zone 1` — deploy to Availability Zone 1.
- `--admin-username azureuser` — Linux administrator account name.
- `--generate-ssh-keys` — generate or reuse the local SSH keypair.
- `--custom-data <file>` — pass the cloud-init configuration to the VM.

### Partial success

Azure CLI generated SSH keys locally:

```text
C:\Users\W_Admin\.ssh\id_rsa
C:\Users\W_Admin\.ssh\id_rsa.pub
```

### Deployment result

The VM deployment failed with:

```text
SkuNotAvailable
Standard_B1ms currently unavailable in australiaeast due to capacity restrictions
```

### Lesson

This was not a syntax error. The command was valid. The infrastructure request failed because of current Azure capacity.

---

## 26. Verify no partial VM was created

```powershell
az vm list --resource-group rg-az700-lb-aue --query "[].{Name:name,Size:hardwareProfile.vmSize,Zone:zones[0],State:provisioningState}" -o table
```

### Result

The output was empty, confirming no VM remained from the failed deployment.

---

## 27. Check `Standard_B2s`

```powershell
az vm list-skus --location australiaeast --resource-type virtualMachines --size Standard_B2s --all --query "[?name=='Standard_B2s'].{Size:name,Zones:locationInfo[0].zones,Restrictions:restrictions}" -o json
```

### Result

`Standard_B2s` showed `NotAvailableForSubscription`, so it was rejected as a replacement.

### Lesson

There are multiple types of availability problem:

```text
SKU exists in region
        |
        +-- may be restricted for the subscription
        |
        +-- may be allowed for the subscription but have no live capacity
```

---

## 28. List unrestricted VM SKUs

```powershell
az vm list-skus --location australiaeast --resource-type virtualMachines --all --query "[?restrictions==null || length(restrictions)==``0``].{Size:name,vCPUs:capabilities[?name=='vCPUs'].value | [0],MemoryGB:capabilities[?name=='MemoryGB'].value | [0],Zones:locationInfo[0].zones}" -o table
```

### Purpose

Instead of randomly guessing VM sizes, this query filtered toward SKUs with no subscription restrictions and displayed CPU and memory information.

### Selection

`Standard_B2als_v2` was chosen as a small lab-appropriate option:

```text
2 vCPU
4 GB RAM
```

---

## 29. Verify `Standard_B2als_v2` zone support and restrictions

```powershell
az vm list-skus --location australiaeast --resource-type virtualMachines --size Standard_B2als_v2 --all --query "[?name=='Standard_B2als_v2'].{Size:name,Zones:locationInfo[0].zones,Restrictions:restrictions}" -o json
```

### Result

```text
Restrictions: []
Zones: 1, 2, 3
```

The actual output listed the zones as `3, 2, 1`; the order does not matter.

---

# Part I — Create the three backend VMs

## 30. Create VM in Availability Zone 1

```powershell
az vm create --resource-group rg-az700-lb-aue --name vm-web-az1 --nics nic-web-az1 --image Canonical:0001-com-ubuntu-server-jammy:22_04-lts-gen2:latest --size Standard_B2als_v2 --zone 1 --admin-username azureuser --generate-ssh-keys --custom-data .\labs\01-load-balancer\manual-deployment\cloud-init.yaml
```

### Result

```text
vm-web-az1
Zone 1
Private IP 10.200.1.4
No public IP
VM running
```

---

## 31. Validate VM1 application bootstrap

```powershell
az vm run-command invoke --resource-group rg-az700-lb-aue --name vm-web-az1 --command-id RunShellScript --scripts "cloud-init status --wait; systemctl is-active apache2; cat /var/www/html/index.html" --query "value[0].message" -o tsv
```

### Azure CLI syntax

- `az vm run-command invoke` — ask the Azure VM agent to execute a command inside the VM.
- `--command-id RunShellScript` — use Linux shell execution.
- `--scripts "..."` — shell commands to run.
- commands are separated by semicolons.
- `--query "value[0].message" -o tsv` — print only the returned command output message.

### Linux command syntax inside `--scripts`

```text
cloud-init status --wait
```

Wait until cloud-init finishes.

```text
systemctl is-active apache2
```

Check whether the Apache service is active.

```text
cat /var/www/html/index.html
```

Print the generated web page.

### Result

```text
status: done
active
Served by: vm-web-az1
```

### Lesson

`VM running` only proves the VM is powered on. It does **not** prove that cloud-init finished or that the application is healthy. We validated those separately.

---

## 32. Create and validate VM in Availability Zone 2

Create:

```powershell
az vm create --resource-group rg-az700-lb-aue --name vm-web-az2 --nics nic-web-az2 --image Canonical:0001-com-ubuntu-server-jammy:22_04-lts-gen2:latest --size Standard_B2als_v2 --zone 2 --admin-username azureuser --generate-ssh-keys --custom-data .\labs\01-load-balancer\manual-deployment\cloud-init.yaml
```

Validate:

```powershell
az vm run-command invoke --resource-group rg-az700-lb-aue --name vm-web-az2 --command-id RunShellScript --scripts "cloud-init status --wait; systemctl is-active apache2; cat /var/www/html/index.html" --query "value[0].message" -o tsv
```

Result:

```text
vm-web-az2
Zone 2
10.200.1.5
Apache active
Served by: vm-web-az2
```

---

## 33. Create and validate VM in Availability Zone 3

Create:

```powershell
az vm create --resource-group rg-az700-lb-aue --name vm-web-az3 --nics nic-web-az3 --image Canonical:0001-com-ubuntu-server-jammy:22_04-lts-gen2:latest --size Standard_B2als_v2 --zone 3 --admin-username azureuser --generate-ssh-keys --custom-data .\labs\01-load-balancer\manual-deployment\cloud-init.yaml
```

Validate:

```powershell
az vm run-command invoke --resource-group rg-az700-lb-aue --name vm-web-az3 --command-id RunShellScript --scripts "cloud-init status --wait; systemctl is-active apache2; cat /var/www/html/index.html" --query "value[0].message" -o tsv
```

Result:

```text
vm-web-az3
Zone 3
10.200.1.6
Apache active
Served by: vm-web-az3
```

---

# Part J — Load Balancer validation

## 34. Retrieve the frontend public IP

```powershell
az network public-ip show --resource-group rg-az700-lb-aue --name pip-az700-lb-aue --query ipAddress -o tsv
```

### Result

```text
20.92.75.118
```

### Why `-o tsv` was useful

Instead of printing a JSON object such as:

```json
{"ipAddress":"20.92.75.118"}
```

TSV output returned only the value, making it convenient for terminal and scripting use.

---

## 35. First end-to-end HTTP test

```powershell
curl.exe -s http://20.92.75.118
```

### Syntax

- `curl.exe` — invoke the Windows curl executable explicitly.
- `-s` — silent mode; remove progress output.
- URL — make an HTTP request to the Load Balancer frontend.

### Result

The response contained:

```text
Served by: vm-web-az3
```

### What this proved

```text
Client
  -> Load Balancer public frontend
  -> TCP/80 rule
  -> healthy backend
  -> Apache
  -> response
```

It proved one successful end-to-end flow, but not yet distribution across all three backends.

---

## 36. Create multiple new client connections

```powershell
1..12 | ForEach-Object { (curl.exe -s -H "Connection: close" http://20.92.75.118 | Select-String "Served by").Line }
```

### PowerShell syntax breakdown

```text
1..12
```

Create the integer sequence 1 through 12.

```text
|
```

PowerShell pipeline operator. Send each item to the next command.

```text
ForEach-Object { ... }
```

Execute the script block once per pipeline item.

```text
curl.exe -s -H "Connection: close"
```

Perform the HTTP request and ask HTTP to close the connection rather than deliberately keeping it alive.

```text
| Select-String "Served by"
```

Filter the returned HTML for the line containing `Served by`.

```text
.Line
```

Return just the matching text line.

### Result

All three VMs appeared repeatedly. In this run the pattern happened to alternate cleanly:

```text
vm-web-az3
vm-web-az2
vm-web-az1
...
```

### Critical lesson: this is not proof of round-robin

Azure Load Balancer distributes flows using hash-based flow selection. Conceptually, the default decision includes the five-tuple:

```text
Source IP
Source port
Destination IP
Destination port
Protocol
```

Each new TCP connection normally has a different source port, so different flows can hash to different backends.

The observed neat sequence was an observation, **not a guarantee that Azure Load Balancer performs request-by-request round-robin**.

---

# Part K — Failure simulation

## 37. Stop Apache on VM2 without stopping the VM

```powershell
az vm run-command invoke --resource-group rg-az700-lb-aue --name vm-web-az2 --command-id RunShellScript --scripts "sudo systemctl stop apache2; systemctl is-active apache2" --query "value[0].message" -o tsv
```

### Result

```text
inactive
```

### Why this was a better test than powering off VM2

The VM itself remained running. Only the application service failed.

That allowed us to prove the health probe reacts to an **application/service failure**, not merely a powered-off server.

---

## 38. Wait for health probing and retest

```powershell
Start-Sleep -Seconds 40; 1..12 | ForEach-Object { (curl.exe -s --max-time 5 -H "Connection: close" http://20.92.75.118 | Select-String "Served by").Line }
```

### Syntax

- `Start-Sleep -Seconds 40` — PowerShell pauses before the next command.
- `;` — separates commands in the PowerShell statement.
- `--max-time 5` — curl stops waiting after five seconds if a request stalls.

### Result

Only:

```text
vm-web-az1
vm-web-az3
```

appeared.

`vm-web-az2` disappeared completely from new connections.

### What this proved

```text
Apache on VM2 failed
      |
      v
HTTP probe to VM2 failed
      |
      v
VM2 became ineligible for new flows
      |
      v
Traffic continued through VM1 and VM3
```

---

# Part L — Automatic recovery test

## 39. Restart Apache on VM2

```powershell
az vm run-command invoke --resource-group rg-az700-lb-aue --name vm-web-az2 --command-id RunShellScript --scripts "sudo systemctl start apache2; systemctl is-active apache2" --query "value[0].message" -o tsv
```

### Result

```text
active
```

---

## 40. Wait for health recovery and retest

```powershell
Start-Sleep -Seconds 40; 1..12 | ForEach-Object { (curl.exe -s --max-time 5 -H "Connection: close" http://20.92.75.118 | Select-String "Served by").Line }
```

### Result

All three VMs appeared again:

```text
vm-web-az1
vm-web-az3
vm-web-az2
...
```

### What this proved

No administrator action was required on the Load Balancer itself.

Once the probe succeeded again, VM2 automatically returned to the healthy backend set.

---

# Part M — Explicit outbound SNAT test

## 41. Check the public source IP seen from a backend VM

```powershell
az vm run-command invoke --resource-group rg-az700-lb-aue --name vm-web-az1 --command-id RunShellScript --scripts "curl -s https://api.ipify.org; echo" --query "value[0].message" -o tsv
```

### What happens inside this command

Azure Run Command executes inside `vm-web-az1`:

```bash
curl -s https://api.ipify.org
```

The external service returns the public source IP from which it sees the request.

### Result

```text
20.92.75.118
```

That was the Load Balancer's public IP.

### What this proved

```text
vm-web-az1 private IP
      |
      v
Load Balancer outbound rule
      |
      v
SNAT
      |
      v
20.92.75.118
      |
      v
Internet
```

The Load Balancer frontend public IP was therefore doing two distinct jobs through different rule types:

```text
Inbound rule:
20.92.75.118:80 -> healthy backend:80

Outbound rule:
backend -> SNAT via 20.92.75.118 -> Internet
```

---

# Part N — Git checkpoint before teardown

## 42. Check local Git working tree

```powershell
git status --short
```

### Result

```text
?? labs/01-load-balancer/manual-deployment/cloud-init.yaml
```

### Git syntax lesson

- `git status` — inspect the working tree and staging area.
- `--short` — use compact status output.
- `??` — Git sees a new **untracked file**.

An untracked file is **not included by `git push`**. Git only pushes commits; therefore a file must first be added to the index and committed.

---

# Part O — Teardown

## 43. Delete the manual deployment Resource Group

```powershell
az group delete --name rg-az700-lb-aue --yes
```

### Syntax

- `az group delete` — delete the Resource Group and resources inside it.
- `--name` — Resource Group to delete.
- `--yes` — do not prompt interactively for confirmation.

`--no-wait` was deliberately not used, so the CLI waited for Azure's deletion operation rather than immediately returning after starting it.

### Architectural/lifecycle lesson

Keeping the lab resources in one dedicated Resource Group made teardown predictable and reduced the risk of leaving billable lab infrastructure behind.

---

## 44. Verify teardown

```powershell
az group exists --name rg-az700-lb-aue
```

### Result

```text
false
```

### Meaning

The manual Azure environment had been removed successfully.

---

# Part P — What the completed tests proved

## 45. Baseline distribution

Observed:

```text
VM1 healthy
VM2 healthy
VM3 healthy
```

Repeated new connections reached all three backend VMs.

**Proved:** frontend, rule, backend pool, NSG, web servers, and health state allowed end-to-end service.

---

## 46. Application failure

Observed:

```text
VM2 still running
Apache on VM2 inactive
```

After the probe detection period, new connections reached VM1 and VM3 only.

**Proved:** a running VM with an unhealthy application can be removed from new Load Balancer flows.

---

## 47. Automatic recovery

Observed:

```text
Apache on VM2 restarted
Probe became healthy again
VM2 reappeared in new connection results
```

**Proved:** healthy backends automatically re-enter service without manually modifying the Load Balancer.

---

## 48. Explicit outbound connectivity

Observed from VM1:

```text
External source IP = Load Balancer public IP
```

**Proved:** the explicit Standard Load Balancer outbound rule was supplying SNAT for the private backend VMs.

---

# Part Q — Key networking mental model

The completed manual lab can be summarized as two paths.

## Inbound path

```text
Client
  |
  | TCP/80
  v
Standard public IP
  |
  v
Load Balancer frontend
  |
  v
Load-balancing rule
  |
  +--> health state decides which backends are eligible
  |
  v
Backend pool
  |
  v
NIC private IP
  |
  v
Subnet NSG evaluation
  |
  v
Apache :80
```

## Outbound path

```text
Private backend VM
  |
  v
Backend pool membership
  |
  v
Load Balancer outbound rule
  |
  v
SNAT to frontend public IP
  |
  v
Internet
```

---

# Part R — Key lessons from unexpected behavior

## 49. Zone support does not guarantee live capacity

`Standard_B1ms` supported the required zones but failed at deployment time because Azure had a capacity restriction.

```text
Supports Zone 1/2/3
        !=
Capacity available right now
```

---

## 50. Subscription restriction is a different problem

`Standard_B2s` existed in the region but Azure reported `NotAvailableForSubscription`.

This differs from the B1ms capacity failure.

---

## 51. `VM running` does not equal `application healthy`

For each VM we independently checked:

```text
cloud-init status: done
Apache: active
Web page: correct hostname
```

This separation between infrastructure state and application state is important in operations and troubleshooting.

---

## 52. Load Balancer distribution is flow based

The observed sequences should not be memorized as round-robin behavior.

A better model is:

```text
new network flow
     |
     v
flow hash
     |
     v
eligible healthy backend
```

---

## 53. Security is a separate evaluation layer

A Load Balancer configuration can be correct while the traffic still fails because of an NSG rule.

Troubleshooting should therefore separate:

```text
frontend/rule correctness
backend health
NSG decision
application listener
```

---

# Part S — Current checkpoint

The manual deployment is now:

```text
Built       ✅
Validated   ✅
Failure-tested ✅
Recovery-tested ✅
Outbound-tested ✅
Destroyed   ✅
```

Azure currently has no `rg-az700-lb-aue` Resource Group from the manual run.

The next infrastructure phase is to **rebuild the same logical architecture using Terraform**, then independently validate the Terraform-created environment with Azure CLI.

Before starting Terraform, synchronize and commit the local `cloud-init.yaml` file so the repository contains the manual deployment artifact as well as this documentation.
