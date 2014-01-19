require 'spec_helper'

describe 'nrpe::default' do

  context 'standard package install' do
    let(:chef_run) do
      runner = ChefSpec::Runner.new
      runner.converge 'nrpe::default'
    end

    it 'includes the _package_install recipe' do
      expect(chef_run).to include_recipe('nrpe::_package_install')
    end

    it 'installs nagios-nrpe-server package' do
      expect(chef_run).to install_package('nagios-nrpe-server')
    end

    it 'starts nrpe service' do
      expect(chef_run).to start_service('nagios-nrpe-server')
    end

    it 'adds addresses to the allowed hosts when defined' do
      Chef::Recipe.any_instance.stub(:search)

      chef_run = runner(
        :nrpe => { :allowed_hosts => %w(test.host) }
      ).converge 'nrpe::default'

      expect(chef_run).to render_file("#{chef_run.node['nrpe']['conf_dir']}/nrpe.cfg").with_content('allowed_hosts=127.0.0.1,test.host')
    end

    it 'does not blow up when the search returns no results' do
      Chef::REST.any_instance.stub(:get_rest).and_return('rows' => [], 'start' => 0, 'total' => 0)

      expect { chef_run }.to_not raise_error
    end
  end

  context 'source install' do
    let(:chef_run) do
      runner = ChefSpec::Runner.new
      runner.node.set['nrpe']['install_method'] = 'source'
      runner.converge 'nrpe::default'
    end

    it 'starts nrpe service' do
      expect(chef_run).to start_service('nrpe')
    end

  end

end
