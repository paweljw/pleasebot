# frozen_string_literal: true

class RequestReviewsCommand
  def self.call(repository, pull_request)
    new(repository, pull_request).call
  end

  def initialize(repository, pull_request)
    @repository = repository
    @pull_request = pull_request
  end

  def call
    Github.instance.request_pull_request_review(
      @repository.full_name,
      @pull_request.number,
      random_reviewers,
      accept: 'application/vnd.github.black-cat-preview'
    )
    random_reviewers
  end

  private

  def random_reviewers
    @random_reviewers ||= @pull_request.assignees_except_author.sample(2)
  end
end
