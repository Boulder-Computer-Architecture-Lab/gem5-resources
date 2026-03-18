#!/bin/bash

# Copyright (c) 2024 The Regents of the University of California.
# SPDX-License-Identifier: BSD 3-Clause

PACKER_VERSION="1.10.0"

# Detect host architecture
ARCH=$(uname -m)
case "$ARCH" in
    x86_64)
        PACKER_ARCH="amd64"
        ;;
    aarch64 | arm64)
        PACKER_ARCH="arm64"
        ;;
    *)
        echo "Unsupported architecture: $ARCH"
        exit 1
        ;;
esac

# Check if Packer exists, otherwise download the correct one
if [ ! -f ./packer ]; then
    URL="https://releases.hashicorp.com/packer/${PACKER_VERSION}/packer_${PACKER_VERSION}_linux_${PACKER_ARCH}.zip"
    echo "Downloading Packer from $URL ..."
    wget "$URL"
    unzip "packer_${PACKER_VERSION}_linux_${PACKER_ARCH}.zip"
    rm "packer_${PACKER_VERSION}_linux_${PACKER_ARCH}.zip"
fi

if [ ! -f ./../tmp/riscv-ubuntu-24.04-20250515 ]; then
    wget https://dist.gem5.org/dist/develop/images/riscv/ubuntu-24-04/riscv-ubuntu-24.04-20250515.gz \
        -O ./../tmp/riscv-ubuntu-24.04-20250515.gz
    gunzip ../tmp/riscv-ubuntu-24.04-20250515.gz;
fi

rm -rf $OUTDIR

# Install the needed plugins
./packer init ./packer-scripts/riscv-ubuntu.pkr.hcl

# Build the image
./packer build ./packer-scripts/riscv-ubuntu.pkr.hcl
