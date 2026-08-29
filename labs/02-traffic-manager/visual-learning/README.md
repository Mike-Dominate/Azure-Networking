# Lab 02 Visual Learning — Azure Traffic Manager

Visual learning is mandatory for Lab 02.

Create the following reusable PNG/JPEG assets during the lab:

```text
Lab02-01-Traffic-Manager-DNS-Mental-Model.png
Lab02-02-Geographic-Routing-Flow.png
Lab02-03-Endpoint-Health-and-DNS-Behaviour.png
Lab02-04-Final-Lab-Architecture.png
```

## Visual 01 — DNS mental model

Must show:

```text
Client
  ↓ DNS query
Recursive DNS resolver
  ↓
Traffic Manager profile
  ↓ DNS routing/health decision
DNS answer identifying/leading to selected endpoint
  ↓
Client connects directly to selected application endpoint
```

The visual must explicitly show that **Traffic Manager is not in the HTTP/HTTPS data path**.

## Visual 02 — Geographic routing

Show the source-lab mapping:

```text
North America -> East US App Service
Europe        -> West Europe App Service
Asia          -> Southeast Asia App Service
```

Also show that geographic routing is based on the DNS-query/resolver geography seen by Traffic Manager rather than on an inline inspection of every HTTP packet.

## Visual 03 — Endpoint health and DNS behaviour

Show a healthy baseline and an endpoint-health failure. Include DNS TTL/cache as a separate factor that can delay what an individual client observes.

Do not draw an assumed cross-geography failover path until the actual Geographic-routing behavior has been taught and tested.

## Visual 04 — Final architecture

Create this after the final implementation has been validated. It should include actual resource names, regions, Traffic Manager routing method, monitor configuration, endpoints, and the tested application/DNS flow.

## Additional evidence images

Save Portal screenshots, DNS-query screenshots, or other images only when they materially improve understanding. Use clear filenames and avoid screenshots containing secrets, tokens, subscription identifiers, or unrelated personal/company information.
