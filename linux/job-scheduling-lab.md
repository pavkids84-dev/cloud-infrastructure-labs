# Linux Time and Job Scheduling Lab

## Objective

Practice Linux time management, NTP synchronization, and job scheduling on Rocky Linux.

The goal of this lab is to understand how system time is inspected and synchronized, how one-time and recurring jobs are scheduled, and how Linux scheduling services and configuration files are connected.

## Environment

- OS: Rocky Linux
- Shell: Bash
- Init System: systemd
- Time Synchronization: Chrony
- Privilege: root or sudo-enabled user

## System Time Overview

Linux systems maintain several time-related values.

```text
Local Time
→ Time displayed using the configured time zone

Universal Time
→ UTC-based system time

RTC Time
→ Hardware real-time clock

Time Zone
→ Regional time configuration
```

Accurate time is important for:

```text
Log correlation
Authentication records
Scheduled jobs
Service events
Troubleshooting
```

## Inspect System Time

Display the current time configuration.

```bash
timedatectl
```

Inspect fields such as:

```text
Local time
Universal time
RTC time
Time zone
System clock synchronized
NTP service
RTC in local TZ
```

## Inspect Available Time Zones

List available time zones.

```bash
timedatectl list-timezones
```

The command displays time-zone identifiers that can be used by the system.

## Network Time Protocol

NTP is used to synchronize clocks between systems.

```text
Time Source
    |
    v
NTP Protocol
    |
    v
Linux Server
```

Time synchronization helps multiple systems use a consistent time reference.

## Chrony Overview

Rocky Linux can use Chrony for NTP synchronization.

The main components are:

```text
chronyd
→ Time-synchronization daemon

chronyc
→ Command-line interface for inspecting and controlling Chrony

/etc/chrony.conf
→ Chrony configuration
```

## Inspect Chrony Configuration

Display the Chrony configuration.

```bash
cat /etc/chrony.conf
```

Look for configured time sources.

Depending on the installed Rocky Linux version and configuration, the exact source entries may differ.

## Inspect the Chrony Service

Check the Chrony service.

```bash
systemctl status chronyd
```

Check whether it is configured for automatic startup.

```bash
systemctl is-enabled chronyd
```

## Inspect NTP Sources

Display Chrony's configured and reachable time sources.

```bash
chronyc sources
```

Display a more detailed view.

```bash
chronyc sources -v
```

The exact servers and values depend on the current network and system configuration.

## Immediate Chrony Synchronization

Chrony can be requested to step the system clock when immediate correction is required.

```bash
sudo chronyc makestep
```

This command changes system time and should be used intentionally.

Verify the time state afterward.

```bash
timedatectl
```

## Time Synchronization Workflow

```text
Inspect Time
     |
     v
timedatectl
     |
     v
Inspect chronyd
     |
     v
systemctl status chronyd
     |
     v
Inspect Time Sources
     |
     v
chronyc sources -v
     |
     v
Verify Synchronization
```

## Job Scheduling Overview

Linux provides several job-scheduling mechanisms.

```text
One-Time Jobs
├── at
└── batch

Recurring Jobs
├── cron
└── anacron
```

Their general purposes are:

```text
at
→ Run once at a specified time

batch
→ Run once when system load permits

cron
→ Run repeatedly according to a schedule

anacron
→ Handle periodic jobs that may have been missed
```

## Inspect Scheduling Services

The `at` and `batch` commands are associated with the `atd` service.

Check the service.

```bash
systemctl status atd
```

Inspect its process when available.

```bash
ps -ef | grep atd
```

Cron jobs are processed by `crond`.

```bash
systemctl status crond
```

Inspect the process.

```bash
ps -ef | grep crond
```

## Inspect Scheduling Packages

Check whether the `at` package is installed.

```bash
rpm -q at
```

Check the cron package available on the system.

```bash
rpm -qa | grep cron
```

The exact package names depend on the installed system.

## Schedule a One-Time Job with `at`

The `at` command schedules a command for one-time execution.

Example:

```bash
at now + 2 minutes
```

At the `at>` prompt, enter a safe test command.

```text
echo "at job completed" > /tmp/at-job-result.txt
```

Finish the job input with:

```text
Ctrl+D
```

