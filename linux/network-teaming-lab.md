# Linux Network Teaming Lab

## Objective

Practice Linux network teaming concepts with NetworkManager and an active-backup team.

The main goal of this lab is to understand how multiple network interfaces can participate in one logical network configuration and how an active-backup team can provide link failover when one member becomes unavailable.

## Environment

- OS: Rocky Linux lab environment
- Shell: Bash
- Network Management: NetworkManager
- Team Management: `nmcli`, `teamdctl`
- Example Logical Interface: `team0`
- Required Lab Resources: Two disposable network interfaces

## Safety Notice

Network-interface changes can immediately interrupt remote connectivity.

Perform disconnect and failover tests from a VM console or another recovery-safe environment.

Before starting:

```text
Confirm console access
        |
        v
Identify actual interfaces
        |
        v
Inspect existing connections
        |
        v
Confirm the interfaces are disposable
```

Do not copy the lecture interface names or IP addresses as if they were values from the current VM.

## Network Teaming Concept

Network teaming combines multiple network interfaces into a logical network configuration.

```text
                  team0
                    |
             +------+------+
             |             |
             v             v
          ens33           ens37
```

The logical team can be assigned network configuration while the physical interfaces operate as member links.

## Teaming Modes Introduced by the Course

The course introduces:

```text
broadcast
round robin
active-backup
loadbalance
lacp
```

The detailed hands-on configuration in this section uses:

```text
active-backup
```

## Broadcast Mode

The course describes broadcast mode as sending packets through all ports.

Conceptually:

```text
Packet
  |
  v
team0
 |  |
 v  v
NIC NIC
```

The course introduces this mode conceptually and does not provide a complete broadcast-mode configuration exercise.

## Round-Robin Mode

The course lists round-robin as another teaming mode.

Conceptually, traffic can be distributed sequentially among participating links.

The course does not provide a detailed round-robin configuration exercise in this section.

## Active-Backup Mode

The course explicitly associates active-backup with failover.

Conceptually:

```text
team0
 |
 +-- NIC A  ACTIVE
 |
 +-- NIC B  BACKUP
```

If the active member becomes unavailable:

```text
NIC A Failure
     |
     v
Failover
     |
     v
NIC B Becomes Active
```

The purpose of this exercise is to verify this failover behavior.

## Load-Balance Mode

The course describes load balancing as using a hash function to select a transmission port.

Conceptually:

```text
Traffic
   |
   v
Hash Selection
   |
 +---+---+
 |       |
 v       v
NIC A   NIC B
```

The course introduces this mode but does not provide a detailed configuration lab for it.

## LACP

The course introduces LACP as an implementation of:

```text
802.3ad Link Aggregation Control Protocol
```

The course does not include switch-side LACP configuration in this section.

## Team Architecture

The course uses the following logical structure:

```text
                 IP Address
                     |
                     v
                   team0
              connection: team0
                 type: team
                     |
             +-------+-------+
             |               |
             v               v
       team0-port1       team0-port2
       team member       team member
             |               |
             v               v
           ens33           ens37
```

Important distinction:

```text
team0-port1
→ NetworkManager connection name

ens33
→ Network interface name
```

A connection profile and a network device are not the same concept.

## Identify Available Interfaces

Before creating a team, inspect the actual lab interfaces.

```bash
nmcli dev status
```

Also inspect:

```bash
ip addr
```

Record only the actual interface names from the current VM.

Do not assume that `ens33` and `ens37` exist.

## Inspect Existing Connections

```bash
nmcli con show
```

Identify any existing connection profiles associated with the interfaces intended for the lab.

Do not reconfigure a production or management interface without recovery access.

## Create an Active-Backup Team

The course demonstrates:

```bash
nmcli con add type team con-name team0 ifname team0 config '{"runner":{"name":"activebackup"}}'
```

Command components:

```text
nmcli con add
→ Create a NetworkManager connection

type team
→ Create a team connection

con-name team0
→ Connection profile name

ifname team0
→ Logical interface name

runner activebackup
→ Active-backup behavior
```

Verify that the new connection exists:

```bash
nmcli con show
```

## Configure the Team IPv4 Address

