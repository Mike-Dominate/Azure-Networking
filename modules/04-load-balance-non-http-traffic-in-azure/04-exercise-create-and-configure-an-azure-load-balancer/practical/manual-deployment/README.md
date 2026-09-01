# Lab 01 — Direct Azure Deployment

## Purpose

Build the Load Balancer architecture directly before Terraform so each Azure object can be seen and understood.

## Rule

Do not treat this as a click-through recipe. At every major object, pause and explain what it contributes to the traffic path.

## Planned resources

- Resource group
- VNet `10.200.0.0/16`
- Web subnet `10.200.1.0/24`
- Network Security Group
- Three Linux VM NICs
- Three Ubuntu VMs across availability zones 1, 2, and 3 where available
- Apache on each VM with a page identifying the backend
- Standard public IP
- Standard public Azure Load Balancer
- Frontend IP configuration
- Backend address pool
- HTTP health probe on port 80
- TCP load-balancing rule 80 -> 80

## Deployment record

The exact portal/CLI actions will be added as they are performed during Lab 01 rather than pre-filled blindly.

### Resource group

_To be completed._

### VNet and subnet

_To be completed._

### NSG

_To be completed._

### Backend VMs

_To be completed._

### Load Balancer

_To be completed._

### Backend pool

_To be completed._

### Health probe

_To be completed._

### Load-balancing rule

_To be completed._

## Verification before moving to Terraform

- [ ] All expected resources visible in Azure
- [ ] Each backend web server responds internally/appropriately
- [ ] Load Balancer frontend public IP assigned
- [ ] Backends registered in backend pool
- [ ] Health probe reports healthy backends
- [ ] Repeated HTTP requests demonstrate distribution
- [ ] Azure CLI queries saved in validation notes
- [ ] Architecture can be explained before teardown/rebuild
