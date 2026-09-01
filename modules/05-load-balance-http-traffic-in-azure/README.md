# Module 5 — Load balance HTTP(S) traffic in Azure

**Microsoft Learn:** https://learn.microsoft.com/en-us/training/modules/load-balancing-https-traffic-azure/

**BlueHarbor project:** Launch the BlueHarbor Partner Hub globally  
**Status:** NOT STARTED

Module 5 continues directly from Module 4. BlueHarbor already understands regional Layer 4 load balancing and global DNS-based endpoint selection. The new Partner Hub requires HTTP(S)-aware routing based on hostnames, URL paths, TLS and application health.

The module is taught as one progressive project:

```text
Layer 4 is no longer enough
        -> design Application Gateway
        -> configure listeners/rules/pools/probes/TLS
        -> build regional Partner Hub delivery
        -> break and troubleshoot HTTP-layer behaviour
        -> expand the application globally
        -> introduce Azure Front Door
        -> build multi-origin global HTTP(S) delivery
        -> fail an origin and observe rerouting
        -> compare all four Azure traffic-distribution services
```

Read [`PROJECT-STORY.md`](PROJECT-STORY.md) before starting the module.

## Microsoft Learn units

1. Introduction
2. Design Azure Application Gateway
3. Configure Azure Application Gateway
4. Exercise: Deploy Azure Application Gateway
5. Design and configure Azure Front Door
6. Exercise: Create a Front Door for a highly available web application
7. Summary

## Story-first rule

This module is built fresh when reached in sequence. No previous lab is allowed to shortcut or reshape the BlueHarbor architecture.
