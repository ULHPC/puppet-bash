-*- mode: markdown; mode: visual-line;  -*-

# Bash Puppet Module 

[![Puppet Forge](http://img.shields.io/puppetforge/v/ULHPC/bash.svg)](https://forge.puppetlabs.com/ULHPC/bash)
[![Puppet Forge Downloads](http://img.shields.io/puppetforge/dt/ULHPC/bash.svg)](https://forge.puppetlabs.com/ULHPC/bash)
[![License](http://img.shields.io/:license-Apache2.0-blue.svg)](LICENSE)
![Supported Platforms](http://img.shields.io/badge/platform-debian|redhat|centos-lightgrey.svg)
[![Documentation Status](https://readthedocs.org/projects/ulhpc-puppet-bash/badge/?version=latest)](https://readthedocs.org/projects/ulhpc-puppet-bash/?badge=latest)
[![By ULHPC](https://img.shields.io/badge/by-ULHPC-fb7047.svg)](http://hpc.uni.lu)

Configure and manage Bourne Again SHell (Bash) dotfiles and profiles

      Copyright (c) 2015 UL HPC Management Team <hpc-sysadmins@uni.lu>
                    aka. S. Varrette, H. Cartiaux, V. Plugaru, S. Diehl 

| [Project Page](https://github.com/ULHPC/puppet-bash) | [Sources](https://github.com/ULHPC/puppet-bash) | [Documentation](https://ulhpc-puppet-bash.readthedocs.org/en/latest/) | [Issues](https://github.com/ULHPC/puppet-bash/issues) |

## Synopsis

Configure and manage [Bourne Again SHell (Bash)](http://www.gnu.org/software/bash/) dotfiles and profile.
Bourne Again SHell ([Bash](http://www.gnu.org/software/bash/)) is the GNU Project's shell.
Bash is an sh-compatible shell that incorporates useful features from the Korn shell (ksh) and C shell (csh). It is intended to conform to the IEEE POSIX P1003.2/ISO 9945.2 Shell and Tools standard. It offers functional improvements over sh for both programming and interactive use. In addition, most sh scripts can be run by Bash without modification.

This module implements the following elements: 

* __Puppet classes__:
    - `bash` 
    - `bash::common` 
    - `bash::common::debian`: specific implementation under Debian
    - `bash::common::redhat`: specific implementation under Redhat-like system 
    - `bash::params`: module parameters

* __Puppet definitions__: 
    - `bash::setup` 

All these components are configured through a set of variables you will find in
[`manifests/params.pp`](manifests/params.pp). 

_Note_: the various operations that can be conducted from this repository are piloted from a [`Rakefile`](https://github.com/ruby/rake) and assumes you have a running [Ruby](https://www.ruby-lang.org/en/) installation.
See `docs/contributing.md` for more details on the steps you shall follow to have this `Rakefile` working properly. 

## Dependencies

See [`metadata.json`](metadata.json). In particular, this module depends on 

* [puppetlabs/stdlib](https://forge.puppetlabs.com/puppetlabs/stdlib)
* [puppetlabs/vcsrepo](https://forge.puppetlabs.com/puppetlabs/vcsrepo)

## Overview and Usage

### Class `bash`

This is the main class defined in this module.
It accepts the following parameters: 

* `$ensure`: default to 'present', can be 'absent'
* `$aliases`: Hash of key / command values to place in a aliases files
* `$aliases_file`:      configuration file where the aliases are placed.
    - _Default_: `/etc/profiles.d/bash_aliases.sh`
* `$dotfiles_provider`: Type of dotfiles provider
    - _Default_: `git`
* `$dotfiles_src`:  URL of the [Git] repository hosting the dotfiles. Note that it is expected that this dotfiles directory contains an installation script `install.sh` at the root of the repository that accept the '`--delete`' command.
	- _Default:_ <https://github.com/ULHPC/dotfiles.git>. 
* `$dotfiles_revision`: [git] branch / revision / tag to use.
    - _Default:_  `master` 

Use it as follows:

     include ' bash'

See also [`tests/init.pp`](tests/init.pp)


### Definition `bash::setup`

The definition `bash::setup` configures `.bashrc` and many other dotfiles (`.inputrc`, `.vimrc`, [`.screenrc`](https://www.gnu.org/software/screen/manual/html_node/Startup-Files.html), bash aliases etc. ) for a given user within a given home directory (hopefully **his** home directory) using specific configuration (see <https://github.com/ULHPC/dotfiles>).
To do that, it relies on an installation script named [`install.sh`](https://github.com/ULHPC/dotfiles/blob/master/install.sh) available at the root of repository that accepts also the '`--delete`' command-line option to remove / uninstall the dotfiles.

This definition accepts the following parameters:

* `$ensure`: default to 'present', can be 'absent'
* `$path`: If the title of the resource is not the homedir to consider, use the `path` parameter to precise the homedir to setup
* `$user`: User that run the setup. **BEWARE** that it **SHALL** be the owner of the home directory you're trying to setup!!!! `bash::setup` does not make extra checks to detect it so pay attention to it.
   - _Default_: `root`
* `$group`: As above but for the group operating the commands. **BEWARE** again to use the appropriate group!
   - _Default_: `root`

Example:

      include bash

      bash::setup{ '/home/vagrant':
          ensure => 'present',
          user   => 'vagrant',
          group  => 'vagrant',
      }

See also [`tests/vagrant_setup.pp`](tests/vagrant_setup.pp) or [`tests/vagrant_setup_absent.pp`](tests/vagrant_setup_absent.pp)

## Librarian-Puppet / R10K Setup

You can of course configure the bash module in your `Puppetfile` to make it available with [Librarian puppet](http://librarian-puppet.com/) or [r10k](https://github.com/adrienthebo/r10k) by adding the following entry:

     # Modules from the Puppet Forge
     mod "ULHPC/bash"

or, if you prefer to work on the git version: 

     mod "ULHPC/bash", 
         :git => 'https://github.com/ULHPC/puppet-bash',
         :ref => 'production' 

## Issues / Feature request

You can submit bug / issues / feature request using the [ULHPC/bash Puppet Module Tracker](https://github.com/ULHPC/puppet-bash/issues). 

## Developments / Contributing to the code 

If you want to contribute to the code, you shall be aware of the way this module is organized. 
These elements are detailed on `docs/contributing.md`.

You are more than welcome to contribute to its development by [sending a pull request](https://help.github.com/articles/using-pull-requests). 

## Puppet modules tests within a Vagrant box

The best way to test this module in a non-intrusive way is to rely on [Vagrant](http://www.vagrantup.com/).
The `Vagrantfile` at the root of the repository pilot the provisioning of various vagrant boxes available on [Vagrant cloud](https://atlas.hashicorp.com/boxes/search?utf8=%E2%9C%93&sort=&provider=virtualbox&q=svarrette) you can use to test this module.

See [`docs/vagrant.md`](vagrant.md) for more details. 

## Online Documentation

[Read the Docs](https://readthedocs.org/) aka RTFD hosts documentation for the open source community and the [ULHPC/bash](https://github.com/ULHPC/puppet-bash) puppet module has its documentation (see the `docs/` directory directly) hosted on [readthedocs](http://ulhpc-puppet-bash.rtfd.org).

See [`docs/rtfd.md`](rtfd.md) for more details.

## Licence

This project and the sources proposed within this repository are released under the terms of the [Apache 2.0](LICENCE) licence. 

[![Licence](https://www.apache.org/images/feather-small.gif)](LICENSE)
