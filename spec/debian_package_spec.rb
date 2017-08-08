require 'spec_helper'

describe 'package install' do
  cached(:chef_run) do
    runner = ChefSpec::SoloRunner.new(platform: 'debian', version: '7.11')
    runner.converge 'nrpe::default'
  end

  it 'includes the _package_install recipe' do
    expect(chef_run).to include_recipe('nrpe::_package_install')
  end

  it 'renders the nrpe config' do
    expect(chef_run).to render_file('/etc/nagios/nrpe.cfg').with_content('include_dir=/etc/nagios/')
    expect(chef_run).to render_file('/etc/nagios/nrpe.cfg').with_content('pid_file=/var/run/nagios/nrpe.pid')
  end

  it 'creates nrpe.d directory' do
    expect(chef_run).to create_directory('/etc/nagios/nrpe.d')
  end

  it 'starts nrpe service' do
    expect(chef_run).to start_service('nagios-nrpe-server')
  end

  it 'installs the correct packages' do
    expect(chef_run).to install_package('nagios-nrpe-server')
    expect(chef_run).to install_package('nagios-plugins')
    expect(chef_run).to install_package('nagios-plugins-basic')
    expect(chef_run).to install_package('nagios-plugins-standard')
  end
end
