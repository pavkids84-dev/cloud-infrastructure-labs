# SSH Fundamentals and Remote Access Lab

## Objective

Practice OpenSSH service inspection, remote login, server identity verification, password and public-key authentication, SSH client and server configuration, secure file transfer, local port forwarding, and layered SSH troubleshooting.

The goal is to understand SSH as an encrypted remote-access framework rather than treating `ssh` as an isolated login command.

## Environment

- OS: Rocky Linux
- Shell: Bash
- SSH Implementation: OpenSSH
- Server Daemon: `sshd`
- Client Tools: `ssh`, `scp`, `sftp`
- Init System: systemd
- Client Configuration: `~/.ssh/config`
- Server Configuration: `/etc/ssh/sshd_config`

## SSH Capabilities

The course introduces four major SSH capabilities:

```text
Remote Session Login
Remote Command Execution
File Transfer
Tunneling
```

SSH can therefore provide more than an interactive shell.

A simplified view is:

```text
SSH
 |
 +-- Remote Login
 |
 +-- Remote Command
 |
 +-- SCP / SFTP
 |
 +-- Port Forwarding
```

## SSH Architecture

SSH remote access can be represented as:

```text
SSH Client
    |
    | Encrypted Network Connection
    v
SSH Server
    |
    v
sshd
    |
    v
Authentication
    |
    v
Remote User Session
```

The client and server roles should be distinguished.

```text
ssh
→ SSH client command

sshd
→ SSH server daemon
```

## Inspect OpenSSH Packages

The course uses:

```bash
rpm -qa | grep openssh
```

Packages can include components such as:

```text
openssh
openssh-clients
openssh-server
```

The exact package versions must come from the current VM.

Do not copy lecture package versions as actual lab evidence.

## Inspect the SSH Server

Check the SSH server daemon.

```bash
systemctl status sshd
```

Inspect information such as:

```text
Loaded state
Active state
Main PID
Recent log entries
```

Record only the actual current-system output.

## SSH Service and Network Access

A running SSH service does not automatically guarantee successful remote access.

A useful service path is:

```text
sshd
  ↓
Listening Socket
  ↓
Firewall
  ↓
Network
  ↓
Authentication
  ↓
SSH Session
```

Each layer should be checked separately during troubleshooting.

## Basic Remote Login

General form:

```bash
ssh USER@HOST
```

Use only a hostname or IP address belonging to the authorized lab environment.

## SSH Encryption Flow

SSH establishes an encrypted session between a client and server.

A simplified workflow is:

```text
Client Connects
      ↓
Server Identity Verification
      ↓
Cryptographic Negotiation
      ↓
Key Exchange
      ↓
User Authentication
      ↓
Encrypted Session
```

SSH host authentication and user authentication are separate concepts.

## SSH Host Key

An SSH server has host keys that identify the server.

Server host-key files can exist under:

```text
/etc/ssh/
```

with names such as:

```text
ssh_host_rsa_key
ssh_host_rsa_key.pub

ssh_host_ecdsa_key
ssh_host_ecdsa_key.pub

ssh_host_ed25519_key
ssh_host_ed25519_key.pub
```

Actual algorithms and files depend on the current OpenSSH configuration.

## Host Key Purpose

A host key answers the question:

```text
Is this the SSH server I expected to reach?
```

It should be distinguished from a user authentication key.

```text
Host Key
→ Authenticates server identity

User Key
→ Authenticates user identity
```

## `known_hosts`

The SSH client stores information about previously accepted server host keys in:

```text
~/.ssh/known_hosts
```

Conceptually:

```text
First Connection
      ↓
Receive Server Host Key
      ↓
Verify Fingerprint
      ↓
Accept Server Identity
      ↓
Store in known_hosts
```

On later connections, the client can compare the presented host key with the previously recorded identity.

## Host-Key Change Warning

A changed host key should not automatically be ignored.

Possible reasons can include:

```text
Server reinstallation
Host-key regeneration
Server replacement
IP address reuse
Unexpected destination
Potential interception
```

Investigate the reason before deleting or replacing a `known_hosts` entry.

## Host-Key Algorithms

The course introduces host-key algorithm families including:

```text
RSA
ECDSA
Ed25519
```

