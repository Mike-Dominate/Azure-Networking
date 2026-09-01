# Unit 06 — Exercise: Create a Front Door for a highly available web application

**BlueHarbor chapter:** Prove global origin failover  
**Status:** NOT STARTED

## Target architecture

```text
portal.blueharbor.example
        |
Azure Front Door
        |
   +----+----+
   |         |
Australia   Europe
origin      origin
```

## Required practical behaviour

- build the Microsoft exercise objective in the BlueHarbor story;
- validate origins, origin group and routes;
- test normal HTTP(S) delivery;
- deliberately fail one origin;
- observe health and routing behaviour;
- compare the result with Traffic Manager's DNS-based failover model;
- introduce and troubleshoot one route/origin/host configuration error;
- use Azure CLI/Terraform where appropriate;
- capture evidence and tear down safely.

The key lesson is that Front Door remains in the web application path, whereas Traffic Manager changes DNS answers and then leaves the data path.
