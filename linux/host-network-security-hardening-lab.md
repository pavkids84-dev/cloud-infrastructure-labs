# Host Network Security Hardening Lab

## Objective

Build a basic Linux host-security baseline by reducing unnecessary software and services, hardening SSH access, reviewing firewall and SELinux controls, configuring HTTPS concepts, and maintaining security updates.

The goal is to treat host security as a layered system rather than relying on one defensive mechanism.

## Environment

- OS: Rocky Linux lab environment
- Package System: RPM / DNF
- Service Manager: systemd
- Remote Access: OpenSSH
- Firewall: firewalld
- Mandatory Access Control: SELinux
- Web Server: Apache HTTP Server
- TLS Utility: OpenSSL

## Security Model

The course combines several security layers:

```text
Installed Software
        ↓
Running Services
        ↓
Listening Ports
        ↓
Remote Access Policy
        ↓
Firewall
        ↓
SELinux
        ↓
Application Encryption
        ↓
Security Updates
```

No single layer should be treated as a complete host-security solution.

---

# Reduce Installed Software

The course recommends minimizing installed software.

Inventory installed RPM packages:

```bash
rpm -qa
```

Save an inventory:

```bash
rpm -qa > installed_packages.txt
```

The inventory provides a baseline for reviewing which software is present on the host.

Do not remove packages only because they are unfamiliar.

Identify their purpose and dependencies before making changes.

---

# Attack Surface Reduction

A simplified security relationship is:

```text
More Installed Software
        ↓
More Code
        ↓
More Components to Maintain
        ↓
Potentially Larger Attack Surface
```

The hardening goal is:

```text
Install only what the system requires.
```

---

# Review Running Services

The course uses:

```bash
systemctl list-units -t service
```

to inspect services.

A more focused runtime inspection can also use:

```bash
systemctl list-units --type=service --state=running
```

Actual services must be identified from the current lab system.

---

# Review Listening Ports

The course uses:

```bash
netstat -tulpn
```

Modern Linux can also use:

```bash
ss -tulpn
```

Inspect:

```text
Protocol
Local Address
Listening Port
Process
```

Do not record lecture ports or processes as actual runtime evidence.

---

# Package, Service, and Port Relationship

Use the following model:

```text
Installed Package
       ↓
Running Service
       ↓
Listening Socket
       ↓
Firewall Exposure
       ↓
Remote Attack Surface
```

A package being installed does not necessarily mean that a network service is running.

A service running does not necessarily mean that the firewall exposes it remotely.

Verify each layer separately.

---

# Remove Unnecessary Exposure

For every listening service, ask:

```text
Why is this service required?

Which clients require access?

Which port is required?

Should it start automatically?

Can the service be disabled when unused?
```

Do not disable infrastructure services without understanding their dependencies.

---

# OpenSSH Hardening

The course introduces the following SSH hardening concepts:

```text
Change the SSH port
Use key-based authentication
Disable direct root login
Disable password authentication
Restrict allowed users
Restrict allowed groups
```

These controls should be layered rather than treated as interchangeable alternatives.

---

# Custom SSH Port

The course demonstrates a custom SSH port with:

```bash
ssh -p PORT USER@HOST
```

SCP uses uppercase `-P`:

```bash
scp -P PORT SOURCE USER@HOST:DESTINATION
```

Remember:

```text
ssh
→ -p

scp
→ -P
```

---

# SSH Port Changes Are Not Strong Authentication

Changing the SSH port can reduce some automated scanning noise.

It does not replace:

```text
Public-Key Authentication
Root Login Restriction
User Access Restrictions
Firewall Policy
Security Updates
```

Treat a non-default port as one configuration choice rather than the primary SSH security boundary.

---

# SSH Client Configuration

Instead of globally aliasing `ssh` to one custom port, reusable per-host settings can be stored in:

```text
~/.ssh/config
```

Conceptual structure:

```text
Host lab-server
    Hostname SERVER_ADDRESS
    Port SSH_PORT
    User REMOTE_USER
```

Do not store passwords or private keys in this file.

---

# Disable Direct SSH Root Login

The course uses:

```text
PermitRootLogin no
```

Conceptually:

