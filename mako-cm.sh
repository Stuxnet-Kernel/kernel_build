#!/bin/bash

cd ../mako

clear

echo ""
echo "****************************************************"
echo "* Im not responsible of what you do to your device.*"
echo "* You know the consequences upon changing stuff.   *"
echo "* Its your responsibility upon building my kernel. *"
echo "****************************************************"
echo ""

git checkout cm-12

make clean
make mrproper
export CCACHE=1
export ARCH=arm
export CROSS_COMPILE=~/tmp/arm-eabi-4.9/bin/arm-eabi-
export ENABLE_GRAPHITE=true
version="4.2"
export CONFIG_DEBUG_SECTION_MISMATCH=y
make mako_defconfig

if [ $# -gt 0 ]; then
echo $1 > .version
fi

time make -j8 2>&1 | tee kernel.log

echo ""
echo "Building boot.img"
cp arch/arm/boot/zImage ../cyanogenmod/

cd ../cyanogenmod/

echo ""
echo "building ramdisk"
./mkbootfs ramdisk | gzip > ramdisk.gz
echo ""
echo "making boot image"
./mkbootimg --kernel zImage --cmdline 'console=ttyHSL0,115200,n8 androidboot.hardware=mako lpj=67677 user_debug=31' --base 0x80200000 --pagesize 2048 --ramdisk_offset 0x01600000 --ramdisk ramdisk.gz --output ../mako/boot.img

rm -rf ramdisk.gz
rm -rf zImage

cd ../mako/

zipfile="Stuxnet-cm-v$version.zip"
echo ""
echo "zipping kernel"
cp boot.img zip/

rm -rf ../cyanogenmod/boot.img

cd zip/
rm -f *.zip
zip -r -9 $zipfile *
rm -f /tmp/*.zip
cp *.zip /tmp

cd ../
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
