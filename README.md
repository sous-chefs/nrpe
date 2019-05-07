# nrpe cookbook

[![Cookbook Version](https://img.shields.io/cookbook/v/nrpe.svg)](https://supermarket.chef.io/cookbooks/nrpe)
[![Build Status](https://img.shields.io/circleci/project/github/sous-chefs/nrpe/master.svg)](https://circleci.com/gh/sous-chefs/nrpe)
[![OpenCollective](https://opencollective.com/sous-chefs/backers/badge.svg)](#backers)
[![OpenCollective](https://opencollective.com/sous-chefs/sponsors/badge.svg)](#sponsors)
[![License](https://img.shields.io/badge/License-Apache%202.0-green.svg)](https://opensource.org/licenses/Apache-2.0)

Chef cookbook to install Nagios NRPE client (was previously part of the Nagios cookbook)

## Requirements

### Chef

Chef 13+

### Platform

- Debian
- FreeBSD
- Ubuntu
- Red Hat Enterprise Linux (CentOS/Amazon/Scientific/Oracle)
- Fedora
- SUSE / openSUSE

**Notes**: This cookbook has been tested on the listed platforms. It may work on other platforms with or without modification.

### Cookbooks

- build-essential
- yum-epel

## Recipes

### default

Installs the NRPE client via packages or source depending on platform and attributes set

### configure

Configures the NRPE client. This will be called internally by the `default` recipe but can also be used to re-configure later on.

## Attributes

### platform specific attributes (auto set based on platform)

- `node['nrpe']['install_method']` - whether to install from package or source. Default chosen by platform based on known packages available for NRPE: debian/ubuntu 'package', Redhat/CentOS/Fedora/Scientific: source
- `node['nrpe']['home']` - home directory of NRPE
- `node['nrpe']['ssl_lib_dir']` - ssl directory used by NRPE
- `node['nrpe']['pid_file']` - location to store the NRPE pid file
- `node['nrpe']['conf_dir']` - location of the nrpe configuration, default /etc/nagios
- `node['nrpe']['bin_dir']` - location of the nrpe binary, default /usr/sbin
- `node['nrpe']['packages']` - nrpe / plugin packages to install. The default attribute for RHEL/Fedora platforms contains a bare minimum set of packages. The full list of available packages is available at: `http://dl.fedoraproject.org/pub/epel/6/x86_64/repoview/letter_n.group.html`
- `node['nrpe']['log_facility']` - log facility for nrpe configuration, default nil (not set)
- `node['nrpe']['plugin_dir']` - location where Monitoring plugins (aka Nagios plugins) go, default '/usr/lib/nagios/plugins'.

### options for package install

- `node['nrpe']['package']['options']` - options when installing nrpe via package manager. The default value for this attribute is nil.`
- `node['nrpe']['install_yum-epel']` - whether to install the EPEL repo or not. The default value is `true`. Set this to `false` if you do not wish to install the EPEL RPM; in this scenario you will need to make the relevant NRPE packages available via another method e.g. local repo.

### nrpe.conf attributes

- `node['nrpe']['server_port']` - the port nrpe will listen on, default 5666
- `node['nrpe']['server_address']` - the IP the nrpe server will listen on. This allows you to bind to particular IPs in situations where the system has more than one IP. This is particularly handy in determining if nrpe should bind to the internal or public IP in a cloud environment. Set the attribute to the node attribute for the cloud interface you wish to use. Defaults to nil (not enabled)
- `node['nrpe']['log_facility']` - syslog facility to log to, default nil (not set)
- `node['nrpe']['command_prefix']` - command to prefix to every nrpe command (like perhaps sudo), default nil (not set)
- `node['nrpe']['debug']` - debug level nrpe configuration, default 0
- `node['nrpe']['connection_timeout']` - connection timeout for nrpe configuration, default nil (not set)
- `node['nrpe']['dont_blame_nrpe']` - allows the server to send additional values to NRPE via arguments. this needs to be enabled for most checks to function
- `node['nrpe']['command_timeout']` - the amount of time NRPE will wait for a command to execute before timing out
- `node['nrpe']['allow_bash_command_substitution']` - allows bash command substitution in your nrpe commands - defaults to nil

### urls for source installations

- `node['nrpe']['url']` - url to retrieve NRPE source
- `node['nrpe']['version']` - version of NRPE source to download
- `node['nrpe']['checksum']` - checksum of the NRPE source tarball
- `node['nrpe']['plugins']['url']` - url to retrieve the plugins source from
- `node['nrpe']['plugins']['version']` - version of the plugins source to download
- `node['nrpe']['plugins']['checksum']` - checksum of the plugins source tarball

### authorization and server discovery

- `node['nrpe']['server_role']` - the role that the Nagios server will have in its run list that the clients can search for.
- `node['nrpe']['allowed_hosts']` - additional hosts that are allowed to connect to this client. Must be an array of strings (i.e. `%w(test.host other.host)`). These hosts are added in addition to 127.0.0.1, ::1, and IPs that are found via search.
- `node['nrpe']['using_solo_search']` - discover server information in node data_bags even with chef solo through the use of solo-search (<https://github.com/edelight/chef-solo-search>)
- `node['nrpe']['multi_environment_monitoring']` - search for nagios servers in all environments not just that of the node when building the array of allowed hosts, default 'false'

### user and group attributes

- `node['nrpe']['user']` - NRPE user, default 'nagios'.
- `node['nrpe']['group']` - NRPE group, default 'nagios'.

## Resources/Providers

### check

The check resource provides an easy way to add and remove NRPE checks from within cookbooks.

#### Actions

- `:add` creates a NRPE configuration file and reloads the NRPE process. Default action.
- `:remove` removes the configuration file and reloads the NRPE process

#### Attribute Parameters

- `command_name` The name of the check. This is the command that you will call from your nagios_service data bag check
- `warning_condition` String that you will pass to the command with the -w flag
- `critical_condition` String that you will pass to the command with the -c flag
- `command` The actual command to execute (including the path). If this is not specified, this will use `#{node['nrpe']['plugin_dir']}/command_name` as the path to the command.
- `parameters` Any additional parameters you wish to pass to the plugin.
- `template` Use the specific erb template to render NRPE config command.

#### Examples

```ruby
# Use resource to define check_load
nrpe_check "check_load" do
  command "#{node['nrpe']['plugin_dir']}/check_load"
  warning_condition '10'
  critical_condition '15'
  action :add
end
```

```ruby
# Remove the check_load definition
nrpe_check "check_load" do
  action :remove
end
```

Using template:

```ruby
nrpe_check "check_load" do
  template "check_load.cfg.erb"
  action :add
end
```

## Contributors

This project exists thanks to all the people who [contribute.](https://opencollective.com/sous-chefs/contributors.svg?width=890&button=false)

### Backers

Thank you to all our backers!

![https://opencollective.com/sous-chefs#backers](https://opencollective.com/sous-chefs/backers.svg?width=600&avatarHeight=40)

### Sponsors

Support this project by becoming a sponsor. Your logo will show up here with a link to your website.

![https://opencollective.com/sous-chefs/sponsor/0/website](https://opencollective.com/sous-chefs/sponsor/0/avatar.svg?avatarHeight=100)
![https://opencollective.com/sous-chefs/sponsor/1/website](https://opencollective.com/sous-chefs/sponsor/1/avatar.svg?avatarHeight=100)
![https://opencollective.com/sous-chefs/sponsor/2/website](https://opencollective.com/sous-chefs/sponsor/2/avatar.svg?avatarHeight=100)
![https://opencollective.com/sous-chefs/sponsor/3/website](https://opencollective.com/sous-chefs/sponsor/3/avatar.svg?avatarHeight=100)
![https://opencollective.com/sous-chefs/sponsor/4/website](https://opencollective.com/sous-chefs/sponsor/4/avatar.svg?avatarHeight=100)
![https://opencollective.com/sous-chefs/sponsor/5/website](https://opencollective.com/sous-chefs/sponsor/5/avatar.svg?avatarHeight=100)
![https://opencollective.com/sous-chefs/sponsor/6/website](https://opencollective.com/sous-chefs/sponsor/6/avatar.svg?avatarHeight=100)
![https://opencollective.com/sous-chefs/sponsor/7/website](https://opencollective.com/sous-chefs/sponsor/7/avatar.svg?avatarHeight=100)
![https://opencollective.com/sous-chefs/sponsor/8/website](https://opencollective.com/sous-chefs/sponsor/8/avatar.svg?avatarHeight=100)
![https://opencollective.com/sous-chefs/sponsor/9/website](https://opencollective.com/sous-chefs/sponsor/9/avatar.svg?avatarHeight=100)
