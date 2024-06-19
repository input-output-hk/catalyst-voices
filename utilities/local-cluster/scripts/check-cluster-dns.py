#!/usr/bin/env python3

import socket
import sys


def parse_extra_hostnames(hostnames):
    """
    This function takes a file of hostnames and returns a list of tuples containing the IP address and hostname for each entry.
    The input should be a file with one hostname per line, formatted as "IP_Address Hostname".
    The function will ignore any lines that start with "#" and any extra hostnames on the same line.
    """
    with open(hostnames) as f:
        lines = f.readlines()
        lines = [line.strip() for line in lines]
        lines = [line for line in lines if line != "" and not line.startswith("#")]

    result = []
    for line in lines:
        split = line.split()
        result.append((split[0], split[1]))
    return result


HOSTNAME_SPACE = 27
RESOLVED_IP_SPACE = 15


def status(hostname, resolved_ip, ok):
    print(f"{hostname:<{HOSTNAME_SPACE}} : {resolved_ip:>{RESOLVED_IP_SPACE}} : {ok}")


def check_hostname(hostname, ip):
    # Check the hostname resolves to the expected IP
    ok = "OK"
    try:
        resolved_ip = socket.gethostbyname(hostname)
        if resolved_ip != ip:
            ok = f"FAIL. Set `{ip:<{RESOLVED_IP_SPACE}} {hostname:<{HOSTNAME_SPACE}}` in /etc/hosts."
    except socket.error as e:
        resolved_ip = "None"
        ok = f"FAIL. Add `{ip:<{RESOLVED_IP_SPACE}} {hostname:<{HOSTNAME_SPACE}}` to /etc/hosts"

    status(hostname, resolved_ip, ok)

    return ok == "OK"


everything_ok = True

extra_hosts = parse_extra_hostnames(sys.argv[1])

status("HOSTNAME", "RESOLVED IP", "STATUS")
status("-" * HOSTNAME_SPACE, "-" * RESOLVED_IP_SPACE, "------")

for host in extra_hosts:
    everything_ok = check_hostname(host[1], host[0]) and everything_ok

if not everything_ok:
    sys.exit(1)
sys.exit(0)
