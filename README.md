# Vagrant enviroment for Starling Via hacking
A Vagrant pox provisioned with the tools needed to build, flash, and hack Via modules. 

Modeled after the [Mutable Dev Environment](https://github.com/pichenettes/mutable-dev-environment) and [Adafruit ARM toolchain(https://github.com/adafruit/ARM-toolchain-vagrant) Vagrant boxes.

Supported flashing methods include micro USB (for flashing when disconnected from euro power) or SWD over ST-LinkV2 (for flashing when connected to euro power) with options to preserve calibration data.

An early version of a Python toolkit for generating Via resources (wavetables, scales, patterns) is included.

Debugging is a todo.

## Requirements
Make sure you have the latest version of [Vagrant](https://www.vagrantup.com/downloads.html) and
[VirtualBox 5.x](https://www.virtualbox.org/wiki/Downloads) installed.

In addition you will need the VirtualBox extension pack to provide USB device passthrough support for flashing.  [Download the appropriate extension pack](https://www.virtualbox.org/wiki/Downloads) for your version of VirtualBox.  

On Windows double click the downloaded .vbox-extpack file to install.  You will also want to install the [STLink USB driver](http://www.st.com/web/en/catalog/tools/PF260219) if you are using the STLink programmer. (You may need to install libusb drivers with Zadig to flash on windows but not sure??)

On Linux or Mac OSX install it using the VBoxManage command by navigating to the location of the
downloaded file and running:

    VBoxManage extpack install <ext pack filename>

For example if the file is called Oracle_VM_VirtualBox_Extension_Pack-5.0.0-101573.vbox-extpack then run:

    VBoxManage extpack install Oracle_VM_VirtualBox_Extension_Pack-5.0.0-101573.vbox-extpack

Finally if you are running a Linux operating system you will want to add your user to the `vboxusers` group
so that the virtual machine can access your USB devices.  Run the following command:

    sudo usermod -a -G vboxusers $USER

Then **log out and log back in** to make sure the group change takes effect.

## Vagrant setup
To start the VM open a terminal in the directory with the Vagrantfile and run:

    vagrant up

The first time the VM is started it will download an operating system image and provision it with the ARM
toolchain. It will also download the Starling Via source and python toolkit for resource generation. This process can take a long time (~10-45) minutes depending on the speed of your internet connection and computer.
After the initial provisioning future VM startups will take just a few seconds.

Once the VM is running you can connect to it by running:

    vagrant ssh

You will now be inside the VM and ready to build, flash, and hack firmware.

When you're ready to stop the VM you can exit it by running the following command inside the VM:

    exit

Note that after you exit the VM it will still be running! This may cause issues if you try to program the module from outside the box. You can enter the VM again with the ssh command,
or you can shutdown the VM by running:

    vagrant halt

If you would ever like to completely delete the VM and start fresh you can remove it with:

    vagrant destroy

Inside the virtual machine the `/vagrant` path (the default location of the firmware repo and python tool kit) will be syncronized with the location of the Vagrantfile on your real machine.  You can copy files to and from these locations to move data between the two machines.

## Flashing tools
Our preferred firmware flashing method is STLink using SWD, becuase it allows the module to be programmed while connected to euro power. An STM32F0DISCOVERY board can be purchased for under $10 and a cable can be provisioned from 6 socket to socket breadboard cables. Pin 1 on the Via SWD header points towards the top of the module. The modules must be connected to eurorack power and powered on to flash over STLink.

You can also flash over micro USB with DFU when the module is disconnected from Eurorack power. Be sure that your micro USB cable supports data transfer. The device can only be programmed if the DFU button near the USB connector is pressed while connecting the USB to your computer. You may need to disconnect the expander side of the jumper cable.

## Firmware building
When you log into the Vagrant box, the current directory will be set the the root of the firmware repository.

From there you can build the firmware for a module with the following syntax:

    make -f MODULE_TOKEN/makefile

Replace MODULE_TOKEN with the token for the module of choice, matching the names of the folders in the firmware directory, eg:

    make -f sync3/makefile

### Recipes
The following recipes can be added to the above make command:

    make -f sync3/makefile clean
    make -f sync3/makefile upload
    make -f sync3/makefile calib
    make -f sync3/makefile upload-usb
    make -f sync3/makefile calib-usb

If you are working with a unit that has valid calibration stored in the EEPROM, its helpful to pair the upload and calib recipes, eg:

    make -f sync3/makefile upload calib 
    make -f sync3/makefile upload-usb calib-usb

```clean``` removes the firmware and library builds. The next build will reflect any chances in the source.
```upload``` builds the firmware and flashes it over StLinkV2.
```calib``` writes the option bytes over StLinkV2 to ensure that the firmware will read the stored calibration data.
```upload-usb``` builds the firmware and flashes it over StLinkV2.
```calib-usb``` writes the option bytes over StLinkV2 to ensure that the firmware will read the stored calibration data.

## Hacking resources

### Custom repository URL
If you want to build code from your own github fork, you can specify the repository to clone when you create the VM via the `USER_GITHUB_URL` environment variable, e.g.

    USER_GITHUB_URL=https://github.com/<username>/eurorack.git vagrant up

The Starling repository is automatically added as the git remote `starlingcode`.

### Python resource generators
The wavetables, scales, and patterns in the Via modules were all generated from the Python project copied into the same directory as the firmware repo (in /vagrant/wavetablegentools). You can run scripts in that directory with the system Python3 command, as all requirements were installed in provisioning.

Documentation and refactoring are sorely needed.


