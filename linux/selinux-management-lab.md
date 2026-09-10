# Linux SELinux Management Lab

## Objective

Practice SELinux inspection, mode management, security-context analysis, Boolean policy control, file-context management, and SELinux troubleshooting on Rocky Linux.

The main goal is to understand why normal Linux permissions can allow an operation while SELinux still denies it, and to troubleshoot the policy problem without disabling SELinux.

## Environment

- OS: Rocky Linux
- Shell: Bash
- Security Framework: SELinux
- SELinux Policy: targeted
- Privilege: root or sudo-enabled user

## SELinux Overview

SELinux provides Mandatory Access Control in addition to traditional Linux Discretionary Access Control.

```text
Traditional Linux Permissions
            |
            v
           DAC

SELinux Policy
            |
            v
           MAC
```

A request can therefore be affected by both traditional permissions and SELinux policy.

```text
DAC Allows Access
        +
SELinux Allows Access
        |
        v
Access Succeeds
```

A correct `chmod` or `chown` configuration does not automatically mean that SELinux policy will allow the same operation.

## Inspect Installed SELinux Packages

The course introduces:

```bash
rpm -qa | grep selinux
```

Use the command only to inspect the packages installed on the current VM.

Do not copy package versions from the lecture environment.

## SELinux Modes

The course introduces three SELinux modes.

```text
Enforcing
→ SELinux policy is enforced

Permissive
→ Policy violations are logged but not enforced

Disabled
→ SELinux policy enforcement is disabled
```

## Enforcing Mode

In enforcing mode, SELinux policy can deny an operation even when standard Linux permissions allow it.

Conceptually:

```text
Process
   |
   v
SELinux Policy Check
   |
   +----------+
   |          |
 Allow      Deny
   |          |
   v          v
Access      Block
```

The course uses Apache as an example.

```text
Process type:
httpd_t

Web-content type:
httpd_sys_content_t
```

SELinux policy determines whether a process with one type can access an object with another type.

## Permissive Mode

In permissive mode, SELinux does not enforce the denial but still records policy violations.

```text
Policy Violation
      |
      v
Log the Event
      |
      v
Do Not Block the Operation
```

Permissive mode can therefore help determine whether SELinux is involved in a failure.

It should not be treated as the final solution to a policy problem.

## Disabled Mode

Disabled mode removes SELinux policy enforcement.

Disabling SELinux should not be used as the default response to an application-access problem.

A better operational workflow is to identify the policy cause and correct the required context or policy setting.

## Inspect Persistent SELinux Configuration

The course uses:

```bash
cat /etc/selinux/config
```

or:

```bash
more /etc/selinux/config
```

The configuration can contain values such as:

```text
SELINUX=enforcing
SELINUXTYPE=targeted
```

The course introduces the following values for `SELINUX`:

```text
enforcing
permissive
disabled
```

Do not modify the persistent configuration simply to perform an inspection lab.

## Inspect the Current SELinux Mode

Use:

```bash
getenforce
```

The result can be:

```text
Enforcing
Permissive
Disabled
```

Record the actual result from the current VM.

## Inspect Detailed SELinux Status

Use:

```bash
sestatus
```

The course also demonstrates:

```bash
sestatus -v
```

The output can contain information such as:

```text
SELinux status
Current mode
Configured mode
Policy
Process contexts
File contexts
```

Do not copy runtime values from the lecture screenshots.

## Runtime and Persistent SELinux State

The current SELinux mode and the configured boot-time mode are different concepts.

```text
Current Runtime State
→ getenforce
→ setenforce


Persistent Configuration
→ /etc/selinux/config
```

This is another example of the general Linux administration principle:

```text
Runtime State
!=
Persistent Configuration
```

## Temporarily Enter Permissive Mode

The course demonstrates:

```bash
sudo setenforce 0
```

Verify:

```bash
getenforce
```

The expected mode is:

```text
Permissive
```

This changes the runtime enforcement state.

## Return to Enforcing Mode

After the troubleshooting test, return to enforcing mode.

```bash
sudo setenforce 1
```

Verify:

```bash
getenforce
```

Do not leave the lab VM in permissive mode unintentionally.

## Security Context Overview

SELinux assigns security contexts to subjects and objects.

Examples include:

```text
Processes
Users
Files
Directories
```

A context can be represented conceptually as:

```text
SELinux User
:
Role
:
Type
:
Level
```

Example structure:

```text
system_u:system_r:httpd_t:s0
```

The exact values depend on the current system and policy.

## SELinux Type

The type field is particularly important in the targeted-policy examples used in this course.

Examples shown by the course include:

```text
httpd_t
squid_t
httpd_sys_content_t
selinux_config_t
```

Conceptually:

```text
Process Type
      |
      v
SELinux Policy
      |
      v
Object Type
```

The policy determines which interactions are allowed.

## Inspect Process Contexts

The course demonstrates SELinux-aware process output.

Example:

