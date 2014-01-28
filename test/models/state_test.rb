require 'test_helper'

class StateTest < ActiveSupport::TestCase
  before do
    @state = FactoryGirl.build(:state)
  end

  [:ref, :message, :branch, :local_commits, :diff, :installation, :github_repo, :behind_by, :check_github!, :commit_date].each do |method|
    it "responds to #{method}" do
      @state.must_respond_to method
    end
  end

  it 'is valid' do
    @state.valid?.must_equal true
  end

  it 'sets the commit date' do
    @state.save!
    @state.commit_date.wont_be_nil
  end

  describe 'when it has no ref' do
    before { @state.ref = nil }

    it 'is invalid' do
      @state.invalid?.must_equal true
    end
  end
end
