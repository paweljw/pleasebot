# frozen_string_literal: true

require_relative './request_reviews_command'
require_relative './comment_command'

require_relative './../validators/pull_request_validator'

require_relative './../redis_service'
require_relative './../pull_request'
require_relative './../repository'

class PleaseCommand
  def self.call(payload)
    new(payload).call
  end

  def initialize(payload)
    @payload = payload
  end

  def call
    return unless assigned_action? && pull_request.valid?

    only_once do
      assignees = RequestReviewsCommand.call(repository, pull_request)
      CommentCommand.call(repository, pull_request, assignees)
      RedisService.instance.mark_done(pull_request)
    end
  end

  private

  def assigned_action?
    @payload['action'] == 'assigned'
  end

  def repository
    @repository ||= Repository.new(@payload['repository'])
  end

  def pull_request
    @pull_request ||= PullRequest.new(@payload['pull_request'])
  end

  def only_once(&block)
    RedisService.instance.with_lock(pull_request.id, &block)
  end
end
