require 'test_helper'

class InstallationTest < ActiveSupport::TestCase
  before do
    @installation = FactoryGirl.build(:installation)
  end

  [:name, :location, :env, :application].each do |method|
    it "responds to #{method}" do
      @installation.must_respond_to method
    end
  end

  it 'is valid' do
    @installation.valid?.must_equal true
  end

  describe 'when it has no name' do
    before { @installation.name = nil }

    it 'is invalid' do
      @installation.invalid?.must_equal true
    end
  end
end