Detailed cryptographic mathematics are outside the scope of this lab.

The important concept is that these algorithms can be used to establish SSH server identity.

## Host Authentication vs Session Encryption

The server host key is primarily associated with server authentication.

A simplified model is:

```text
Host Key
→ Verify Server Identity

Key Exchange
→ Establish Session Key Material

Session Keys
→ Protect Session Traffic
```

Do not interpret the host public key as directly encrypting every byte of the entire SSH session.

## Password Authentication

Password authentication can be represented as:

```text
Client Connects
      |
      v
Server Requests Authentication
      |
      v
Password
      |
      +-------+
      |       |
   Correct  Incorrect
      |       |
      v       v
   Login    Failure
```

The user account must exist on the remote system.

## Public-Key Authentication

The course also introduces key-based authentication.

```text
Client
  |
  +-- Private Key
  |
  +-- Public Key
          |
          v
     Remote Server
          |
          v
~/.ssh/authorized_keys
```

The private key remains on the client.

The public key is registered for the remote user.

## Generate an SSH Key Pair

The course uses:

```bash
ssh-keygen
```

This creates an SSH key pair.

Do not fabricate:

```text
Key type
Key path
Fingerprint
Randomart
```

Record only values generated by the actual lab environment.

## Private and Public Keys

The two key components must be treated differently.

```text
Private Key
→ Keep on the client
→ Do not share
→ Never commit to GitHub
```

```text
Public Key
→ Can be registered on the remote SSH server
```

A private key must never be stored in this repository.

## Copy a Public Key to a Remote User

The course uses:

```bash
ssh-copy-id USER@HOST
```

Conceptually:

```text
Client Public Key
        |
        | ssh-copy-id
        v
Remote User
~/.ssh/authorized_keys
```

Use the actual lab username and host.

## `authorized_keys`

The remote user's allowed public keys are stored in:

```text
~/.ssh/authorized_keys
```

The important relationship is:

```text
Client
------
Private Key


Server
------
Public Key
stored in authorized_keys
```

Do not confuse `authorized_keys` with `known_hosts`.

## `known_hosts` vs `authorized_keys`

```text
known_hosts
→ Client-side server identity database

authorized_keys
→ Server-side user public-key authorization list
```

A useful question is:

```text
Who is being authenticated?
```

If the answer is:

```text
Server
```

think:

```text
Host Key
known_hosts
```

If the answer is:

```text
User
```

think:

```text
User Key
authorized_keys
```

## Test Key-Based Login

After the public key is registered:

```bash
ssh USER@HOST
```

Verify that the intended authentication method works.

Do not assume successful key registration solely because `ssh-copy-id` completed.

## SSH Client Directory

A user SSH directory can contain files such as:

```text
~/.ssh/known_hosts
~/.ssh/id_*
~/.ssh/id_*.pub
~/.ssh/config
```

Their functions should be distinguished.

## SSH Client Configuration

The course introduces:

```text
~/.ssh/config
```

This file allows connection parameters to be stored under SSH aliases.

General structure:

```text
Host ALIAS
    Hostname ACTUAL_HOST
    Port SSH_PORT
    User REMOTE_USER
```

## SSH Client Alias

`Host` defines the alias used by the SSH client.

Example:

```text
Host app-server
```

The alias does not have to be the actual DNS hostname.

A user can connect with:

```bash
ssh app-server
```

when the corresponding configuration exists.

## `Hostname`

`Hostname` defines the actual SSH destination.

Example structure:

```text
Host app-server
    Hostname SERVER_ADDRESS
```

Distinguish:

```text
Host
→ Local SSH alias

Hostname
→ Actual remote destination
```

## `Port`

A client profile can define a non-default SSH port.

```text
Port SSH_PORT
```

This avoids repeatedly typing the port on the command line.

## `User`

A profile can also define:

```text
User REMOTE_USER
```

The client can therefore combine:

```text
Host
Hostname
Port
User
```

into one reusable connection profile.

## Example Client Configuration

Use placeholders rather than lecture addresses:

```text
Host internal-server
    Hostname SERVER_ADDRESS
    Port 22
    User clouduser
```

Then connect with:

```bash
ssh internal-server
```

Do not store passwords or private keys in the SSH client configuration.

