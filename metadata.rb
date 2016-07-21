name              'nrpe'
maintainer        'Tim Smith'
maintainer_email  'tsmith84@gmail.com'
license           'Apache 2.0'
description       'Installs and configures Nagios NRPE client'
long_description  IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version           '1.5.4'
issues_url       'https://github.com/schubergphilis/nrpe/issues' if respond_to?(:issues_url)
source_url       'https://github.com/schubergphilis/nrpe' if respond_to?(:source_url)

recipe 'default', 'Installs and configures a nrpe client'
%w(build-essential yum-epel).each do |cb|
  depends cb
end

%w(debian ubuntu redhat centos fedora scientific amazon oracle freebsd).each do |os|
  supports os
end
