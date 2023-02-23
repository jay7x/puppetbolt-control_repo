# frozen_string_literal: true

require 'spec_helper'

describe 'control_repo::apply' do
  let(:plan) { subject }

  it 'runs' do
    allow_apply_prep
    allow_apply
    result = run_plan(plan, { 'targets' => 'example1', 'noop' => true })

    expect(result.ok?).to be(true)
  end
end
