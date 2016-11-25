#!/bin/sh
sysctl -w net.ipv6.conf.all.autoconf=0
sysctl -w net.ipv6.conf.all.dad_transmits=0
sysctl -w net.ipv6.conf.all.accept_ra=0
sysctl -w net.ipv6.conf.all.router_solicitations=0
bash
