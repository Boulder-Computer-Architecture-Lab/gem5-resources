#!/bin/bash

# Copyright (c) 2025 The Regents of the University of California.
# SPDX-License-Identifier: BSD 3-Clause

echo "Installing parsec..."

# Clone the parsec benchmark suite
git clone https://github.com/cirosantilli/parsec-benchmark.git

# Allowing services to restart while updating some libraries.
sudo debconf-get-selections | grep restart-without-asking > libs.txt
sed -i 's/false/true/g' libs.txt
while read line; do echo $line | sudo debconf-set-selections; done < libs.txt
sudo rm libs.txt

echo "12345" | sudo -S chown gem5 -R parsec-benchmark/
echo "12345" | sudo -S chgrp gem5 -R parsec-benchmark/

# Set up the parsec environment
cd parsec-benchmark
./configure
source env.sh
parsecmgmt -a build -p libtool
parsecmgmt -a build -p hooks
# Parsec benchmarks
parsecmgmt -a build -p blackscholes -c gcc-hooks
parsecmgmt -a build -p bodytrack -c gcc-hooks
parsecmgmt -a build -p canneal -c gcc-hooks
parsecmgmt -a build -p dedup -c gcc-hooks
parsecmgmt -a build -p facesim -c gcc-hooks
parsecmgmt -a build -p ferret -c gcc-hooks
parsecmgmt -a build -p fluidanimate -c gcc-hooks
parsecmgmt -a build -p freqmine -c gcc-hooks
parsecmgmt -a build -p streamcluster -c gcc-hooks
parsecmgmt -a build -p swaptions -c gcc-hooks
parsecmgmt -a build -p vips -c gcc-hooks
parsecmgmt -a build -p x264 -c gcc-hooks
parsecmgmt -a build -p netapp -c gcc-hooks
echo "12345" | sudo -S chown gem5 -R /usr/local/
echo "12345" | sudo -S chgrp gem5 -R /usr/local/
parsecmgmt -a build -p raytrace -c gcc-hooks
cp -r /usr/local/bin/ /home/gem5/parsec-benchmark/pkgs/tools/cmake/inst/amd64-linux.gcc-hooks/
parsecmgmt -a build -p raytrace -c gcc-hooks
cp -r /usr/local/bin/ /home/gem5/parsec-benchmark/pkgs/apps/raytrace/inst/amd64-linux.gcc-hooks/
echo "12345" | sudo -S chown root -R /usr/local/
echo "12345" | sudo -S chgrp root -R /usr/local/
# Splash2 benchmarks
parsecmgmt -a build -p splash2x -c gcc-hooks
# Get the native inputs for the benchmarks
./get-inputs -n

cd ..
echo "12345" | sudo -S chown gem5 -R parsec-benchmark/
echo "12345" | sudo -S chgrp gem5 -R parsec-benchmark/

echo "Done installing parsec."