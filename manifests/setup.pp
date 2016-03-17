# File::      <tt>setup.pp</tt>
# Author::    S. Varrette, H. Cartiaux, V. Plugaru, S. Diehl aka. UL HPC Management Team (hpc-sysadmins@uni.lu)
# Copyright:: Copyright (c) 2011-2015 S. Varrette, H. Cartiaux, V. Plugaru, S. Diehl aka. UL HPC Management Team
# License::   Apache-2.0
#
# ------------------------------------------------------------------------------
# = Defines: bash::setup
#
# Configures .bashrc and many other dotfiles (screenrc, bash aliases etc. ) for a given user
#
# == Parameters
#
# [*ensure*]
#    Default: 'present'.
#    Ensure the presence (or absence) of setup
#
# [*path*]
#    If the title of the resource is not the homedir to consider, use path to precise the
#    homedir to setup
#
# [*user*]
#    Default: 'root'
#    User that run the setup.
#    BEWARE: it SHALL be the owner of the home directory you're trying to setup!!!!
#
# [*group*]
#    Default: 'root'
#    As above but for the group operating the commands.
#    BEWARE again to use the appropriate group!
#
# == Actions
#
#  Configure the .bashrc etc. into a given home directory using specific configuration (see https://github.com/ULHPC/dotfiles).
#  Actually, it not only creates the symlinks for .bashrc, .inputrc but also for
# .screenrc and .gitconfig that are provided as part of the config.
#
# Note that it is expected that the dotfiles directory to contains an installation
# script 'install.sh' at the root of the repository that accept the '--delete' command.
#
# == Requires
#
# $path must be set (or $name will be considered as the basedir for installation)
#
# == Usage
#
#  Configuration for /root
#
#     bash::setup { '/root': }
#
#  Configuration for the user $user
#
#     bash::setup { "/home/${user}":
#            ensure => 'present'
#            user   => "${user}",
#            group  => "${user}",
#     }
#
# === Authors
#
# The UL HPC Management team  (see http://hpc.uni.lu)
#
# == Warnings
#
# /!\ Always respect the style guide available
# here[http://docs.puppetlabs.com/guides/style_guide]
#
# [Remember: No empty lines between comments and class definition]
#
define bash::setup (
    $path   = '',
    $ensure = 'present',
    $user   = 'root',
    $group  = 'root'
)
{
    if ! ($ensure in [ 'present', 'absent' ]) {
        fail("bash::setup 'ensure' parameter must be set to either 'absent' or 'present'")
    }

    include bash::params

    if !defined(Class['bash']) {
        include 'bash'
    }

    # Where to install .bashrc etc.
    $basedir = $path ? {
        ''      => $name,
        default => $path
    }

    if ($basedir == '') {
        fail('Unable to run bash::setup in an empty directory')
    }

    # Let's go
    info("Running ${module_name}::setup in ${basedir} for user ${user} (with ensure = ${ensure})")
    $install_script = "${basedir}/${bash::params::dotfilesdir}/install.sh"

    # Set File / Exec resource defaults
    File {
        owner  => $user,
        group  => $group,
    }
    Exec {
        user  => $user,
        group => $group
    }

    if ($ensure == 'present')
    {

        file { "${basedir}/${bash::params::dotfilesdir}":
            ensure  => 'link',
            target  => $bash::ref_dotfilesdir,
            require => Vcsrepo[$bash::ref_dotfilesdir]
        }
        # Now call the install script
        exec { $install_script:
            path    => '/usr/bin:/usr/sbin:/bin:/sbin',
            command => "${install_script} --offline --dir '${basedir}/${bash::params::dotfilesdir}'",
            cwd     => $basedir,
            onlyif  => "test -x ${install_script}",
            require => File["${basedir}/${bash::params::dotfilesdir}"]
        }
    }
    else
    {
        $remove_cmd = "${install_script} --delete --dir '${basedir}/${bash::params::dotfilesdir}'"

        # Now call the install script
        exec { $remove_cmd:
            path    => '/usr/bin:/usr/sbin:/bin:/sbin',
            cwd     => $basedir,
            onlyif  => "test -x ${install_script}",
            require => Vcsrepo[$bash::ref_dotfilesdir]
        }

        file { "${basedir}/${bash::params::dotfilesdir}":
            ensure  => $ensure,
            require => Exec[$remove_cmd]
        }
    }


}
