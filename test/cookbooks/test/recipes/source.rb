# frozen_string_literal: true

apt_update 'update' if platform_family?('debian')

nrpe 'source' do
  install_method 'source'
end
