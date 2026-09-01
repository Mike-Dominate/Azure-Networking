# Unit 05 — Design name resolution for your virtual network

## BlueHarbor chapter: Stop memorising IP addresses

BlueHarbor's environment has grown enough that engineers are passing raw private IP addresses around. Those addresses can change, so workloads and people need stable names.

Business problem:

```text
human/workload knows a name
        |
        v
DNS must discover the current IP address
```

Teach the Microsoft Learn name-resolution unit first. Supporting DNS fundamentals are used only where they make the Microsoft objective clearer. AZ-700 study-guide additions such as Azure DNS Private Resolver are added afterward inside this same objective area.

**Status:** IN PROGRESS — CURRENT UNIT.

No Azure resources should be deployed until the tutorial/mental model and understanding check are complete.

Existing DNS tutorial/handoff material is preserved in `practical/`.
