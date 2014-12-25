#!/bin/bash

cd ../shamu

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
export CCACHE=1
export ARCH=arm
export CROSS_COMPILE=~/tmp/arm-eabi-4.9/bin/arm-eabi-
export ENABLE_GRAPHITE=true
version="1.0"
export CONFIG_DEBUG_SECTION_MISMATCH=y
make shamu_defconfig

if [ $# -gt 0 ]; then
echo $1 > .version
fi

time make -j8 2>&1 | tee kernel.log

rm kernel.log

echo ""
echo "****************************************************"
echo "* Kernel building successful unless it errors out. *"
echo "* Check the errors and fix them if you changed it. *"
echo "* Otherwise flash it and jerk off with your iPhone!*"
echo "****************************************************"
echo ""
