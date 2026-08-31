# Lab 04 Handoff — Azure DNS, Private DNS & DNS Private Resolver

## Status

- **Lab:** 04 — Azure DNS, Private DNS & DNS Private Resolver
- **State:** IN PROGRESS
- **Previous lab:** Lab 03 — COMPLETE
- **Current phase:** Public DNS mental model COMPLETE; Azure public DNS zone design/deployment is NEXT
- **Azure resources:** NONE CREATED YET
- **Started:** 2026-08-31 (Australia/Brisbane)

## Immediate resume point

Do **not** repeat the introductory DNS tutorial. The public DNS mental model has already been worked through interactively with real `nslookup` queries.

Resume at:

```text
1. finish the pre-deployment baseline query for web.lab04.example.com
2. design the Azure public DNS test zone
3. create rg-az700-dns-aue
4. create public Azure DNS zone lab04.example.com
5. inspect Azure-assigned authoritative name servers
6. create A / CNAME / TXT records
7. query Azure authoritative name servers directly
8. prove normal recursive Internet resolution still lacks delegation
9. then move to Azure-provided DNS inside a VNet
10. continue to Private DNS zones, VNet links, auto-registration and DNS Private Resolver
```

## DNS mental model already completed

### Resolver role

Observed local recursive resolvers during the tutorial:

```text
JBA-Router.bems.net  10.10.1.1
unifi.localdomain    10.48.0.1
```

The resolver changed when the client network changed. The role remained the same:

```text
recursive resolver = finds the answer for the client, potentially using cache and/or recursive lookups
```

### Authoritative vs recursive DNS

Retained distinction:

```text
Recursive resolver
= "find the useful/final answer for me"

Authoritative DNS
= "I own the official records for this zone"
```

### Public DNS hierarchy

The tutorial walked through the simplified hierarchy:

```text
client
-> recursive resolver
-> DNS root
-> TLD (.com / .net)
-> authoritative DNS for the requested zone
-> record answer
```

DNS is distributed authority, not one global database server.

### microsoft.com authority proved

Command:

```powershell
nslookup -type=ns microsoft.com
```

Observed authoritative name servers:

```text
ns1-39.azure-dns.com
ns2-39.azure-dns.net
ns3-39.azure-dns.org
ns4-39.azure-dns.info
```

This demonstrated that the public `microsoft.com` zone is hosted on Azure DNS authoritative infrastructure.

### Direct authoritative query proved

Command:

```powershell
nslookup -type=cname www.microsoft.com ns1-39.azure-dns.com
```

Observed:

```text
www.microsoft.com canonical name = www.microsoft.com-c-3.edgekey.net
```

The Azure DNS authoritative server returned the record it owns for the `microsoft.com` zone rather than recursively resolving the entire external CNAME chain.

### CNAME chain and second authority proved

Recursive lookup showed:

```text
www.microsoft.com
-> www.microsoft.com-c-3.edgekey.net
-> e13678.dscb.akamaiedge.net
-> IPv4 / IPv6 addresses
```

The returned edge IP changed between lookups, which reinforced that DNS/CDN answers can vary by time, resolver/location and edge selection.

Command:

```powershell
nslookup -type=ns edgekey.net
```

returned Akamai authoritative servers including:

```text
ns1-2.akam.net
usw6.akam.net
a3-65.akam.net
...
```

Direct Akamai authoritative query:

```powershell
nslookup -type=cname www.microsoft.com-c-3.edgekey.net ns1-2.akam.net
```

Observed:

```text
www.microsoft.com-c-3.edgekey.net canonical name = e13678.dscb.akamaiedge.net
```

This proved a DNS resolution chain can cross from one authoritative zone/provider to another.

## DNS record types covered

```text
A      hostname -> IPv4 address
AAAA   hostname -> IPv6 address
CNAME  hostname -> another hostname
MX     domain -> mail exchanger
TXT    text used for verification/security/policy data
NS     identifies authoritative name servers for a zone
SOA    zone administrative/control metadata
PTR    IP address -> hostname (reverse DNS concept)
```

### MX example observed

```powershell
nslookup -type=mx microsoft.com
```

Observed:

```text
microsoft.com MX preference = 10
mail exchanger = microsoft-com.mail.protection.outlook.com
```

### SOA example observed

```powershell
nslookup -type=soa microsoft.com
```

Observed:

```text
primary name server = ns1-39.azure-dns.com
responsible mail addr = azuredns-hostmaster.microsoft.com
serial  = 1
refresh = 3600
retry   = 300
expire  = 2419200
default TTL = 300
```

SOA concepts covered: primary authority, administrative contact, serial/version, refresh, retry, expiry and TTL/negative caching behaviour.

## Delegation mental model retained

Creating a DNS zone and delegating a DNS namespace are separate actions.

```text
parent DNS zone / registrar
        |
        | NS delegation
        v
child authoritative DNS zone
        |
        v
records inside that zone
```

For the planned test design:

```text
example.com              parent namespace
        |
        | delegation would be required for normal Internet resolution
        v
lab04.example.com         child zone hosted in Azure DNS
```

We do not own `example.com`, so the lab will use direct queries to Azure authoritative name servers to prove records exist while separately proving that creating the zone alone does not create public delegation.

## Planned Azure public DNS test design

```text
Resource Group: rg-az700-dns-aue
Region:         australiaeast
Public zone:    lab04.example.com
```

Planned records:

```text
A      web       -> documentation/test IPv4 address
CNAME  portal    -> web.lab04.example.com
TXT    @         -> lab verification text
NS/SOA @         -> automatically present with the Azure DNS zone
```

Important architecture note:

```text
Azure DNS public zones are global DNS resources.
The resource group has a region, but the public DNS zone is not a regional workload endpoint.
```

## Pre-deployment baseline started

A normal recursive query was run for:

```text
web.lab04.example.com
```

The simple `nslookup` output returned the queried name but no usable address. The next command should make the baseline explicit by querying the A record type:

```powershell
nslookup -type=A web.lab04.example.com
```

Do this before creating the Azure DNS zone so the before/after behaviour is preserved.

## Scope still to prove practically

- Azure DNS public zone/record behaviour
- direct authoritative queries to Azure DNS
- absence of normal public recursion without parent delegation
- Azure-provided DNS inside a VNet
- Private DNS zone visibility through VNet links
- manual private DNS records
- auto-registration behaviour
- cross-VNet private DNS resolution
- split-horizon/private-name-resolution behaviour
- DNS Private Resolver inbound resolution path
- DNS Private Resolver outbound forwarding path
- forwarding ruleset behaviour
- deliberate DNS failure/recovery cases
- Terraform rebuild and convergence

## Critical rule

Provisioning state `Succeeded` does not prove DNS works. DNS must be tested with actual name-resolution queries, and the resolver, authority, returned record and intended query path must be understood.
