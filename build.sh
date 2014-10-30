#!/bin/bash

# Bash Color
green='\033[01;32m'
red='\033[01;31m'
blink_red='\033[05;31m'
restore='\033[0m'

clear

# Resources
THREAD="-j9"
KERNEL="zImage"
DEFCONFIG="hells_defconfig"

# Kernel Details
BASE_HC_VER="hC"
VER="-b64"
HC_VER="$BASE_HC_VER$VER"

# Vars
export LOCALVERSION=-`echo $HC_VER`
export ARCH=arm
export SUBARCH=arm

# Paths
KERNEL_DIR=`pwd`
REPACK_DIR="${HOME}/Android/Kernel/hC-N4-anykernel"
ZIP_MOVE="${HOME}/Android/Kernel/hC-releases/N4"
ZIMAGE_DIR="${HOME}/Android/Kernel/hells-Core-N4/arch/arm/boot"

# Functions
function clean_all {
		rm -rf $REPACK_DIR/kernel/zImage
		make clean && make mrproper
}

function make_kernel {
		make $DEFCONFIG
		make $THREAD
		cp -vr $ZIMAGE_DIR/$KERNEL $REPACK_DIR/kernel
}

function make_zip {
		cd $REPACK_DIR
		zip -9 -r `echo $HC_VER`.zip .
		mv  `echo $HC_VER`.zip $ZIP_MOVE
		cd $KERNEL_DIR
}


DATE_START=$(date +"%s")

echo -e "${green}"
echo "hC Kernel Creation Script:"
echo

echo "---------------"
echo "Kernel Version:"
echo "---------------"

echo -e "${red}"; echo -e "${blink_red}"; echo "$HC_VER"; echo -e "${restore}";

echo -e "${green}"
echo "-----------------"
echo "Making hC Kernel:"
echo "-----------------"
echo -e "${restore}"

while read -p "Do you want to clean stuffs (y/n)? " cchoice
do
case "$cchoice" in
	y|Y )
		clean_all
		echo
		echo "All Cleaned now."
		break
		;;
	n|N )
		break
		;;
	* )
		echo
		echo "Invalid try again!"
		echo
		;;
esac
done

echo

while read -p "Do you want to build kernel (y/n)? " dchoice
do
case "$dchoice" in
	y|Y)
		make_kernel
		make_zip
		break
		;;
	n|N )
		break
		;;
	* )
		echo
		echo "Invalid try again!"
		echo
		;;
esac
done

echo -e "${green}"
echo "-------------------"
echo "Build Completed in:"
echo "-------------------"
echo -e "${restore}"

DATE_END=$(date +"%s")
DIFF=$(($DATE_END - $DATE_START))
echo "Time: $(($DIFF / 60)) minute(s) and $(($DIFF % 60)) seconds."
echo