## Inspect the `at` Queue

List scheduled jobs.

```bash
atq
```

An alternative form is:

```bash
at -l
```

Each scheduled job has a job ID.

## Inspect an `at` Job

Display the contents of a scheduled job.

```bash
at -c JOB_ID
```

Replace `JOB_ID` with an ID returned by `atq`.

## Remove an `at` Job

Cancel a scheduled job.

```bash
atrm JOB_ID
```

Verify that it was removed.

```bash
atq
```

## Verify an Executed `at` Job

If the test job was allowed to run, verify its result.

```bash
cat /tmp/at-job-result.txt
```

Remove the temporary file after verification.

```bash
rm -f /tmp/at-job-result.txt
```

## `at` Workflow

```text
Schedule Job
     |
     v
at
     |
     v
Inspect Queue
     |
     v
atq
     |
     +------------------+
     |                  |
     v                  v
Wait for Execution    Cancel
     |                  |
     v                  v
Verify Result          atrm
```

## Batch Jobs

`batch` also creates one-time jobs.

Unlike `at`, the job is intended to run when system load permits.

Start a batch job.

```bash
batch
```

At the prompt, a command can be entered.

Example:

```text
echo "batch job completed" > /tmp/batch-job-result.txt
```

Finish with:

```text
Ctrl+D
```

Inspect the queue.

```bash
atq
```

A batch job can also be removed using its job ID.

```bash
atrm JOB_ID
```

The exact execution time of a batch job should not be assumed because it depends on scheduling conditions.

## `at` and `batch` Comparison

```text
at
→ One-time execution
→ User specifies a time

batch
→ One-time execution
→ Execution depends on system scheduling conditions
```

## Cron Overview

Cron is used for recurring scheduled jobs.

The cron daemon is:

```text
crond
```

Check its status.

```bash
systemctl status crond
```

## Inspect the System Crontab

Display the system-wide crontab.

```bash
cat /etc/crontab
```

The file can contain environment settings such as:

```text
SHELL
PATH
MAILTO
```

A system crontab job uses the following general structure:

```text
minute hour day-of-month month day-of-week user command
```

## Cron Time Fields

```text
Minute
→ 0-59

Hour
→ 0-23

Day of Month
→ 1-31

Month
→ 1-12

Day of Week
→ 0-6
```

The `*` character represents all applicable values in a field.

## System Crontab vs User Crontab

The system-wide `/etc/crontab` includes a user field.

```text
minute hour day month weekday user command
```

A user's own crontab already has an execution identity and therefore uses:

```text
minute hour day month weekday command
```

This distinction is important when reading or creating cron entries.

## Inspect the Current User Crontab

List the current user's cron jobs.

```bash
crontab -l
```

If no crontab exists, the command may report that no crontab is configured.

## Edit the Current User Crontab

The current user's recurring jobs can be edited with:

```bash
crontab -e
```

Do not create a recurring test job unless it can be safely identified, verified, and removed after the lab.

## Inspect Cron Directories

List cron-related files and directories.

```bash
ls /etc/cron*
```

Common directories can include:

```text
/etc/cron.d/
/etc/cron.hourly/
/etc/cron.daily/
/etc/cron.weekly/
/etc/cron.monthly/
```

Inspect them individually when available.

```bash
ls /etc/cron.hourly/
```

```bash
ls /etc/cron.daily/
```

```bash
ls /etc/cron.weekly/
```

```bash
ls /etc/cron.monthly/
```

## Anacron Overview

Cron jobs can be missed when a system is unavailable at the scheduled time.

Anacron provides a mechanism for periodic jobs to be performed later.

```text
Recurring Job
     |
     v
Scheduled Period Arrives
     |
     v
System Unavailable
     |
     v
Job Missed
     |
     v
Anacron
     |
     v
Job Executed Later
```

## Inspect Anacron Configuration

Display the Anacron configuration.

```bash
cat /etc/anacrontab
```

The file can contain settings such as:

```text
RANDOM_DELAY
START_HOURS_RANGE
```

A job entry follows the general structure:

```text
period-in-days delay-in-minutes job-identifier command
```

## Anacron Entry Concept

An Anacron entry contains:

```text
Period
→ How often the job should run

Delay
→ Delay before execution

Job Identifier
→ Name used to identify the job

Command
→ Command that is executed
```

