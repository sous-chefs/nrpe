# frozen_string_literal: true

require 'spec_helper'
require_relative '../libraries/helpers'

describe NrpeCookbook::Helpers do
  subject(:helper) do
    Class.new do
      include NrpeCookbook::Helpers
      attr_accessor :node

      def platform?(*)
        false
      end

      def platform_family?(*families)
        families.include?(node['platform_family'])
      end

      def systemd?
        true
      end
    end.new
  end

  before do
    helper.node = {
      'platform_family' => 'debian',
      'kernel' => {
        'machine' => 'x86_64',
      },
    }
  end

  it 'returns Debian package defaults' do
    expect(helper.default_install_method).to eq('package')
    expect(helper.default_conf_dir).to eq('/etc/nagios')
    expect(helper.default_service_name('package')).to eq('nagios-nrpe-server')
  end
end
