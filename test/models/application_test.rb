require 'test_helper'

class ApplicationTest < ActiveSupport::TestCase
  before do
    @application = FactoryGirl.build(:application)
  end

  [:name, :installations].each do |method|
    it "responds to #{method}" do
      @application.must_respond_to method
    end
  end

  it 'is valid' do
    @application.valid?.must_equal true
  end

  describe 'when it has no name' do
    before { @application.name = nil }

    it 'is invalid' do
      @application.invalid?.must_equal true
    end
  end

  describe 'when creating two applications with the same name' do
    let(:copy) { @application.dup }

    before do
      @application.save!
    end

    it 'raises an exception' do
      -> { copy.save! }.must_raise ActiveRecord::RecordInvalid
    end
  end
end
