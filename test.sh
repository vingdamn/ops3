#!/bin/bash

#Part A
lscpu | grep Virtualisation
lsmod | grep kvm
ls -l /dev/kvm

qemu-img create -f qcow2 nova-prime.qcow2 12G 
qemu-img info nova-prime.qcow2 # View disk virtual and actual size

sudo ip link add name br-horizon type bridge
sudo ip link set br-horizon up
sudo ip addr add 10.0.0.0/24 dev br-horizon
# sudo ip link set eth0 master br-horizon 

qemu-system-x86_64 -enable-kvm -m 768 -name nova-prime -drive file=nova-prime.qcow2,format=qcow2 -cdrom alpine.iso -boot d -netdev tap,id=net0,ifname=br-horizonscript=no,downscript=no -device virtio-net-pci,netdev=net0 -nographic 

sudo lxc-create -n Pulse-Prime -t download -- --dist alpine --release 3.19 --arch amd64
#nano /var/lib/lxc/Pulse-Prime/config
#lxc.net.0.type = veth
#lxc.net.0.link = br-horizon
#lxc.net.0.flags = up
#lxc.net.0.name = eth0
#lxc.cgroup2.memory.max = 768M or lxc.cgroups.memory.limit_in_bytes = 768M
sudo lxc-start -n Pulse-Prime
sudo lxc-attach -n Pulse-Prime

#Part B
qemu-img create -f qcow2 Orion-disk.qcow2 15G
virt-install --name Orion-Secundus --ram 1024 --disk file=Orion-disk.qcow2,format=qcow2 --cdrom /var/lib/libvirt/images/ubuntu.iso --network network=default,model=virtio --graphics none --console pty,target_type=serial

sudo lxc-create -n Beam-Secundus -t download -- --dist ubuntu --release 22.04 -a amd64
sudo chown -R 100000:100000 /var/lib/lxc/Beam-Secundus # make container unprivilaged

sudo virsh snapshot-create-as Orion-Secundus snap1 "Initial-Snapshot"
sudo virsh snapshot-list Orion-Secundus
sudo virt-clone --original Orion-Secundus --name Orion-Secundus-clone --auto-clone --file /var/lib/libvirt/images/orion-secundus-clone.qcow2

nano /var/lib/lxc/Beam-Secundus/config
lxc.cgroup2.memory.max = 1536M

#Part C
bridge link

