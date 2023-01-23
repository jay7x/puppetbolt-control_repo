require 'spec_helper'

describe 'Profile::Common::Packages' do
  include_context 'clean room'

  packages = {
    rsync:  'installed',
    screen: 'purged',
  }

  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }
      let(:params) { { versions: packages } }

      context 'with default params' do
        packages.each do |pkg, ens|
          it { is_expected.to contain_package(pkg).with_ensure(ens) }
        end
      end

      context 'with ensure=>absent' do
        let(:params) { super().merge(ensure: 'absent') }

        packages.each do |pkg, _|
          it { is_expected.to contain_package(pkg).with_ensure('absent') }
        end
      end
    end
  end
end
