class GitHelper
#call this function to update commit database with new local git commits
  def self.parse_git_log(application_path,application_id, commit_SHA= '')
    require 'changelogs_parser'
    last_commit  = Commit.all.order(:commit_time).last
    if commit_SHA.present?
      commits = `cd #{application_path} && git log -z --pretty="%H%n%ai%n%an%n%B" #{commit_SHA} -n 1`.split("\u0000")
    elsif last_commit.nil?
      commits = `cd #{application_path} && git log origin -z --pretty="%H%n%ai%n%an%n%B"`.split("\u0000")
    else
      commits = `cd #{application_path} && git log  -z --pretty="%H%n%ai%n%an%n%B" #{last_commit.ref}..HEAD`.split("\u0000")
    end

    commits.each do |c|
      commit_array = c.split( /\r?\n/ ) #split by newline
      commit_message = ""

      (3..commit_array.size-1).each do |i|
        commit_message << commit_array[i].to_s << "\n"
      end

      p = ChangelogsParser.parse_commit(commit_message)

      if p.changelogs.present? || commit_SHA.present?
        new_commit = Commit.find_or_initialize_by(ref: commit_array[0])
        branch = `cd #{application_path} && git branch -r --contains #{commit_array[0]}`
        new_commit.update_attributes(commit_time: commit_array[1], full_commit_message: commit_message, application_id: application_id, branch: branch, author: commit_array[2], downtime: p::annotations.include?('downtime')   )
        Changelog.where(commit_id:new_commit.id).destroy_all
          p.changelogs.each do |c|
            if c.text.present?
              new_changelog = Changelog.new(commit_id: new_commit.id, content: c.text)
              new_changelog.keyword = c.keyword.upcase if c.keyword.present?
              new_changelog.affected = c.affected.upcase if c.affected.present?
              new_changelog.save
            end
          end
      end
    end
  end

end


