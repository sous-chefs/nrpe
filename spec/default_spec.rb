require 'spec_helper'

describe 'default installation' do
  let(:chef_run) do
    runner = ChefSpec::Runner.new(platform: 'ubuntu', version: '12.04')
    runner.converge 'nrpe::default'
  end

  it 'expects nrpe config to allow localhost polling' do
    expect(chef_run).to render_file('/etc/nagios/nrpe.cfg').with_content('allowed_hosts=127.0.0.1')
  end

end
