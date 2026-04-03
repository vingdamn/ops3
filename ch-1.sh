#!/usr/bin/bash

#cerify CPU vitualisation support
lscpu | grep Virtualization

#Verify kernel modules
lsmod | grep kvm

#Verify permissions
ls -lh /dev/kvm

#create virtual disk qcow2
qemu-img create -f qcow2 Disk-name.qcow2 50G

#download iso image
wget https://dl-cdn.alpinelinux.org/alpine/v3.20/releases/x86_64/alpine-virt-3.20.0-x86_64.iso

#launch VM
qemu-system-x86_64 -enable-kvm -m 1024 -disk file=Disk-name.qcow2,type=qcow2 -cdrom alpine-virt-3.20.0-x86_64.iso -boot d -nographic

#login using root and no password, to install alpine os into vm run setup-alpine, after setup run poweroff, to loginto vm with alpine OS run launching comands without -cdrom & -boot d.

#installing libvirt
sudo apt install qemu-kvm libvirt-daemon-system virtinst -y
sudo systemctl status libvirtd
sudo usermod -aG libvirt $USER

#create storage pool
virsh pool-define-as pool-name dir --target /var/lib/libvirt/images/pool-name
virsh pool-build pool-name
virsh pool-start pool-name
virsh pool-autostart pool-name
virsh poo-list --all

#create volume
virsh vol-create-as pool-name volume-name.qcow2 10G --format qcow2
virsh vol-info volume-name.qcow2 --pool pool-name

#deploying vm with virt install
sudo cp alpine-* /var/lib/libvirt/images/
virt-install --name VM-name --ram 512 --vcpu 2 --disk vol=pool-name/volume-name.qcow2 --cdrom /var/lib/libvirt/images/alpine-virt-3.20.-x86_64.iso --graphics none --console pty,target_type=serial --boot cdrom

#managing vm's with virsh
virsh list
virsh dominfo VM-name #View VM info
virsh console VM-name # recconect to the console
virsh shutdown VM-name #Gracefull shutdown
virsh start VM-name #Start VM
virsh destroy VM-name #Force shutdown
virsh undefine VM-name #clear VM definition
