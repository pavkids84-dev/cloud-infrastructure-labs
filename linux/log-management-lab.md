# Linux Log Management Lab

## Objective

Practice Linux log management and troubleshooting with rsyslog, systemd-journald, journalctl, logger, and logrotate.

The goal of this lab is to understand how Linux logs are collected, classified, stored, filtered, monitored, and rotated, and to use logs as evidence during infrastructure troubleshooting.

## Environment

- OS: Rocky Linux
- Shell: Bash
- Traditional Logging: rsyslog
- Journal Service: systemd-journald
- Journal Query Tool: journalctl
- Log Rotation: logrotate
- Privilege: root or sudo-enabled user

## Logging Overview

The course introduces two major Linux logging components.

```text
rsyslog
→ Rule-based log processing
→ /etc/rsyslog.conf


systemd-journald
→ systemd journal collection
→ journalctl for log queries
```

A simplified logging flow is:

```text
Applications / Kernel / Services
             |
             v
      systemd-journald
             |
             v
           Journal
             |
             +--------> journalctl
             |
             v
          rsyslog
             |
             +--------> /var/log/messages
             +--------> /var/log/secure
             +--------> Other destinations
```

The exact logging flow depends on the system configuration.

## rsyslog Configuration

The main rsyslog configuration introduced in the course is:

```text
/etc/rsyslog.conf
```

Inspect the configuration.

```bash
sudo less /etc/rsyslog.conf
```

Do not modify the configuration before understanding the existing rules.

## rsyslog Rule Concept

A common rsyslog rule can be understood as:

```text
Facility.Priority        Destination
```

Conceptually:

```text
What generated the log?
        +
How important is the log?
        |
        v
Where should it be written?
```

The course includes rules similar to:

```text
*.info;mail.none;authpriv.none;cron.none    /var/log/messages
```

and:

```text
authpriv.*                                  /var/log/secure
```

## Important Log Files

The course introduces the following log files:

```text
/var/log/messages
/var/log/secure
/var/log/maillog
/var/log/cron
/var/log/boot.log
```

Conceptually:

```text
/var/log/messages
→ General system messages

/var/log/secure
→ Authentication and security messages

/var/log/maillog
→ Mail-related messages

/var/log/cron
→ Scheduled-job messages

/var/log/boot.log
→ Boot-related messages
```

The exact files available can depend on the system configuration.

## Monitor Authentication Logs

The course monitors authentication activity with:

```bash
sudo tail -f /var/log/secure
```

Log entries can contain information related to:

```text
sshd
PAM
sudo
Session creation
Authentication
```

Do not copy course IP addresses, usernames, PIDs, or timestamps into documentation as if they were produced by the current VM.

## Follow a Log File

The `-f` option follows new log entries as they are appended.

```bash
tail -f FILE
```

A useful troubleshooting pattern is:

```text
Terminal 1
---------
tail -f LOG_FILE


Terminal 2
---------
Reproduce the event


Terminal 1
---------
Observe the new log evidence
```

## Syslog Facility

A facility identifies the subsystem or category associated with a syslog message.

Facilities introduced in the course include:

```text
kern
user
mail
daemon
auth
syslog
lpr
news
uucp
cron
authpriv
ftp
ntp
security
console
solaris-cron
local0 through local7
```

The course facility table associates them with categories such as:

```text
kern
→ Kernel messages

user
→ User-level messages

mail
→ Mail system

daemon
→ System daemons

auth / authpriv
→ Authentication and security

cron
→ Cron subsystem

ftp
→ FTP daemon

ntp
→ NTP subsystem

local0 - local7
→ Locally used facilities
```

## Syslog Severity

The course introduces eight severity levels.

```text
Value   Keyword     Severity

0       emerg       Emergency
1       alert       Alert
2       crit        Critical
3       err         Error
4       warning     Warning
5       notice      Notice
6       info        Informational
7       debug       Debug
```

Lower numeric values represent more severe conditions.

## Facility and Severity Relationship

A syslog selector can combine the two concepts.

Example:

```text
local0.notice
```

means:

```text
Facility
→ local0

Severity
→ notice
```

This combination can then be mapped to a destination through an rsyslog rule.

## Create a Custom rsyslog Rule

The course creates a custom log using the `local0` facility.

