# Linux Service Management Lab

## Objective

Practice Linux service management with systemd and `systemctl`.

The goal of this lab is to understand service runtime state, boot-time configuration, unit types, default targets, service dependencies, masking, socket activation, and basic service troubleshooting.

## Environment

- OS: Rocky Linux
- Init System: systemd
- Shell: Bash
- Privilege: root or sudo-enabled user

## systemd Overview

Modern Rocky Linux systems use systemd to manage system services and other operating-system resources.

systemd manages objects called units.

```text
systemd
   |
   ├── Service Units
   ├── Socket Units
   ├── Target Units
   ├── Mount Units
   ├── Timer Units
   ├── Path Units
   ├── Device Units
   ├── Swap Units
   └── Other Unit Types
```

`systemctl` is the primary command used to inspect and control systemd units.

## Unit Types

Common systemd unit types include:

```text
.service
→ Service or daemon

.socket
→ Socket used for socket-based activation

.target
→ Group of units representing a system state or goal

.mount
→ Filesystem mount

.automount
→ Automatic filesystem mount

.timer
→ Time-based activation

.path
→ Path-based activation

.device
→ Device representation

.swap
→ Swap resource

.slice
→ Resource-management group

.scope
→ Externally created process group
```

The most important unit types for this lab are:

```text
.service
.socket
.target
```

## List Service Units

List loaded service units.

```bash
systemctl --type=service
```

An equivalent form can be used:

```bash
systemctl -t service
```

Inspect all service unit files.

```bash
systemctl list-unit-files --type=service
```

## Understanding Service Status

Inspect an individual service.

```bash
systemctl status sshd
```

Typical status information can include:

```text
Loaded
Active
Main PID
Tasks
Memory
CGroup
Recent log messages
```

A service status can contain states such as:

```text
loaded
active
inactive
running
exited
waiting
enabled
disabled
static
```

## LOAD, ACTIVE, and SUB

Service listings can include the following fields:

```text
LOAD
→ Whether the unit definition was successfully loaded

ACTIVE
→ High-level activation state

SUB
→ More detailed unit-specific state
```

Example concept:

```text
LOAD    loaded
ACTIVE  active
SUB     running
```

This indicates that the unit is loaded and currently running.

## Active Does Not Always Mean Running

A unit can be:

```text
active (running)
```

when a process remains active.

Some units can also appear as:

```text
active (exited)
```

This can occur when a unit successfully completes its required initialization work and no long-running process remains.

Therefore:

```text
active
```

should not always be interpreted as exactly the same thing as:

```text
running
```

## Start a Service

Start a service immediately.

```bash
sudo systemctl start sshd
```

Verify the result.

```bash
systemctl status sshd
```

## Stop a Service

Stop the service.

```bash
sudo systemctl stop sshd
```

Verify the state.

```bash
systemctl status sshd
```

When practicing on an SSH service, perform disruptive tests from a local VM console rather than the remote SSH session being tested.

## Restart a Service

Restart a service.

```bash
sudo systemctl restart sshd
```

Verify:

```bash
systemctl status sshd
```

## Reload a Service

Some services can reload configuration without a full restart.

```bash
sudo systemctl reload SERVICE
```

Conceptually:

```text
restart
→ Stop and start the service process

reload
→ Ask the service to reload configuration without a full restart
```

Not every service supports reload.

## Runtime State vs Boot Configuration

Current service state and boot-time configuration are separate concepts.

```text
Runtime State
─────────────
active
inactive


Boot Configuration
──────────────────
enabled
disabled
```

A service can therefore be:

```text
active + enabled
active + disabled
inactive + enabled
inactive + disabled
```

## Check Runtime State

Inspect current status.

```bash
systemctl status sshd
```

## Check Boot-Time Configuration

Check whether the service is enabled.

```bash
systemctl is-enabled sshd
```

## Enable a Service

Configure the service to start automatically during boot.

```bash
sudo systemctl enable sshd
```

Verify:

```bash
systemctl is-enabled sshd
```

## Disable a Service

Remove automatic boot-time activation.

```bash
sudo systemctl disable sshd
```

Verify:

```bash
systemctl is-enabled sshd
```

### Important Difference

