# Linux Process Management Lab

## Objective

Practice Linux process monitoring, shell job control, process state inspection, and process termination using signals.

## Environment

- OS: Rocky Linux
- Virtualization: VMware
- Shell: Bash
- Access Method: SSH

## Process Concepts

A process is a program currently executing in memory.

Linux process management includes several related concepts:

```text
Program
   |
   v
Process
```

A daemon is a service process that typically runs in the background.

A job is a process managed directly by the current shell.

## Foreground and Background Jobs

Run a command in the background.

```bash
sleep 300 &
```

Display jobs managed by the current shell.

```bash
jobs
```

A command ending with `&` runs as a background job and immediately returns the shell prompt.

## Suspend a Foreground Job

Run a command in the foreground.

```bash
sleep 300
```

Press:

```text
Ctrl+Z
```

Check the job state.

```bash
jobs
```

The foreground job should now be stopped.

## Resume a Job in the Background

Resume the stopped job in the background.

```bash
bg %1
```

Verify the job state.

```bash
jobs
```

## Bring a Job to the Foreground

Move the background job to the foreground.

```bash
fg %1
```

Press `Ctrl+C` to interrupt the foreground process.

## Monitor Processes with ps

Display running processes.

```bash
ps aux | head
```

Important fields include:

```text
USER
PID
%CPU
%MEM
VSZ
RSS
TTY
STAT
START
TIME
COMMAND
```

The most important fields for basic process troubleshooting are `PID`, `%CPU`, `%MEM`, `STAT`, and `COMMAND`.

## Process States

Common Linux process states include:

```text
R = running or runnable
S = interruptible sleep
D = uninterruptible sleep
T = stopped
Z = zombie
```

Process state information can be viewed in the `STAT` field of `ps`.

## Search for Processes

Search for Bash processes.

```bash
pgrep -l bash
```

Search for sleep processes.

```bash
pgrep -l sleep
```

`pgrep` makes it possible to locate process IDs by process name.

## Inspect the Process Tree

Display the parent-child relationship between processes.

```bash
pstree
```

The process tree helps identify how processes are related to each other.

## Real-Time Monitoring with top

Start real-time process monitoring.

```bash
top
```

Useful interactive keys include:

```text
P = sort by CPU usage
M = sort by memory usage
h = help
q = quit
```

Use `top` to observe process activity and system resource usage in real time.

## Linux Signals

Display available Linux signals.

```bash
kill -l
```

Important signals include:

```text
1  = SIGHUP
2  = SIGINT
9  = SIGKILL
15 = SIGTERM
```

`SIGTERM` requests normal process termination, while `SIGKILL` forces a process to terminate.

## Terminate a Test Process

Start a test process.

```bash
sleep 500 &
```

Find its PID.

```bash
pgrep -l sleep
```

Send the default termination signal.

```bash
kill <PID>
```

Verify that the process has terminated.

```bash
pgrep -l sleep
```

## Send a Specific Signal

Start another test process.

```bash
sleep 500 &
```

Find its PID.

```bash
pgrep -l sleep
```

Send `SIGINT`.

```bash
kill -INT <PID>
```

Verify the result.

```bash
pgrep -l sleep
```

## Verification

Verify the following:

- A running program is represented as a process.
- The shell assigns job IDs to jobs that it manages.
- `&` starts a command as a background job.
- `jobs` displays jobs managed by the current shell.
- `Ctrl+Z` suspends a foreground job.
- `bg` resumes a stopped job in the background.
- `fg` moves a job to the foreground.
- `ps` displays process information.
- The `STAT` field represents process state.
- `top` provides real-time process monitoring.
- `pgrep` locates processes by name.
- `pstree` displays parent-child process relationships.
- `kill` sends a signal to a process.
- `SIGTERM` requests normal termination.
- `SIGKILL` forces termination.

## What I Learned

- A process is a program currently executing in memory.
- Daemons are service processes that typically remain active in the background.
- Shell jobs can run in the foreground, background, or stopped state.
- Job IDs and process IDs represent different identifiers.
- Linux provides multiple tools for monitoring processes, including `ps`, `top`, `pgrep`, and `pstree`.
- Process states help explain whether a process is running, waiting, stopped, or terminated.
- Signals provide a mechanism for controlling running processes.
- Process monitoring and signal handling are fundamental skills for Linux server administration and troubleshooting.
