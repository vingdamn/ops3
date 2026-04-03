#!/bin/bash

#Creating disk's
qemu-img create -f raw disk-name.raw 10G
qemu-img create -f qcow2 disk-name2.qcow2 10G

#converting disk's
qemu-img convert -c -f raw -O qcow2 disk-name.raw disk-name.qcow2
qemu-img convert -c -f qcow2 -O raw disk-name2.qcow2 disk-name2.raw
qemu-img info disk-name.qcow2 && qemu-img info disk-name2.raw #Verify details

#Resize image
qemu-img resize disk-img.qcow2 +2G

#Create loopback file
dd if=/dev/Zero of=/root/vistual_disk.img bs=1M count=1000
#Attach it to a loopback device
losetup /dev/loop0 /root/virtual_disk.img
#Initialize physical volume
pvcreate /dev/loop0
vgcreate VG_name /dev/loop0 #create volume group
lvcreate -n vol_name -L 500M VG_name #create logical volume

#format and mount
mkfs.ext4 /dev/VG_name/vol_name && mkdir /mnt/test_volume && sudo mount /dev/VG_name /mnt/test_volume
df -h /mnt/test_volume lvs

#take a snapshot
qemu-img snapshot -c snap1 test-disk.qcow2
qemu-img snapshot -l test-disk.qcow2 #List snapshots
qemu-img snapshot -a snap1 test-disk.qcow2 #Restore snapshot

#Create stumulated disk
truncate -s 1G /root/disk

#Zpool
zfs create -V 500M pool-name/block-name # Create Zvol
ls -l /dev/zvol/pool-name/block-name #Verify device
mkfs.ext4 /dev/pool-name/block-name #After formating you can use it as 2nd device when starting a vm -drive file=/dev/zvol/pool-name/block-name,format=raw
zpool status #verify zpool status
zfs snapshot snap@name #Take zpool snaposhot
zfs rollback snap@name # Restore zpool snapshot
