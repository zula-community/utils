#!/bin/bash
sudo touch /var/swap.img
sudo chmod 600 /var/swap.img
sudo dd if=/dev/zero of=/var/swap.img bs=1024k count=2000
mkswap /var/swap.img
sudo swapon /var/swap.img
sudo echo "/var/swap.img none swap sw 0 0" >> /etc/fstab
sudo apt-get update -y

mkdir /root/temp
cd /root/temp
wget https://github.com/zuladev/zulacoin/releases/download/0.12.2.1/linux64_v0.12.2.1.tar.gz
tar -xvzf linux64_v0.12.2.1.tar.gz
sleep 15
rm linux64_v0.12.2.1.tar.gz

mkdir /root/zula
mkdir /root/.zulacore
cp /root/temp/zulad /root/zula
cp /root/temp/zula-cli /root/zula
cd /root/zula
sudo apt-get install -y pwgen
GEN_PASS=`pwgen -1 20 -n`
echo -e "rpcuser=zulauser\nrpcpassword=${GEN_PASS}\nrpcport=12500\nport=12501\nlisten=1\nmaxconnections=256" > /root/.zulacore/zula.conf
cd /root/zula
./zulad -daemon
sleep 10
masternodekey=$(./zula-cli masternode genkey)
./zula-cli stop
sleep 30
echo -e "masternode=1\nmasternodeprivkey=$masternodekey" >> /root/.zulacore/zula.conf
./zulad -daemon
sleep 10
echo "Masternode private key: $masternodekey"
echo "Job completed successfully"
