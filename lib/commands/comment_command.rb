# frozen_string_literal: true

class CommentCommand
  def self.call(repository, pull_request, reviewers)
    new(repository, pull_request, reviewers).call
  end

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
    @reviewers.map { |reviewer| "@#{reviewer}" }.join(' ')
  end

  def author
    @pull_request.author
  end
end
