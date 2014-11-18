#!/bin/bash

cd mako
rm arch/arm/boot/zImage
rm boot.img
rm kernel.log
rm zip/boot.img
rm zip/Stuxnet.zip

clear

echo ""
echo "****************************************************"
echo "* Im not responsible of what you do to your device.*"
echo "* You know the consequences upon changing stuff.   *"
echo "* Its your responsibility upon building my kernel. *"
echo "****************************************************"
echo ""

git checkout Stuxnet

make clean
make mrproper
export KBUILD_BUILD_USER=jmabalot
export KBUILD_BUILD_HOST=STUXNET-KERNEL-DEVELOPMENT
export ARCH=arm
export CROSS_COMPILE=~/tmp/arm-eabi-4.9/bin/arm-eabi-
export ENABLE_GRAPHITE=true
make mako_defconfig
time make -j8 2>&1 | tee kernel.log

echo ""
echo "Building boot.img"
cp arch/arm/boot/zImage ../ramdisk/

cd ../ramdisk/

echo ""
echo "building ramdisk"
./mkbootfs ramdisk | gzip > ramdisk.gz
echo ""
echo "making boot image"
./mkbootimg --base 80200000 --ramdisk_offset 01600000 --second_offset 00008000 --tags_offset 00000100 --cmdline 'console=ttyHSL0,115200,n8 androidboot.hardware=mako lpj=67677 user_debug=31' --kernel zImage --ramdisk ramdisk.gz --output ../mako/boot.img

rm -rf ramdisk.gz
rm -rf zImage

cd ../mako/

zipfile="Stuxnet.zip"
echo ""
echo "zipping kernel"
cp boot.img zip/

rm -rf ../ramdisk/boot.img

cd zip/
rm -f *.zip
zip -r -9 $zipfile *
rm -f /tmp/*.zip
cp *.zip /tmp

cd ..
rm arch/arm/boot/zImage
rm boot.img
rm kernel.log
rm zip/boot.img

echo ""
echo "****************************************************"
echo "* Kernel building successful unless it errors out. *"
echo "* Check the errors and fix them if you changed it. *"
echo "* Otherwise flash it and jerk off with your iPhone!*"
echo "****************************************************"
echo ""
