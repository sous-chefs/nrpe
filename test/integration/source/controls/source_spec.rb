# frozen_string_literal: true

nrpe_user = os.redhat? ? 'nrpe' : 'nagios'

control 'nrpe-source-01' do
  impact 1.0
  title 'NRPE source install creates user and binary'

  describe group(nrpe_user) do
    it { should exist }
  end

  describe user(nrpe_user) do
    it { should exist }
  end

  describe file('/usr/sbin/nrpe') do
    it { should exist }
    it { should be_executable }
  end

  describe service('nrpe') do
    it { should be_enabled }
    it { should be_running }
  end
end