Open the rsyslog configuration:

```bash
sudo vi /etc/rsyslog.conf
```

Add the course rule:

```text
local0.notice        /var/log/local0.log
```

This routes matching messages to:

```text
/var/log/local0.log
```

## Create the Custom Log File

Create the destination file.

```bash
sudo touch /var/log/local0.log
```

Restart rsyslog to apply the configuration.

```bash
sudo systemctl restart rsyslog
```

Verify the service state.

```bash
systemctl status rsyslog
```

## Monitor the Custom Log

In one terminal:

```bash
sudo tail -f /var/log/local0.log
```

Leave the command running while generating a test message from another terminal.

## Generate a Test Log with `logger`

In another terminal:

```bash
logger -p local0.notice "This is a test log message."
```

Command components:

```text
logger
→ Generate a log message

-p
→ Specify priority

local0.notice
→ Facility and severity

Message
→ Log content
```

The expected pipeline is:

```text
logger
   |
   v
local0.notice
   |
   v
rsyslog Rule
   |
   v
/var/log/local0.log
```

Verify that the message appears in the monitored log file.

Record only the actual VM output.

## Custom Logging Verification

After the test, verify the end of the log file.

```bash
sudo tail /var/log/local0.log
```

The custom logging exercise demonstrates:

```text
Configure
   |
   v
Restart
   |
   v
Generate Event
   |
   v
Observe Log
   |
   v
Verify
```

## systemd-journald

The course introduces `systemd-journald` as the systemd journal service.

Inspect it.

```bash
systemctl status systemd-journald
```

The output can include information such as:

```text
Loaded state
Active state
Main PID
Runtime journal path
Current service status
```

Runtime values must come from the actual VM.

## Static and Active Unit States

The course screenshot shows `systemd-journald` as both:

```text
static
```

and:

```text
active (running)
```

These describe different properties.

```text
active
→ Current runtime state

static
→ Unit installation configuration characteristic
```

A static unit can still be running as part of system dependencies.

## journalctl Overview

Use:

```bash
journalctl
```

to display systemd journal entries.

The journal can contain messages from:

```text
Kernel
systemd
Services
Applications
```

The output is generally displayed in chronological order.

## Traditional Log Files and Journal

```text
Traditional log files
---------------------
/var/log/messages
/var/log/secure
...
        |
        v
cat / less / grep / tail


systemd journal
---------------
Journal entries
        |
        v
journalctl
```

Both forms can be useful during troubleshooting.

## Inspect the Most Recent Journal Entry

The course uses:

```bash
journalctl -n 1 -o verbose
```

Command components:

```text
-n 1
→ Display one recent journal entry

-o verbose
→ Display detailed journal fields
```

Verbose output can contain structured fields such as:

```text
PRIORITY
SYSLOG_FACILITY
_BOOT_ID
_MACHINE_ID
_HOSTNAME
SYSLOG_IDENTIFIER
_UNIT
_TRANSPORT
_PID
_UID
_GID
_COMM
_EXE
_CMDLINE
_SELINUX_CONTEXT
```

The exact fields depend on the journal entry.

## Structured Journal Metadata

Journal entries contain more than plain message text.

Metadata can identify:

```text
Process
User
Command
Executable
systemd unit
Host
Severity
Boot
Security context
```

This makes journal entries useful for filtered troubleshooting.

## Follow Journal Entries in Real Time

The course uses:

```bash
journalctl -f
```

This follows new journal entries as they are generated.

A useful workflow is:

```text
Terminal 1
---------
journalctl -f


Terminal 2
---------
Reproduce the problem


Terminal 1
---------
Observe new journal entries
```

## `tail -f` and `journalctl -f`

```text
tail -f FILE
→ Follow one text log file

journalctl -f
→ Follow new system journal entries
```

The choice depends on which logging source is being investigated.

## Filter Journal by Priority

The course uses:

```bash
journalctl -p err
```

This filters journal messages using the `err` priority.

The course screenshot displays error messages related to kernel and service activity.

This connects journal filtering with the syslog severity model.

## Filter Journal by Time

The course uses:

```bash
journalctl --since "-5min"
```

This limits the output to a recent time range.

Time filtering is useful when the approximate incident time is known.

Conceptually:

