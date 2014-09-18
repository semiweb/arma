class CodeChangelogsController < ApplicationController
  def index
    @installation = Installation.find(params[:installation_id])
    directory = File.join('doc', @installation.application.name, @installation.name, @installation.env, @installation.location == 'undefined' ? '' : @installation.location)
    @changelogs = CodeChangelog::ArmaCodeChangelog.new(directory)
  end

  def generate_content
    @installation = Installation.find(params[:installation_id])
    redirect_to application_installation_code_changelogs_path(@installation.application_id, @installation) if params[:changelogs_ids].nil?
    directory = File.join('doc', @installation.application.name, @installation.name, @installation.env, @installation.location == 'undefined' ? '' : @installation.location)
    code_changelog = CodeChangelog::ArmaCodeChangelog.new(directory, params[:changelogs_ids])
    @content = code_changelog.generate_content()
    @changelogs_ids = params[:changelogs_ids]
  end

  def commit
    @installation = Installation.find(params[:installation_id])
    directory = File.join('doc', @installation.application.name, @installation.name, @installation.env, @installation.location == 'undefined' ? '' : @installation.location)
    code_changelog = CodeChangelog::ArmaCodeChangelog.new(directory, params[:changelogs_ids])
    code_changelog.commit()
    redirect_to application_installation_code_changelogs_path(@installation.application_id, @installation)
  end

end