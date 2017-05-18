# frozen_string_literal: true

require_relative './validators/pull_request_validator'

class PullRequest
  def initialize(data)
    @data = data
  end

  def assignees
    @assignees ||= @data['assignees'].map { |assignee| assignee['login'] }
  end

  def id
    @data['id']
  end

  def number
    @data['number'].to_i
  end

  def author
    @data['user']['login']
  end

  def assigned?
    assignees.count >= Pleasebot.min_assignees
  end

  def assignees_except_author
    @assignees_except_author ||= assignees - [author]
  end

  def valid?
    PullRequestValidator.valid?(self)
  end
end
