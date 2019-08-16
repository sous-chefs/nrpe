require 'spec_helper'

describe 'source install on ubuntu 16.04' do
  cached(:chef_run) do
    runner = ChefSpec::SoloRunner.new(platform: 'ubuntu', version: '16.04')
    runner.node.normal['nrpe']['install_method'] = 'source'
    runner.converge 'nrpe::default'
  end

  before do
    stub_command('which nrpe').and_return(false)
  end

  it 'templates systemd unit file' do
    expect(chef_run).to create_template('/lib/systemd/system/nrpe.service')
  end
end
