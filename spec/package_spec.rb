require 'spec_helper'

describe 'package install' do
  let(:chef_run) do
    runner = ChefSpec::Runner.new(platform: 'ubuntu', version: '12.04')
    runner.converge 'nrpe::default'
  end

  it 'includes the _package_install recipe' do
    expect(chef_run).to include_recipe('nrpe::_package_install')
  end

  it 'installs the correct packages' do
    expect(chef_run).to install_package('nagios-nrpe-server')
    expect(chef_run).to install_package('nagios-plugins')
    expect(chef_run).to install_package('nagios-plugins-basic')
    expect(chef_run).to install_package('nagios-plugins-standard')
  end

end
