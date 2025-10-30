#!/bin/bash

echo "Installing gapbs."

sudo apt install -y debconf-utils git
sudo debconf-get-selections | grep restart-without-asking > libs.txt
sed -i 's/false/true/g' libs.txt
while read line; do echo $line | sudo debconf-set-selections; done < libs.txt
sudo rm libs.txt

sudo apt install -y git
echo "12345" | sudo apt-get install -y build-essential libboost-all-dev

git clone https://github.com/darchr/gapbs.git
cd gapbs
make -j $(nproc)
sed -i 's/^GRAPHS =.*/GRAPHS = road/' benchmark/bench.mk
make bench-graphs -j $(nproc)
cd ..

echo "Done installing gapbs."