## SSH Server Configuration

The SSH server configuration file introduced by the course is:

```text
/etc/ssh/sshd_config
```

Inspect it safely:

```bash
sudo less /etc/ssh/sshd_config
```

Do not modify a remote SSH configuration without a recovery method.

## `PermitRootLogin`

The server setting:

```text
PermitRootLogin
```

controls SSH root-login behavior.

It should be interpreted as a security-policy setting rather than as a value that should always be enabled.

## `PubkeyAuthentication`

The setting:

```text
PubkeyAuthentication
```

controls public-key authentication.

It connects directly to:

```text
ssh-keygen
ssh-copy-id
authorized_keys
```

## `PasswordAuthentication`

The course demonstrates:

```text
PasswordAuthentication no
```

This disables password-based SSH authentication when the effective server configuration uses that value.

Do not disable password authentication before verifying another authorized login method.

## Safe Password-Authentication Hardening

A safe workflow is:

```text
Configure Public-Key Authentication
        ↓
Verify Key Login in a New Session
        ↓
Keep Existing Session Open
        ↓
Change PasswordAuthentication
        ↓
Validate Configuration
        ↓
Apply the Change
        ↓
Test Another New Connection
```

This reduces the risk of locking yourself out of a remote system.

## Safe SSH Configuration Changes

Changing SSH configuration remotely can interrupt administrative access.

Use this operational principle:

```text
Keep Existing Session Open
        ↓
Modify Configuration
        ↓
Validate Configuration
        ↓
Apply the Intended Change
        ↓
Test from a New Session
        ↓
Confirm Access
        ↓
Close the Original Session
```

Do not treat an edit as complete until a new connection has been tested.

## SCP Overview

SCP provides direct secure file-copy operations over SSH-related transport.

General structure:

```bash
scp SOURCE DESTINATION
```

SCP can transfer data in both directions.

```text
Local → Remote

Remote → Local
```

## SCP with a Custom SSH Port

The course demonstrates the SCP port option:

```text
-P
```

General structure:

```bash
scp -P SSH_PORT FILE USER@HOST:DESTINATION
```

Important distinction:

```text
scp
→ -P for port

ssh
→ -p for port
```

The option letters are case-sensitive.

## Copy a Local File to a Remote Server

General structure:

```bash
scp SOURCE_FILE USER@SERVER:/tmp
```

Conceptually:

```text
Local File
    |
    v
Remote /tmp
```

Use a disposable test file and the actual remote user and host.

## Copy a Directory with SCP

The course introduces recursive transfer with:

```bash
scp -r DIRECTORY USER@HOST:DESTINATION
```

The `-r` option recursively copies directory contents.

Verify the resulting destination after transfer.

## Copy a Remote File to the Local System

General structure:

```bash
scp USER@SERVER:/tmp/REMOTE_FILE LOCAL_DIRECTORY
```

Conceptually:

```text
Remote File
     |
     v
Local Directory
```

## Understanding the SCP Remote Path

A remote SCP path uses:

```text
USER@HOST:PATH
```

The colon separates the remote host specification from the remote filesystem path.

Read source and destination positions carefully before transferring data.

## Verify SCP Transfers

After a transfer, inspect the destination.

For a local destination:

```bash
ls -l LOCAL_DIRECTORY
```

For a remote destination, inspect the actual remote path.

The workflow is:

```text
Transfer
   ↓
Inspect Destination
   ↓
Verify File
```

## SFTP Overview

SFTP provides an interactive secure file-transfer session.

Start a session:

```bash
sftp USER@HOST
```

The prompt changes to:

```text
sftp>
```

## SFTP Commands

Available commands can include:

```text
get
put
ls
cd
lcd
pwd
lpwd
mkdir
rm
rename
help
exit
quit
bye
```

The exact command list can vary by OpenSSH version.

## Remote and Local SFTP Context

An SFTP session operates with two filesystem contexts.

```text
Remote Filesystem
+
Local Filesystem
```

Remote working directory:

```text
sftp> pwd
```

Local working directory:

```text
sftp> lpwd
```

These can point to different directories.

## SFTP Download

```text
sftp> get FILE
```

Direction:

```text
Remote
  |
  v
Local
```

