nrpe = os.debian? ? 'nagios-nrpe-server' : 'nrpe'

describe package(nrpe) do
  it { should be_installed }
end

describe service(nrpe) do
  it { should be_enabled }
  it { should be_running }
end
