# BlueHarbor Cumulative Terraform Stack

This directory is the **single authoritative Terraform root** for the entire BlueHarbor AZ-700 engineering project.

## Core rule

Every applicable Microsoft Learn unit extends the Terraform code and state produced by the previous unit.

```text
first practical
    Terraform baseline
          |
          + next requirement
          v
next practical
    same code + same state + new resources/config
          |
          + next requirement
          v
...
          |
          v
Module 8
    complete BlueHarbor environment
```

This is not a folder containing independent lab solutions.

## What we do NOT do

Do not:

- create `lab01/terraform`, `lab02/terraform`, `lab03/terraform` as independent full deployments;
- copy the complete previous Terraform project into a new unit folder;
- start a fresh state file because a new lab begins;
- destroy the environment at the end of every unit;
- create persistent Azure resources manually in Portal/CLI and leave Terraform unaware of them;
- accept a plan that unexpectedly destroys earlier BlueHarbor infrastructure.

## What we DO

For each practical unit:

```text
1. inspect current code/state/environment
2. identify the new BlueHarbor requirement
3. change this Terraform root
4. terraform fmt -recursive
5. terraform init
6. terraform validate
7. terraform plan
8. inspect the delta carefully
9. terraform apply
10. independently validate Azure behaviour
11. run failure/troubleshooting exercise
12. encode permanent infrastructure fixes here
13. re-plan / re-apply / re-validate
14. commit the checkpoint to Git
15. continue from this exact state in the next unit
```

## Git is the lab-history mechanism

The current working tree always represents the latest complete BlueHarbor architecture.

Historical lab states are recovered from Git commits rather than by maintaining duplicate Terraform directories.

Conceptually:

```text
Git commit A = BlueHarbor after M1 U04
Git commit B = BlueHarbor after M1 U06
Git commit C = BlueHarbor after M1 U08
...
main         = current full environment
```

## State rule

The first real Terraform deployment establishes the state lineage for the project. The chosen backend must be documented and maintained consistently.

State files and sensitive variable values must not be committed to Git.

Never delete state simply to avoid fixing a Terraform/Azure discrepancy.

## Plan rule

Every plan should be read as a change report against the environment we have already built.

Typical healthy progression:

```text
previous resources: unchanged
new unit resources: create
required integration changes: update in place where expected
unexpected destroy/replace: STOP AND INVESTIGATE
```

A replacement can be valid, but only when the BlueHarbor design intentionally requires it and the reason is understood before apply.

## Provisioning versus validation

Terraform manages persistent infrastructure.

Azure CLI, Portal and protocol tools can be used to:

- query actual resource state;
- inspect assigned addresses and effective configuration;
- test DNS, HTTP and connectivity;
- inspect routes, health and logs;
- troubleshoot.

The validation tool must not become a second unmanaged provisioning path.

## Expected growth

Files are added only when the BlueHarbor story introduces that concern. Over the full programme this directory may evolve toward something like:

```text
versions.tf
providers.tf
variables.tf
locals.tf
network.tf
dns.tf
peering.tf
routing.tf
nat.tf
hybrid.tf
expressroute.tf
load-balancing.tf
application-delivery.tf
security.tf
private-access.tf
monitoring.tf
outputs.tf
```

This list is a possible destination, not a requirement to create empty files in advance.

## End state

By Module 8, this Terraform root should describe the cumulative BlueHarbor Azure networking environment built from Module 1 onward, with monitoring observing the same network, hybrid connectivity, delivery, security and private-access components created throughout the programme.
