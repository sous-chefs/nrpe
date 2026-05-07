# frozen_string_literal: true

nrpe = os.debian? ? 'nagios-nrpe-server' : 'nrpe'
config = os.suse? ? '/etc/nrpe.cfg' : '/etc/nagios/nrpe.cfg'

control 'nrpe-package-01' do
  impact 1.0
  title 'NRPE package is installed'

  describe package(nrpe) do
    it { should be_installed }
  end
end

control 'nrpe-service-01' do
  impact 1.0
  title 'NRPE service is enabled and running'

  describe service(nrpe) do
    it { should be_enabled }
    it { should be_running }
  end
end

control 'nrpe-config-01' do
  impact 1.0
  title 'NRPE configuration is rendered'

  describe file(config) do
    it { should exist }
    its('content') { should match(/allowed_hosts=.*192\.0\.2\.10/) }
  end
end
