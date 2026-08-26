# Cloud Infrastructure Labs

A hands-on learning repository for building practical skills in cloud infrastructure, Linux system administration, networking, automation, containers, and infrastructure troubleshooting.

The purpose of this repository is to document not only what I studied, but also what I configured, tested, verified, and troubleshot in practical lab environments.

## Learning Approach

Each lab focuses on a practical workflow:

```text
Concept
   |
   v
Hands-on Configuration
   |
   v
Command Execution
   |
   v
Verification
   |
   v
Troubleshooting
   |
   v
Lessons Learned
```

Rather than simply collecting commands, I use this repository to understand how infrastructure components behave and how to investigate problems when expected results are not produced.

## Current Focus

### Linux

Hands-on Linux administration labs using Rocky Linux and VMware.

[View Linux Labs](./linux/README.md)

Current Linux topics include:

- Linux system architecture
- SSH remote administration
- Kernel and system information
- File and directory management
- File permissions and inodes
- Symbolic and hard links
- Shell input/output and pipelines
- Environment variables
- Vi/Vim
- Shell scripting
- File content searching with `grep`
- File system searching with `find`
- Archiving with `tar`
- Compression with `gzip` and `bzip2`

## Lab Environment

Current primary lab environment:

- Rocky Linux
- VMware
- Bash
- SSH-based remote administration

The environment will expand as additional infrastructure technologies are introduced.

## Repository Structure

```text
cloud-infrastructure-labs/
├── README.md
│
└── linux/
    ├── README.md
    ├── ssh-basic-lab.md
    ├── system-information-lab.md
    ├── file-directory-permission-lab.md
    ├── shell-basics-lab.md
    ├── shell-environment-lab.md
    ├── vi-basic-lab.md
    ├── search-archive-compression-lab.md
    │
    └── shell-script/
        ├── README.md
        ├── basic.sh
        ├── args.sh
        └── shift.sh
```

The repository structure will expand as new infrastructure topics are studied and practiced.

## Planned Areas

Future hands-on areas may include:

- Networking
- Databases
- Docker
- Kubernetes
- AWS
- Azure
- KT Cloud
- Terraform
- Ansible
- Infrastructure troubleshooting

## What I Am Building Toward

This repository is intended to build practical foundations for:

- Linux server administration
- Cloud infrastructure operations
- Infrastructure troubleshooting
- Cloud networking
- Container infrastructure
- Infrastructure automation
- Infrastructure as Code
- Cloud security

As my studies progress, I will continue adding hands-on labs, automation scripts, configuration examples, verification results, and troubleshooting records.