```text
Direct Remote Root Login
→ Denied
```

Administrative access can instead use an authorized non-root account and controlled privilege escalation.

---

# Disable Password Authentication

The course uses:

```text
PasswordAuthentication no
```

Do not apply this until another authorized authentication method has been verified.

Safe workflow:

```text
Configure Public-Key Authentication
        ↓
Test Key Login in a New Session
        ↓
Keep Existing Session Open
        ↓
Modify SSH Authentication Policy
        ↓
Validate Configuration
        ↓
Apply Configuration
        ↓
Test Another New Session
```

---

# Validate SSH Configuration

Before applying SSH configuration changes:

```bash
sudo sshd -t
```

A successful syntax check does not prove remote connectivity, so test a new SSH session after applying the change.

---

# Restrict SSH Users

The course uses:

```text
AllowUsers jdoe smith
```

This limits SSH login to selected user accounts.

Conceptually:

```text
Linux Accounts
      ↓
SSH AllowUsers
      ↓
Selected SSH Users
```

---

# Restrict SSH Groups

The course uses:

```text
AllowGroups ssh_adm
```

Create a lab group:

```bash
sudo groupadd ssh_adm
```

Add a user:

```bash
sudo usermod -aG ssh_adm USER
```

Use only disposable lab accounts.

---

# SSH User and Group Restrictions

When multiple SSH access directives are configured, inspect the complete effective configuration.

Do not assume that adding one `AllowUsers` or `AllowGroups` directive overrides all other access conditions.

Test access using authorized lab accounts.

---

# Custom SSH Port Security Layers

A non-default SSH port can affect several configuration layers.

Conceptually:

```text
sshd_config
Port
   ↓
SELinux Port Policy
   ↓
firewalld
   ↓
Listening Socket
   ↓
SSH Client
```

A port change is incomplete if another required security layer prevents the daemon from using or receiving traffic on that port.

---

# Firewall Architecture

The course describes the Linux firewall stack conceptually as:

```text
Linux Kernel
      ↓
Netfilter
      ↓
firewalld
      ↓
firewall-cmd / firewall-config
```

firewalld configuration is stored under:

```text
/etc/firewalld/
```

The exact backend implementation can depend on the current Linux distribution and version.

---

# Firewall Hardening Principle

Allow only the traffic required for the server's role.

Conceptually:

```text
Required Service
      ↓
Required Protocol / Port
      ↓
Required Source
      ↓
Firewall Rule
```

Avoid opening unrelated ports to make troubleshooting easier.

---

# Runtime and Persistent Firewall State

Remember:

```text
Runtime Rule
!=
Persistent Rule
```

After permanent changes, verify both the saved configuration and the active runtime state.

---

# SELinux Security Layer

SELinux provides a security layer separate from traditional Unix owner/group/mode permissions.

Conceptually:

```text
Linux DAC Permission
        ↓
SELinux Policy
        ↓
Access
```

Passing DAC permissions does not guarantee that SELinux will allow an operation.

---

# Inspect SELinux Mode

The course uses:

```bash
getenforce
```

Possible modes include:

```text
Enforcing
Permissive
Disabled
```

Do not disable SELinux as a general troubleshooting technique.

---

# Inspect HTTP-Related SELinux Booleans

The course uses:

```bash
getsebool -a | grep http
```

This can show SELinux booleans related to HTTP services.

Do not change a boolean until its purpose and security impact are understood.

---

# File Context Management

The course demonstrates:

```bash
chcon -t TYPE FILE
```

and persistent file-context mapping with:

```bash
semanage fcontext -a -t TYPE PATH
```

followed by:

```bash
restorecon -RFvv PATH
```

The conceptual distinction is:

```text
chcon
→ Change current context directly
```

```text
semanage fcontext
→ Define persistent context mapping
```

```text
restorecon
→ Apply the defined/default mapping
```

---

# Course `admin_home_t` Example

The course uses:

```text
admin_home_t
```

as a file-context command example.

Do not interpret this as the standard SELinux type for Apache web content.

HTTP content can require HTTP-specific SELinux types depending on the intended access.

---

# SELinux Port Labeling

The course demonstrates:

```bash
semanage port -a -t http_port_t -p tcp 808
```

