require 'spec_helper'

describe 'package install' do
  let(:chef_run) do
    runner = ChefSpec::Runner.new(platform: 'freebsd', version: '9.1')
    runner.converge 'nrpe::default'
  end

  it 'includes the _package_install recipe' do
    expect(chef_run).to include_recipe('nrpe::_package_install')
  end

  it 'installs the correct packages' do
    expect(chef_run).to install_package('nrpe')
  end

  it 'starts service called nrpe' do
    expect(chef_run).to start_service('nrpe2')
  end

end
