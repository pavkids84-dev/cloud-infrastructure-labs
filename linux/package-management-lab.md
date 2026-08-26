# Linux Package Management Lab

## Objective

Practice Linux package inspection and management using RPM and DNF, understand the role of software repositories, and connect package installation with Linux service management.

## Environment

- OS: Rocky Linux
- Virtualization: VMware
- Shell: Bash
- Package Format: RPM
- Package Manager: DNF

## Package Management Overview

Red Hat-based Linux distributions use RPM packages and package management tools such as RPM, YUM, and DNF.

```text
Software Repository
        |
        v
       DNF
        |
        v
RPM Packages
        |
        v
Installed Software
```

RPM provides direct package inspection and management capabilities.

DNF uses software repositories to search, install, update, and remove packages.

## List Installed RPM Packages

Display installed RPM packages.

```bash
rpm -qa
```

Display only the first few results.

```bash
rpm -qa | head
```

Search the installed package list.

```bash
rpm -qa | grep ssh
```

## Query a Specific Package

Check whether Bash is installed.

```bash
rpm -q bash
```

Display detailed package information.

```bash
rpm -qi bash
```

## List Files Installed by a Package

Display files installed by the Bash package.

```bash
rpm -ql bash
```

Display only the first few entries.

```bash
rpm -ql bash | head
```

## Inspect Package Configuration Files

Display configuration files associated with the package.

```bash
rpm -qc bash
```

## Inspect Package Documentation

Display documentation files associated with the package.

```bash
rpm -qd bash
```

Display only the first few results.

```bash
rpm -qd bash | head
```

## Inspect an RPM File Before Installation

Information about a local RPM package file can be inspected before installation.

General form:

```bash
rpm -qip <package-file.rpm>
```

This differs from:

```bash
rpm -qi <installed-package>
```

```text
rpm -qi
→ Inspect an installed package

rpm -qip
→ Inspect an RPM package file before installation
```

## RPM Package Operations

RPM supports direct package installation, upgrade, verification, and removal.

Install an RPM package file:

```bash
sudo rpm -i <package-file.rpm>
```

Upgrade a package:

```bash
sudo rpm -Uvh <package-file.rpm>
```

The options represent:

```text
-U = upgrade
-v = verbose
-h = display installation progress
```

Verify an installed package:

```bash
rpm -V <package-name>
```

Remove an installed package:

```bash
sudo rpm -e <package-name>
```

For normal package installation on a repository-based Rocky Linux system, DNF is generally preferred because it can manage package dependencies.

## Package Dependencies

Software packages may require other packages or libraries.

```text
Package A
   |
   v
Package B
   |
   v
Package C
```

DNF can use repository metadata to identify and install required dependencies.

## Inspect Configured Repositories

Display enabled software repositories.

```bash
dnf repolist
```

Repositories provide packages and metadata that DNF uses for package management.

```text
Linux Server
     |
     | DNF
     v
Repository
     |
     ├── Packages
     └── Package Metadata
```

## Search for a Package

Search for the `tree` utility.

```bash
dnf search tree
```

Package search is useful when the exact package name is unknown.

## List Installed Packages with DNF

Display installed packages.

```bash
dnf list installed
```

Display only the first few entries.

```bash
dnf list installed | head
```

## Install a Package with DNF

Check whether the `tree` command is already available.

```bash
tree --version
```

Search for the package.

```bash
dnf search tree
```

Install it.

```bash
sudo dnf install tree
```

During installation, review the packages and dependencies that DNF plans to install.

## Verify Package Installation

Verify the package using RPM.

```bash
rpm -q tree
```

Verify the installed application.

```bash
tree --version
```

This demonstrates how DNF and RPM can be used together.

```text
DNF
→ Install and manage packages

RPM
→ Inspect the installed package
```

## Remove a Package

Remove the test package.

```bash
sudo dnf remove tree
```

Verify the result.

```bash
rpm -q tree
```

The package should no longer be reported as installed.

If the utility is needed for future labs, install it again.

```bash
sudo dnf install tree
```

## Update Packages

DNF can update installed packages to available newer versions.

```bash
sudo dnf update
```

Before applying large updates on production systems, the impact of package changes should be reviewed.

## Repository Management

DNF repository configuration determines where packages can be retrieved.

Display repositories:

```bash
dnf repolist
```

The course material also introduces repository addition using `dnf-config-manager`.

General form:

```bash
sudo dnf-config-manager --add-repo=<repository-url>
```

A repository should only be added when its source and purpose are understood.

## Package Management and Service Management

Installing a service package and running that service are separate operations.

```text
Package Installation
        |
        v
Configuration
        |
        v
Service Start
        |
        v
Boot-Time Enablement
        |
        v
Verification
```

For example:

```text
dnf install ...
→ Install software

systemctl start ...
→ Start the service now

systemctl enable ...
→ Configure the service to start during boot
```

A package being installed does not necessarily mean that its service is currently running.

## Basic Package Troubleshooting Workflow

When software cannot be installed or executed, investigate the package state and repository configuration.

```text
Problem
   |
   v
Search for Package
   |
   v
Check Repository
   |
   v
Check Installation State
   |
   v
Install or Update Package
   |
   v
Verify
```

Useful commands include:

```bash
dnf search <keyword>
dnf repolist
rpm -q <package>
rpm -qi <package>
```

## Verification

Verify the following:

- RPM packages are used by Red Hat-based Linux distributions.
- `rpm -qa` lists installed RPM packages.
- `rpm -q` checks a specific installed package.
- `rpm -qi` displays detailed information about an installed package.
- `rpm -ql` displays files installed by a package.
- `rpm -qc` displays package configuration files.
- `rpm -qd` displays package documentation files.
- `rpm -qip` can inspect a local RPM file before installation.
- RPM supports direct installation, upgrade, verification, and removal.
- DNF manages packages using software repositories.
- `dnf search` searches for packages by keyword.
- `dnf list installed` displays installed packages.
- `dnf install` installs packages and required dependencies.
- `dnf remove` removes packages.
- `dnf update` updates installed packages.
- `dnf repolist` displays configured repositories.
- Package installation and service execution are separate system administration tasks.

## What I Learned

- Linux software is commonly distributed and managed as packages.
- RPM provides detailed package inspection and direct package management capabilities.
- DNF provides repository-based package management and dependency resolution.
- Software repositories contain packages and metadata used by package managers.
- RPM and DNF complement each other: DNF is useful for repository-based management, while RPM is useful for detailed package inspection and verification.
- Package installation does not automatically represent the runtime state of a service.
- Package management, service management, and process management represent different layers of Linux administration.
- Understanding package and repository management is fundamental for configuring and maintaining Linux servers.
