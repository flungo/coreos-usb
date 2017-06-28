# coreos-usb

Tools to create a bootable USB drive with [CoreOS](https://coreos.com/) which can be used for bare-metal installations. All tasks including cross transpiling the YAML ignition file are performed through the `Makefile` provided.

Features:
- Enables auto-login for all local terminals
- Sets the hostname to `coreos-usb` so that you can be sure you've booted into the right device.

## Pre-requisites

The `Makefile` requires and makes use of the [Container Linux Config Transpiler](https://github.com/coreos/container-linux-config-transpiler) and [coreos-install](https://github.com/coreos/init/blob/master/bin/coreos-install) script. If these are not installed and available in your path, that should be done before using this to create a coreos-usb. Alternatively, you may wish to manually specify the path to `ct` and `coreos-install` with the `CT` and `COREOS_INSTALL` variables respectively.

## Installation

To perform an installation, you will need to know which block (USB) device CoreOS should be installed onto, `lsblk` is typically a good command to determine this. If the device is `/dev/sdX`, then the following will transpile the `ignition.yml` into `ignition.json` and install onto the specified `DEVICE`:

```bash
sudo make DEVICE=/dev/sdX install
```

Once installed onto the USB device, it should be booted once (on a machine with no other CoreOS installations on any other attached disks) so that the ignition script is run. On this first boot, autologin will not work, and a restart will be required to be dropped straight into a shell. `Ctrl`+`Alt`+`Del` can be used to reboot once the login prompt is shown.

## How it works

The `Makefile` provided is fairly simple and performs two tasks: transpiling the YAML configuration and installing onto a specified block device.

### Ignition

Using ignition, the features of the install are configured by the ignition script which runs on the first boot.

In order to enable auto-login, `/usr/share/oem/grub.cfg` is modified to append the `coreos.autologin` kernel option is added to the `cmdline` using the `linux_append` variable. Due to this being a modification to the grub configuration, this will not take effect until after the first boot.
