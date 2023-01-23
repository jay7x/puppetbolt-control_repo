require 'spec_helper'

describe 'Profile::Example' do
  include_context 'clean room'

  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      context 'with default params' do
        it do
          is_expected.to contain_file('/tmp/example.txt')
            .with_ensure('file')
            .with_owner('root')
            .with_group('root')
            .with_mode('0600')
            .with_content('Hello world')
        end
      end

      context 'with ensure=>absent' do
        let(:params) { { ensure: 'absent' } }

        it { is_expected.to contain_file('/tmp/example.txt').with_ensure('absent') }
      end
    end
  end
end
