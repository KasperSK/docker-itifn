#!/bin/sh
sysctl -w net.ipv6.conf.all.autoconf=0 > /dev/null
sysctl -w net.ipv6.conf.all.dad_transmits=0 > /dev/null
sysctl -w net.ipv6.conf.all.accept_ra=0 > /dev/null
sysctl -w net.ipv6.conf.all.router_solicitations=0 > /dev/null

sysctl -w net.ipv6.conf.default.autoconf=0 > /dev/null
sysctl -w net.ipv6.conf.default.dad_transmits=0 > /dev/null
sysctl -w net.ipv6.conf.default.accept_ra=0 > /dev/null
sysctl -w net.ipv6.conf.default.router_solicitations=0 > /dev/null

sysctl -w net.ipv6.conf.lo.autoconf=0 > /dev/null
sysctl -w net.ipv6.conf.lo.dad_transmits=0 > /dev/null
sysctl -w net.ipv6.conf.lo.accept_ra=0 > /dev/null
sysctl -w net.ipv6.conf.lo.router_solicitations=0 > /dev/null

sysctl -w net.ipv6.conf.eth0.autoconf=0 > /dev/null
sysctl -w net.ipv6.conf.eth0.dad_transmits=0 > /dev/null
sysctl -w net.ipv6.conf.eth0.accept_ra=0 > /dev/null
sysctl -w net.ipv6.conf.eth0.router_solicitations=0 > /dev/null

sysctl -w net.ipv6.conf.eth1.autoconf=0 > /dev/null
sysctl -w net.ipv6.conf.eth1.dad_transmits=0 > /dev/null
sysctl -w net.ipv6.conf.eth1.accept_ra=0 > /dev/null
sysctl -w net.ipv6.conf.eth1.router_solicitations=0 > /dev/null

sysctl -w net.ipv6.conf.eth2.autoconf=0 > /dev/null
sysctl -w net.ipv6.conf.eth2.dad_transmits=0 > /dev/null
sysctl -w net.ipv6.conf.eth2.accept_ra=0 > /dev/null
sysctl -w net.ipv6.conf.eth2.router_solicitations=0 > /dev/null

sysctl -w net.ipv6.conf.eth3.autoconf=0 > /dev/null
sysctl -w net.ipv6.conf.eth3.dad_transmits=0 > /dev/null
sysctl -w net.ipv6.conf.eth3.accept_ra=0 > /dev/null
sysctl -w net.ipv6.conf.eth3.router_solicitations=0 > /dev/null

/usr/sbin/zebra -d
/usr/sbin/ospfd -d
/usr/sbin/bgpd -d

vtysh
