# File::      <tt>bash.pp</tt>
# Author::    Sebastien Varrette (Sebastien.Varrette@uni.lu)
# Copyright:: Copyright (c) 2011 Sebastien Varrette
# License::   GPLv3
#
# Time-stamp: <Wed 2012-08-22 15:15 svarrette>
# ------------------------------------------------------------------------------
# = Class: bash
#
# Configure and manage bash
#
# == Requires:
#
# git
#
# == Sample Usage:
#
#     import bash
#
# You can then specialize the various aspects of the configuration,
# for instance:
#
#         class { 'bash': }
#
# == Warnings
#
# /!\ Always respect the style guide available
# here[http://docs.puppetlabs.com/guides/style_guide]
#
#
# [Remember: No empty lines between comments and class definition]
#
class bash inherits bash::params
{
    info ('Configuring bash')

    case $::operatingsystem {
        debian, ubuntu:         { include bash::debian }
        redhat, fedora, centos: { include bash::redhat }
        default: {
            fail("Module ${module_name} is not supported on ${operatingsystem}")
        }
    }
}

# ------------------------------------------------------------------------------
# = Class: bash::common
#
# Base class to be inherited by the other bash classes
#
# Note: respect the Naming standard provided here[http://projects.puppetlabs.com/projects/puppet/wiki/Module_Standards]
class bash::common {

    # Load the variables used in this module. Check the ssh-server-params.pp file
    require bash::params

    package { $bash::params::packages:
        ensure  => installed,
    }

    # # Clone the bash-completion


    # git::clone { "bash-completion":
    #     basedir => "/usr/local/src",
    #     source  => "${bash::params::bash_completion_giturl}",
    #     timeout => 15
    # }




    # # # Add the puppet completion script available on the system
    # # file { "${bash::params::bash_completion_dir}/puppet":
    # #     ensure => 'file',
    # #     source => "puppet:///modules/bash/bash_completion.d/puppet"
    # # }



}


# ------------------------------------------------------------------------------
# = Class: bash::debian
#
# Specialization class for Debian systems
class bash::debian inherits bash::common {

}

# ------------------------------------------------------------------------------
# = Class: bash::redhat
#
# Specialization class for Redhat systems
class bash::redhat inherits bash::common {
    file { "${bash::params::profiledir}/git-prompt.sh":
        ensure => 'file',
        source => 'puppet:///modules/bash/git-prompt.sh',
        mode   => '0644',
    }
}



