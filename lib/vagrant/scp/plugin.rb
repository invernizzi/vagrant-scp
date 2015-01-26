module VagrantPlugins
  module Scp

    class Plugin < Vagrant.plugin('2')

      name 'vagrant-scp'

      description <<-DESC
        Copy files to vagrant boxes via scp
      DESC

      command "scp" do
        require_relative 'commands/scp.rb'
        Command::Scp
      end
    end

  end
end
