class CodeChangelogsController < ApplicationController

  before_action :set_installation, only: [:index, :generate_content, :commit, :toggle_show_changelog_count]

  def index
    @changelogs = CodeChangelog::ArmaCodeChangelog.new(@installation.code_changelog_directory)
  end

  def generate_content
    redirect_to application_installation_code_changelogs_path(@installation.application_id, @installation) if params[:changelogs_ids].nil?
    code_changelog = CodeChangelog::ArmaCodeChangelog.new(@installation.code_changelog_directory, params[:changelogs_ids])
    @content = code_changelog.generate_content
    @changelogs_ids = params[:changelogs_ids]
  end

  def commit
    code_changelog = CodeChangelog::ArmaCodeChangelog.new(@installation.code_changelog_directory, params[:changelogs_ids])
    code_changelog.commit
    redirect_to application_installation_code_changelogs_path(@installation.application_id, @installation)
  end

  def toggle_show_changelog_count
    @installation.update_attributes!(show_changelog_count: !@installation.show_changelog_count)
    redirect_to application_installation_code_changelogs_path(@installation.application_id, @installation)
  end

  private
    def set_installation
      @installation = Installation.find(params[:installation_id])
    end
end