## SFTP Upload

```text
sftp> put FILE
```

Direction:

```text
Local
  |
  v
Remote
```

## SCP and SFTP Comparison

```text
SCP
→ Direct command-based file copy
```

```text
SFTP
→ Interactive secure file-transfer session
```

## SSH Tunneling

The course introduces SSH tunneling as another SSH capability.

A tunnel carries another TCP connection through the encrypted SSH session.

Conceptually:

```text
Application Traffic
        ↓
Local SSH Client
        ↓
Encrypted SSH Tunnel
        ↓
SSH Server
        ↓
Destination Service
```

## SSH Tunneling and VPN Concepts

The course illustrates tunneling using client-site and site-to-site VPN diagrams.

The shared concept is:

```text
Traffic
  ↓
Encapsulated / Protected Tunnel
  ↓
Intermediate Network
  ↓
Remote Side
```

SSH local port forwarding should not automatically be treated as a complete network-layer VPN.

SSH `-L` forwarding normally forwards selected TCP connections.

## Local Port Forwarding

The course introduces:

```text
-L
```

for local port forwarding.

General syntax:

```bash
ssh -L LOCAL_PORT:DESTINATION_HOST:DESTINATION_PORT USER@SSH_SERVER
```

Conceptually:

```text
Local Application
        ↓
localhost:LOCAL_PORT
        ↓
SSH Client
        ↓
Encrypted SSH Tunnel
        ↓
SSH Server
        ↓
DESTINATION_HOST:DESTINATION_PORT
```

## Local Port Forwarding to the SSH Server

If the destination is:

```text
localhost
```

inside the `-L` specification:

```bash
ssh -L LOCAL_PORT:localhost:DESTINATION_PORT USER@SSH_SERVER
```

that `localhost` is interpreted from the SSH server side.

Conceptually:

```text
Client Computer
localhost:LOCAL_PORT
        ↓
SSH Tunnel
        ↓
SSH Server
localhost:DESTINATION_PORT
```

Do not confuse client-side localhost with server-side localhost.

## Local Port Forwarding to Another Host

The tunnel destination does not have to be the SSH server itself.

General form:

```bash
ssh -L LOCAL_PORT:INTERNAL_HOST:INTERNAL_PORT USER@SSH_SERVER
```

Conceptually:

```text
Client Computer
localhost:LOCAL_PORT
        ↓
SSH Tunnel
        ↓
SSH Server
        ↓
Internal Host
INTERNAL_HOST:INTERNAL_PORT
```

The SSH server must be able to reach the specified destination.

## Bastion-Style Access Concept

Local forwarding can allow an authorized administrator to reach an internal service through an SSH-accessible host.

Conceptually:

```text
Administrator Laptop
        ↓
localhost:LOCAL_PORT
        ↓
SSH Bastion
        ↓
Private Service
```

Examples can include internal administration services or databases.

Use only authorized systems and destinations.

## Port-Forwarding Security

An encrypted tunnel does not remove the need for access control.

Questions to consider include:

```text
Who can access the SSH server?
Which accounts can authenticate?
Which destinations can the SSH server reach?
Which services should be forwarded?
How is administrative access audited?
```

Do not create tunnels that bypass organizational security policy.

## End-to-End SSH Model

SSH now combines multiple infrastructure layers and capabilities.

```text
Network Interface
       ↓
IP Address
       ↓
Route
       ↓
Firewall
       ↓
Listening Socket
       ↓
sshd
       ↓
Server Host Authentication
       ↓
User Authentication
       ↓
Encrypted Session
       ↓
Shell / Command / File Transfer / Tunneling
```

## SSH Troubleshooting Model

When remote SSH access fails:

```text
SSH Connection Failure
        |
        v
Is the network interface active?
        |
        v
Is the expected IP configured?
        |
        v
Is routing correct?
        |
        v
Is sshd running?
        |
        v
Is SSH listening on the expected socket?
        |
        v
Does the firewall allow the traffic?
        |
        v
Is server identity verification succeeding?
        |
        v
Is the selected authentication method allowed?
        |
        v
Does the account or key configuration match?
        |
        v
Inspect SSH logs
```

Do not change all layers at once.

## Host-Key Troubleshooting

