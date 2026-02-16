# Copyright (c) 2020 The Regents of the University of California.
# SPDX-License-Identifier: BSD 3-Clause

# install build-essential (gcc and g++ included) and gfortran
add-apt-repository universe
apt update
apt install -y gfortran 
apt install -y gdb

# build all SPEC workloads
cd /home/gem5/spec2017

echo "yes" | bash install.sh
source shrc

# build_ncpus: number of cpus to build the workloads
# gcc_dir: where to find the compilers (gcc, g++, gfortran)
runcpu --config=myconfig.${ISA}.cfg --threads=$(nproc) --define build_ncpus=$(nproc) --action=build intspeed fpspeed --tuning=base

# add permissions to avoid permission denied error for "/result/lock.CPU2017"
chmod -R 777 /home/gem5/spec2017/*

# the above building process will produce a large log file
# this command removes the log files to avoid copying out large files unnecessarily
rm -f /home/gem5/spec2017/result/*