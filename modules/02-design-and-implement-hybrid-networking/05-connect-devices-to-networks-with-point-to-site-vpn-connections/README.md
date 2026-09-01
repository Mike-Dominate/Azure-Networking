# Unit 05 — Connect devices to networks with Point-to-site VPN connections

**BlueHarbor chapter:** A remote engineer needs access  
**Status:** NOT STARTED

## Business event

A BlueHarbor engineer is working from a home, hotel or customer network and needs secure access to Azure administration services.

Connecting the entire remote network to BlueHarbor is inappropriate. Only the engineer's device needs the private path.

## Architecture

```text
Remote laptop
     |
client VPN
     |
Azure VPN Gateway
     |
permitted Azure networks
```

## Concepts to master

- Point-to-Site VPN
- Azure VPN Client
- client address pool
- supported tunnelling protocol concepts
- Entra ID authentication concepts
- RADIUS / AD authentication concepts
- routes presented to the client
- DNS behaviour while connected

## Key distinction

```text
S2S = network <-> network
P2S = individual device <-> Azure network
```

The validation exercise should prove private reachability changes when the client VPN is established.
