require 'test_helper'

class AuthenticationsControllerTest < ActionController::TestCase
  describe '#authentication' do
    before { get :authentication }

    it 'responds with 200' do
      response.status.must_equal 200
    end
  end

  describe '#authenticate' do
    describe 'when right password' do
      before { post :authenticate, password: ENV['ARMA_PASSWORD'] }

      it 'creates cookie' do
        cookies[:authenticated].wont_be_nil
      end

      it 'redirects' do
        response.status.must_equal 302
      end
    end

    describe 'when wrong password' do
      before { post :authenticate, password: 'whatever' }

      it 'renders authentication template' do
        assert_template :authentication
      end
    end
  end
end