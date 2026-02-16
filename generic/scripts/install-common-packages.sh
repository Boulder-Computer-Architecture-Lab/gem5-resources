#!/bin/bash

# Copyright (c) 2025 The Regents of the University of California.
# SPDX-License-Identifier: BSD 3-Clause

echo "Installing common packages."

# Installing the packages in this script instead of the user-data
# file during ubuntu autoinstall. The reason is that sometimes
# the package install fails. This method is more reliable.

apt-get update
apt-get install -y scons
apt-get install -y git
apt-get install -y vim
apt-get install -y build-essential
apt-get install -y gdb

echo "Installation of common packages done."