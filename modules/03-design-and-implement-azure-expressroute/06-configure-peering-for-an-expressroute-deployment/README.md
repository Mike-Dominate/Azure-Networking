# Unit 06 — Configure peering for an ExpressRoute deployment

**BlueHarbor chapter:** The private path needs routes  
**Status:** NOT STARTED

## Business event

The circuit exists, but BlueHarbor and Microsoft need to exchange routing information so each side knows which prefixes are reachable.

## Routing model

```text
BlueHarbor prefixes
172.16.0.0/16
172.17.0.0/16

BGP route exchange

Azure private address spaces
10.10.0.0/16
10.20.0.0/16
10.30.0.0/16
```

## Concepts to master

- ASN
- BGP neighbor
- BGP session
- route advertisement
- learned route
- Azure private peering
- Microsoft peering
- route advertisement policy

## Mental model

The circuit is the private road. BGP exchanges the maps that tell each side which destinations are reachable through that road.
