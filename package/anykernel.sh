# AnyKernel2 Ramdisk Mod Script
# osm0sis @ xda-developers

## AnyKernel setup
# begin properties
properties() {
kernel.string=Flashing: The Soda Kernel version 
do.devicecheck=1
do.modules=0
do.cleanup=1
do.cleanuponabort=0
device.name1=gemini
device.name2=Gemini
device.name3=mi5
device.name4=Mi5
device.name5=MI5
} # end properties

# shell variables
block=/dev/block/bootdevice/by-name/boot;
is_slot_device=0;
ramdisk_compression=auto;


## AnyKernel methods (DO NOT CHANGE)
# import patching functions/variables - see for reference
. /tmp/anykernel/tools/ak2-core.sh;


## AnyKernel file attributes
# set permissions/ownership for included ramdisk files
chmod -R 750 $ramdisk/*;
chown -R root:root $ramdisk/*;


## AnyKernel install
dump_boot;

# begin ramdisk changes

#### init ####
ui_print "Backup and clean ramdisks..."
backup_file /vendor/etc/init/hw/init.qcom.rc;
backup_file /vendor/etc/init/hw/init.qcom.power.rc;
backup_file /vendor/etc/fstab.qcom;
remove_line /vendor/etc/init/hw/init.qcom.rc "import soda.tweaks.rc"
remove_line /vendor/etc/init/hw/init.qcom.power.rc "trigger tweak-soda"

ui_print "Patch ramdisks..."
# Own script
  insert_line /vendor/etc/init/hw/init.qcom.rc "" after "import" "import soda.tweaks.rc"
  insert_line /vendor/etc/init/hw/init.qcom.power.rc "" after "    trigger enable-low-power" "    trigger tweak-soda"

# Remove default qcom power tweaks
  remove_line /vendor/etc/init/hw/init.qcom.power.rc "setprop sys.io.scheduler"
  remove_line /vendor/etc/init/hw/init.qcom.power.rc "write /sys/module/lowmemorykiller/parameters/enable_adaptive_lmk"
  remove_line /vendor/etc/init/hw/init.qcom.power.rc "write /sys/module/cpu_boost/parameters/input_boost_ms"
  remove_line /vendor/etc/init/hw/init.qcom.power.rc "write /sys/module/cpu_boost/parameters/input_boost_freq"

# Remove default io tweaks
  remove_line /vendor/etc/init/hw/init.qcom.rc ""
  remove_line /vendor/etc/init/hw/init.qcom.rc "write /sys/block/sda/queue/iostats 0"
  remove_line /vendor/etc/init/hw/init.qcom.rc "write /sys/block/sda/queue/scheduler cfq"
  remove_line /vendor/etc/init/hw/init.qcom.rc "write /sys/block/sda/queue/iosched/slice_idle 0"
  remove_line /vendor/etc/init/hw/init.qcom.rc "write /sys/block/sda/queue/read_ahead_kb 2048"
  remove_line /vendor/etc/init/hw/init.qcom.rc "write /sys/block/sda/queue/nr_requests 256"
  remove_line /vendor/etc/init/hw/init.qcom.rc "write /sys/block/dm-0/queue/read_ahead_kb 2048"
  remove_line /vendor/etc/init/hw/init.qcom.rc "write /sys/block/dm-1/queue/read_ahead_kb 2048"
  remove_line /vendor/etc/init/hw/init.qcom.rc "write /sys/block/sda/queue/iostats 1"
  remove_line /vendor/etc/init/hw/init.qcom.rc "write /sys/block/sda/queue/nr_requests 128"
  remove_line /vendor/etc/init/hw/init.qcom.rc "write /sys/block/sda/queue/read_ahead_kb 128"
  remove_line /vendor/etc/init/hw/init.qcom.rc "write /sys/block/dm-0/queue/read_ahead_kb 128"
  remove_line /vendor/etc/init/hw/init.qcom.rc "write /sys/block/dm-1/queue/read_ahead_kb 128"

# Remove zram
  remove_line /vendor/etc/fstab.qcom "/dev/block/zram0"
  remove_line /vendor/etc/init/hw/init.qcom.rc "write /sys/block/zram0/comp_algorithm"
  remove_line /vendor/etc/init/hw/init.qcom.rc "swapon_all /vendor/etc/fstab.qcom"

# Tweak flags
  patch_fstab /vendor/etc/fstab.qcom /data ext4 options "nosuid,nodev,noatime,barrier=1,noauto_da_alloc" "nosuid,nodev,noatime,barrier=1,noauto_da_alloc,nodiratime,discard"
  patch_fstab /vendor/etc/fstab.qcom /data f2fs options "nosuid,nodev,noatime,data_flush" "nosuid,nodev,noatime,data_flush,nodiratime,discard"

# end ramdisk changes

write_boot;

## end install

