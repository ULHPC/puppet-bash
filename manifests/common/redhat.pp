# File::      <tt>common/redhat.pp</tt>
# Author::    S. Varrette, H. Cartiaux, V. Plugaru, S. Diehl aka. UL HPC Management Team (hpc-sysadmins@uni.lu)
# Copyright:: Copyright (c) 2015 S. Varrette, H. Cartiaux, V. Plugaru, S. Diehl aka. UL HPC Management Team
# License::   Apache-2.0
#
# ------------------------------------------------------------------------------
# = Class: bash::common::redhat
#
# Specialization class for Redhat systems
class bash::common::redhat inherits bash::common {
    # BUGFIX on __git_ps1() missing
    # ln -s /usr/share/git-core/contrib/completion/git-prompt.sh  /etc/profile.d/
    file { "${bash::params::profile_dir}/git-prompt.sh":
        ensure => 'link',
        target => '/usr/share/git-core/contrib/completion/git-prompt.sh'
    }
}
