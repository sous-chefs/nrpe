nrpe_dir = os.suse? ? '/etc/nrpe.d' : '/etc/nagios/nrpe.d'

describe file("#{nrpe_dir}/check_root_disk_space.cfg") do
  it { should exist }
  its('content') { should match %r{command\[check_root_disk_space\]=/usr/lib(64)?/nagios/plugins/check_disk -w 5% -c 1% -p} }
end
