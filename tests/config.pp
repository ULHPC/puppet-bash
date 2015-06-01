# The baseline for module testing used by Puppet Labs is that each manifest
# should have a corresponding test manifest that declares that class or defined
# type.
#
# Tests are then run by using puppet apply --noop (to check for compilation
# errors and view a log of events) or by fully applying the test in a virtual
# environment (to compare the resulting system state to the desired state).
#
# Learn more about module testing here
#     <http://docs.puppetlabs.com/guides/tests_smoke.html>
#
#
#
# You can execute this manifest as follows in your vagrant box
#
#      sudo puppet apply -t /vagrant/tests/config.pp
#
node default {
    include bash

    bash::config{ 'modules':
        ensure  => 'present',
        warn    => true,
        content => "
# Environment Module Path
export MODULEPATH='$HOME/.local/easybuild/modules/all:/opt/apps/easybuild/modules/all:/opt/apps/default/modules/all:$HOME/privatemodules:$HOME/easybuild/modules/all'"
    }


    bash::config{ 'sysadminrc':
        ensure      => 'present',
        warn        => true,
        content     => "
# Load .sysadminrc if present
if [ -f ~/.sysadminrc ]; then 
    . ~/.sysadminrc
fi"
    }

}
