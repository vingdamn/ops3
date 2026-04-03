#!/bin/bash

#create name spaces
sudo ip netns add sever && sudo ip netns add proxy
sudo ip netns exec server ip link show 
sudo ip netns exec proxy ip link show 

#create virtual cable
sudo ip link add veth-server type veth peer name veth-proxy

#connect cabble
sudo ip link set veth-server netns server && sudo ip link set veth-proxy netns proxy

#Configure ip addresses
sudo ip netns exec server ip addr add 192.168.1.2/24 dev veth-server
sudo ip netns exec proxy ip addr add 192.168.1.3/24 dev veth-proxy
sudo ip netns exec server ip link set veth-server up && sudo ip netns exec proxy ip link set veth-proxy up

#Create a bridge
sudo ip link add bridge-name type bridge && sudo ip link set bridge-name up
ip link show bridge-name

#clean up
sudo ip netns delete server && sudo ip netns delete proxy && sudo ip link delete bridge-name

#Install OVS
sudo apt install openvswitch-switch -y

#create OVS bridge
sudo ocs-vsctl add-br ovs-name
sudo ovs-vsctl show #Inspect switch

#Add fake port
sudo ip link add type veth && sudo ovs-vsctl add-port ovs-name veth0 && ovs-vsctl show
