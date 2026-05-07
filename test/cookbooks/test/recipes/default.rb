# frozen_string_literal: true

apt_update 'update' if platform_family?('debian')

nrpe 'default' do
  allowed_hosts %w(192.0.2.10)
end
