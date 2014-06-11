Vagrant.configure('2') do |config|
  config.omnibus.chef_version = :latest
  config.berkshelf.enabled = true
  config.chef_zero.chef_repo_path = 'test/integration'
end

Vagrant::Config.run do |config|
  config.vm.provision :chef_client do |chef|
    chef.add_recipe('apt')
    chef.add_recipe('nrpe')
  end

  config.vm.define :nrpe_1004 do |nagios|
    nagios.vm.box = 'chef/ubuntu-10.04'
    nagios.vm.host_name = 'nrpe-1004'
  end

  config.vm.define :nrpe_1204 do |nagios|
    nagios.vm.box = 'chef/ubuntu-12.04'
    nagios.vm.host_name = 'nrpe-1204'
  end

  config.vm.define :nrpe_64 do |nagios|
    nagios.vm.box = 'chef/centos-6.5'
    nagios.vm.host_name = 'nrpe-64'
  end

  config.vm.define :nrpe_59 do |nagios|
    nagios.vm.box = 'chef/centos-5.10'
    nagios.vm.host_name = 'nrpe-59'
  end

end
