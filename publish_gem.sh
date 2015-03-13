#!/bin/bash
rm *.gem
vim lib/vagrant/scp/version.rb
gem build vagrant-scp.gemspec
gem push vagrant-scp-*.gem
