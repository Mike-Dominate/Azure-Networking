# Lab 04 Handoff — Azure DNS, Private DNS & DNS Private Resolver

## Status

- **Lab:** 04 — Azure DNS, Private DNS & DNS Private Resolver
- **State:** IN PROGRESS
- **Current phase:** Tutorial / mental model
- **Deployment phase:** NOT STARTED
- **Previous lab:** Lab 03 — COMPLETE

## Authoritative Lab 04 scope

Use the original Lab 04 scope only:

- Azure public DNS zones
- private DNS zones
- VNet links and auto-registration concepts
- custom DNS settings on VNets
- Azure DNS Private Resolver
- inbound and outbound endpoints
- forwarding rulesets
- hybrid/on-premises name resolution
- DNS troubleshooting and packet/query flow

Supporting DNS fundamentals may be taught only where they directly support these topics; they are not separate Lab 04 scope items.

## Tutorial progress completed so far

The following supporting public-DNS fundamentals have already been demonstrated interactively with `nslookup`:

- recursive resolver versus authoritative DNS
- public DNS hierarchy and delegation concepts
- NS records
- CNAME chains across different authoritative providers
- MX records
- SOA records
- common record types: A, AAAA, CNAME, MX, TXT, NS, SOA, PTR
- a normal recursive resolver returning no usable A record for `web.lab04.example.com`

Observed examples included Microsoft public DNS hosted on Azure DNS authoritative name servers and a CNAME chain from Microsoft into Akamai authoritative DNS.

## Important workflow correction

The programme pattern is:

```text
complete tutorial / mental model
-> visual architecture and query flows
-> understanding check
-> design the lab
-> manual Azure CLI deployment
-> validation
-> deliberate failure and troubleshooting
-> Portal inspection where useful
-> Terraform rebuild
-> evidence and documentation
-> safe teardown
-> explain-back
```

Do not begin or continue Lab 04 deployment until the complete tutorial covering the authoritative nine-topic scope is finished.

## Resume point

Continue the tutorial from the first official topic:

```text
Azure public DNS zones
```

Then proceed through the original scope in order:

```text
1. Azure public DNS zones
2. private DNS zones
3. VNet links and auto-registration concepts
4. custom DNS settings on VNets
5. Azure DNS Private Resolver
6. inbound and outbound endpoints
7. forwarding rulesets
8. hybrid/on-premises name resolution
9. DNS troubleshooting and packet/query flow
```

Only after all nine topics are understood should the Lab 04 implementation be designed and started.
