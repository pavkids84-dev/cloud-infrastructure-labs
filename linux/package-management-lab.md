# Linux Package Management Lab

## Objective

Practice Linux package management and understand how software is installed, inspected, updated, removed, and retrieved from repositories.

The primary hands-on environment for this lab is Rocky Linux using RPM and DNF.

This lab also compares Red Hat-based package management with Debian-based package management and Snap at a conceptual level.

## Environment

- OS: Rocky Linux
- Shell: Bash
- Package Format: RPM
- Package Manager: DNF
- Privilege: root or sudo-enabled user

## Package Management Overview

Linux distributions use different package formats and package-management tools.

```text
Red Hat-based Linux
        |
        v
      RPM
        |
        v
      DNF
        |
        v
 Repository


Debian-based Linux
        |
        v
       DEB
        |
        v
       APT
        |
        v
 Repository
```

The package format and package manager have different responsibilities.

```text
RPM
→ Directly inspect and manage RPM packages

DNF
→ Search repositories, resolve dependencies,
  download packages, and manage installed software
```

## Inspect Installed RPM Packages

List all installed RPM packages.

```bash
rpm -qa
```

Search the installed package list for a specific keyword.

```bash
rpm -qa | grep openssh
```

## Query a Package

Check whether a package is installed.

```bash
rpm -q openssh-server
```

The command returns package information when the package is installed.

The exit status can also be inspected.

```bash
echo $?
```

```text
0
→ Package query succeeded

non-zero
→ Package query failed
```

## Inspect Package Information

Display detailed package information.

```bash
rpm -qi openssh-server
```

Useful information can include:

```text
Name
Version
Release
Architecture
Install Date
Size
License
Summary
Description
```

## Inspect Package File Lists

List files installed by a package.

```bash
rpm -ql openssh-server
```

Limit the output when necessary.

```bash
rpm -ql openssh-server | head
```

## Inspect Configuration Files

List configuration files associated with the package.

```bash
rpm -qc openssh-server
```

## Inspect Documentation Files

List documentation files associated with the package.

```bash
rpm -qd openssh-server
```

## RPM Query Summary

```text
rpm -qa
→ Query all installed packages

rpm -q PACKAGE
→ Check whether a package is installed

rpm -qi PACKAGE
→ Display detailed package information

rpm -ql PACKAGE
→ List package files

rpm -qc PACKAGE
→ List configuration files

rpm -qd PACKAGE
→ List documentation files
```

## RPM Installation and Removal Concepts

RPM supports direct package operations.

```text
-i
→ Install

-U
→ Upgrade or install

-F
→ Freshen an installed package

-e
→ Erase
```

Direct RPM operations work with package files themselves.

Repository-based package management with DNF is generally more convenient when dependencies must also be resolved.

## DNF Package Management

DNF manages packages through configured software repositories.

A simplified workflow is:

```text
User Request
     |
     v
    DNF
     |
     v
Repository Metadata
     |
     v
Dependency Resolution
     |
     v
RPM Packages
     |
     v
Installed Software
```

## Search for Packages

Search repositories by keyword.

```bash
dnf search openssh
```

A broader search can also be performed.

```bash
dnf search all openssh
```

## Inspect Package Information with DNF

Display package information.

```bash
dnf info openssh-server
```

## Install a Package

Install a package and its required dependencies.

```bash
sudo dnf install openssh-server
```

Automatic confirmation can be used when appropriate.

```bash
sudo dnf install -y openssh-server
```

## Remove a Package

Remove an installed package.

```bash
sudo dnf remove PACKAGE
```

Package removal should be performed carefully because dependency relationships may affect other software.

## Update Packages

Check available updates.

```bash
dnf check-update
```

Update packages.

```bash
sudo dnf update
```

## Inspect Repositories

List enabled repositories.

```bash
dnf repolist
```

Typical Rocky Linux repositories can include:

```text
BaseOS
AppStream
```

Their general roles are:

```text
BaseOS
→ Core operating-system packages

AppStream
→ Additional applications, runtime components, and modules
```

## Inspect Repository Configuration

