# BlueHarbor Industries — Module 4 Project Story

## Project — Build resilient service delivery for BlueHarbor applications

**Microsoft Learn module:** Load balance non-HTTP(S) traffic in Azure  
**Company:** BlueHarbor Industries (BHI)  
**Status:** PRIOR PRACTICAL EVIDENCE EXISTS — formal Microsoft Learn review pending

## Starting point from Module 3

BlueHarbor has progressively solved network reachability:

```text
Module 1 -> Azure network foundation
Module 2 -> hybrid VPN connectivity
Module 3 -> enterprise private connectivity with ExpressRoute concepts
```

Users, factories and remote networks can reach Azure. The next production problem is different:

> The network path is healthy, but an application can still fail because one backend server or one regional endpoint becomes unavailable.

Module 4 therefore moves from **connectivity** to **service availability and traffic distribution**.

BlueHarbor operates a production telemetry service used by manufacturing systems. The service must survive individual backend failures and, as the company expands globally, regional endpoint failures.

The Microsoft Learn unit order remains authoritative. Existing Azure Load Balancer and Traffic Manager practical evidence is preserved under Units 04 and 06 and reused where it already proves the objective.

---

## Chapter 01 — Introduction: The network is up, but the application is down

A BlueHarbor production incident occurs.

```text
ExpressRoute / VPN path    UP
VNet                       UP
Routes                     UP
DNS                        UP
Telemetry backend          DOWN
```

Operations initially reports a networking outage, but the network is functioning correctly. One application server has failed.

### Core lesson

```text
Network reachability
!=
Application availability
```

### Business requirement

BlueHarbor cannot allow one backend server to be a single point of failure. The service must continue when an individual backend becomes unhealthy.

---

## Chapter 02 — Explore load balancing: Give many servers one service front door

BlueHarbor adds multiple telemetry backends.

Without load balancing, clients would need to know which server is currently available:

```text
Client -> VM01
Client -> VM02
Client -> VM03
```

BlueHarbor instead wants one service endpoint:

```text
Clients
   |
   v
One frontend address
   |
Load Balancer
 /    |    \
VM01 VM02 VM03
```

### Concepts to master

- frontend IP configuration
- backend pool
- health probe
- load-balancing rule
- regional load balancing
- public versus internal frontend design
- Layer 4 TCP/UDP traffic distribution
- health versus reachability

### Mental model

The client should know the **service**, not the identity of the backend server that happens to process a given eligible flow.

### Health lesson

```text
VM01 healthy
VM02 unhealthy
VM03 healthy
```

The Load Balancer does not repair VM02. It stops selecting an unhealthy backend for new eligible flows according to the service behaviour.

---

## Chapter 03 — Design and implement Azure Load Balancer: Build the regional service

BlueHarbor designs a resilient service in Australia East.

```text
ManufacturingVnet
10.20.0.0/16

Telemetry subnet
      |
Azure Load Balancer
      |
+-----+-----+
|     |     |
VM01  VM02  VM03
```

### Business decision

Determine whether the telemetry frontend should be:

```text
Internal Load Balancer
-> private frontend IP
-> reachable only through permitted private network paths

Public Load Balancer
-> public frontend IP
-> reachable from Internet-facing clients where required
```

The design starts with the question **who should be able to reach the frontend?**, not with a memorised service mode.

### Components to master

- Standard Azure Load Balancer
- frontend IP
- backend pool
- health probe
- load-balancing rule
- outbound connectivity behaviour
- NSG interaction
- backend health and flow distribution

---

## Chapter 04 — Exercise: Create and configure an Azure Load Balancer

BlueHarbor implements the regional design and proves failure behaviour.

### Existing practical evidence

The completed Azure Load Balancer engineering practical is preserved in this unit's `practical/` directory. It already includes significant evidence around:

- Standard Load Balancer deployment;
- frontend IP configuration;
- backend pool;
- health probe;
- load-balancing rule;
- outbound rule;
- NSG behaviour;
- CLI validation;
- Terraform;
- failure testing;
- visual learning material;
- teardown / rebuild evidence.

### Review rule

When Module 4 is reached formally:

1. complete Units 01–03 in Microsoft Learn order;
2. review the existing practical against the current Unit 04 objective;
3. reuse valid evidence;
4. fill only genuine gaps rather than automatically redeploying everything.

### Failure experiment

```text
Normal
LB -> VM01 healthy
   -> VM02 healthy
   -> VM03 healthy

Failure
LB -> VM01 healthy
   -> VM02 unhealthy
   -> VM03 healthy
```

Explain why new eligible traffic is no longer sent to the unhealthy backend.

### Second failure to understand

Deliberately break the health-monitoring path or probe response and observe how a running backend can be treated as unavailable when the Load Balancer cannot verify its health.

---

## Chapter 05 — Explore Azure Traffic Manager: BlueHarbor becomes global

