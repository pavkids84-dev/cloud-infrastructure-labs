# Apache HTTP Server Management Lab

## Objective

Understand basic Apache HTTP Server installation and administration on Rocky Linux, including service management, web content, firewall access, Apache configuration, virtual hosting, module concepts, and layered troubleshooting.

The goal is to understand the relationship between the web application content, Apache configuration, Linux service state, network socket, firewall, name resolution, filesystem permissions, and security controls.

## Environment

- OS: Rocky Linux lab environment
- Web Server: Apache HTTP Server
- Package: `httpd`
- Service: `httpd`
- Main Configuration: `/etc/httpd/conf/httpd.conf`
- Default Content Directory: `/var/www/html`
- Firewall: firewalld
- Service Manager: systemd

## Apache Overview

The course introduces Apache HTTP Server with the following major areas:

```text
Installing Apache
Configuring Apache
Virtual Hosting
Adding Modules
```

Apache provides HTTP web-server functionality on the Linux system.

## Install Apache

The course uses:

```bash
yum install -y httpd
```

On a Rocky Linux environment using DNF:

```bash
sudo dnf install -y httpd
```

Do not copy package-version output from the lecture as actual lab evidence.

## Inspect the Service

Use:

```bash
systemctl status httpd
```

Inspect the actual service state.

Useful information can include:

```text
Loaded state
Active state
Main PID
Recent service messages
```

Do not fabricate runtime values.

## Start Apache

The course uses:

```bash
systemctl start httpd
```

This changes the current runtime service state.

## Enable Apache

The course uses:

```bash
systemctl enable httpd
```

This configures the service to start automatically at boot.

The two operations should be distinguished.

```text
systemctl start
→ Runtime service state

systemctl enable
→ Boot-time configuration
```

## Create Basic Web Content

The course creates:

```text
/var/www/html/index.html
```

with simple HTML content.

Example course structure:

```html
<html>
<title>Web Server test</title>
<body>
<p>Welcome to the class!!</p>
</body>
</html>
```

The important relationship is:

```text
Apache
   ↓
Document Root
   ↓
index.html
   ↓
HTTP Response
```

## Default Content Path

The basic course example uses:

```text
/var/www/html
```

as the web-content directory.

Conceptually:

```text
HTTP Request
     ↓
Apache
     ↓
/var/www/html
     ↓
Requested Content
```

## Allow HTTP Through firewalld

The course demonstrates a port-based rule:

```bash
sudo firewall-cmd \
  --zone=public \
  --add-port=80/tcp \
  --permanent
```

Apply the persistent firewall configuration:

```bash
sudo firewall-cmd --reload
```

The course slide contains `--relead`; this should be interpreted as a typo for:

```text
--reload
```

## HTTP Service Rule

The course also demonstrates:

```bash
sudo firewall-cmd --permanent --add-service=http
sudo firewall-cmd --reload
```

This provides a service-based alternative to adding TCP port 80 explicitly.

Conceptually:

```text
Port Rule
→ Explicit protocol and port

Service Rule
→ firewalld service definition
```

Do not add redundant rules without understanding the current firewall configuration.

## Inspect Firewall State

The course uses:

```bash
firewall-cmd --list-all
```

Verify that the active zone contains the intended HTTP access.

Actual interface names, services, and ports must come from the current lab environment.

## Local HTTP Test

The course tests Apache using:

```bash
curl http://localhost
```

This verifies whether the local HTTP service returns content.

Conceptually:

```text
curl
  ↓
localhost
  ↓
TCP / HTTP
  ↓
httpd
  ↓
Web Content
```

## Local vs Remote Verification

A successful local HTTP test does not prove that a remote client can reach the server.

Use the distinction:

```text
Local HTTP Test Works
        ↓
Apache likely responds locally
```

If remote access still fails, inspect:

```text
Listening socket
Firewall
Routing
Network reachability
```

This helps narrow the failure scope.

## Apache Configuration File

The course identifies:

```text
/etc/httpd/conf/httpd.conf
```

as the primary Apache configuration file.

Do not modify it without preserving a recovery path or configuration backup in a disposable lab.

## DocumentRoot

The course demonstrates changing the web root to:

