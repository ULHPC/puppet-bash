# File::      <tt>config.pp</tt>
# Author::    Sebastien Varrette (<Sebastien.Varrette@uni.lu>)
# Copyright:: Copyright (c) 2015 Sebastien Varrette (www[])
# License::   GPLv3
#
# ------------------------------------------------------------------------------
# = Class: bash::config
#
# Configure a new hook part of the bash configuration.
#
# == Pre-requisites
#
# * The class 'bash' should have been instanciated
#
# == Parameters
#
# [*ensure*]
#   default to 'present', can be 'absent'.
#   Default: 'present'
#
# [*content*]
#  Specify the contents of the mydef entry as a string. Newlines, tabs,
#  and spaces can be specified using the escaped syntax (e.g., \n for a newline)
#
# [*source*]
#  Copy a file as the content of the mydef entry.
#  Uses checksum to determine when a file should be copied.
#  Valid values are either fully qualified paths to files, or URIs. Currently
#  supported URI types are puppet and file.
#  In neither the 'source' or 'content' parameter is specified, then the
#  following parameters can be used to set the console entry.
#
# [*path*]
#  Root directory where to install the hook file.
#
# [*rootdir*]
#  Specifies a root directory hosting the bash configuration file.
#  Set it to a homedir (and precise the user and group directives) to make the configuration local and
#  placed to <rootdir>/.bash.d/<title>.bash
#  Default: /etc/profile.d
#
# [*before_hook*]
#  Specifies if the bash configuration should be placed as a before hook.
#  Only valid if rootdir is set. Then the configuration file will be placed in
#  <rootdir>/.bash.before.d/<title>.bash
#  Default: false
#
#
# [*warn*]
#   Specifies whether to add a header message at the top of the destination file.
#   Valid options: the booleans 'true' and 'false', or a string to serve as the header.
#   Default: 'false'.
#
# === Sample usage
#
#     include 'bash'
#     bash::local::before { 'sysadminrc':
#         ensure  => 'present',
#         path    => '/var/lib/localadmin',
#         content => "[[ -f '~/.sysadminrc' ]] && source ~/.sysadminrc"
#     }
#
#     
#
# == Warnings
#
#    /!\ Always respect the style guide available
#    here[http://docs.puppetlabs.com/guides/style_guide]
#
#    [Remember: No empty lines between comments and class definition]
# 
define bash::config(
    $ensure         = 'present',
    $content        = '',
    $source         = '',
    $rootdir        = '',
    $before_hook    = false,
    $warn           = false,
    $owner          = 'root',
    $group          = 'root',
    $mode           = '0644'
)
{
    include bash::params

    # $name is provided at define invocation
    $filename = $name

    if ! ($ensure in [ 'present', 'absent' ]) {
        fail("bash::local::before 'ensure' parameter must be set to either 'absent' or 'present'")
    }

    if ($bash::ensure != $ensure) {
        if ($bash::ensure != 'present') {
            fail("Cannot configure a bash::local::before '${filename}' as bash::ensure is NOT set to present (but ${bash::ensure})")
        }
    }

    # if content is passed, use that, else if source is passed use that
    case $content {
        '': {
            case $source {
                '': {
                    crit('No content nor source have been  specified')
                }
                default: { $real_source = $source }
            }
        }
        default: { $real_content = $content }
    }

    $dir = $rootdir ? {
        ''      => "${bash::params::profile_dir}/",
        default => $before_hook ? {
            true    => "${rootdir}/${bash::params::local_confdir_before}/",
            default => "${rootdir}/${bash::params::local_confdir}/"
        }
    }

    if (! defined(File["${dir}"])) {
        $dir_ensure = $ensure ? {
            'present' => 'directory',
            default   => $ensure
        }
        file { "${dir}":
            ensure => $dir_ensure,
            owner  => "$owner",
            group  => "$group",
            mode   => "${bash::params::configdir_mode}"
        }
    }
    $path = "${dir}/${filename}.bash"

    concat { "${path}":
        ensure         => $ensure,
        warn           => $warn,
        owner          => $owner,
        group          => $group,
        ensure_newline => true,
        require        => File["${dir}"]
    }

    concat::fragment  { "${path}":
        target => "${path}",
        content => $real_content,
        source  => $real_source,
    }

}
