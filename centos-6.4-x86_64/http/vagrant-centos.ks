install
text
cdrom
lang en_US.UTF-8
keyboard us
network --onboot yes --device eth0 --bootproto dhcp --noipv6 --hostname vagrant-centos-6-4.vagrantup.com
rootpw vagrant
firewall --disabled
authconfig --enableshadow --passalgo=sha512
selinux --disabled
timezone --utc America/Chicago
zerombr
clearpart --all
part /boot --fstype=ext4 --size=512
part pv.01 --grow --size=1
volgroup vg_vagrantcentos64 --pesize=4096 pv.01
logvol swap --name=lv_swap --vgname=vg_vagrantcentos64 --size=1024
logvol / --fstype=ext4 --name=lv_root --vgname=vg_vagrantcentos64 --grow --size=1
bootloader --location=mbr --append="crashkernel=auto rhgb quiet"
user --name=vagrant --groups=wheel --password=vagrant
reboot --eject

%packages --nobase
@core
%end

%post --nochroot
cp /etc/resolv.conf /mnt/sysimage/etc/resolv.conf
%end

%post
/usr/bin/yum -y install sudo gcc "kernel-devel-$(uname -r)" make perl rubygems ruby-devel
/usr/bin/yum -y clean all
/sbin/swapoff -a
/sbin/mkswap /dev/mapper/vg_vagrantcentos63-lv_swap
/bin/dd if=/dev/zero of=/boot/EMPTY bs=1M
/bin/rm -f /boot/EMPTY
/bin/dd if=/dev/zero of=/EMPTY bs=1M
/bin/rm -f /EMPTY
%end
