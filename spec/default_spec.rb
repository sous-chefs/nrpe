require 'spec_helper'

describe 'default installation' do
  let(:chef_run) do
    runner = ChefSpec::Runner.new(platform: 'ubuntu', version: '12.04')
    runner.converge 'nrpe::default'
  end

  it 'expects nrpe config to allow localhost polling' do
    expect(chef_run).to render_file('/etc/nagios/nrpe.cfg').with_content('allowed_hosts=127.0.0.1')
  end

  it 'expects nrpe config to not have allow_bash_command_substitution' do
    expect(chef_run).not_to render_file('/etc/nagios/nrpe.cfg').with_content('allow_bash_command_substitution=0')
  end

  it 'expects nrpe config to not have command_prefix' do
    expect(chef_run).not_to render_file('/etc/nagios/nrpe.cfg').with_content('command_prefix')
  end

  it 'expects nrpe config to not have server_address' do
    expect(chef_run).not_to render_file('/etc/nagios/nrpe.cfg').with_content('server_address')
  end

  it 'expects nrpe config to not have dont_blame_nrpe' do
    expect(chef_run).to render_file('/etc/nagios/nrpe.cfg').with_content('dont_blame_nrpe=0')
  end

  it 'expects nrpe config to have allow_bash_command_substitution when set' do
    chef_run.node.set['nrpe']['allow_bash_command_substitution'] = 0
    chef_run.converge('nrpe::default')

    expect(chef_run).to render_file('/etc/nagios/nrpe.cfg').with_content('allow_bash_command_substitution=0')
  end
end
