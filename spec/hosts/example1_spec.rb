require 'spec_helper'

describe 'example1' do
  let(:node) { 'example1' }

  test_on = {
    supported_os: [
      {
        'operatingsystem' => 'Ubuntu',                   # This host is expected to be Ubuntu-only
        'operatingsystemrelease' => ['20.04', '22.04'],  # Test with next Ubuntu version facts too
      },
    ],
  }

  on_supported_os(test_on).each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      it { is_expected.to compile.with_all_deps }

      it { is_expected.to contain_class('Role::Example') }

      it { is_expected.to contain_class('Profile::Common::Packages') }
      it { is_expected.to contain_class('Profile::Example') }

      it { is_expected.to contain_package('vim').with_ensure('installed') }
      it { is_expected.to contain_package('snapd').with_ensure('purged') }

      it { is_expected.to contain_file('/tmp/example.txt').with_ensure('file') }
    end
  end
end
