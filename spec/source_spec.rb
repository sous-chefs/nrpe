require 'spec_helper'

describe 'source install' do
  let(:chef_run) do
    runner = ChefSpec::Runner.new(platform: 'ubuntu', version: '12.04')
    runner.node.set['nrpe']['install_method'] = 'source'
    runner.converge 'nrpe::default'
  end

  it 'includes the nrpe source recipes' do
    expect(chef_run).to include_recipe('nrpe::_source_install')
    expect(chef_run).to include_recipe('nrpe::_source_nrpe')
    expect(chef_run).to include_recipe('nrpe::_source_plugins')
  end

  it 'includes the build-essential recipe' do
    expect(chef_run).to include_recipe('build-essential')
  end

  it 'installs the correct packages' do
    expect(chef_run).to install_package('libssl-dev')
    expect(chef_run).to install_package('make')
    expect(chef_run).to install_package('tar')
  end

  it 'creates the nrpe user' do
    expect(chef_run).to create_user(chef_run.node['nrpe']['user'])
  end

  it 'creates the nrpe group' do
    expect(chef_run).to create_group(chef_run.node['nrpe']['group'])
  end

  it 'creates config dir' do
    expect(chef_run).to create_directory(chef_run.node['nrpe']['conf_dir'])
  end

  it 'templates init script' do
    expect(chef_run).to render_file("/etc/init.d/#{chef_run.node['nrpe']['service_name']}").with_content('processname: nrpe')
  end

  it 'starts service called nrpe not nagios-nrpe-server' do
    expect(chef_run).to start_service('nrpe')
  end
end