Conceptually:

```text
TCP Port
   ↓
SELinux Port Type
   ↓
Service Policy
```

This is separate from filesystem context management.

---

# Inspect Port Labels Before Changing Them

Before adding a new port label, inspect existing mappings.

```bash
semanage port -l
```

Determine whether the port:

```text
Does not exist
Is already assigned to the desired type
Is assigned to another type
```

Do not blindly add duplicate port mappings.

---

# HTTP on a Non-Standard Port

When Apache is configured for a non-standard port, several layers can matter.

```text
Apache Listen Configuration
        ↓
SELinux http_port_t
        ↓
firewalld
        ↓
Listening Socket
        ↓
Client Access
```

Troubleshoot the layers separately.

---

# HTTPS Overview

The course introduces Apache HTTPS using a self-signed X.509 certificate.

Conceptually:

```text
HTTP
      +
TLS
      ↓
HTTPS
```

HTTPS protects application traffic between a client and server using TLS.

---

# Generate a Self-Signed Certificate

The course uses:

```bash
openssl req -x509 -nodes -days 365 \
  -newkey rsa:2048 \
  -keyout server.key \
  -out server.crt
```

This creates:

```text
server.key
→ Private key

server.crt
→ Self-signed certificate
```

Do not commit either generated private key or real operational certificates from a private environment to this repository.

The private key must never be exposed.

---

# Private-Key Protection

The course uses `-nodes`, which creates the private key without passphrase encryption for the demonstrated service workflow.

This makes filesystem protection particularly important.

Conceptually:

```text
Private Key
→ Secret
→ Restrict access
```

Never place private keys in GitHub.

---

# Self-Signed Certificate Trust

A self-signed certificate can provide encrypted TLS communication but is not automatically trusted by normal client trust stores.

A browser can therefore present a certificate warning.

Use self-signed certificates only for appropriate lab or controlled internal scenarios.

---

# Apache TLS Certificate Configuration

The course demonstrates:

```apache
SSLCertificateFile /etc/certs/server.crt
SSLCertificateKeyFile /etc/certs/server.key
```

and:

```apache
<VirtualHost *:443>
    SSLEngine On
    SSLCertificateFile /etc/certs/server.crt
    SSLCertificateKeyFile /etc/certs/server.key
    DocumentRoot /var/www/
</VirtualHost>
```

Certificate paths must match the actual files on the system.

---

# Certificate Path Consistency

The OpenSSL course command creates:

```text
server.key
server.crt
```

relative to the current directory.

The Apache example references:

```text
/etc/certs/server.key
/etc/certs/server.crt
```

Ensure that actual file placement and Apache configuration are consistent.

Do not assume a file exists merely because a configuration path references it.

---

# `SSLCACertificateFile`

The course also shows:

```apache
SSLCACertificateFile /etc/certs/ca.pem
```

CA-file requirements depend on the intended TLS and certificate-validation configuration.

Do not add this directive blindly simply because a server certificate is CA-signed.

Verify the Apache TLS design and installed version.

---

# HTTPS Service Layers

A complete HTTPS path can include:

```text
Apache
   ↓
TLS Module
   ↓
Certificate / Private Key
   ↓
TCP 443
   ↓
SELinux
   ↓
firewalld
   ↓
Client
```

A valid certificate alone does not prove that remote HTTPS connectivity works.

---

# Security Updates

The course demonstrates a full system update:

```bash
sudo dnf update -y
```

and reboot:

```bash
sudo reboot
```

The slide specifically describes an update that includes the kernel.

---

# Kernel Update and Reboot

Installing a new kernel does not replace the currently running kernel immediately.

Conceptually:

```text
Install New Kernel
        ↓
Old Kernel Still Running
        ↓
Reboot
        ↓
Boot New Kernel
```

Verify the running kernel after reboot using actual system evidence.

---

# Reboot Requirements

Not every package update necessarily requires a full reboot.

The course demonstrates:

```text
Full Update Including Kernel
→ Reboot
```

Other updates can require different actions such as service restart.

Determine the appropriate action based on the updated components.

---

# CVE

CVE stands for:

```text
Common Vulnerabilities and Exposures
```

