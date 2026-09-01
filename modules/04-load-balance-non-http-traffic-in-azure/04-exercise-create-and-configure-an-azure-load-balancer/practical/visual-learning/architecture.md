# Lab 01 Visual Learning — Azure Load Balancer

## Start here

Do not deploy anything until this mental model is understood.

## Core traffic path

```text
Client
  |
  v
Public IP
  |
  v
Azure Load Balancer frontend
  |
  +--> Load-balancing rule: TCP/80 -> TCP/80
  |
  +--> Health probe: HTTP/80 /
  |
  v
Backend pool
  |
  +--> VM in Availability Zone 1
  +--> VM in Availability Zone 2
  +--> VM in Availability Zone 3
           |
           v
       NIC / Subnet / NSG
           |
           v
         Apache
```

## Questions to answer during the lesson

1. Why is Azure Load Balancer considered a Layer 4 service?
2. What information can it make forwarding decisions on?
3. What is the difference between the frontend and backend configurations?
4. Why is the health probe separate from the load-balancing rule?
5. What happens to a backend when its probe fails?
6. Does the Load Balancer replace an NSG?
7. What changes if the Load Balancer is internal instead of public?
8. Why place the backend VMs in multiple availability zones?
9. What failure does multi-zone placement protect against?
10. When would Application Gateway be more appropriate?

## Control plane vs data plane

Fill this in during the lesson:

- **Control plane:** how we configure Azure resources.
- **Data plane:** how actual client traffic flows through the configured service.

Record examples specific to this lab below.

### Control-plane examples

_To be completed during Lab 01._

### Data-plane examples

_To be completed during Lab 01._

## Packet walk

Document the packet journey in your own words after the direct deployment works.

_To be completed during Lab 01._

## Failure model

Document what should happen when:

- one backend VM is stopped
- Apache stops on one backend
- port 80 is blocked by an NSG
- the health probe path returns an unhealthy response

_To be completed during Lab 01._

## Service selection comparison

Complete at the end of the lab:

| Service | Layer / mechanism | Best fit | Why not use it here? |
|---|---|---|---|
| Azure Load Balancer | L4 | | |
| Application Gateway | L7 | | |
| Azure Front Door | Global edge/L7 | | |
| Traffic Manager | DNS | | |