The regional service is now resilient, but BlueHarbor expands into multiple geographic regions.

```text
Australia / APAC service
Europe service
North America service
```

Each region can have its own highly available regional service. The new question is:

> How should a client discover which regional endpoint to use?

This introduces Azure Traffic Manager.

### Critical mental model

Traffic Manager is **DNS-based traffic steering**. It is not in the application data path.

```text
DNS decision path
Client -> DNS resolver -> Traffic Manager -> selected endpoint answer

Application path
Client -------------------------------> selected endpoint
```

### Concepts to master

- Traffic Manager profile
- endpoints
- health monitoring
- DNS response behaviour
- DNS TTL / caching
- endpoint eligibility
- routing methods

### Routing methods as business questions

```text
Priority
-> use a primary endpoint and defined backups

Weighted
-> distribute DNS answers according to configured weights

Performance
-> steer toward the endpoint expected to provide the best network-performance result

Geographic
-> map client DNS geography to configured endpoints

Subnet
-> map source IP ranges to endpoints

Multivalue
-> return multiple healthy endpoints where the method applies
```

The learner should understand the business intent behind each method rather than memorising names.

---

## Chapter 06 — Exercise: Create a Traffic Manager profile using the Azure portal

BlueHarbor implements global DNS-based endpoint selection and tests regional failure behaviour.

### Existing practical evidence

The completed Traffic Manager engineering practical is preserved in this unit's `practical/` directory. It already contains substantial evidence for:

- Traffic Manager profile creation;
- multiple regional endpoints;
- geographic routing;
- health monitoring;
- DNS behaviour;
- routing-policy failure scenarios;
- CLI validation;
- Terraform;
- visual learning material;
- teardown / rebuild evidence.

### Key prior lesson — eligibility and health are separate

During the existing geographic-routing work, an Asia endpoint did not initially cover the geography needed by the test client. The result demonstrated that a healthy endpoint is not automatically eligible for every DNS request.

```text
Endpoint health = one decision
Routing-policy eligibility = another decision
```

### Key prior lesson — health does not override policy

When a region becomes degraded, Traffic Manager does not ignore the configured routing method and send the client to an arbitrary healthy endpoint. The routing policy still controls which endpoints are eligible.

### DNS failover timing

```text
endpoint fails
   -> health monitoring detects failure
   -> future DNS answers change according to policy
   -> existing cached DNS answers remain until TTL/cache behaviour permits refresh
   -> clients query again
   -> new eligible endpoint can be returned
```

This is why DNS-based traffic steering does not mean every client moves instantaneously at the moment a regional endpoint fails.

### Review rule

When Module 4 is reached formally, review the existing Unit 06 evidence against the current Microsoft exercise and fill only missing objectives.

---

## Chapter 07 — Summary: BlueHarbor service-availability architecture review

BlueHarbor now has two distinct layers of availability.

```text
                         Client
                           |
                       DNS query
                           |
                           v
                    Traffic Manager
                 global endpoint choice
                           |
        +------------------+------------------+
        |                  |                  |
        v                  v                  v
    Region A           Region B           Region C
        |                  |                  |
   Load Balancer       Load Balancer      Load Balancer
    /   |   \           /   |   \          /   |   \
  VM1  VM2  VM3       VM1  VM2  VM3      VM1  VM2  VM3
```

### Layer 1 — regional availability

Azure Load Balancer distributes Layer 4 traffic across eligible backend resources within the regional design and uses health probes to determine backend health.

### Layer 2 — global endpoint selection

Traffic Manager uses DNS to choose an eligible endpoint according to routing method and endpoint health. Application packets then travel directly between the client and selected endpoint.

### Architecture-board questions

The learner must be able to explain:

- why network reachability does not guarantee application availability;
- frontend versus backend pool;
- what a health probe proves and what it does not prove;
- why an internal Load Balancer differs from a public Load Balancer;
- what happens when one backend becomes unhealthy;
- why Traffic Manager is not a proxy in the application data path;
- how Traffic Manager health and routing-policy eligibility interact;
- why DNS TTL affects observed failover timing;
- when Azure Load Balancer and Traffic Manager solve different layers of the same availability problem.

## Definition of done for Module 4

The learner can trace and explain:

```text
regional flow
client -> Load Balancer frontend -> rule -> healthy backend

and

global selection
client DNS query -> Traffic Manager policy/health -> endpoint answer
client application flow -> selected endpoint directly
```

## Carry-forward into Module 5

Module 4 solves regional Layer 4 distribution and DNS-based global endpoint selection. BlueHarbor's next applications are HTTP/HTTPS and require application-aware routing and web-specific capabilities.

The next business question becomes:

> How do we route web traffic by hostname or URL path, terminate TLS appropriately, protect applications with WAF capabilities and provide global HTTP(S) delivery?

That leads into Module 5 — Load balance HTTP(S) traffic in Azure.
