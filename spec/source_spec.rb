require 'spec_helper'

describe 'source install' do
  let(:chef_run) do
    runner = ChefSpec::Runner.new(platform: 'ubuntu', version: '12.04')
    runner.node.set['nrpe']['install_method'] = 'source'
    runner.converge 'nrpe::default'
  end

  it 'includes the _source_install recipe' do
    expect(chef_run).to include_recipe('nrpe::_source_install')
  end

  it 'includes the build-essential recipe' do
    expect(chef_run).to include_recipe('build-essential')
  end

  it 'installs the correct packages' do
    expect(chef_run).to install_package('libssl-dev')
    expect(chef_run).to install_package('make')
    expect(chef_run).to install_package('tar')
  end

end
