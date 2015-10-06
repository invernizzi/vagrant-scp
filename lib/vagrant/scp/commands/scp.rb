require 'net/scp'

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
            current_file = nil
            Net::SCP.send(
              net_ssh_command,
              @ssh_info[:host],
              @ssh_info[:username],
              source_files,
              target_files,
              :recursive => true,
              :verbose => true,
              :ssh => {
                :port => @ssh_info[:port],
                :keys => @ssh_info[:private_key_path],
                :verbose => 2}
            ) do |_, name, sent, total|
              message = "\r#{name}: #{(sent*100.0/total).round(3)}%"
              message = "\n{message}" unless current_file == name
              STDOUT.write message
              current_file = name
            end
          end
        end

        private

        def parse_args
          opts = OptionParser.new do |o|
            o.banner =  "Usage: vagrant scp <local_path> [vm_name]:<remote_path> \n"
            o.banner += "       vagrant scp [vm_name]:<remote_path> <local_path>"
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
          host = nil if (host.nil? || host == 0 )
          host
        end

        def net_ssh_command
          @file_1.include?(':') ? :download! : :upload!
        end

        def source_files
          format_file_path(@file_1)
        end

        def target_files
          format_file_path(@file_2)
        end

        def format_file_path(filepath)
          if filepath.include?(':')
            filepath.split(':').last.gsub("~", "/home/#{@ssh_info[:username]}")
          else
            filepath
          end
        end

      end

    end
  end
end
