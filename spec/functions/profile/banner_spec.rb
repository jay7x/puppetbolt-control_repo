require 'spec_helper'

describe 'Profile::Banner' do
  it { is_expected.to run.and_return(%r{managed by puppet}i) }
end
