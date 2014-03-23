require 'spec_helper'

describe 'default installation' do
  let(:chef_run) do
    runner = ChefSpec::Runner.new(platform: 'ubuntu', version: '12.04')
    runner.converge 'nrpe::default'
  end

  it 'renders config file' do
    expect(chef_run).to render_file("#{chef_run.node['nrpe']['conf_dir']}/nrpe.cfg")
  end

  it 'creates nrpe.d directory' do
    expect(chef_run).to create_directory("#{chef_run.node['nrpe']['conf_dir']}/nrpe.d")
  end

  it 'starts nrpe service' do
    expect(chef_run).to start_service('nagios-nrpe-server')
  end

  # it 'adds addresses to the allowed hosts when defined' do

  #   chef_run = runner(
  #     :nrpe => { :allowed_hosts => %w(test.host) }
  #   ).converge 'nrpe::default'

  #   expect(chef_run).to render_file("#{chef_run.node['nrpe']['conf_dir']}/nrpe.cfg").with_content('allowed_hosts=127.0.0.1,test.host')
  # end

  it 'does not blow up when the search returns no results' do
    stub_search(:role, 'monitoring').and_return([])
    expect { chef_run }.to_not raise_error
  end

end
