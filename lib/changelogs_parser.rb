#!/usr/bin/env ruby

# Parse changelogs from a commit message and returns a ParsedCommit, which contains the changelogs and the possible errors
#
# Details about the format of changelogs can be found here:
# https://docs.google.com/document/d/1jd1VjrWtH95RkmkzbB8qt756OUCvDzYLYPgCHXWgMwM/edit#
# In the Nagano3 Drive / Documentation / Changelogs
#
# This file should be kept in sync between Arma and Nagano:
#   arma/lib/changelogs_parser.rb
#   nagano/script/changelogs_parser.rb
#

module ChangelogsParser
  ALLOWED_ANNOTATIONS = %w(downtime none).freeze
  ALLOWED_KEYWORDS = %w(bugfix change feature improv).freeze
  ALLOWED_AFFECTED = %w(ad ces color feas invo multi plus sofa).freeze

  def self.parse_commit(full_commit_message)
    ParsedCommit.parse(full_commit_message)
  end

  class ParsedChangelog
    attr_accessor :affected, :error_messages, :full_raw_text, :keyword, :lines, :text

    def initialize
      @error_messages = []
      @lines = []
    end

    def self.parse(changelog_lines)
      self.new.parse(changelog_lines)
    end

    def parse(changelog_lines)
      raise 'Already parsed a changelog text' unless @full_raw_text.nil?
      @full_raw_text = changelog_lines.join("\n")

      keyword_and_affected, separator, text_besides_keyword_and_affected = changelog_lines.first.partition(':')

      if separator.empty?
        error_messages << "Unindented line without a ':'. The line should either be indented or start with a 'keyword:'" \
            " or 'keyword@affected:' clause. Line follows:"
        error_messages.last << "\n#{changelog_lines.first}\n"
        return self
      end

      keyword, _affected_separator, affected = keyword_and_affected.partition("@")
      keyword.strip!
      keyword.downcase!
      affected.strip!
      affected.downcase!

      if keyword.empty?
        error_messages << "Keyword is missing before the ':' or the line should be indented"
      end

      if !ALLOWED_KEYWORDS.include?(keyword.downcase)
        error_messages << "The keyword #{keyword.inspect} is invalid"
      end

      @keyword = keyword.to_sym

      if !affected.empty? && !ALLOWED_AFFECTED.include?(affected.downcase)
        error_messages << "The affected #{affected.inspect} is invalid"
      end

      @affected = affected.empty? ? nil : affected.to_sym

      changelogs_content_lines = [text_besides_keyword_and_affected] + changelog_lines[1..-1]

      if changelogs_content_lines.all?(&:empty?)
        error_messages << "The changelog has no content."
      end

      @lines = changelogs_content_lines.map(&:strip)
      @text = @lines.join("\n").strip
      self
    end
  end

  class ParsedCommit
    attr_accessor :annotations, :changelogs, :error_messages, :full_commit_message

    def initialize
      @annotations = []
      @changelogs = []
      @error_messages = []
    end

    # Returns the first error message of the ParsedCommit or the first error of a changelog
    def first_error_message
      return error_messages.first if !error_messages.empty?
      changelogs.each do |changelog|
        return changelog.error_messages.first if !changelog.error_messages.empty?
      end
      nil
    end

    def self.parse(full_commit_message)
      self.new.parse(full_commit_message)
    end

    def parse(full_commit_message)
      raise 'Already parsed a commit message' unless @full_commit_message.nil?
      @full_commit_message = full_commit_message

      _generic_text, separator, changelogs_raw_text = full_commit_message.partition("\n---")

      if separator.empty?
        error_messages << "Commit message doesn't have a line starting with ---"
        return self
      end

      annotations_line, *changelogs_raw_lines = changelogs_raw_text.split("\n", -1)
      annotations_line ||= ''

      parse_changelogs(changelogs_raw_lines)
      parse_annotations(annotations_line)

      self
    end

    def parse_annotations(annotation_line)
      annotation_line ||= ''
      annotations = annotation_line.downcase.split(/[ ,]/).map(&:strip).reject(&:empty?)

      bad_annotations = annotations.reject{|annotation| ALLOWED_ANNOTATIONS.include?(annotation)}
      @annotations = annotations.select{|annotation| ALLOWED_ANNOTATIONS.include?(annotation)}.uniq

      if !bad_annotations.empty?
        error_messages << "Commit has invalid annotation: #{annotations.join(', ')}"
      end

      if @changelogs.empty? && !@annotations.include?('none')
        error_messages << "Commit message has no changelogs, but doesn't specify the 'none' annotation"
      elsif !@changelogs.empty? && @annotations.include?('none')
        error_messages << "Commit message has changelogs, but specifies the 'none' annotation"
      end
    end

    def parse_changelogs(changelogs_raw_lines)
      # The first array is everything before the first changelog
      individual_changelogs_raw_lines = [[]]
      changelogs_raw_lines.each do |line|
        if line[/^\S/]
          individual_changelogs_raw_lines << [line]
        else
          individual_changelogs_raw_lines.last << line
        end
      end

      pre_changelogs_raw_lines = individual_changelogs_raw_lines.shift

      if pre_changelogs_raw_lines.any?{|line| !line.empty?}
        bad_lines_string = pre_changelogs_raw_lines.reject(&:empty?).join("\n")
        error_messages << "Commit message's first non-empty line after the --- is indented. Bad lines follows:\n#{bad_lines_string}\n"
      end

      @changelogs = individual_changelogs_raw_lines.map do |changelog_lines|
        ParsedChangelog.parse(changelog_lines)
      end
    end
  end
end

# commit_msgs = ARGF.read.split("\0")
# commit_msgs.each do |commit_msg|
#   p ChangelogsParser.parse_commit(commit_msg)
# end