```apache
DocumentRoot /srv/html
```

`DocumentRoot` defines where Apache obtains web content.

Conceptually:

```text
HTTP Request
     ↓
Apache
     ↓
DocumentRoot
     ↓
Filesystem Content
```

## Directory Configuration

The course uses:

```apache
<Directory "/srv/html">
    Options Indexes FollowSymLinks
    AllowOverride None
    Require all granted
</Directory>
```

A `<Directory>` block applies Apache configuration to a filesystem path.

## DocumentRoot vs Directory Policy

These directives have different roles.

```text
DocumentRoot
→ Defines the web-content location
```

```text
<Directory>
→ Defines Apache policy for that filesystem path
```

Changing one does not automatically configure the other.

## `Options Indexes`

The course enables:

```text
Indexes
```

This option is associated with directory-index listing behavior when an appropriate index resource is not used.

In an Internet-facing environment, directory listing should be enabled only when it is intentionally required.

## `Options FollowSymLinks`

The course enables:

```text
FollowSymLinks
```

This setting is associated with Apache following symbolic links according to its configuration and access rules.

The course does not provide a detailed symbolic-link security lab in this section.

## `AllowOverride None`

The course uses:

```apache
AllowOverride None
```

This controls whether directory-level `.htaccess` configuration can override applicable Apache configuration.

A simplified distinction is:

```text
httpd.conf
→ Central server configuration

.htaccess
→ Directory-level override mechanism
```

## `Require all granted`

The course uses:

```apache
Require all granted
```

This is an Apache authorization directive allowing access to the configured directory.

It should be distinguished from Linux filesystem permissions.

## Multiple Access-Control Layers

A request can depend on several independent controls.

```text
HTTP Request
      ↓
Apache Authorization
      ↓
Linux Filesystem Permissions
      ↓
SELinux
      ↓
File Access
```

A failure at one layer should not automatically be treated as a failure at another layer.

## Custom Document Roots and SELinux

The course changes the document root to:

```text
/srv/html
```

On a SELinux-enabled Rocky Linux system, a custom web-content path can require appropriate SELinux file-context configuration.

Conceptually:

```text
Apache Configuration Correct
        ↓
DAC Permissions Correct
        ↓
SELinux Context Correct?
```

Do not disable SELinux as a generic workaround.

Collect evidence and correct the intended security context.

## Virtual Hosting

The course introduces three virtual-hosting types:

```text
IP-Based
Name-Based
Port-Based
```

Virtual hosting allows one Apache system to provide multiple websites.

## IP-Based Virtual Hosting

Different IP addresses can identify different sites.

Conceptually:

```text
IP Address A
→ Site A

IP Address B
→ Site B
```

A server can have multiple IP addresses associated with one or more interfaces.

## Name-Based Virtual Hosting

Multiple websites can use the same server IP and port while being distinguished by requested host names.

Conceptually:

```text
server1.domain.com
        ↓
SERVER_IP:80

www1.domain.com
        ↓
SERVER_IP:80
```

Apache selects the appropriate virtual host using the HTTP request information and configured server names.

## Port-Based Virtual Hosting

Different ports can identify different services or sites.

Conceptually:

```text
SERVER_IP:80
→ Site A

SERVER_IP:8080
→ Site B
```

Port-based hosting requires clients to connect to the intended destination port.

## Course Name-Based Virtual Host Paths

The course assumes a base site:

```text
/var/www/www1.domain.com/html
```

and adds:

```text
/var/www/server1.domain.com/html
```

These are course examples only.

Use actual disposable lab domain names and paths.

## Recursive `chmod 755`

The course demonstrates:

```bash
chmod 755 -R /var/www/<nameofsite>
```

This should be treated as a simplified lab example.

Applying `755` recursively can set execute bits on ordinary files.

A real deployment should distinguish:

```text
Directory permissions
File permissions
Owner
Group
Required write access
```

Do not treat recursive `755` as a universal web-server permission policy.

## VirtualHost Block

The course uses:

```apache
<VirtualHost *:80>
    ServerAdmin webmaster@localhost
    ServerName server1.domain.com
    DocumentRoot /var/www/server1.domain.com/html
    ErrorLog LOG_PATH
    CustomLog ACCESS_LOG_PATH combined
</VirtualHost>
```

