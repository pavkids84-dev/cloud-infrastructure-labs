# Linux User Management Lab

## Objective

Practice Linux user and group administration on Rocky Linux.

The goal of this lab is to understand how Linux manages user accounts, groups, passwords, account policies, privileges, and login information through hands-on verification.

## Environment

- OS: Rocky Linux
- Shell: Bash
- Privilege: root or sudo-enabled user

## User and Group Management Overview

Linux users and groups are identified internally by numeric IDs.

```text
User
├── Username
├── UID
├── Primary Group
├── Supplementary Groups
├── Home Directory
└── Login Shell

Group
├── Group Name
├── GID
└── Members
```

A user has one primary group and can belong to multiple supplementary groups.

## Account-Related Files

Important user and group configuration files include:

```text
/etc/passwd
→ General user account information

/etc/shadow
→ Password and password-aging information

/etc/group
→ General group information

/etc/gshadow
→ Protected group information

/etc/login.defs
→ Default login and account policy settings
```

## Inspect User Creation Defaults

Check the default values used by `useradd`.

```bash
useradd -D
```

Inspect login-related defaults.

```bash
grep -E '^(UMASK|HOME_MODE|PASS_MAX_DAYS|PASS_MIN_DAYS|PASS_MIN_LEN|PASS_WARN_AGE)' /etc/login.defs
```

### What to Verify

- Default home directory location
- Default login shell
- Skeleton directory
- Password aging defaults
- Default permission-related settings

## Create a Test User

Create a test user with a home directory and Bash login shell.

```bash
useradd -m -s /bin/bash labuser
```

Verify that the account exists.

```bash
id labuser
```

Check the home directory.

```bash
ls -ld /home/labuser
```

## Verify `/etc/passwd`

Inspect the new account entry.

```bash
grep '^labuser:' /etc/passwd
```

The `/etc/passwd` entry follows this structure:

```text
username:password-placeholder:UID:GID:comment:home-directory:login-shell
```

Example structure:

```text
labuser:x:UID:GID::/home/labuser:/bin/bash
```

### Interpretation

```text
labuser
→ Login name

x
→ Password information is stored separately in /etc/shadow

UID
→ User ID

GID
→ Primary group ID

/home/labuser
→ Home directory

/bin/bash
→ Login shell
```

## Verify `/etc/shadow`

Inspect the protected account entry.

```bash
grep '^labuser:' /etc/shadow
```

The `/etc/shadow` file stores information such as:

```text
Username
Password hash
Last password change
Minimum password age
Maximum password age
Warning period
Inactive period
Account expiration
```

Do not publish real password hashes in public documentation.

## Inspect the Private Group

Check whether a group associated with the user exists.

```bash
grep '^labuser:' /etc/group
```

Check the user's primary group information.

```bash
id labuser
```

This demonstrates the relationship between a user account and its primary group.

## Create a Supplementary Group

Create a new group.

```bash
groupadd labteam
```

Verify the group.

```bash
grep '^labteam:' /etc/group
```

Inspect its GID.

```bash
getent group labteam
```

## Add the User to a Supplementary Group

Add `labuser` to `labteam` while preserving existing supplementary group memberships.

```bash
usermod -aG labteam labuser
```

Verify the result.

```bash
id labuser
```

```bash
groups labuser
```

### Key Concept

```text
-G
→ Specify supplementary groups

-a
→ Append without replacing existing supplementary groups
```

The combination `-aG` allows a new supplementary group to be added without removing existing memberships.

## Set a Password

Set a password for the test account.

```bash
passwd labuser
```

Verify that password-related information exists in `/etc/shadow`.

```bash
grep '^labuser:' /etc/shadow
```

The password itself is not stored as plain text.

## Inspect Password Aging

Check the current password-aging policy.

```bash
chage -l labuser
```

Review information such as:

```text
Last password change
Password expires
Password inactive
Account expires
Minimum number of days between password changes
Maximum number of days between password changes
Number of days of warning before password expires
```

## Configure Password Aging

Configure a minimum password age of 1 day, a maximum age of 180 days, and a warning period of 15 days.

```bash
chage -m 1 -M 180 -W 15 labuser
```

Verify the updated policy.

```bash
chage -l labuser
```

### Interpretation

```text
-m 1
→ Minimum number of days before the password can be changed again

-M 180
→ Maximum number of days the password can be used

-W 15
→ Number of warning days before password expiration
```

## Force a Password Change

Set the last password change date so that the user must change the password at the next login.

```bash
chage -d 0 labuser
```

Verify the result.

```bash
chage -l labuser
```

## Lock the Account Password

Lock password authentication for the account.

```bash
passwd -l labuser
```

Inspect the shadow entry.

```bash
grep '^labuser:' /etc/shadow
```

Check the account policy.

```bash
chage -l labuser
```

### Key Concept

Account locking is different from account deletion.

```text
Lock
→ Account information remains
→ Password authentication is disabled

Delete
→ Account itself is removed
```

## Unlock the Account Password

Unlock the account.

```bash
passwd -u labuser
```

Verify the shadow entry again.

```bash
grep '^labuser:' /etc/shadow
```

## Inspect Account Expiration

Check the current expiration status.

```bash
chage -l labuser
```

Password expiration and account expiration are separate concepts.

```text
Password expiration
→ Controls the lifetime of the password

Account expiration
→ Controls the lifetime of the account itself
```

## Inspect Group Files

Inspect the test groups in `/etc/group`.

