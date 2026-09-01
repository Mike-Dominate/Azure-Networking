# Unit 05 — Design and configure Azure Front Door

**BlueHarbor chapter:** The Partner Hub becomes global  
**Status:** NOT STARTED

## Business event

Users now access the Partner Hub from Australia, Asia, Europe and North America. BlueHarbor wants global HTTP(S) delivery with healthy regional origins.

## Architecture

```text
Global users
   |
Azure Front Door
   |
+-- Australia origin
+-- Europe origin
```

## Concepts to master

- Front Door profile/endpoint concepts
- origin and origin group
- routes
- health probes
- global HTTP(S) edge
- hostname/path-aware routing
- TLS at the edge
- performance/acceleration concepts introduced by Microsoft Learn

## Critical distinction

```text
Traffic Manager
DNS-based; not in application data path

Front Door
HTTP(S) service in the application data path
```
