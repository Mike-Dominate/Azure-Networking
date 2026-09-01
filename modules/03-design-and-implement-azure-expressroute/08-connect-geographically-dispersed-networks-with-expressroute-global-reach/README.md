# Unit 08 — Connect geographically dispersed networks with ExpressRoute global reach

**BlueHarbor chapter:** Connect the existing Brisbane and Perth sites through Microsoft's backbone  
**Status:** NOT STARTED

## Story continuity

Do not invent a Singapore office. Reuse the two physical locations already established in Module 2:

```text
Brisbane HQ
 -> ExpressRoute circuit/provider path A
 -> Microsoft backbone / Global Reach
 -> ExpressRoute circuit/provider path B
 -> Perth Manufacturing
```

## Mental model

```text
Normal ExpressRoute
on-premises -> Microsoft/Azure

Global Reach
on-premises -> Microsoft backbone -> another on-premises site
```

If real carrier circuits are unavailable, preserve this same architecture in serious circuit/BGP/routing/failure analysis rather than creating a disconnected demo topology.
