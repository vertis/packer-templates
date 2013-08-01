#!/usr/bin/env bash
set -e
set -x

sudo sed -i "s/^.*requiretty/#Defaults requiretty/" /etc/sudoers
sudo sed -i "s/#UseDNS yes/UseDNS no/" /etc/ssh/sshd_config

sudo sh -c 'echo "[epel]" >> /etc/yum.repos.d/epel.repo'
sudo sh -c 'echo "name=epel" >> /etc/yum.repos.d/epel.repo'
sudo sh -c 'echo "baseurl=http://download.fedoraproject.org/pub/epel/6/\$basearch" >> /etc/yum.repos.d/epel.repo'
sudo sh -c 'echo "enabled=1" >> /etc/yum.repos.d/epel.repo'
sudo sh -c 'echo "gpgcheck=0" >> /etc/yum.repos.d/epel.repo'

/bin/cat << EOF > /etc/yum.repos.d/epel.repo
[epel]
name=Extra Packages for Enterprise Linux 6 - \$basearch
baseurl=http://download.fedoraproject.org/pub/epel/6/\$basearch
enabled=1
gpgcheck=0
EOF

sudo yum -y install git gcc make automake autoconf libtool gcc-c++ kernel-headers-`uname -r` kernel-devel-`uname -r` zlib-devel openssl-devel readline-devel sqlite-devel perl wget nfs-utils bind-utils dkms

sudo yum -y upgrade

# Installing vagrant keys
/bin/mkdir /home/vagrant/.ssh
/bin/chmod 700 /home/vagrant/.ssh
/usr/bin/curl -o /home/vagrant/.ssh/id_rsa https://raw.github.com/mitchellh/vagrant/master/keys/vagrant
/usr/bin/curl -o /home/vagrant/.ssh/authorized_keys https://raw.github.com/mitchellh/vagrant/master/keys/vagrant.pub
/bin/chown -R vagrant:vagrant /home/vagrant/.ssh
/bin/chmod 0400 /home/vagrant/.ssh/*


/bin/cat << EOF > /etc/sudoers.d/wheel
Defaults:%wheel env_keep += "SSH_AUTH_SOCK"
Defaults:%wheel !requiretty
%wheel ALL=NOPASSWD: ALL
EOF
/bin/chmod 0440 /etc/sudoers.d/wheel

# # Puppet and chef
# /usr/bin/gem install --no-ri --no-rdoc puppet
# /usr/sbin/groupadd -r puppet
# /usr/bin/gem install --no-ri --no-rdoc chef



if [[ -f /etc/.vbox_version ]]; then
  cd /tmp
  sudo mount -o loop /tmp/VBoxGuestAdditions.iso /mnt
  sudo sh /mnt/VBoxLinuxAdditions.run || true
  sudo umount /mnt
  rm -rf /tmp/VBoxGuestAdditions*.iso

  sudo /etc/rc.d/init.d/vboxadd setup
fi