```text
All Logs
   |
   v
Incident Time
   |
   v
Time Filter
   |
   v
Smaller Evidence Set
```

## Filter Journal by Structured Field

The course demonstrates `_COMM`, which identifies a command name associated with a journal entry.

Example:

```bash
journalctl _COMM=sshd
```

This returns entries whose `_COMM` field matches `sshd`.

The output can include events such as:

```text
Server listening
Authentication
Session opened
Session closed
```

depending on the actual VM activity.

## Journal Troubleshooting Strategy

A useful investigation sequence is:

```text
Large Journal
     |
     v
Limit by Incident Time
     |
     v
Limit by Priority
     |
     v
Limit by Process or Structured Field
     |
     v
Inspect Detailed Metadata
```

Relevant course commands include:

```bash
journalctl --since "-5min"
```

```bash
journalctl -p err
```

```bash
journalctl _COMM=sshd
```

```bash
journalctl -n 1 -o verbose
```

## journald Configuration File

The journald configuration file should be understood as:

```text
/etc/systemd/journald.conf
```

The course introduces the `Storage` setting.

Example:

```text
Storage=auto
```

## Journal Storage Modes

The course introduces four storage modes.

```text
persistent
volatile
auto
none
```

### Persistent

```text
Storage=persistent
```

The course associates persistent storage with:

```text
/var/log/journal
```

This allows journal data to be stored on persistent storage.

### Volatile

```text
Storage=volatile
```

The course associates volatile journal data with:

```text
/run/log/journal
```

This is runtime storage.

### Auto

```text
Storage=auto
```

The course describes this as depending on the presence of:

```text
/var/log/journal
```

### None

```text
Storage=none
```

The course lists this as a journal storage mode.

The slide does not provide a detailed hands-on exercise for this mode.

## Persistent and Volatile Journal Comparison

```text
Persistent
-------------------------
/var/log/journal
Disk-backed journal storage
Intended to remain across reboot


Volatile
-------------------------
/run/log/journal
Runtime journal storage
Not intended as persistent history
```

## Create Persistent Journal Storage

The course creates the journal directory with:

```bash
sudo mkdir -m 2775 /var/log/journal
```

The permission value includes:

```text
2
→ SGID

775
→ rwxrwxr-x
```

## Set Journal Directory Ownership

The course uses:

```bash
sudo chown root:systemd-journal /var/log/journal/
```

Verify:

```bash
ls -ld /var/log/journal
```

Do not fabricate the actual owner, group, or permission output.

## Inspect systemd-related Groups

The course uses:

```bash
grep sys /etc/group
```

The screenshot includes groups such as:

```text
systemd-journal
systemd-coredump
systemd-resolve
```

The exact groups and IDs depend on the current VM.

## Restart journald

Restart the journal service after preparing persistent journal storage.

```bash
sudo systemctl restart systemd-journald
```

Verify:

```bash
systemctl status systemd-journald
```

## Verify Persistent Journal Directory

Inspect the directory.

```bash
ls /var/log/journal/
```

The course screenshot shows a machine-specific directory name.

Do not copy that identifier into documentation.

Record only the value generated by the actual lab VM.

## Persistent Journal Workflow

```text
Prepare /var/log/journal
        |
        v
Set Permissions and Ownership
        |
        v
Restart systemd-journald
        |
        v
Inspect /var/log/journal
        |
        v
Verify Journal Storage
```

## logrotate Overview

Log files cannot grow indefinitely.

`logrotate` is used to manage older log files through rotation policies.

Conceptually:

```text
Current Log
    |
    v
Rotation Condition
    |
    v
Old Log Archived
    |
    v
New Current Log
```

## Course logrotate Example

The course displays a sample configuration containing:

```text
compress

/var/log/messages {
    rotate 5
    weekly
    postrotate
        /usr/bin/killall -HUP syslogd
    endscript
}
```

This is presented as a sample configuration rather than a command sequence that should be copied blindly to the current Rocky Linux VM.

## logrotate Options

### `compress`

```text
Compress rotated log files
```

### `rotate 5`

```text
Keep a configured number of rotated logs
```

The sample uses five.

### `weekly`

```text
Rotate according to a weekly schedule
```

### `postrotate`

Defines commands that are executed after rotation.

General structure:

```text
postrotate
    COMMAND
endscript
```

