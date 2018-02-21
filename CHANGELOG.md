# CHANGELOG for nrpe

This file is used to list changes made in each version of nrpe

## 2.0.3 (2018-02-18)

- Allow IPv6 localhost ::1

## 2.0.2 (2017-07-13)

- Fix broken template

## 2.0.1 (2017-07-13)

- Allow option to disable PID file as it's not needed by systemd and causes issues with SELinux at this time

## 2.0.0 (2017-03-03)

- Convert the check LWRP to a custom resource with simplified restart logic. This increases the requirement of Chef to 12.9 or later
- Add support for package installs on openSUSE Leap
- Update RHEL platforms to use the nrpe user and pid file defined in the package
- Remove logic which built node['nrpe']['checks'] as it broke on modern Chef clients
- Added Chefspec matchers for the check resource
- Use multi-package installs to speed up package installs
- Simplify the Fedora check in the attributes file
- Rework test kitchen testing and test the check resource in Travis
- Switch from testing in Rake to Delivery local mode

## 1.6.4 (2016-09-07)

- Only restart NRPE at the end of the chef-run

## 1.6.3 (2016-08-12)

- Updated cookbook to support nrpe 3.0 using source install method
- Added ability to define node['nrpe']['bin_dir'], default to /usr/sbin
- Removed duplicate line from README.md for node['nrpe']['conf_dir'] attribute

## 1.6.2 (2016-08-12)

- Fixing service reload/restart issue
- Fixing the use_inline_resources error on chef 12 client

## 1.6.0 (2016-07-21)

- Added support for openSUSE via source install
- Added chef_version to the metadata
- Updated the monitoring plugins to 2.1.2 for source installs
- Fixed user/group creation in the source recipe, which would fail chef runs
- Fixed source installs for systemd based distros by properly managing the unit file
- Resolved a scenario where the NRPE compilation could fail and never run again
- Ensured we run the NRPE process using our attribute defined user/group in the source recipe
- Ensured NRPE is compiled into /usr/sbin not /usr/bin so init / systemd files work
- Require Chef 11\. Chef 10 is end of life moving to Chef 11 allows us to remove Ruby 1.8.7 backwards compatibility
- Removed support for Fedora < 17
- Enabled caching the Chefspecs to speedup runs 3.5X
- Removed make from source installs as build-essential already handles this
- Added a Rakefile for simplified testing
- Disabled FC003 with a .foodcritic file
- Removed the Vagrantfile as we already have a Kitchen file
- Switched from Rubocop to Cookstyle and resolve all warnings
- Added yum to the Berksfile for integration testing
- Removed chef-solo-search from the Berksfile as we don't need this for testing -

## 1.5.4

- Documentation fix for pid_file attribute
- Make sure that systemd unit file matches the nrpe user attribute

## 1.5.3

- Add template support for config files
- Remove node.set in default recipe (Issue #27)

## 1.5.2

- Fedora 20+ / RHEL 7+ systems now run the daemon as nrpe/nrpe since the user installed by the package changed
- Fedora 20+ / RHEL 7+ systems now restart on check updates since the systemd scipt doesn't include a reload action
- Removed the retry count for starting the NRPE service, which didn't fix the real issue on RHEL 7+

## 1.5.0

- Added 3 retries with a delay of 3 to the nrpe service start for RHEL/CentOS 7
- Added ability to define node['nrpe']['packages'] as a Hash to add version information as sample below. In your environment specific cookbook, this version infomation for each individual package can be overriden for required versions (instead of latest one). If it is nil it will install latest one from repositories.

  Sample: default['nrpe']['packages'] = { 'nagios-nrpe-server' => {'version' => nil}, 'nagios-plugins' => {'version' => nil}, 'nagios-plugins-basic' => {'version' => nil}, 'nagios-plugins-standard' => {'version' => nil} }

  For backward compatibiility, it will also install packages if it is defined as an array in your env specific cookbook.

# 1.4.12

- Added default['nrpe']['checks'] to store all checks as a node attribute
- Removed Ruby 1.9.3 and added Ruby 2.2.0 to Travis
- Make the yum-epel recipe optional with default['nrpe']['install_yum-epel']

# 1.4.10

- Add support for CentOS / RHEL
- Update the LWRP to use the default action functionality introduced in Chef 0.10.10

# 1.4.8

- Rubocop fixes
- Remove .DS_Store files in the supermarket file that caused failures on older versions of Berkshelf
- Remove strainer gem from Gemfile

## 1.4.6

- Update specs to Chefspec 4.1
- Add additional platforms to the Vagrantfile
- Fix a compile error / logic error when running on Fedora

## 1.4.4

- Add a chefignore file so that Berkshelf wont fail on dsstore files

## 1.4.2

- NRPE running on a Nagios server would not enable polling from other Nagios servers

## 1.4.0

- Update from nagios-plugins to monitoring-plugins in source installs since the project name changed
- Update nagios-plugins 1.5 to 2.0 for source installs
- Reorder the attributes so that FreeBSD has log_facility properly set
- Add additional specs and update specs to the latest Debian / FreeBSD releases
- Update Berkshelf to 3.1.X and update the Berksfile to the new format

## 1.3.0

- Source lsb init-functions in the init script on Ubuntu source installs so the service doesn't start every run
- Added new attribute node['nrpe']['allow_bash_command_substitution'] to allow using the allow_bash_command_substitution config option
- When searching the the monitoring role search for roles vs. role so the monitoring role can be nested on the run_list
- Sort and Unique the array of allowed monitor hosts. This prevents NRPE from restarting on every run when the results come back in a different order
- Fix deprecated warning when running specs

## 1.2.0

- Add status / reload commands to the init script for source installs resolving issues with the service on source installs
- Add new node['nrpe']['package']['options'] attribute for adding install options to the package install
- Add Ubuntu 14.04 to the Test Kitchen config and remove Ubuntu 13.04
- Add source install suite to Test Kitchen

## 1.1.2

- Include an example base monitoring recipe with base NRPE checks defined
- Fix the LWRP example in the Readme to reflect the current state of the cookbook

## 1.1.0

- Added a server_address attribute to allow binding NRPE to the IP of a specific interface
- Added a server_port attribute to allow changing the NRPE port
- Added a command_prefix attribute to allow prefixing all commands with another command such as sudo
- Minor fixes to the readme

## 1.0.6

- Reload NRPE instead of restarting it when a new check is added
- Fix log_facility in the NRPE config to write out on its own line vs clobbering the config

## 1.0.4

- Expanded the chefspecs to multiple platforms and install methods
- Fixed a bug where the plugin dir wasn't defined for RHEL platforms causing source install failures

## 1.0.2

- Add chefspecs
- Fix test kitchen setup on FreeBSD
- Lint fixes with Rubocop
- Nagios plugin_dir for Debian/Ubuntu was incorrect. Should always be /usr/lib/nagios/plugins regardless of CPU arch
- Update readme to remove several references to the old Nagios cookbook

## 1.0.0:

- Initial release of the cookbook with client functionality split from the existing nagios cookbook
