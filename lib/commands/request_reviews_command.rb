# frozen_string_literal: true

require_relative './base_command'

class RequestReviewsCommand < BaseCommand
  def initialize(repository, pull_request)
    @repository = repository
    @pull_request = pull_request
  end

  def call
    Github.instance.request_pull_request_review(
      @repository.full_name,
      @pull_request.number,
      least_busy_developers.map(&:first),
      accept: 'application/vnd.github.black-cat-preview'
    )
    least_busy_developers
  end

  private

  def least_busy_developers
    @least_busy_developers ||= Github.instance.least_requested_reviewers(@pull_request.assignees_except_author, 2)
  end
end
