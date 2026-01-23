@echo off

:: Convert an existing QCOW2 image and compress it into a new QCOW2 snapshot
:: .\qemu-img.exe convert -c -O qcow2 asimov.qcow2 asimov_snapshot.qcow2

:: Create a new QCOW2 image with a size of 30GB
:: .\qemu-img.exe create -f qcow2 asimov.qcow2 30G

:: Launch QEMU with specified configurations
.\qemu-system-x86_64.exe -accel whpx -machine q35 ^
  -device usb-tablet ^
  -display sdl,gl=on ^
  -smp 6 ^
  -m 8G ^
  -vga qxl ^
  -usb ^
  -netdev user,id=net0,hostfwd=tcp::50022-:22,net=10.16.85.0/24,dhcpstart=10.16.85.9 ^
  -device virtio-net-pci,netdev=net0 ^
  -drive file=asimov.qcow2,if=none,id=drive-virtio0,format=qcow2 ^
  -device virtio-scsi-pci ^
  -device scsi-hd,drive=drive-virtio0 ^
  -boot d
