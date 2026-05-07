# nrpe

Installs, configures, and starts the NRPE daemon and monitoring plugins.

## Actions

| Action | Description |
|--------|-------------|
| `:install` | Installs NRPE from packages or source. |
| `:configure` | Creates `nrpe.cfg`, the include directory, and source-install systemd unit when needed. |
| `:start` | Enables and starts the NRPE service. |
| `:remove` | Stops/disables the service and removes managed package/config artifacts. |

The default action is `[:install, :configure, :start]`.

## Properties

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| `instance_name` | String | name property | Resource instance name. |
| `install_method` | String | platform default | `package` or `source`. |
| `install_epel` | true, false | `true` | Install `epel-release` on RHEL-family package installs. |
| `package_options` | String, Array | `nil` | Options passed to package resources. |
| `packages` | Array, Hash | platform default | Packages to install. Hash values can include `version`. |
| `build_packages` | Array | platform default | Packages required for source compilation. |
| `user` | String | platform default | NRPE user. |
| `group` | String | platform default | NRPE group. |
| `home` | String | platform default | NRPE library/home path. |
| `pid_file` | String | platform default | NRPE PID file path. |
| `conf_dir` | String | platform default | NRPE config directory. |
| `bin_dir` | String | `/usr/sbin` | NRPE binary directory. |
| `plugin_dir` | String | platform default | Monitoring plugins directory. |
| `ssl_lib_dir` | String | platform default | SSL library directory used for source builds. |
| `systemd_unit_dir` | String | `/usr/lib/systemd/system` | Systemd unit directory retained for compatibility. |
| `service_name` | String | platform default | NRPE service name. |
| `allow_bash_command_substitution` | Integer, String, nil | `nil` | Optional NRPE config setting. |
| `server_port` | Integer, String | `5666` | NRPE listen port. |
| `server_address` | String, nil | `nil` | Optional bind address. |
| `command_prefix` | String, nil | `nil` | Prefix applied to commands by NRPE. |
| `log_facility` | String, nil | `nil` | Syslog facility. |
| `debug` | Integer, String | `0` | NRPE debug setting. |
| `dont_blame_nrpe` | Integer, String | `0` | Allows command arguments from the monitoring host. |
| `command_timeout` | Integer, String | `60` | Command timeout in seconds. |
| `connection_timeout` | Integer, String, nil | `nil` | Optional connection timeout. |
| `allowed_hosts` | Array | `[]` | Extra allowed hosts added to localhost and discovered hosts. |
| `server_role` | String | `monitoring` | Role used for Chef search host discovery. |
| `using_solo_search` | true, false | `false` | Enables solo-search behavior. |
| `multi_environment_monitoring` | true, false | `false` | Search all environments for monitoring hosts. |
| `nrpe_url` | String | GitHub releases URL | NRPE source release base URL. |
| `nrpe_version` | String | `4.1.3` | NRPE source version. |
| `nrpe_checksum` | String, nil | `nil` | NRPE source tarball checksum. |
| `plugins_url` | String | Monitoring Plugins URL | Monitoring Plugins source base URL. |
| `plugins_version` | String | `2.4.0` | Monitoring Plugins source version. |
| `plugins_checksum` | String, nil | `nil` | Monitoring Plugins source tarball checksum. |

## Examples

### Package install

```ruby
nrpe 'default' do
  allowed_hosts %w(192.0.2.10)
end
```

### Source install

```ruby
nrpe 'source' do
  install_method 'source'
  nrpe_version '4.1.3'
  plugins_version '2.4.0'
end
```

### Custom config

```ruby
nrpe 'default' do
  server_port 5666
  dont_blame_nrpe 1
  command_timeout 120
  allowed_hosts %w(192.0.2.10 192.0.2.11)
end
```
