# Derived from https://github.com/adafruit/ARM-toolchain-vagrant and https://github.com/pichenettes/mutable-dev-environment
# See LICENSE for details

#!/usr/bin/env bash

# fix apt warnings like:
# ==> default: dpkg-preconfigure: unable to re-open stdin: No such file or directory
# http://serverfault.com/questions/500764/dpkg-reconfigure-unable-to-re-open-stdin-no-file-or-directory
export LANGUAGE=en_US.UTF-8
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
locale-gen en_US.UTF-8
dpkg-reconfigure locales

# # Add the basics

sudo dpkg --add-architecture i386
sudo apt-get update
sudo apt-get build-dep dfu-util
sudo apt-get install -y build-essential autotools-dev autoconf pkg-config libusb-1.0-0 libusb-1.0-0-dev libftdi1 libftdi-dev git libc6:i386 libncurses5:i386 libstdc++6:i386 cmake libtool

# Install openocd

cd /home/vagrant

git clone https://github.com/ntfreak/openocd.git
cd openocd
./bootstrap
./configure
make
sudo make install

# Install st-link

cd /home/vagrant
wget https://github.com/texane/stlink/archive/v1.5.1.tar.gz
mv v1.5.1.tar.gz stlink.tar.gz
tar xvfz stlink.tar.gz
cd stlink-1.5.1
sudo make release
cd build/Release
sudo make install
sudo ldconfig
sudo udevadm control --reload-rules
sudo udevadm trigger
cd /home/vagrant
rm stlink.tar.gz

# Install GNU ARM tools

wget https://developer.arm.com/-/media/Files/downloads/gnu-rm/7-2017q4/gcc-arm-none-eabi-7-2017-q4-major-linux.tar.bz2
tar xjf gcc-arm-none-eabi-7-2017-q4-major-linux.tar.bz2
sudo mv gcc-arm-none-eabi-7-2017-q4-major /usr/local/
# echo 'export PATH=/usr/local/gcc-arm-none-eabi-7-2017-q4-major/bin:$PATH' >> /home/vagrant/.bashrc
# export PATH=/usr/local/gcc-arm-none-eabi-7-2017-q4-major/bin:$PATH
cd /home/vagrant
rm gcc-arm-none-eabi-7-2017-q4-major-linux.tar.bz2

# Install dfu-util

git clone https://git.code.sf.net/p/dfu-util/dfu-util
cd dfu-util
make maintainer-clean
git pull
./autogen.sh
./configure  # on most systems
make
sudo cp /vagrant/40-dfuse.rules /etc/udev/rules.d
sudo adduser vagrant plugdev
sudo udevadm control --reload-rules
sudo udevadm trigger
sudo make install

# Provision python

sudo apt update
sudo apt install -y python3-pip
cd /vagrant
if [ -d /vagrant/viatools ]; then
	echo "Python tools exist, skipping clone"
else
	git clone "https://github.com/starlingcode/viatools"
fi
cd viatools
sudo pip3 install -r requirements.txt




