require 'test_helper'

class InstallationsControllerTest < ActionController::TestCase
  before do
    @application = FactoryGirl.create(:application)
    @installation1 = FactoryGirl.create(:installation)
    @installation2 = FactoryGirl.create(:installation)
    @application.installations << @installation1 << @installation2
  end

  describe '#index' do
    describe 'when authenticated' do
      before do
        cookies[:authenticated] = true
        get :index, application_id: @application.id, format: 'js'
      end

      it 'responds with 200' do
        response.status.must_equal 200
      end

      it 'assigns installations' do
        assigns(:installations).must_include @installation1, @installation2
      end
    end

    describe 'when not authenticated' do
      before { get :index, application_id: @application.id, format: 'js' }

      it 'redirects' do
        response.status.must_equal 302
      end
    end
  end
end