module VagrantPlugins
  module Scp
    module Command

      class Scp < Vagrant.plugin(2, :command)

        def self.synopsis
          "copies data into a box via SCP"
        end

        def execute
          # Parse the arguments
          file_1, file_2 = parse_args()
          # Extract host info
          #
          # We want to get the name of the vm, from a [host_1]:file_1 [host_2]:file_2 description
          host = [file_1, file_2].map{|file_spec| file_spec.match(/^([^:]*):/)[1] rescue nil}.compact.first

          # Get the info about the target VM
          with_target_vms(host) do |machine|
            ssh_info = machine.ssh_info
            raise Vagrant::Errors::SSHNotReady if ssh_info.nil?
            if file_1.include? ':'
              source_files = "#{ssh_info[:username]}@#{ssh_info[:host]}:#{file_1.split(':').last}"
              target_files = file_2
            else
              source_files = file_1
              target_files = "#{ssh_info[:username]}@#{ssh_info[:host]}:#{file_2.split(':').last}"
            end

            # Run the SCP
            command = [
              "scp",
              '-r',
              '-o StrictHostKeyChecking=no',
              '-o UserKnownHostsFile=/dev/null',
              "-o port=#{ssh_info[:port]}",
              "-i '#{ssh_info[:private_key_path][0]}'",
                source_files,
                target_files
            ].join(' ')
            system(command)
          end
        end

        def parse_args
          opts = OptionParser.new do |o|
            o.banner = "Usage: vagrant scp <files> <target> [vm_name]"
            o.separator ""
            o.separator "Options:"
            o.separator ""
          end
          argv = parse_options(opts)
          @env.ui.info(opts.help, prefix: false) unless argv.length == 2
          return argv
        end

      end

    end
  end
end
