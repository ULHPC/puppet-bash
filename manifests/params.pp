# File::      <tt>params.pp</tt>
# Author::    S. Varrette, H. Cartiaux, V. Plugaru, S. Diehl aka. UL HPC Management Team (hpc-sysadmins@uni.lu)
# Copyright:: Copyright (c) 2015 S. Varrette, H. Cartiaux, V. Plugaru, S. Diehl aka. UL HPC Management Team
# License::   Apache-2.0
#
# ------------------------------------------------------------------------------
# = Class: bash::params
#
# In this class are defined as variables values that are used in other
# bash classes.
# This class should be included, where necessary, and eventually be enhanced
# with support for more OS
#
# == Warnings
#
# /!\ Always respect the style guide available
# here[http://docs.puppetlabs.com/guides/style_guide]
#
# The usage of a dedicated param classe is advised to better deal with
# parametrized classes, see
# http://docs.puppetlabs.com/guides/parameterized_classes.html
#
# [Remember: No empty lines between comments and class definition]
#
class bash::params {

  ######## DEFAULTS FOR VARIABLES USERS CAN SET ##########################
  # (Here are set the defaults, provide your custom variables externally)
  # (The default used is in the line with '')
  ###########################################
  # ensure the presence (or absence) of bash configuration
  $ensure = 'present'

  # Hash of bash aliases under the form key => 'command'
  $aliases           = undef
  $dotfiles_provider = 'git'
  $dotfiles_src      = 'https://github.com/ULHPC/dotfiles.git'
  $dotfiles_revision = 'master'


  #### MODULE INTERNAL VARIABLES  #########
  # (Modify to adapt to unsupported OSes)
  #######################################
  # bash packages
  $packagename = $::operatingsystem ? {
    default => 'bash',
  }
  $extra_packages = $::operatingsystem ? {
    #/(?i-mx:ubuntu|debian)/        => [],
    #/(?i-mx:centos|fedora|redhat)/ => [],
    default => [ 'bash-completion' ]
  }

  ### Configuration directory & file
  $ref_dotfilesdir = $::operatingsystem ? {
    default => '/etc/dotfiles.d'
  }
  $dotfilesdir = $::operatingsystem ? {
    default => '.dotfiles.d'
  }
  $local_confdir_before = '.bash.before.d'
  $local_confdir        = '.bash.d'

  # Profile directory
  # $bash_completion_giturl  = "https://github.com/GArik/bash-completion.git"
  # $bash_completion_src_url = "http://bash-completion.alioth.debian.org/files/bash-completion-2.0.tar.gz"
  # $bash_completion_src_version = "2.0"


  # Configuration directory & file
  $configdir = $::operatingsystem ? {
    default => '/etc/bashrc.d',
  }
  $profile_dir = $::operatingsystem ? {
    default => '/etc/profile.d',
  }
  $completion_dir = $::operatingsystem ? {
    default => '/etc/bash_completion.d'
  }
  $skel_dir = $::operatingsystem ? {
    default => '/etc/skel'
  }
  $configdir_mode = $::operatingsystem ? {
    default => '0755',
  }
  $configdir_owner = $::operatingsystem ? {
    default => 'root',
  }
  $configdir_group = $::operatingsystem ? {
    default => 'root',
  }

  $configfile = $::osfamily ? {
    'Redhat' => '/etc/bashrc',
    default  => '/etc/bash.bashrc'
  }
  # Aliases files -- eventually user defined
  $aliases_file = $::bash_aliases_file ? {
    ''      => "${profile_dir}/bash_aliases.sh",
    default => $::bash_aliases_file
  }

  $configfile_mode = $::operatingsystem ? {
    default => '0644',
  }
  $configfile_owner = $::operatingsystem ? {
    default => 'root',
  }
  $configfile_group = $::operatingsystem ? {
    default => 'root',
  }


}
