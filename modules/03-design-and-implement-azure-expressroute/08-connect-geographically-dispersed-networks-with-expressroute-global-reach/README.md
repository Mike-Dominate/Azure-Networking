# Unit 08 — Connect geographically dispersed networks with ExpressRoute global reach

**BlueHarbor chapter:** Add a second ExpressRoute circuit/path and connect Brisbane and Perth  
**Status:** NOT STARTED

## Story continuity

Do not invent a Singapore office. Reuse the two physical locations already established in Module 2.

Global Reach requires two ExpressRoute circuit/provider paths:

```text
Brisbane HQ
 -> ExpressRoute circuit/provider path A
 -> Microsoft backbone / Global Reach
 -> ExpressRoute circuit/provider path B
 -> Perth Manufacturing
```

The Brisbane path is introduced earlier in Module 3. This unit introduces/models the distinct Perth circuit/provider path required for the Global Reach objective.

## Mental model

```text
Normal ExpressRoute
on-premises -> Microsoft/Azure

Global Reach
on-premises circuit A -> Microsoft backbone -> on-premises circuit B
```

## Important future security lifecycle

Global Reach circuit-to-circuit traffic does not traverse the Virtual WAN hub security appliance. Therefore it becomes an intentional bypass once Module 6 requires centrally inspected private transit.

Module 6 will disable Global Reach after the secured ER-to-ER path is proven. That is a deliberate security evolution, not lab cleanup.

If real carrier circuits are unavailable, preserve this exact two-circuit architecture in serious circuit/BGP/routing/failure analysis rather than creating a disconnected demo topology.