```text
systemctl start
→ Start now

systemctl enable
→ Configure automatic activation at boot


systemctl stop
→ Stop now

systemctl disable
→ Remove automatic activation at boot
```

`enable` does not necessarily mean the service is currently running.

`start` does not necessarily mean the service will automatically start after reboot.

## Enable and Start Together

systemd provides the `--now` option.

```bash
sudo systemctl enable --now UNIT
```

Conceptually, this combines:

```bash
systemctl enable UNIT
systemctl start UNIT
```

into one operation.

## Mask a Service

Masking blocks a unit from being started.

```bash
sudo systemctl mask SERVICE
```

Check its state.

```bash
systemctl status SERVICE
```

Attempting to start a masked unit should fail.

```bash
sudo systemctl start SERVICE
```

## Unmask a Service

Remove the mask.

```bash
sudo systemctl unmask SERVICE
```

The service can then be started again.

```bash
sudo systemctl start SERVICE
```

## Disable vs Mask

```text
disable
→ Prevent automatic startup at boot
→ Manual start is still possible

mask
→ Block the unit from being started
→ The unit must be unmasked before normal start
```

Masking is therefore stronger than disabling.

## Verify Service Recovery

After unmasking and starting:

```bash
systemctl status SERVICE
```

Confirm that the unit returned to the expected state.

## Inspect Unit Files

List installed unit files.

```bash
systemctl list-unit-files
```

Limit the output to services.

```bash
systemctl list-unit-files --type=service
```

This helps distinguish installed unit definitions from units currently loaded in memory.

## Inspect Service Dependencies

View unit dependencies.

```bash
systemctl list-dependencies sshd.service
```

A systemd service can depend on or interact with other units.

Conceptually:

```text
Service
   |
   ├── Required Units
   ├── Related Targets
   └── Other Dependencies
```

Dependency inspection can be useful during troubleshooting when a service does not start as expected.

## Default Target

systemd uses targets to represent system operating states or goals.

Check the system's default boot target.

```bash
systemctl get-default
```

A server-oriented environment can use:

```text
multi-user.target
```

A graphical environment can use:

```text
graphical.target
```

## Inspect the Default Target Link

Check the default target symbolic link.

```bash
ls -l /etc/systemd/system/default.target
```

Conceptually:

```text
System Boot
    |
    v
default.target
    |
    v
Configured Target
    |
    v
Required Units
```

## Runlevel and Target Concept

Traditional Linux systems used numeric runlevels.

systemd uses targets for similar system-state purposes.

A common conceptual relationship is:

```text
Traditional Runlevel        systemd Target

3                           multi-user.target

5                           graphical.target
```

Targets are systemd units and should not be treated as merely renamed runlevel numbers.

## Change the Default Target

The default target can be changed with:

```bash
sudo systemctl set-default TARGET
```

Example form:

```bash
sudo systemctl set-default multi-user.target
```

Do not change the default target unnecessarily on a working system.

## Isolate a Target

systemd can switch the current system state toward a target using:

```bash
sudo systemctl isolate TARGET
```

This can stop units that are not required by the selected target.

Because it can significantly change the current system state, it should be used carefully.

## Socket Units

A `.socket` unit represents a communication socket managed by systemd.

Socket activation allows systemd to wait for a request and activate the associated service when required.

Conceptually:

```text
Client Request
      |
      v
.socket Unit
      |
      v
Associated Service
```

This is different from requiring every service process to remain permanently running.

## Inspect Socket Units

List socket units.

```bash
systemctl list-units --type=socket
```

List installed socket unit files.

```bash
systemctl list-unit-files --type=socket
```

## Cockpit Socket Activation

Cockpit is a web-based Linux administration interface.

If Cockpit is installed, its socket unit can be inspected.

```bash
systemctl status cockpit.socket
```

If the unit exists and the lab environment permits it, the socket can be enabled and started together.

```bash
sudo systemctl enable --now cockpit.socket
```

Verify:

```bash
systemctl status cockpit.socket
```

The important concept is socket activation:

```text
Web Client
    |
    v
cockpit.socket
    |
    v
Cockpit Service Functionality
```

Cockpit commonly uses TCP port 9090, but this lab focuses on the systemd unit relationship rather than web-interface configuration.

