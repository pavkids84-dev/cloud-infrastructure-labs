# AWS VPC Networking Foundations Lab

## Objective

Understand the AWS VPC networking concepts introduced in the course, including VPC CIDR design, subnets, ENIs, route tables, Internet Gateways, NAT, security groups, network ACLs, VPC peering, VPC endpoints, VPN, Direct Connect, and the associated practice workflow.

## Scope

```text
VPC
CIDR
Subnet
Availability Zone
Reserved Subnet Addresses
ENI
Route Table
Local Route
Default Route
Internet Gateway
Public Subnet
Private Subnet
NAT Gateway
NAT Instance Context
Security Group
Network ACL
Stateful
Stateless
VPC Peering
VPC Endpoint
Site-to-Site VPN
Direct Connect
VPC Practice
Troubleshooting
```

---

# Virtual Private Cloud

A VPC is a logically isolated virtual network in AWS.

Conceptually:

```text
AWS Region
   ↓
VPC
├── Subnet A
├── Subnet B
└── Subnet C
```

Resources such as EC2 instances, load balancers, and databases can be launched into VPC networking.

---

# CIDR Planning

A VPC is assigned one or more CIDR blocks.

CIDR determines the address range available to the VPC and its subnets.

Example concept:

```text
VPC
10.0.0.0/16
```

Subnets consume smaller ranges from the VPC address space.

CIDR planning should consider future growth and connectivity with other networks.

---

# Private Address Ranges

The course introduces the RFC1918 private IPv4 ranges:

```text
10.0.0.0/8
172.16.0.0/12
192.168.0.0/16
```

These are commonly used for private VPC addressing.

Avoid overlapping address plans when networks may later need to connect through peering, VPN, or other routing technologies.

---

# Subnet

A subnet is an address range inside a VPC.

A subnet belongs to one Availability Zone.

Conceptually:

```text
VPC
├── AZ A
│   └── Subnet A
└── AZ B
    └── Subnet B
```

AWS resources launched in the subnet receive private addresses from that subnet's address range.

---

# Reserved Subnet Addresses

AWS reserves addresses from every IPv4 subnet.

The course uses the first four addresses and the last address of the subnet as the reserved set.

A useful example pattern is:

```text
Network Base Address
VPC Router Address
DNS-Related Reserved Address
Future-Use Reserved Address
Last Address in Subnet
```

The last address is reserved by AWS. VPC networking does not provide normal IPv4 broadcast delivery like a traditional Ethernet broadcast domain.

---

# Public and Private Subnets

A subnet is normally called public when its route table has a route to an Internet Gateway.

Conceptually:

```text
Public Subnet Route Table
0.0.0.0/0
      ↓
Internet Gateway
```

A private subnet does not have a direct route to an Internet Gateway for IPv4 internet access.

---

# Public IPv4 Assignment

A public subnet does not automatically guarantee that every resource receives a public IPv4 address.

Public IPv4 assignment is a separate resource or subnet setting.

For direct IPv4 internet communication through an Internet Gateway, the resource also needs an appropriate public IPv4 address or Elastic IP.

---

# ENI

An Elastic Network Interface is a virtual network interface.

Conceptually:

```text
EC2 Instance
     ↓
ENI
├── Private IPv4
├── Optional Additional Private IPs
└── Related Network Attributes
```

Many VPC-connected AWS services use network interfaces as part of their connectivity model.

---

# Route Table

A route table contains rules that determine where network traffic is sent.

Conceptually:

```text
Destination
      ↓
Route Target
```

Possible route targets introduced by the course include:

```text
Local
Internet Gateway
NAT Gateway
VPC Peering
VPC Endpoint Context
```

---

# Local Route

A VPC route table contains a local route for communication within the VPC CIDR space.

The local route is associated with the VPC address range rather than simply one subnet range.

Conceptually:

```text
VPC CIDR
   ↓
local
```

---

# Default Route

For IPv4, the default route is:

```text
0.0.0.0/0
```

It matches destinations not covered by a more specific route.

Common examples are:

```text
Public Subnet
0.0.0.0/0 → Internet Gateway
```

```text
Private Subnet
0.0.0.0/0 → NAT Gateway
```

---

# Internet Gateway

An Internet Gateway connects a VPC to the public internet for supported traffic.

Conceptually:

```text
Internet
   ↕
Internet Gateway
   ↕
VPC
```

For an EC2 instance to use direct IPv4 internet connectivity through an IGW, the complete path must be valid.

---

# Public Internet Connectivity Checklist

A useful reasoning model is:

