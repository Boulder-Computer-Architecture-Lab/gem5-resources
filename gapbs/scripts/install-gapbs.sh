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
make
wget http://www.diag.uniroma1.it/challenge9/data/USA-road-d/USA-road-d.LKS.gr.gz
gzip -d USA-road-d.LKS.gr.gz
cd ..

echo "Done installing gapbs."