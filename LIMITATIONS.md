# NRPE cookbook limitations

This cookbook now exposes custom resources only. The legacy recipes and node attributes have
been removed.

## Platform support

The supported platform set was modernized on 2026-05-07 using vendor package availability and
endoflife.date lifecycle data.

| Platform | Supported versions | Install method | Notes |
|----------|--------------------|----------------|-------|
| AlmaLinux | 8, 9 | Package | NRPE packages are available from EPEL 8 and EPEL 9. |
| Amazon Linux | 2023 | Source | No `nrpe` package candidate was available in the default Amazon Linux 2023 Dokken repositories during CI on 2026-05-07. |
| CentOS Stream | 9 | Package | NRPE packages are available from EPEL 9. |
| Debian | 12 | Package | `nagios-nrpe-server` is available in Debian 12. |
| Fedora | Latest | Package | Fedora packages publish `nrpe` and `nagios-plugins-nrpe`. |
| Oracle Linux | 8, 9 | Package | Uses EPEL package names. |
| Red Hat Enterprise Linux | 8, 9 | Package | Uses EPEL package names. |
| Rocky Linux | 8, 9 | Package | Uses EPEL package names. |
| Ubuntu | 22.04, 24.04 | Package | `nagios-nrpe-server` is available in Ubuntu 24.04. |

## Removed platforms

The previous cookbook declared broad support for CentOS 7, CentOS Stream 8, Debian 9-11,
Ubuntu 18.04/20.04/23.04, FreeBSD, Scientific Linux, SUSE, and openSUSE Leap 15. Those
platforms were removed from the supported/tested matrix because they are end-of-life, not
available in Dokken, or not source-verified for this migration.

openSUSE Leap 15.6 reached end of life on 2026-04-30. Leap 16 is current, but this migration
does not claim package support for it until the package and Dokken image paths are verified.

## Source install

The `nrpe` resource keeps source installation for platforms or environments where package
installation is not suitable. Source install compiles NRPE and Monitoring Plugins from
tarballs. The default Monitoring Plugins source version is `2.4.0`, the latest
non-RC tarball present in the upstream Monitoring Plugins download directory as
of May 7, 2026. Callers should pin `nrpe_version`, `nrpe_checksum`, `plugins_version`, and
`plugins_checksum` for reproducible builds.

Amazon Linux 2023 is covered through the `source` Kitchen suite because no distro `nrpe`
package candidate is present in the default repositories. Fedora package installation is
covered, but the `source` suite is not listed because NRPE 4.1.3 source compilation failed
against Fedora latest OpenSSL headers on 2026-05-07 with a missing `engine.h` include.

Source references:

* Nagios NRPE source install guide: <https://support.nagios.com/kb/article.php?id=515>
* Nagios Plugins downloads: <https://www.nagios.org/downloads/nagios-plugins/>
* Debian `nagios-nrpe-server`: <https://packages.debian.org/bookworm/nagios-nrpe-server>
* Ubuntu 24.04 `nagios-nrpe-server`: <https://launchpad.net/ubuntu/noble/+package/nagios-nrpe-server>
* Fedora/EPEL `nrpe`: <https://packages.fedoraproject.org/pkgs/nrpe/nrpe/>
* openSUSE lifecycle: <https://endoflife.date/opensuse>
