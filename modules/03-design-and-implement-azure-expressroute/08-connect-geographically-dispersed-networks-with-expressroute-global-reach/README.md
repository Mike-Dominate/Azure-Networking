# Unit 08 — Connect geographically dispersed networks with ExpressRoute global reach

**BlueHarbor chapter:** Connect BlueHarbor sites through Microsoft's backbone  
**Status:** NOT STARTED

## Business event

Multiple BlueHarbor physical sites now connect through compatible ExpressRoute circuits and need private site-to-site communication.

## Architecture

```text
Brisbane on-premises
 -> ExpressRoute
 -> Microsoft backbone
 -> ExpressRoute
 -> Singapore on-premises
```

## Mental model

```text
Normal ExpressRoute
on-premises -> Microsoft/Azure

Global Reach
on-premises -> Microsoft backbone -> another on-premises site
```

The learner must distinguish Global Reach from VNet peering, Site-to-Site VPN and ordinary VNet-to-ExpressRoute connectivity.
