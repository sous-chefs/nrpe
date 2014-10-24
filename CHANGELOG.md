# CHANGELOG for nrpe

This file is used to list changes made in each version of nrpe

# 1.4.8
* Rubocop fixes
* Remove .DS_Store files in the supermarket file that caused failures on older versions of Berkshelf
* Remove strainer gem from Gemfile

## 1.4.6
* Update specs to Chefspec 4.1
* Add additional platforms to the Vagrantfile
* Fix a compile error / logic error when running on Fedora

## 1.4.4
* Add a chefignore file so that Berkshelf wont fail on dsstore files

## 1.4.2
* NRPE running on a Nagios server would not enable polling from other Nagios servers

## 1.4.0
* Update from nagios-plugins to monitoring-plugins in source installs since the project name changed
* Update nagios-plugins 1.5 to 2.0 for source installs
* Reorder the attributes so that FreeBSD has log_facility properly set
* Add additional specs and update specs to the latest Debian / FreeBSD releases
* Update Berkshelf to 3.1.X and update the Berksfile to the new format

## 1.3.0
* Source lsb init-functions in the init script on Ubuntu source installs so the service doesn't start every run
* Added new attribute node['nrpe']['allow_bash_command_substitution'] to allow using the allow_bash_command_substitution config option
* When searching the the monitoring role search for roles vs. role so the monitoring role can be nested on the run_list
* Sort and Unique the array of allowed monitor hosts.  This prevents NRPE from restarting on every run when the results come back in a different order
* Fix deprecated warning when running specs

## 1.2.0
* Add status / reload commands to the init script for source installs resolving issues with the service on source installs
* Add new node['nrpe']['package']['options'] attribute for adding install options to the package install
* Add Ubuntu 14.04 to the Test Kitchen config and remove Ubuntu 13.04
* Add source install suite to Test Kitchen

## 1.1.2
* Include an example base monitoring recipe with base NRPE checks defined
* Fix the LWRP example in the Readme to reflect the current state of the cookbook

## 1.1.0
* Added a server_address attribute to allow binding NRPE to the IP of a specific interface
* Added a server_port attribute to allow changing the NRPE port
* Added a command_prefix attribute to allow prefixing all commands with another command such as sudo
* Minor fixes to the readme

## 1.0.6
* Reload NRPE instead of restarting it when a new check is added
* Fix log_facility in the NRPE config to write out on its own line vs clobbering the config

## 1.0.4
* Expanded the chefspecs to multiple platforms and install methods
* Fixed a bug where the plugin dir wasn't defined for RHEL platforms causing source install failures

## 1.0.2
* Add chefspecs
* Fix test kitchen setup on FreeBSD
* Lint fixes with Rubocop
* Nagios plugin_dir for Debian/Ubuntu was incorrect.  Should always be /usr/lib/nagios/plugins regardless of CPU arch
* Update readme to remove several references to the old Nagios cookbook

## 1.0.0:
* Initial release of the cookbook with client functionality split from the existing nagios cookbook
