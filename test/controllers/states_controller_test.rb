require 'test_helper'

class StatesControllerTest < ActionController::TestCase
  before do
    @installation = FactoryGirl.create(:installation)
    @state1 = FactoryGirl.create(:state)
    @state2 = FactoryGirl.create(:state)
    @user = FactoryGirl.create(:user)
    @installation.states << @state1 << @state2
  end

  describe '#index' do
    describe 'when authenticated' do
      before do
        sign_in @user
        get :index, application_id: 12000, installation_id: @installation.id, format: 'js'
      end

      it 'responds with 200' do
        response.status.must_equal 200
      end

      it 'assigns states' do
        assigns(:states).must_include @state1, @state2
      end
    end

    describe 'when not authenticated' do
      before { get :index, application_id: 12000, installation_id: @installation.id, format: 'js' }

      it 'does not authorize' do
        response.status.must_equal 401
      end
    end
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