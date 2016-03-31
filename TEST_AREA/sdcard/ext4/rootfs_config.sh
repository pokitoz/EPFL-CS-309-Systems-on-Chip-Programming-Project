#!/bin/bash

# locale
localedef -i en_US -c -f UTF-8 en_US.UTF-8
dpkg-reconfigure locales

# timezone
echo "Europe/Zurich" > /etc/timezone
dpkg-reconfigure -f noninteractive tzdata

# hostname
echo DE0-Nano-SoC > /etc/hostname
cat <<EOF > /etc/hosts
127.0.0.1   localhost
127.0.1.1   DE0-Nano-SoC
EOF

# apt sources
# uncomment the "deb" lines (no need to uncomment "deb src" lines)
perl -pi -e 's/^#+\s+(deb\s+http)/$1/g' /etc/apt/sources.list

# fstab (boot partition, swap partition)

# network interfaces
cat <<EOF > /etc/network/interfaces
# interfaces(5) file used by ifup(8) and ifdown(8)

# The loopback network interface
auto lo
iface lo inet loopback

# The primary network interface
auto eth0
iface eth0 inet dhcp
EOF

# enable serial console for login shell
cat <<EOF > /etc/init/ttyS0.conf
# ttyS0 - getty
#
# This service maintains a getty on ttyS0

description "Get a getty on ttyS0"

start on runlevel [2345]
stop on runlevel [016]

respawn

exec /sbin/getty -L 115200 ttyS0 vt102
# exec /sbin/getty -l /usr/bin/autologin -n 115200 ttyS0
EOF

# create user account (called "psoc" here)
adduser psoc

# ubuntu requires the admin to be part of the "adm" and "sudo" groups
usermod -aG adm,sudo psoc
