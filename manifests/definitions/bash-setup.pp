# File::      <tt>bash-setup.pp</tt>
# Author::    Sebastien Varrette (<Sebastien.Varrette@uni.lu>)
# Copyright:: Copyright (c) 2011 Sebastien Varrette (www[http://varrette.gforge.uni.lu])
# License::   GPLv3
#
# ------------------------------------------------------------------------------
# = Defines: bash::setup
#
# Configure .bashrc from
#
# == Parameters:
#
# $param1 (Default: val):: description
#
# == Actions:
#
# Configure the .bashrc etc. into a given homedir using my personnal
# configuration (see https://github.com/Falkor/dotfiles).
# Actually, it not only creates the symlinks for .bashrc, .inputrc but also for
# .vimrc and .gitconfig that are provided as part of my config.
#
# In all case, a backup of the existing files is done (if they exist) via a
# renaming to <filename>.old
#
# == Requires:
#
# $homedir must be set (or $name will be consider as the basedir for installation)
#
# == Usage:
#
#     bash::setup { "/home/${user}":
#            ensure => 'present'
#            user   => "${user}",
#            group  => "${user}",
#     }
#
# == Warnings
#
# /!\ Always respect the style guide available
# here[http://docs.puppetlabs.com/guides/style_guide]
#
# [Remember: No empty lines between comments and class definition]
#
define bash::setup (
    $homedir = '',
    $ensure = 'present',
    $user   = 'root',
    $group  = 'root'
)
{
    include bash::params

    # Where to install .bashrc etc.
    $basedir = $homedir ? {
        ''      => "${name}",
        default => "${homedir}"
    }

    # Let's go
    info("configuring bash in ${basedir} for user ${user} (with ensure = ${ensure})")


    # clone my personnal configuration from github
    if ! defined( Git::Clone["${basedir}/${bash::params::dotfilesdir}"] ) {
        git::clone { "${basedir}/${bash::params::dotfilesdir}":
            path      => "${basedir}/${bash::params::dotfilesdir}",
            source    => "${bash::params::dotfiles_gitsrc}",
            ensure    => "${ensure}",
            user      => "${user}",
            group     => "${group}",
            timeout   => 15,
        }
    }


    if ($ensure == 'absent')
    {
        #obliged to split in an if..else as otherwise, file owner is checked even on 'absent'
        # remove installed components
        exec { "rm -f ${basedir}/.bashrc":
            path    => "/usr/bin:/usr/sbin:/bin",
            command => "rm -f ${basedir}/.bashrc",
            onlyif  => "test -h ${basedir}/.bashrc"
        }
        exec { "rm -f ${basedir}/.inputrc":
            path    => "/usr/bin:/usr/sbin:/bin",
            command => "rm -f ${basedir}/.inputrc",
            onlyif  => "test -h ${basedir}/.inputrc"
        }
        exec { "rm -f ${basedir}/.vimrc":
            path    => "/usr/bin:/usr/sbin:/bin",
            command => "rm -f ${basedir}/.vimrc",
            onlyif  => "test -h ${basedir}/.vimrc"
        }
        exec { "rm -f ${basedir}/.gitconfig":
            path    => "/usr/bin:/usr/sbin:/bin",
            command => "rm -f ${basedir}/.gitconfig",
            onlyif  => "test -h ${basedir}/.gitconfig"
        }

        # Restore old versions (if they exist)
        exec { "mv ${basedir}/.bashrc.old ${basedir}/.bashrc":
            path    => "/usr/bin:/usr/sbin:/bin",
            creates => "${basedir}/.bashrc",
            user    => "${user}",
            group   => "${group}",
            onlyif  => "test -f ${basedir}/.bashrc.old",
            unless  => "test -f ${basedir}/.bashrc",
            require => Exec["rm -f ${basedir}/.bashrc"]
        }
        exec { "mv ${basedir}/.bash_profile.old ${basedir}/.bash_profile":
            path    => "/usr/bin:/usr/sbin:/bin",
            creates => "${basedir}/.bash_profile",
            user    => "${user}",
            group   => "${group}",
            onlyif  => "test -f ${basedir}/.bash_profile.old",
            unless  => "test -f ${basedir}/.bash_profile",
        }
        exec { "mv ${basedir}/.inputrc.old ${basedir}/.inputrc":
            path    => "/usr/bin:/usr/sbin:/bin",
            creates => "${basedir}/.inputrc",
            user    => "${user}",
            group   => "${group}",
            onlyif  => "test -f ${basedir}/.inputrc.old",
            unless  => "test -f ${basedir}/.inputrc",
            require => Exec["rm -f ${basedir}/.inputrc"]
        }
        exec { "mv ${basedir}/.vimrc.old ${basedir}/.vimrc":
            path    => "/usr/bin:/usr/sbin:/bin",
            creates => "${basedir}/.vimrc",
            user    => "${user}",
            group   => "${group}",
            onlyif  => "test -f ${basedir}/.vimrc.old",
            unless  => "test -f ${basedir}/.vimrc",
            require => Exec["rm -f ${basedir}/.vimrc"]
        }
        exec { "mv ${basedir}/.gitconfig.old ${basedir}/.gitconfig":
            path    => "/usr/bin:/usr/sbin:/bin",
            creates => "${basedir}/.gitconfig",
            user    => "${user}",
            group   => "${group}",
            onlyif  => "test -f ${basedir}/.gitconfig.old",
            unless  => "test -f ${basedir}/.gitconfig",
            require => Exec["rm -f ${basedir}/.gitconfig"]
        }

    }
    else
    {
        # eventually backup old version
        exec { "mv ${basedir}/.bashrc ${basedir}/.bashrc.old":
            path    => "/usr/bin:/usr/sbin:/bin",
            creates => "${basedir}/.bashrc.old",
            user    => "${user}",
            group   => "${group}",
            onlyif  => "test -f ${basedir}/.bashrc",
            unless  => "test -h ${basedir}/.bashrc",
        }
        exec { "mv ${basedir}/.bash_profile ${basedir}/.bash_profile.old":
            path    => "/usr/bin:/usr/sbin:/bin",
            creates => "${basedir}/.bash_profile.old",
            user    => "${user}",
            group   => "${group}",
            onlyif  => "test -f ${basedir}/.bash_profile",
        }
        exec { "mv ${basedir}/.inputrc ${basedir}/.inputrc.old":
            path    => "/usr/bin:/usr/sbin:/bin",
            creates => "${basedir}/.inputrc.old",
            user    => "${user}",
            group   => "${group}",
            onlyif  => "test -f ${basedir}/.inputrc",
            unless  => "test -h ${basedir}/.inputrc",
        }
        exec { "mv ${basedir}/.vimrc ${basedir}/.vimrc.old":
            path    => "/usr/bin:/usr/sbin:/bin",
            creates => "${basedir}/.vimrc.old",
            user    => "${user}",
            group   => "${group}",
            onlyif  => "test -f ${basedir}/.vimrc",
            unless  => "test -h ${basedir}/.vimrc",
        }
        exec { "mv ${basedir}/.gitconfig ${basedir}/.gitconfig.old":
            path    => "/usr/bin:/usr/sbin:/bin",
            creates => "${basedir}/.gitconfig.old",
            user    => "${user}",
            group   => "${group}",
            onlyif  => "test -f ${basedir}/.gitconfig",
            unless  => "test -h ${basedir}/.gitconfig",
        }

        # symlink to my config
        file { "${basedir}/.bashrc":
            ensure  => 'link',
            target  => "${basedir}/${bash::params::dotfilesdir}/bash/.bashrc",
            require => [
                        Git::Clone["${basedir}/${bash::params::dotfilesdir}"],
                        Exec["mv ${basedir}/.bashrc ${basedir}/.bashrc.old"]
                        ],
            owner   => "${user}",
            group   => "${group}",
            replace => true,
        }

        file { "${basedir}/.inputrc":
            ensure  => 'link',
            target  => "${basedir}/${bash::params::dotfilesdir}/bash/.inputrc",
            require => [
                        Git::Clone["${basedir}/${bash::params::dotfilesdir}"],
                        Exec["mv ${basedir}/.inputrc ${basedir}/.inputrc.old"]
                        ],
            owner   => "${user}",
            group   => "${group}",
            replace => true,
        }
        file { "${basedir}/.vimrc":
            ensure  => 'link',
            target  => "${basedir}/${bash::params::dotfilesdir}/vim/.vimrc",
            require => [
                        Git::Clone["${basedir}/${bash::params::dotfilesdir}"],
                        Exec["mv ${basedir}/.vimrc ${basedir}/.vimrc.old"]
                        ],
            owner   => "${user}",
            group   => "${group}",
            replace => true,
        }
        file { "${basedir}/.gitconfig":
            ensure  => 'link',
            target  => "${basedir}/${bash::params::dotfilesdir}/git/.gitconfig",
            require => [
                        Git::Clone["${basedir}/${bash::params::dotfilesdir}"],
                        Exec["mv ${basedir}/.gitconfig ${basedir}/.gitconfig.old"]
                        ],
            owner   => "${user}",
            group   => "${group}",
            replace => true,
        }
        # # Add a ~/.bash_logout
        file { "${basedir}/.bash_logout":
            ensure  => 'file',
            replace => false,
            source  => "puppet:///modules/bash/bash_logout",
            owner   => "${user}",
            group   => "${group}",
            mode    => '0644',
        }

    }



}


