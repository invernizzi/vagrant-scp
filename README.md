# Vagrant::Scp

Copy files to a Vagrant VM via SCP.

## Installation

You need to install the plugin, like so

    vagrant plugin install vagrant-scp

## Usage

If you have just a single Vagrant VM, you can copy files over like this:

    vagrant scp <some_local_file_or_dir> <somewhere_on_the_vm>

If you have multiple VMs, you can specify it.

    vagrant scp <some_local_file_or_dir> <vm_name:somewhere_on_the_vm>

Copying files out of the VM works in the same fashion

    vagrant scp <vm_name:somewhere_on_the_vm> <some_local_file_or_dir>

That’s it!
