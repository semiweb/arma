require 'test_helper'

class InstallationTest < ActiveSupport::TestCase
  before do
    @installation = FactoryGirl.create(:installation, name: 'zod')
  end

  [:name, :location, :env, :application].each do |method|
    it "responds to #{method}" do
      @installation.must_respond_to method
    end
  end

  [:threaded_git_check].each do |method|
    it "the model responds to #{method}" do
      Installation.must_respond_to method
    end
  end

  it 'is valid' do
    @installation.valid?.must_equal true
  end

  describe 'when multiple installations' do
    before do
      @installation2 = FactoryGirl.create(:installation, name: 'asgalus')
    end

    it 'orders installations' do
      Installation.first.name.must_equal 'asgalus'
    end
  end

  describe 'when it has no name' do
    before { @installation.name = nil }

    it 'is invalid' do
      @installation.invalid?.must_equal true
    end
  end
end