The exact entries depend on the installed system.

## Inspect Anacron and Cron Integration

Inspect the hourly directory.

```bash
ls /etc/cron.hourly/
```

Inspect the periodic directories.

```bash
ls /etc/cron.daily/
```

```bash
ls /etc/cron.weekly/
```

```bash
ls /etc/cron.monthly/
```

This helps visualize how recurring system jobs are organized.

## Cron and Anacron Comparison

```text
cron
→ Executes jobs according to a time schedule

anacron
→ Helps run periodic jobs that were missed
```

Anacron is especially useful for systems that are not guaranteed to remain powered on continuously.

## Scheduling Access Control

Linux can provide access-control files for scheduling commands.

Cron-related files can include:

```text
/etc/cron.allow
/etc/cron.deny
```

At-related files can include:

```text
/etc/at.allow
/etc/at.deny
```

These files are used to control which users can access scheduling facilities.

Inspect files that exist on the current system.

```bash
ls -l /etc/cron.allow /etc/cron.deny 2>/dev/null
```

```bash
ls -l /etc/at.allow /etc/at.deny 2>/dev/null
```

The precise access-control behavior should be verified using the manual pages on the current system.

```bash
man crontab
```

```bash
man at
```

## Cron Mail Concept

Cron can send command output through the system mail mechanism.

The system crontab can include:

```text
MAILTO=root
```

This associates job output with a mail recipient.

Mail-related tools can include:

```text
mail
mailx
```

Actual mail delivery depends on the system's mail configuration.

## Scheduling Comparison

```text
at
     |
     └── One-time job at a specified time

batch
     |
     └── One-time job when system load permits

cron
     |
     └── Recurring time-based jobs

anacron
     |
     └── Recovery of missed periodic jobs
```

## Scheduling Troubleshooting Workflow

When a scheduled job does not run:

```text
Scheduled Job Failed
        |
        v
Check System Time
        |
        v
timedatectl
        |
        v
Check Scheduling Service
        |
        v
systemctl status atd / crond
        |
        v
Check Job Registration
        |
        v
atq / crontab
        |
        v
Check Schedule Definition
        |
        v
Check Scheduling Access
        |
        v
allow / deny files
        |
        v
Check Whether Periodic Job Was Missed
        |
        v
anacron configuration
```

## Verification Checklist

- System time information was inspected with `timedatectl`.
- Available time zones were inspected.
- The `chronyd` service was inspected.
- Chrony time sources were inspected.
- The relationship between `chronyd` and `chronyc` was understood.
- The `atd` and `crond` services were inspected.
- A one-time `at` job was scheduled or its workflow was reviewed.
- The `at` queue and job-management commands were inspected.
- `at` and `batch` were compared.
- `/etc/crontab` was inspected.
- Cron time fields were interpreted.
- System and user crontab formats were distinguished.
- Cron directories were inspected.
- `/etc/anacrontab` was inspected.
- Cron and Anacron behavior was compared.
- Scheduling access-control files were identified.
- Scheduling troubleshooting was connected to time, services, jobs, and permissions.

## What I Learned

- Accurate system time is important for Linux operations and troubleshooting.
- `timedatectl` displays system time, UTC, RTC, time-zone, and synchronization information.
- NTP synchronizes clocks between systems.
- `chronyd` performs Chrony time synchronization.
- `chronyc` is used to inspect and control Chrony.
- `/etc/chrony.conf` defines Chrony configuration and time sources.
- `at` schedules a one-time job for a specified time.
- `batch` schedules a one-time job based on system scheduling conditions.
- `atq` lists queued jobs and `atrm` removes them.
- Cron provides recurring time-based job scheduling.
- `/etc/crontab` includes the execution user field, while a user's crontab does not.
- Cron schedules use minute, hour, day-of-month, month, and day-of-week fields.
- `crond` processes cron scheduling.
- Anacron helps execute periodic jobs that were missed while a system was unavailable.
- `/etc/anacrontab` defines period, delay, job identifier, and command information.
- Cron and at can use allow/deny files for scheduling access control.
- Troubleshooting scheduled jobs requires checking system time, daemon state, job registration, schedule definitions, and access control.
