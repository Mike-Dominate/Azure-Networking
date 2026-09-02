# Source and Coverage Reference

## Authority order

The BlueHarbor programme uses three Microsoft authorities for different purposes:

```text
Microsoft Learn AZ-700 learning path
  -> curriculum module/unit order

Current AZ-700 study guide
  -> completeness check against skills measured

Current Azure product documentation
  -> exact technical behaviour / implementation constraints
```

Primary curriculum:

`https://learn.microsoft.com/en-us/training/paths/design-implement-microsoft-azure-networking-solutions-az-700/`

Coverage authority:

`https://learn.microsoft.com/en-us/credentials/certifications/resources/study-guides/az-700`

Current coverage baseline:

```text
AZ-700 skills measured effective July 27, 2026
Last BlueHarbor coverage verification: September 2, 2026
```

The objective-by-objective mapping is maintained in:

[`AZ700-STUDY-GUIDE-COVERAGE.md`](AZ700-STUDY-GUIDE-COVERAGE.md)

## Curriculum rule

Microsoft Learn controls **when** a topic is introduced. The study guide controls whether the programme is **complete enough**.

If the study guide contains a capability that the main Learn unit treats only briefly, add it as an extension inside the nearest matching Learn unit. Do not create a disconnected parallel lab sequence simply to tick exam bullets.

Example:

```text
M1 name-resolution units
  -> Azure DNS / VNet DNS
  -> study-guide extension: DNS Private Resolver concepts

M2 hybrid requirement appears
  -> deploy the actual Core DNS Private Resolver endpoints
```

## Authoritative practical workflow

Persistent Azure infrastructure is **Terraform-first and cumulative**.

```text
Microsoft Learn unit
 -> BlueHarbor business requirement
 -> mental model / architecture / packet or query flow
 -> understanding check
 -> inspect CURRENT Terraform + deployed estate
 -> define the smallest coherent delta
 -> modify SAME blueharbor/terraform root
 -> terraform fmt / init / validate / plan
 -> STOP on unexplained destroy/replace
 -> terraform apply when the unit requires infrastructure
 -> independent CLI / Portal / protocol validation
 -> deliberate failure / troubleshooting
 -> reconcile permanent fixes into Terraform
 -> evidence / Git checkpoint
 -> next unit starts from this exact code/state/environment
```

Azure CLI, PowerShell, Portal and protocol tools are for inspection, validation, exercises and troubleshooting. They must not become an unmanaged second provisioning path for persistent BlueHarbor infrastructure.

There is **no normal `safe teardown` step** at the end of a unit or module. Intentional retirement/replacement occurs only when a later BlueHarbor requirement changes the architecture.

See [`WORKING-METHOD.md`](WORKING-METHOD.md) for the operational workflow.

## Coverage modes

Study-guide objectives are intentionally classified rather than forcing every feature into the persistent architecture:

```text
BUILD
 -> persistent cumulative BlueHarbor resource/configuration

CONFIGURE / VALIDATE
 -> real configuration/diagnostic work on existing BlueHarbor resources

CONTROLLED EXPERIMENT
 -> hands-on change used to learn a feature; any temporary delta is deliberately reconciled into the approved architecture

DESIGN / TROUBLESHOOT
 -> deep architecture, configuration-object, packet/route and failure analysis where persistent deployment would distort the cumulative design

CONDITIONAL EXTERNAL
 -> hands-on when a carrier, owned public prefix, RADIUS/NVA appliance, real public domain/certificate or other external prerequisite exists; otherwise rigorous design/configuration/failure analysis
```

Coverage completeness does **not** mean every Azure feature remains permanently deployed. It means every current exam objective has a deliberate learning home and treatment.

## External-dependency rule

Provider- or ownership-dependent features must be represented honestly.

Examples include:

- ExpressRoute provider provisioning and some BGP operations;
- ExpressRoute Direct/MACsec-specific scenarios;
- Microsoft peering that requires validated public prefixes;
- Custom IP Prefix / BYOIP;
- third-party Virtual WAN NVAs;
- RADIUS environments;
- trusted public-domain certificates for end-to-end TLS.

Never claim a dependency exists when it does not.

## Cost rule

Cost does not justify routine destruction of the cumulative environment. Where a study objective requires a commercial/external dependency that cannot realistically be obtained for the lab, preserve the real BlueHarbor architecture and use serious configuration/failure analysis instead of a fake deployment.

## Drift-prevention rule

Before teaching or implementing any unit:

1. confirm the current Microsoft Learn unit title/objective;
2. check the corresponding rows in `AZ700-STUDY-GUIDE-COVERAGE.md`;
3. verify service constraints against current Microsoft product documentation;
4. inspect the current BlueHarbor Terraform/state/environment;
5. do not pre-build future resources merely because their final design is known;
6. update roadmap/handoff/coverage when Microsoft changes the learning path or study guide.
