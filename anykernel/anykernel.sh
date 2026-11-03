### AnyKernel3 Ramdisk Mod Script
## BakaSU + Droidspaces kernel for OnePlus Ace 3V (audi)

### AnyKernel setup
# global properties
properties() { '
kernel.string=BakaSU + Droidspaces kernel for OnePlus Ace 3V (audi)
do.devicecheck=0
do.modules=0
do.systemless=0
do.cleanup=1
do.cleanuponabort=0
device.name1=PJF110
device.name2=audi
device.name3=
device.name4=
device.name5=
supported.versions=
supported.patchlevels=
supported.vendorpatchlevels=
'; } # end properties

### AnyKernel install
## boot shell variables
BLOCK=boot
IS_SLOT_DEVICE=auto
RAMDISK_COMPRESSION=auto
PATCH_VBMETA_FLAG=auto
NO_MAGISK_CHECK=1

# import functions/variables and setup patching - see for reference (DO NOT REMOVE)
. tools/ak3-core.sh

split_boot
if [ -f "split_img/ramdisk.cpio" ]; then
  unpack_ramdisk
  write_boot
else
  flash_boot
fi
