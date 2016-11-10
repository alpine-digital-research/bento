#!/bin/sh -eux

# Totally wrong place for this, but needed by vmware tools to successfully install.
yum -y install kernel-devel kernel-headers

yum -y update

# Automatic updates to the kernel will cause vmware's tools to fall
# out of currency, so we just preclude that behavior here.
echo 'exclude=kernel' >> /etc/yum.conf

reboot
sleep 60