```bash
ps axZ
```

Search for a process when appropriate:

```bash
ps axZ | grep PROCESS_NAME
```

For Apache, the course also uses:

```bash
ps -efZ | grep httpd
```

If Apache is installed and running in the current lab environment, inspect its real process context.

Do not fabricate the process context if the service is not installed.

## Inspect the Current User Context

Use:

```bash
id -Z
```

The command displays the current SELinux security context.

The lecture shows SELinux user, role, type, and MLS/MCS information.

Record only the actual value from the current VM.

## Inspect File and Directory Contexts

Use:

```bash
ls -lZ PATH
```

To inspect the directory object itself:

```bash
ls -lZd PATH
```

For example, if Apache content exists:

```bash
ls -lZd /var/www/html
```

The course shows a web-content type such as:

```text
httpd_sys_content_t
```

The actual context must be verified on the current VM.

## Process and File Context Relationship

A service-access problem should consider both sides of the request.

```text
Process
httpd_t
   |
   v
SELinux Policy
   |
   v
File / Directory
httpd_sys_content_t
```

If the object type does not match the intended policy, the operation can fail even when DAC permissions appear correct.

## SELinux Troubleshooting Layers

When a process cannot access a file:

```text
Access Failure
      |
      v
Check Traditional Permissions
      |
      v
Check Process SELinux Context
      |
      v
Check File SELinux Context
      |
      v
Check Relevant SELinux Boolean
      |
      v
Inspect SELinux Denial Evidence
      |
      v
Apply the Smallest Required Change
      |
      v
Verify in Enforcing Mode
```

## SELinux Boolean Overview

SELinux Booleans allow selected policy behavior to be enabled or disabled without replacing the entire policy.

Conceptually:

```text
SELinux Policy
      |
      +-- Feature A: on/off
      +-- Feature B: on/off
      +-- Feature C: on/off
```

## List SELinux Booleans

The course uses:

```bash
semanage boolean -l
```

The output can contain:

```text
Boolean name
Current state
Default state
Description
```

The actual list depends on the installed SELinux policy.

## Filter Booleans

The course demonstrates FTP-related Boolean filtering.

```bash
semanage boolean -l | grep ftpd
```

Possible names depend on the current policy version.

Do not assume that every Boolean shown in the lecture exists on the current Rocky Linux VM.

## Inspect a Specific Boolean

The course example uses:

```bash
getsebool ftp_home_dir
```

The lecture environment shows the Boolean changing from `off` to `on`.

The current VM can differ.

## Persistently Enable a Boolean

The course demonstrates:

```bash
sudo setsebool -P ftp_home_dir on
```

Verify:

```bash
getsebool ftp_home_dir
```

The `-P` option makes the policy Boolean change persistent.

Only change a Boolean when the application requirement and security impact are understood.

## Boolean and Context Are Different

```text
Security Context
→ Identifies the SELinux label associated with a subject or object


Boolean
→ Enables or disables a predefined policy behavior
```

A troubleshooting process should identify which type of policy issue exists rather than applying unrelated changes.

## Inspect SELinux Users

The course demonstrates:

```bash
semanage user -l
```

The output can contain SELinux users such as:

```text
guest_u
root
staff_u
sysadm_u
system_u
unconfined_u
user_u
xguest_u
```

The lecture also displays information such as:

```text
MLS/MCS level
MLS/MCS range
SELinux roles
```

The exact values depend on the current policy.

This lab focuses on inspecting these relationships rather than modifying SELinux user mappings.

## Apache Context Example

The course uses Apache to demonstrate process and content contexts.

Inspect the content directory if it exists:

```bash
ls -lZd /var/www/html
```

Inspect Apache processes if the service is installed and running:

```bash
ps -efZ | grep httpd
```

The course demonstrates the conceptual relationship:

```text
httpd process
→ httpd_t

Web content
→ httpd_sys_content_t
```

## Custom Web Content Context

The course provides an example for user-hosted web content:

```bash
chcon -R -t httpd_user_content_t /home/user1/public_html
```

This example should be understood as a context-management demonstration.

Do not run it unless the directory exists specifically for the lab and the intended SELinux policy requires that type.

## `chcon`

`chcon` directly changes the SELinux context on an object.

Conceptually:

```text
Current File Label
      |
      v
chcon
      |
      v
New File Label
```

A direct `chcon` change should not automatically be treated as the permanent policy definition for that path.

## Inspect File Context Rules

The course introduces:

```bash
semanage fcontext -l
```

This displays file-context definitions known to SELinux policy.

## Add a Persistent File Context Rule

The course example is:

```bash
sudo semanage fcontext -a -t public_content_t '/home/share(/.*)?'
```

Conceptually:

```text
/home/share
and its contents
        |
        v
SELinux File Context Rule
        |
        v
public_content_t
```

The exact type used for a real service must match the intended security policy.

## Apply the File Context Rule

The course then uses:

