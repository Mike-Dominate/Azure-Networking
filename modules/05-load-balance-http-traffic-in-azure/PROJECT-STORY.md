# BlueHarbor Industries — Module 5 Project Story

## Project — Launch the BlueHarbor Partner Hub globally

**Microsoft Learn module:** Load balance HTTP(S) traffic in Azure  
**Company:** BlueHarbor Industries (BHI)  
**Status:** NOT STARTED

## Starting point from Module 4

BlueHarbor already understands two important availability patterns:

```text
Azure Load Balancer
-> regional Layer 4 TCP/UDP distribution

Azure Traffic Manager
-> global DNS-based endpoint selection
```

Those patterns solve useful problems, but BlueHarbor is now launching an HTTP/HTTPS application whose routing decisions depend on the application request itself.

The new service is the **BlueHarbor Partner Hub**:

```text
https://portal.blueharbor.example
https://portal.blueharbor.example/engineering
https://portal.blueharbor.example/orders
https://portal.blueharbor.example/support
```

The Module 5 business question is:

> How should BlueHarbor deliver HTTP(S) applications when routing decisions depend on hostnames, URL paths, TLS, backend health and global web performance?

The Microsoft Learn unit order remains authoritative. Each unit below is the next chapter of this same project.

---

## Chapter 01 — Introduction: Layer 4 is no longer enough

The Partner Hub initially runs behind a simple regional network path, but application teams now require different HTTP requests to reach different backend services.

Example request:

```text
GET /engineering
Host: portal.blueharbor.example
```

The routing decision now depends on application-layer information such as:

- hostname;
- URL path;
- HTTP/HTTPS behaviour;
- backend application health;
- TLS requirements.

### Core lesson

```text
Layer 4 decision
IP + port + protocol

Layer 7 decision
HTTP host + path + application behaviour
```

This creates the reason for Azure Application Gateway.

---

## Chapter 02 — Design Azure Application Gateway: Build the regional web entrance

BlueHarbor needs one controlled HTTP(S) entry point for the Partner Hub in Australia East.

```text
Internet
   |
 HTTPS
   |
Application Gateway
   |
+-- Engineering backend pool
+-- Orders backend pool
+-- Support backend pool
```

### Business requirements

- one regional HTTP(S) entry point;
- multiple backend services;
- application-aware health checks;
- hostname and URL-path routing;
- TLS-aware design;
- public or private frontend according to audience.

### Concepts to master

- frontend IP configuration;
- listener;
- request-routing rule;
- backend pool;
- backend setting;
- health probe;
- TLS certificate and TLS termination concepts;
- public versus private frontend;
- Application Gateway subnet requirement and placement.

### Mental model

The gateway is not merely selecting a server. It can understand **what web request arrived** and apply application-layer routing rules.

---

## Chapter 03 — Configure Azure Application Gateway: Route the Partner Hub intelligently

The application team now provides concrete routing requirements.

### URL path-based routing

```text
portal.blueharbor.example/engineering/*
        -> Engineering pool

portal.blueharbor.example/orders/*
        -> Orders pool

portal.blueharbor.example/support/*
        -> Support pool
```

### Multi-site / hostname routing

BlueHarbor may later separate the applications by hostname:

```text
engineering.blueharbor.example -> Engineering pool
orders.blueharbor.example      -> Orders pool
support.blueharbor.example     -> Support pool
```

### TLS questions

The learner must be able to reason about where TLS begins and ends:

```text
Client -- HTTPS --> Application Gateway -- HTTP/HTTPS --> Backend
```

and distinguish TLS termination from end-to-end TLS.

### Health lesson

An application can be reachable at `/` but fail the configured probe at `/health`. Health is defined by the check we configure, not by assumption.

---

## Chapter 04 — Exercise: Deploy Azure Application Gateway

BlueHarbor now builds the regional Partner Hub entry point as a fresh story-driven practical.

### Conceptual regional design

```text
Australia East

bhi-vnet-app-aue
|
+-- snet-appgw
|      |
|      +-- Application Gateway
|
+-- snet-web
       |
       +-- web01
       +-- web02
```

### Practical flow

