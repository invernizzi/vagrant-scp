module VagrantPlugins
  module Scp
    module Command

      class Scp < Vagrant.plugin(2, :command)

        def self.synopsis
          "copies data into a box via SCP"
        end

        def execute
          # Parse the arguments
          source_files, target_dir, host = parse_args()
          return if target_dir.nil?

          # Get the info about the target VM
          with_target_vms(host) do |machine|
            ssh_info = machine.ssh_info
            raise Vagrant::Errors::SSHNotReady if ssh_info.nil?

            # Run the SCP
            command = [
              "scp",
              '-r',
              '-o StrictHostKeyChecking=no',
              '-o UserKnownHostsFile=/dev/null',
              "-o port=#{ssh_info[:port]}",
              "-i '#{ssh_info[:private_key_path][0]}'",
                source_files,
                "#{ssh_info[:username]}@#{ssh_info[:host]}:#{target_dir}"
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
          @env.ui.info(opts.help, prefix: false) if ! [2,3].include? argv.length
          return argv
        end

      end

    end
  end
end