```bash
sudo restorecon -RFvv /home/share
```

Conceptually:

```text
semanage fcontext
→ Define the expected label

restorecon
→ Apply the expected label to files and directories
```

Verify afterward:

```bash
ls -lZd /home/share
```

and, when required:

```bash
ls -lZR /home/share
```

## `chcon` and `semanage fcontext`

These operations serve different administrative purposes.

```text
chcon
→ Directly change the current context


semanage fcontext
→ Define the expected context for a path


restorecon
→ Apply or restore the policy-defined context
```

For a path that must maintain a defined label, the file-context rule and `restorecon` workflow provides a policy-based approach.

## SELinux Troubleshooting Tools

The final course slide introduces SELinux troubleshooting with the `setroubleshoot` package.

The lecture does not specify the exact installation package command in this section.

Do not invent a package name as if it were explicitly provided by the course.

## Follow SELinux-Related Log Activity

The course demonstrates:

```bash
sudo tail -f /var/log/messages
```

The exact SELinux logging path available can depend on the current Rocky Linux configuration.

Use the actual available log source in the current VM.

## Analyze an SELinux Alert

The course introduces a command structure such as:

```bash
sealert -l ALERT_ID
```

This is used to inspect detailed information associated with a recorded SELinux alert.

Use an actual alert identifier generated by the lab environment.

Never fabricate an alert ID.

## Troubleshooting Example

A useful SELinux incident model is:

```text
Application Cannot Read a File
          |
          v
Check Application State
          |
          v
Check chmod / chown
          |
          v
Permissions Look Correct
          |
          v
Check SELinux Mode
          |
          v
Check Process Context
          |
          v
Check File Context
          |
          v
Inspect Policy / Boolean / Logs
          |
          v
Correct the Required SELinux Setting
          |
          v
Test Again in Enforcing Mode
```

## Why Disabling SELinux Is Not the Fix

A temporary permissive-mode test can provide diagnostic evidence.

For example:

```text
Enforcing
→ Operation fails

Permissive
→ Operation succeeds
```

This suggests that SELinux may be involved.

However:

```text
setenforce 0
```

does not identify the root cause.

The actual issue can involve:

```text
Incorrect file context
Incorrect process/object relationship
Disabled required Boolean
Another SELinux policy restriction
```

The final state should be verified with SELinux enforcing the intended policy.

## SELinux Incident Verification

After correcting an SELinux issue, verify all relevant layers.

```text
Application running?
        |
        v
DAC permissions correct?
        |
        v
Process context correct?
        |
        v
File context correct?
        |
        v
Required Boolean correct?
        |
        v
No relevant denial remains?
        |
        v
Application succeeds in Enforcing mode?
```

## Verification Checklist

- SELinux and traditional DAC permissions were distinguished.
- Enforcing, Permissive, and Disabled modes were understood.
- The persistent SELinux configuration file was inspected.
- The current SELinux mode was inspected with `getenforce`.
- Detailed SELinux state was inspected with `sestatus`.
- Runtime and persistent SELinux state were distinguished.
- A temporary permissive-mode test was reviewed or performed safely.
- SELinux user, role, type, and level fields were reviewed.
- Process contexts were inspected.
- User context was inspected with `id -Z`.
- File and directory contexts were inspected with `ls -Z`.
- The relationship between `httpd_t` and web-content contexts was reviewed.
- SELinux Booleans were listed.
- FTP-related Boolean filtering was reviewed.
- `getsebool` and `setsebool -P` were distinguished.
- SELinux users were inspected with `semanage user -l`.
- Direct context changes with `chcon` were reviewed.
- Persistent file-context rules with `semanage fcontext` were reviewed.
- `restorecon` was used or reviewed as the policy-label application step.
- SELinux troubleshooting logs and `sealert` concepts were reviewed.
- SELinux was not disabled merely to bypass a policy problem.
- The final application state was verified under Enforcing mode.

## What I Learned

- SELinux adds Mandatory Access Control on top of traditional Linux permissions.
- A correct Unix permission does not guarantee that SELinux will allow an operation.
- Enforcing mode blocks policy violations.
- Permissive mode records policy violations without enforcing the denial.
- SELinux runtime mode and persistent configuration are different.
- Processes, files, directories, and users can have SELinux security contexts.
- The SELinux type field is a key part of targeted-policy access control.
- `ps` with SELinux context output can identify process types.
- `ls -Z` displays filesystem security contexts.
- `id -Z` displays the current SELinux user context.
- SELinux Booleans provide predefined switches for selected policy behavior.
- `getsebool` inspects a Boolean and `setsebool -P` can persistently modify it.
- `chcon` directly changes an object's current context.
- `semanage fcontext` defines file-context rules.
- `restorecon` applies the context expected by SELinux policy.
- SELinux troubleshooting should use evidence from contexts, policy settings, and logs instead of immediately disabling SELinux.
- A successful fix should be verified while SELinux is enforcing the intended policy.