```text
Instance Running?
      ↓
Public IPv4 / EIP?
      ↓
Subnet Route to IGW?
      ↓
Internet Gateway Attached?
      ↓
Security Group Allows Traffic?
      ↓
Network ACL Allows Traffic?
      ↓
Operating-System Service / Firewall?
```

A route alone is not enough.

---

# NAT Gateway

A NAT Gateway allows private-subnet resources to initiate outbound IPv4 connections while preventing unsolicited inbound internet connections from being initiated through that NAT path.

Conceptually:

```text
Private EC2
    ↓
Private Route Table
0.0.0.0/0
    ↓
NAT Gateway
    ↓
Internet Gateway
    ↓
Internet
```

---

# NAT Gateway Placement

A public NAT Gateway is created in a public subnet and uses public connectivity.

Private subnets route internet-bound IPv4 traffic toward the NAT Gateway.

For resilient architectures, NAT design should also consider Availability Zone failure domains.

---

# NAT Gateway Is Managed

NAT Gateway is managed by AWS.

This differs from operating a customer-managed EC2 instance as a NAT device.

Operational differences include:

```text
Maintenance Responsibility
Scaling Behavior
Failure Handling
Security-Group Support
Cost Model
```

---

# NAT Instance Historical Context

The course introduces NAT Instances as EC2 instances configured to forward traffic for private subnets.

This is an older and more operationally intensive pattern.

A NAT Instance requires customer management and can require source/destination checks to be disabled.

Course-era community AMI examples should be treated as historical implementation details, not as a current default design.

---

# Security Group

A security group is a stateful virtual firewall associated with network interfaces and resources such as EC2 instances.

Conceptually:

```text
ENI / Resource
      ↓
Security Group
      ↓
Inbound / Outbound Allow Rules
```

Security groups support allow rules rather than explicit deny rules.

---

# Stateful Behavior

Stateful means return traffic for an allowed connection is automatically recognized.

Conceptually:

```text
Allowed Inbound Request
        ↓
Connection State Recorded
        ↓
Return Traffic Allowed
```

This differs from a stateless packet filter.

---

# Security Group Defaults

A newly created security group normally begins without inbound allow rules and with outbound access allowed by default unless changed.

The VPC default security group has its own default self-referencing behavior.

Do not assume every security group has identical initial rules.

---

# Security Group Quotas

The number of security groups that can be associated with a network interface is quota-controlled and can change.

Course numbers should not be treated as permanent architecture limits.

---

# Network ACL

A network ACL is a stateless filter associated with subnets.

Conceptually:

```text
Subnet
  ↓
Network ACL
  ↓
Inbound and Outbound Rules
```

All resources using that subnet are affected by the subnet's associated NACL.

---

# Stateless Behavior

Stateless means request and response traffic are evaluated separately.

Conceptually:

```text
Inbound Rule
and
Outbound Rule
```

must both permit the required packet flow.

Return traffic is not automatically allowed simply because the initial request was allowed.

---

# NACL Rule Order

Network ACL rules are evaluated by rule number.

Conceptually:

```text
Lowest Rule Number
       ↓
First Matching Rule
       ↓
Allow or Deny
```

NACLs support both allow and deny rules.

---

# Default vs Custom Network ACLs

The default network ACL permits traffic by default.

A newly created custom network ACL begins more restrictively and should not be assumed to allow everything.

The course statement about default allow behavior should be interpreted in the context of the VPC default NACL.

---

# Security Group vs Network ACL

A useful comparison is:

```text
Security Group
→ Resource / ENI Level
→ Stateful
→ Allow Rules
```

```text
Network ACL
→ Subnet Level
→ Stateless
→ Allow and Deny Rules
→ Ordered Rules
```

They can be used as separate layers of network access control.

---

# VPC Peering

VPC Peering provides private routing between two VPCs.

Conceptually:

```text
VPC A
   ↕
Peering Connection
   ↕
VPC B
```

Route tables must contain the required peer routes.

---

# Inter-Region Peering

The course practice connects VPCs in different Regions.

Conceptually:

```text
Seoul VPC
    ↕
Inter-Region VPC Peering
    ↕
Oregon VPC
```

The real Region and VPC identifiers must come from the user's environment.

---

# Peering Is Not Transitive

VPC Peering does not provide transit routing.

Conceptually:

```text
VPC A ↔ VPC B
VPC B ↔ VPC C
```

does not automatically mean:

```text
VPC A ↔ VPC C
```

Address ranges must also be planned so connected VPCs do not create incompatible overlap.

---

# VPC Endpoint

A VPC endpoint allows private access from a VPC to supported AWS services without requiring the traffic to traverse a normal public-internet path.

Conceptually:

