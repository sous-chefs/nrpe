require 'spec_helper'

describe 'default installation' do
  cached(:chef_run) do
    runner = ChefSpec::SoloRunner.new(platform: 'debian', version: '7.11')
    runner.converge 'nrpe::default'
  end

  # things that shouldn't be there

  it 'expects nrpe config to not have allow_bash_command_substitution' do
    expect(chef_run).not_to render_file('/etc/nagios/nrpe.cfg').with_content('allow_bash_command_substitution=0')
  end

  it 'expects nrpe config to not have log_facility' do
    expect(chef_run).not_to render_file('/etc/nagios/nrpe.cfg').with_content('log_facility')
  end

  it 'expects nrpe config to not have command_prefix' do
    expect(chef_run).not_to render_file('/etc/nagios/nrpe.cfg').with_content('command_prefix')
  end

  it 'expects nrpe config to not have server_address' do
    expect(chef_run).not_to render_file('/etc/nagios/nrpe.cfg').with_content('server_address')
  end

  it 'expects nrpe config to not have connection_timeout' do
    expect(chef_run).not_to render_file('/etc/nagios/nrpe.cfg').with_content('connection_timeout')
  end

  # things that should be there

  it 'expects nrpe config to have nrpe_user' do
    expect(chef_run).to render_file('/etc/nagios/nrpe.cfg').with_content('nrpe_user=nagios')
  end

  it 'expects nrpe config to have nrpe_group' do
    expect(chef_run).to render_file('/etc/nagios/nrpe.cfg').with_content('nrpe_group=nagios')
  end

  it 'expects nrpe config to allow localhost polling' do
    expect(chef_run).to render_file('/etc/nagios/nrpe.cfg').with_content('allowed_hosts=127.0.0.1,::1')
  end

  it 'expects nrpe config to have dont_blame_nrpe' do
    expect(chef_run).to render_file('/etc/nagios/nrpe.cfg').with_content('dont_blame_nrpe=0')
  end

  it 'expects nrpe config to have command_timeout' do
    expect(chef_run).to render_file('/etc/nagios/nrpe.cfg').with_content('command_timeout=60')
  end

  it 'expects nrpe config to have server_port' do
    expect(chef_run).to render_file('/etc/nagios/nrpe.cfg').with_content('server_port=5666')
  end
end

describe 'default installation with attributes' do
  let(:chef_run) do
    runner = ChefSpec::SoloRunner.new(platform: 'debian', version: '7.11')
    runner.converge 'nrpe::default'
  end

  it 'expects nrpe config to have allow_bash_command_substitution when set' do
    chef_run.node.normal['nrpe']['allow_bash_command_substitution'] = 0
    chef_run.converge('nrpe::default')

    expect(chef_run).to render_file('/etc/nagios/nrpe.cfg').with_content('allow_bash_command_substitution=0')
  end

  it 'expects nrpe config to have connection_timeout when set' do
    chef_run.node.normal['nrpe']['connection_timeout'] = 20
    chef_run.converge('nrpe::default')

    expect(chef_run).to render_file('/etc/nagios/nrpe.cfg').with_content('connection_timeout=20')
  end
end
