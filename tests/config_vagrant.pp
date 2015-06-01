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
#      sudo puppet apply -t /vagrant/tests/config_vagrant.pp
#
node default {
    include bash

    Bash::Config {
        ensure  => 'absent',
        warn    => true,
        rootdir => '/home/vagrant',
        owner   => 'vagrant',
        group   => 'vagrant',
    }

    bash::config{ 'aliases':
        content => "
# Local aliases
alias cdv='cd /vagrant'
"
    }

    bash::config{ 'prompts':
        content => '
# Local aliases
export PS1="\u@\h \w>"
'
    }
    
    bash::config{ 'sysadminrc':
        before_hook => true,
        content     => "
# Load .sysadminrc if present
if [ -f ~/.sysadminrc ]; then 
    . ~/.sysadminrc
fi"
    }

}
