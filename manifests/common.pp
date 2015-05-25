# File::      <tt>common.pp</tt>
# Author::    S. Varrette, H. Cartiaux, V. Plugaru, S. Diehl aka. UL HPC Management Team (hpc-sysadmins@uni.lu)
# Copyright:: Copyright (c) 2015 S. Varrette, H. Cartiaux, V. Plugaru, S. Diehl aka. UL HPC Management Team
# License::   Apache-2.0
#
# ------------------------------------------------------------------------------
# = Class: bash::common
#
# Base class to be inherited by the other bash classes, containing the common code.
#
# Note: respect the Naming standard provided here[http://projects.puppetlabs.com/projects/puppet/wiki/Module_Standards]

class bash::common {

    # Load the variables used in this module. Check the params.pp file
    require bash::params

    package { 'bash':
        name    => "${bash::params::packagename}",
        ensure  => 'present',   # You shall NEVER remove the bash package
    }

    package { $bash::params::extra_packages:
        ensure => "${bash::ensure}"
    }

    # Our PS1 prompt requires git and subversion, git being ensured through the
    # vcsrepo class call
    if !defined(Package['subversion']) {
        package { 'subversion':
            ensure => "${bash::ensure}"
        }
    }

    # Set File resource defaults
    File {
        owner  => "${bash::params::configdir_owner}",
        group  => "${bash::params::configdir_group}",
    }

    file { $bash::aliases_file:
        ensure  => "${bash::ensure}",
        mode    => "${bash::params::configfile_mode}",
        content => template("${module_name}/bash_aliases.sh.erb"),
    }

    file {
        [
         "${bash::params::profile_dir}",
         "${bash::params::skel_dir}"
         ]:
             ensure => 'directory',
             mode   => "${bash::params::configdir_mode}",
             require => Package['bash'],
    }

    file { "${bash::params::completion_dir}":
        ensure => 'directory',
        mode   => "${bash::params::configdir_mode}",
        require => Package['bash-completion'],
    }

    # Prepare the reference dotfiles directory
    vcsrepo { "${bash::ref_dotfilesdir}":
        ensure     => "${bash::ensure}",
        provider   => "${bash::dotfiles_provider}",
        source     => "${bash::dotfiles_src}",
        revision   => "${bash::dotfiles_revision}",
        user       => "${bash::params::configdir_owner}",
        group      => "${bash::params::configdir_group}",
        submodules => false
    }

    # Apply it for root user
    bash::setup { '/root':
        ensure => "${bash::ensure}",
        user   => "${bash::params::configdir_owner}",
        group  => "${bash::params::configdir_group}",
    }
}

