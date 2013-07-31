require 'test_helper'

class StatesControllerTest < ActionController::TestCase
  before do
    @installation = FactoryGirl.create(:installation)
    @state1 = FactoryGirl.create(:state)
    @user = FactoryGirl.create(:user)
  end

  describe '#diff' do
    before do
      sign_in @user
      get :diff, application_id: 12000, installation_id: @installation.id, id: @state1.id
    end

    it 'responds with 200' do
      response.status.must_equal 200
    end

    it 'assigns diff' do
      assigns(:diff).must_equal @state1.diff
    end
  end
end