```bash
grep -E '^(labuser|labteam):' /etc/group
```

Inspect protected group information.

```bash
grep -E '^(labuser|labteam):' /etc/gshadow
```

This demonstrates the relationship:

```text
/etc/passwd   ↔ /etc/shadow
/etc/group    ↔ /etc/gshadow
```

## Inspect Login Messages

Check the system login message files.

```bash
cat /etc/issue
```

```bash
cat /etc/motd
```

These files can be used to display system or administrative information to users during login.

## Inspect `.hushlogin`

Check whether the test user has a `.hushlogin` file.

```bash
ls -la /home/labuser
```

A `.hushlogin` file can be used to suppress some login messages for that user.

## Compare `su` and `su -`

Switch to the test account.

```bash
su labuser
```

Check the environment.

```bash
whoami
pwd
echo "$HOME"
```

Return to the original shell.

```bash
exit
```

Switch again using a login environment.

```bash
su - labuser
```

Check the environment.

```bash
whoami
pwd
echo "$HOME"
```

Return to the original shell.

```bash
exit
```

### Comparison

```text
su USER
→ Switches user identity

su - USER
→ Switches user identity and starts a login environment
```

## Inspect sudo Usage

If the current account has sudo privileges, run a single command with elevated privileges.

```bash
sudo whoami
```

The expected identity should be an administrative user when sudo access is configured correctly.

### Privilege Concept

```text
su
→ Switch user

su -
→ Switch user with the target user's login environment

sudo COMMAND
→ Run a specific command with elevated privileges

sudo -i
→ Start an interactive login-style administrative shell
```

## Authentication and Authorization

Authentication and authorization are different concepts.

```text
Authentication
→ Who are you?

Authorization
→ What are you allowed to do?
```

Linux authentication can be connected to PAM.

```text
Login / SSH / sudo / passwd
            |
            v
           PAM
            |
            v
     Authentication Policy
```

File permissions, groups, and sudo policies control what an authenticated user is allowed to do.

## Inspect Current Login Sessions

Check currently logged-in users.

```bash
who
```

Display additional session information.

```bash
who -u
```

Check the current terminal.

```bash
tty
```

## Inspect Login History

Display recent login history.

```bash
last
```

Display the most recent login information for accounts.

```bash
lastlog
```

### Login Information Summary

```text
who
→ Currently logged-in users

last
→ Login history

lastlog
→ Most recent login information for each account
```

## Inspect Authentication Logs

Inspect recent authentication-related log entries.

```bash
tail /var/log/secure
```

If administrator privileges are required:

```bash
sudo tail /var/log/secure
```

The exact log entries depend on the activity performed on the system.

## Verify Account State Before Cleanup

Review the account one final time.

```bash
id labuser
```

```bash
groups labuser
```

```bash
grep '^labuser:' /etc/passwd
```

```bash
grep '^labuser:' /etc/shadow
```

```bash
grep '^labteam:' /etc/group
```

## Cleanup

Remove the test user and its home directory.

```bash
userdel -r labuser
```

Remove the supplementary group.

```bash
groupdel labteam
```

## Verify Cleanup

Confirm that the user no longer exists.

```bash
id labuser
```

Confirm that the account entry was removed.

```bash
grep '^labuser:' /etc/passwd
```

Confirm that the supplementary group was removed.

```bash
grep '^labteam:' /etc/group
```

These commands should no longer return valid account or group information after successful cleanup.

## Account Lifecycle

This lab followed a complete user-account management workflow.

```text
Create User
    |
    v
Verify Account Files
    |
    v
Create Group
    |
    v
Assign Supplementary Group
    |
    v
Set Password
    |
    v
Configure Password Aging
    |
    v
Lock Account
    |
    v
Unlock Account
    |
    v
Inspect Login Information
    |
    v
Remove Test Resources
    |
    v
Verify Cleanup
```

## Verification Checklist

- Test user was created successfully.
- Home directory and login shell were configured.
- `/etc/passwd` entry was verified.
- `/etc/shadow` entry was verified.
- Primary group information was inspected.
- Supplementary group was created.
- User was added to the supplementary group.
- UID, GID, and group memberships were verified.
- Password was configured.
- Password-aging settings were inspected and modified.
- Account password was locked and unlocked.
- `su` and `su -` behavior was compared.
- sudo-based command execution was inspected where available.
- Current login sessions were inspected.
- Login history was inspected.
- Authentication-related logs were inspected.
- Test user and group were removed.
- Cleanup was verified.

## What I Learned

- Linux users are identified internally by UID.
- Linux groups are identified by GID.
- A user has one primary group and can belong to multiple supplementary groups.
- `/etc/passwd` stores general user account information.
- `/etc/shadow` stores protected password and password-aging information.
- `/etc/group` stores general group information.
- `/etc/gshadow` stores protected group information.
- `useradd`, `usermod`, and `userdel` manage the user account lifecycle.
- `groupadd`, `groupmod`, and `groupdel` manage groups.
- `passwd` manages account passwords and password locking.
- `chage` manages password-aging and expiration policies.
- `-aG` can be used to append a user to a supplementary group.
- Locking an account password is different from deleting the account.
- `su`, `su -`, and `sudo` provide different privilege-management behaviors.
- Authentication determines user identity, while authorization determines permitted actions.
- `who`, `last`, and `lastlog` provide different views of login activity.
- User-management changes should be verified through account files, commands, and login information rather than assumed to have succeeded.