This defines one HTTP virtual host.

## `*:80`

The course uses:

```text
*:80
```

to identify the HTTP listener context for the virtual host.

Conceptually:

```text
Configured Apache Address
        +
TCP Port 80
        ↓
VirtualHost Matching
```

## `ServerName`

The course uses:

```apache
ServerName server1.domain.com
```

This identifies the host name associated with the virtual host.

A simplified name-based flow is:

```text
HTTP Request
Host: server1.domain.com
        ↓
Apache
        ↓
ServerName Match
        ↓
Selected VirtualHost
```

## DNS and Name-Based Virtual Hosting

Configuring:

```apache
ServerName server1.domain.com
```

does not by itself make that name resolvable by clients.

A complete conceptual path is:

```text
Client
  ↓
DNS or Hostname Resolution
  ↓
Domain Name → Server IP
  ↓
TCP Connection
  ↓
HTTP Host Information
  ↓
Apache VirtualHost
```

Name resolution is studied in the following DNS section.

## VirtualHost DocumentRoot

The course uses:

```apache
DocumentRoot /var/www/server1.domain.com/html
```

Conceptually:

```text
server1.domain.com
       ↓
VirtualHost
       ↓
DocumentRoot
       ↓
Site Content
```

## Apache Logs

The course introduces:

```text
ErrorLog
CustomLog
```

for virtual-host logging.

Their purposes are:

```text
ErrorLog
→ Error and diagnostic information

CustomLog
→ Request/access logging
```

Logs provide important troubleshooting evidence.

## Course `${APACHE_LOG_DIR}` Example

The course uses:

```apache
ErrorLog ${APACHE_LOG_DIR}/error.log
CustomLog ${APACHE_LOG_DIR}/access.log combined
```

This syntax depends on whether the referenced variable is defined in the actual Apache environment.

Do not copy it blindly into a Rocky Linux system.

Inspect the installed Apache configuration and existing log directives before choosing a log path.

## VirtualHost Directory Access

The course also uses:

```apache
<Directory "/var/www/server1.domain.com/html">
    Require all granted
</Directory>
```

This provides Apache authorization for the virtual-host content directory.

Use standard ASCII quotation marks in configuration files.

Do not copy typographic curly quotes from presentation slides.

## Apache Modules

The course introduces Apache modules as a way to extend server functionality.

It demonstrates:

```bash
dnf search mod_
```

and:

```bash
dnf install -y mod_ssl mod_php mod_wsgi
```

Package availability can differ by Rocky Linux version and enabled repositories.

Verify the actual DNF results before installation.

## `mod_ssl`

The course introduces:

```text
mod_ssl
```

as an Apache module.

It is associated with TLS/HTTPS support.

The course section does not provide a certificate-configuration exercise.

## `mod_php`

The course introduces:

```text
mod_php
```

and references a URL such as:

```text
http://SERVER_IP/info.php
```

The course does not show the contents of `info.php` on this page.

Do not invent a course file that was not provided.

Package and PHP integration behavior should be verified against the actual Rocky Linux environment.

## `mod_wsgi`

The course introduces:

```text
mod_wsgi
```

as another Apache module example.

It is associated with WSGI/Python web-application integration.

Detailed WSGI application configuration is outside the scope of this course section.

## Apache Infrastructure Model

A complete simplified request path is:

```text
Client
  ↓
DNS / IP
  ↓
Routing
  ↓
Firewall
  ↓
TCP Listener
  ↓
httpd
  ↓
VirtualHost
  ↓
DocumentRoot
  ↓
Filesystem Permission
  ↓
SELinux
  ↓
Web Content
```

This model can be used to localize web-service failures.

## Troubleshooting Workflow

When a web page is unavailable:

```text
Web Content Exists?
        ↓
Apache Configuration Valid?
        ↓
httpd Running?
        ↓
HTTP Port Listening?
        ↓
Local curl Works?
        ↓
Firewall Allows HTTP?
        ↓
Network Reachability Works?
        ↓
Name Resolution Works?
        ↓
Correct VirtualHost Selected?
        ↓
Filesystem Permission Correct?
        ↓
SELinux Allows Access?
```

