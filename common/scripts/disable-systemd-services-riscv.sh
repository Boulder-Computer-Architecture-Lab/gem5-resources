#!/bin/bash

# Copyright (c) 2024 The Regents of the University of California.
# SPDX-License-Identifier: BSD 3-Clause

echo "Disabling systemd services for riscv architecture..."

# Disable AppArmor — optional security daemon that slows boot and isn't needed
systemctl disable apparmor.service snapd.apparmor.service
systemctl mask apparmor.service snapd.apparmor.service

# Mask systemd-random-seed to avoid long waits for entropy in gem5 simulations
systemctl disable systemd-random-seed.service
systemctl mask systemd-random-seed.service

# Disable multipathd — not needed for single disk setup or simulation
systemctl disable multipathd.service
systemctl mask multipathd.service

# Disable snapd and its socket — snap package manager is not used in gem5
systemctl disable snapd.service snapd.socket
systemctl mask snapd.service snapd.socket

# Disable periodic system maintenance timers to reduce boot time
systemctl disable apt-daily.timer apt-daily-upgrade.timer fstrim.timer
systemctl mask apt-daily.timer apt-daily-upgrade.timer fstrim.timer

# Disable accounts-daemon — manages desktop login accounts (not needed headless)
systemctl disable accounts-daemon.service
systemctl mask accounts-daemon.service

# Disable lvm2-monitor — not required unless simulating logical volumes
systemctl disable lvm2-monitor.service
systemctl mask lvm2-monitor.service

# Disable ModemManager — manages cellular devices, irrelevant in gem5
systemctl disable ModemManager.service
systemctl mask ModemManager.service

# Disable udisks2 — disk hotplug and automounting service, not useful in static sim
systemctl disable udisks2.service
systemctl mask udisks2.service

# Disable system time sync — not needed for simulated time environments
systemctl disable systemd-timesyncd.service
systemctl mask systemd-timesyncd.service

# Disable rsyslog — persistent logging not required and slows simulation
systemctl disable rsyslog.service
systemctl mask rsyslog.service

# Switch default target to multi-user (no GUI)
sudo systemctl set-default multi-user.target

# Mask plymouth — graphical boot splash screen, not needed in headless mode
systemctl disable plymouth-start.service plymouth-quit.service plymouth-read-write.service
systemctl mask plymouth-start.service plymouth-quit.service plymouth-read-write.service

echo "completed disabling systemd services for riscv."