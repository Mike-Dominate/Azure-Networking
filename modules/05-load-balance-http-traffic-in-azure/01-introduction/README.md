# Unit 01 — Introduction

**Microsoft Learn Module 5:** Load balance HTTP(S) traffic in Azure  
**BlueHarbor chapter:** Layer 4 is no longer enough  
**Status:** NOT STARTED

## Business event

BlueHarbor launches the Partner Hub. Requests now need routing decisions based on HTTP hostname and URL path rather than only IP address, port and protocol.

## Core distinction

```text
Layer 4
IP + port + protocol

Layer 7
HTTP host + path + application behaviour
```

## Problem to solve

Create an HTTP(S)-aware delivery architecture for the Partner Hub without prematurely introducing security controls that belong to Module 6.
