#!/bin/bash

echo "Installing gapbs."

sudo apt install -y debconf-utils git
sudo debconf-get-selections | grep restart-without-asking > libs.txt
sed -i 's/false/true/g' libs.txt
while read line; do echo $line | sudo debconf-set-selections; done < libs.txt
sudo rm libs.txt

echo "12345" | sudo apt-get install -y git build-essential libboost-all-dev

git clone https://github.com/darchr/gapbs.git
cd gapbs
make -j $(nproc)
# Only derive the road benchmark
sed -i 's/^GRAPHS =.*/GRAPHS = road/' benchmark/bench.mk
make bench-graphs -j $(nproc)

echo "Done installing gapbs."