Rocky Linux repository configuration files are stored under:

```text
/etc/yum.repos.d/
```

List the repository configuration files.

```bash
ls /etc/yum.repos.d/
```

Inspect a repository file when needed.

```bash
cat /etc/yum.repos.d/*.repo
```

The exact file names and repository definitions depend on the installed Rocky Linux version.

## Repository Concept

A software repository provides packages and package metadata to package managers.

```text
Repository
    |
    ├── Package Metadata
    ├── Package Versions
    └── RPM Packages
             |
             v
            DNF
             |
             v
      Installed Software
```

Repository configuration is important when troubleshooting package-search or package-installation failures.

## Repository Troubleshooting Flow

```text
Package Not Found
       |
       v
Check Package Name
       |
       v
Check Enabled Repositories
       |
       v
dnf repolist
       |
       v
Search Repository
       |
       v
dnf search
```

## Additional Repositories

Additional repositories can extend the package selection available to the system.

One example is EPEL.

Check whether the EPEL release package is installed.

```bash
rpm -q epel-release
```

If the lab specifically requires EPEL and it is available for the current environment, it can be installed through the package manager.

The important concept is:

```text
Repository Package
       |
       v
Repository Configuration Added
       |
       v
DNF Can Access Additional Packages
```

## DNF Repository Cache

DNF stores repository metadata and cached information under:

```text
/var/cache/dnf/
```

Inspect the directory.

```bash
ls /var/cache/dnf/
```

DNF cache data can be cleared with:

```bash
sudo dnf clean all
```

This removes cached DNF data.

It does not remove all installed packages.

## DNF History

DNF records package-management transactions.

List package-management history.

```bash
dnf history list
```

The history can help identify:

```text
Package installations
Package removals
Package updates
Transaction IDs
```

Inspect a specific transaction.

```bash
dnf history info TRANSACTION_ID
```

Example structure:

```bash
dnf history info 5
```

The actual transaction ID must be selected from the current system.

## Undo Concept

DNF can provide transaction-based undo functionality.

```bash
sudo dnf history undo TRANSACTION_ID
```

This command should not be executed casually on a working system.

The important administrative concept is that package-management history can be used to investigate recent software changes.

```text
System Problem
     |
     v
Was Software Recently Changed?
     |
     v
dnf history
     |
     v
Inspect Transaction
```

## Package Groups

DNF can manage groups of related packages.

List available package groups.

```bash
dnf group list
```

A package group represents multiple packages associated with a particular purpose.

```text
Single Package
→ One software package

Package Group
→ Collection of related packages
```

Package groups can be installed with:

```bash
sudo dnf group install "GROUP_NAME"
```

The actual group name should be selected from the current system's `dnf group list` output.

## DNF Command Summary

```text
dnf search KEYWORD
→ Search repositories

dnf info PACKAGE
→ Show package information

dnf install PACKAGE
→ Install package

dnf remove PACKAGE
→ Remove package

dnf update
→ Update packages

dnf repolist
→ List repositories

dnf group list
→ List package groups

dnf history list
→ List package transactions

dnf history info ID
→ Inspect a transaction

dnf clean all
→ Clear DNF cache
```

## RPM and DNF Comparison

```text
RPM
     |
     ├── Direct package query
     ├── Package file inspection
     └── Direct RPM operations


DNF
     |
     ├── Repository access
     ├── Dependency resolution
     ├── Package search
     ├── Package installation
     ├── Package removal
     ├── Package updates
     └── Transaction history
```

## Debian Package Management Comparison

Debian-based systems use a different package format and package-management stack.

```text
Rocky / RHEL
RPM
 |
DNF
 |
/etc/yum.repos.d/


Debian / Ubuntu
DEB
 |
APT
 |
/etc/apt/sources.list
/etc/apt/sources.list.d/
```

The following commands are included for conceptual comparison and are not required to be executed on the Rocky Linux lab system.

### Search for Packages

```bash
apt-cache search apache2
```

### Refresh Repository Metadata

```bash
apt-get update
```

`apt-get update` refreshes package information from configured repositories.

