# The baseline for module testing used by Puppet Labs is that each manifest
# should have a corresponding test manifest that declares that class or defined
# type.
#
# Tests are then run by using puppet apply --noop (to check for compilation
# errors and view a log of events) or by fully applying the test in a virtual
# environment (to compare the resulting system state to the desired state).
#
# Learn more about module testing here
#      <http://docs.puppetlabs.com/guides/tests_smoke.html>
#
# You can execute this manifest as follows in your vagrant box
#
#      sudo puppet apply -t /vagrant/tests/setup_vagrant_absent.pp
#
# This specific manifest remove the setup of bash operated by the ULHPC/bash module
# for the 'vagrant' user
#
node default {
    include bash

    bash::setup{ '/home/vagrant':
        ensure => 'absent',
        user   => 'vagrant',   # Ensure you are running as the owner user of the homedir
        group  => 'vagrant',
    }

}
