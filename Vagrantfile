Vagrant.configure('2') do |config|
  config.omnibus.chef_version = :latest
  config.berkshelf.enabled = true
  config.chef_zero.chef_repo_path = 'test/integration'

  unless Vagrant.has_plugin?('vagrant-berkshelf')
    fail 'Vagrant Berkshelf plugin not installed.  Run: vagrant plugin install vagrant-berkshelf'
  end

  unless Vagrant.has_plugin?('vagrant-omnibus')
    fail 'Vagrant Omnibus plugin not installed.  Run: vagrant plugin install vagrant-omnibus'
  end

  unless Vagrant.has_plugin?('vagrant-chef-zero')
    fail 'Vagrant Chef Zero plugin not installed.  Run: vagrant plugin install vagrant-chef-zero'
  end
end

Vagrant::Config.run do |config|
  config.vm.provision :chef_client do |chef|
    chef.formatter = :doc
    chef.add_recipe('apt')
    chef.add_recipe('nrpe')
  end

  config.vm.define :nrpe_ubuntu_1004 do |nagios|
    nagios.vm.box = 'chef/ubuntu-10.04'
    nagios.vm.host_name = 'nrpe-ubuntu-1004'
  end

  config.vm.define :nrpe_ubuntu_1204 do |nagios|
    nagios.vm.box = 'chef/ubuntu-12.04'
    nagios.vm.host_name = 'nrpe-ubuntu-1204'
  end

  config.vm.define :nrpe_ubuntu_1404 do |nagios|
    nagios.vm.box = 'chef/ubuntu-14.04'
    nagios.vm.host_name = 'nrpe-ubuntu-1404'
  end

  config.vm.define :nrpe_debian_76 do |nagios|
    nagios.vm.box = 'chef/debian-7.6'
    nagios.vm.host_name = 'nrpe-debian-76'
  end

  config.vm.define :nrpe_freebsd_10 do |nagios|
    nagios.vm.box = 'chef/freebsd-10.0'
    nagios.vm.host_name = 'nrpe-freebsd-10'
  end

  config.vm.define :nrpe_centos_510 do |nagios|
    nagios.vm.box = 'chef/centos-5.10'
    nagios.vm.host_name = 'nrpe-510'
  end

  config.vm.define :nrpe_centos_65 do |nagios|
    nagios.vm.box = 'chef/centos-6.5'
    nagios.vm.host_name = 'nrpe-65'
  end

  config.vm.define :nrpe_centos_70 do |nagios|
    nagios.vm.box = 'chef/centos-7.0'
    nagios.vm.host_name = 'nrpe-70'
  end

  config.vm.define :nrpe_fedora_20 do |nagios|
    nagios.vm.box = 'chef/fedora-20'
    nagios.vm.host_name = 'nrpe-fedora-20'
  end
end
