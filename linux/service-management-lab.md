# Linux Service Management Lab

## Objective

Practice Linux service management with `systemd` and `systemctl`, including service status inspection, runtime control, boot-time configuration, dependency inspection, and basic troubleshooting.

## Environment

- OS: Rocky Linux
- Virtualization: VMware
- Shell: Bash
- Service Manager: systemd
- Test Service: sshd

## Service Management Overview

Linux services are background processes that provide system or application functionality.

`systemd` manages services and other system components, while `systemctl` is used to interact with systemd.

```text
Administrator
      |
      | systemctl
      v
   systemd
      |
      v
   Service
      |
      v
   Process
```

## Check Service Status

Check the SSH service.

```bash
systemctl status sshd
```

Important service states include:

```text
loaded
active
inactive
enabled
disabled
static
```

`active` and `inactive` describe the current runtime state.

`enabled` and `disabled` describe whether a service is configured to start automatically during system boot.

These concepts are different.

```text
active / inactive
→ Current runtime state

enabled / disabled
→ Boot-time configuration
```

## Check Runtime State

Check whether the SSH service is currently active.

```bash
systemctl is-active sshd
```

A typical result is:

```text
active
```

## Check Boot-Time Configuration

Check whether SSH is configured to start automatically during boot.

```bash
systemctl is-enabled sshd
```

A typical result may be:

```text
enabled
```

Runtime state and boot-time configuration should be checked separately.

## List Service Units

Display service unit files.

```bash
systemctl list-unit-files --type=service
```

This command can be used to inspect the boot-time configuration state of available services.

## Start a Service

Start the SSH service.

```bash
sudo systemctl start sshd
```

Verify the result.

```bash
systemctl status sshd
```

## Stop a Service

When using the VMware local console, stop the SSH service.

```bash
sudo systemctl stop sshd
```

Verify the result.

```bash
systemctl status sshd
```

The service should no longer be active.

> Do not stop `sshd` while relying on the same SSH connection for access to the server. Use the VMware console for this test.

Start the service again.

```bash
sudo systemctl start sshd
```

Verify the result.

```bash
systemctl status sshd
```

## Restart a Service

Restart the SSH service.

```bash
sudo systemctl restart sshd
```

Verify the result.

```bash
systemctl status sshd
```

`restart` stops and starts the service again.

## Reload a Service

Some services support reloading their configuration without a complete restart.

General form:

```bash
sudo systemctl reload <service>
```

Reload support depends on the service.

`restart` and `reload` serve different purposes.

```text
restart
→ Stop and start the service again

reload
→ Ask the running service to reload its configuration
```

## Enable a Service

Configure a service to start automatically during system boot.

```bash
sudo systemctl enable sshd
```

Check the result.

```bash
systemctl is-enabled sshd
```

`enable` does not mean the same thing as `start`.

```text
start
→ Start the service now

enable
→ Configure the service to start during boot
```

## Disable a Service

Remove the boot-time automatic start configuration.

```bash
sudo systemctl disable sshd
```

Check the result.

```bash
systemctl is-enabled sshd
```

`disable` does not necessarily stop a currently running service.

```text
stop
→ Stop the service now

disable
→ Prevent automatic start during boot
```

If SSH must remain enabled on the lab system, restore the original configuration after the test.

```bash
sudo systemctl enable sshd
```

## Inspect Service Dependencies

Display dependencies related to the SSH service.

```bash
systemctl list-dependencies sshd
```

Services may depend on other system units and resources.

The dependency view helps identify relationships between system components.

## Mask and Unmask a Service

A masked service is prevented from being started.

General form:

```bash
sudo systemctl mask <service>
```

Remove the mask:

```bash
sudo systemctl unmask <service>
```

Masking is stronger than disabling.

```text
disable
→ Disable automatic startup during boot

mask
→ Prevent the service from being started
```

Do not mask `sshd` during a remote SSH session.

## Basic Service Troubleshooting

When a service is not working as expected, begin by checking its status.

```bash
systemctl status sshd
```

Check whether it is currently active.

```bash
systemctl is-active sshd
```

Check whether it is configured to start during boot.

```bash
systemctl is-enabled sshd
```

If additional information is required, inspect the systemd journal.

```bash
journalctl -u sshd -n 30
```

A basic troubleshooting workflow is:

```text
Problem
   |
   v
Check Service Status
   |
   v
Inspect Runtime State
   |
   v
Inspect Logs
   |
   v
Identify Root Cause
   |
   v
Apply Resolution
   |
   v
Restart or Start Service
   |
   v
Verify
```

## Verification

Verify the following:

- `systemd` manages Linux services and other system components.
- `systemctl` is used to control and inspect systemd services.
- `systemctl status` displays service status information.
- `active` and `inactive` describe the current runtime state.
- `enabled` and `disabled` describe boot-time configuration.
- `start` starts a service immediately.
- `stop` stops a running service.
- `restart` stops and starts a service again.
- `reload` requests a supported service to reload its configuration.
- `enable` configures a service for automatic startup during boot.
- `disable` removes automatic startup configuration.
- `start` and `enable` have different purposes.
- `stop` and `disable` have different purposes.
- `list-dependencies` displays relationships between system units.
- `mask` prevents a service from being started.
- Service status and logs can be used together during troubleshooting.

## What I Learned

- Linux services are commonly managed through systemd.
- Service runtime state and boot-time configuration are separate concepts.
- A service can be active while disabled or inactive while enabled.
- `start`, `stop`, and `restart` control the current runtime state.
- `enable` and `disable` control automatic startup behavior.
- `mask` provides stronger protection against starting a service than `disable`.
- Service dependencies help explain relationships between system components.
- Checking service status is one of the first steps when troubleshooting a Linux server.
- Service logs provide additional evidence when status information alone is not enough to identify a failure.
- Understanding service management is fundamental to operating Linux servers and cloud infrastructure.
