require 'spec_helper'

describe 'package install' do
  cached(:chef_run) do
    runner = ChefSpec::SoloRunner.new(platform: 'freebsd', version: '10.3')
    runner.converge 'nrpe::default'
  end

  it 'includes the _package_install recipe' do
    expect(chef_run).to include_recipe('nrpe::_package_install')
  end

  it 'renders the nrpe config' do
    expect(chef_run).to render_file('/usr/local/etc/nrpe.cfg').with_content('include_dir=/usr/local/etc/nrpe.d')
    expect(chef_run).to render_file('/usr/local/etc/nrpe.cfg').with_content('pid_file=/var/run/nrpe2/nrpe2.pid')
    expect(chef_run).to render_file('/usr/local/etc/nrpe.cfg').with_content('log_facility=daemon')
  end

  it 'installs the correct packages' do
    expect(chef_run).to install_package('nrpe')
  end

  it 'starts service called nrpe2' do
    expect(chef_run).to start_service('nrpe2')
  end
end