## Service Management Workflow

A basic service-management workflow is:

```text
Inspect
   |
   v
systemctl status
   |
   v
Determine Current State
   |
   +───────────────+
   |               |
   v               v
start/stop       enable/disable
Runtime           Boot Policy
   |
   v
Verify
```

## Troubleshooting Workflow

When a service does not start:

```text
Service Problem
      |
      v
Check Status
      |
      v
systemctl status SERVICE
      |
      v
Check Runtime State
      |
      v
Check Enabled / Disabled State
      |
      v
systemctl is-enabled SERVICE
      |
      v
Check Whether Unit Is Masked
      |
      v
Inspect Dependencies
      |
      v
systemctl list-dependencies SERVICE
      |
      v
Correct the Cause
      |
      v
Start or Restart
      |
      v
Verify
```

## Practical SSH Service Inspection

Inspect the SSH service.

```bash
systemctl status sshd
```

Check boot-time configuration.

```bash
systemctl is-enabled sshd
```

Inspect the process when the service is running.

```bash
ps -ef | grep sshd
```

Package information can also be checked.

```bash
rpm -q openssh-server
```

This demonstrates the relationship:

```text
Package
   |
   v
Unit File
   |
   v
Service
   |
   v
Process
```

## Practical crond Inspection

Inspect the command scheduler service.

```bash
systemctl status crond
```

Check whether it is enabled.

```bash
systemctl is-enabled crond
```

The status output can be used to distinguish:

```text
Current runtime state
Boot-time configuration
```

## Service State Verification

After any administrative change, verify the result instead of assuming the command succeeded.

Example:

```bash
sudo systemctl start SERVICE
systemctl status SERVICE
```

For boot configuration:

```bash
sudo systemctl enable SERVICE
systemctl is-enabled SERVICE
```

For masking:

```bash
sudo systemctl mask SERVICE
systemctl status SERVICE
```

For recovery:

```bash
sudo systemctl unmask SERVICE
sudo systemctl start SERVICE
systemctl status SERVICE
```

## Runtime and Boot-State Comparison

```text
Command                    Primary Purpose

systemctl start             Start now
systemctl stop              Stop now
systemctl restart           Restart now
systemctl reload            Reload configuration

systemctl enable            Enable at boot
systemctl disable           Disable at boot
systemctl is-enabled        Inspect boot configuration

systemctl mask              Block start
systemctl unmask            Remove start block
```

## Unit Relationship

```text
systemd
   |
   v
Units
   |
   +-------------------+-------------------+
   |                   |                   |
   v                   v                   v
.service             .socket             .target
   |                   |                   |
   v                   v                   v
Service Process    Activation Point    System Goal
```

## Verification Checklist

- Loaded service units were listed.
- Installed service unit files were inspected.
- A service status was inspected.
- Runtime and boot-time states were distinguished.
- Service start and stop behavior was reviewed.
- Restart and reload concepts were compared.
- Enable and disable behavior was reviewed.
- Mask and unmask behavior was reviewed.
- Service dependencies were inspected.
- The default systemd target was inspected.
- The `default.target` symbolic link was inspected.
- Common systemd unit types were identified.
- Socket units were inspected.
- Cockpit socket activation was reviewed where available.
- Administrative changes were followed by explicit verification.

## What I Learned

- systemd manages services and other resources as units.
- `.service` is only one of several systemd unit types.
- `.socket` units can support socket-based service activation.
- `.target` units group other units into system operating states or goals.
- `systemctl status` provides current unit-state information.
- `active` and `enabled` describe different aspects of a service.
- `start` and `stop` control the current runtime state.
- `enable` and `disable` control boot-time activation.
- A service can be active but disabled, or inactive but enabled.
- `mask` prevents a unit from being started and is stronger than `disable`.
- `unmask` removes the start restriction.
- `restart` and `reload` perform different service-management operations.
- Unit dependencies can be inspected with `systemctl list-dependencies`.
- `systemctl get-default` identifies the default boot target.
- `/etc/systemd/system/default.target` links the system to its default target.
- systemd targets provide a modern replacement for many traditional runlevel use cases.
- Cockpit can use a socket unit for on-demand activation.
- Service management should always include verification after configuration changes.