If the SSH client reports a host-key mismatch:

```text
Stop
  ↓
Confirm the intended destination
  ↓
Check whether the server was rebuilt or replaced
  ↓
Verify the expected fingerprint through a trusted method
  ↓
Update known_hosts only when the identity change is legitimate
```

Do not automatically suppress host-identity warnings.

## Public-Key Authentication Troubleshooting

When public-key authentication fails:

```text
1. Confirm network connectivity.

2. Confirm sshd is running.

3. Confirm SSH is listening.

4. Confirm the firewall permits SSH.

5. Confirm public-key authentication is allowed.

6. Confirm the intended remote user is being used.

7. Confirm the public key is registered in that user's authorized_keys.

8. Confirm the client is using the intended private key.

9. Inspect SSH logs.

10. Retest the connection.
```

Do not regenerate keys immediately without first identifying which layer failed.

## Password Authentication Troubleshooting

If key authentication works but password authentication does not:

```text
Network Works
     ↓
SSH Transport Works
     ↓
Key Authentication Works
     ↓
Password Authentication Fails
     ↓
Inspect PasswordAuthentication Policy
```

The failure is likely beyond the basic network layer.

## Tunnel Troubleshooting

When local port forwarding fails:

```text
Can the client reach the SSH server?
        ↓
Can SSH authentication succeed?
        ↓
Is the local port available?
        ↓
Can the SSH server reach the destination host?
        ↓
Is the destination service listening?
        ↓
Is forwarding permitted by SSH policy?
        ↓
Test the local forwarded port
```

Separate SSH transport problems from destination-service problems.

## Verification Checklist

- OpenSSH capabilities were reviewed.
- The SSH client and `sshd` server roles were distinguished.
- The `sshd` service state was inspected.
- SSH encryption was understood conceptually.
- Server host authentication was distinguished from user authentication.
- SSH host keys were identified.
- `known_hosts` was identified as client-side server identity information.
- Host-key changes were treated as security-relevant events.
- RSA, ECDSA, and Ed25519 host-key concepts were reviewed.
- Password authentication was understood.
- Public-key authentication was understood.
- A private key was kept private.
- `authorized_keys` was identified as a server-side user public-key list.
- `known_hosts` and `authorized_keys` were distinguished.
- `~/.ssh/config` was reviewed.
- `Host`, `Hostname`, `Port`, and `User` were distinguished.
- `/etc/ssh/sshd_config` was inspected or reviewed.
- `PasswordAuthentication` was understood.
- Authentication hardening was treated as a lockout-sensitive operation.
- SCP custom-port syntax was reviewed.
- SCP recursive transfer was reviewed.
- SFTP was reviewed.
- Local port forwarding with `ssh -L` was understood.
- Client-side and server-side `localhost` contexts were distinguished.
- Forwarding through an SSH server to another internal host was understood.
- SSH tunneling was distinguished from a general full-network VPN.
- SSH troubleshooting was organized across network, service, identity, authentication, and forwarding layers.
- No passwords or private keys were committed to the repository.
- Runtime hostnames, IP addresses, PIDs, fingerprints, and key values were recorded only from the actual lab environment.

## What I Learned

- SSH provides remote login, remote command execution, file transfer, and tunneling.
- SSH host keys authenticate the identity of the server.
- `known_hosts` records accepted SSH server identities on the client.
- User public keys and server host keys serve different authentication purposes.
- `authorized_keys` controls which user public keys can authenticate to a remote account.
- SSH establishes encrypted session traffic after cryptographic negotiation and key exchange.
- `~/.ssh/config` can simplify repeated SSH connections.
- `Host` is an SSH client alias while `Hostname` defines the actual destination.
- `/etc/ssh/sshd_config` controls SSH server behavior.
- Password authentication should not be disabled until another verified login method exists.
- SCP uses uppercase `-P` for a custom SSH port.
- SCP and SFTP provide different secure file-transfer workflows.
- Local port forwarding maps a client-side port through an encrypted SSH session to a destination service.
- In `ssh -L`, the destination host is reached from the SSH server side.
- SSH tunneling can provide controlled access to internal TCP services.
- SSH tunneling and a full network-layer VPN are not identical concepts.
- SSH failures should be localized before configuration is changed.
