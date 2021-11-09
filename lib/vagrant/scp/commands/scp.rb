require 'pathname'

module VagrantPlugins
  module Scp
    module Command

      class Scp < Vagrant.plugin(2, :command)

        def self.synopsis
          "copies data into a box via SCP"
        end

        def execute
          @file_1, @file_2 = parse_args()
          return if @file_2.nil?

          with_target_vms(host) do |machine|
            @ssh_info = machine.ssh_info
            raise Vagrant::Errors::SSHNotReady if @ssh_info.nil?
            user_at_host = "#{@ssh_info[:username]}@#{@ssh_info[:host]}"
            if net_ssh_command == :upload!
              target = "#{user_at_host}:'#{target_files}'"
              source = "'#{source_files}'"
            else
              target = "'#{target_files}'"
              source = "#{user_at_host}:'#{source_files}'"
            end

            if @ssh_info[:proxy_command]
              proxy_command = "-o ProxyCommand='#{@ssh_info[:proxy_command]}'"
            else
              proxy_command = ''
            end

            if @ssh_info[:keys_only]
              keys_only = "-o IdentitiesOnly=yes"
            else
              keys_only = ''
            end

            command = [
              "scp",
              "-r",
              "-o StrictHostKeyChecking=no",
              "-o UserKnownHostsFile=/dev/null",
              "-o port=#{@ssh_info[:port]}",
              keys_only,
              proxy_command,
              "-i '#{@ssh_info[:private_key_path][0]}'",
              source,
              target
            ].join(' ')
            system(command)
          end
        end

        private

        def parse_args
          opts = OptionParser.new do |o|
            o.banner =  "Usage: vagrant scp <local_path> [vm_name]:<remote_path> \n"
            o.banner += "       vagrant scp [vm_name]:<remote_path> <local_path> \n"
            o.banner += "Directories will be copied recursively."
            o.separator ""
            o.separator "Options:"
            o.separator ""
          end
          argv = parse_options(opts)
          return argv if argv and  argv.length == 2
          @env.ui.info(opts.help, prefix: false) if argv
          return nil, nil
        end

        def host
          host = [@file_1, @file_2].map{|file_spec| file_spec.match(/^([^:]*):/)[1] rescue nil}.compact.first
          host = nil if (host.nil? || host == '' || host == 0 )
          host
        end

        def net_ssh_command
          @file_1.include?(':') ? :download! : :upload!
        end

        def source_files
          format_file_path(@file_1)
        end

        def target_files
          if target_location_specified?
            format_file_path(@file_2)
          else
            Pathname.new(source_files).basename
          end
        end

        def format_file_path(filepath)
          if filepath.include?(':')
            filepath.split(':').last.gsub("~", "/home/#{@ssh_info[:username]}")
          else
            filepath
          end
        end

        def target_location_specified?
          !@file_2.end_with?(':')
        end
      end

    end
  end
end
