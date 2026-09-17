# Docker Networking Lab

## Objective

Understand how Docker connects container processes to network environments using Linux networking concepts such as network namespaces, bridges, IP addressing, gateways, and shared network stacks.

The goal is to connect previously studied Linux and networking fundamentals to Docker container communication.

## Scope

```text
Docker Networks
Network Drivers
Bridge Network
Custom Bridge Network
Network Namespace
Container Network Sharing
Host Network
None Network
Macvlan
Overlay Network
docker network create
docker network ls
Container Name Resolution
Container-to-Container Communication
Port Publishing Context
Docker Network Troubleshooting
```

---

# Docker Networking Foundation

Containers are processes that can execute inside isolated Linux network namespaces.

A simplified model is:

```text
Docker Host
│
├── Host Network Namespace
│
├── Container A Network Namespace
│   ├── Interface
│   ├── IP Address
│   └── Route
│
└── Container B Network Namespace
    ├── Interface
    ├── IP Address
    └── Route
```

This makes it possible for container processes to have network environments different from the host and from other containers.

---

# Docker Network Types

The course introduces several Docker network models:

```text
Bridge
Network Disabled / None
Container Network Sharing
Host Network Sharing
Macvlan
Overlay
Third-Party Networking
```

Each model changes how the container process is connected to a network namespace and the surrounding infrastructure.

---

# Bridge Network

The bridge driver connects containers through a software bridge on the Docker host.

Conceptually:

```text
Container A
    │
   veth
    │
    ├──────────────┐
    │              │
Docker Bridge      │
    │              │
    ├──────────────┘
    │
   veth
    │
Container B
```

The container can maintain its own:

```text
Network Interface
IP Address
Routing Table
Port Space
```

while communicating through the host's bridge networking.

---

# Linux Bridge Relationship

Docker bridge networking should be connected to Linux bridge concepts.

```text
Linux Bridge
→ Software Layer 2 switching
```

```text
Docker Bridge Network
→ Container interfaces connected through a Linux-based bridge model
```

Docker provides management around existing Linux networking capabilities rather than replacing fundamental Ethernet and IP concepts.

---

# Network Namespaces

Network namespaces isolate network resources.

A container network namespace can contain:

```text
Interfaces
IP Addresses
Routes
Sockets
Port Space
```

Conceptually:

```text
Container A
→ Network Namespace A

Container B
→ Network Namespace B
```

This allows containers on the same Linux host to appear as independent network endpoints.

---

# None Network

The course uses historical terminology around a host-only or null-style network.

A clearer conceptual model is the Docker `none` network.

```text
none
→ Container receives no normal external network connectivity from Docker
```

This is different from host networking.

```text
none
→ Network isolation
```

```text
host
→ Host network stack sharing
```

---

# Custom Docker Network

The course demonstrates creating a Docker network with explicit IP configuration.

A general structure is:

```bash
docker network create -d DRIVER \
  --subnet=NETWORK/PREFIX \
  --ip-range=ADDRESS_RANGE \
  --gateway=GATEWAY \
  NETWORK_NAME
```

Conceptually:

```text
Docker Network
├── Driver
├── Subnet
├── Address Pool
└── Gateway
```

This connects Docker configuration directly to normal IP networking concepts.

---

# Using a Custom Network

A container can be attached to a Docker network when it is created.

Example structure:

```bash
docker run -d --network NETWORK_NAME IMAGE
```

Conceptually:

```text
Container
    ↓
Selected Docker Network
    ↓
Network Driver
    ↓
Host Networking
```

---

# `docker network ls`

Docker networks are Docker-managed resources.

The course demonstrates listing them using:

```bash
docker network ls
```

Relevant information can include:

```text
Network ID
Name
Driver
Scope
```

A useful Docker resource model is:

```text
docker image ls
→ Images
```

```text
docker ps
→ Containers
```

```text
docker network ls
→ Networks
```

---

# Custom Bridge Networks

The course demonstrates creating a custom bridge network and attaching multiple containers to it.

Conceptually:

```text
Custom Bridge Network
       │
       ├── Container A
       │
       └── Container B
```

Containers on the same appropriate Docker network can communicate through that network.

