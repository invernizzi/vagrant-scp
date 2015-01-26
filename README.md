# Vagrant::Scp

Copy files to a Vagrant VM via SCP.

## Installation

You need to install the plugin, like so

    vagrant plugin install vagrant-scp

## Usage

If you have just a single Vagrant VM, you can copy files over like this:

    vagrant scp <some_local_file_or_dir> <somewhere_on_the_vm>

If you have multiple VMs, you need a third parameter

    vagrant scp <some_local_file_or_dir> <somewhere_on_the_vm> <vm_name>

That’s it!