A CVE provides a standardized identifier for a publicly documented vulnerability.

A useful operational relationship is:

```text
Installed Software
       ↓
Affected Version?
       ↓
Known CVE?
       ↓
Vendor Advisory
       ↓
Patch / Mitigation
```

A CVE identifier itself does not replace vendor impact analysis.

---

# Vendor Security Information

The course recommends monitoring vendor security information for platforms such as:

```text
Red Hat
Debian
```

Security maintenance should use authoritative vendor advisories when evaluating package vulnerabilities and available fixes.

---

# Host Hardening Workflow

A basic host-security review can follow:

```text
1. Inventory installed packages.

2. Identify running services.

3. Identify listening sockets.

4. Remove or disable unnecessary exposure.

5. Review SSH authentication and authorization.

6. Review firewall policy.

7. Verify SELinux mode and required labels.

8. Protect web traffic with TLS when required.

9. Review available security updates.

10. Verify the system after each controlled change.
```

---

# Troubleshooting Principle

Do not make several security changes at once.

Use:

```text
Baseline
   ↓
Evidence
   ↓
One Controlled Change
   ↓
Verification
```

This preserves the ability to identify the actual cause of a failure.

---

# Example: Custom SSH Port Failure

Symptom:

```text
SSH works on port 22 but not on the new port.
```

Investigation model:

```text
sshd Configuration
      ↓
Configuration Validation
      ↓
Listening Socket
      ↓
SELinux Port Label
      ↓
firewalld Rule
      ↓
Network Reachability
```

Do not disable SELinux or the firewall simply to make the connection work.

---

# Example: HTTPS Failure

Symptom:

```text
HTTP works but HTTPS does not.
```

Investigation model:

```text
TLS Module
     ↓
Certificate Files
     ↓
Private-Key Access
     ↓
Apache TLS Configuration
     ↓
TCP 443 Listener
     ↓
SELinux
     ↓
Firewall
     ↓
Client
```

The working HTTP service already provides evidence that part of the Apache stack is functioning.

---

# Verification Checklist

- Installed RPM packages were inventoried or reviewed.
- Running services were inspected.
- Listening sockets were inspected.
- `netstat` was recognized as the course tool.
- `ss` was recognized as the modern Linux alternative.
- Unnecessary software and service exposure were understood as attack-surface concerns.
- SSH custom-port syntax was reviewed.
- SSH key authentication was prioritized over relying on a port change.
- `PermitRootLogin no` was reviewed.
- `PasswordAuthentication no` was reviewed.
- Key-based login was understood to require verification before password authentication is disabled.
- `AllowUsers` was reviewed.
- `AllowGroups` was reviewed.
- SSH group membership management was reviewed.
- Firewall and SSH port configuration were recognized as separate layers.
- Netfilter and firewalld roles were distinguished.
- SELinux mode was inspected or reviewed.
- SELinux booleans were introduced.
- File-context and port-label management were distinguished.
- `chcon` was distinguished from persistent `semanage fcontext` mappings.
- `restorecon` was understood.
- `semanage port` was understood.
- Existing SELinux port mappings were to be inspected before modification.
- HTTPS and TLS concepts were reviewed.
- A self-signed certificate was understood as a lab certificate.
- Private keys were treated as secrets.
- Certificate file paths were checked for consistency.
- Kernel-inclusive system updates were connected to reboot requirements.
- CVE monitoring was understood as part of vulnerability management.
- No passwords, private keys, real certificates, or fabricated runtime evidence were committed to the repository.

---

# What I Learned

- Host security is built from multiple defensive layers.
- Reducing unnecessary software and services reduces attack surface.
- Package inventory, service inventory, and listening-port inventory answer different security questions.
- Changing an SSH port is not a substitute for strong authentication.
- Root login, password authentication, users, and groups can be independently restricted by SSH policy.
- Firewall policy and SELinux policy provide separate controls.
- SELinux file contexts and port labels solve different authorization problems.
- HTTPS protects application traffic with TLS.
- A self-signed certificate can encrypt traffic without providing normal public trust.
- Private keys must remain secret.
- Security updates and CVE monitoring are part of routine infrastructure operations.
- Security changes should be evidence-driven and verified one layer at a time.
