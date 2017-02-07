#!/bin/bash -x

# locale
localedef -i en_US -c -f UTF-8 en_US.UTF-8
dpkg-reconfigure locales

# timezone
echo "Europe/Zurich" > "/etc/timezone"
dpkg-reconfigure -f noninteractive tzdata

# hostname
echo "DE0-Nano-SoC" > "/etc/hostname"
tee "/etc/hosts" >"/dev/null" <<EOF
127.0.0.1   localhost
127.0.1.1   DE0-Nano-SoC
EOF

# network interfaces
tee "/etc/network/interfaces" > "/dev/null" <<EOF
# interfaces(5) file used by ifup(8) and ifdown(8)

# The loopback network interface
auto lo
iface lo inet loopback

# The primary network interface
auto eth0
iface eth0 inet dhcp
EOF

# DNS
sudo tee "/etc/resolv.conf" > "/dev/null" <<EOF
nameserver 8.8.8.8
EOF

# enable serial console for login shell
tee "/etc/init/ttyS0.conf" > "/dev/null" <<EOF
# ttyS0 - getty
#
# This service maintains a getty on ttyS0

description "Get a getty on ttyS0"

start on runlevel [2345]
stop on runlevel [016]

respawn

exec /sbin/getty -L 115200 ttyS0 vt102
EOF

# create user "sahand" with password "1234"
username="sahand"
password="1234"
# encrypted password (needed for useradd)
encrypted_password="$(perl -e 'printf("%s\n", crypt($ARGV[0], "password"))' "${password}")"
useradd -m -p "${encrypted_password}" -s "/bin/bash" "${username}"

# ubuntu requires the admin to be part of the "adm" and "sudo" groups
addgroup ${username} adm
addgroup ${username} sudo

# set root password to "1234" (needed so we have a password to supply ARM DS-5
# when remote debugging)
echo -e "${password}\n${password}\n" | passwd root

# remove "/rootfs_config.sh" from /etc/rc.local to avoid reconfiguring system on
# next boot
tee "/etc/rc.local" > "/dev/null" <<EOF
#!/bin/sh -e
#
# rc.local
#
# This script is executed at the end of each multiuser runlevel.
# Make sure that the script will "exit 0" on success or any other
# value on error.
#
# In order to enable or disable this script just change the execution
# bits.
#
# By default this script does nothing.

exit 0
EOF
