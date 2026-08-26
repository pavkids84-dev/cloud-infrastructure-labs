# SSH Basic Lab

## Objective

Connect from the host machine to a Rocky Linux virtual machine using SSH and verify the basic remote administration workflow.

## Environment

* OS: Rocky Linux
* Virtualization: VMware
* Access Method: SSH
* User: student

## Connection Flow

```text
Host PC
   |
   | SSH
   v
Rocky Linux VM
   |
   v
 sshd
   |
   v
User Shell
```

## Commands

Connect to the Rocky Linux VM:

```bash
ssh student@<server-ip>
```

After logging in, verify the current user and system information:

```bash
whoami
id
hostname
pwd
who
```

Switch to the root user:

```bash
su - root
```

Verify the current user again:

```bash
whoami
id
```

Return to the previous user:

```bash
exit
```

Disconnect from the remote server:

```bash
exit
```

## Verification

The following items were verified during the lab:

* Successfully connected to the Rocky Linux VM using SSH.
* Confirmed the currently logged-in user with `whoami`.
* Verified the UID, GID, and group memberships using `id`.
* Confirmed the hostname of the remote system using `hostname`.
* Verified the current working directory using `pwd`.
* Checked logged-in user sessions using `who`.
* Confirmed that `su - root` changes the current user context.
* Successfully exited from the root shell and the SSH session.

## What I Learned

* SSH provides secure remote access to a Linux server.
* The SSH client connects to the `sshd` service running on the remote host.
* Linux commands are executed with the privileges of the currently authenticated user.
* `whoami` shows the user currently executing commands.
* `id` displays the UID, GID, and group membership information of a user.
* `su - root` switches the current shell to the root user environment.
* Remote administration through SSH is a fundamental task in Linux server and cloud infrastructure management.
