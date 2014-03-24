# CHANGELOG for nrpe

This file is used to list changes made in each version of nrpe

## 1.0.2
* Add chefspecs
* Fix test kitchen setup on FreeBSD
* Lint fixes with Rubocop
* Nagios plugin_dir for Debian/Ubuntu was incorrect.  Should always be /usr/lib/nagios/plugins regardless of CPU arch
* Update readme to remove several references to the old Nagios cookbook

## 1.0.0:
* Initial release of the cookbook with client functionality split from the existing nagios cookbook