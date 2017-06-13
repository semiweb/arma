class ChangelogReportsController < ApplicationController

  before_action :set_application, only: [:create, :index, :edit,:update]
  before_action :set_changelog_report, only: [:update, :destroy]

  def edit
    @changelog_report = @application.changelog_reports.find(params[:id])
  end

  def create
    #default changelog report creation
    @application = Application.find(params[:application_id]) if params[:application_id].present?
    changelogs = Changelog.where(id: params[:changelogs_ids], ignored: false ) if params[:changelogs_ids].present?
    if params['last_notif'].present?
      last_reported_changelog = ChangelogReport.where(application_id:@application.id).map{|x|x.changelogs}.flatten.sort.reverse.first
      changelogs = Commit.where(application_id:@application.id).map { |x| x.changelogs.select{|x| x > last_reported_changelog && x.changelog_reports.count == 0 && !x.ignored}}.flatten
    end
    #custom changelog report creation
    if params[:SHA1].present? && params[:SHA2].present?
      border_commits = [@application.commits.find_by_ref(params[:SHA1], @application.id), @application.commits.find_by_ref(params[:SHA2],@application.id)]
      changelogs = @application.commits.has_changelogs.map{|x| x.changelogs if x.between?(border_commits.min,border_commits.max) }
    end

    if changelogs.nil? || changelogs.count < 1
      flash[:danger] = "Changelog report is empty, please select changelogs to continue"
      return  redirect_to application_commits_path(@application)
    end

    compute_message = "Report on #{Date.today.to_s} - #{@application.name}"
    changelog_reports = @application.changelog_reports.create(changelogs: changelogs.flatten.compact, name: compute_message) if @application.present?
    if changelog_reports.valid?
      flash[:success] = 'changelog report created successfully'
    else
      flash[:danger] = "Cannnot create changelog report : #{changelog_reports.errors.full_messages.join("\n")}"
    end
    redirect_to edit_application_changelog_report_path(@application,changelog_reports)
  end

  def update
    if params[:action_to].present?
      @changelog_report.update_attributes(sent: Time.now) if params[:action_to] == 'send'
      @changelog_report.update_attributes(name: params[:changelog_name]) if params[:action_to] == 'update_name'
    end
    flash[:success] = 'Changelog report successfully modified'
    redirect_to edit_application_changelog_report_path(@application,@changelog_report)
  end

  def destroy
    if @changelog_report.destroy
      flash[:success] = 'Changelog report  deleted successfully'
    else
      flash[:danger] = 'Cannot detete Changelog report'
    end
    redirect_to application_changelog_reports_path
  end

  def index
    @changelog_reports = @application.changelog_reports
  end

  private
  def set_changelog_report
    @changelog_report = ChangelogReport.find(params[:id])
  end

  def set_application
    @application = Application.find(params[:application_id])
  end

end
