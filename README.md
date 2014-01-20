chef-nrpe
=========

Chef cookbook to install Nagios NRPE client (was previously part of the Nagios cookbook)

Requirements
------------
### Chef
Chef version 0.10.10+ and Ohai 0.6.12+ are required.

### Platform
* Debian 6.X, 7.X
* Ubuntu 10.04, 12.04, 13.04
* Red Hat Enterprise Linux (CentOS/Amazon/Scientific/Oracle) 5.X, 6.X

**Notes**: This cookbook has been tested on the listed platforms. It may work on other platforms with or without modification.

### Cookbooks
* build-essential
* yum-epel (note: this requires yum cookbook v3.0, which breaks compatibility with many other cookbooks)

Recipes
-------
### default
Installs the NRPE client via packages or source depending on platform and attributes set


License & Authors
-----------------
- Author:: Joshua Sierles <joshua@37signals.com>
- Author:: Nathan Haneysmith <nathan@opscode.com>
- Author:: Joshua Timberman <joshua@opscode.com>
- Author:: Seth Chisamore <schisamo@opscode.com>
- Author:: Tim Smith <tsmith84@gmail.com>

```text
Copyright 2009, 37signals
Copyright 2009-2013, Opscode, Inc
Copyright 2012, Webtrends Inc.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
```
