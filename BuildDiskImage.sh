#!/bin/bash

echo " *** Image building helper ***"
echo "A tool to build a disk image with partitions and FAT32."
echo "Warning: DON'T PRESS ENTER FREQUENTLY. Just be patient."

# Build Image
echo "=========================================================="
echo "Now input a name for your disk image (e.g. myDisk.img) :"
read dname
echo "Now input the size of $dname (e.g. 128M) :"
read dsize
echo "Now input your fdisk scipt name (e.g. disksrc) :"
read scname
echo "Now I will build a $dsize with $dname with $scname."
echo "Press enter to continue."
read
dd if=/dev/zero of=$dname bs=$dsize count=1
sudo sfdisk $dname < disksrc

# Format Partitions
echo "=========================================================="
echo "Now I will format the partitions to FAT32."
echo "If you stop it before finish, you should 'losetup -d'."
echo "Press enter to continue."
read
sudo losetup -Pf $dname
echo "The following information may help find the loop device."
sudo fdisk -l /dev/loop?
echo "Please check carefully for which device is used."
echo "Press enter to continue."
read
echo "Input the device used (e.g. 0) :"
read devno
echo "Now will format /dev/loop${devno}p* to FAT32:"
echo "Press enter to continue."
read
for part in $(ls -1 /dev/loop${devno}p*)
do
    # echo $part
    sudo mkfs.fat -F32 $part
done
sudo losetup -d /dev/loop${devno}

echo "=========================================================="
echo "Everything finished. See you next time!"