# File::      <tt>params.pp</tt>
# Author::    S. Varrette, H. Cartiaux, V. Plugaru, S. Diehl aka. UL HPC Management Team (hpc-sysadmins@uni.lu)
# Copyright:: Copyright (c) 2015 S. Varrette, H. Cartiaux, V. Plugaru, S. Diehl aka. UL HPC Management Team
# License::   Apache-2.0
#
# ------------------------------------------------------------------------------
# You need the 'future' parser to be able to execute this manifest (that's
# required for the each loop below).
#
# Thus execute this manifest in your vagrant box as follows:
#
#      sudo puppet apply -t --parser future /vagrant/tests/params.pp
#
#

include 'bash::params'

$names = ['ensure', 'protocol', 'port', 'packagename']

notice("bash::params::ensure = ${bash::params::ensure}")
notice("bash::params::protocol = ${bash::params::protocol}")
notice("bash::params::port = ${bash::params::port}")
notice("bash::params::packagename = ${bash::params::packagename}")

#each($names) |$v| {
#    $var = "bash::params::${v}"
#    notice("${var} = ", inline_template('<%= scope.lookupvar(@var) %>'))
#}