```text
Private VPC Resource
       ↓
VPC Endpoint
       ↓
AWS Service
```

---

# Gateway and Interface Endpoints

The course introduces:

```text
Gateway Endpoint
Interface Endpoint
```

Gateway endpoints are associated with services such as S3 and DynamoDB.

Interface endpoints are based on private connectivity through VPC networking for many supported AWS services.

---

# Site-to-Site VPN

The course introduces VPN connectivity between on-premises infrastructure and AWS.

Conceptually:

```text
On-Premises Network
       ↓
VPN Tunnel
       ↓
AWS VPC
```

Routing must be configured so the networks know which destinations use the VPN.

---

# Customer and AWS Gateway Context

The course uses concepts such as:

```text
Customer Gateway
Virtual Private Gateway
```

to represent the on-premises and AWS sides of Site-to-Site VPN architecture.

Exact VPN gateway architectures can vary depending on current AWS service choices.

---

# Direct Connect

AWS Direct Connect provides dedicated private network connectivity between customer environments and AWS.

Conceptually:

```text
Customer Network
       ↓
Dedicated Connectivity
       ↓
AWS
```

It is useful for predictable private connectivity, bandwidth, and hybrid-network architecture.

---

# Direct Connect and Encryption

Dedicated connectivity should not automatically be equated with encrypted connectivity.

Encryption is a separate design concern.

If encryption is required, evaluate the supported encryption or VPN-over-private-connectivity design for the specific architecture.

---

# Course VPC Practice

The course practice covers:

```text
Create Public and Private Subnets in Seoul
Create a Public Subnet in Oregon
Connect Regions with VPC Peering
Test Private-IP Connectivity
Modify Security Groups
```

The course CIDR blocks, resource names, and Region-specific examples are training values.

---

# Public and Private Route Design

The practice creates a model similar to:

```text
Public Subnet
0.0.0.0/0 → Internet Gateway
```

```text
Private Subnet
0.0.0.0/0 → NAT Gateway
```

This is a core AWS VPC architecture pattern.

---

# Peering Verification

The course verifies private-IP connectivity between instances in the two peered VPCs.

Actual verification evidence must be captured from the user's own lab.

Do not reuse course IP addresses or successful ping statements as personal evidence.

---

# Security Group Practice

The course removes an SSH rule, observes connectivity failure, then adds SSH access from the user's current public IP and verifies connectivity.

The reusable troubleshooting pattern is:

```text
Connectivity Fails
      ↓
Inspect Security Group
      ↓
Required Port / Source Missing?
      ↓
Add Minimum Required Rule
      ↓
Verify Again
```

Avoid permanently allowing administrative access from the entire internet when a narrower source is possible.

---

# VPC Troubleshooting Workflow

A useful connectivity workflow is:

```text
Correct VPC?
      ↓
Correct Subnet?
      ↓
Correct IP Address?
      ↓
Route Table?
      ↓
IGW / NAT / Peering / VPN / Endpoint?
      ↓
Security Group?
      ↓
NACL?
      ↓
Operating-System Firewall?
      ↓
Application Listening?
```

This mirrors normal network troubleshooting while adding AWS-specific routing and security layers.

---

# Evidence Policy

Do not fabricate or publish:

```text
VPC IDs
Subnet IDs
Route Table IDs
Internet Gateway IDs
NAT Gateway IDs
Elastic IP Addresses
Security Group IDs
Network ACL IDs
Peering Connection IDs
Endpoint IDs
VPN IDs
Direct Connect IDs
Real Public or Private IP Addresses
Ping Results
CLI Output
Billing Values
```

Actual evidence must come from an authorized AWS environment.

---

# Verification Checklist

- VPC and subnet scope were distinguished.
- A subnet was connected to one Availability Zone.
- Public and private subnet routing was understood.
- Public IPv4 assignment was separated from public-subnet routing.
- ENI was introduced.
- Route tables and default routes were understood.
- Internet Gateway and NAT Gateway roles were distinguished.
- NAT Instance was recognized as historical and customer-managed context.
- Security groups were understood as stateful resource-level controls.
- NACLs were understood as stateless subnet-level controls.
- VPC Peering was understood as non-transitive.
- VPC endpoints were connected to private AWS-service access.
- VPN and Direct Connect were distinguished.
- Course values were not treated as actual lab evidence.

## What I Learned

- AWS VPC networking still follows normal routing, addressing, and firewall principles.
- Public internet access requires a complete network path, not just one AWS resource.
- Private-subnet egress through NAT is different from direct internet exposure.
- Security groups and NACLs operate at different scopes and maintain different state models.
- Hybrid and inter-VPC connectivity require deliberate route design.
