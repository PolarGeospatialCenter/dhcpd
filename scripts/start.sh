#!/bin/sh

confd -onetime

exec /usr/sbin/dhcpd -f