It does not mean that all installed packages are upgraded.

### Install a Package

```bash
apt-get install apache2
```

### Remove a Package

```bash
apt-get remove apache2
```

### Inspect Installed DEB Packages

```bash
dpkg -l
```

### Inspect Files Provided by a Package

```bash
dpkg -L PACKAGE
```

## RPM/DNF and DEB/APT Comparison

```text
Rocky / RHEL                   Debian / Ubuntu

rpm -qa                        dpkg -l
rpm -ql PACKAGE                dpkg -L PACKAGE
dnf search KEYWORD             apt-cache search KEYWORD
dnf install PACKAGE            apt-get install PACKAGE
dnf remove PACKAGE             apt-get remove PACKAGE
```

## Snap Concept

Ubuntu can also use Snap as an application distribution mechanism.

Conceptually:

```text
Ubuntu
  |
  ├── APT
  |    |
  |    └── .deb
  |         |
  |         └── OS and system packages
  |
  └── Snap
       |
       └── .snap
            |
            └── Applications
```

Snap packages can include application components and provide features such as:

```text
Application packaging
Sandboxing
Automatic updates
Revision management
Rollback
```

A Snap installation command can have the following form:

```bash
sudo snap install PACKAGE
```

The Rocky Linux lab does not require Snap installation.

## APT and Snap Comparison

```text
APT
→ Traditional Debian package management
→ Uses .deb packages
→ Uses configured software repositories

Snap
→ Application distribution system
→ Uses .snap packages
→ Can bundle more of the application environment
→ Supports revisions and rollback
```

## Practical Package Inspection Workflow

A useful package-management investigation sequence is:

```text
Is the package installed?
        |
        v
rpm -q PACKAGE
        |
        v
What package is it?
        |
        v
rpm -qi PACKAGE
        |
        v
What files did it install?
        |
        v
rpm -ql PACKAGE
        |
        v
Which repositories are available?
        |
        v
dnf repolist
        |
        v
What recent package changes occurred?
        |
        v
dnf history list
```

## Troubleshooting Example Workflow

When software is missing or fails after a package change:

```text
Problem
   |
   v
Verify Package
   |
   v
rpm -q
   |
   v
Inspect Package Information
   |
   v
rpm -qi / rpm -ql
   |
   v
Check Repository
   |
   v
dnf repolist
   |
   v
Search Package
   |
   v
dnf search
   |
   v
Inspect Recent Transactions
   |
   v
dnf history
```

## Verification Checklist

- Installed RPM packages were inspected.
- A specific package was queried.
- Package details were inspected.
- Package file lists were inspected.
- Package configuration files were identified.
- DNF package searching was practiced.
- Enabled repositories were inspected.
- Repository configuration files were located.
- DNF cache location was inspected.
- DNF transaction history was inspected.
- Package groups were inspected.
- RPM and DNF responsibilities were compared.
- Debian APT and dpkg were compared conceptually with RPM and DNF.
- Snap was compared conceptually with traditional package management.

## What I Learned

- RPM is the package format and low-level package-management tool used by Rocky Linux.
- DNF provides repository-based package management and dependency resolution.
- `rpm -q` checks whether a package is installed.
- `rpm -qi` displays detailed package information.
- `rpm -ql` lists files installed by a package.
- `rpm -qc` identifies package configuration files.
- `rpm -qd` identifies package documentation files.
- DNF searches configured repositories for available packages.
- Rocky Linux repository configuration is stored under `/etc/yum.repos.d/`.
- BaseOS and AppStream provide different categories of Rocky Linux packages.
- `dnf repolist` helps verify repository availability.
- DNF caches repository information under `/var/cache/dnf/`.
- `dnf history` provides evidence of previous package-management transactions.
- Package groups provide collections of related software.
- Debian-based systems use DEB packages with tools such as dpkg and APT.
- `apt-get update` refreshes repository package information rather than upgrading all installed software.
- Snap is an application distribution mechanism that differs from traditional system package management.
- Package troubleshooting should combine package inspection, repository inspection, and transaction history rather than relying on a single command.
