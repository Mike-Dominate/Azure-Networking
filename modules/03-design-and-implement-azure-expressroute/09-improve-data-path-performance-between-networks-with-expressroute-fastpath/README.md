# Unit 09 — Improve data path performance between networks with ExpressRoute FastPath

**BlueHarbor chapter:** Evaluate FastPath against the exact cumulative Virtual WAN design  
**Status:** NOT STARTED

## Current Virtual WAN eligibility contract

For BlueHarbor's Virtual WAN implementation, treat FastPath as active only when the current supported conditions are met:

```text
ExpressRoute Direct circuit
+
Virtual WAN ExpressRoute Gateway >= 5 scale units
        -> FastPath automatically enabled for supported traffic
```

A standard provider ExpressRoute circuit must **not** be described as FastPath-enabled inside Virtual WAN under the current support matrix.

## Mental model

```text
control/routing architecture
still includes the ExpressRoute gateway

supported FastPath data traffic
can use a more direct supported path
```

## Engineering rule

If BlueHarbor uses ExpressRoute Direct and the qualifying Virtual WAN gateway scale, validate FastPath in the same architecture.

If BlueHarbor uses a provider circuit, explain the exact eligibility gap and the supported Direct reference design instead of creating a disconnected second ExpressRoute topology just to tick the objective.

Also distinguish this Virtual WAN rule from classic VNet ExpressRoute-gateway FastPath scenarios; do not merge the support matrices conceptually.
