require 'test_helper'

class StateTest < ActiveSupport::TestCase
  before do
    @state = FactoryGirl.build(:state)
  end

  [:ref, :branch, :local_changes, :diff, :installation, :github_repo, :behind_by, :check_github!].each do |method|
    it "responds to #{method}" do
      @state.must_respond_to method
    end
  end

  it 'is valid' do
    @state.valid?.must_equal true
  end

  describe 'when it has no ref' do
    before { @state.ref = nil }

    it 'is invalid' do
      @state.invalid?.must_equal true
    end
  end
end
