# Unit 07 — Summary

**BlueHarbor chapter:** Application-delivery architecture review  
**Status:** NOT STARTED

## Final service-selection mental model

```text
Azure Load Balancer
regional Layer 4 TCP/UDP distribution

Traffic Manager
global DNS-based endpoint selection

Application Gateway
regional Layer 7 HTTP(S) routing

Azure Front Door
global Layer 7 HTTP(S) application delivery
```

## Explain-back requirements

Be able to explain:

- why Layer 4 cannot solve URL-path/hostname routing;
- listener, rule, backend pool, backend setting and probe relationships;
- path-based versus hostname-based routing;
- TLS termination versus end-to-end TLS;
- Application Gateway versus Front Door;
- Traffic Manager versus Front Door;
- how a healthy network path can still fail at HTTP layer;
- how regional Application Gateway and global Front Door can coexist.

Module 6 begins when BlueHarbor's Security team asks how to protect the networks and applications that now exist.
