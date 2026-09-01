# Unit 10 — Troubleshoot ExpressRoute connection issues

**BlueHarbor chapter:** Production incident  
**Status:** NOT STARTED

## Incident

BlueHarbor Manufacturing reports that an Azure ERP workload is unreachable from Brisbane.

## Troubleshooting chain

```text
application / destination
 -> Azure NIC / VNet route
 -> ExpressRoute Gateway
 -> BGP learned route
 -> ExpressRoute peering
 -> circuit state
 -> provider path
 -> BlueHarbor edge
```

## Deliberate failure candidates

- BGP session down
- wrong ASN
- wrong peer addressing
- missing prefix advertisement
- route filtering
- provider provisioning issue
- gateway/circuit relationship issue
- route preference problem
- asymmetric routing
- provider/path failure

## Operating principle

Troubleshoot in layers:

```text
circuit -> peering -> BGP -> routes -> gateway/VNet -> workload
```

BGP depth remains Azure-practical: ASN, neighbor, session, prefix, advertisement, learned route and preferred path.
