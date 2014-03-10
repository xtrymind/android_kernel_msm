#!/bin/bash

head=`git rev-parse --verify --short HEAD 2>/dev/null`

BASE_VER="perf-"
LOCAL_VER=$BASE_VER$head

export LOCALVERSION="-"`echo $LOCAL_VER`
export ARCH=arm
export SUBARCH=arm
export CROSS_COMPILE=~/tools/arm-cortex_a15-linux-gnueabihf-linaro_4.7.4-2014.01/bin/arm-cortex_a15-linux-gnueabihf-
#export KBUILD_BUILD_USER=xtrymind
#export KBUILD_BUILD_HOST="kernel"

echo 
echo "Making mako_defconfig"

DATE_START=$(date +"%s")

make "mako_defconfig"

OUTPUT_DIR=nightlies-4.4.x/

make -j16
rm -v ../$OUTPUT_DIR/kernel/zImage
cp -vr arch/arm/boot/zImage ../$OUTPUT_DIR/kernel/
cd ../

version=`cat .version`
KER_VERSION="mako-kernel-0"
KERNEL_VER=$KER_VERSION$version

cd $OUTPUT_DIR
zip -rv `echo $KERNEL_VER`.zip kernel META-INF

DATE_END=$(date +"%s")
echo
DIFF=$(($DATE_END - $DATE_START))
echo "Build completed in $(($DIFF / 60)) minute(s) and $(($DIFF % 60)) seconds."
