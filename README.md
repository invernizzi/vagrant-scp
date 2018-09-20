# Vagrant::Scp

Copy files to a Vagrant guest via SCP.

## Installation

You need to install the plugin, like so

    vagrant plugin install vagrant-scp

## Usage

If you have just a single Vagrant guest, you can copy files over like this:

    vagrant scp <some_local_file_or_dir> <somewhere_on_the_vm>

If you have multiple VMs, you can specify it.

    vagrant scp <some_local_file_or_dir> [vm_name]:<somewhere_on_the_vm>

Copying files out of the guest works in the same fashion

    vagrant scp [vm_name]:<somewhere_on_the_vm> <some_local_file_or_dir>

If source is a directory it will be copied recursively.


## Examples

If you have just one guest, you can copy files to it like this:

    vagrant scp file_on_host.txt :file_on_vm.txt

And from the guest like this:

    vagrant scp :file_on_vm.txt file_on_host.txt

## Vagrant version
We require Vagrant v1.7 or newer. If you are running older version (check with `vagrant --version`), install recent version directly from [vendor site](https://www.vagrantup.com/).
