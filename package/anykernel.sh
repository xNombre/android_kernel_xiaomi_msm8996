# AnyKernel2 Ramdisk Mod Script
# osm0sis @ xda-developers

## AnyKernel setup
# EDIFY properties
kernel.string=The Soda-Upstream Kernel beta v1.0 by xNombre
do.devicecheck=1
do.initd=1
do.modules=1
do.cleanup=1
device.name1=Gemini
device.name2=gemini
device.name3=MI5
device.name4=Mi5
device.name5=mi5

# shell variables
block=/dev/block/bootdevice/by-name/boot;
is_slot_device=0;


## AnyKernel methods (DO NOT CHANGE)
# import patching functions/variables - see for reference
. /tmp/anykernel/tools/ak2-core.sh;


## AnyKernel permissions
# set permissions for included ramdisk files
chmod -R 755 $ramdisk

## AnyKernel install
dump_boot;

# begin ramdisk changes

# end ramdisk changes

write_boot;

## end install

