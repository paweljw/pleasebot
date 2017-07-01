# frozen_string_literal: true

require_relative './base_command'

class CommentCommand < BaseCommand
  def initialize(repository, pull_request, reviewers)
    @repository = repository
    @pull_request = pull_request
    @reviewers = reviewers
  end

  def call
    Github.instance.add_comment(@repository.full_name, @pull_request.number, comment_template)
  end

  def comment_template
    "Hey @#{author}, thanks for assigning people to this pull request!" \
    " #{reviewers} were requested to review this on your behalf.\n\n--\n" \
    ':heart:, Pleasebot'
  end

  def reviewers
    @reviewers.map { |reviewer, count| "@#{reviewer} (#{count + 1})" }.join(' and ')
  end

  def author
    @pull_request.author
  end
end
