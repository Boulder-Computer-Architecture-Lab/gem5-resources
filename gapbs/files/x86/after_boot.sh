#!/bin/bash

# Copyright (c) 2022,2024 The University of California.
# Copyright (c) 2021 The University of Texas at Austin.
# SPDX-License-Identifier: BSD 3-Clause

# This file is executed at the end of the bashrc for the gem5 user.
# The script checks to see if we should run in interactive mode or not.
# If we are in interactive mode, the script will drop to a shell.
# If we are not in interactive mode, the script will check if we should
# run a script from the gem5-bridge. If so, it will run the script and
# exit. If there is no script and we are not in interactive mode, it will
# exit. This last option is used for testing purposes.

# gem5-bridge exit signifying that after_boot.sh is running
printf "In after_boot.sh...\n"
gem5-bridge hypercall 2

printf "Starting gem5 init... trying to read run script file via readfile.\n"
gem5-bridge readfile > /home/gem5/gapbs/script
printf "Running script from gem5-bridge stored in /home/gem5/gapbs\n"
chmod 755 /home/gem5/gapbs/script
hypercall 2
/home/gem5/gapbs/script
printf "Done running script from gem5-bridge, exiting.\n"
rm -f /home/gem5/gapbs/script
gem5-bridge hypercall 3