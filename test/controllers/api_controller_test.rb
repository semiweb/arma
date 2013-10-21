require 'test_helper'

class ApiControllerTest < ActionController::TestCase
  describe '#collect' do
    before do
      @options = options('Nagano')
      @options2 = options('Whatever').merge(installation: { location: 'location', env: 'production' })
    end

    let(:application) { Application.find_by(@options[:application]) }
    let(:installation) { application.installations.find_by(@options[:installation]) }
    let(:state) { installation.states.find_by(@options[:state]) }

    describe 'when right authorization_key' do
      describe 'when right options format' do
        before { post :collect, @options }

        it 'responds with 200' do
          response.status.must_equal 200
        end

        it 'creates the resources' do
          [application, installation, state].each do |resource|
            resource.wont_be_nil
          end
        end
      end

      describe 'when wrong option format' do
        before { post :collect, @options2 }

        it 'responds with 422' do
          response.status.must_equal 422
        end

        it 'does not create the application' do
          application.must_be_nil
        end
      end
    end

    describe 'when wrong authorization_key' do
      before { post :collect, @options.merge(authorization_key: 'whatever') }

      it 'responds with 403' do
        response.status.must_equal 403
      end

      it 'does not create the application' do
        application.must_be_nil
      end
    end
  end

  private
    def options(app_name)
      application = app_name
      options = {
        state: {
          ref:           '245edf89g544tyyu87456sdfdsfpsdfg',
          branch:        'master',
          diff:          'diff text'
        },
        application:       { name: application },
        installation:      { name: 'icm', location: 'location', env: 'production' },
        authorization_key: ENV['ARMA_AUTHORIZATION_KEY']
      }
    end
end