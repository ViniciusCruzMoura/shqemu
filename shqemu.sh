#!/bin/sh

##############################################################################
#
# ShQEMU - A simple and easy-to-use QEMU command-line interface (CLI)
#               (https://github.com/viniciuscruzmoura)
#
# LICENSE: MIT license
#
# Copyright (c) 2025 Vinícius Moura
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.
##############################################################################

QEMU_SYSTEM_X86_64=qemu-system-x86_64
QEMU_IMG=qemu-img

LINUX_QEMU_IMG_SIZE="8048M"
LINUX_OS_ISO="./debian-12.9.0-amd64-netinst.iso"

WIN_OS_ISO="./Win10_22H2_English_x64v1.iso"
WIN_QEMU_IMG_SIZE="24048M"

QEMU_NET_FLAGS="-netdev user,id=net0,hostfwd=tcp::2222-:22,net=10.16.85.0/24,dhcpstart=10.16.85.9 -device e1000,netdev=net0"
QEMU_DISPLAY_FLAGS="-display vnc=:0" #-display gtk , -display vnc=:0 , -display sdl
QEMU_FLAGS="$QEMU_DISPLAY_FLAGS -enable-kvm -cpu host -smp $(nproc) -m 4048 -vga qxl $QEMU_NET_FLAGS"

NO_VNC_CLIENT="~/workspaces/opt/noVNC/utils/novnc_proxy --vnc localhost:5900"
NO_VNC_BROWSER="firefox \"http://localhost:6080/vnc.html?host=&port=6080\" "

case $1 in
    install-linux)
        if [ -z "$2" ]; then
            echo "Usage: $0 $1 <vhddisk.img>"
            echo "ERROR: no path to image is provided"
            exit 1
        fi
        $QEMU_IMG create "$2" $LINUX_QEMU_IMG_SIZE
        $QEMU_SYSTEM_X86_64 $QEMU_FLAGS -cdrom $LINUX_OS_ISO -hda "$2" -boot d
        exit 0
        ;;
    install-win)
        if [ -z "$2" ]; then
            echo "Usage: $0 $1 <vhddisk.img>"
            echo "ERROR: no path to image is provided"
            exit 1
        fi
        $QEMU_IMG create "$2" $WIN_QEMU_IMG_SIZE
        $QEMU_SYSTEM_X86_64 $QEMU_FLAGS -cdrom $WIN_OS_ISO -hda "$2" -boot d
        exit 0
        ;;
    run)
        if [ -z "$2" ]; then
            echo "Usage: $0 $1 <vhddisk.img>"
            echo "ERROR: no path to image is provided"
            exit 1
        fi
        $QEMU_SYSTEM_X86_64 $QEMU_FLAGS "$2"
        exit 0
        ;;
    sync)
        echo "TODO: sync shared directory"
        exit 0
        ;;
    mount)
        echo "TODO: mount shared directory"
        exit 0
        ;;
    -h|-help|--help|help|*)
        echo "ShQEMU - A simple and easy-to-use QEMU command-line interface (CLI)"
        echo "  (https://github.com/viniciuscruzmoura)"
        echo
        echo "Usage:"
        echo "  $0 COMMAND [options]"
        echo
        echo "Commands:"
        echo "  help            Display this help information."
        echo "  install-linux   Create a Linux virtual hard disk and initiate installation."
        echo "                  Usage: $0 install-linux <vhddisk.img>"
        echo "  install-win     Create a Windows (Win10) virtual hard disk and initiate installation."
        echo "                  Usage: $0 install-win <vhddisk.img>"
        echo "  run             Run an existing virtual hard disk image."
        echo "                  Usage: $0 run <vhddisk.img>"
        echo "  sync            (TODO) Sync a shared directory."
        echo "  mount           (TODO) Mount a shared directory."
        echo
        echo "You can also invoke help for an individual command by appending --help after the command:"
        echo "  Example: $0 install-linux --help"
        echo
        exit 0
        ;;
esac
