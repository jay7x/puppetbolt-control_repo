require 'spec_helper'

describe 'Profile::Ensure' do
  include_examples 'clean room'

  it { is_expected.to allow_values('absent', 'present') }
  it { is_expected.not_to allow_values('anything', 'else') }
end
