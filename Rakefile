##############################################################################
# Rakefile - Configuration file for rake (http://rake.rubyforge.org/)
# Time-stamp: <Wed 2017-08-23 15:17 svarrette>
#
# Copyright (c) 2017  UL HPC Team <hpc-sysadmins@uni.lu>
#                       ____       _         __ _ _
#                      |  _ \ __ _| | _____ / _(_) | ___
#                      | |_) / _` | |/ / _ \ |_| | |/ _ \
#                      |  _ < (_| |   <  __/  _| | |  __/
#                      |_| \_\__,_|_|\_\___|_| |_|_|\___|
#
# Use 'rake -T' to list the available actions
#
# Resources:
# * http://www.stuartellis.eu/articles/rake/
#
# See also https://github.com/garethr/puppet-module-skeleton
##############################################################################
require 'falkorlib'
#require 'puppetlabs_spec_helper/rake_tasks'

## placeholder for custom configuration of FalkorLib.config.*
## See https://github.com/Falkor/falkorlib

# Adapt the versioning aspects
FalkorLib.config.versioning do |c|
	c[:type] = 'puppet_module'
end

# Adapt the Git flow aspects
FalkorLib.config.gitflow do |c|
	c[:branches] = {
		:master  => 'production',
		:develop => 'devel'
	}
end

require 'falkorlib/tasks/git'
require 'falkorlib/tasks/puppet'

Rake::Task['puppet:module:build'].clear

namespace :puppet do
  namespace :module do
    ###########   puppet:module:build   ###########
    desc "Build the puppet module to publish it on the Puppet Forge"
    task :build do |t|
      info(t.comment).to_s
      run %( pdk build --force)
      if File.exist?('metadata.json')
        metadata = JSON.parse( IO.read( 'metadata.json' ) )
        name    = metadata["name"]
        version = metadata["version"]
         run %( gunzip pkg/#{name}-#{version}.tar.gz)
         run %( tar --numeric-owner -rvf pkg/#{name}-#{version}.tar --transform='s,^,#{name}-#{version}/,' metadata.json)
         run %( gzip pkg/#{name}-#{version}.tar)
      end
    end # task build
  end
end

##############################################################################
#TOP_SRCDIR = File.expand_path(File.join(File.dirname(__FILE__), "."))

