#!/bin/bash

if [ "${ISA}" = "riscv" ]; then
    echo "Disabling cloud-init services"
    # Disable systemd targets for cloud-init that wait for its completion
    systemctl disable cloud-init.target
    systemctl mask cloud-init.target
    if [ -f /etc/netplan/50-cloud-init.yaml ]; then
        mv /etc/netplan/50-cloud-init.yaml /etc/netplan/50-cloud-init.yaml.bak
    elif [ -f /etc/netplan/00-installer-config.yaml ]; then
        mv /etc/netplan/00-installer-config.yaml /etc/netplan/00-installer-config.yaml.bak
        netplan apply
    fi

    # Disable systemd service that waits for network to be online
    systemctl disable systemd-networkd-wait-online.service
    systemctl mask systemd-networkd-wait-online.service
fi

