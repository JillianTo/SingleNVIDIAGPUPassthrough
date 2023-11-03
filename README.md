# Single NVIDIA GPU Passthrough
I did all these steps on Debian 12 with a Ryzen 1700 and RTX 3090
 1. Enable IOMMU and SVM in your BIOS
 Called something different for Intel
 2. Edit /etc/default/grub
   GRUB_CMDLINE_LINUX_DEFAULT="amd_iommu=on iommu=pt video=efifb:off quiet"
   video=efifb:off will disable GPU output during boot, also obviously this needs to be edited if you have an Intel CPU
 3. Do sudo update-grub
 4. Do sudo usermod -aG *YOUR USERNAME* input kvm libvirt, then reboot your system
 5. Download ISO with virtio drivers: https://fedorapeople.org/groups/virt/virtio-win/direct-downloads/stable-virtio/virtio-win.iso
 6. Download ISO for the operating system you're using
  I'm using the October 2023 build of Windows 11 x64
 7. OPTIONAL: Create an empty NTFS partition for Windows install
  Maybe improves performance over the virtual disk?
 8. Do sudo virt-manager and create a VM, don't passthrough GPU yet
  TODO: Add steps for this
  Set firmware to the UEFI option with secboot in the name
  Choose "Add Hardware", "Storage Device", and set it to CDROM and the virtio driver ISO
 9. Install Windows on VM
  If you're using a virtual disk, on the screen where you choose a disk to install to, click "Load Driver" and choose the amd64 option
10. Install virtio-guest-tools.exe from the virtio driver ISO
11. Shutdown the VM
12. Edit the VM options
  Remove Display Spice, Channel Spice, Video QXL, and USB Redirect. If you can't remove it, do sudo virsh edit *YOUR VM NAME* and delete those parts from the XML
  Passthrough USB devices (like your keyboard and mouse)
  Passthrough GPU PCIE devices (both the video and audio parts)
13. Set hyperv vendor id and kvm hidden state
  TODO: Add steps for this
14. Download the VBIOS for your GPU and edit in a hex editor
  TechPowerUp has a bunch of VBIOSes
  Search for "VIDEO" and then to the left of that, find 55 AA. Delete everything before that.
15. Move your edited VBIOS to /usr/share/vgabios
  If the vgabios folder doesn't exist, create it. Do sudo chown *YOUR USERNAME*:*YOUR USERNAME* *YOUR VBIOS*.rom and sudo chmod 755 *YOUR VBIOS*.rom
16. Do sudo virsh edit *YOUR VM NAME* and add the rom file
  TODO: add steps for this
17. Do sudo ./start.sh and it should work
  You'll probably want to restart your display-manager but who needs desktops anyway?
