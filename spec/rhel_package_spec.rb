require 'spec_helper'

describe 'package install on rhel 6.7' do
  cached(:chef_run) do
    runner = ChefSpec::ServerRunner.new(platform: 'centos', version: '6.7')
    runner.converge 'nrpe::default'
  end

  it 'includes the _package_install recipe' do
    expect(chef_run).to include_recipe('nrpe::_package_install')
  end

  it 'renders the nrpe config' do
    expect(chef_run).to render_file('/etc/nagios/nrpe.cfg').with_content('include_dir=/etc/nagios/nrpe.d')
    expect(chef_run).to render_file('/etc/nagios/nrpe.cfg').with_content('pid_file=/var/run/nrpe.pid')
  end

  it 'installs the correct packages' do
    expect(chef_run).to install_package('nrpe')
    expect(chef_run).to install_package('nagios-plugins-disk')
    expect(chef_run).to install_package('nagios-plugins-load')
    expect(chef_run).to install_package('nagios-plugins-procs')
    expect(chef_run).to install_package('nagios-plugins-users')
  end

  it 'starts service called nrpe' do
    expect(chef_run).to start_service('nrpe')
  end
end

describe 'package install on rhel 7.2' do
  cached(:chef_run) do
    runner = ChefSpec::ServerRunner.new(platform: 'centos', version: '7.1.1503')
    runner.converge 'nrpe::default'
  end

  before do
    allow(File).to receive(:exist?).and_return(false)
    allow(File).to receive(:exist?).with('/usr/lib/systemd/system/nrpe.service').and_return(true)
  end

  it 'templates systemd unit file' do
    expect(chef_run).to render_file('/usr/lib/systemd/system/nrpe.service').with_content('/usr/sbin/nrpe')
  end
end