The course uses an example address:

```bash
nmcli con mod team0 ipv4.addresses '192.168.108.150/24'
```

Do not reuse the lecture address blindly.

Use an address that belongs to the current disposable lab network.

General form:

```bash
sudo nmcli con mod team0 ipv4.addresses ADDRESS/PREFIX
```

## Configure Manual IPv4 Addressing

The course uses:

```bash
nmcli con mod team0 ipv4.method manual
```

This configures the team connection to use manually assigned IPv4 configuration.

Verify:

```bash
nmcli con show team0
```

## Add the First Team Member

The course demonstrates:

```bash
nmcli con add type team-slave con-name team0-port1 ifname ens33 master team0
```

Conceptually:

```text
team0
  |
  v
team0-port1
  |
  v
ens33
```

General form:

```bash
sudo nmcli con add \
  type team-slave \
  con-name TEAM_PORT_CONNECTION \
  ifname INTERFACE \
  master team0
```

Use the actual disposable interface from the VM.

## Add the Second Team Member

The course demonstrates:

```bash
nmcli con add type team-slave con-name team0-port2 ifname ens37 master team0
```

The resulting structure is:

```text
              team0
            /       \
           /         \
 team0-port1         team0-port2
      |                   |
      v                   v
    ens33               ens37
```

## Activate Team Member Connections

The course uses:

```bash
nmcli con up team0-port1
```

and:

```bash
nmcli con up team0-port2
```

Use the actual connection names created in the current environment.

## Verify Team State

The course uses:

```bash
teamdctl team0 state
```

This can display information about:

```text
Team runner
Member ports
Link state
Active port
Link-watch information
```

Do not copy the lecture state output as actual lab evidence.

Record the output generated by the current VM.

## Verify Active-Backup Runner

Inspect:

```bash
teamdctl team0 state
```

Confirm that the runner reports:

```text
activebackup
```

when the team was intentionally configured in active-backup mode.

## Identify the Active Port

The team state should identify the current active member.

Conceptually:

```text
runner:
    active port: INTERFACE
```

Record the actual active interface before beginning the failover test.

## Baseline Before Failure

Before disconnecting any interface, collect baseline evidence.

```bash
nmcli dev status
```

```bash
ip addr
```

```bash
teamdctl team0 state
```

If network connectivity is being tested, also record the appropriate connectivity result from the actual lab topology.

The baseline is necessary for comparison after the simulated failure.

## Simulate a Link Failure

The course demonstrates:

```bash
nmcli dev dis ens33
```

and later:

```bash
nmcli dev dis ens37
```

General form:

```bash
sudo nmcli dev disconnect INTERFACE
```

Only disconnect a disposable team member from a VM console.

Do not disconnect the only management interface of a remote server.

## Verify Failover

Immediately inspect:

```bash
teamdctl team0 state
```

The course demonstrates that when the current active member becomes unavailable, another team member becomes active.

Conceptually:

```text
Before Failure

team0
 |
 +-- NIC A  ACTIVE
 |
 +-- NIC B  BACKUP


NIC A Disconnect
       |
       v


After Failure

team0
 |
 +-- NIC A  DOWN
 |
 +-- NIC B  ACTIVE
```

The active-port change is evidence that failover occurred.

## Restore the Disconnected Interface

The course demonstrates reconnecting an interface:

```bash
nmcli dev con ens33
```

General form:

```bash
sudo nmcli dev connect INTERFACE
```

Verify the device state afterward:

```bash
nmcli dev status
```

Then inspect the team again:

```bash
teamdctl team0 state
```

## Test the Other Member

The course also disconnects the other interface:

```bash
nmcli dev dis ens37
```

This allows the active-backup behavior to be tested from the opposite direction when the lab topology supports it.

Inspect the team state again:

```bash
teamdctl team0 state
```

## Active-Backup Verification Model

```text
Create Team
    |
    v
Add Two Members
    |
    v
Activate Members
    |
    v
Inspect Active Port
    |
    v
Disconnect Active Member
    |
    v
Inspect Team Again
    |
    v
Confirm Active Port Changed
    |
    v
Restore Member
```