The course sample sends a HUP signal to a logging process.

The correct command depends on the current service configuration.

## Size-Based Rotation

The second course sample contains HTTP server logs and:

```text
size 100k
```

This demonstrates a size-based rotation condition.

## Additional Sample Options

The second course example also introduces:

```text
mail recipient@example.org
sharedscripts
postrotate
endscript
```

These demonstrate additional behavior that can be associated with rotated logs.

The email address in the course is an example and should not be used as a real destination.

## Time-Based and Size-Based Rotation

The course demonstrates different rotation conditions.

```text
weekly
→ Time-based condition

size 100k
→ Size-based condition
```

This allows log retention behavior to be adapted to different log volumes.

## Logging Architecture

A useful overall model is:

```text
Kernel / Application / Service
             |
             v
        Log Message
             |
             v
     systemd-journald
             |
        +----+----+
        |         |
        v         v
     Journal    rsyslog
        |         |
        v         v
  journalctl    /var/log/*
                  |
                  v
               logrotate
```

The exact implementation depends on the system configuration.

## Log Troubleshooting Workflow

When a service fails:

```text
Service Failure
      |
      v
Inspect Current Service State
      |
      v
systemctl status
      |
      v
Identify Relevant Log Source
      |
      +-------------------+
      |                   |
      v                   v
/var/log/...          journalctl
      |                   |
      +---------+---------+
                |
                v
        Limit Evidence
                |
        +-------+-------+
        |       |       |
        v       v       v
       Time   Priority  Process
                |
                v
          Identify Cause
                |
                v
       Apply Controlled Fix
                |
                v
             Verify
```

## SSH Log Investigation Example

When investigating an SSH problem, useful sources introduced in this course include:

```text
/var/log/secure
```

and:

```bash
journalctl _COMM=sshd
```

A troubleshooting process can be:

```text
Check sshd state
      |
      v
Inspect authentication logs
      |
      v
Inspect sshd journal entries
      |
      v
Reproduce the connection problem
      |
      v
Observe new logs
      |
      v
Identify the cause
```

## Verification Checklist

- rsyslog and systemd-journald were distinguished.
- `/etc/rsyslog.conf` was inspected.
- Important `/var/log` files were reviewed.
- `/var/log/secure` was monitored with `tail -f`.
- Syslog Facility was understood.
- Syslog Severity was understood.
- Facility and Severity were combined into a selector.
- A custom `local0.notice` rsyslog rule was configured or reviewed.
- A test log was generated with `logger`.
- The custom log destination was verified.
- `systemd-journald` status was inspected.
- The journal was queried with `journalctl`.
- Detailed journal metadata was inspected with verbose output.
- New journal entries were followed in real time.
- Journal messages were filtered by priority.
- Journal messages were filtered by time.
- Journal entries were filtered with `_COMM`.
- Persistent and volatile journal storage were distinguished.
- `/var/log/journal` storage was configured or reviewed.
- Journal-directory permissions and ownership were inspected.
- `logrotate` concepts were reviewed.
- Time-based and size-based log rotation conditions were distinguished.
- Post-rotation actions were understood as configuration-specific operations.
- Runtime log values were recorded only from the actual lab VM.

## What I Learned

- Linux systems can use both rsyslog and systemd-journald for logging.
- rsyslog processes messages according to configurable rules.
- Syslog Facility identifies the message category or subsystem.
- Syslog Severity represents the importance of a message.
- `local0` through `local7` can be used for locally defined logging.
- `logger` can generate test syslog messages.
- `/var/log/secure` contains authentication-related evidence in the course environment.
- `tail -f` is useful for observing new entries in a text log file.
- `journalctl` queries systemd journal data.
- Journal entries contain structured metadata in addition to human-readable messages.
- `journalctl -f` follows new journal entries.
- Priority, time, and structured fields can reduce a large journal to relevant evidence.
- Persistent journal data is associated with `/var/log/journal`.
- Volatile journal data is associated with `/run/log/journal`.
- `logrotate` prevents traditional log files from growing indefinitely.
- Rotation can be based on time or file size.
- Logging is a primary source of evidence when troubleshooting Linux services.
- Infrastructure changes should follow evidence collection rather than replacing log investigation with immediate restarts or configuration changes.
