require 'spec_helper_acceptance'

copy_module_to(hosts, module_name: 'production', target_module_path: '/etc/puppetlabs/code/environments')

describe 'example1' do
  it_behaves_like 'an idempotent resource' do
    let(:manifest) do
      <<-PUPPET
        include hiera_classifier
      PUPPET
    end
  end

  describe package('vim') do
    it { is_expected.to be_installed }
  end

  describe package('snapd') do
    it { is_expected.not_to be_installed }
  end

  describe file('/tmp/example.txt') do
    it { is_expected.to be_file }
  end
end
