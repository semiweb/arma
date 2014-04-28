require 'test_helper'

class StatesControllerTest < ActionController::TestCase
  before do
    @installation = FactoryGirl.create(:installation)
    @installation_with_states = FactoryGirl.create(:installation_with_states)
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

  describe '#index' do
    before do
      sign_in @user
      get :index, application_id: 12000, installation_id: @installation_with_states.id
    end

    it 'responds with 200' do
      response.status.must_equal 200
    end

    it 'assigns installation' do
      assigns(:installation).must_equal @installation_with_states
    end

    it 'assigns states' do
      assigns(:states).must_equal @installation_with_states.states.order('created_at DESC')
    end
  end
end