---

# Container Name Communication

The course demonstrates one container reaching another using the target container name.

Conceptually:

```text
Container A
     ↓
Container Name
     ↓
Container B
```

This reduces the need for an application to depend directly on a temporary container IP address.

---

# Container IP Addresses

Containers can be recreated.

Conceptually:

```text
Old Container
→ IP A

Remove

New Container
→ IP B
```

Applications should therefore avoid unnecessary dependence on hardcoded container IP addresses.

Service or container naming is more appropriate when the network environment provides name resolution.

---

# Network Configuration and Application Identity

A useful distinction is:

```text
Container IP
→ Runtime network location
```

```text
Container / Service Name
→ Logical application identity
```

This distinction becomes more important in multi-container applications and Docker Compose.

---

# Container Network Sharing

The course demonstrates another container sharing the network environment of an existing container.

A command structure is:

```bash
docker run --network container:TARGET_CONTAINER IMAGE
```

Conceptually:

```text
Container A
      ┐
      ├── Shared Network Namespace
      │
Container B
      ┘
```

The containers can therefore share network resources such as:

```text
Interfaces
IP Addresses
Routes
Network Port Space
```

---

# Shared Network Does Not Mean Shared Container

Two containers that share a network namespace are still separate container objects.

They can continue to have separate:

```text
Processes
Filesystem Views
Container Metadata
```

The shared component is the network namespace.

This demonstrates that Linux namespace boundaries can be configured independently.

---

# Namespace Isolation Model

Containers can use multiple namespace types.

Examples include:

```text
PID Namespace
Network Namespace
Mount Namespace
UTS Namespace
IPC Namespace
```

A runtime can isolate some namespaces while sharing another.

Container architecture should therefore be understood as process isolation rather than as a fixed miniature virtual-machine model.

---

# Host Network

The course demonstrates running a container using the host network.

A command structure is:

```bash
docker run --network host IMAGE
```

Conceptually:

```text
Container Process
      ↓
Host Network Namespace
```

The container does not use the normal separate bridge-network model.

---

# Bridge vs Host Networking

Bridge mode can be represented as:

```text
Container Network Namespace
        ↓
Container Interface
        ↓
Docker Bridge
        ↓
Host Network
```

Host mode can be represented as:

```text
Container Process
        ↓
Host Network Namespace
```

The difference is the network namespace boundary.

---

# Host Network and Ports

In bridge networking, applications can require host-to-container port publishing.

```text
Host Port
    ↓
Container Port
```

In host networking, the container process uses the host's network stack directly.

The normal bridge-based port-mapping model therefore does not describe host networking in the same way.

---

# Macvlan

The course introduces Macvlan as a network driver associated with the physical network interface.

Conceptually:

```text
Physical Network
      ↓
Physical NIC
      ↓
Macvlan
  ┌────┴────┐
  ↓         ↓
Container A Container B
```

This allows containers to participate in the surrounding network using a model different from the default host bridge.

---

# Overlay Network

The course connects overlay networking to Docker cluster or Swarm environments.

Conceptually:

```text
Docker Host A
Container A
     │
     │ Overlay Network
     │
Docker Host B
Container B
```

Overlay networks allow container communication to span multiple Docker hosts.

Detailed cluster networking is covered later in the learning path.

---

# Third-Party Networking

The course references external networking solutions such as:

```text
Weave
Flannel
Open vSwitch
```

The important concept is that container networking can integrate with networking technologies outside Docker's basic built-in drivers.

The specific product names are less important than understanding the extensible networking model.

---

# Docker Networking and Existing Network Fundamentals

Docker networking uses previously studied concepts directly.

```text
IPv4 Addressing
→ Docker Subnets

Prefix Length
→ Docker Network Prefix

Gateway
→ Container Next Hop

Linux Bridge
→ Bridge Network

Network Namespace
→ Container Network Isolation

DNS / Name Resolution
→ Container Naming

TCP / UDP Ports
→ Container Services

Routing
→ Container Reachability
```

Docker networking should therefore be treated as an application of Linux and network fundamentals.

---

# Docker Networking and Linux

Relevant Linux foundations include:

```text
Network Namespaces
Linux Bridges
Virtual Interfaces
Routing
Socket State
Process Isolation
```

Docker provides an abstraction and management layer around these operating-system features.

---

# Docker Networking and Port Publishing

Container networking and port publishing are related but different concepts.

```text
Container Network
→ How the container participates in a network
```

```text
Port Publishing
→ How host-side traffic is forwarded to a container service
```

For example:

```text
Host Port 8080
       ↓
Container Port 80
```

is a publishing relationship layered on top of container networking.

---

# Container Network Troubleshooting

When containers cannot communicate, avoid assuming the application is the first failing layer.

A useful workflow is:

```text
Container Running?
      ↓
Correct Docker Network?
      ↓
Expected Network Driver?
      ↓
Network Attachment Present?
      ↓
Container Addressing Correct?
      ↓
Route / Gateway Correct?
      ↓
Name Resolution Works?
      ↓
Target Port Listening?
      ↓
Port Published if Required?
      ↓
Application Responding?
```

---

# Layered Troubleshooting

Docker network problems can be mapped to existing network layers.

```text
Container Process
       ↓
Socket
       ↓
Network Namespace
       ↓
Container Interface
       ↓
Bridge / Network Driver
       ↓
Host Interface
       ↓
Routing
       ↓
Remote Network
```

This makes existing Linux and networking troubleshooting skills directly reusable.

---

# Name Resolution Troubleshooting

If one container can reach an IP address but not a container or service name:

```text
IP Connectivity Works
       +
Name Lookup Fails
       ↓
Investigate Container Name Resolution
```

Do not immediately treat this as a routing failure.

This follows the same principle used in general DNS troubleshooting.

---

# Port Troubleshooting

If network connectivity exists but the application cannot be reached:

```text
Network Reachable?
      ↓
Expected Process Running?
      ↓
Socket Listening?
      ↓
Correct Container Port?
      ↓
Host Port Published if Required?
      ↓
Application Response?
```

This separates network reachability from service availability.

---

# Host Network Caution

Host networking reduces the network isolation normally provided by a separate container network namespace.

The container process directly participates in the host networking environment.

This should be selected intentionally rather than simply used to bypass a networking problem.

---

# Network Evidence

Useful evidence during Docker network troubleshooting can include:

```text
docker network ls
docker network inspect
docker inspect
docker ps
ss
ip addr
ip route
ip link
curl
nc
Packet Capture
```

Actual command output should be collected from the authorized lab environment.

Do not fabricate network evidence.

---

# Verification Checklist

- Docker networking was connected to Linux network namespaces.
- Bridge networking was connected to Linux bridge concepts.
- Docker network types were reviewed.
- The course's host-only/null terminology was distinguished from the `none` network concept.
- Custom Docker networks were understood.
- `docker network create` was connected to subnet, address-range, and gateway concepts.
- `docker network ls` was reviewed.
- Containers were connected to custom bridge networks.
- Container-name communication was reviewed.
- Runtime container IP addresses were not treated as permanent application identities.
- Container network namespace sharing was understood.
- Shared network namespaces were distinguished from sharing all container state.
- Host networking was distinguished from bridge networking.
- Host networking was connected to the host network namespace.
- Port publishing was distinguished from container network selection.
- Macvlan was introduced.
- Overlay networking was connected to multi-host container environments.
- Third-party networking was recognized as an extension point.
- Docker networking was connected to existing IP, routing, DNS, bridge, and port fundamentals.
- A layered Docker-network troubleshooting workflow was established.
- Course network values were not treated as actual runtime evidence.

## What I Learned

- Docker networking is built on Linux networking rather than replacing it.
- Network namespaces allow containers to maintain isolated interfaces, addresses, routes, and sockets.
- Bridge networking connects isolated container network namespaces through a host software bridge.
- Custom networks allow containers to be grouped into intentional communication domains.
- Container names can provide more stable application references than hardcoded runtime IP addresses.
- Containers can intentionally share another container's network namespace.
- Host networking removes the normal separate container network namespace boundary.
- Overlay networking extends container communication across multiple Docker hosts.
- Docker network troubleshooting can reuse Linux and general network troubleshooting methods.
