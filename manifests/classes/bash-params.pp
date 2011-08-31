# File::      <tt>bash-params.pp</tt>
# Author::    Sebastien Varrette (Sebastien.Varrette@uni.lu)
# Copyright:: Copyright (c) 2011 Sebastien Varrette
# License::   GPLv3
#
# Time-stamp: <Wed 2011-08-31 13:18 svarrette>
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

    # Specify the directory in which the .bashrc should be setup.
     $version = $augeas_version ? {
        ''      => 'present',
        default => "${augeas_version}",
    }
    

    

    #### MODULE INTERNAL VARIABLES  #########
    # (Modify to adapt to unsupported OSes)
    #######################################
    $packages = $::operatingsystem ? {
        default => [ 'bash', 'bash-completion' ]
    }

    $dotfilesdir = '.dotfiles.d'
    
    # 
    $dotfiles_gitsrc = 'git://github.com/Falkor/dotfiles.git'
    
}

