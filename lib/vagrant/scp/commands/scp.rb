
module VagrantPlugins
  module Scp
    module Command

      class Scp < Vagrant.plugin(2, :command)

        def self.synopsis
          "copies data into a box via SCP"
        end

        Pathspec = Struct.new(:host, :path) do 
          def self.parse(spec)
            host, path = spec.match(/^([^:\/]*):(.*)/)[1..2] rescue nil
            host, path = nil, spec if (host.nil? || host == '' || host == 0 )
            return Pathspec.new(host, path)
          end
        end

        def execute
          pathspecs = parse_args()
          return if pathspecs.empty?

          pathspecs.map!{|s| Pathspec.parse(s)}

          @ssh_info = {}
          with_target_vms(pathspecs.map{|s| s.host}.compact) do |machine|
            raise Vagrant::Errors::SSHNotReady if machine.ssh_info.nil?
            @ssh_info[machine.name.to_s] = machine.ssh_info
          end

          command = [
              "scp", "-r", "-3",
              "-o", "StrictHostKeyChecking=no",
              "-o", "UserKnownHostsFile=/dev/null",
            ] + pathspecs.map{|s| scp_command_from_vm_pathspec(s)}.flatten
          system(*command)
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
          return argv if argv
          @env.ui.info(opts.help, prefix: false) if argv
          return []
        end

        def scp_command_from_vm_pathspec(spec)
          if spec.host and @ssh_info.has_key?(spec.host)
            ssh_info = @ssh_info[spec.host]
            command = ["-i", ssh_info[:private_key_path][0]]
            command << "-o" << "ProxyCommand=#{ssh_info[:proxy_command]}" if ssh_info[:proxy_command]
            command << "-P" << "#{ssh_info[:port]}" if ssh_info[:port]
            command << "#{ssh_info[:username]}@#{ssh_info[:host]}:#{spec.path}"
            return command
          else
            return [spec.host.nil? ? spec.path : spec.host + ':' + spec.path]
          end
        end
      end

    end
  end
end

