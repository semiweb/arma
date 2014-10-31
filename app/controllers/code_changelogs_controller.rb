class CodeChangelogsController < ApplicationController
  def index
    @installation = Installation.find(params[:installation_id])
    @changelogs = CodeChangelog::ArmaCodeChangelog.new(@installation.code_changelog_directory)
  end

  def generate_content
    @installation = Installation.find(params[:installation_id])
    redirect_to application_installation_code_changelogs_path(@installation.application_id, @installation) if params[:changelogs_ids].nil?
    code_changelog = CodeChangelog::ArmaCodeChangelog.new(@installation.code_changelog_directory, params[:changelogs_ids])
    @content = code_changelog.generate_content
    @changelogs_ids = params[:changelogs_ids]
  end

  def commit
    @installation = Installation.find(params[:installation_id])
    code_changelog = CodeChangelog::ArmaCodeChangelog.new(@installation.code_changelog_directory, params[:changelogs_ids])
    code_changelog.commit
    redirect_to application_installation_code_changelogs_path(@installation.application_id, @installation)
  end

  def toggle_show_changelog_count
    installation = Installation.find(params[:installation_id])
    installation.update_attributes!(show_changelog_count: !installation.show_changelog_count)
    redirect_to application_installation_code_changelogs_path(installation.application_id, installation)
  end
end