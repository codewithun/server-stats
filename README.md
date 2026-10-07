# Server Stats

A simple Bash script for analyzing basic server performance statistics on Linux systems.

This project was created as part of the [roadmap.sh Server Stats project](https://roadmap.sh/projects/server-stats).

## Features

The script provides the following information:

* Operating system
* Server uptime
* Load average
* Logged-in users
* Total CPU usage
* Total memory usage
* Free and used memory
* Memory usage percentage
* Disk usage
* Free and used disk space
* Top 5 processes by CPU usage
* Top 5 processes by memory usage

## Requirements

The script requires:

* Linux operating system
* Bash
* `top`
* `free`
* `df`
* `ps`
* `awk`
* `grep`
* `cut`
* `tr`
* `uptime`
* `who`

Most of these commands are available by default on common Linux distributions such as Ubuntu, Debian, Fedora, and CentOS.

## Installation

Clone the repository:

```bash
git clone https://github.com/YOUR_USERNAME/server-stats.git
```

Move into the project directory:

```bash
cd server-stats
```

Make the script executable:

```bash
chmod +x server-stats.sh
```

Run the script:

```bash
./server-stats.sh
```

You can also run it directly with Bash:

```bash
bash server-stats.sh
```

## Example Output

```text
========================================
        SERVER PERFORMANCE STATS
========================================

OS             : Ubuntu 24.04.3 LTS
Uptime         : up 2 hours, 31 minutes
Load Average   : 0.15, 0.20, 0.18
Logged In Users: 1

----------------------------------------
CPU USAGE
----------------------------------------
Total CPU Usage: 12.4%

----------------------------------------
MEMORY USAGE
----------------------------------------
Total: 7.7 GB
Used : 3.1 GB
Free : 4.6 GB
Usage: 40.2%

----------------------------------------
DISK USAGE
----------------------------------------
Filesystem: /dev/sda1
Total     : 100G
Used      : 28G
Free      : 72G
Usage     : 28%

----------------------------------------
TOP 5 PROCESSES BY CPU
----------------------------------------
PID      USER         CPU%     MEM%     COMMAND
1234     user         25.3     2.1      node
1523     user         12.8     4.3      chrome
...

----------------------------------------
TOP 5 PROCESSES BY MEMORY
----------------------------------------
PID      USER         CPU%     MEM%     COMMAND
1523     user         4.2      8.5      chrome
1234     user         25.3     2.1      node
...

========================================
          END OF SERVER STATS
========================================
```

## How It Works

### 1. Check the operating system

The script checks whether it is running on Linux:

```bash
if [[ "$OSTYPE" != "linux-gnu"* ]]; then
```

This prevents the script from running on unsupported operating systems.

### 2. Get OS information

```bash
grep '^PRETTY_NAME=' /etc/os-release
```

`/etc/os-release` contains information about the Linux distribution.

`grep` searches for the `PRETTY_NAME` field.

`cut` removes the `PRETTY_NAME=` part:

```bash
cut -d= -f2
```

`tr -d '"'` removes quotation marks.

### 3. Check server uptime

```bash
uptime -p
```

The `uptime` command shows how long the server has been running.

The `-p` option displays the result in a human-readable format.

Example:

```text
up 2 hours, 31 minutes
```

### 4. Check load average

```bash
uptime | awk -F'load average:' '{print $2}'
```

`uptime` provides the load average.

`awk` extracts the part after `load average:`.

The result usually contains three values:

```text
1 minute, 5 minutes, 15 minutes
```

Load average helps indicate how much work the system is processing.

### 5. Check logged-in users

```bash
who | wc -l
```

`who` lists users currently logged into the server.

`wc -l` counts the number of lines.

Therefore, the command gives the number of logged-in sessions.

### 6. Calculate CPU usage

```bash
top -bn1
```

`top` provides real-time system and process information.

The options mean:

* `-b` = batch mode
* `-n1` = perform one iteration

The script extracts CPU idle percentage and calculates:

```text
CPU Usage = 100 - CPU Idle
```

This allows the script to report total CPU usage.

### 7. Check memory usage

```bash
free -m
```

The `free` command displays RAM usage.

The `-m` option displays values in megabytes.

The script uses `awk` to calculate:

```text
Memory Usage % = Used Memory / Total Memory × 100
```

The output includes:

* Total memory
* Used memory
* Free memory
* Usage percentage

### 8. Check disk usage

```bash
df -h /
```

`df` reports filesystem disk usage.

The `-h` option makes the values human-readable.

The script checks the root filesystem `/`.

The output includes:

* Total disk space
* Used disk space
* Free disk space
* Usage percentage

### 9. Find processes using the most CPU

```bash
ps -eo pid,user,%cpu,%mem,comm --sort=-%cpu
```

`ps` displays information about running processes.

The options specify:

* `pid` = process ID
* `user` = process owner
* `%cpu` = CPU usage
* `%mem` = memory usage
* `comm` = command/process name

The following option sorts processes by CPU usage:

```bash
--sort=-%cpu
```

The `-` means descending order.

The script then selects the first five processes.

### 10. Find processes using the most memory

The script uses:

```bash
ps -eo pid,user,%cpu,%mem,comm --sort=-%mem
```

This is similar to the CPU command, but processes are sorted by memory usage instead.

The first five processes are displayed.

## Commands Used

| Command  | Purpose                        |
| -------- | ------------------------------ |
| `bash`   | Execute the shell script       |
| `top`    | Monitor CPU and processes      |
| `free`   | Check memory usage             |
| `df`     | Check disk usage               |
| `ps`     | Display running processes      |
| `awk`    | Process and extract text/data  |
| `grep`   | Search for specific text       |
| `cut`    | Extract specific fields        |
| `tr`     | Transform or remove characters |
| `uptime` | Show uptime and load average   |
| `who`    | Show logged-in users           |
| `wc`     | Count lines                    |

## Project Structure

```text
server-stats/
├── server-stats.sh
├── README.md
└── .gitignore
```

## Learning Goals

Through this project, I learned how to:

* Write Bash scripts
* Work with Linux system commands
* Monitor CPU and memory usage
* Analyze disk usage
* Inspect running processes
* Use pipes (`|`) to combine Linux commands
* Process command output using `awk`
* Filter information using `grep`
* Format terminal output
* Work with executable shell scripts

## Roadmap.sh

Project reference:

https://roadmap.sh/projects/server-stats

## License

This project is open source and available for learning purposes.
