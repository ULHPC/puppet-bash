# File::      <tt>init.pp</tt>
# Author::    S. Varrette, H. Cartiaux, V. Plugaru, S. Diehl aka. UL HPC Management Team (hpc-sysadmins@uni.lu)
# Copyright:: Copyright (c) 2015 S. Varrette, H. Cartiaux, V. Plugaru, S. Diehl aka. UL HPC Management Team
# License::   Apache-2.0
#
# ------------------------------------------------------------------------------
# = Class: bash
#
# Configure and manage Bash dotfiles and profiles
#
# == Parameters:
#
# $ensure::            *Default:* 'present'. Ensure the presence (or absence) of ULHPC/bash
# $aliases::           Hash of key / command values to place in a aliases files
# $aliases_file::      *Default:* '/etc/profiles.d/bash_aliases.sh' config file where the aliases are placed.
# $dotfiles_provider:: *Default:* 'git'. Type of dotfiles provider
# $dotfiles_src::      *Default:* 'https://github.com/ULHPC/dotfiles.git'. [Git] repository URL of the dotfiles.
# $dotfiles_revision:: *Default:* 'master'. [git] branch / revision / tag to use.
#
# == Actions:
#
# Install and configure bash
#
# == Requires:
#
# n/a
#
# == Sample Usage:
#
#     include 'bash'
#
# You can then specialize the various aspects of the configuration,
# for instance:
#
#         class { 'bash':
#             ensure       => 'present',
#             dotfiles_src => 'https://github.com/Falkor/dotfiles',
#         }
#
# == Warnings
#
# /!\ Always respect the style guide available
# here[http://docs.puppetlabs.com/guides/style_guide]
#
#
# [Remember: No empty lines between comments and class definition]
#
class bash(
    $aliases            = $bash::params::aliases,
    $aliases_file       = $bash::params::aliases_file,
    $ensure             = $bash::params::ensure,
    $dotfiles_provider  = $bash::params::dotfiles_provider,
    $dotfiles_src       = $bash::params::dotfiles_src,
    $dotfiles_revision  = $bash::params::dotfiles_revision
)
inherits bash::params
{
    info ("Configuring bash (with ensure = ${ensure})")

    if ! ($ensure in [ 'present', 'absent' ]) {
        fail("bash 'ensure' parameter must be set to either 'absent' or 'present'")
    }

    case $::osfamily {
        'Debian': { include bash::common::debian }
        'Redhat': { include bash::common::redhat }
        default: {
            fail("Module ${module_name} is not supported on ${::operatingsystem}")
        }
    }
}



