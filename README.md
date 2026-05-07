# nrpe cookbook

[![Cookbook Version](https://img.shields.io/cookbook/v/nrpe.svg)](https://supermarket.chef.io/cookbooks/nrpe)
[![Build Status](https://img.shields.io/circleci/project/github/sous-chefs/nrpe/master.svg)](https://circleci.com/gh/sous-chefs/nrpe)
[![OpenCollective](https://opencollective.com/sous-chefs/backers/badge.svg)](#backers)
[![OpenCollective](https://opencollective.com/sous-chefs/sponsors/badge.svg)](#sponsors)
[![License](https://img.shields.io/badge/License-Apache%202.0-green.svg)](https://opensource.org/licenses/Apache-2.0)

Chef cookbook to install Nagios NRPE client (was previously part of the Nagios cookbook)

This cookbook is a custom-resource cookbook. Legacy recipes and node attributes have been
removed; see [migration.md](migration.md) for migration examples.

## Maintainers

This cookbook is maintained by the Sous Chefs. The Sous Chefs are a community of Chef cookbook maintainers working together to maintain important cookbooks. If you’d like to know more please visit [sous-chefs.org](https://sous-chefs.org/) or come chat with us on the Chef Community Slack in [#sous-chefs](https://chefcommunity.slack.com/messages/C2V7B88SF).

## Requirements

### Chef

Chef 15.3+

### Platform

- Debian
- FreeBSD
- Ubuntu
- RHEL including CentOS and Oracle Linux
- Amazon Linux (2.x cannot be installed via package)
- Fedora
- SUSE / openSUSE

**Notes**: This cookbook has been tested on the listed platforms. It may work on other platforms with or without modification.

## Resources

- [nrpe](documentation/nrpe_nrpe.md)
- [nrpe_check](documentation/nrpe_check.md)

### nrpe

Installs NRPE from packages or source, installs plugins, renders server configuration, manages
allowed hosts, and enables/starts the service.

```ruby
nrpe 'default' do
  allowed_hosts %w(192.0.2.10)
end
```

### nrpe_check

The check resource provides an easy way to add and remove NRPE checks from within cookbooks.

#### Actions

- `:add` creates a NRPE configuration file and reloads the NRPE process. Default action.
- `:remove` removes the configuration file and reloads the NRPE process

#### Properties

- `command_name` The name of the check. This is the command that you will call from your nagios_service data bag check
- `warning_condition` String that you will pass to the command with the -w flag
- `critical_condition` String that you will pass to the command with the -c flag
- `command` The actual command to execute (including the path). If this is not specified, this will use `plugin_dir/command_name` as the path to the command.
- `parameters` Any additional parameters you wish to pass to the plugin.
- `template` Use the specific erb template to render NRPE config command.

#### Examples

```ruby
# Use resource to define check_load
nrpe_check "check_load" do
  command '/usr/lib/nagios/plugins/check_load'
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
