# Lab 01 Handoff — Azure Load Balancer

Use this file to resume Lab 01 precisely. Update it during and at the end of every Lab 01 working session.

## Status

- **Lab:** 01 — Azure Load Balancer
- **State:** NOT STARTED
- **Current phase:** Visual learning
- **Last completed action:** Repository and Lab 01 workspace created
- **Next action:** Teach and complete the Azure Load Balancer mental model before deployment
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
- [ ] Mental model lesson completed
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

## Decisions specific to Lab 01

- Preserve the reference lab's core objective: public Standard Load Balancer with three web backends across availability zones.
- Prefer secure SSH-key authentication rather than the source lab's shared lab password.
- Select the actual Azure region at execution time based on availability-zone and VM SKU availability.
- Use the source address space (`10.200.0.0/16`, subnet `10.200.1.0/24`) unless a real conflict is identified.

## Commands already run

None yet.

## Resources currently deployed

None.

## Blockers

None.

## Evidence captured

None yet.

## What the learner should explain before moving on

Before direct deployment, explain in your own words:

1. Why the Load Balancer needs a frontend IP.
2. What the backend pool represents.
3. Why the health probe exists.
4. What the load-balancing rule maps.
5. Why Azure Load Balancer is Layer 4.
6. Why the three backends are distributed across availability zones.
7. Where the NSG fits into the data path.

## Resume instruction

Start with `../visual-learning/architecture.md`. Do not begin Terraform until the direct Azure architecture has been understood and validated.
