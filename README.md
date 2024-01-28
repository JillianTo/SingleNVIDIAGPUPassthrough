# Single NVIDIA GPU Passthrough
I did all these steps on Debian 12 with a Ryzen 1700 and RTX 3090<br />
 1. Enable IOMMU and SVM in your BIOS<br />
    Called something different for Intel<br />
 2. Edit /etc/default/grub<br />
    GRUB_CMDLINE_LINUX_DEFAULT="amd_iommu=on iommu=pt video=efifb:off quiet"<br />
    video=efifb:off will disable GPU output during boot, you don't need that if you have another GPU.
    Use something else instead of amd_iommu if you have an Intel CPU<br />
 4. Do sudo update-grub<br />
 5. Do sudo usermod -aG *YOUR USERNAME* input kvm libvirt, then reboot your system<br />
 6. Download ISO with virtio drivers: https://fedorapeople.org/groups/virt/virtio-win/direct-downloads/stable-virtio/virtio-win.iso<br />
 7. Download ISO for the operating system you're using<br />
    I'm using the October 2023 build of Windows 11 x64<br />
 8. OPTIONAL: Create an empty NTFS partition for Windows install<br />
    Maybe improves performance over the virtual disk?<br />
 9. Do sudo virt-manager and create a VM, don't passthrough GPU yet<br />
    TODO: Add steps for this<br />
    Set firmware to the UEFI option for your distro TODO: list what those are<br />
    If you're making a Windows 11 VM, choose the UEFI option with secboot in the name<br />
    Choose "Add Hardware", "Storage Device", and set it to CDROM and the virtio driver ISO<br />
 10. Install Windows on VM<br />
    If you're using a virtual disk, on the screen where you choose a disk to install to, click "Load Driver" and choose the amd64 option<br />
11. Install virtio-guest-tools.exe from the virtio driver ISO<br />
12. Shutdown the VM<br />
13. Edit the VM options<br />
    Remove Display Spice, Channel Spice, Video QXL, and USB Redirect. If you can't remove it, do sudo virsh edit *YOUR VM NAME* and delete those parts from the XML<br />
    Passthrough USB devices (like your keyboard and mouse)<br />
    Passthrough GPU PCIE devices (both the video and audio parts)<br />
14. Set hyperv vendor id and kvm hidden state<br />
    TODO: Add steps for this<br />
15. Download the VBIOS for your GPU and edit in a hex editor<br />
    TechPowerUp has a bunch of VBIOSes<br />
    Search for "VIDEO" and then to the left of that, find 55 AA. Delete everything before that.<br />
16. Move your edited VBIOS to /usr/share/vgabios<br />
    If the vgabios folder doesn't exist, create it. Do sudo chown *YOUR USERNAME*:*YOUR USERNAME* *YOUR VBIOS*.rom and sudo chmod 755 *YOUR VBIOS*.rom<br />
17. Do sudo virsh edit *YOUR VM NAME* and add the rom file<br />
    Add <rom file='/usr/share/vgabios/YOUR VBIOS.rom'/> after <source><address domain='0x0000' bus='0x03' slot='0xYOUR GPU PCI ADDR' function='0x0'/></source>. You can get your GPU's PCI address by using lspci, and function 0x0 inside the source block should be the video part of the card. If it had 0x01 inside the source block, it's the audio part.<<br />
18. Do sudo ./start.sh and it should work<br />
    Don't try and replace this with hooks, it doesn't work (unless it does for you...)<br />
    You'll probably want to restart your display-manager but who needs desktops anyway?<br />
19. Install your GPU drivers in Windows