```text
Microsoft exercise
-> inspect the resulting gateway
-> validate listener/rule/pool/probe relationships
-> test normal HTTP(S) behaviour
-> deliberately break one backend
-> deliberately break health-probe behaviour
-> troubleshoot an HTTP-layer misconfiguration
-> rebuild with Azure CLI where practical
-> rebuild with Terraform where appropriate
-> capture evidence
-> safe teardown
```

### Deliberate failure scenarios

1. Stop one backend and prove the service continues through a healthy backend.
2. Make the configured health path return an unhealthy response and observe backend health.
3. Introduce an HTTP host-header or backend-setting mismatch and diagnose why network connectivity can be healthy while the application fails.

---

## Chapter 05 — Design and configure Azure Front Door: BlueHarbor becomes global

The Partner Hub succeeds and users now access it from Australia, Asia, Europe and North America.

The business asks:

> Can users enter Microsoft's network closer to where they are, while BlueHarbor maintains multiple healthy application origins?

This creates the reason for Azure Front Door.

### Architecture introduced

```text
Global users
    |
    v
Azure Front Door
    |
+---+-------------------+
|                       |
v                       v
Australia origin      Europe origin
```

### Concepts to master

- Front Door profile / endpoint concepts;
- origin and origin group;
- route;
- health probing;
- HTTP(S)-aware global delivery;
- global edge versus regional application delivery;
- hostname/path-based global routing concepts;
- TLS at the global edge;
- caching / acceleration concepts where the Microsoft unit introduces them.

### Critical comparison

```text
Traffic Manager
DNS-based selection; not in application data path

Front Door
HTTP(S) proxy/service in the application data path
```

---

## Chapter 06 — Exercise: Create a Front Door for a highly available web application

BlueHarbor deploys a multi-origin Partner Hub and proves origin-failure behaviour.

### Target architecture

```text
portal.blueharbor.example
        |
        v
Azure Front Door
        |
   +----+----+
   |         |
   v         v
Australia   Europe
origin      origin
```

Each regional origin may itself use an Application Gateway and healthy backend pool as the architecture grows.

### Practical flow

```text
build Front Door
-> configure origins/origin group
-> configure route
-> validate normal request flow
-> inspect health
-> fail one origin
-> observe routing/failover behaviour
-> compare with Traffic Manager DNS failover
-> troubleshoot a route/origin/host configuration error
-> Terraform where appropriate
-> evidence and teardown
```

### Core lesson

Traffic Manager changes DNS answers. Front Door remains in the HTTP(S) application path. Their failover mechanics are therefore fundamentally different.

---

## Chapter 07 — Summary: BlueHarbor application-delivery architecture review

By the end of Module 5, BlueHarbor can reason about four different traffic-distribution services from the business problem they solve.

```text
Azure Load Balancer
-> regional Layer 4 TCP/UDP distribution

Traffic Manager
-> global DNS-based endpoint selection

Application Gateway
-> regional Layer 7 HTTP(S) routing

Azure Front Door
-> global Layer 7 HTTP(S) application delivery
```

### Final architecture

```text
                    Global users
                         |
                         v
                  Azure Front Door
                         |
              +----------+----------+
              |                     |
              v                     v
       Australia region        Europe region
              |                     |
       Application Gateway     Application Gateway
              |                     |
        +-----+-----+           +---+---+
        |     |     |           |       |
      web   api   orders       web     api
```

### Architecture-board questions

The learner must be able to explain:

- why Layer 4 load balancing is insufficient for hostname/path routing;
- listener, rule, backend pool, backend setting and health probe relationships;
- public versus private Application Gateway frontend design;
- path-based versus multi-site routing;
- TLS termination versus end-to-end TLS;
- why a healthy network path can still produce an HTTP application failure;
- Application Gateway versus Azure Front Door;
- Traffic Manager versus Azure Front Door;
- how regional and global Layer 7 services can coexist in one architecture.

## Security boundary for this module

Application Gateway and Front Door can participate in WAF-protected architectures, but detailed Web Application Firewall security policy belongs in Module 6. Module 5 introduces the delivery architecture without stealing the security module's learning objectives.

## Carry-forward into Module 6

BlueHarbor now has a sophisticated global network and application-delivery architecture. The Security team asks:

> How do we defend these networks and applications against unwanted traffic, attacks and policy violations?

That starts Module 6 — Design and implement network security.
