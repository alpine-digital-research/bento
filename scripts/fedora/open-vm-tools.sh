#!/bin/sh -eux

# set a default HOME_DIR environment variable if not set
HOME_DIR="${HOME_DIR:-/home/vagrant}";

case "$PACKER_BUILDER_TYPE" in
vmware-iso|vmware-vmx)
    dnf -y install open-vm-tools
    mkdir -p /mnt/hgfs

    rm -f $HOME_DIR/*.iso;
    ;;
esac
