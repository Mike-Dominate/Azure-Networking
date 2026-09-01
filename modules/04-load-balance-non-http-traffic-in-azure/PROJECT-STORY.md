# BlueHarbor Industries — Module 4 Project Story

## Project — Build resilient service delivery

**Status:** NOT STARTED

By Module 4, BlueHarbor has solved core Azure, hybrid and enterprise-connectivity problems. The next incident proves that a healthy network does not guarantee a healthy application.

> The network is reachable, but one telemetry backend fails and the production service goes down.

No pre-story Load Balancer or Traffic Manager practical is reused as completion credit. The service is built again in the proper BlueHarbor sequence so each design decision follows from the preceding business problem.

## Chapter 01 — The network is up, but the application is down

**Unit 01 — Introduction**

Separate network reachability from application availability. One backend is a single point of failure.

## Chapter 02 — Give multiple servers one front door

**Unit 02 — Explore load balancing**

Introduce frontend IP, backend pool, health probe and rule because clients should know the service, not individual server identities.

## Chapter 03 — Design the regional production service

**Unit 03 — Design and implement Azure Load Balancer**

BlueHarbor designs a resilient Australia East telemetry service. Decide internal versus public frontend from who should be able to reach it, then design backend membership, probes, rules, NSG and outbound behaviour.

## Chapter 04 — Prove backend failure does not equal service failure

**Unit 04 — Exercise: Create and configure an Azure Load Balancer**

Build the service fresh. Stop or break one backend/probe path and prove how backend health changes traffic eligibility. Validate with Azure CLI and real client traffic; rebuild with Terraform where appropriate.

## Chapter 05 — The service becomes global

**Unit 05 — Explore Azure Traffic Manager**

BlueHarbor deploys regional service endpoints and now needs a global DNS decision. Introduce Traffic Manager as DNS-based steering, not an application proxy. Teach Priority, Weighted, Performance, Geographic, Subnet and Multivalue as different business policies.

## Chapter 06 — Test a regional endpoint failure

**Unit 06 — Exercise: Create a Traffic Manager profile**

Build the Traffic Manager design fresh in story context. Prove that endpoint health and policy eligibility are separate, and trace how monitoring plus DNS TTL/cache behaviour affects observed failover.

## Chapter 07 — Architecture review

**Unit 07 — Summary**

Explain the two availability layers:

```text
regional
client -> Azure Load Balancer -> healthy backend

global
client DNS query -> Traffic Manager policy/health -> endpoint answer
client application traffic -> selected endpoint directly
```

## Handoff to Module 5

BlueHarbor's next applications are HTTP/HTTPS and need application-aware routing, TLS and web-specific delivery capabilities, leading into Application Gateway and Azure Front Door.
