# nrpe_check

Creates or removes individual NRPE check command files.

## Actions

| Action | Description |
|--------|-------------|
| `:add` | Creates the check config file. |
| `:remove` | Deletes the check config file. |

The default action is `:add`.

## Properties

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| `command_name` | String | name property | Check command name and config filename. |
| `warning_condition` | Integer, String | `nil` | Value passed with `-w`. |
| `critical_condition` | Integer, String | `nil` | Value passed with `-c`. |
| `command` | String | `nil` | Full command path. Defaults to `plugin_dir/command_name`. |
| `parameters` | String | `nil` | Extra command parameters. |
| `template` | String | `nil` | ERB template for custom command content. Cannot be used with `command`. |
| `conf_dir` | String | platform default | NRPE config directory. |
| `plugin_dir` | String | platform default | Monitoring plugins directory. |
| `service_name` | String | platform default | Service to notify. |
| `check_action` | Symbol | platform default | Notification action, `:reload` or `:restart`. |

## Examples

### Add a check

```ruby
nrpe_check 'check_root_disk_space' do
  command '/usr/lib/nagios/plugins/check_disk'
  warning_condition '5%'
  critical_condition '1%'
  parameters '-p /'
end
```

### Remove a check

```ruby
nrpe_check 'check_root_disk_space' do
  action :remove
end
```

### Render from a template

```ruby
nrpe_check 'check_load' do
  template 'check_load.cfg.erb'
end
```
