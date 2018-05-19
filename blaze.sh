#!/bin/sh
# Custom build script


KERNEL_DIR=$PWD
ZIMAGE=$KERNEL_DIR/outdir/arch/arm/boot/zImage-dtb
BUILD_START=$(date +"%s")
blue='\033[0;34m'
cyan='\033[0;36m'
yellow='\033[0;33m'
red='\033[0;31m'
nocol='\033[0m'

#make kernel compiling dir...
mkdir -p outdir


#exports ::
#toolchain , custom build_user , custom build_host , arch
export ARCH=arm
export ARCH_MTK_PLATFORM=mt673
#export CROSS_COMPILE=~/arm-eabi-4.9/bin/arm-eabi-
#export CROSS_COMPILE=$PWD/arm-gnu-7.x/bin/arm-gnu-linux-androideabi-
export CROSS_COMPILE=$PWD/arm-linux-androideabi-4.9/bin/arm-linux-androideabi-
export KBUILD_BUILD_USER="izaqkull"
export KBUILD_BUILD_HOST="OSX-Strec"
>>>>>>> 4d586db50... Update blaze.sh


compile_kernel ()
{
echo -e "$blue***********************************************"
echo "          Compiling Blaze™ Kernel...          "
echo -e "***********************************************$nocol"
echo ""
#woods defconfig
make -C $PWD O=outdir ARCH=arm woods_defconfig
#
make -j4 -C $PWD O=outdir ARCH=arm
echo -e "$yellow Copying to outdir/iykonzBlaze $nocol"
cp outdir/arch/arm/boot/zImage-dtb outdir/iykonzBlaze/Image

if ! [ -f $ZIMAGE ];
then
echo -e "$red Kernel Compilation failed! Fix the errors! $nocol"
exit 1
fi
}

zip_zak ()
{
echo -e "$cyan***********************************************"
echo "          ZIpping Blaze™ Kernel...          "
echo -e "***********************************************$nocol"
echo ""
echo -e "$yellow Putting iykonzBlaze™ Kernel in Recovery Flashable Zip $nocol"
#using lazy kernel flasher
cd outdir
cd iykonzBlaze
    if 
    [ -f outdir/iykonzBlaze/out_done ] 
    then
    rm -rf out_done
    else
    make
    mkdir -p out_done
    cp Jennie.N7x_woods*zip* out_done
    cd ../../
    sleep 0.6;
    echo ""
    echo ""
    echo "" "Done Making Recovery Flashable Zip"
    echo ""
    echo ""
    echo "" "Locate iykonzBlaze™ Kernel in the following path : "
    echo "" "outdir/iykonzBlaze/out_done"
    echo ""
    echo -e "$blue***********************************************"
    echo "          Uploading Blaze™ Kernel as zip...          "
    echo -e "***********************************************$nocol"
    echo ""
    curl --upload-file outdir/iykonzBlaze/out_done/Jennie.N7x_woods*.zip https://transfer.sh/Jennie.N7x_woods_Nougat_$BUILD_START.zip
    echo ""
    echo ""
    echo " Uploading Done !!!"
    echo ""
    echo ""
    BUILD_END=$(date +"%s")
    DIFF=$(($BUILD_END - $BUILD_START))
    echo -e "$yellow Build completed in $(($DIFF / 60)) minute(s) and $(($DIFF % 60)) seconds.$n"
    #exit 1
    fi
}

close_me ()
{
printf '\e[8;33;80t]'
clear
 cecho C "" "Talent Is Nothing WIthout Ethics!!!"
 sleep 1.0;
 clear
exit
}

case $1 in
clean)
#make ARCH=arm -j16 clean mrproper
rm -rf include/linux/autoconf.h
;;
*)
compile_kernel
zip_zak
close_me
;;
esac