A team should not be considered verified simply because the configuration commands succeeded.

## Configuration and Runtime Inspection

Different commands expose different layers.

```text
nmcli con
→ NetworkManager connection configuration


nmcli dev
→ Current network-device state


teamdctl
→ Team runner and member state
```

Compare these views when the team does not behave as expected.

## Teaming Troubleshooting Workflow

When an active-backup team does not fail over:

```text
Failover Does Not Work
        |
        v
Does the team connection exist?
        |
        v
Are both member connections present?
        |
        v
Are both physical interfaces available?
        |
        v
Is the runner active-backup?
        |
        v
Which port is currently active?
        |
        v
Disconnect the active member
        |
        v
Does another member become active?
        |
        v
Verify network connectivity
```

Change only one layer at a time.

## Troubleshooting Connection Profiles

Inspect:

```bash
nmcli con show
```

Check that:

```text
team0 exists
team member connections exist
member connections reference the intended interfaces
```

Do not recreate the entire team before inspecting the existing configuration.

## Troubleshooting Physical Devices

Inspect:

```bash
nmcli dev status
```

and:

```bash
ip addr
```

Determine whether a problem exists at the physical or virtual interface layer.

A valid team configuration cannot provide redundancy if only one usable member link is available.

## Troubleshooting Team State

Inspect:

```bash
teamdctl team0 state
```

Check:

```text
Runner
Ports
Link state
Active port
```

This provides evidence about the team's internal state.

## Availability vs Performance

The active-backup configuration in this course is primarily a failover configuration.

```text
Active-Backup
→ Availability and link redundancy
```

It should not automatically be interpreted as doubling network throughput simply because two interfaces participate in the team.

Other modes introduced by the course address different traffic-distribution behavior.

## Redundancy Comparison

The team exercise connects conceptually with other infrastructure redundancy labs.

```text
RAID
→ Storage-device redundancy


Active-Backup Teaming
→ Network-link redundancy
```

In both cases, the important operational question is not only whether redundancy was configured but whether failure behavior was actually tested.

## Failure Testing Principle

A high-availability mechanism should be validated under controlled failure.

```text
Normal State
    |
    v
Collect Baseline
    |
    v
Introduce One Failure
    |
    v
Observe State Change
    |
    v
Verify Service Continuity
    |
    v
Restore the Failed Component
```

Use only disposable lab resources for deliberate failure tests.

## Verification Checklist

- Teaming modes introduced by the course were reviewed.
- Broadcast mode was understood conceptually.
- Round-robin mode was reviewed conceptually.
- Active-backup was identified as the hands-on failover mode.
- Load-balance mode was understood as using a hash-based port-selection concept.
- LACP was identified as an 802.3ad link-aggregation protocol.
- The logical `team0` structure was understood.
- Connection names and interface names were distinguished.
- The actual lab interfaces were inspected before configuration.
- An active-backup team configuration was created or reviewed.
- IPv4 configuration was associated with the logical team.
- Two member connections were created or reviewed.
- Team members were activated.
- Team state was inspected with `teamdctl`.
- The active member was identified before the failure test.
- A member interface was disconnected in a disposable environment.
- Active-port failover was verified.
- The disconnected interface was restored.
- Configuration state and device state were inspected separately.
- Lecture IP addresses and interface names were not recorded as actual VM evidence.
- Deliberate network failure testing was performed only with recovery-safe access.

## What I Learned

- Network teaming can combine multiple physical or virtual interfaces into one logical network configuration.
- Different teaming runners provide different traffic and redundancy behaviors.
- The course uses active-backup to demonstrate network-link failover.
- The logical team receives the higher-level network configuration while physical interfaces participate as team members.
- NetworkManager connection names and physical interface names are different concepts.
- `nmcli con` manages connection profiles.
- `nmcli dev` controls and inspects device state.
- `teamdctl` exposes team runner, member, link, and active-port information.
- A successful configuration command is not enough to prove that redundancy works.
- Failover should be verified by deliberately making one member unavailable in a controlled lab.
- Active-backup primarily provides availability rather than automatically increasing throughput.
- Infrastructure redundancy becomes more meaningful when the failure path is tested and documented.
