# Vagrant enviroment for Starling Via hacking
A Vagrant box provisioned with the tools needed to build, flash, and hack Via modules. 

Modeled after the [Mutable Dev Environment](https://github.com/pichenettes/mutable-dev-environment) and [Adafruit ARM toolchain](https://github.com/adafruit/ARM-toolchain-vagrant) Vagrant boxes.

Supported flashing methods include micro USB (for flashing when disconnected from euro power) or SWD over ST-LinkV2 (for flashing when connected to euro power) with options to preserve calibration data. You are welcome to open an issue if you need support for another device.

An early version of a Python toolkit for generating Via resources (wavetables, scales, patterns) is included.

If you prefer, you can use the Eclipse setup instructions in the [main firmware repo](https://github.com/starlingcode/via_hardware_executables) to work in an IDE on your host machine.

### See the [Wiki](https://github.com/starlingcode/via-dev-environment/wiki) for installation, usage, and tutorials
