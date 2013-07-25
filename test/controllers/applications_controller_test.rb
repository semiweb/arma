require 'test_helper'

class ApplicationsControllerTest < ActionController::TestCase
  before do
    2.times { FactoryGirl.create(:application) }
  end

  describe '#index' do
    describe 'when authenticated' do
      before do
        cookies[:authenticated] = true
        get :index
      end

      it 'responds with 200' do
        response.status.must_equal 200
      end

      it 'assigns existing applications' do
        assigns(:applications).must_equal Application.all
      end
    end

    describe 'when not authenticated' do
      before { get :index }

      it 'redirects' do
        response.status.must_equal 302
      end
    end
  end
end