Collect evidence before changing multiple layers.

## Local HTTP Failure

If:

```bash
curl http://localhost
```

fails, investigate local areas first:

```text
httpd state
Apache configuration
Listening socket
Web content
Local authorization
Filesystem access
```

Do not begin with remote-routing changes.

## Remote HTTP Failure

If local curl succeeds but a remote client fails:

```text
Local Apache Response
→ Working

Remote Access
→ Failing
```

prioritize areas such as:

```text
Firewall
Routing
Network reachability
Listening address
```

## Name Resolution Failure

If:

```text
HTTP by IP
→ Works

HTTP by hostname
→ Fails
```

the evidence points toward areas such as:

```text
DNS
/etc/hosts
Name resolution
```

rather than immediately changing Apache content.

## VirtualHost Failure

If one site works but another virtual host does not:

```text
Apache service itself
→ likely functioning

Investigate
→ ServerName
→ VirtualHost selection
→ DocumentRoot
→ Directory policy
→ Name resolution
```

## Permission Failure

If Apache reaches the correct site but receives access errors:

```text
Apache Authorization
        ↓
Linux DAC Permission
        ↓
SELinux Context
```

should be inspected as separate layers.

## Log-Based Troubleshooting

When Apache returns an error:

```text
Symptom
   ↓
HTTP status / Browser error
   ↓
Apache ErrorLog
   ↓
Relevant configuration
   ↓
Filesystem / Security state
   ↓
Controlled correction
   ↓
Verification
```

Logs should be treated as evidence rather than as an afterthought.

## Verification Checklist

- The `httpd` package was installed or reviewed.
- The `httpd` service was inspected.
- `start` and `enable` were distinguished.
- Basic HTML content was created or reviewed.
- `/var/www/html` was identified as the course's basic web-content directory.
- HTTP firewall access was reviewed.
- Port-based and service-based firewalld rules were distinguished.
- The course `--relead` typo was recognized as `--reload`.
- Local HTTP verification with `curl` was reviewed.
- Local and remote connectivity tests were distinguished.
- `/etc/httpd/conf/httpd.conf` was identified.
- `DocumentRoot` was understood.
- `<Directory>` configuration was understood.
- `Indexes` and `FollowSymLinks` were reviewed.
- `AllowOverride None` was reviewed.
- `Require all granted` was understood as Apache authorization.
- Filesystem permissions were distinguished from Apache authorization.
- SELinux was recognized as another independent access-control layer.
- IP-based virtual hosting was reviewed.
- Name-based virtual hosting was reviewed.
- Port-based virtual hosting was reviewed.
- `ServerName` was understood.
- Name resolution was connected to name-based virtual hosting.
- Recursive `chmod 755` was not treated as a universal production permission policy.
- `ErrorLog` and `CustomLog` were identified as troubleshooting evidence.
- `${APACHE_LOG_DIR}` was not assumed to exist in the current Rocky configuration.
- Standard ASCII quotes were used in actual Apache configuration.
- Apache module concepts were reviewed.
- `mod_ssl`, `mod_php`, and `mod_wsgi` were recognized as course examples.
- Module package availability was not fabricated.
- Lecture IP addresses, domain names, PIDs, package versions, and HTTP output were not recorded as actual lab evidence.

## What I Learned

- Apache HTTP Server is managed as the `httpd` service on the Rocky Linux course environment.
- Apache service state and boot-time enablement are separate concepts.
- Web content, Apache configuration, service state, firewall state, and network reachability are separate troubleshooting layers.
- `DocumentRoot` defines the content location while `<Directory>` defines policy for a filesystem path.
- Name-based virtual hosting allows multiple sites to share an IP address and HTTP port.
- `ServerName` helps Apache select the intended virtual host.
- DNS or another name-resolution mechanism is still required for clients to resolve a virtual-host name.
- Apache access depends on more than Linux file permissions.
- SELinux can independently affect access to custom web-content directories.
- Apache logs provide important evidence for configuration and access failures.
- Apache modules extend web-server functionality.
- Troubleshooting is more effective when local service verification is separated from remote network verification.
