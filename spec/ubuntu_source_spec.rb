require 'spec_helper'

describe 'source install on ubuntu' do
  cached(:chef_run) do
    runner = ChefSpec::SoloRunner.new(platform: 'ubuntu')
    runner.node.override['nrpe']['install_method'] = 'source'
    runner.converge 'nrpe::default'
  end

  before do
    stub_command('which nrpe').and_return(false)
    stub_command('nrpe --version | grep 3.2.1').and_return(false)
  end

  it 'templates systemd unit file' do
    expect(chef_run).to create_template('/lib/systemd/system/nrpe.service')
  end
end
