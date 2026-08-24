# Lab 01 Handoff — Azure Load Balancer

Use this file to resume Lab 01 precisely. Update it during and at the end of every Lab 01 working session.

## Status

- **Lab:** 01 — Azure Load Balancer
- **State:** IN PROGRESS
- **Current phase:** Workstation/tool verification before direct Azure deployment
- **Last completed action:** Completed the first-pass visual lesson covering frontend IP, backend pool, health probes, load-balancing rules, five-tuple flow hashing, NSG evaluation, Layer 4 vs Layer 7, and Availability Zone resilience
- **Next action:** In the VS Code integrated terminal, verify Git is installed with `git --version`; then verify Azure CLI, Terraform, repository clone/authentication, and Azure context one action at a time
- **Last updated:** 2026-08-24 (Australia/Brisbane)

## Current architecture

Planned learning architecture:

```text
Client
  |
  v
Standard Public IP
  |
  v
Standard Azure Load Balancer
  |
  +--> TCP/80 load-balancing rule
  +--> HTTP/80 health probe
  |
  v
Backend pool
  |
  +--> Linux VM AZ1
  +--> Linux VM AZ2
  +--> Linux VM AZ3
          |
          v
     Web subnet / NSG
          |
          v
        Apache
```

## Completed checklist

- [x] Lab workspace created
- [x] Learning objectives recorded
- [x] Visual-learning worksheet created
- [x] Direct-deployment worksheet created
- [x] Terraform learning workspace created
- [x] Validation worksheet created
- [x] Troubleshooting journal created
- [x] First-pass mental model lesson completed
- [ ] Workstation/tool verification completed
- [ ] Direct deployment started
- [ ] Direct deployment completed
- [ ] Direct deployment validated
- [ ] Terraform implementation started
- [ ] Terraform implementation completed
- [ ] Terraform deployment validated
- [ ] Failure exercise completed
- [ ] Lab reflection completed
- [ ] Resources destroyed
- [ ] Lab marked COMPLETE

## Mental-model checkpoints

- [x] Learner understands that clients connect to the Load Balancer frontend rather than directly to individual backend VMs.
- [x] Learner understands that the backend pool contains candidate backend instances.
- [x] Learner understands that unhealthy backend instances do not receive new flows.
- [x] Learner understands the high-level request -> healthy backend -> response path.
- [x] Refinement recorded: health probes run continuously; the Load Balancer does not wait for each user request before probing the backends.
- [x] Five-tuple hashing and flow-based distribution taught; reinforce during live testing so the learner can observe why repeated browser refreshes do not guarantee round-robin behaviour.
- [x] Learner understands the load-balancing rule as the mapping between frontend and backend flow definitions.
- [x] Learner understands where NSG evaluation fits into the data path and that a deny can block an otherwise correct Load Balancer design.
- [x] NSG priority evaluation taught: lower numeric priority is evaluated first.
- [x] Layer 4 vs Layer 7 distinction taught; reinforce during comparison with Application Gateway later in the programme.
- [x] Availability Zone resilience taught: backends are spread across zones to reduce the impact of a zone-level failure.

## Decisions specific to Lab 01

- Preserve the reference lab's core objective: public Standard Load Balancer with three web backends across availability zones.
- Prefer secure SSH-key authentication rather than the source lab's shared lab password.
- Select the actual Azure region at execution time based on availability-zone and VM SKU availability.
- Use the source address space (`10.200.0.0/16`, subnet `10.200.1.0/24`) unless a real conflict is identified.
- Use Standard Load Balancer; Basic Load Balancer has been retired.
- Prefer a zone-redundant frontend public IP where the selected region supports availability zones.

## Commands already run

None yet.

## Resources currently deployed

None.

## Blockers

None.

## Evidence captured

- Microsoft Learn Load Balancer components checked on 2026-08-24 before teaching the lab.
- Learner explanation captured: VM1 and VM3 are eligible when VM2 is unhealthy; request reaches the public frontend, a healthy backend is selected, the application serves the request, and the response returns to the client.
- Learner explanation captured: if TCP/80 is denied by the NSG, the website cannot work; NSG rule evaluation is an appropriate next troubleshooting area once the Load Balancer and Apache are known good.
- Visual reference aids created in the conversation for Load Balancer architecture, flow hashing, Layer 4 vs Layer 7, and Availability Zones.

## What the learner should be able to explain by the end of Lab 01

1. Why the Load Balancer needs a frontend IP.
2. What the backend pool represents.
3. Why the health probe exists.
4. What the load-balancing rule maps.
5. Why Azure Load Balancer is Layer 4.
6. Why the three backends are distributed across availability zones.
7. Where the NSG fits into the data path.
8. Why traffic distribution is flow-hash based rather than simple request-by-request round-robin.
9. Why NSG priority numbers matter when multiple rules could match the same traffic.

## Resume instruction

Continue from workstation/tool verification in VS Code. First command: `git --version`. After Git, verify `az`, `terraform`, GitHub/local repository access, and Azure subscription context one action at a time. Do not start Terraform implementation before the direct Azure deployment has been completed and validated.
