require 'test_helper'

class CodeChangelogsControllerTest < ActionController::TestCase
  before do
    @application = FactoryGirl.create(:application)
    @installation = FactoryGirl.create(:installation_with_states)
    @user = FactoryGirl.create(:user)
    @application.installations << @installation

    @directory = File.join('doc', @installation.application.name, @installation.name, @installation.env, @installation.location == 'undefined' ? '' : @installation.location)
    filename_1 = '20140911212555_test_1.yml'
    filename_2 = '20140911212555_test_2.yml'
    @file1_path = File.join(@directory, filename_1)
    @file2_path = File.join(@directory, filename_2)
    FileUtils.mkdir_p(@directory)
    File.open(@file1_path, 'w') { |file| file.write("affect: all\ndescription: Test code changelog 1") }
    File.open(@file2_path, 'w') { |file| file.write("affect: all\ndescription: Test code changelog 2") }
    @code_changelog_1 = CodeChangelog::ArmaCodeChangelogEntry.create!(filename: filename_1, installation: @installation)
    @code_changelog_2 = CodeChangelog::ArmaCodeChangelogEntry.create!(filename: filename_2, installation: @installation)
  end

  after do
    File.delete(@file1_path)
    File.delete(@file2_path)
    FileUtils.rm_rf(File.join('doc', @installation.application.name))
  end

  describe '#index' do
    describe 'when authenticated' do

      before do
        sign_in @user
        get :index, application_id: 12000, installation_id: @installation.id
      end

      it 'responds with 200' do
        response.status.must_equal 200
      end

      it 'provide code changelog' do
        assigns(:changelogs).must_be_instance_of CodeChangelog::ArmaCodeChangelog
      end
    end
  end

  describe '#generate_content' do
    describe 'when no code changelogs ids' do

      before do
        sign_in @user
        post :generate_content, application_id: 12000, installation_id: @installation.id
      end

      it 'responds with 302' do
        response.status.must_equal 302
      end
    end
    describe 'when code changelogs ids' do

      before do
        sign_in @user
        post :generate_content, application_id: 12000, installation_id: @installation.id, changelogs_ids: [@code_changelog_1.id, @code_changelog_2.id]
      end

      it 'responds with 200' do
        response.status.must_equal 200
      end

      it 'provide code changelog' do
        assigns(:content).must_equal 'Test code changelog 1<br><br>Test code changelog 2<br><br>'
        assigns(:changelogs_ids).must_equal [@code_changelog_1.id.to_s, @code_changelog_2.id.to_s]
      end
    end
    describe 'when commit' do

      before do
        CodeChangelog::ArmaCodeChangelogEntry.find_by_filename('20140911212555_test_1.yml').committed.must_equal false
        CodeChangelog::ArmaCodeChangelogEntry.find_by_filename('20140911212555_test_2.yml').committed.must_equal false
        sign_in @user
        post :commit, application_id: 12000, installation_id: @installation.id, :changelogs_ids => [@code_changelog_1.id, @code_changelog_2.id]
      end

      it 'responds with 302' do
        response.status.must_equal 302
      end

      it 'committed' do
        CodeChangelog::ArmaCodeChangelogEntry.find_by_filename('20140911212555_test_1.yml').committed.must_equal true
        CodeChangelog::ArmaCodeChangelogEntry.find_by_filename('20140911212555_test_2.yml').committed.must_equal true
      end
    end
  end
end