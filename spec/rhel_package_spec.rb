require 'spec_helper'

describe 'package install on centos 6' do
  cached(:chef_run) do
    runner = ChefSpec::SoloRunner.new(platform: 'centos')
    runner.converge 'nrpe::default'
  end

  it 'includes the _package_install recipe' do
    expect(chef_run).to include_recipe('nrpe::_package_install')
  end

  it 'includes the _package_install recipe' do
    expect(chef_run).to include_recipe('yum-epel::default')
  end

  it 'renders the nrpe config' do
    expect(chef_run).to render_file('/etc/nagios/nrpe.cfg').with_content('include_dir=/etc/nagios/nrpe.d')
    expect(chef_run).to render_file('/etc/nagios/nrpe.cfg').with_content('pid_file=/var/run/nrpe/nrpe.pid')
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
