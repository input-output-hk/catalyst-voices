#!/bin/bash
# Runs scylla node in the background
scylla --options-file /etc/scylla/scylla.yaml --smp 2 --memory 4G --overprovisioned --default-log-level error &