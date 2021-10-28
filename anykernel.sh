# AnyKernel3 Ramdisk Mod Script
# osm0sis @ xda-developers

## AnyKernel setup
# begin properties
properties() { '
kernel.string=iDn Kernel 4.9 Supports 11 by @Arrayfs
do.devicecheck=1
do.modules=0
do.systemless=1
do.cleanup=1
do.cleanuponabort=0
device.name1=riva
device.name2=rolex
device.name3=rova
device.name4=msm8937
supported.versions=11 - 12
supported.patchlevels=
'; } # end properties

# shell variables
block=/dev/block/bootdevice/by-name/boot;
is_slot_device=0;
ramdisk_compression=auto;


## AnyKernel methods (DO NOT CHANGE)
# import patching functions/variables - see for reference
. tools/ak3-core.sh;


## AnyKernel file attributes
# set permissions/ownership for included ramdisk files
set_perm_recursive 0 0 755 644 $ramdisk/*;
set_perm_recursive 0 0 750 750 $ramdisk/init* $ramdisk/sbin;

## AnyKernel install
dump_boot;

patch_cmdline androidboot.usbconfigfs androidboot.usbconfigfs=true

write_boot;
## end install

# Check for 4.9 support
umount /vendor
mount -o ro /dev/block/bootdevice/by-name/cust /vendor
if [ -f /vendor/build.prop ]; then
	if [ -f /vendor/etc/vintf/manifest.xml ] ; then
		grep "target-level=\"2\"" /vendor/etc/vintf/manifest.xml
	elif [ -f /vendor/manifest.xml ] ; then
		grep "target-level=\"2\"" /vendor/manifest.xml
	else
		false
	fi

	if [ $? -eq 0 ]; then
		ui_print "WARNING: Your vendor doesn't seems like supporting kernel 4.9."
	fi
fi
umount /vendor
