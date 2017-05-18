# frozen_string_literal: true

require_relative './../redis_service'

class PullRequestValidator
  def self.valid?(pull_request)
    new(pull_request).valid?
  end

  def initialize(pull_request)
    @pull_request = pull_request
  end

  def valid?
    reviewable? && not_already_requested?
  end

  private

  def reviewable?
    @pull_request.assigned? && @pull_request.assignees_except_author.count.positive?
  end

  def not_already_requested?
    !RedisService.instance.exist?(@pull_request)
  end
end
