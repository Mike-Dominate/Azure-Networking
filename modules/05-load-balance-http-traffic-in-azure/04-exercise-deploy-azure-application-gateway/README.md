# Unit 04 — Exercise: Deploy Azure Application Gateway

**BlueHarbor chapter:** Build and troubleshoot the Australia East Partner Hub  
**Status:** NOT STARTED

Preserve the Microsoft exercise objective, but implement the persistent architecture through the existing `blueharbor/terraform/` root.

## Expected cumulative Terraform delta

```text
existing Modules 1–4
+
bhi-vnet-partner-aue 10.40.0.0/16
+
snet-appgw       10.40.1.0/24
snet-partner-app  10.40.2.0/24
+
Virtual WAN VNet connection -> bhi-vhub-aue
+
nat-partner-aue / explicit app-subnet egress
+
Partner Hub backend compute/services
+
appgw-partner-aue Standard_v2
```

## Validation/failure work

- generate real HTTP(S) requests;
- prove path-based routing;
- inspect listener/rule/pool/probe relationships;
- make one backend unhealthy;
- break the configured health path;
- introduce a host-header/backend-setting error;
- identify whether the failure is IP reachability or Layer 7 configuration.

A successful apply is not proof of correct application delivery.

## Carry-forward rule

Do not tear the unit down. The Partner Hub AUE resources remain deployed and become the first real origin for Front Door later in the module.
