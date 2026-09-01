# Lab 03 Failure Tests

These tests were performed deliberately against the live manual Azure environment to validate address-planning failure modes and confirm Azure did not leave failed resources behind.

## 1. Overlapping subnet

Existing subnet:

```text
snet-web = 10.30.10.0/26
range = 10.30.10.0 - 10.30.10.63
```

Attempted subnet:

```text
snet-overlap-test = 10.30.10.32/27
range = 10.30.10.32 - 10.30.10.63
```

Azure result:

```text
Code: NetcfgSubnetRangesOverlap
Message: Subnet 'snet-overlap-test' is not valid because its IP address range overlaps with that of an existing subnet in virtual network 'vnet-az700-ip-aue'.
```

Post-failure verification query for `snet-overlap-test` returned blank, confirming no partial subnet existed.

## 2. Azure-reserved private IP

Subnet:

```text
snet-db = 10.30.30.0/27
```

Attempted static NIC IP:

```text
10.30.30.1
```

Azure result:

```text
Code: PrivateIPAddressInReservedRange
Message: Private static IP address 10.30.30.1 falls within reserved IP range of subnet prefix 10.30.30.0/27.
```

Post-failure lookup of `nic-lab03-reserved-test` returned `ResourceNotFound`.

## 3. Duplicate private IP

Existing allocation:

```text
nic-lab03-app-static = 10.30.20.10
```

Attempted second NIC with the same address.

Azure result:

```text
Code: PrivateIPAddressIsAllocated
Message: ... private IP address 10.30.20.10 ... is already allocated to ... nic-lab03-app-static/ipConfigurations/ipconfig1.
```

Post-failure lookup of `nic-lab03-duplicate-test` returned `ResourceNotFound`.

## 4. Private IP outside the assigned subnet

Assigned subnet:

```text
snet-app = 10.30.20.0/27
range = 10.30.20.0 - 10.30.20.31
```

Attempted private IP:

```text
10.30.21.10
```

The address belongs to the overall VNet `10.30.0.0/16` but not to the NIC's selected subnet.

Azure result:

```text
Code: PrivateIPAddressNotInSubnet
Message: Private static IP address 10.30.21.10 does not belong to the range of subnet prefix 10.30.20.0/27.
```

Post-failure lookup of `nic-lab03-outside-test` returned `ResourceNotFound`.

## Troubleshooting mental model

When diagnosing private-IP allocation or subnet-design errors, check in this order:

```text
1. Is the address inside the intended subnet?
2. Is the subnet CIDR itself valid and non-overlapping?
3. Is the address reserved by Azure?
4. Is the address already allocated to another resource?
```

These failures are address-plan/allocation problems. NSGs, route tables and firewalls do not repair invalid or ambiguous CIDR design.
