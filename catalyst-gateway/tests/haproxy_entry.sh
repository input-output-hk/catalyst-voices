#!/bin/sh
mkdir -p /var/run/haproxy
chown -R haproxy:haproxy /var/run/haproxy
exec su-exec haproxy haproxy -f /usr/local/etc/haproxy/haproxy.cfg
ń
