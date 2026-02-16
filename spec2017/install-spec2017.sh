#!/bin/bash

ISA=$1
NPROC=$2

# use the example config as the template
# if [ "${ISA}" = "x86" ]; then
#    cp files/spec2017/config/Example-gcc-linux-x86.cfg files/spec2017/config/myconfig.${ISA}.cfg
#    TOOL="linux-x86_64"
# elif [ "${ISA}" = "riscv" ]; then
#    cp files/${ISA}/myconfig.${ISA}.cfg files/spec2017/config/myconfig.${ISA}.cfg
#    TOOL="linux-riscv64"
# fi

# cd files/spec2017

# ./install.sh

# source shrc

# # Update the SPEC2017 to latest version
# echo y | runcpu --update

# build all SPEC workloads
# build_ncpus: number of cpus to build the workloads
# gcc_dir: where to find the compilers (gcc, g++, gfortran)
runcpu --config=myconfig.${ISA}.cfg --define build_ncpus=$(nproc) --define gcc_dir="/usr" --action=build intspeed --tuning=base
runcpu --config=myconfig.${ISA}.cfg --define build_ncpus=$(nproc) --define gcc_dir="/usr" --action=setup intspeed --tuning=base
runcpu --config=myconfig.${ISA}.cfg --define build_ncpus=$(nproc) --define gcc_dir="/usr" --action=build fpspeed --tuning=base
runcpu --config=myconfig.${ISA}.cfg --define build_ncpus=$(nproc) --define gcc_dir="/usr" --action=setup fpspeed --tuning=base

# Clean by hand
# rm -Rf $SPEC/benchspec/C*/*/run
# rm -Rf $SPEC/benchspec/C*/*/build
# rm -Rf $SPEC/benchspec/C*/*/exe 